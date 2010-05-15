Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab0EONn1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 09:43:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36357 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472Ab0EONnX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 09:43:23 -0400
Date: Sat, 15 May 2010 15:43:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: perf, ftrace and MCEs
Message-ID: <20100515134312.GA25375@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
References: <20100501181212.GA25352@liondog.tnic>
 <20100504113227.GA14067@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20100504113227.GA14067@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, May 04, 2010 at 01:32:27PM +0200

Hi,

> To start with this, a quick initial prototype could use the 'perf trace' live 
> mode tracing script. (See latest -tip, 'perf trace --script <script-name>' and 
> 'perf record -o -' to activate live mode.)

so I did some experimenting with this and have a pretty rough prototype
which conveys decoded MCEs to userspace where they're read with perf.
More specifically, I did

perf record -e mce:mce_record -a

after tweaking the mce_record tracepoint to include the decoded error
string.

And then doing

perf trace -g python
perf trace -s perf-trace.py

got me:

in trace_begin
mce__mce_record          6 00600.700632283        0 init                  mcgcap=262, mcgstatus=0, bank=4, status=15888347641659525651, addr=26682366720, misc=13837309867997528064, ip=0, cs=0, tsc=0, walltime=1273928155, cpu=6, cpuid=1052561, apicid=6, socketid=0, cpuvendor=2, decoded_err= Northbridge Error, node 1ECC/ChipKill ECC error.
CE err addr: 0x636649b00
CE page 0x636649, offset 0xb00, grain 0, syndrome 0x1fd, row 3, channel 0
 Transaction type: generic read(mem access), no t
in trace_end

which shows the signature of an ECC which I injected earlier over the
EDAC sysfs interface. And yes, the decoded_err appears truncated so I'll
have to think of a slicker way to collect that info.

Although they're pretty rough yet, I've attached the relevant patches so
that one could get an impression of where we're moving here.

0001-amd64_edac-Remove-polling-mechanism.patch removes the EDAC
polling mechanism in favor of hooking into the machine_check_poll
polling function using the atomic notifier which we already use for
uncorrectable errors.

The other two

0002-mce-trace-Add-decoded-string-to-mce_record-s-format.patch
0003-edac-mce-Prepare-error-decoded-info.patch

add that decoded_err string. I'm open for better ideas here though.

Concerning the early MCE logging and reporting, I'm thinking of using
the mce.c ring buffer temporarily until the ftrace buffer has been
initialized and then copying all records into the last. We might do a
more elegant solution in the future after all that bootmem churn has
quieted down and allocate memory early for a dedicated MCE ring buffer
or whatever.

Wrt critical MCEs, I'm leaning towards bypassing perf/ftrace subsystem
altogether in favor of executing the smallest amount of code possible
like, for example, switching to a tty, dumping the decoded error and
in certain cases not panicking but shutting down gracefully after a
timeout. Of course, graceful shutdown is completely dependent on the
type of hw failure and in some cases we can't do anything else but
freeze in order to prevent faulty data propagation.

I'm sure there's more...

Thanks.

-- 
Regards/Gruss,
    Boris.

--k1lZvvs/B4yU6o8G
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0001-amd64_edac-Remove-polling-mechanism.patch"

>From 47927877707e57f7cda3093d426160bb70654291 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Sat, 15 May 2010 13:51:57 +0200
Subject: [PATCH 1/4] amd64_edac: Remove polling mechanism

