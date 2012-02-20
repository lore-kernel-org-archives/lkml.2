Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab2BTO7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:59:34 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56649 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2BTO7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:59:32 -0500
Date: Mon, 20 Feb 2012 15:59:20 +0100
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RAS trace event proto
Message-ID: <20120220145920.GB5728@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

here's a dirty patch which should hopefully show what I have in mind wrt
using tracepoints for RAS events. The code compiles and should only give
an initial idea, it is subject to significant changes until it reaches
its final form thus it is only exemplary and not final in any case.

Notes:

* So there are two RAS tracepoints: trace_mce_record which dumps the
MCE-related errors + their decoded info and trace_hw_error which simply
carries a string to userspace. The second one can be used for non-MCA
errors.

* When prepping the string for the tracepoint, we cache the string by
calling ras_printk which buffers the so-far done string internally,
so everything that wants to dump into it needs to be converted to use
ras_printk.

* Which brings me to it: ras_printk() is x86-only and it could probably
be moved to an arch-agnostic place for the other arches. I'd leave it
x86-only for now, for testing purposes, and then later the other arches
could consider using it (this is wrt non-x86 EDAC drivers).

* When writing a 1 into /sys/devices/system/ras/agent, we enable the
string buffering functionality - this could be done by the RAS daemon or
whatever agent is requesting putting hw errors info into tracing.

* I'd like to have conditional printk-ing in trace_mce_record depending
on the TP args, Steve probably knows what can be done:

@Steven:

I'd like to do the following:

	TP_printk("%s, ARG1: %d, ARG2: %c ...", str1, arg1, arg2)

and have it print only the first arg, i.e. the string and drop the rest
of the args while still doing the TP_fast_assign into the ring buffer
and carrying the stuff to its consumers. Background is that I want to
dump the decoded string of a hardware error, if it is decoded, but carry
the MCE info to userspace and only dump the fields of the MCE if I
haven't managed to decode it, i.e. str1 == "".

So, my question is, can I do something like:

	TP_printk("%s, ARG1: %d, ARG2: %c ...", __print_conditional(str1, arg1, arg2))

where __print_conditional is a vararg macro which calls a
ftrace_print_cond() which prints only str1 if strlen(str1) > 0 and
otherwise calls a vsnprintf() variant to deal with the va_args?

As always, all comments are welcome.

--
>From e06143929d7d6cbed7bec1a7f4976f595a2537da Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Mon, 20 Feb 2012 14:52:19 +0100
Subject: [PATCH] RAS trace event proto

---
 arch/x86/Kconfig                 |    9 ++
 arch/x86/Makefile                |    3 +
 arch/x86/include/asm/ras.h       |   17 +++
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 arch/x86/ras/Makefile            |    1 +
 arch/x86/ras/ras.c               |  121 +++++++++++++++++++++
 drivers/edac/amd64_edac.c        |    8 +-
 drivers/edac/edac_mc.c           |    9 ++-
 drivers/edac/mce_amd.c           |  218 ++++++++++++++++++++------------------
 include/trace/events/mce.h       |   26 ++++-
 10 files changed, 306 insertions(+), 108 deletions(-)
 create mode 100644 arch/x86/include/asm/ras.h
 create mode 100644 arch/x86/ras/Makefile
 create mode 100644 arch/x86/ras/ras.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e189fa..bda1480241b2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -657,6 +657,15 @@ config X86_CYCLONE_TIMER
 	def_bool y
 	depends on X86_SUMMIT
 
+config X86_RAS
+	def_bool y
+	prompt "X86 RAS features"
+	---help---
+	A collection of Reliability, Availability and Serviceability
+	software features which aim to enable hardware error logging
+	and reporting. Leave it at 'y' unless you really know what
+	you're doing
+
 source "arch/x86/Kconfig.cpu"
 
 config HPET_TIMER
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 209ba1294592..a6b6bb1f308b 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -146,6 +146,9 @@ drivers-$(CONFIG_OPROFILE) += arch/x86/oprofile/
 # suspend and hibernation support
 drivers-$(CONFIG_PM) += arch/x86/power/
 
+# RAS support
+core-y += arch/x86/ras/
+
 drivers-$(CONFIG_FB) += arch/x86/video/
 
 ####
diff --git a/arch/x86/include/asm/ras.h b/arch/x86/include/asm/ras.h
new file mode 100644
index 000000000000..27333cfd7534
--- /dev/null
+++ b/arch/x86/include/asm/ras.h
@@ -0,0 +1,17 @@
+#ifndef _ASM_X86_RAS_H
+#define _ASM_X86_RAS_H
+
+#define ERR_STRING_SZ 200
+
+extern bool ras_agent;
+extern char *decoded_err_str;
+
+enum ras_printk_flags {
+	PR_EMERG	= 0,
+	PR_WARNING	= 1,
+	PR_CONT		= 2,
+	RAS_EOFLAGS,
+};
+extern void ras_printk(enum ras_printk_flags flags, const char *fmt, ...);
+
+#endif /* _ASM_X86_RAS_H */
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2e9e91..072e020ecaf3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -144,7 +144,7 @@ void mce_log(struct mce *mce)
 	int ret = 0;
 
 	/* Emit the trace record: */
