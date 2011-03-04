Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759719Ab1CDPEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:04:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5659 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752030Ab1CDPEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:04:20 -0500
Date: Fri, 4 Mar 2011 16:04:16 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] block: fix mis-synchronisation in
 blkdev_issue_zeroout()
In-Reply-To: <x49zkpbhszn.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1103041552020.5003@dhcp-27-109.brq.redhat.com>
References: <1299231968-5730-1-git-send-email-lczerner@redhat.com> <x49zkpbhszn.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Jeff Moyer wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > BZ29402
> > https://bugzilla.kernel.org/show_bug.cgi?id=29402
> >
> > We can hit serious mis-synchronization in bio completion path of
> > blkdev_issue_zeroout() leading to a panic.
> >
> > The problem is that when we are going to wait_for_completion() in
> > blkdev_issue_zeroout() we check if the bb.done equals issued (number of
> > submitted bios). If it does, we can skip the wait_for_completition()
> > and just out of the function since there is nothing to wait for.
> > However, there is a ordering problem because bio_batch_end_io() is
> > calling atomic_inc(&bb->done) before complete(), hence it might seem to
> > blkdev_issue_zeroout() that all bios has been completed and exit. At
> > this point when bio_batch_end_io() is going to call complete(bb->wait),
> > bb and wait does not longer exist since it was allocated on stack in
> > blkdev_issue_zeroout() ==> panic!
> >
> > (thread 1)                      (thread 2)
> > bio_batch_end_io()              blkdev_issue_zeroout()
> >   if(bb) {                      ...
> >     if (bb->end_io)             ...
> >       bb->end_io(bio, err);     ...
> >     atomic_inc(&bb->done);      ...
> >     ...                         while (issued != atomic_read(&bb.done))
> >     ...                         (let issued == bb.done)
> >     ...                         (do the rest of the function)
> >     ...                         return ret;
> >     complete(bb->wait);
> >     ^^^^^^^^
> >     panic
> 
> That's a pretty tight window.  The complete is immediately following the
> increment.  I'm surprised thread 2 has time to finish up and exit the
> function before the completion is done.

Yeah, maybe that is why it is so hard to hit. Eric was able to hit it
only on 48 core box running ffsb test with 192 threads. Also the panic
backtrace bug "bad spinlock magic" pointed me to this.

> 
> > We can fix this easily by simplifying bio_batch and completion counting.
> > We can count completion locally in blkdev_issue_zeroout() without need of
> > locking or atomic operation because we are the only one handling issued
> > variable holding the number of submitted bios. So remove atomic_t done
> > from struct bio_batch.
> 
> It seems to me like it might be better to just not complete anything
> until the count is zero.  Why issue a wakeup for every bio?
> fs/direct-io does something similar, maybe take a look at the
> dio_bio_end* routines and see if that would fit well here.  With your
> scheme, I worry about missing a completion, maybe because the first bio
> completes before you are done submitting bios.  Is that possible?

I do not think it is possible. For every bio submitted there is
wait_for_completion called. When bio complete()s completion->done is
incremented (under the wait->lock). In wait_for_completion() we are
waiting for single submitted bio to complete (completion->done > 0),
then completion->done is decremented. It seems like simple
synchronization.

I am not sure what wakeup you have in mind, but thanks for the tip I'll
look in fs/direct-io.

Thanks!
-Lukas

> 
> > Also remove bio_end_io_t *end_io since it is not used.
> 
> Yeah, no idea why that was in there.
> 
> Cheers,
> Jeff
> 
