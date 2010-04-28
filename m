Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab0D1Rn0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:43:26 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57365 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab0D1RnV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:43:21 -0400
Date: Wed, 28 Apr 2010 19:43:20 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: CFQ is broken for CONFIG_BLK_CGROUP=y, CFQ_GROUP_IOSCHED=n
Message-ID: <20100428174320.GV27497@kernel.dk>
References: <877hnrg30c.fsf@openvz.org> <20100428150959.GA16033@redhat.com> <87ljc7egil.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ljc7egil.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28 2010, Dmitry Monakhov wrote:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
> > On Wed, Apr 28, 2010 at 04:44:51PM +0400, Dmitry Monakhov wrote:
> >> 
> >> I've had an  oops on kernel boot due to NULL pointer deference
> >> linux-2.6-block/for-next HEAD:7eaed1226ab411ee5dc8c34fc0d8034e4c98e3c6
> >> I've enabled CONFIG_BLK_CGROUP, but not CFQ_GROUP_IOSCHED
> >> In this case cfq_ref_get_cfqg() defined as 
> >> static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
> >> {
> >>         return NULL;
> >> }
> >> So following call trace is simply NOOP
> >> cfq_set_request()
> >>  rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> >> 
> >> Which later result in OOPS on bio insertion
> >> cfq_insert_request
> >>  -> blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,...)
> >>     -> spin_lock_irqsave(&blkg->stats_lock, flags);
> >> 
> >> Bad commit.
> >> >From 7f1dc8a2d2f45fc557b27fd56115338b1d34fc24 Mon Sep 17 00:00:00 2001
> >> From: Vivek Goyal <vgoyal@redhat.com>
> >> Date: Wed, 21 Apr 2010 17:44:16 +0200
> >> Subject: [PATCH] blkio: Fix blkio crash during rq stat update
> >
> > Dmitry, this patch should fix the issue. Can you please give it a try.
> Yes. the issue is gone.
> >
> > Jens, I know you don't like this form of cfq_ref_get_cfqg(), but this
> > seems to be the simplest solution to fix it.
> IMHO following fix is simpler, and cleaner.

Agreed, that's much better. I'll add it, thanks.

-- 
Jens Axboe

