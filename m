Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876Ab1J1XhG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:37:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61471 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab1J1XhE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:37:04 -0400
MIME-Version: 1.0
In-Reply-To: <20111025122618.GA8072@quack.suse.cz>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
	<ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
	<CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
	<CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
	<CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
	<20111025122618.GA8072@quack.suse.cz>
Date: Fri, 28 Oct 2011 16:37:03 -0700
Message-ID: <CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
Subject: Re: Latency writing to an mlocked ext4 mapping
From: Andy Lutomirski <luto@amacapital.net>
To: Jan Kara <jack@suse.cz>
Cc: Andreas Dilger <adilger@dilger.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 5:26 AM, Jan Kara <jack@suse.cz> wrote:
> On Wed 19-10-11 22:59:55, Andy Lutomirski wrote:
>> On Wed, Oct 19, 2011 at 7:17 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> > On Wed, Oct 19, 2011 at 6:15 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> >> On Wed, Oct 19, 2011 at 6:02 PM, Andreas Dilger <adilger@dilger.ca> wrote:
>> >>> What kernel are you using?  A change to keep pages consistent during writeout was landed not too long ago (maybe Linux 3.0) in order to allow checksumming of the data.
>> >>
>> >> 3.0.6, with no relevant patches.  (I have a one-liner added to the tcp
>> >> code that I'll submit sometime soon.)  Would this explain the latency
>> >> in file_update_time or is that a separate issue?  file_update_time
>> >> seems like a good thing to make fully asynchronous (especially if the
>> >> file in question is a fifo, but I've already moved my fifos to tmpfs).
>> >
>> > On 2.6.39.4, I got one instance of:
>> >
>> > call_rwsem_down_read_failed ext4_map_blocks ext4_da_get_block_prep
>> > __block_write_begin ext4_da_write_begin ext4_page_mkwrite do_wp_page
>> > handle_pte_fault handle_mm_fault do_page_fault page_fault
>> >
>> > but I'm not seeing the large numbers of the ext4_page_mkwrite trace
>> > that I get on 3.0.6.  file_update_time is now by far the dominant
>> > cause of latency.
>>
>> The culprit seems to be do_wp_page -> file_update_time ->
>> mark_inode_dirty_sync.  This surprises me for two reasons:
>>
>>  - Why the _sync?  Are we worried that data will be written out before
>> the metadata?  If so, surely there's a better way than adding latency
>> here.
>  _sync just means that inode will become dirty for fsync(2) purposes but
> not for fdatasync(2) purposes - i.e. it's just a timestamp update (or
> it could be something similar).
>
>>  - Why are we calling file_update_time at all?  Presumably we also
>> update the time when the page is written back (if not, that sounds
>> like a bug, since the contents may be changed after something saw the
>> mtime update), and, if so, why bother updating it on the first write?
>> Anything that relies on this behavior is, I think, unreliable, because
>> the page could be made writable arbitrarily early by another program
>> that changes nothing.
>  We don't update timestamp when the page is written back. I believe this
> is mostly because we don't know whether the data has been changed by a
> write syscall, which already updated the timestamp, or by mmap. That is
> also the reason why we update the timestamp at page fault time.
>
>  The reason why file_update_time() blocks for you is probably that it
> needs to get access to buffer where inode is stored on disk and because a
> transaction including this buffer is committing at the moment, your thread
> has to wait until the transaction commit finishes. This is mostly a problem
> specific to how ext4 works so e.g. xfs shouldn't have it.
>
>  Generally I believe the attempts to achieve any RT-like latencies when
> writing to a filesystem are rather hopeless. How much hopeless depends on
> the load of the filesystem (e.g., in your case of mostly idle filesystem I
> can imagine some tweaks could reduce your latencies to an acceptable level
> but once the disk gets loaded you'll be screwed). So I'd suggest that
> having RT thread just store log in memory (or write to a pipe) and have
> another non-RT thread write the data to disk would be a much more robust
> design.

Windows seems to do pretty well at this, and I think it should be fixable on
Linux too.  "All" that needs to be done is to remove the pte_wrprotect from
page_mkclean_one.  The fallout from that might be unpleasant, though, but
it would probably speed up a number of workloads.

Adding a whole separate process just to copy data from memory to disk sounds
a bit like a hack -- that's what mmap + mlock would do if it worked better.
Incidentally, pipes are no good.  I haven't root-caused it yet, but both reading
to and writing from pipes, even if O_NONBLOCK, can block.  I haven't root-caused
it yet.

Anyway, I'll start sending patches to whittle away at the problem,
starting right now :)

--Andy
