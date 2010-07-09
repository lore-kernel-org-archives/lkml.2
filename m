Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159Ab0GIWdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 18:33:21 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59736 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753655Ab0GIWdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 18:33:20 -0400
From: Darren Hart <dvhltc@us.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>,
       linux-rt-users@vger.kernel.org
Subject: [PATCH 0/4][RT] futex: fix tasks blocking on two rt_mutex locks
Date: Fri,  9 Jul 2010 15:32:56 -0700
Message-Id: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set address the following problem reported by Mike Galbraith:

> Stress testing, looking to trigger RCU stalls, I've managed to find a
> way to repeatably create fireworks.  (got RCU stall, see attached)
> 
> 1. download ltp-full-20100630.  Needs to be this version because of
> testcase bustage in earlier versions, and must be built with gcc > 4.3,
> else testcases will segfault due to a gcc bug. 
> 
> 2. apply patchlet so you can run testcases/realtime/perf/latency/run.sh
> at all.
> 
> --- pthread_cond_many.c.org	2010-07-05 09:05:59.000000000 +0200
> +++ pthread_cond_many.c	2010-07-04 12:12:25.000000000 +0200
> @@ -259,7 +259,7 @@ void usage(void)
>  
>  int parse_args(int c, char *v)
>  {
> -	int handled;
> +	int handled = 1;
>          switch (c) {
>  		case 'h':
>  			usage();
> 
> 3. add --realtime for no particular reason.
> 
> --- run.sh.org	2010-07-06 15:54:58.000000000 +0200
> +++ run.sh	2010-07-06 16:37:34.000000000 +0200
> @@ -22,7 +22,7 @@ make
>  # process to run realtime.  The remainder of the processes (if any)
>  # will run non-realtime in any case.
>  
> -nthread=5000
> +nthread=500
>  iter=400
>  nproc=5
>  
> @@ -39,7 +39,7 @@ i=0
>  i=1
>  while test $i -lt $nproc
>  do
> -        ./pthread_cond_many --broadcast -i $iter -n $nthread > $nthread.$iter.$nproc.$i.out &
> +        ./pthread_cond_many --realtime --broadcast -i $iter -n $nthread > $nthread.$iter.$nproc.$i.out &
>          i=`expr $i + 1`
>  done
>  wait

The LTP wreckage will be addressed separately <ugh>

> 4. run it.
> 
> What happens here is we hit WARN_ON(pendowner->pi_blocked_on != waiter),
> this does not make it to consoles (poking sysrq-foo doesn't either).
> Next comes WARN_ON(!pendowner->pi_blocked_on), followed by the NULL
> explosion, which does make it to consoles.
> 
> With explosion avoidance, I also see pendowner->pi_blocked_on->task ==
> NULL at times, but that, as !pendowner->pi_blocked_on, seems to be
> fallout.  The start of bad juju is always pi_blocked_on != waiter.
> 
> [  141.609268] BUG: unable to handle kernel NULL pointer dereference at 0000000000000058
> [  141.609268] IP: [<ffffffff8106856d>] wakeup_next_waiter+0x12c/0x177
> [  141.609268] PGD 20e174067 PUD 20e253067 PMD 0 
> [  141.609268] Oops: 0000 [#1] PREEMPT SMP 
> [  141.609268] last sysfs file: /sys/devices/system/cpu/cpu3/cache/index2/shared_cpu_map
> [  141.609268] CPU 0 
> [  141.609268] Pid: 8154, comm: pthread_cond_ma Tainted: G        W  2.6.33.6-rt23 #12 MS-7502/MS-7502
> [  141.609268] RIP: 0010:[<ffffffff8106856d>]  [<ffffffff8106856d>] wakeup_next_waiter+0x12c/0x177
> [  141.609268] RSP: 0018:ffff88020e3cdd78  EFLAGS: 00010097
> [  141.609268] RAX: 0000000000000000 RBX: ffff8801e8eba5c0 RCX: 0000000000000000
> [  141.609268] RDX: ffff880028200000 RSI: 0000000000000046 RDI: 0000000000000009
> [  141.609268] RBP: ffff88020e3cdda8 R08: 0000000000000002 R09: 0000000000000000
> [  141.609268] R10: 0000000000000005 R11: 0000000000000000 R12: ffffffff81659068
> [  141.609268] R13: ffff8801e8ebdb58 R14: 0000000000000000 R15: ffff8801e8ebac08
> [  141.609268] FS:  00007f664d539700(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
> [  141.609268] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  141.609268] CR2: 0000000000000058 CR3: 0000000214266000 CR4: 00000000000006f0
> [  141.609268] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [  141.609268] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [  141.609268] Process pthread_cond_ma (pid: 8154, threadinfo ffff88020e3cc000, task ffff88020e2a4700)
> [  141.609268] Stack:
> [  141.609268]  0000000000000000 ffffffff81659068 0000000000000202 0000000000000000
> [  141.609268] <0> 0000000000000000 0000000080001fda ffff88020e3cddc8 ffffffff812fec48
> [  141.609268] <0> ffffffff81659068 0000000000606300 ffff88020e3cddd8 ffffffff812ff1b9
> [  141.609268] Call Trace:
> [  141.609268]  [<ffffffff812fec48>] rt_spin_lock_slowunlock+0x43/0x61
> [  141.609268]  [<ffffffff812ff1b9>] rt_spin_unlock+0x46/0x48
> [  141.609268]  [<ffffffff81067d7f>] do_futex+0x83c/0x935
> [  141.609268]  [<ffffffff810c26ce>] ? handle_mm_fault+0x6de/0x6f1
> [  141.609268]  [<ffffffff81067e36>] ? do_futex+0x8f3/0x935
> [  141.609268]  [<ffffffff81067fba>] sys_futex+0x142/0x154
> [  141.609268]  [<ffffffff81020eb0>] ? do_page_fault+0x23e/0x28e
> [  141.609268]  [<ffffffff81004aa7>] ? math_state_restore+0x3d/0x3f
> [  141.609268]  [<ffffffff81004b08>] ? do_device_not_available+0xe/0x12
> [  141.609268]  [<ffffffff81002c5b>] system_call_fastpath+0x16/0x1b
> [  141.609268] Code: c7 09 6d 41 81 e8 ac 34 fd ff 4c 39 ab 70 06 00 00 74 11 be 47 02 00 00 48 c7 c7 09 6d 41 81 e8 92 34 fd ff 48 8b 83 70 06 00 00 <4c> 39 60 58 74 11 be 48 02 00 00 48 c7 c7 09 6d 41 81 e8 74 34 
> [  141.609268] RIP  [<ffffffff8106856d>] wakeup_next_waiter+0x12c/0x177
> [  141.609268]  RSP <ffff88020e3cdd78>
> [  141.609268] CR2: 0000000000000058
> [  141.609268] ---[ end trace 58805b944e6f93ce ]---
> [  141.609268] note: pthread_cond_ma[8154] exited with preempt_count 2


