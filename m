Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030889Ab2CGWov (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:44:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11458 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030205Ab2CGWou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:44:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 07 Mar 2012 14:44:27 -0800
From: Diwakar Tundlam <dtundlam@nvidia.com>
To: Ingo Molnar <mingo@elte.hu>, "'Peter Zijlstra'" <peterz@infradead.org>,
        "'Jens Axboe'" <jaxboe@fusionio.com>,
        "'Randy Dunlap'" <randy.dunlap@oracle.com>
CC: Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>
Date: Wed, 7 Mar 2012 14:44:26 -0800
Subject: [PATCH] scheduler: domain: correctly initialize 'next_balance' in
 'nohz' idle balancer
Thread-Topic: [PATCH] scheduler: domain: correctly initialize 'next_balance'
 in 'nohz' idle balancer
Thread-Index: AczgU0erG2gZs14gRdCqHlqSrZe0nwcX5wag
Message-ID: <1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com>
References: <1327927463-4165-1-git-send-email-pdeschrijver@nvidia.com>
	 <1328024684.2446.234.camel@twins>
	 <1DD7BFEDD3147247B1355BEFEFE466523791832BE9@HQMAIL04.nvidia.com>
 <1328040137.2446.242.camel@twins>
In-Reply-To: <1328040137.2446.242.camel@twins>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scheduler: domain: init next_balance in nohz_idle_balancer with jiffies

The 'next_balance' field of 'nohz' idle balancer must be initialized
to jiffies. Since jiffies is initialized to negative 300 seconds the
'nohz' idle balancer does not run for the first 300s (5mins) after
bootup. If no new processes are spawed or no idle cycles happen, the
load on the cpus will remain unbalanced for that duration.

Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
---
 1 files changed, 1 insertions(+), 0 deletions(-)

diff -up sched/fair.c{.orig,}
--- sched/fair.c.orig	2012-03-07 08:33:03.000000000 -0800
+++ sched/fair.c	2012-03-07 13:50:30.787265795 -0800
@@ -5614,6 +5614,7 @@ __init void init_sched_fair_class(void)
 	open_softirq(SCHED_SOFTIRQ, run_rebalance_domains);
 
 #ifdef CONFIG_NO_HZ
+	nohz.next_balance = jiffies;
 	zalloc_cpumask_var(&nohz.idle_cpus_mask, GFP_NOWAIT);
 	cpu_notifier(sched_ilb_notifier, 0);
 #endif