-	trace_mce_record(mce);
+	trace_mce_record("", mce);
 
 	ret = atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, mce);
 	if (ret == NOTIFY_STOP)
diff --git a/arch/x86/ras/Makefile b/arch/x86/ras/Makefile
new file mode 100644
index 000000000000..7a70bb5cd057
--- /dev/null
+++ b/arch/x86/ras/Makefile
@@ -0,0 +1 @@
+obj-y		:= ras.o
diff --git a/arch/x86/ras/ras.c b/arch/x86/ras/ras.c
new file mode 100644
index 000000000000..64099a03ea32
--- /dev/null
+++ b/arch/x86/ras/ras.c
@@ -0,0 +1,121 @@
+#include <linux/types.h>
+#include <linux/device.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <asm/ras.h>
+
+#define ERR_STRING_SZ 200
+char *decoded_err_str;
+static unsigned dec_len;
+
+/*
+ * If true, userspace has an agent running and eating all the
+ * tracing data we're sending out so there's no dmesg output
+ */
+bool ras_agent;
+EXPORT_SYMBOL_GPL(ras_agent);
+
+void ras_printk(enum ras_printk_flags flags, const char *fmt, ...)
+{
+	va_list args;
+	char *buf;
+	unsigned cur_sz;
+	int i;
+
+	if (dec_len >= ERR_STRING_SZ-1)
+		return;
+
+	buf = decoded_err_str + dec_len;
+	cur_sz = ERR_STRING_SZ - dec_len - 1;
+
+	va_start(args, fmt);
+	i = vsnprintf(buf, cur_sz, fmt, args);
+	va_end(args);
+
+	if (i >= cur_sz) {
+		pr_err("Error decode buffer truncated.\n");
+		dec_len = ERR_STRING_SZ-1;
+		decoded_err_str[dec_len] = '\n';
+	} else
+		dec_len += i;
+
+	if (!ras_agent) {
+		if (flags == PR_EMERG)
+			pr_emerg("%s", buf);
+		if (flags == PR_WARNING)
+			pr_warning("%s", buf);
+		else if (flags == PR_CONT)
+			pr_cont("%s", buf);
+	}
+}
+EXPORT_SYMBOL_GPL(ras_printk);
+
+struct bus_type ras_subsys = {
+	.name	  = "ras",
+	.dev_name = "ras",
+};
+
+struct ras_attr {
+	const struct attribute attr;
+	ssize_t (*show) (struct kobject *kobj, struct ras_attr *attr, char *buf);
+	ssize_t (*store)(struct kobject *kobj, struct ras_attr *attr,
+			 const char *buf, size_t count);
+};
+
+#define RAS_ATTR(_name, _mode, _show, _store)	\
+static struct ras_attr ras_attr_##_name = __ATTR(_name, _mode, _show, _store)
+
+static ssize_t ras_agent_show(struct kobject *kobj,
+			      struct ras_attr *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%.1d\n", ras_agent);
+}
+
+static ssize_t ras_agent_store(struct kobject *kobj,
+			       struct ras_attr *attr,
+			       const char *buf, size_t count)
+{
+	int ret = 0;
+	unsigned long value;
+
+	ret = kstrtoul(buf, 10, &value);
+	if (ret < 0) {
+		printk(KERN_ERR "Wrong value for ras_agent field.\n");
+		return ret;
+	}
+
+	ras_agent = !!value;
+
+	return count;
+}
+
+RAS_ATTR(agent, 0644, ras_agent_show, ras_agent_store);
+
+static int __init ras_init(void)
+{
+	int err = 0;
+
+	err = subsys_system_register(&ras_subsys, NULL);
+	if (err) {
+		printk(KERN_ERR "Error registering toplevel RAS sysfs node.\n");
+		return -EINVAL;
+	}
+
+	err = sysfs_create_file(&ras_subsys.dev_root->kobj, &ras_attr_agent.attr);
+	if (err) {
+		printk(KERN_ERR "Error creating %s sysfs node.\n",
+				ras_attr_agent.attr.name);
+		goto err_sysfs_create;
+	}
+
+	return 0;
+
+err_sysfs_create:
+	sysfs_remove_file(&ras_subsys.dev_root->kobj, &ras_attr_agent.attr);
+	bus_unregister(&ras_subsys);
+
+	return -EINVAL;
+
+}
+early_initcall(ras_init);
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c9eee6d33e9a..8a42e591508d 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1,6 +1,7 @@
-#include "amd64_edac.h"
 #include <asm/amd_nb.h>
+#include <asm/ras.h>
 
+#include "amd64_edac.h"
 static struct edac_pci_ctl_info *amd64_ctl_pci;
 
 static int report_gart_errors;
@@ -1901,7 +1902,10 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 	sys_addr = get_error_address(m);
 	syndrome = extract_syndrome(m->status);
 
