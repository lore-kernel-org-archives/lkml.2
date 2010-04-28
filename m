Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab0D1Ns5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:48:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0D1Ns4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:48:56 -0400
Date: Wed, 28 Apr 2010 09:48:52 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: CFQ is broken for CONFIG_BLK_CGROUP=y, CFQ_GROUP_IOSCHED=n
Message-ID: <20100428134852.GA12720@redhat.com>
References: <877hnrg30c.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hnrg30c.fsf@openvz.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 04:44:51PM +0400, Dmitry Monakhov wrote:
> 
> I've had an  oops on kernel boot due to NULL pointer deference
> linux-2.6-block/for-next HEAD:7eaed1226ab411ee5dc8c34fc0d8034e4c98e3c6
> I've enabled CONFIG_BLK_CGROUP, but not CFQ_GROUP_IOSCHED
> In this case cfq_ref_get_cfqg() defined as 
> static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
> {
>         return NULL;
> }
> So following call trace is simply NOOP
> cfq_set_request()
>  rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);
> 
> Which later result in OOPS on bio insertion
> cfq_insert_request
>  -> blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,...)
>     -> spin_lock_irqsave(&blkg->stats_lock, flags);
> 
> Bad commit.
> >From 7f1dc8a2d2f45fc557b27fd56115338b1d34fc24 Mon Sep 17 00:00:00 2001
> From: Vivek Goyal <vgoyal@redhat.com>
> Date: Wed, 21 Apr 2010 17:44:16 +0200
> Subject: [PATCH] blkio: Fix blkio crash during rq stat update

Hi Dmitry,

Thanks for reporting the issue. I am cooking up a patch now.

Vivek
