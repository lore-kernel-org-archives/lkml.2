Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab1EWRBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:01:49 -0400
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:45844
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932143Ab1EWRBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:01:46 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zzbb2cK148cM1432N98dKzz1202hzz8275bh8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LLNRAP-01-1A0-02
X-M-MSG: 
Date: Mon, 23 May 2011 19:01:36 +0200
From: Robert Richter <robert.richter@amd.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: sleeping while atomic warning while modprobing oprofile.
Message-ID: <20110523170136.GO20052@erda.amd.com>
References: <20110518191706.GA20475@redhat.com>
 <20110520034724.GA20052@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110520034724.GA20052@erda.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.05.11 05:47:24, Robert Richter wrote:
> On 18.05.11 15:17:06, Dave Jones wrote:
> > I just saw this when after I did a 'modprobe oprofile' on my amd64 box.
> 
> Thanks for reporting this. This happens in init_ibs(). We are actually
> too strict here with disabling preemption, though we still need it.
> Will change that code.
> 
> -Robert
> 
> > 
> > 	Dave
> > 
> > BUG: sleeping function called from invalid context at mm/slub.c:824
> > in_atomic(): 1, irqs_disabled(): 0, pid: 32357, name: modprobe
> > INFO: lockdep is turned off.
> > Pid: 32357, comm: modprobe Not tainted 2.6.39-rc7+ #14
> > Call Trace:
> >  [<ffffffff8104bdc8>] __might_sleep+0x112/0x117
> >  [<ffffffff81129693>] kmem_cache_alloc_trace+0x4b/0xe7
> >  [<ffffffff81278f14>] kzalloc.constprop.0+0x29/0x2b
> >  [<ffffffff81278f4c>] pci_get_subsys+0x36/0x78
> >  [<ffffffff81022689>] ? setup_APIC_eilvt+0xfb/0x139
> >  [<ffffffff81278fa4>] pci_get_device+0x16/0x18
> >  [<ffffffffa06c8b5d>] op_amd_init+0xd3/0x211 [oprofile]
> >  [<ffffffffa064d000>] ? 0xffffffffa064cfff
> >  [<ffffffffa064d298>] op_nmi_init+0x21e/0x26a [oprofile]
> >  [<ffffffffa064d062>] oprofile_arch_init+0xe/0x26 [oprofile]
> >  [<ffffffffa064d010>] oprofile_init+0x10/0x42 [oprofile]
> >  [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
> >  [<ffffffff81096524>] sys_init_module+0x132/0x281
> >  [<ffffffff814cc682>] system_call_fastpath+0x16/0x1b

Dave,

the patch below should fix this.

-Robert


>From 3d2606f42984613d324ad3047cf503bcddc3880a Mon Sep 17 00:00:00 2001
From: Robert Richter <robert.richter@amd.com>
Date: Fri, 20 May 2011 09:46:54 +0200
Subject: [PATCH] oprofile, x86: Enable preemption during pci device setup in
 IBS init

IBS initialization is a mix of per-core register access and per-node
pci device setup. Register access should be pinned to the cpu, but pci
setup must run with preemption enabled.

This patch better separates the code into non-/preemptible sections
and fixes sleeping with preemption disabled. See bug message below.

Fixes also freeing the eilvt entry by introducing put_eilvt().

BUG: sleeping function called from invalid context at mm/slub.c:824
in_atomic(): 1, irqs_disabled(): 0, pid: 32357, name: modprobe
INFO: lockdep is turned off.
Pid: 32357, comm: modprobe Not tainted 2.6.39-rc7+ #14
Call Trace:
 [<ffffffff8104bdc8>] __might_sleep+0x112/0x117
 [<ffffffff81129693>] kmem_cache_alloc_trace+0x4b/0xe7
 [<ffffffff81278f14>] kzalloc.constprop.0+0x29/0x2b
 [<ffffffff81278f4c>] pci_get_subsys+0x36/0x78
 [<ffffffff81022689>] ? setup_APIC_eilvt+0xfb/0x139
 [<ffffffff81278fa4>] pci_get_device+0x16/0x18
 [<ffffffffa06c8b5d>] op_amd_init+0xd3/0x211 [oprofile]
 [<ffffffffa064d000>] ? 0xffffffffa064cfff
 [<ffffffffa064d298>] op_nmi_init+0x21e/0x26a [oprofile]
 [<ffffffffa064d062>] oprofile_arch_init+0xe/0x26 [oprofile]
 [<ffffffffa064d010>] oprofile_init+0x10/0x42 [oprofile]
 [<ffffffff81002099>] do_one_initcall+0x7f/0x13a
 [<ffffffff81096524>] sys_init_module+0x132/0x281
 [<ffffffff814cc682>] system_call_fastpath+0x16/0x1b

Reported-by: Dave Jones <davej@redhat.com>
Cc: <stable@kernel.org>         [2.6.37.x]
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/oprofile/op_model_amd.c |   95 +++++++++++++++++++++----------------
 1 files changed, 54 insertions(+), 41 deletions(-)

diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index c3b8e24..9fd8a56 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -316,16 +316,23 @@ static void op_amd_stop_ibs(void)
 		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
-static inline int eilvt_is_available(int offset)
+static inline int get_eilvt(int offset)
 {
-	/* check if we may assign a vector */
 	return !setup_APIC_eilvt(offset, 0, APIC_EILVT_MSG_NMI, 1);
 }
 
+static inline int put_eilvt(int offset)
+{
+	return !setup_APIC_eilvt(offset, 0, 0, 1);
+}
+
 static inline int ibs_eilvt_valid(void)
 {
 	int offset;
 	u64 val;
+	int valid = 0;
+
+	preempt_disable();
 
 	rdmsrl(MSR_AMD64_IBSCTL, val);
 	offset = val & IBSCTL_LVT_OFFSET_MASK;
@@ -333,16 +340,20 @@ static inline int ibs_eilvt_valid(void)
 	if (!(val & IBSCTL_LVT_OFFSET_VALID)) {
 		pr_err(FW_BUG "cpu %d, invalid IBS interrupt offset %d (MSR%08X=0x%016llx)\n",
 		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		return 0;
+		goto out;
 	}
 
-	if (!eilvt_is_available(offset)) {
+	if (!get_eilvt(offset)) {
 		pr_err(FW_BUG "cpu %d, IBS interrupt offset %d not available (MSR%08X=0x%016llx)\n",
 		       smp_processor_id(), offset, MSR_AMD64_IBSCTL, val);
-		return 0;
+		goto out;
 	}
 
-	return 1;
+	valid = 1;
+out:
+	preempt_enable();
+
+	return valid;
 }
 
 static inline int get_ibs_offset(void)
@@ -600,67 +611,69 @@ static int setup_ibs_ctl(int ibs_eilvt_off)
 
 static int force_ibs_eilvt_setup(void)
 {
-	int i;
+	int offset;
 	int ret;
 
-	/* find the next free available EILVT entry */
-	for (i = 1; i < 4; i++) {
-		if (!eilvt_is_available(i))
-			continue;
-		ret = setup_ibs_ctl(i);
-		if (ret)
-			return ret;
-		pr_err(FW_BUG "using offset %d for IBS interrupts\n", i);
-		return 0;
+	/*
+	 * find the next free available EILVT entry, skip offset 0,
+	 * pin search to this cpu
+	 */
+	preempt_disable();
+	for (offset = 1; offset < APIC_EILVT_NR_MAX; offset++) {
+		if (get_eilvt(offset))
+			break;
 	}
+	preempt_enable();
 
-	printk(KERN_DEBUG "No EILVT entry available\n");
-
-	return -EBUSY;
-}
-
-static int __init_ibs_nmi(void)
-{
-	int ret;
-
-	if (ibs_eilvt_valid())
-		return 0;
+	if (offset == APIC_EILVT_NR_MAX) {
+		printk(KERN_DEBUG "No EILVT entry available\n");
+		return -EBUSY;
+	}
 
-	ret = force_ibs_eilvt_setup();
+	ret = setup_ibs_ctl(offset);
 	if (ret)
-		return ret;
+		goto out;
 
-	if (!ibs_eilvt_valid())
-		return -EFAULT;
+	if (!ibs_eilvt_valid()) {
+		ret = -EFAULT;
+		goto out;
+	}
 
+	pr_err(FW_BUG "using offset %d for IBS interrupts\n", offset);
 	pr_err(FW_BUG "workaround enabled for IBS LVT offset\n");
 
 	return 0;
+out:
+	preempt_disable();
+	put_eilvt(offset);
+	preempt_enable();
+	return ret;
 }
 
 /*
  * check and reserve APIC extended interrupt LVT offset for IBS if
  * available
- *
- * init_ibs() preforms implicitly cpu-local operations, so pin this
- * thread to its current CPU
  */
 
 static void init_ibs(void)
 {
-	preempt_disable();
-
 	ibs_caps = get_ibs_caps();
+
 	if (!ibs_caps)
+		return;
+
+	if (ibs_eilvt_valid())
 		goto out;
 
-	if (__init_ibs_nmi() < 0)
-		ibs_caps = 0;
-	else
-		printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
+	if (!force_ibs_eilvt_setup())
+		goto out;
+
+	/* Failed to setup ibs */
+	ibs_caps = 0;
+	return;
 
 out:
-	preempt_enable();
+	printk(KERN_INFO "oprofile: AMD IBS detected (0x%08x)\n", ibs_caps);
 }
 
 static int (*create_arch_files)(struct super_block *sb, struct dentry *root);
-- 
1.7.5.rc3



-- 
Advanced Micro Devices, Inc.
Operating System Research Center

