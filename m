Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab2LUS1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 13:27:06 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:32769 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2LUS07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 13:26:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121221105126.GD17357@quack.suse.cz>
References: <cover.1356043686.git.luto@amacapital.net> <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221001457.GY15182@dastard> <CALCETrXT2uYwuYR3402LUO2uw3d++=f9vxtFLq8Ez62VdAgOcw@mail.gmail.com>
 <20121221105126.GD17357@quack.suse.cz>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 21 Dec 2012 10:26:37 -0800
Message-ID: <CALCETrX3uSkASU-aw5HF9mNtzVr4HsXt-2a97wzDfc9sDwp8Qw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 2:51 AM, Jan Kara <jack@suse.cz> wrote:
> On Thu 20-12-12 21:36:58, Andy Lutomirski wrote:
>> On Thu, Dec 20, 2012 at 4:14 PM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Thu, Dec 20, 2012 at 03:10:10PM -0800, Andy Lutomirski wrote:
>> >> The onus is currently on filesystems to call file_update_time
>> >> somewhere in the page_mkwrite path.  This is unfortunate for three
>> >> reasons:
>> >>
>> >> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
>> >>    often sleeps while dirtying inodes.
>> >
>> > That's an ext4 problem, not a page fault or timestamp update
>> > problem. Fix ext4.
>>
>> I could fix ext4 (or rather, someone who understands jbd2 could fix
>> ext4), but I think my approach is considerably simpler and fixes all
>> filesystems at once.
>   Well, you could implement the fix you did just inside ext4. Remove
> timestamp update from ext4_page_mkwrite(), just set some inode flag there,
> update times in ext4_writepages(), ext4_sync_file(), and
> ext4_release_file(). It won't be as elegant but it would work.

I'm worried about funny corner cases.  Suppose fd1 and fd2 refer to
two separate struct files for the same inode.  Then do this:

addr1 = mmap(fd1);
addr2 = mmap(fd2);
*addr2 = 0;  <-- calls page_mkwrite
munmap(addr1);
close(fd1);
sleep(10);
*addr2 = 1;  <-- probably does not call page_mkwrite
munmap(addr2);
close(fd2);

Without extra care, the file timestamp will be ten seconds too early.
To make this work, ext4 would need to keep track of which vma is
dirty, which would involve a lot more complexity.  Alternatively, ext4
could call page_mkclean on all pages in the mapping in
ext4_release_file, but that would suck for performance.  (Actually,
that would probably be awful for my workload -- I have a background
task that periodically opens and (critically) closes the same files
that are mmaped in real-time thread, and all those extra tlb flushes
and page faults would hurt.)

The approach in my patches magically avoids this problem by using the
per-pte dirty bit as opposed to anything that's per page. :)
Admittedly, I could leave the AS_CMTIME stuff in the core and just
sprinkle mapping_flush_cmtime calls around ext4.

One of these days I hope to open-source the thing that hits all these
issues.  It's useful and has no good reason to be proprietary, other
than its present messiness.

>
>> >> 3. (An ulterior motive) I'd like to use hardware dirty tracking for
>> >>    shared, locked, writable mappings (instead of page faults).  Moving
>> >>    important work out of the page_mkwrite path is an important first step.
>> >
>> > I don't think you're going to get very far doing this. page_mkwrite
>> > needs to do:
>> >
>> >         a) block allocation in page_mkwrite() for faults over holes
>> >            to detect ENOSPC conditions immediately rather than in
>> >            writeback when such an error results in data loss.
>> >         b) detect writes over unwritten extents so that the pages in
>> >            the page cache can be set up correctly for conversion to
>> >            occur during writeback.
>> >
>> > Correcting these two problems was the reason for introducing
>> > page_mkwrite in the first place - we need to do this stuff before
>> > the page fault is completed, and that means, by definition,
>> > page_mkwrite needs to be able to block. Moving c/mtime updates out
>> > of the way does not, in any way, change these requirements.
>>
>> I was unclear.  I have no problem if PROT_WRITE, MAP_SHARED pages
>> start out write protected.  I want two changes from the status quo,
>> though:
>>
>> 1. ptes (maybe only if mlocked or maybe even only if some new madvise
>> flag is set) should be marked clean but stay writable during and after
>> writeback.  (This would only work when stable pages are not in
>> effect.)
>   This is actually problematic - s390 architecture doesn't have PTE dirty
> bit. It has per page HW dirty bit but that's problematic to use so it's
> completely relying on page being protected after writeback so that it hits
> page fault when it should be dirtied again. Also memory management uses
> these page faults to track number of dirty pages which is then important to
> throttle aggressive writers etc. (we used to do what you describe sometimes
> in early 2.6 days but then we switched to writeprotecting the page for
> writeback to be able to do dirty page tracking).

Ugh.  I thought arches without per-pte dirty bits were supposed to
emulate them by treating writable+clean as write protected and fixing
everything up when page faults happen.

This whole thing could just be turned off on s390, though.

>
> If we limit the behavior you desribe to mlocked pages, I could imagine
> things would work out from the accounting POV (we could treat mlocked pages
> as always dirty for accounting purposes) but it's definitely not a change
> to be easily made.
>
>> 2. There should be a way to request that pages be made clean-but-writable.
>>
>> #1 should be mostly fine already from the filesystems' point of view.
>> #2 would involve calling page_mkwrite or some equivalent.
>>
>> I suspect that there are bugs that are currently untriggerable
>> involving clean-but-writable pages.  For example, what happens if cpu
>> 0 (atomically) changes a pte from clean/writable to not present, but
>> cpu 1 writes the page before the TLB flush happens.  I think the pte
>> ends up not present + dirty, but the current unmapping code won't
>> notice.
>>
>> This would involve splitting page_mkclean into "make clean and write
>> protect" and "make clean but leave writable".
>>
>> Doing this would avoid ~1M "soft" page faults per day in a single
>> real-time thread in my software.  (The file time patches are to make
>> sure that the "soft" page faults actually don't sleep.)
>   Yes, there's a non-negligible cost of writeprotecting the page during
> writeback. But the avoidance of OOM conditions due to too aggressive
> writers simply has precedence... Anyway, if you want to push more in this
> direction, I suggest to move this discussion to linux-mm@kvack.org as there
> are lingering more appropriate listeners :). I'm just a filesystem guy with
> some basic knowledge of MM.

Will do.  I'll send out updated patches as well.

--Andy
