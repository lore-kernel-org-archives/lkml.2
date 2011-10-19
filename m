Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab1JSRt6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 13:49:58 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49588 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845Ab1JSRt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 13:49:57 -0400
Date: Wed, 19 Oct 2011 10:49:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, ctalbott@google.com
Subject: Re: [PATCH 07/10] block: reorganize throtl_get_tg() and
 blk_throtl_bio()
Message-ID: <20111019174952.GI25124@google.com>
References: <1318998384-22525-1-git-send-email-tj@kernel.org>
 <1318998384-22525-8-git-send-email-tj@kernel.org>
 <20111019145622.GE1140@redhat.com>
 <20111019170625.GD25124@google.com>
 <20111019171917.GA4026@redhat.com>
 <20111019173053.GG25124@google.com>
 <20111019174556.GJ1140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111019174556.GJ1140@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 19, 2011 at 01:45:56PM -0400, Vivek Goyal wrote:
> > Hmmmm, yeah, right, switching itself would be racy.  Maybe not sharing
> > is the solution, I don't know.  There's a way to make the switching
> > safe tho.  Sth like the following.
> > 
> > 	lock_queue(q, flags)
> > 	{
> > 		spinlock_t *lock;
> > 
> > 		local_irq_save(flags);
> > 		lock = rcu_dereference_sched(q->queue_lock);
> > 		spin_lock(lock);
> > 	}
> > 
> > and on cleanup, do synchronize_sched() after lock switching.  But yeah
> > it still stinks.
> 
> rcu protected spinlocks. Interesting. :-)

:)

> IIUC, it still leaves the window open that two callers think they have
> the spinlock. One is holding the driver provided lock and other is holding
> the queue private lock.

On blk_cleanup_queue() completion, the two are disjoint, so that
shouldn't be a problem.  Block layer won't call into low level drivers
and low level drivers aren't supposed to call into block layer either.

Thanks.

-- 
tejun
