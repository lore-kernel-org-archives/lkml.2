Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab1F2R0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:26:40 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13657 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1F2R0f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:26:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cFDHxxv/KOVsm1tCgH4hTKZTB1JzY5k3oRnovtWQXm1HNI1ec2PhUlYxHYgDMrNES
	bBq7jY8wXaij9JfeK1f8A==
MIME-Version: 1.0
In-Reply-To: <20110629081155.GA5558@infradead.org>
References: <1309304616-8657-1-git-send-email-curtw@google.com>
	<20110629005422.GQ32466@dastard>
	<BANLkTimKtwVZo3D+w9AB2-C83d08YROcMw@mail.gmail.com>
	<20110629081155.GA5558@infradead.org>
Date: Wed, 29 Jun 2011 10:26:33 -0700
Message-ID: <BANLkTinoFOnQoo3k3KiDgqd7+uBH6shNesxhmVRo9wWr0WCkEw@mail.gmail.com>
Subject: Re: [PATCH] writeback: Don't wait for completion in writeback_inodes_sb_nr
From: Curt Wohlgemuth <curtw@google.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph:

On Wed, Jun 29, 2011 at 1:11 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Tue, Jun 28, 2011 at 06:56:41PM -0700, Curt Wohlgemuth wrote:
>> I don't quite understand this.  It's true that all IO done as a result
>> of calling wb_writeback() on this work item won't finish before the
>> completion takes place, but sending all those pages in flight *will*
>> take place.  And that's a lot of time.  To wait on this before we then
>> call sync_inodes_sb(), and do it all over again, seems odd at best.
>>
>> Pre-2.6.35 kernels would start non-integrity sync writeback and
>> immediately return, which would seem like a reasonable "prefetch-y"
>> thing to do, considering it's going to be immediately followed by a
>> data integrity sync writeback operation.
>
> The only old kernel I have around is 2.6.16, so looking at that one
> for old semantics:
>
>  - it first does a wakeup_pdflush() which does a truely asynchronous
>   writeback of everything in the system.  This is replaced with a
>   wakeup_flusher_threads(0) in 3.0, which has pretty similar sematics.
>  - after that things change a bit as we reordered sync quite a bit too
>   a) improve data integrity by properly ordering the steps of the sync
>   and b) shared code between the global sync and per-fs sync as
>   used by umount, sys_syncfs and a few other callers.  But both do
>   an semi-sync pass and a sync pass on per-sb writeback.  For the old
>   code it's done from the calling threads context, while the next code
>   moved it to the flushers thread, but still waiting for it with the
>   completion.  No major change in semantics as far as I can see.

You're right about this.  (I'm looking at 2.6.26 as it happens, but
it's got the same behavior.)

The semantics did change between 2.6.34 and 2.6.35 though.  When the
work item queue was introduced in 2.6.32, the semantics changed from
what you describe above to what's present through 2.6.34:
writeback_inodes_sb() would enqueue a work item, and return.  Your
commit 83ba7b07 ("writeback: simplify the write back thread queue")
added the wait_for_completion() call, putting the semantics back to
where they were pre-2.6.32.

And in fact, this change has only minor effect on writeback, at least
-- since the WB_SYNC_ALL work item won't even get started until the
WB_SYNC_NONE one is finished.

Though one additional change between the old way (pre-2.6.32) and
today:  with the old kernel, the pdflush thread would operate
concurrently with the first (and second?) sync path through writeback.
 Today of course, they're *all* serialized.  So really a call to
sys_sync() will enqueue 3 work items -- one from
wakeup_flusher_threads(), one from writeback_inodes_sb(), and one from
sync_inodes_sb().

> The idea of the async pass is to start writeback on as many as possible
> pages before actively having to wait on them.  I'd agree with your
> assessment that the writeback_inodes_sb might not really help all that
> much - given that a lot of the waiting might not actually be for I/O
> completion but e.g. for the block level throtteling (or maybe cgroups
> in your case?).

What I'm seeing with an admittedly nasty workload -- two FIO scripts
writing as fast as possible to 1000 files each, with a sync 10 seconds
into the workload -- is that the "async pass" will write out a
(nearly) completely separate set of pages from the "sync pass."
Because the work items are serialized, there are so many new dirty
pages since the first work item starts, and so the sync pass has just
about as many pages to write out as the first.  So the "prefetch-y"
async pass is basically wasted time.

>
> For sys_sync I'm pretty sure we could simply remove the
> writeback_inodes_sb call and get just as good if not better performance,
> but we'd still need a solution for the other sync_filesystem callers,
> assuming the first write actually benefits them.  Maybe you can run
> some sys_syncfs microbenchmarks to check it?  Note that doing multiple
> passes generally doesn't actually help live-lock avoidance either, but
> wu has recently done some work in that area.

I've been running tests using sys_sync, and seeing sync take far
longer than I'd expect, but haven't tried sys_syncfs yet.  I'll add
that to my list.

Still, both do two completely serialized passes: one "async pass"
followed by the "sync pass" -- during which other work items can get
queued, lots more pages get dirtied, etc.

>
> Another thing we've discussed a while ago is changing sync_inodes_sb
> to the writeback or at least the waiting back in the calling threads
> context to not block the flushers threads from getting real work done.

This would make sense to insure that sync finishes reasonably fast,
but as Jan points out, would cause that much more interference with
the write pattern...

Thanks,
Curt
