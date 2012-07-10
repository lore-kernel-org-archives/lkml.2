Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab2GJNHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:07:46 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34351 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992Ab2GJNHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:07:45 -0400
MIME-Version: 1.0
Date: Tue, 10 Jul 2012 21:07:44 +0800
Message-ID: <CAJd=RBB-sju_DFR5RjQRD=f7ZmPUG7Dey7zW03oPaNdVohXRMA@mail.gmail.com>
Subject: [patch] BFS 421-1: delink cpupri
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We compile less with cpupri delinked.


--- a/kernel/sched/Makefile	Tue Jul 10 20:51:54 2012
+++ b/kernel/sched/Makefile	Tue Jul 10 20:51:52 2012
@@ -17,8 +17,8 @@ else
 obj-y += core.o clock.o idle_task.o fair.o rt.o stop_task.o
 obj-$(CONFIG_SCHED_AUTOGROUP) += auto_group.o
 obj-$(CONFIG_SCHED_DEBUG) += debug.o
-endif
 obj-$(CONFIG_SMP) += cpupri.o
+endif
 obj-$(CONFIG_SCHEDSTATS) += stats.o


--- a/kernel/sched/bfs.c	Mon Jul  9 20:10:14 2012
+++ b/kernel/sched/bfs.c	Tue Jul 10 20:49:58 2012
@@ -76,7 +76,6 @@
 #include <asm/paravirt.h>
 #endif

-#include "cpupri.h"
 #include "../workqueue_sched.h"

 #define CREATE_TRACE_POINTS
@@ -223,7 +222,6 @@ struct root_domain {
 	 * one runnable RT task.
 	 */
 	cpumask_var_t rto_mask;
-	struct cpupri cpupri;
 };

 /*
@@ -5591,7 +5589,6 @@ static void free_rootdomain(struct rcu_h
 {
 	struct root_domain *rd = container_of(rcu, struct root_domain, rcu);

-	cpupri_cleanup(&rd->cpupri);
 	free_cpumask_var(rd->rto_mask);
 	free_cpumask_var(rd->online);
 	free_cpumask_var(rd->span);
@@ -5646,12 +5643,8 @@ static int init_rootdomain(struct root_d
 	if (!alloc_cpumask_var(&rd->rto_mask, GFP_KERNEL))
 		goto free_online;

-	if (cpupri_init(&rd->cpupri) != 0)
-		goto free_rto_mask;
 	return 0;

-free_rto_mask:
-	free_cpumask_var(rd->rto_mask);
 free_online:
 	free_cpumask_var(rd->online);
 free_span:
--
