Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933999Ab2C3KXe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:23:34 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:44764 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933680Ab2C3KXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:23:18 -0400
Date: Fri, 30 Mar 2012 12:23:08 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Hocko <mhocko@suse.cz>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] fix idle ticks in cpu summary line of /proc/stat
Message-ID: <20120330122308.18720283@de.ibm.com>
In-Reply-To: <alpine.LFD.2.02.1203291241360.2542@ionos>
References: <20120311182621.41674b39@de.ibm.com>
	<20120312121726.GA23608@tiehlicka.suse.cz>
	<20120312101739.26eb373e@de.ibm.com>
	<4F5E0CC1.6010102@linux.vnet.ibm.com>
	<20120312153906.GE3994@tiehlicka.suse.cz>
	<20120312164145.5110ed5c@de.ibm.com>
	<20120313080748.GA7754@tiehlicka.suse.cz>
	<alpine.LFD.2.02.1203291241360.2542@ionos>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12033010-4966-0000-0000-000001E5A5F6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Thu, 29 Mar 2012 12:42:22 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Tue, 13 Mar 2012, Michal Hocko wrote:
> 
> > OK, so the updated version of the patch looks like this. I am sorry but
> > I had time to only compile test this...
> > ---
> > >From d12247f14c5f8b00ae97a87442f62e49227a759b Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Mon, 12 Mar 2012 13:11:38 +0100
> > Subject: [PATCH] nohz: fix idle ticks in cpu summary line of /proc/stat
> > 
> > Git commit 09a1d34f8535ecf9 "nohz: Make idle/iowait counter update
> > conditional" introduced a bug in regard to cpu hotplug. The effect is
> > that the number of idle ticks in the cpu summary line in /proc/stat is
> > still counting ticks for offline cpus.
> > 
> > Reproduction is easy, just start a workload that keeps all cpus busy,
> > switch off one or more cpus and then watch the idle field in top.
> > On a dual-core with one cpu 100% busy and one offline cpu you will get
> > something like this:
> > 
> > %Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> > 
> > The problem is that an offline cpu still has ts->idle_active == 1.
> > To fix this we should make sure that the cpu is online when calling
> > get_cpu_idle_time_us and get_cpu_iowait_time_us.
> > 
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
> > Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> 
> Martin, does that solve the problem for you ?

Yes, the patch does solve the immediate problem. I just tested if again
on x86 and s390, works fine. I would like to have another change though.
The idle_sleep calculation in the scheduler is fine for x86 but for s390
the arch_idle_time delivers a much better precision. A patch would look
like this:
--
Subject: [PATCH] use arch_idle_time for idle and iowait times if available

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Git commit a25cac5198d4ff28 "proc: Consider NO_HZ when printing idle and
iowait times" changes the code for /proc/stat to use get_cpu_idle_time_us
and get_cpu_iowait_time_us if the system is running with nohz enabled.
For architectures which define arch_idle_time (currently s390 only)
this is a change for the worse. The result of arch_idle_time is supposed
to be the exact sleep time of the target cpu and should be used instead
of the value kept by the scheduler.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 fs/proc/stat.c |   34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

--- a/fs/proc/stat.c
+++ b/fs/proc/stat.c
@@ -18,9 +18,30 @@
 #ifndef arch_irq_stat
 #define arch_irq_stat() 0
 #endif
-#ifndef arch_idle_time
-#define arch_idle_time(cpu) 0
-#endif
+
+#ifdef arch_idle_time
+
+static cputime64_t get_idle_time(int cpu)
+{
+	cputime64_t idle;
+
+	idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
+	if (cpu_online(cpu) && !nr_iowait_cpu(cpu))
+		idle += arch_idle_time(cpu);
+	return idle;
+}
+
+static cputime64_t get_iowait_time(int cpu)
+{
+	cputime64_t iowait;
+
+	iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
+	if (cpu_online(cpu) && nr_iowait_cpu(cpu))
+		iowait += arch_idle_time(cpu);
+	return iowait;
+}
+
+#else
 
 static u64 get_idle_time(int cpu)
 {
@@ -29,11 +50,10 @@ static u64 get_idle_time(int cpu)
 	if (cpu_online(cpu))
 		idle_time = get_cpu_idle_time_us(cpu, NULL);
 
-	if (idle_time == -1ULL) {
+	if (idle_time == -1ULL)
 		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
-		idle += arch_idle_time(cpu);
-	} else
+	else
 		idle = usecs_to_cputime64(idle_time);
 
 	return idle;
@@ -55,6 +75,8 @@ static u64 get_iowait_time(int cpu)
 	return iowait;
 }
 
+#endif
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

