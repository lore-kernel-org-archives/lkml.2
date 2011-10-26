Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751935Ab1JZTZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 15:25:56 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47639 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab1JZTZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 15:25:54 -0400
Date: Wed, 26 Oct 2011 12:25:48 -0700
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: axboe@kernel.dk, jgarzik@pobox.com, davem@davemloft.net, hch@infradead.org,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] block: add blk_queue_dead()
Message-ID: <20111026192548.GB24261@google.com>
References: <1319590927-15791-1-git-send-email-tj@kernel.org>
 <1319590927-15791-5-git-send-email-tj@kernel.org>
 <20111026172049.GD355@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111026172049.GD355@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 26, 2011 at 01:20:49PM -0400, Vivek Goyal wrote:
> On Tue, Oct 25, 2011 at 06:02:05PM -0700, Tejun Heo wrote:
> > @@ -603,7 +603,7 @@ EXPORT_SYMBOL(blk_init_allocated_queue_node);
> >  
> >  int blk_get_queue(struct request_queue *q)
> >  {
> > -	if (likely(!test_bit(QUEUE_FLAG_DEAD, &q->queue_flags))) {
> > +	if (likely(!blk_queue_dead(q))) {
> >  		kobject_get(&q->kobj);
> >  		return 0;
> 
> I thought DEAD flag is now synchronized with queue lock. So the protocol
> is that caller should be holding queue lock here first?

The requirement is that issue and processing of requests don't happen
once DEAD is set and to guarantee that it's necessary to set DEAD and
check DEAD in rq alloc/issue paths.

blk_get_queue() is inherently opportunistic as holding a reference
doesn't prevent it from being killed.  It doesn't make any sense to
require its holder to grab spinlock - either the caller doesn't need a
refcnt (as it's holding spinlock) or the result of the check becomes
stale as soon as it drops the spinlock.  Whether testing DEAD is
helpful (it isn't necessary per-se) is another question tho.

Thanks.

-- 
tejun
