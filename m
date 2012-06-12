Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab2FLM22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:28:28 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39110 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794Ab2FLM20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:28:26 -0400
MIME-Version: 1.0
Date: Tue, 12 Jun 2012 20:28:26 +0800
Message-ID: <CAJd=RBBf4rFUKQZXTApeecWeKkpuSyQh10vG3hJoj8nCJv0Fww@mail.gmail.com>
Subject: [patch] BFS 421: add knob for selecting the earliest deadline task
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cache affinity considered, EDL is no longer strict when selecting
task. To understand its benifit, knob is added for comparing different
EDL modes, with two other modes added to be background.

Note, keep workload unchanged when comparing EDL modes.


--- a/kernel/sched/bfs.c	Mon Jun 11 21:02:22 2012
+++ b/kernel/sched/bfs.c	Tue Jun 12 20:01:46 2012
@@ -150,6 +150,13 @@ int rr_interval __read_mostly = 6;
 int sched_iso_cpu __read_mostly = 70;

 #ifdef CONFIG_SMP
+enum {
+	EDL_CK,		//default
+	EDL_MS,		//map cache distance to milliseconds
+	EDL_NONE,	//strict edl
+};
+int edl_mode = EDL_CK;
+
 unsigned long	grab_rq_lock = 0,
 		wait_rq_lock = 0,
 		tsk_csw = 0,
@@ -3062,7 +3069,17 @@ task_struct *earliest_deadline_task(stru
 			 */
 			dl = p->deadline;
 #ifdef CONFIG_SMP
-			dl <<= locality_diff(p, rq) + scaling_rq(rq);
+			switch (edl_mode) {
+			default:
+			case EDL_CK:
+				dl <<= locality_diff(p, rq) + scaling_rq(rq);
+				break;
+			case EDL_MS:
+				dl += MS_TO_NS(locality_diff(p, rq) +
+						4* scaling_rq(rq));
+			case EDL_NONE:
+				break;
+			}
 #endif

 			if (deadline_before(dl, earliest_deadline)) {
--- a/kernel/sysctl.c	Tue Jun 12 19:54:40 2012
+++ b/kernel/sysctl.c	Tue Jun 12 20:04:02 2012
@@ -126,6 +126,7 @@ static int __maybe_unused one_hundred =
 extern int rr_interval;
 extern int sched_iso_cpu;
 #ifdef CONFIG_SMP
+extern int edl_mode;
 extern unsigned long grab_rq_lock,
 			wait_rq_lock,
 			tsk_csw,
@@ -883,6 +884,13 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &one_hundred,
 	},
 #ifdef CONFIG_SMP
+	{
+		.procname	= "edl_mode",
+		.data		= &edl_mode,
+		.maxlen		= sizeof (int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 	{
 		.procname	= "cpu_csw",
 		.data		= &cpu_csw,
--
