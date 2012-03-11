Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab2CKW0h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:26:37 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:57960 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab2CKW03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:26:29 -0400
Date: Sun, 11 Mar 2012 18:26:21 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michal Hocko <mhocko@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix idle ticks in cpu summary line of /proc/stat
Message-ID: <20120311182621.41674b39@de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12031122-3548-0000-0000-0000014E3498
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update conditional"
introduced a bug in regard to cpu hotplug. The effect is that the number
of idle ticks in the cpu summary line in /proc/stat is still counting
ticks for offline cpus. 

Reproduction is easy, just start a workload that keeps all cpus busy,
switch off one or more cpus and then watch the idle field in top.
On a dual-core with one cpu 100% busy and one offline cpu you will get
something like this:

%Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

The problem is that an offline cpu still has ts->idle_active == 1.
To fix this get_cpu_idle_time_us and get_cpu_iowait_time_us
should check for offline cpus.

Cc: Michal Hocko <mhocko@suse.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 kernel/time/tick-sched.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -213,7 +213,7 @@ u64 get_cpu_idle_time_us(int cpu, u64 *l
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, idle;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_enabled || !cpu_online(cpu))
 		return -1;
 
 	now = ktime_get();
@@ -254,7 +254,7 @@ u64 get_cpu_iowait_time_us(int cpu, u64
 	struct tick_sched *ts = &per_cpu(tick_cpu_sched, cpu);
 	ktime_t now, iowait;
 
-	if (!tick_nohz_enabled)
+	if (!tick_nohz_enabled || !cpu_online(cpu))
 		return -1;
 
 	now = ktime_get();

