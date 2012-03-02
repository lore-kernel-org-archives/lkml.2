Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964913Ab2CBOZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:25:37 -0500
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:49359 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757205Ab2CBOZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:25:34 -0500
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 1/4] mce: Slim up struct mce
Date: Fri,  2 Mar 2012 15:25:11 +0100
Message-Id: <1330698314-9863-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.8.rc0
In-Reply-To: <1330698314-9863-1-git-send-email-bp@amd64.org>
References: <1330698314-9863-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Drop unused ->apicid, make ->socketid __u16 since it is copied from
struct cpuinfo_86.phys_proc_id, reorder members and adjust padding so
that it remains packed and on a 64-byte boundary.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/mce.h              |   12 +++++-------
 arch/x86/kernel/cpu/mcheck/mce-inject.c |    8 ++++----
 arch/x86/kernel/cpu/mcheck/mce.c        |   13 ++++++-------
 drivers/edac/amd64_edac.c               |    2 +-
 drivers/edac/mce_amd.c                  |    4 ++--
 include/trace/events/mce.h              |   11 ++++-------
 6 files changed, 22 insertions(+), 28 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 6aefb14cbbc5..42e209e32231 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -67,15 +67,13 @@ struct mce {
 	__u64 time;	/* wall time_t when error was detected */
 	__u8  cpuvendor;	/* cpu vendor as encoded in system.h */
 	__u8  inject_flags;	/* software inject flags */
-	__u16  pad;
+	__u8  pad;
+	__u8  cs;	/* code segment */
 	__u32 cpuid;	/* CPUID 1 EAX */
-	__u8  cs;		/* code segment */
 	__u8  bank;	/* machine check bank */
-	__u8  cpu;	/* cpu number; obsolete; use extcpu now */
-	__u8  finished;   /* entry is valid */
-	__u32 extcpu;	/* linux cpu number that detected the error */
-	__u32 socketid;	/* CPU socket ID */
-	__u32 apicid;	/* CPU initial apic ID */
+	__u8  finished; /* entry is valid */
+	__u16 socketid;	/* CPU socket ID */
+	__u32 cpu;	/* linux cpu number that detected the error */
 	__u64 mcgcap;	/* MCGCAP MSR: machine check capabilities of CPU */
 };
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce-inject.c b/arch/x86/kernel/cpu/mcheck/mce-inject.c
index fc4beb393577..a19eace708f1 100644
--- a/arch/x86/kernel/cpu/mcheck/mce-inject.c
+++ b/arch/x86/kernel/cpu/mcheck/mce-inject.c
@@ -31,14 +31,14 @@
 /* Update fake mce registers on current CPU. */
 static void inject_mce(struct mce *m)
 {
-	struct mce *i = &per_cpu(injectm, m->extcpu);
+	struct mce *i = &per_cpu(injectm, m->cpu);
 
 	/* Make sure no one reads partially written injectm */
 	i->finished = 0;
 	mb();
 	m->finished = 0;
 	/* First set the fields after finished */
-	i->extcpu = m->extcpu;
+	i->cpu = m->cpu;
 	mb();
 	/* Now write record in order, finished last (except above) */
 	memcpy(i, m, sizeof(struct mce));
@@ -111,7 +111,7 @@ static int raise_local(void)
 	struct mce *m = &__get_cpu_var(injectm);
 	int context = MCJ_CTX(m->inject_flags);
 	int ret = 0;
-	int cpu = m->extcpu;
+	int cpu = m->cpu;
 
 	if (m->inject_flags & MCJ_EXCEPTION) {
 		printk(KERN_INFO "Triggering MCE exception on CPU %d\n", cpu);
@@ -217,7 +217,7 @@ static ssize_t mce_write(struct file *filp, const char __user *ubuf,
 	if (copy_from_user(&m, ubuf, usize))
 		return -EFAULT;
 
-	if (m.extcpu >= num_possible_cpus() || !cpu_online(m.extcpu))
+	if (m.cpu >= num_possible_cpus() || !cpu_online(m.cpu))
 		return -EINVAL;
 
 	/*
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5a11ae2e9e91..a30d7af18e66 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -112,14 +112,13 @@ ATOMIC_NOTIFIER_HEAD(x86_mce_decoder_chain);
 void mce_setup(struct mce *m)
 {
 	memset(m, 0, sizeof(struct mce));
-	m->cpu = m->extcpu = smp_processor_id();
+	m->cpu = smp_processor_id();
 	rdtscll(m->tsc);
 	/* We hope get_seconds stays lockless */
 	m->time = get_seconds();
 	m->cpuvendor = boot_cpu_data.x86_vendor;
 	m->cpuid = cpuid_eax(1);
-	m->socketid = cpu_data(m->extcpu).phys_proc_id;
-	m->apicid = cpu_data(m->extcpu).initial_apicid;
+	m->socketid = cpu_data(m->cpu).phys_proc_id;
 	rdmsrl(MSR_IA32_MCG_CAP, m->mcgcap);
 }
 
@@ -243,7 +242,7 @@ static void print_mce(struct mce *m)
 	int ret = 0;
 
 	pr_emerg(HW_ERR "CPU %d: Machine Check Exception: %Lx Bank %d: %016Lx\n",
-	       m->extcpu, m->mcgstatus, m->bank, m->status);
+	       m->cpu, m->mcgstatus, m->bank, m->status);
 
 	if (m->ip) {
 		pr_emerg(HW_ERR "RIP%s %02x:<%016Lx> ",
@@ -266,9 +265,9 @@ static void print_mce(struct mce *m)
 	 * Note this output is parsed by external tools and old fields
 	 * should not be changed.
 	 */
-	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x microcode %x\n",
-		m->cpuvendor, m->cpuid, m->time, m->socketid, m->apicid,
-		cpu_data(m->extcpu).microcode);
+	pr_emerg(HW_ERR "PROCESSOR %u:%x TIME %llu SOCKET %u microcode %x\n",
+		m->cpuvendor, m->cpuid, m->time, m->socketid,
+		cpu_data(m->cpu).microcode);
 
 	/*
 	 * Print out human-readable details about the MCE error,
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index c9eee6d33e9a..08413377a43b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -972,7 +972,7 @@ static u64 get_error_address(struct mce *m)
 		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
 			return addr;
 
-		mce_nid	= amd_get_nb_id(m->extcpu);
+		mce_nid	= amd_get_nb_id(m->cpu);
 		pvt	= mcis[mce_nid]->pvt_info;
 
 		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_LIM, &tmp);
diff --git a/drivers/edac/mce_amd.c b/drivers/edac/mce_amd.c
index bd926ea2e00c..7752f81fa4d6 100644
--- a/drivers/edac/mce_amd.c
+++ b/drivers/edac/mce_amd.c
@@ -595,7 +595,7 @@ static bool nb_noop_mce(u16 ec, u8 xec)
 void amd_decode_nb_mce(struct mce *m)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
-	int node_id = amd_get_nb_id(m->extcpu);
+	int node_id = amd_get_nb_id(m->cpu);
 	u16 ec = EC(m->status);
 	u8 xec = XEC(m->status, 0x1f);
 
@@ -753,7 +753,7 @@ int amd_decode_mce(struct notifier_block *nb, unsigned long val, void *data)
 		return NOTIFY_STOP;
 
 	pr_emerg(HW_ERR "CPU:%d\tMC%d_STATUS[%s|%s|%s|%s|%s",
-		m->extcpu, m->bank,
+		m->cpu, m->bank,
 		((m->status & MCI_STATUS_OVER)	? "Over"  : "-"),
 		((m->status & MCI_STATUS_UC)	? "UE"	  : "CE"),
 		((m->status & MCI_STATUS_MISCV)	? "MiscV" : "-"),
diff --git a/include/trace/events/mce.h b/include/trace/events/mce.h
index 4cbbcef6baa8..4c1740ac7889 100644
--- a/include/trace/events/mce.h
+++ b/include/trace/events/mce.h
@@ -25,8 +25,7 @@ TRACE_EVENT(mce_record,
 		__field(	u64,		walltime	)
 		__field(	u32,		cpu		)
 		__field(	u32,		cpuid		)
-		__field(	u32,		apicid		)
-		__field(	u32,		socketid	)
+		__field(	u16,		socketid	)
 		__field(	u8,		cs		)
 		__field(	u8,		bank		)
 		__field(	u8,		cpuvendor	)
@@ -41,16 +40,15 @@ TRACE_EVENT(mce_record,
 		__entry->ip		= m->ip;
 		__entry->tsc		= m->tsc;
 		__entry->walltime	= m->time;
-		__entry->cpu		= m->extcpu;
+		__entry->cpu		= m->cpu;
 		__entry->cpuid		= m->cpuid;
-		__entry->apicid		= m->apicid;
 		__entry->socketid	= m->socketid;
 		__entry->cs		= m->cs;
 		__entry->bank		= m->bank;
 		__entry->cpuvendor	= m->cpuvendor;
 	),
 
-	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x",
+	TP_printk("CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u",
 		__entry->cpu,
 		__entry->mcgcap, __entry->mcgstatus,
 		__entry->bank, __entry->status,
@@ -59,8 +57,7 @@ TRACE_EVENT(mce_record,
 		__entry->tsc,
 		__entry->cpuvendor, __entry->cpuid,
 		__entry->walltime,
-		__entry->socketid,
-		__entry->apicid)
+		__entry->socketid)
 );
 
 #endif /* _TRACE_MCE_H */
-- 
1.7.8.rc0

