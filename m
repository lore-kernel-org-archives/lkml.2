Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab1BQAfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 19:35:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:53235 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755437Ab1BQAfq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 19:35:46 -0500
Date: Thu, 17 Feb 2011 11:35:36 +1100
From: NeilBrown <neilb@suse.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-kernel@vger.kernel.org
Subject: Re: blk_throtl_exit  taking q->queue_lock is problematic
Message-ID: <20110217113536.2bbf308e@notabene.brown>
In-Reply-To: <20110216155305.GC14653@redhat.com>
References: <20110216183114.26a3613b@notabene.brown>
	<20110216155305.GC14653@redhat.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Feb 2011 10:53:05 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:

> On Wed, Feb 16, 2011 at 06:31:14PM +1100, NeilBrown wrote:
> > 
> > 
> > Hi,
> > 
> >  I recently discovered that blk_throtl_exit takes ->queue_lock when a blockdev
> > is finally released.
> > 
> > This is a problem for because by that time the queue_lock doesn't exist any
> > more.  It is in a separate data structure controlled by the RAID personality
> > and by the time that the block device is being destroyed the raid personality
> > has shutdown and the data structure containing the lock has been freed.
> > 
> > This has not been a problem before.  Nothing else takes queue_lock after
> > blk_cleanup_queue.
> 
> I agree that this is a problem. blk_throtl_exit() needs queue lock to
> avoid other races with cgroup code and for avoiding races for its
> lists etc.
> 
> > 
> > I could of course set queue_lock to point to __queue_lock and initialise that,
> > but it seems untidy and probably violates some locking requirements.
> > 
> > Is there some way you could use some other lock - maybe a global lock, or
> > maybe used __queue_lock directly ???
> 
> Initially I had put blk_throtl_exit() in blk_cleanup_queue() where it is
> known that ->queue_lock is still around. Due to a bug, Jens moved it
> to blk_release_queue(). I still think that blk_cleanup_queue() is a better
> place to call blk_throtl_exit().

Why do you say that it is known that ->queue_lock is still around in
blk_cleanup_queue?  In md it isn't. :-(
Is there some (other) reason that it needs to be?

Thanks,
NeilBrown

