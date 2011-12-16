Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760775Ab1LPUyi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:54:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48989 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964947Ab1LPUv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:51:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Dec 16 12:50:43 2011
Message-Id: <20111216205043.560516284@clark.kroah.org>
User-Agent: quilt/0.50-24.1
Date: Fri, 16 Dec 2011 12:49:47 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Greg KH <greg@kroah.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>
Subject: [14/16] [PATCH 3/3] oprofile, x86: Fix crash when unloading module (timer mode)
In-Reply-To: <20111216205049.GA28030@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <robert.richter@amd.com>

Based on 97f7f81 oprofile, x86: Fix crash when unloading module (nmi timer
mode) upstream.

Fix for stable kernels v2.6.28.y to v2.6.34.y. This patch is for .32.

Oprofile crashs while unlaoding modules and if in timer mode. Timer
mode is the fallback if the architectural initialization fails. The
pointer variable model is then used uninitialzied during exit causing
a NULL pointer dereference.

It can be triggered with kernel parameters oprofile.timer=1 nolapic
used. Happens esp. in virtual machine environments.

oprofile: using timer interrupt.
BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
IP: [<ffffffffa000251f>] op_nmi_exit+0x3d/0x4a [oprofile]
PGD 42ac5e067 PUD 42ac5d067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
last sysfs file: /sys/module/oprofile/refcnt
CPU 0
Modules linked in: oprofile(-)
Pid: 2245, comm: modprobe Not tainted 2.6.32.21-oprofile-x86_64-debug-00038-gf4db115 #69 Anaheim
RIP: 0010:[<ffffffffa000251f>]  [<ffffffffa000251f>] op_nmi_exit+0x3d/0x4a [oprofile]
RSP: 0018:ffff88042d4f9ec8  EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffffffa0005590 RCX: ffff88042d4f9ea8
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000001
RBP: ffff88042d4f9ec8 R08: ffff88042d4f9ee8 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000080
R13: 00000000fffffff5 R14: 0000000000000001 R15: 00000000006101e0
FS:  00007fef6ac9c700(0000) GS:ffff880028200000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000028 CR3: 000000042ac60000 CR4: 00000000000006f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process modprobe (pid: 2245, threadinfo ffff88042d4f8000, task ffff88042cd66040)
Stack:
 ffff88042d4f9ed8 ffffffffa0002096 ffff88042d4f9ee8 ffffffffa0003bbb
<0> ffff88042d4f9f78 ffffffff810748ad 656c69666f72706f 00007fff77a07800
<0> ffff88042d4f9f28 ffffffff81068414 000000000060f180 0000000000000000
Call Trace:
 [<ffffffffa0002096>] oprofile_arch_exit+0xe/0x10 [oprofile]
 [<ffffffffa0003bbb>] oprofile_exit+0x13/0x15 [oprofile]
 [<ffffffff810748ad>] sys_delete_module+0x1cd/0x244
 [<ffffffff81068414>] ? trace_hardirqs_on_caller+0x114/0x13f
 [<ffffffff8143ad47>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8100b13b>] system_call_fastpath+0x16/0x1b
Code: 48 c7 c7 90 4e 00 a0 e8 e7 15 22 e1 48 c7 c7 e0 4e 00 a0 e8 bd 18 22 e1 48 c7 c7 70 4e 00 a0 e8 94 4e 41 e1 48 8b 05 d1 39 00 00 <48> 8b 40 28 48 85 c0 74 02 ff d0 c9 c3 55 48 89 e5 e8 cb 88 00
RIP  [<ffffffffa000251f>] op_nmi_exit+0x3d/0x4a [oprofile]
 RSP <ffff88042d4f9ec8>
CR2: 0000000000000028
---[ end trace 18b12420ceb19193 ]---

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/x86/oprofile/nmi_int.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -750,12 +750,12 @@ int __init op_nmi_init(struct oprofile_o
 
 void op_nmi_exit(void)
 {
-	if (using_nmi) {
-		exit_sysfs();
+	if (!using_nmi)
+		return;
+	exit_sysfs();
 #ifdef CONFIG_SMP
-		unregister_cpu_notifier(&oprofile_cpu_nb);
+	unregister_cpu_notifier(&oprofile_cpu_nb);
 #endif
-	}
 	if (model->exit)
 		model->exit();
 }


