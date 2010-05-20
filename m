Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab0ETKwG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:52:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:60503 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614Ab0ETKwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:52:04 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] scheduler: cgroups cpuaccouting: Make cpuusage atomic
Date: Thu, 20 May 2010 12:53:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.12-0.2-desktop; KDE/4.4.3; x86_64; ; )
Cc: mike@android.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com,
       menage@google.com, containers@lists.linux-foundation.org, mingo@elte.hu
References: <1274264877.5605.10541.camel@twins> <1274295539-7798-3-git-send-email-trenn@suse.de> <1274295743.1674.1545.camel@laptop>
In-Reply-To: <1274295743.1674.1545.camel@laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005201253.08904.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 May 2010 21:02:23 Peter Zijlstra wrote:
> On Wed, 2010-05-19 at 20:58 +0200, Thomas Renninger wrote:
> > and avoid locking on 32 bit.
> > This resolves an ugly dependency in cgroups_cpuaccount.c
> > to per_cpu runqueues lock variable.
> 
> While I totally agree with the sentiments here, atomic64_t isn't
> available on all 32bit archs and is _terribly_ expensive on ARCH=i386.

Please ignore the 2nd patch.
If nobody objects about the creation of kernel/sched.h which should get
used for further cleanups IMO, the first patch should get in.
I thought a bit about it, but taking the per_cpu rq lock is the most sane
thing I could think of.

Here is a fix (bug always was there), for "on top" patching of the first.
It should also be possible to fix this by exchanging:
CONFIG_64BIT to CONFIG_X86_64, but removing the #ifdefs should
be preferred over a lock that is only grabbed via sysfs access...

Thanks,

    Thomas

scheduler: cgroup_cpuaccount - Fix race on cpuusage

A u64 access is not atomic on all 64 bit archs.
Especially this:
*cpuusage += cputime;
should not necessarily be atomic on non X86_64 archs.
As cpuacct_cpuusage_{read,write} is only used during
sysfs access, the lock should be acquired rather rarely
and the code is nicer as well.

Signed-off-by: Thomas Renninger <trenn@suse.de>
CC: linux-kernel@vger.kernel.org
CC: mike@android.com
CC: menage@google.com
CC: lizf@cn.fujitsu.com
CC: containers@lists.linux-foundation.org
CC: mingo@elte.hu
CC: peterz@infradead.org

diff --git a/kernel/cgroup_cpuaccount.c b/kernel/cgroup_cpuaccount.c
index 0ad356a..a9e0345 100644
--- a/kernel/cgroup_cpuaccount.c
+++ b/kernel/cgroup_cpuaccount.c
@@ -95,16 +95,12 @@ static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu)
 	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 	u64 data;
 
-#ifndef CONFIG_64BIT
 	/*
-	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
+	 * Take rq->lock to make 64-bit read safe
 	 */
 	lock_runqueue(cpu);
 	data = *cpuusage;
 	unlock_runqueue(cpu);
-#else
-	data = *cpuusage;
-#endif
 
 	return data;
 }
@@ -113,16 +109,12 @@ static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu, u64 val)
 {
 	u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
 
-#ifndef CONFIG_64BIT
 	/*
-	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
+	 * Take rq->lock to make 64-bit write safe
 	 */
 	lock_runqueue(cpu);
 	*cpuusage = val;
 	unlock_runqueue(cpu);
-#else
-	*cpuusage = val;
-#endif
 }
 
 /* return total cpu usage (in nanoseconds) of a group */
