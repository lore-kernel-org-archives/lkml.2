Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936682Ab2C3Wz1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 18:55:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37931 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936651Ab2C3Wy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 18:54:57 -0400
Date: Fri, 30 Mar 2012 15:54:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, tglx@linutronix.de,
        srivatsa.bhat@linux.vnet.ibm.com, mhocko@suse.cz
Cc: tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        tglx@linutronix.de, mhocko@suse.cz
Subject: Re: [tip:timers/core] proc: stats: Use arch_idle_time for idle and
 iowait times if available
Message-Id: <20120330155455.786e8963.akpm@linux-foundation.org>
In-Reply-To: <tip-cb85a6ed67e979c59a29b7b4e8217e755b951cf4@git.kernel.org>
References: <20120330122308.18720283@de.ibm.com>
	<tip-cb85a6ed67e979c59a29b7b4e8217e755b951cf4@git.kernel.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 06:58:25 -0700
tip-bot for Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:

> Commit-ID:  cb85a6ed67e979c59a29b7b4e8217e755b951cf4
> Gitweb:     http://git.kernel.org/tip/cb85a6ed67e979c59a29b7b4e8217e755b951cf4
> Author:     Martin Schwidefsky <schwidefsky@de.ibm.com>
> AuthorDate: Fri, 30 Mar 2012 12:23:08 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Fri, 30 Mar 2012 15:43:33 +0200
> 
> proc: stats: Use arch_idle_time for idle and iowait times if available
> 
> Git commit a25cac5198d4ff28 "proc: Consider NO_HZ when printing idle and
> iowait times" changes the code for /proc/stat to use get_cpu_idle_time_us
> and get_cpu_iowait_time_us if the system is running with nohz enabled.
> For architectures which define arch_idle_time (currently s390 only)
> this is a change for the worse. The result of arch_idle_time is supposed
> to be the exact sleep time of the target cpu and should be used instead
> of the value kept by the scheduler.

So it appears that this patch is a superset of "nohz: fix idle ticks in
cpu summary line of /proc/stat" (below), yes?

> Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> Link: http://lkml.kernel.org/r/20120330122308.18720283@de.ibm.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

No cc:stable?  Both 09a1d34f8535ecf9 and a25cac5198d date from
September '11 and 09a1d34f8535ecf9 (at least) was a regression.



From: Michal Hocko <mhocko@suse.cz>
Subject: nohz: fix idle ticks in cpu summary line of /proc/stat

Commit 09a1d34f8535ecf9 ("nohz: Make idle/iowait counter update
conditional") introduced a bug in regard to cpu hotplug.  The effect is
that the number of idle ticks in the cpu summary line in /proc/stat is
still counting ticks for offline cpus.

Reproduction is easy, just start a workload that keeps all cpus busy,
switch off one or more cpus and then watch the idle field in top.  On a
dual-core with one cpu 100% busy and one offline cpu you will get
something like this:

%Cpu(s): 48.7 us,  1.3 sy,  0.0 ni, 50.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st

The problem is that an offline cpu still has ts->idle_active == 1.  To fix
this we should make sure that the cpu is online when calling
get_cpu_idle_time_us and get_cpu_iowait_time_us.

Cc: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
Cc: <stable@vger.kernel.org>	[3.2.x]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/stat.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -puN fs/proc/stat.c~nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat fs/proc/stat.c
--- a/fs/proc/stat.c~nohz-fix-idle-ticks-in-cpu-summary-line-of-proc-stat
+++ a/fs/proc/stat.c
@@ -24,10 +24,13 @@
 
 static u64 get_idle_time(int cpu)
 {
-	u64 idle, idle_time = get_cpu_idle_time_us(cpu, NULL);
+	u64 idle, idle_time = -1ULL;
+
+	if (cpu_online(cpu))
+		idle_time = get_cpu_idle_time_us(cpu, NULL);
 
 	if (idle_time == -1ULL) {
-		/* !NO_HZ so we can rely on cpustat.idle */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.idle */
 		idle = kcpustat_cpu(cpu).cpustat[CPUTIME_IDLE];
 		idle += arch_idle_time(cpu);
 	} else
@@ -38,10 +41,13 @@ static u64 get_idle_time(int cpu)
 
 static u64 get_iowait_time(int cpu)
 {
-	u64 iowait, iowait_time = get_cpu_iowait_time_us(cpu, NULL);
+	u64 iowait, iowait_time = -1ULL;
+
+	if (cpu_online(cpu))
+		iowait_time = get_cpu_iowait_time_us(cpu, NULL);
 
 	if (iowait_time == -1ULL)
-		/* !NO_HZ so we can rely on cpustat.iowait */
+		/* !NO_HZ or cpu offline so we can rely on cpustat.iowait */
 		iowait = kcpustat_cpu(cpu).cpustat[CPUTIME_IOWAIT];
 	else
 		iowait = usecs_to_cputime64(iowait_time);
_

