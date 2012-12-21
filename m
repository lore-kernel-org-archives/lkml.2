Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab2LUFha (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 00:37:30 -0500
Received: from mail-vb0-f48.google.com ([209.85.212.48]:49063 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab2LUFhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 00:37:19 -0500
MIME-Version: 1.0
In-Reply-To: <20121221001457.GY15182@dastard>
References: <cover.1356043686.git.luto@amacapital.net> <bd4585908de458907ce90417fcd8233d33960e8f.1356043686.git.luto@amacapital.net>
 <20121221001457.GY15182@dastard>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 20 Dec 2012 21:36:58 -0800
Message-ID: <CALCETrXT2uYwuYR3402LUO2uw3d++=f9vxtFLq8Ez62VdAgOcw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] mm: Update file times when inodes are written
 after mmaped writes
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 4:14 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 20, 2012 at 03:10:10PM -0800, Andy Lutomirski wrote:
>> The onus is currently on filesystems to call file_update_time
>> somewhere in the page_mkwrite path.  This is unfortunate for three
>> reasons:
>>
>> 1. page_mkwrite on a locked page should be fast.  ext4, for example,
>>    often sleeps while dirtying inodes.
>
> That's an ext4 problem, not a page fault or timestamp update
> problem. Fix ext4.

I could fix ext4 (or rather, someone who understands jbd2 could fix
ext4), but I think my approach is considerably simpler and fixes all
filesystems at once.

>
>> 2. The current behavior is surprising -- the timestamp resulting from
>>    an mmaped write will be before the write, not after.  This contradicts
>>    the mmap(2) manpage, which says:
>>
>>      The st_ctime and st_mtime field for a file mapped with  PROT_WRITE  and
>>      MAP_SHARED  will  be  updated  after  a write to the mapped region, and
>>      before a subsequent msync(2) with the MS_SYNC or MS_ASYNC flag, if  one
>>      occurs.
>
> What you propose (time updates in do_writepages()) violates this.
> msync(MS_ASYNC) doesn't actually start any IO, therefore the
> timestamp wil not be updated.

That's easy enough -- I can add special-case code for MS_ASYNC.  It'll
make an operation that is otherwise a no-op considerably less free,
though.

>
> Besides, what POSIX actually says is:

[snipped -- covered elsewhere in the thread]

>
>> 3. (An ulterior motive) I'd like to use hardware dirty tracking for
>>    shared, locked, writable mappings (instead of page faults).  Moving
>>    important work out of the page_mkwrite path is an important first step.
>
> I don't think you're going to get very far doing this. page_mkwrite
> needs to do:
>
>         a) block allocation in page_mkwrite() for faults over holes
>            to detect ENOSPC conditions immediately rather than in
>            writeback when such an error results in data loss.
>         b) detect writes over unwritten extents so that the pages in
>            the page cache can be set up correctly for conversion to
>            occur during writeback.
>
> Correcting these two problems was the reason for introducing
> page_mkwrite in the first place - we need to do this stuff before
> the page fault is completed, and that means, by definition,
> page_mkwrite needs to be able to block. Moving c/mtime updates out
> of the way does not, in any way, change these requirements.

I was unclear.  I have no problem if PROT_WRITE, MAP_SHARED pages
start out write protected.  I want two changes from the status quo,
though:

1. ptes (maybe only if mlocked or maybe even only if some new madvise
flag is set) should be marked clean but stay writable during and after
writeback.  (This would only work when stable pages are not in
effect.)

2. There should be a way to request that pages be made clean-but-writable.

#1 should be mostly fine already from the filesystems' point of view.
#2 would involve calling page_mkwrite or some equivalent.

I suspect that there are bugs that are currently untriggerable
involving clean-but-writable pages.  For example, what happens if cpu
0 (atomically) changes a pte from clean/writable to not present, but
cpu 1 writes the page before the TLB flush happens.  I think the pte
ends up not present + dirty, but the current unmapping code won't
notice.

This would involve splitting page_mkclean into "make clean and write
protect" and "make clean but leave writable".

Doing this would avoid ~1M "soft" page faults per day in a single
real-time thread in my software.  (The file time patches are to make
sure that the "soft" page faults actually don't sleep.)

--Andy