Switch to using the machine check polling mechanism of the mcheck core
instead of duplicating functionality.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    1 +
 drivers/edac/amd64_edac.c        |  118 --------------------------------------
 2 files changed, 1 insertions(+), 118 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 8a6f0af..b57c185 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -581,6 +581,7 @@ void machine_check_poll(enum mcp_flags flags, mce_banks_t *b)
 		 */
 		if (!(flags & MCP_DONTLOG) && !mce_dont_log_ce) {
 			mce_log(&m);
+			atomic_notifier_call_chain(&x86_mce_decoder_chain, 0, &m);
 			add_taint(TAINT_MACHINE_CHECK);
 		}
 
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 297cc12..80600f1 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1973,107 +1973,6 @@ static int get_channel_from_ecc_syndrome(struct mem_ctl_info *mci, u16 syndrome)
 }
 
 /*
- * Check for valid error in the NB Status High register. If so, proceed to read
- * NB Status Low, NB Address Low and NB Address High registers and store data
- * into error structure.
- *
- * Returns:
- *	- 1: if hardware regs contains valid error info
- *	- 0: if no valid error is indicated
- */
-static int amd64_get_error_info_regs(struct mem_ctl_info *mci,
-				     struct err_regs *regs)
-{
-	struct amd64_pvt *pvt;
-	struct pci_dev *misc_f3_ctl;
-
-	pvt = mci->pvt_info;
-	misc_f3_ctl = pvt->misc_f3_ctl;
-
-	if (amd64_read_pci_cfg(misc_f3_ctl, K8_NBSH, &regs->nbsh))
-		return 0;
-
-	if (!(regs->nbsh & K8_NBSH_VALID_BIT))
-		return 0;
-
-	/* valid error, read remaining error information registers */
-	if (amd64_read_pci_cfg(misc_f3_ctl, K8_NBSL, &regs->nbsl) ||
-	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBEAL, &regs->nbeal) ||
-	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBEAH, &regs->nbeah) ||
-	    amd64_read_pci_cfg(misc_f3_ctl, K8_NBCFG, &regs->nbcfg))
-		return 0;
-
-	return 1;
-}
-
-/*
- * This function is called to retrieve the error data from hardware and store it
- * in the info structure.
- *
- * Returns:
- *	- 1: if a valid error is found
- *	- 0: if no error is found
- */
-static int amd64_get_error_info(struct mem_ctl_info *mci,
-				struct err_regs *info)
-{
-	struct amd64_pvt *pvt;
-	struct err_regs regs;
-
-	pvt = mci->pvt_info;
-
-	if (!amd64_get_error_info_regs(mci, info))
-		return 0;
-
-	/*
-	 * Here's the problem with the K8's EDAC reporting: There are four
-	 * registers which report pieces of error information. They are shared
-	 * between CEs and UEs. Furthermore, contrary to what is stated in the
-	 * BKDG, the overflow bit is never used! Every error always updates the
-	 * reporting registers.
-	 *
-	 * Can you see the race condition? All four error reporting registers
-	 * must be read before a new error updates them! There is no way to read
-	 * all four registers atomically. The best than can be done is to detect
-	 * that a race has occured and then report the error without any kind of
-	 * precision.
-	 *
-	 * What is still positive is that errors are still reported and thus
-	 * problems can still be detected - just not localized because the
-	 * syndrome and address are spread out across registers.
-	 *
-	 * Grrrrr!!!!!  Here's hoping that AMD fixes this in some future K8 rev.
-	 * UEs and CEs should have separate register sets with proper overflow
-	 * bits that are used! At very least the problem can be fixed by
-	 * honoring the ErrValid bit in 'nbsh' and not updating registers - just
-	 * set the overflow bit - unless the current error is CE and the new
-	 * error is UE which would be the only situation for overwriting the
-	 * current values.
-	 */
-
-	regs = *info;
-
-	/* Use info from the second read - most current */
-	if (unlikely(!amd64_get_error_info_regs(mci, info)))
-		return 0;
-
-	/* clear the error bits in hardware */
-	pci_write_bits32(pvt->misc_f3_ctl, K8_NBSH, 0, K8_NBSH_VALID_BIT);
-
-	/* Check for the possible race condition */
-	if ((regs.nbsh != info->nbsh) ||
-	     (regs.nbsl != info->nbsl) ||
-	     (regs.nbeah != info->nbeah) ||
-	     (regs.nbeal != info->nbeal)) {
-		amd64_mc_printk(mci, KERN_WARNING,
-				"hardware STATUS read access race condition "
-				"detected!\n");
-		return 0;
-	}
-	return 1;
-}
-
-/*
  * Handle any Correctable Errors (CEs) that have occurred. Check for valid ERROR
  * ADDRESS and process.
  */
@@ -2197,20 +2096,6 @@ void amd64_decode_bus_error(int node_id, struct err_regs *regs)
 }
 
 /*
- * The main polling 'check' function, called FROM the edac core to perform the
- * error checking and if an error is encountered, error processing.
- */
-static void amd64_check(struct mem_ctl_info *mci)
-{
-	struct err_regs regs;
-
-	if (amd64_get_error_info(mci, &regs)) {
-		struct amd64_pvt *pvt = mci->pvt_info;
-		amd_decode_nb_mce(pvt->mc_node_id, &regs, 1);
-	}
-}
-
-/*
  * Input:
  *	1) struct amd64_pvt which contains pvt->dram_f2_ctl pointer
  *	2) AMD Family index value
@@ -2749,9 +2634,6 @@ static void amd64_setup_mci_misc_attributes(struct mem_ctl_info *mci)
 	mci->dev_name		= pci_name(pvt->dram_f2_ctl);
 	mci->ctl_page_to_phys	= NULL;
 
-	/* IMPORTANT: Set the polling 'check' function in this module */
-	mci->edac_check		= amd64_check;
-
 	/* memory scrubber interface */
 	mci->set_sdram_scrub_rate = amd64_set_scrub_rate;
 	mci->get_sdram_scrub_rate = amd64_get_scrub_rate;