-	amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
+	if (ras_agent)
+		ras_printk(PR_EMERG, "err addr: 0x%llx", sys_addr);
+	else
+		amd64_mc_err(mci, "CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
 
 	pvt->ops->map_sysaddr_to_csrow(mci, sys_addr, syndrome);
 }
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index ca6c04d350ee..772d712a6f74 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -30,8 +30,10 @@
 #include <asm/uaccess.h>
 #include <asm/page.h>
 #include <asm/edac.h>
+#include <asm/ras.h>
 #include "edac_core.h"
 #include "edac_module.h"
+#include "mce_amd.h"
 
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
@@ -701,7 +703,11 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 		return;
 	}
 
-	if (edac_mc_get_log_ce())
+	if (edac_mc_get_log_ce()) {
+		if (ras_agent)
+			ras_printk(PR_CONT, "row: %d, channel: %d\n",
+				   row, channel);
+
 		/* FIXME - put in DIMM location */
 		edac_mc_printk(mci, KERN_WARNING,
 			"CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
@@ -709,6 +715,7 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 			page_frame_number, offset_in_page,
 			mci->csrows[row].grain, syndrome, row, channel,
 			mci->csrows[row].channels[channel].label, msg);
+	}
 
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index bd926ea2e00c..ad7f47ddd7da 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -1,5 +1,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <trace/events/mce.h>
+#include <asm/ras.h>
 
 #include "mce_amd.h"
 
@@ -137,9 +139,9 @@ static bool f12h_dc_mce(u16 ec, u8 xec)
 		ret = true;
 
 		if (ll == LL_L2)
-			pr_cont("during L1 linefill from L2.\n");
+			ras_printk(PR_CONT, "during L1 linefill from L2.\n");
 		else if (ll == LL_L1)
-			pr_cont("Data/Tag %s error.\n", R4_MSG(ec));
+			ras_printk(PR_CONT, "Data/Tag %s error.\n", R4_MSG(ec));
 		else
 			ret = false;
 	}
