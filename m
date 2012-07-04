Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab2GDNA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 09:00:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:61250 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752032Ab2GDNAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:00:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="163974924"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: "'linux-kernel@vger.kernel.org' (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
CC: "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "kay@vrfy.org" <kay@vrfy.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Topic: [PATCH] printk: fixing the deadlock when calling printk in nmi
 handle
Thread-Index: Ac1Z5QcLvtA63cR2SZCbqgNGHLXbfA==
Date: Wed, 4 Jul 2012 13:00:49 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A10C7F6@SHSMSX101.ccr.corp.intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: liu chuansheng <chuansheng.liu@intel.com>
Subject: [PATCH] printk: fixing the deadlock when calling printk in nmi handle

Current printk implementation can not fully support that
calling it in nmi handler for SMP arch.

There is typical case in nmi handler function arch_trigger_all_cpu_backtrace_handler().

In my platform, there are 2 CPUs, when function arch_trigger_all_cpu_backtrace()
is called, 2 CPUs will recevied the nmi interrupts, and the
arch_trigger_all_cpu_backtrace_handler() will called on 2 CPUs:

case1:
CPU0                                            CPU1
calling arch_trigger_all_cpu_backtrace()        calling printk, and has obtain the logbuf_lock
nmi interrupt received                          nmi interrupt received
call arch_trigger_all_cpu_backtrace_handler()   call arch_trigger_all_cpu_backtrace_handler()
Obtain arch_spin_lock(&lock);                   Waiting for arch_spin_lock(&lock);
Continue to call printk()
CPU0 will be blocked by logbuf_lock             CPU1 is blocked by arch_spin_lock(&lock)

The deadlock will be happening.

case2:
CPU0                                             CPU1:(run dmesg command)
calling arch_trigger_all_cpu_backtrace()         calling do_syslog
                                                 Obtaining the logbuf_lock
nmi interrupt received                           nmi interrupt received
....
The dealock will happen also somtimes.

I just write a simple interface to run the arch_trigger_all_cpu_backtrace_handler() every 5s,
it will trigger dead lock many times.

The solution is when printk is called in nmi handler, we will use trylock instead of lock.
And in nmi handler, do the call the console write function because normal console write function
include many spin locks also. This fix can confirm the traces in nmi handler can be output successfully
almost.

Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
---
 kernel/printk.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index dba1821..de68e24 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1275,7 +1275,7 @@ static int console_trylock_for_printk(unsigned int cpu)
 {
        int retval = 0, wake = 0;
 
-       if (console_trylock()) {
+       if (!in_nmi() && console_trylock()) {
                retval = 1;
 
                /*
@@ -1432,7 +1432,13 @@ asmlinkage int vprintk_emit(int facility, int level,
        }
 
        lockdep_off();
-       raw_spin_lock(&logbuf_lock);
+       if(unlikely(in_nmi())) {
+               if(!raw_spin_trylock(&logbuf_lock))
+                       goto out_restore_lockdep_irqs;
+       } else {
+               raw_spin_lock(&logbuf_lock);
+       }
+
        logbuf_cpu = this_cpu;
 
        if (recursion_bug) {
@@ -1524,6 +1530,7 @@ asmlinkage int vprintk_emit(int facility, int level,
        if (console_trylock_for_printk(this_cpu))
                console_unlock();
 
+out_restore_lockdep_irqs:
        lockdep_on();
 out_restore_irqs:
        local_irq_restore(flags);
-- 
1.7.0.4