-- 
1.6.4.4


--k1lZvvs/B4yU6o8G
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0002-mce-trace-Add-decoded-string-to-mce_record-s-format.patch"

>From e5e0209868763073b4a82c6874a7e9d21fd7c8e5 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 27 Mar 2010 17:25:02 +0100
Subject: [PATCH 2/4] mce, trace: Add decoded string to mce_record's format

Put the decoded error string into the trace record.

Not-Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 include/trace/events/mce.h       |   43 +++++++++++++++++++++----------------
 2 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index b57c185..3880f3c 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -161,7 +161,7 @@ void mce_log(struct mce *mce)
 	unsigned next, entry;
 
 	/* Emit the trace record: */
-	trace_mce_record(mce);
+	trace_mce_record(mce, "");
 
 	mce->finished = 0;
 	wmb();
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
index 7eee778..96b040a 100644
--- a/include/trace/events/mce.h
+++ b/include/trace/events/mce.h
@@ -8,11 +8,13 @@
 #include <linux/tracepoint.h>
 #include <asm/mce.h>
 
+#define DECODED_ERR_SZ 200
+
 TRACE_EVENT(mce_record,
 
-	TP_PROTO(struct mce *m),
+	TP_PROTO(struct mce *m, char *decoded_err),
 
-	TP_ARGS(m),
+	TP_ARGS(m, decoded_err),
 
 	TP_STRUCT__entry(
 		__field(	u64,		mcgcap		)
@@ -30,27 +32,29 @@ TRACE_EVENT(mce_record,
 		__field(	u32,		apicid		)
 		__field(	u32,		socketid	)
 		__field(	u8,		cpuvendor	)
+		__array(      char,		decoded_err,	DECODED_ERR_SZ)
 	),
 
 	TP_fast_assign(
-		__entry->mcgcap		= m->mcgcap;
-		__entry->mcgstatus	= m->mcgstatus;
-		__entry->bank		= m->bank;
-		__entry->status		= m->status;
-		__entry->addr		= m->addr;
-		__entry->misc		= m->misc;
-		__entry->ip		= m->ip;
-		__entry->cs		= m->cs;
-		__entry->tsc		= m->tsc;
-		__entry->walltime	= m->time;
-		__entry->cpu		= m->extcpu;
-		__entry->cpuid		= m->cpuid;
-		__entry->apicid		= m->apicid;
-		__entry->socketid	= m->socketid;
-		__entry->cpuvendor	= m->cpuvendor;
+		__entry->mcgcap			= m->mcgcap;
+		__entry->mcgstatus		= m->mcgstatus;
+		__entry->bank			= m->bank;
+		__entry->status			= m->status;
+		__entry->addr			= m->addr;
+		__entry->misc			= m->misc;
+		__entry->ip			= m->ip;
+		__entry->cs			= m->cs;
+		__entry->tsc			= m->tsc;
+		__entry->walltime		= m->time;
+		__entry->cpu			= m->extcpu;
+		__entry->cpuid			= m->cpuid;
+		__entry->apicid			= m->apicid;
+		__entry->socketid		= m->socketid;
+		__entry->cpuvendor		= m->cpuvendor;
+		memcpy(__entry->decoded_err, decoded_err, DECODED_ERR_SZ);
 	),
 
-	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
+	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x\nErr: %s\n",
 		__entry->cpu,
 		__entry->mcgcap, __entry->mcgstatus,
 		__entry->bank, __entry->status,
@@ -60,7 +64,8 @@ TRACE_EVENT(mce_record,
 		__entry->cpuvendor, __entry->cpuid,
 		__entry->walltime,
 		__entry->socketid,
-		__entry->apicid)
+		__entry->apicid,
+		__entry->decoded_err)
 );
 
 #endif /* _TRACE_MCE_H */
-- 
1.6.4.4


--k1lZvvs/B4yU6o8G
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="0003-edac-mce-Prepare-error-decoded-info.patch"

