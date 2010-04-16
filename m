Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0DPGXQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 02:23:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:40155 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab0DPGXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 02:23:15 -0400
Message-ID: <4BC8024E.6020006@petalogix.com>
Date: Fri, 16 Apr 2010 08:23:10 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: wuzhangjin@gmail.com, Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: sched_clock - microblaze
References: <4BC728DD.5020404@petalogix.com> <1271355179.20625.107.camel@falcon> <4BC76917.9060604@petalogix.com> <201004152152.03883.arnd@arndb.de>
In-Reply-To: <201004152152.03883.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 15 April 2010 21:29:27 Michal Simek wrote:
>>> sched_clock() {
>>>       ftrace_stop();
>>>       printk(...);
>>>       ftrace_start();
>>>       ...
>>> }
>> But I am describing different problem. sched_clock is called before 
>> kernel initialized timers. Microblaze takes all information from DTS 
>> that's means that I am not able to read timer because I even don't know 
>> where it is. :-(
> 
> You could make sched_clock return zero before the clock is probed, it
> is very unlikely to be needed before that anyway.

First of all - this technique works.

That calling sequence is
main.c: sched_init() -> sched.c: sched_init(); -> init_idle(); -> 
sched_clock() without initialized timer which is causing my problems.

Why is sched_clock called in init_idle? Do you get any non zero value on 
any ARCH?

Thanks,
Michal

diff --git a/kernel/sched.c b/kernel/sched.c
index 6af210a..bddd918 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5244,7 +5244,7 @@ void __cpuinit init_idle(struct task_struct *idle, 
int cpu)

         __sched_fork(idle);
         idle->state = TASK_RUNNING;
-       idle->se.exec_start = sched_clock();
+       idle->se.exec_start = 0;

         cpumask_copy(&idle->cpus_allowed, cpumask_of(cpu));
         __set_task_cpu(idle, cpu);

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
