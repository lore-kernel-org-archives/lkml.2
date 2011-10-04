Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933687Ab1JDW43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 18:56:29 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38788 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933158Ab1JDW42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 18:56:28 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 4 Oct 2011 23:37:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
From: Julie Sullivan <kernelmail.jms@gmail.com>
Subject: BUG: scheduling while atomic: swapper/0/0x10000002 - spew of 44-odd in all 3.1-rc*
Message-Id: <201110042337.39611.kernelmail.jms@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic and all,

I've been getting a big spew of 
'BUG: scheduling while atomic: swapper/0/0x10000002' messages in dmesg for the 
current -rc series (not in 3.0). Bisecting for this produces two behaviours; 

1 - affected kernels have typically 44 but there can be between 43 - 47 of 
these messages in the log (varying on a per boot basis rather than a per 
kernel basis.) 
All the 3.1-rc* kernels are like this. 
Looking at the call traces most (but not all) of these seem to be acpi-
related.
The traces slightly differ, I wouldn't want to guess what the offending 
functions are.

2 - affected kernels have only one 'BUG: ...' message which seems to always be
the same, at least in the examples I've looked at: 

[    0.000000] Detected 2393.032 MHz processor.
[    0.001003] Calibrating delay loop (skipped), value calculated using timer frequency.. 4786.06 BogoMIPS (lpj=2393032)
[    0.001008] pid_max: default: 32768 minimum: 301
[    0.001012] BUG: scheduling while atomic: swapper/0/0x10000002
[    0.001020] no locks held by swapper/0.
[    0.001022] Modules linked in:
[    0.001026] Pid: 0, comm: swapper Not tainted 3.1.0-rc6 #96
[    0.001028] Call Trace:
[    0.001036]  [<ffffffff8103234e>] __schedule_bug+0x75/0x7a
[    0.001041]  [<ffffffff815c78da>] __schedule+0x95/0x686
[    0.001047]  [<ffffffff8105959d>] ? kzalloc.clone.0+0x29/0x2b                                                             
[    0.001052]  [<ffffffff8103aac0>] __cond_resched+0x2a/0x36                                                                
[    0.001055]  [<ffffffff815c7f28>] _cond_resched+0x1b/0x22                                                                 
[    0.001060]  [<ffffffff81100544>] slab_pre_alloc_hook.clone.28+0x3a/0x40                                                  
[    0.001064]  [<ffffffff81101f09>] kmem_cache_alloc_trace+0x2c/0xec                                                        
[    0.001068]  [<ffffffff8105959d>] kzalloc.clone.0+0x29/0x2b                                                               
[    0.001073]  [<ffffffff81cc1b0a>] pidmap_init+0x6a/0xab                                                                   
[    0.001079]  [<ffffffff81caca7e>] start_kernel+0x2ef/0x37f                                                                
[    0.001083]  [<ffffffff81cac2a6>] x86_64_start_reservations+0xb6/0xba                                                     
[    0.001086]  [<ffffffff81cac39c>] x86_64_start_kernel+0xf2/0xf9                                                           
[    0.002039] Security Framework initialized
[    0.002049] SELinux:  Initializing.



I'll send a copy of a (sample 44-message) dmesg and my .config shortly.
(btw superficially this looks like a problem discussed by Josh Boyer and 
Paul McKenney a few weeks ago but I tried both Josh and Paul's patches and 
neither made a difference.)


Bisecting for the 44-odd message behaviour just results in this merge commit;


commit 1ecc818c51b1f6886825dae3885792d5e49ec798
Merge: 1c09ab0 d902db1
Author: Ingo Molnar <mingo@elte.hu>
Date:   Fri Jul 1 13:20:51 2011 +0200

    Merge branch 'sched/core-v2' of git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing into sched/core



but bisecting for the 1-message behaviour more helpfully results in this:



commit e8f7c70f44f75c827c04239b0ae5f0068b65b76e
Author: Frederic Weisbecker <fweisbec@gmail.com>
Date:   Wed Jun 8 01:51:02 2011 +0200

    sched: Make sleeping inside spinlock detection working in !CONFIG_PREEMPT

    Select CONFIG_PREEMPT_COUNT when we enable the sleeping inside
    spinlock detection, so that the preempt offset gets correctly
    incremented/decremented from preempt_disable()/preempt_enable().

    This makes the preempt count eventually working in !CONFIG_PREEMPT
    when that debug option is set and thus fixes the detection of explicit
    preemption disabled sections under such config. Code that sleeps
    in explicitly preempt disabled section can be finally spotted
    in non-preemptible kernels.

    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
    Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>



so I guess this is not a bug but a change that uncovers other bugs? just 
triggering a load of 'scheduling while atomic' messages which didn't show up 
before. 
Although I can't figure out why if this patch was released in June these 
messages aren't present in 3.0...

Indeed switching from CONFIG_PREEMPT_VOLUNTARY to CONFIG_PREEMPT completely 
gets rid of all of these :-)

As far as I can tell this is a boot-time issue. 
Starting up seems straightforward, one kernel boot hung but I test booted it 
again twice and it was OK. All other kernels I tested when bisecting (more 
than 40) also booted OK.

System behaviour once up seems unaffected, which is why I didn't take it 
especially seriously. 
Is this just noise?

Cheers
Julie
