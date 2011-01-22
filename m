Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751070Ab1AVFFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 00:05:07 -0500
Received: from smtp-out.google.com ([74.125.121.67]:45610 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1AVFEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 00:04:52 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:user-agent:date:from:to:cc:subject:references:
	content-disposition:x-system-of-record;
	b=J2Y3q1ZSfTk+3/N7wa/eDU2HONW2p6UjnVGQ20Fzn798CpSqQWv8dfCcUttAqtruL
	VEtkOWuTNruXinCvOfbdg==
Message-Id: <20110122044852.102126037@google.com>
User-Agent: quilt/0.48-1
Date: Fri, 21 Jan 2011 20:45:03 -0800
From: Paul Turner <pjt@google.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>
Subject: [patch 5/5] sched: avoid expensive initial update_cfs_load()
References: <20110122044458.058531078@google.com>
Content-Disposition: inline; filename=sched-fix_first_update_load.patch
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since cfs->{load_stamp,load_last} are zero-initalized the initial load update
will consider the delta to be 'since the beginning of time'.

This results in a lot of pointless divisions to bring this large period to be
within the sysctl_sched_shares_window.

Fix this by initializing load_stamp to be 1 at cfs_rq initialization, this
allows for an initial load_stamp > load_last which then lets standard idle
truncation proceed.

We avoid spinning (and slightly improve consistency) by fixing delta to be 
[period - 1] in this path resulting in a slightly more predictable shares ramp.
(Previously the amount of idle time preserved by the overflow would range between
[period/2,period-1].)

Signed-off-by: Paul Turner <pjt@google.com>

---
 kernel/sched.c      |    2 ++
 kernel/sched_fair.c |    1 +
 2 files changed, 3 insertions(+)

Index: tip3/kernel/sched.c
===================================================================
--- tip3.orig/kernel/sched.c
+++ tip3/kernel/sched.c
@@ -7796,6 +7796,8 @@ static void init_cfs_rq(struct cfs_rq *c
 	INIT_LIST_HEAD(&cfs_rq->tasks);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
+	/* allow initial update_cfs_load() to truncate */
+	cfs_rq->load_stamp = 1;
 #endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
Index: tip3/kernel/sched_fair.c
===================================================================
--- tip3.orig/kernel/sched_fair.c
+++ tip3/kernel/sched_fair.c
@@ -732,6 +732,7 @@ static void update_cfs_load(struct cfs_r
 	    now - cfs_rq->load_last > 4 * period) {
 		cfs_rq->load_period = 0;
 		cfs_rq->load_avg = 0;
+		delta = period - 1;
 	}
 
 	cfs_rq->load_stamp = now;


