Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934821Ab1JaXOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 19:14:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45823 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaXOs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 19:14:48 -0400
MIME-Version: 1.0
In-Reply-To: <20111031231031.GD10107@quack.suse.cz>
References: <CALCETrXbPWsgaZmsvHZGEX-CxB579tG+zusXiYhR-13RcEnGvQ@mail.gmail.com>
	<ACE78D84-0E94-4E7A-99BF-C20583018697@dilger.ca>
	<CALCETrU23vyCXPG6mJU9qaPeAGOWDQtur5C+LRT154V5FM=Ajg@mail.gmail.com>
	<CALCETrX=-CnNQ9+4tRbqMG4mfuy2FBPXXoJeBVDVPnEiRJYRFQ@mail.gmail.com>
	<CALCETrUcOKQAJTTmCSD3Q3wYS-zLqv6tBa4AdkK50bNobRhDUQ@mail.gmail.com>
	<20111025122618.GA8072@quack.suse.cz>
	<CALCETrWoZeFpznU5Nv=+PvL9QRkTnS4atiGXx0jqZP_E3TJPqw@mail.gmail.com>
	<20111031231031.GD10107@quack.suse.cz>
Date: Mon, 31 Oct 2011 16:14:47 -0700
Message-ID: <CALCETrViG6t1forOFtO-R=bGABvtLcECxJ8m8Tenv6rwxLg_ew@mail.gmail.com>
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

On Mon, Oct 31, 2011 at 4:10 PM, Jan Kara <jack@suse.cz> wrote:
> On Fri 28-10-11 16:37:03, Andy Lutomirski wrote:
>> On Tue, Oct 25, 2011 at 5:26 AM, Jan Kara <jack@suse.cz> wrote:
>> >>  - Why are we calling file_update_time at all?  Presumably we also
>> >> update the time when the page is written back (if not, that sounds
>> >> like a bug, since the contents may be changed after something saw the
>> >> mtime update), and, if so, why bother updating it on the first write?
>> >> Anything that relies on this behavior is, I think, unreliable, because
>> >> the page could be made writable arbitrarily early by another program
>> >> that changes nothing.
>> >  We don't update timestamp when the page is written back. I believe this
>> > is mostly because we don't know whether the data has been changed by a
>> > write syscall, which already updated the timestamp, or by mmap. That is
>> > also the reason why we update the timestamp at page fault time.
>> >
>> >  The reason why file_update_time() blocks for you is probably that it
>> > needs to get access to buffer where inode is stored on disk and because a
>> > transaction including this buffer is committing at the moment, your thread
>> > has to wait until the transaction commit finishes. This is mostly a problem
>> > specific to how ext4 works so e.g. xfs shouldn't have it.
>> >
>> >  Generally I believe the attempts to achieve any RT-like latencies when
>> > writing to a filesystem are rather hopeless. How much hopeless depends on
>> > the load of the filesystem (e.g., in your case of mostly idle filesystem I
>> > can imagine some tweaks could reduce your latencies to an acceptable level
>> > but once the disk gets loaded you'll be screwed). So I'd suggest that
>> > having RT thread just store log in memory (or write to a pipe) and have
>> > another non-RT thread write the data to disk would be a much more robust
>> > design.
>>
>> Windows seems to do pretty well at this, and I think it should be fixable on
>> Linux too.  "All" that needs to be done is to remove the pte_wrprotect from
>> page_mkclean_one.  The fallout from that might be unpleasant, though, but
>> it would probably speed up a number of workloads.
>  Well, but Linux's mm pretty much depends the pte_wrprotect() so that's
> unlikely to go away in a forseeable future. The reason is that we need to
> reliably account the number of dirty pages so that we can throttle
> processes that dirty too much of memory and also protect agaist system
> going into out-of-memory problems when too many pages would be dirty (and
> thus hard to reclaim). Thus we create clean pages as write-protected, when
> they are first written to, we account them as dirtied and unprotect them.
> When pages are cleaned by writeback, we decrement number of dirty pages
> accordingly and write-protect them again.

What about skipping pte_wrprotect for mlocked pages and continuing to
account them dirty even if they're actually clean?  This should be a
straightforward patch except for the effect on stable pages for
writeback.  (It would also have unfortunate side effects on
ctime/mtime without my other patch to rearrange that code.)

>
>> Adding a whole separate process just to copy data from memory to disk sounds
>> a bit like a hack -- that's what mmap + mlock would do if it worked better.
>  Well, always only guarantees you cannot hit major fault when accessing
> the page. And we keep that promise - we only hit a minor fault. But I agree
> that for your usecase this is impractical.

Not really true.  We never fault in the page, but make_write can wait
for I/O (for hundreds of ms) which is just as bad.

>
> I can see as theoretically feasible for writeback to skip mlocked pages
> which would help your case. But practically, I do not see how to implement
> that efficiently (just skipping a dirty page when we find it's mlocked
> seems like a way to waste CPU needlessly).
>
>> Incidentally, pipes are no good.  I haven't root-caused it yet, but both
>> reading to and writing from pipes, even if O_NONBLOCK, can block.  I
>> haven't root-caused it yet.
>  Interesting. I imagine they could block on memory allocation but I guess
> you don't put that much pressure on your system. So it might be interesting
> to know where else they block...

I'll figure it out in a couple of days, I imagine.

--Andy
