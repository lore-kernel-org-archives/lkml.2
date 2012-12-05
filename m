Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2LEEwx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 23:52:53 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:22037
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735Ab2LEEwt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 23:52:49 -0500
X-Forefront-Antispam-Report: CIP:160.33.194.229;KIP:(null);UIP:(null);IPV:NLI;H:usculsndmail02v.am.sony.com;RD:mail02.sonyusa.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1d1ah1d2ahzz8275bhz2fh2a8h668h839h947hd25hf0ah10d2h1288h12a5h12a9h12bdh137ah13b6h1441h1537h153bh162dh1631h1155h)
Message-ID: <50BED320.3060204@am.sony.com>
Date: Tue, 4 Dec 2012 20:52:48 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "dipankar@in.ibm.com" <dipankar@in.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RT 0/2][RFC] fix RCU stall warning on ARM
References: <50BED1DA.7070907@am.sony.com>
In-Reply-To: <50BED1DA.7070907@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch should __not__ be committed to the RT_PREEMPT tree.

Test scaffolding to force printing of rcu detected stall.  Each time the
specified value is echoed into the proc file, the routine to be tested
will be called one time, from the context it would normally be called from.

   # test print_cpu_stall()
   echo 1 > /proc/sys/kernel/zzz_debug_print_stall_once
   
   # test print_other_cpu_stall()
   echo 2 > /proc/sys/kernel/zzz_debug_print_stall_once


Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 kernel/rcutree.c |   26 	26 +	0 -	0 !
 kernel/sysctl.c  |   11 	11 +	0 -	0 !
 2 files changed, 37 insertions(+)

Index: b/kernel/rcutree.c
===================================================================
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -738,6 +738,7 @@ static void record_gp_stall_check_time(s
 	rsp->jiffies_stall = jiffies + jiffies_till_stall_check();
 }
 
+int zzz_debug_print_other_cpu_stall;
 static void print_other_cpu_stall(struct rcu_state *rsp)
 {
 	int cpu;
@@ -750,10 +751,12 @@ static void print_other_cpu_stall(struct
 
 	raw_spin_lock_irqsave(&rnp->lock, flags);
 	delta = jiffies - rsp->jiffies_stall;
+if (!zzz_debug_print_other_cpu_stall) {
 	if (delta < RCU_STALL_RAT_DELAY || !rcu_gp_in_progress(rsp)) {
 		raw_spin_unlock_irqrestore(&rnp->lock, flags);
 		return;
 	}
+}
 	rsp->jiffies_stall = jiffies + 3 * jiffies_till_stall_check() + 3;
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
@@ -792,6 +795,10 @@ static void print_other_cpu_stall(struct
 	ndetected += rcu_print_task_stall(rnp);
 	raw_spin_unlock_irqrestore(&rnp->lock, flags);
 
+if (zzz_debug_print_other_cpu_stall) {
+	ndetected += 1;
+}
+
 	print_cpu_stall_info_end();
 	printk(KERN_CONT "(detected by %d, t=%ld jiffies)\n",
 	       smp_processor_id(), (long)(jiffies - rsp->gp_start));
@@ -843,6 +850,7 @@ static void print_cpu_stall(struct rcu_s
 	set_need_resched();  /* kick ourselves to get things going. */
 }
 
+int zzz_debug_print_stall_once;
 static void check_cpu_stall(struct rcu_state *rsp, struct rcu_data *rdp)
 {
 	unsigned long j;
@@ -851,6 +859,24 @@ static void check_cpu_stall(struct rcu_s
 
 	if (rcu_cpu_stall_suppress)
 		return;
+
+	if (zzz_debug_print_stall_once) {
+		int tmp = zzz_debug_print_stall_once;
+		zzz_debug_print_stall_once = 0;
+		if (tmp & 0x1) {
+			pr_crit("\n\n*****  DEBUG -- test print_cpu_stall():\n\n");
+			print_cpu_stall(rsp);
+		}
+		if (tmp & 0x2) {
+			pr_crit("\n\n*****  DEBUG -- test print_other_cpu_stall():\n\n");
+			zzz_debug_print_other_cpu_stall = 1;
+			print_other_cpu_stall(rsp);
+			zzz_debug_print_other_cpu_stall = 0;
+		}
+
+		return;
+	}
+
 	j = ACCESS_ONCE(jiffies);
 	js = ACCESS_ONCE(rsp->jiffies_stall);
 	rnp = rdp->mynode;
Index: b/kernel/sysctl.c
===================================================================
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -132,6 +132,8 @@ static int one_hundred = 100;
 static int ten_thousand = 10000;
 #endif
 
+extern int zzz_debug_print_stall_once;
+
 /* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
 static unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
 
@@ -1000,6 +1002,15 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_dointvec,
 	},
 #endif
+#ifdef CONFIG_SMP
+	{
+		.procname	= "zzz_debug_print_stall_once",
+		.data		= &zzz_debug_print_stall_once,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+#endif
 	{ }
 };
 

