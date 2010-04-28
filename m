Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab0D1Mo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:44:58 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:44942 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab0D1Mo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:44:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:cc:date:message-id:user-agent:mime-version
         :content-type;
        b=POrTUQJl7ipQVbSGUpzx+VPDFXP7mPwMLRqUS/SPp1/jS06FNFcQQHx/Ih0xVbHxak
         qApKOm9l30bL8CNwfm5+AWyHV+enukaXuRJtCOudPEOAzQ/2D+3InrvjgCNoSKeaEHtL
         JE8VXhSwRDfGnotf1Jkn9GfXt5AaHDkjvSvW8=
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Subject: CFQ is broken for CONFIG_BLK_CGROUP=y, CFQ_GROUP_IOSCHED=n
CC: jens.axboe@oracle.com, Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 28 Apr 2010 16:44:51 +0400
Message-ID: <877hnrg30c.fsf@openvz.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've had an  oops on kernel boot due to NULL pointer deference
linux-2.6-block/for-next HEAD:7eaed1226ab411ee5dc8c34fc0d8034e4c98e3c6
I've enabled CONFIG_BLK_CGROUP, but not CFQ_GROUP_IOSCHED
In this case cfq_ref_get_cfqg() defined as 
static inline struct cfq_group *cfq_ref_get_cfqg(struct cfq_group *cfqg)
{
        return NULL;
}
So following call trace is simply NOOP
cfq_set_request()
 rq->elevator_private3 = cfq_ref_get_cfqg(cfqq->cfqg);

Which later result in OOPS on bio insertion
cfq_insert_request
 -> blkiocg_update_io_add_stats(&(RQ_CFQG(rq))->blkg,...)
    -> spin_lock_irqsave(&blkg->stats_lock, flags);

Bad commit.
>From 7f1dc8a2d2f45fc557b27fd56115338b1d34fc24 Mon Sep 17 00:00:00 2001
From: Vivek Goyal <vgoyal@redhat.com>
Date: Wed, 21 Apr 2010 17:44:16 +0200
Subject: [PATCH] blkio: Fix blkio crash during rq stat update