>From 980c6fdf00cf23ef76481a4c94ba682c0ff80d61 Mon Sep 17 00:00:00 2001
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sat, 27 Mar 2010 18:42:08 +0100
Subject: [PATCH 3/4] edac, mce: Prepare error decoded info

Add a buffer where CECC error info is stored and dump it later into the
trace record.

Not-Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +
 drivers/edac/amd64_edac.c        |    4 ++-
 drivers/edac/edac_mc.c           |    7 ++++
 drivers/edac/edac_mce_amd.c      |   60 +++++++++++++++++++++++++++++++------
 drivers/edac/edac_mce_amd.h      |    1 +
 5 files changed, 63 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 3880f3c..0bcb488 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -160,8 +160,10 @@ void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
 
+#ifndef CONFIG_EDAC_DECODE_MCE
 	/* Emit the trace record: */
 	trace_mce_record(mce, "");
+#endif
 
 	mce->finished = 0;
 	wmb();
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 80600f1..3e036f3 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1993,7 +1993,9 @@ static void amd64_handle_ce(struct mem_ctl_info *mci,
 	sys_addr = pvt->ops->get_error_address(mci, info);
 
 	amd64_mc_printk(mci, KERN_ERR,
-		"CE ERROR_ADDRESS= 0x%llx\n", sys_addr);
+		"CE err addr: 0x%llx\n", sys_addr);
+
+	edac_snprintf("CE err addr: 0x%llx\n", sys_addr);
 
 	pvt->ops->map_sysaddr_to_csrow(mci, info, sys_addr);
 }
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 3630308..f4b7de7 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -33,6 +33,7 @@
 #include <asm/edac.h>
 #include "edac_core.h"
 #include "edac_module.h"
+#include "edac_mce_amd.h"
 
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
@@ -702,6 +703,12 @@ void edac_mc_handle_ce(struct mem_ctl_info *mci,
 			mci->csrows[row].grain, syndrome, row, channel,
 			mci->csrows[row].channels[channel].label, msg);
 
+	edac_snprintf("CE page 0x%lx, offset 0x%lx, grain %d, syndrome "
+			"0x%lx, row %d, channel %d\n",
+			page_frame_number, offset_in_page,
+			mci->csrows[row].grain, syndrome, row, channel);
+
+
 	mci->ce_count++;
 	mci->csrows[row].ce_count++;
 	mci->csrows[row].channels[channel].ce_count++;
diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index 97e64bc..86b374e 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -1,4 +1,6 @@
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <trace/events/mce.h>
 #include "edac_mce_amd.h"
 
 static bool report_gart_errors;
@@ -128,6 +130,33 @@ const char *ext_msgs[] = {
 };
 EXPORT_SYMBOL_GPL(ext_msgs);
 
