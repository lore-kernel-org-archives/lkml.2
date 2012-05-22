Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab2EVMvQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 08:51:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57992 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754200Ab2EVMvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 08:51:14 -0400
MIME-Version: 1.0
Date: Tue, 22 May 2012 20:51:13 +0800
Message-ID: <CAJd=RBD54S8M76pFk8RDpk43v+p=sub0pZpBjbkYaVd8BDgzEg@mail.gmail.com>
Subject: Re: BFS 420: fix updating iso ticks
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, iso task is not able to compete with rt task for CPU resources.
Second, rt task could starve iso task but iso task could not starve rt task.
Third, there is change in the defined role of sched_iso_cpu.

That said, remove the dependency on rt task.

--- a/kernel/sched/bfs.c	Mon May 14 20:50:38 2012
+++ b/kernel/sched/bfs.c	Tue May 22 20:08:48 2012
@@ -2764,12 +2764,8 @@ static void task_running_tick(struct rq
 {
 	struct task_struct *p;

-	/*
-	 * If a SCHED_ISO task is running we increment the iso_ticks. In
-	 * order to prevent SCHED_ISO tasks from causing starvation in the
-	 * presence of true RT tasks we account those as iso_ticks as well.
-	 */
-	if ((rt_queue(rq) || (iso_queue(rq) && !grq.iso_refractory))) {
+	/* Increase iso ticks if a SCHED_ISO task is running */
+	if (iso_queue(rq) && isoprio_suitable()) {
 		if (grq.iso_ticks <= (ISO_PERIOD * 128) - 128)
 			iso_tick();
 	} else
--