@@ -149,7 +151,7 @@ static bool f12h_dc_mce(u16 ec, u8 xec)
 static bool f10h_dc_mce(u16 ec, u8 xec)
 {
 	if (R4(ec) == R4_GEN && LL(ec) == LL_L1) {
-		pr_cont("during data scrub.\n");
+		ras_printk(PR_CONT, "during data scrub.\n");
 		return true;
 	}
 	return f12h_dc_mce(ec, xec);
@@ -158,7 +160,7 @@ static bool f10h_dc_mce(u16 ec, u8 xec)
 static bool k8_dc_mce(u16 ec, u8 xec)
 {
 	if (BUS_ERROR(ec)) {
-		pr_cont("during system linefill.\n");
+		ras_printk(PR_CONT, "during system linefill.\n");
 		return true;
 	}
 
@@ -178,14 +180,14 @@ static bool f14h_dc_mce(u16 ec, u8 xec)
 		switch (r4) {
 		case R4_DRD:
 		case R4_DWR:
-			pr_cont("Data/Tag parity error due to %s.\n",
+			ras_printk(PR_CONT, "Data/Tag parity error due to %s.\n",
 				(r4 == R4_DRD ? "load/hw prf" : "store"));
 			break;
 		case R4_EVICT:
-			pr_cont("Copyback parity error on a tag miss.\n");
+			ras_printk(PR_CONT, "Copyback parity error on a tag miss.\n");
 			break;
 		case R4_SNOOP:
-			pr_cont("Tag parity error during snoop.\n");
+			ras_printk(PR_CONT, "Tag parity error during snoop.\n");
 			break;
 		default:
 			ret = false;
@@ -195,17 +197,17 @@ static bool f14h_dc_mce(u16 ec, u8 xec)
 		if ((II(ec) != II_MEM && II(ec) != II_IO) || LL(ec) != LL_LG)
 			return false;
 
-		pr_cont("System read data error on a ");
+		ras_printk(PR_CONT, "System read data error on a ");
 
 		switch (r4) {
 		case R4_RD:
-			pr_cont("TLB reload.\n");
+			ras_printk(PR_CONT, "TLB reload.\n");
 			break;
 		case R4_DWR:
-			pr_cont("store.\n");
+			ras_printk(PR_CONT, "store.\n");
 			break;
 		case R4_DRD:
-			pr_cont("load.\n");
+			ras_printk(PR_CONT, "load.\n");
 			break;
 		default:
 			ret = false;
@@ -225,28 +227,29 @@ static bool f15h_dc_mce(u16 ec, u8 xec)
 
 		switch (xec) {
 		case 0x0:
-			pr_cont("Data Array access error.\n");
+			ras_printk(PR_CONT, "Data Array access error.\n");
 			break;
 
 		case 0x1:
-			pr_cont("UC error during a linefill from L2/NB.\n");
+			ras_printk(PR_CONT, "UC error during a linefill "
+					    "from L2/NB.\n");
 			break;
 
 		case 0x2:
 		case 0x11:
-			pr_cont("STQ access error.\n");
+			ras_printk(PR_CONT, "STQ access error.\n");
 			break;
 
 		case 0x3:
-			pr_cont("SCB access error.\n");
+			ras_printk(PR_CONT, "SCB access error.\n");
 			break;
 
 		case 0x10:
-			pr_cont("Tag error.\n");
+			ras_printk(PR_CONT, "Tag error.\n");
 			break;
 
 		case 0x12:
-			pr_cont("LDQ access error.\n");
+			ras_printk(PR_CONT, "LDQ access error.\n");
 			break;
 
 		default:
@@ -255,9 +258,9 @@ static bool f15h_dc_mce(u16 ec, u8 xec)
 	} else if (BUS_ERROR(ec)) {
 
 		if (!xec)
-			pr_cont("during system linefill.\n");
+			ras_printk(PR_CONT, "during system linefill.\n");
 		else
-			pr_cont(" Internal %s condition.\n",
+			ras_printk(PR_CONT, " Internal %s condition.\n",
 				((xec == 1) ? "livelock" : "deadlock"));
 	} else
 		ret = false;
@@ -270,12 +273,12 @@ static void amd_decode_dc_mce(struct mce *m)
 	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, xec_mask);
 
-	pr_emerg(HW_ERR "Data Cache Error: ");
+	ras_printk(PR_EMERG, HW_ERR "Data Cache Error: ");
 
 	/* TLB error signatures are the same across families */
 	if (TLB_ERROR(ec)) {
 		if (TT(ec) == TT_DATA) {
-			pr_cont("%s TLB %s.\n", LL_MSG(ec),
+			ras_printk(PR_CONT, "%s TLB %s.\n", LL_MSG(ec),
 				((xec == 2) ? "locked miss"
 					    : (xec ? "multimatch" : "parity")));
 			return;
@@ -283,7 +286,7 @@ static void amd_decode_dc_mce(struct mce *m)
 	} else if (fam_ops->dc_mce(ec, xec))
 		;
 	else
-		pr_emerg(HW_ERR "Corrupted DC MCE info?\n");
+		ras_printk(PR_EMERG, HW_ERR "Corrupted DC MCE info?\n");
 }
 
 static bool k8_ic_mce(u16 ec, u8 xec)
@@ -295,19 +298,19 @@ static bool k8_ic_mce(u16 ec, u8 xec)
 		return false;
 
 	if (ll == 0x2)
-		pr_cont("during a linefill from L2.\n");
+		ras_printk(PR_CONT, "during a linefill from L2.\n");
 	else if (ll == 0x1) {
 		switch (R4(ec)) {
 		case R4_IRD:
-			pr_cont("Parity error during data load.\n");
+			ras_printk(PR_CONT, "Parity error during data load.\n");
 			break;
 
 		case R4_EVICT:
-			pr_cont("Copyback Parity/Victim error.\n");
+			ras_printk(PR_CONT, "Copyback Parity/Victim error.\n");
 			break;
 
 		case R4_SNOOP:
-			pr_cont("Tag Snoop error.\n");
+			ras_printk(PR_CONT, "Tag Snoop error.\n");
 			break;
 
 		default:
@@ -330,9 +333,9 @@ static bool f14h_ic_mce(u16 ec, u8 xec)
 			ret = false;
 
 		if (r4 == R4_IRD)
-			pr_cont("Data/tag array parity error for a tag hit.\n");
+			ras_printk(PR_CONT, "Data/tag array parity error for a tag hit.\n");
 		else if (r4 == R4_SNOOP)
-			pr_cont("Tag error during snoop/victimization.\n");
+			ras_printk(PR_CONT, "Tag error during snoop/victimization.\n");
 		else
 			ret = false;
 	}
@@ -348,15 +351,16 @@ static bool f15h_ic_mce(u16 ec, u8 xec)
 
 	switch (xec) {
 	case 0x0 ... 0xa:
-		pr_cont("%s.\n", f15h_ic_mce_desc[xec]);
+		ras_printk(PR_CONT, "%s.\n", f15h_ic_mce_desc[xec]);
 		break;
 
 	case 0xd:
-		pr_cont("%s.\n", f15h_ic_mce_desc[xec-2]);
+		ras_printk(PR_CONT, "%s.\n", f15h_ic_mce_desc[xec-2]);
 		break;
 
 	case 0x10 ... 0x14:
-		pr_cont("Decoder %s parity error.\n", f15h_ic_mce_desc[xec-4]);
+		ras_printk(PR_CONT, "Decoder %s parity error.\n",
+				    f15h_ic_mce_desc[xec-4]);
 		break;
 
 	default:
@@ -370,19 +374,20 @@ static void amd_decode_ic_mce(struct mce *m)
 	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, xec_mask);
 
-	pr_emerg(HW_ERR "Instruction Cache Error: ");
+	ras_printk(PR_EMERG, HW_ERR "Instruction Cache Error: ");
 
 	if (TLB_ERROR(ec))
-		pr_cont("%s TLB %s.\n", LL_MSG(ec),
+		ras_printk(PR_CONT, "%s TLB %s.\n", LL_MSG(ec),
 			(xec ? "multimatch" : "parity error"));
 	else if (BUS_ERROR(ec)) {
 		bool k8 = (boot_cpu_data.x86 == 0xf && (m->status & BIT_64(58)));
 
-		pr_cont("during %s.\n", (k8 ? "system linefill" : "NB data read"));
+		ras_printk(PR_CONT, "during %s.\n", (k8 ? "system linefill"
+							: "NB data read"));
 	} else if (fam_ops->ic_mce(ec, xec))
 		;
 	else
-		pr_emerg(HW_ERR "Corrupted IC MCE info?\n");
+		ras_printk(PR_EMERG, HW_ERR "Corrupted IC MCE info?\n");
 }
 
 static void amd_decode_bu_mce(struct mce *m)
@@ -390,30 +395,33 @@ static void amd_decode_bu_mce(struct mce *m)
 	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, xec_mask);
 
-	pr_emerg(HW_ERR "Bus Unit Error");
+	ras_printk(PR_EMERG, HW_ERR "Bus Unit Error");
 
 	if (xec == 0x1)
-		pr_cont(" in the write data buffers.\n");
+		ras_printk(PR_CONT, " in the write data buffers.\n");
 	else if (xec == 0x3)
-		pr_cont(" in the victim data buffers.\n");
+		ras_printk(PR_CONT, " in the victim data buffers.\n");
 	else if (xec == 0x2 && MEM_ERROR(ec))
-		pr_cont(": %s error in the L2 cache tags.\n", R4_MSG(ec));
+		ras_printk(PR_CONT, ": %s error in the L2 cache tags.\n",
+			   R4_MSG(ec));
 	else if (xec == 0x0) {
 		if (TLB_ERROR(ec))
-			pr_cont(": %s error in a Page Descriptor Cache or "
-				"Guest TLB.\n", TT_MSG(ec));
+			ras_printk(PR_CONT, ": %s error in a Page Descriptor "
+					    "Cache or Guest TLB.\n",
+					    TT_MSG(ec));
 		else if (BUS_ERROR(ec))
-			pr_cont(": %s/ECC error in data read from NB: %s.\n",
-				R4_MSG(ec), PP_MSG(ec));
+			ras_printk(PR_CONT, ": %s/ECC error in data read from NB: %s.\n",
+					    R4_MSG(ec), PP_MSG(ec));
 		else if (MEM_ERROR(ec)) {
 			u8 r4 = R4(ec);
 
 			if (r4 >= 0x7)
-				pr_cont(": %s error during data copyback.\n",
-					R4_MSG(ec));
+				ras_printk(PR_CONT, ": %s error during data copyback.\n",
+						    R4_MSG(ec));
 			else if (r4 <= 0x1)
-				pr_cont(": %s parity/ECC error during data "
-					"access from L2.\n", R4_MSG(ec));
+				ras_printk(PR_CONT, ": %s parity/ECC error "
+						    "during data access from L2.\n",
+						    R4_MSG(ec));
 			else
 				goto wrong_bu_mce;
 		} else
@@ -424,7 +432,7 @@ static void amd_decode_bu_mce(struct mce *m)
 	return;
 
 wrong_bu_mce:
-	pr_emerg(HW_ERR "Corrupted BU MCE info?\n");
+	ras_printk(PR_EMERG, HW_ERR "Corrupted BU MCE info?\n");
 }
 
 static void amd_decode_cu_mce(struct mce *m)
@@ -432,28 +440,28 @@ static void amd_decode_cu_mce(struct mce *m)
 	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, xec_mask);
 
-	pr_emerg(HW_ERR "Combined Unit Error: ");
+	ras_printk(PR_EMERG, HW_ERR "Combined Unit Error: ");
 
 	if (TLB_ERROR(ec)) {
 		if (xec == 0x0)
-			pr_cont("Data parity TLB read error.\n");
+			ras_printk(PR_CONT, "Data parity TLB read error.\n");
 		else if (xec == 0x1)
-			pr_cont("Poison data provided for TLB fill.\n");
+			ras_printk(PR_CONT, "Poison data provided for TLB fill.\n");
 		else
 			goto wrong_cu_mce;
 	} else if (BUS_ERROR(ec)) {
 		if (xec > 2)
 			goto wrong_cu_mce;
 
-		pr_cont("Error during attempted NB data read.\n");
+		ras_printk(PR_CONT, "Error during attempted NB data read.\n");
 	} else if (MEM_ERROR(ec)) {
 		switch (xec) {
 		case 0x4 ... 0xc:
-			pr_cont("%s.\n", f15h_cu_mce_desc[xec - 0x4]);
+			ras_printk(PR_CONT, "%s.\n", f15h_cu_mce_desc[xec - 0x4]);
 			break;
 
 		case 0x10 ... 0x14:
-			pr_cont("%s.\n", f15h_cu_mce_desc[xec - 0x7]);
+			ras_printk(PR_CONT, "%s.\n", f15h_cu_mce_desc[xec - 0x7]);
 			break;
 
 		default:
@@ -464,7 +472,7 @@ static void amd_decode_cu_mce(struct mce *m)
 	return;
 
 wrong_cu_mce:
-	pr_emerg(HW_ERR "Corrupted CU MCE info?\n");
+	ras_printk(PR_EMERG, HW_ERR "Corrupted CU MCE info?\n");
 }
 
 static void amd_decode_ls_mce(struct mce *m)
@@ -473,12 +481,12 @@ static void amd_decode_ls_mce(struct mce *m)
 	u8 xec = XEC(m->status, xec_mask);
 
 	if (boot_cpu_data.x86 >= 0x14) {
-		pr_emerg("You shouldn't be seeing an LS MCE on this cpu family,"
-			 " please report on LKML.\n");
+		ras_printk(PR_EMERG, "You shouldn't be seeing an LS MCE on this"
+				     " cpu family, please report on LKML.\n");
 		return;
 	}
 
-	pr_emerg(HW_ERR "Load Store Error");
+	ras_printk(PR_EMERG, HW_ERR "Load Store Error");
 
 	if (xec == 0x0) {
 		u8 r4 = R4(ec);
@@ -486,14 +494,14 @@ static void amd_decode_ls_mce(struct mce *m)
 		if (!BUS_ERROR(ec) || (r4 != R4_DRD && r4 != R4_DWR))
 			goto wrong_ls_mce;
 
-		pr_cont(" during %s.\n", R4_MSG(ec));
+		ras_printk(PR_CONT, " during %s.\n", R4_MSG(ec));
 	} else
 		goto wrong_ls_mce;
 
 	return;
 
 wrong_ls_mce:
-	pr_emerg(HW_ERR "Corrupted LS MCE info?\n");
+	ras_printk(PR_EMERG, HW_ERR "Corrupted LS MCE info?\n");
 }
 
 static bool k8_nb_mce(u16 ec, u8 xec)
@@ -502,15 +510,15 @@ static bool k8_nb_mce(u16 ec, u8 xec)
 
 	switch (xec) {
 	case 0x1:
-		pr_cont("CRC error detected on HT link.\n");
+		ras_printk(PR_CONT, "CRC error detected on HT link.\n");
 		break;
 
 	case 0x5:
-		pr_cont("Invalid GART PTE entry during GART table walk.\n");
+		ras_printk(PR_CONT, "Invalid GART PTE entry during GART table walk.\n");
 		break;
 
 	case 0x6:
-		pr_cont("Unsupported atomic RMW received from an IO link.\n");
+		ras_printk(PR_CONT, "Unsupported atomic RMW received from an IO link.\n");
 		break;
 
 	case 0x0:
@@ -518,11 +526,11 @@ static bool k8_nb_mce(u16 ec, u8 xec)
 		if (boot_cpu_data.x86 == 0x11)
 			return false;
 
-		pr_cont("DRAM ECC error detected on the NB.\n");
+		ras_printk(PR_CONT, "DRAM ECC error detected on the NB.\n");
 		break;
 
 	case 0xd:
-		pr_cont("Parity error on the DRAM addr/ctl signals.\n");
+		ras_printk(PR_CONT, "Parity error on the DRAM addr/ctl signals.\n");
 		break;
 
 	default:
@@ -552,9 +560,9 @@ static bool f10h_nb_mce(u16 ec, u8 xec)
 
 	case 0xf:
 		if (TLB_ERROR(ec))
-			pr_cont("GART Table Walk data error.\n");
+			ras_printk(PR_CONT, "GART Table Walk data error.\n");
 		else if (BUS_ERROR(ec))
-			pr_cont("DMA Exclusion Vector Table Walk error.\n");
+			ras_printk(PR_CONT, "DMA Exclusion Vector Table Walk error.\n");
 		else
 			ret = false;
 
@@ -563,7 +571,7 @@ static bool f10h_nb_mce(u16 ec, u8 xec)
 
 	case 0x19:
 		if (boot_cpu_data.x86 == 0x15)
-			pr_cont("Compute Unit Data Error.\n");
+			ras_printk(PR_CONT, "Compute Unit Data Error.\n");
 		else
 			ret = false;
 
@@ -581,7 +589,7 @@ static bool f10h_nb_mce(u16 ec, u8 xec)
 		break;
 	}
 
-	pr_cont("%s.\n", f10h_nb_mce_desc[xec - offset]);
+	ras_printk(PR_CONT, "%s.\n", f10h_nb_mce_desc[xec - offset]);
 
 out:
 	return ret;
@@ -599,27 +607,27 @@ void amd_decode_nb_mce(struct mce *m)
 	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, 0x1f);
 
-	pr_emerg(HW_ERR "Northbridge Error (node %d): ", node_id);
+	ras_printk(PR_EMERG, HW_ERR "Northbridge Error (node %d): ", node_id);
 
 	switch (xec) {
 	case 0x2:
-		pr_cont("Sync error (sync packets on HT link detected).\n");
+		ras_printk(PR_CONT, "Sync error (sync packets on HT link detected).\n");
 		return;
 
 	case 0x3:
-		pr_cont("HT Master abort.\n");
+		ras_printk(PR_CONT, "HT Master abort.\n");
 		return;
 
 	case 0x4:
-		pr_cont("HT Target abort.\n");
+		ras_printk(PR_CONT, "HT Target abort.\n");
 		return;
 
 	case 0x7:
-		pr_cont("NB Watchdog timeout.\n");
+		ras_printk(PR_CONT, "NB Watchdog timeout.\n");
 		return;
 
 	case 0x9:
-		pr_cont("SVM DMA Exclusion Vector error.\n");
+		ras_printk(PR_CONT, "SVM DMA Exclusion Vector error.\n");
 		return;
 
 	default:
@@ -636,7 +644,7 @@ void amd_decode_nb_mce(struct mce *m)
 	return;
 
 wrong_nb_mce:
-	pr_emerg(HW_ERR "Corrupted NB MCE info?\n");
+	ras_printk(PR_EMERG, HW_ERR "Corrupted NB MCE info?\n");
 }
 EXPORT_SYMBOL_GPL(amd_decode_nb_mce);
 
@@ -651,80 +659,80 @@ static void amd_decode_fr_mce(struct mce *m)
 	if (c->x86 != 0x15 && xec != 0x0)
 		goto wrong_fr_mce;
 
-	pr_emerg(HW_ERR "%s Error: ",
+	ras_printk(PR_EMERG, HW_ERR "%s Error: ",
 		 (c->x86 == 0x15 ? "Execution Unit" : "FIROB"));
 
 	if (xec == 0x0 || xec == 0xc)
-		pr_cont("%s.\n", fr_ex_mce_desc[xec]);
+		ras_printk(PR_CONT, "%s.\n", fr_ex_mce_desc[xec]);
 	else if (xec < 0xd)
-		pr_cont("%s parity error.\n", fr_ex_mce_desc[xec]);
+		ras_printk(PR_CONT, "%s parity error.\n", fr_ex_mce_desc[xec]);
 	else
 		goto wrong_fr_mce;
 
 	return;
 
 wrong_fr_mce:
-	pr_emerg(HW_ERR "Corrupted FR MCE info?\n");
+	ras_printk(PR_EMERG, HW_ERR "Corrupted FR MCE info?\n");
 }
 
 static void amd_decode_fp_mce(struct mce *m)
 {
 	u8 xec = XEC(m->status, xec_mask);
 
-	pr_emerg(HW_ERR "Floating Point Unit Error: ");
+	ras_printk(PR_EMERG, HW_ERR "Floating Point Unit Error: ");
 
 	switch (xec) {
 	case 0x1:
-		pr_cont("Free List");
+		ras_printk(PR_CONT, "Free List");
 		break;
 
 	case 0x2:
-		pr_cont("Physical Register File");
+		ras_printk(PR_CONT, "Physical Register File");
 		break;
 
 	case 0x3:
-		pr_cont("Retire Queue");
+		ras_printk(PR_CONT, "Retire Queue");
 		break;
 
 	case 0x4:
-		pr_cont("Scheduler table");
+		ras_printk(PR_CONT, "Scheduler table");
 		break;
 
 	case 0x5:
-		pr_cont("Status Register File");
+		ras_printk(PR_CONT, "Status Register File");
 		break;
 
 	default:
 		goto wrong_fp_mce;
 		break;
 	}
-
-	pr_cont(" parity error.\n");
+	ras_printk(PR_CONT, " parity error.\n");
 
 	return;
 
 wrong_fp_mce:
-	pr_emerg(HW_ERR "Corrupted FP MCE info?\n");
+	ras_printk(PR_EMERG, HW_ERR "Corrupted FP MCE info?\n");
 }
 
 static inline void amd_decode_err_code(u16 ec)
 {
 
-	pr_emerg(HW_ERR "cache level: %s", LL_MSG(ec));
+	ras_printk(PR_EMERG, HW_ERR "cache level: %s", LL_MSG(ec));
 
 	if (BUS_ERROR(ec))
-		pr_cont(", mem/io: %s", II_MSG(ec));
+		ras_printk(PR_CONT, ", mem/io: %s", II_MSG(ec));
 	else
-		pr_cont(", tx: %s", TT_MSG(ec));
+		ras_printk(PR_CONT, ", tx: %s", TT_MSG(ec));
 
 	if (MEM_ERROR(ec) || BUS_ERROR(ec)) {
-		pr_cont(", mem-tx: %s", R4_MSG(ec));
+		ras_printk(PR_CONT, ", mem-tx: %s", R4_MSG(ec));
 
 		if (BUS_ERROR(ec))
-			pr_cont(", part-proc: %s (%s)", PP_MSG(ec), TO_MSG(ec));
+			ras_printk(PR_CONT, ", part-proc: %s (%s)",
+					    PP_MSG(ec), TO_MSG(ec));
 	}
 
-	pr_cont("\n");
+	ras_printk(PR_CONT, "\n");
 }
 
 /*
@@ -752,7 +760,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 	if (amd_filter_mce(m))
 		return NOTIFY_STOP;
 
-	pr_emerg(HW_ERR "CPU:%d\tMC%d_STATUS[%s|%s|%s|%s|%s",
+	ras_printk(PR_EMERG, HW_ERR "CPU:%d\tMC%d_STATUS[%s|%s|%s|%s|%s",
 		m->extcpu, m->bank,
 		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
 		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
@@ -761,19 +769,20 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		((m->status & MCI_STATUS_ADDRV)	? "AddrV" : "-"));
 
 	if (c->x86 == 0x15)
-		pr_cont("|%s|%s",
+		ras_printk(PR_CONT, "|%s|%s",
 			((m->status & BIT_64(44)) ? "Deferred" : "-"),
 			((m->status & BIT_64(43)) ? "Poison"   : "-"));
 
 	/* do the two bits[14:13] together */
 	ecc = (m->status >> 45) & 0x3;
 	if (ecc)
-		pr_cont("|%sECC", ((ecc == 2) ? "C" : "U"));
+		ras_printk(PR_CONT, "|%sECC", ((ecc == 2) ? "C" : "U"));
 
-	pr_cont("]: 0x%016llx\n", m->status);
+	ras_printk(PR_CONT, "]: 0x%016llx\n", m->status);
 
 	if (m->status & MCI_STATUS_ADDRV)
-		pr_emerg(HW_ERR "\tMC%d_ADDR: 0x%016llx\n", m->bank, m->addr);
+		ras_printk(PR_EMERG, HW_ERR "\tMC%d_ADDR: 0x%016llx\n",
+			   m->bank, m->addr);
 
 	switch (m->bank) {
 	case 0:
@@ -813,6 +822,8 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 
 	amd_decode_err_code(m->status & 0xffff);
 
+	trace_mce_record(decoded_err_str, m);
+
 	return NOTIFY_STOP;
 }
 EXPORT_SYMBOL_GPL(amd_decode_mce);
@@ -882,10 +893,14 @@ static int __init mce_amd_init(void)
 		return -EINVAL;
 	}
 
-	pr_info("MCE: In-kernel MCE decoding enabled.\n");
+	decoded_err_str = kzalloc(ERR_STRING_SZ, GFP_KERNEL);
+	if (!decoded_err_str)
+		return -ENOMEM;
 
 	mce_register_decode_chain(&amd_mce_dec_nb);
 
+	pr_info("MCE: In-kernel MCE decoding enabled.\n");
+
 	return 0;
 }
 early_initcall(mce_amd_init);
@@ -894,6 +909,7 @@ early_initcall(mce_amd_init);
 static void __exit mce_amd_exit(void)
 {
 	mce_unregister_decode_chain(&amd_mce_dec_nb);
+	kfree(decoded_err_str);
 	kfree(fam_ops);
 }
 
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
index 4cbbcef6baa8..1a7cd471a771 100644
--- a/include/trace/events/mce.h
+++ b/include/trace/events/mce.h
@@ -10,11 +10,12 @@
 
 TRACE_EVENT(mce_record,
 
-	TP_PROTO(struct mce *m),
+	TP_PROTO(const char *msg, struct mce *m),
 
-	TP_ARGS(m),
+	TP_ARGS(msg, m),
 
 	TP_STRUCT__entry(
+		__string(	msg,		msg		)
 		__field(	u64,		mcgcap		)
 		__field(	u64,		mcgstatus	)
 		__field(	u64,		status		)
@@ -33,6 +34,7 @@ TRACE_EVENT(mce_record,
 	),
 
 	TP_fast_assign(
+		__assign_str(msg,	msg);
 		__entry->mcgcap		= m->mcgcap;
 		__entry->mcgstatus	= m->mcgstatus;
 		__entry->status		= m->status;
@@ -50,7 +52,8 @@ TRACE_EVENT(mce_record,
 		__entry->cpuvendor	= m->cpuvendor;
 	),
 
-	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
+	TP_printk("%s\n(CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x)",
+		__get_str(msg),
 		__entry->cpu,
 		__entry->mcgcap, __entry->mcgstatus,
 		__entry->bank, __entry->status,
@@ -63,6 +66,23 @@ TRACE_EVENT(mce_record,
 		__entry->apicid)
 );
 
+TRACE_EVENT(hw_error,
+
+	TP_PROTO(const char *msg),
+
+	TP_ARGS(msg),
+
+	TP_STRUCT__entry(
+		__string(msg, msg)
+	),
+
+	TP_fast_assign(
+		__assign_str(msg, msg);
+	),
+
+	TP_printk(HW_ERR "%s\n", __get_str(msg))
+);
+
 #endif /* _TRACE_MCE_H */
 
 /* This part must be outside protection */
-- 
1.7.8.rc0


-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