+static char *decoded_err;
+static unsigned dec_len;
+
+void edac_snprintf(const char *fmt, ...)
+{
+	va_list args;
+	char *buf = decoded_err + dec_len;
+	unsigned size = DECODED_ERR_SZ - dec_len - 1;
+	int i;
+
+	if (dec_len >= DECODED_ERR_SZ-1)
+		return;
+
+	va_start(args, fmt);
+	i = vsnprintf(buf, size, fmt, args);
+	va_end(args);
+
+	if (i >= size) {
+		printk(KERN_ERR "MCE decode buffer truncated.\n");
+		dec_len = DECODED_ERR_SZ-1;
+		decoded_err[dec_len] = '\n';
+	} else {
+		dec_len += i;
+	}
+}
+EXPORT_SYMBOL_GPL(edac_snprintf);
+
 static void amd_decode_dc_mce(u64 mc0_status)
 {
 	u32 ec  = mc0_status & 0xffff;
@@ -304,7 +333,7 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	if (TLB_ERROR(ec) && !report_gart_errors)
 		return;
 
-	pr_emerg(" Northbridge Error, node %d", node_id);
+	edac_snprintf(" Northbridge Error, node %d", node_id);
 
 	/*
 	 * F10h, revD can disable ErrCpu[3:0] so check that first and also the
@@ -313,17 +342,17 @@ void amd_decode_nb_mce(int node_id, struct err_regs *regs, int handle_errors)
 	if ((boot_cpu_data.x86 == 0x10) &&
 	    (boot_cpu_data.x86_model > 7)) {
 		if (regs->nbsh & K8_NBSH_ERR_CPU_VAL)
-			pr_cont(", core: %u\n", (u8)(regs->nbsh & 0xf));
+			edac_snprintf(", core: %u\n", (u8)(regs->nbsh & 0xf));
 	} else {
 		u8 assoc_cpus = regs->nbsh & 0xf;
 
 		if (assoc_cpus > 0)
-			pr_cont(", core: %d", fls(assoc_cpus) - 1);
+			edac_snprintf(", core: %d", fls(assoc_cpus) - 1);
 
-		pr_cont("\n");
+		edac_snprintf("\n");
 	}
 
-	pr_emerg("%s.\n", EXT_ERR_MSG(regs->nbsl));
+	edac_snprintf("%s.\n", EXT_ERR_MSG(regs->nbsl));
 
 	if (BUS_ERROR(ec) && nb_bus_decoder)
 		nb_bus_decoder(node_id, regs);
@@ -342,13 +371,13 @@ static void amd_decode_fr_mce(u64 mc5_status)
 static inline void amd_decode_err_code(unsigned int ec)
 {
 	if (TLB_ERROR(ec)) {
-		pr_emerg(" Transaction: %s, Cache Level %s\n",
+		edac_snprintf(" Transaction: %s, Cache Level %s\n",
 			 TT_MSG(ec), LL_MSG(ec));
 	} else if (MEM_ERROR(ec)) {
-		pr_emerg(" Transaction: %s, Type: %s, Cache Level: %s",
+		edac_snprintf(" Transaction: %s, Type: %s, Cache Level: %s",
 			 RRRR_MSG(ec), TT_MSG(ec), LL_MSG(ec));
 	} else if (BUS_ERROR(ec)) {
-		pr_emerg(" Transaction type: %s(%s), %s, Cache Level: %s, "
+		edac_snprintf(" Transaction type: %s(%s), %s, Cache Level: %s, "
 			 "Participating Processor: %s\n",
 			  RRRR_MSG(ec), II_MSG(ec), TO_MSG(ec), LL_MSG(ec),
 			  PP_MSG(ec));
@@ -363,9 +392,9 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 	struct err_regs regs;
 	int node, ecc;
 
-	pr_emerg("MC%d_STATUS: ", m->bank);
+/* already in the MCE record: pr_emerg("MC%d_STATUS: ", m->bank); */
 
-	pr_cont("%sorrected error, report: %s, MiscV: %svalid, "
+	pr_emerg("%sorrected error, report: %s, MiscV: %svalid, "
 		 "CPU context corrupt: %s",
 		 ((m->status & MCI_STATUS_UC) ? "Unc"  : "C"),
 		 ((m->status & MCI_STATUS_EN) ? "yes"  : "no"),
@@ -416,6 +445,12 @@ static int amd_decode_mce(struct notifier_block *nb, unsigned long val,
 
 	amd_decode_err_code(m->status & 0xffff);
 
+	/* this has to be at the end */
+	pr_emerg("%s\n", decoded_err);
+
+	trace_mce_record(m, decoded_err);
+	dec_len = 0;
+
 	return NOTIFY_STOP;
 }
 
@@ -432,6 +467,10 @@ static int __init mce_amd_init(void)
 	    (boot_cpu_data.x86 >= 0xf))
 		atomic_notifier_chain_register(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 
+	decoded_err = kzalloc(DECODED_ERR_SZ, GFP_KERNEL);
+	if (!decoded_err)
+		return -ENOMEM;
+
 	return 0;
 }
 early_initcall(mce_amd_init);
@@ -439,6 +478,7 @@ early_initcall(mce_amd_init);
 #ifdef MODULE
 static void __exit mce_amd_exit(void)
 {
+	kfree(decoded_err);
 	atomic_notifier_chain_unregister(&x86_mce_decoder_chain, &amd_mce_dec_nb);
 }
 
diff --git a/drivers/edac/edac_mce_amd.h b/drivers/edac/edac_mce_amd.h
index df23ee0..3ff1802 100644
--- a/drivers/edac/edac_mce_amd.h
+++ b/drivers/edac/edac_mce_amd.h
@@ -66,4 +66,5 @@ void amd_register_ecc_decoder(void (*f)(int, struct err_regs *));
 void amd_unregister_ecc_decoder(void (*f)(int, struct err_regs *));
 void amd_decode_nb_mce(int, struct err_regs *, int);
 
+void edac_snprintf(const char *fmt, ...);
 #endif /* _EDAC_MCE_AMD_H */
-- 
1.6.4.4


--k1lZvvs/B4yU6o8G--
