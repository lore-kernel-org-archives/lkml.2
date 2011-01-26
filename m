Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1AZMfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 07:35:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:43197 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125Ab1AZMfX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 07:35:23 -0500
Subject: Re: [tip:sched/core] sched: Avoid expensive initial
 update_cfs_load()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        pjt@google.com, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-f07333bf6ee66d9b49286cec4371cf375e745b7a@git.kernel.org>
References: <20110122044852.102126037@google.com>
	 <tip-f07333bf6ee66d9b49286cec4371cf375e745b7a@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 Jan 2011 13:36:03 +0100
Message-ID: <1296045363.28776.1153.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 12:11 +0000, tip-bot for Paul Turner wrote:
> index e0fa3ff..6820b5b 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -7796,6 +7796,8 @@ static void init_cfs_rq(struct cfs_rq *cfs_rq,
> struct rq *rq)
>         INIT_LIST_HEAD(&cfs_rq->tasks);
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>         cfs_rq->rq = rq;
> +       /* allow initial update_cfs_load() to truncate */
> +       cfs_rq->load_stamp = 1;
>  #endif
>         cfs_rq->min_vruntime = (u64)(-(1LL << 20));
>  } 


That wants a fix to build on UP,

---
Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -7797,8 +7797,10 @@ static void init_cfs_rq(struct cfs_rq *c
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	cfs_rq->rq = rq;
 	/* allow initial update_cfs_load() to truncate */
+#ifdef CONFIG_SMP
 	cfs_rq->load_stamp = 1;
 #endif
+#endif
 	cfs_rq->min_vruntime = (u64)(-(1LL << 20));
 }
 

