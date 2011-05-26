Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1EZFKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 01:10:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57592 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1EZFKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 01:10:43 -0400
Message-ID: <4DDDE094.6050505@kernel.org>
Date: Wed, 25 May 2011 22:09:40 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] irq: remove smp_affinity_list when unregister irq proc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DDDE0A9.0128,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


got:
[  274.239264] ------------[ cut here ]------------
[  274.239500] WARNING: at fs/proc/generic.c:850 remove_proc_entry+0x24c/0x27a()
[  274.251761] remove_proc_entry: removing non-empty directory 'irq/184', leaking at least 'smp_affinity_list'
[  274.271696] Modules linked in:
[  274.271880] Pid: 1, comm: swapper Tainted: G        W   2.6.39-tip-yh-07723-gf48dc10-dirty #1051
[  274.291734] Call Trace:
[  274.291892]  [<ffffffff8107cfa8>] warn_slowpath_common+0x85/0x9d
[  274.311582]  [<ffffffff8107d063>] warn_slowpath_fmt+0x46/0x48
[  274.311874]  [<ffffffff8118994e>] remove_proc_entry+0x24c/0x27a
[  274.331549]  [<ffffffff813336ca>] ? vsnprintf+0x3ed/0x429
[  274.331798]  [<ffffffff81333746>] ? sprintf+0x40/0x42
[  274.351430]  [<ffffffff810cde65>] unregister_irq_proc+0xb5/0xd2
[  274.351715]  [<ffffffff810ca64b>] free_desc+0x22/0x61
[  274.371461]  [<ffffffff810ca6c5>] irq_free_descs+0x3b/0x73
[  274.371738]  [<ffffffff81053bb3>] free_irq_at+0x31/0x36
[  274.391409]  [<ffffffff810553e6>] destroy_irq+0x74/0x7c
[  274.391662]  [<ffffffff81055619>] native_teardown_msi_irq+0xe/0x10
[  274.411407]  [<ffffffff8136239c>] default_teardown_msi_irqs+0x57/0x79
[  274.411735]  [<ffffffff81361c49>] free_msi_irqs+0x84/0xe2
[  274.431394]  [<ffffffff8136294d>] pci_disable_msi+0x35/0x39
[  274.431678]  [<ffffffff816574e2>] e1000e_reset_interrupt_capability+0x55/0x63
[  274.451420]  [<ffffffff81657701>] e1000_test_msi_interrupt+0x30/0x114
[  274.451749]  [<ffffffff81657853>] e1000_test_msi+0x6e/0xc5
[  274.471429]  [<ffffffff81658add>] e1000_open+0x10f/0x1e2
[  274.471731]  [<ffffffff81afed63>] __dev_open+0x9c/0xca
[  274.491282]  [<ffffffff81afef9d>] __dev_change_flags+0xad/0x130
[  274.491561]  [<ffffffff81aff0a1>] dev_change_flags+0x21/0x56
[  274.511370]  [<ffffffff82737d6b>] ic_open_devs+0xe3/0x233
[  274.511637]  [<ffffffff827394cf>] ip_auto_config+0xa5/0x2c0
[  274.531432]  [<ffffffff8273942a>] ? root_nfs_parse_addr+0xb5/0xb5
[  274.531780]  [<ffffffff810002cf>] do_one_initcall+0x57/0x134
[  274.551599]  [<ffffffff826ecf91>] kernel_init+0x137/0x1bb
[  274.551884]  [<ffffffff81c2e354>] kernel_thread_helper+0x4/0x10
[  274.571423]  [<ffffffff81c268c0>] ? retint_restore_args+0xe/0xe
[  274.591165]  [<ffffffff826ece5a>] ? start_kernel+0x3d3/0x3d3
[  274.591483]  [<ffffffff81c2e350>] ? gs_change+0xb/0xb
[  274.611129] ---[ end trace e07c035be3c974e5 ]---

caused by:
| commit 4b060420a596095869a6d7849caa798d23839cd1
| Author: Mike Travis <travis@sgi.com>
| Date:   Tue May 24 17:13:12 2011 -0700
|
|    bitmap, irq: add smp_affinity_list interface to /proc/irq

it forgets to remove it in exit path

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 kernel/irq/proc.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/kernel/irq/proc.c
===================================================================
--- linux-2.6.orig/kernel/irq/proc.c
+++ linux-2.6/kernel/irq/proc.c
@@ -352,6 +352,7 @@ void unregister_irq_proc(unsigned int ir
 #ifdef CONFIG_SMP
 	remove_proc_entry("smp_affinity", desc->dir);
 	remove_proc_entry("affinity_hint", desc->dir);
+	remove_proc_entry("smp_affinity_list", desc->dir);
 	remove_proc_entry("node", desc->dir);
 #endif
 	remove_proc_entry("spurious", desc->dir);
