Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535Ab1JZP7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 11:59:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59972 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933036Ab1JZP7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 11:59:35 -0400
Date: Wed, 26 Oct 2011 17:57:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/uv change for v3.2
Message-ID: <20111026155756.GA5379@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-uv-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uv-for-linus

 Thanks,

	Ingo

------------------>
Jack Steiner (1):
      x86: uv2: Workaround for UV2 Hub bug (system global address format)


 arch/x86/include/asm/uv/uv_bau.h   |    1 +
 arch/x86/include/asm/uv/uv_hub.h   |   37 +++++++++++++++++++++++++++++++++--
 arch/x86/kernel/apic/x2apic_uv_x.c |    7 ++++-
 arch/x86/platform/uv/tlb_uv.c      |   17 +++++----------
 4 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/uv/uv_bau.h b/arch/x86/include/asm/uv/uv_bau.h
index 37d3698..0c767a8 100644
--- a/arch/x86/include/asm/uv/uv_bau.h
+++ b/arch/x86/include/asm/uv/uv_bau.h
@@ -55,6 +55,7 @@
 #define UV_BAU_TUNABLES_DIR		"sgi_uv"
 #define UV_BAU_TUNABLES_FILE		"bau_tunables"
 #define WHITESPACE			" \t\n"
+#define uv_mmask			((1UL << uv_hub_info->m_val) - 1)
 #define uv_physnodeaddr(x)		((__pa((unsigned long)(x)) & uv_mmask))
 #define cpubit_isset(cpu, bau_local_cpumask) \
 	test_bit((cpu), (bau_local_cpumask).bits)
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index f26544a..54a13aa 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -46,6 +46,13 @@
  *	PNODE   - the low N bits of the GNODE. The PNODE is the most useful variant
  *		  of the nasid for socket usage.
  *
+ *	GPA	- (global physical address) a socket physical address converted
+ *		  so that it can be used by the GRU as a global address. Socket
+ *		  physical addresses 1) need additional NASID (node) bits added
+ *		  to the high end of the address, and 2) unaliased if the
+ *		  partition does not have a physical address 0. In addition, on
+ *		  UV2 rev 1, GPAs need the gnode left shifted to bits 39 or 40.
+ *
  *
  *  NumaLink Global Physical Address Format:
  *  +--------------------------------+---------------------+
@@ -141,6 +148,8 @@ struct uv_hub_info_s {
 	unsigned int		gnode_extra;
 	unsigned char		hub_revision;
 	unsigned char		apic_pnode_shift;
+	unsigned char		m_shift;
+	unsigned char		n_lshift;
 	unsigned long		gnode_upper;
 	unsigned long		lowmem_remap_top;
 	unsigned long		lowmem_remap_base;
@@ -177,6 +186,16 @@ static inline int is_uv2_hub(void)
 	return uv_hub_info->hub_revision >= UV2_HUB_REVISION_BASE;
 }
 
+static inline int is_uv2_1_hub(void)
+{
+	return uv_hub_info->hub_revision == UV2_HUB_REVISION_BASE;
+}
+
+static inline int is_uv2_2_hub(void)
+{
+	return uv_hub_info->hub_revision == UV2_HUB_REVISION_BASE + 1;
+}
+
 union uvh_apicid {
     unsigned long       v;
     struct uvh_apicid_s {
@@ -276,7 +295,10 @@ static inline unsigned long uv_soc_phys_ram_to_gpa(unsigned long paddr)
 {
 	if (paddr < uv_hub_info->lowmem_remap_top)
 		paddr |= uv_hub_info->lowmem_remap_base;
-	return paddr | uv_hub_info->gnode_upper;
+	paddr |= uv_hub_info->gnode_upper;
+	paddr = ((paddr << uv_hub_info->m_shift) >> uv_hub_info->m_shift) |
+		((paddr >> uv_hub_info->m_val) << uv_hub_info->n_lshift);
+	return paddr;
 }
 
 
@@ -300,16 +322,19 @@ static inline unsigned long uv_gpa_to_soc_phys_ram(unsigned long gpa)
 	unsigned long remap_base = uv_hub_info->lowmem_remap_base;
 	unsigned long remap_top =  uv_hub_info->lowmem_remap_top;
 
+	gpa = ((gpa << uv_hub_info->m_shift) >> uv_hub_info->m_shift) |
+		((gpa >> uv_hub_info->n_lshift) << uv_hub_info->m_val);
+	gpa = gpa & uv_hub_info->gpa_mask;
 	if (paddr >= remap_base && paddr < remap_base + remap_top)
 		paddr -= remap_base;
 	return paddr;
 }
 
 
-/* gnode -> pnode */
+/* gpa -> pnode */
 static inline unsigned long uv_gpa_to_gnode(unsigned long gpa)
 {
-	return gpa >> uv_hub_info->m_val;
+	return gpa >> uv_hub_info->n_lshift;
 }
 
 /* gpa -> pnode */
@@ -320,6 +345,12 @@ static inline int uv_gpa_to_pnode(unsigned long gpa)
 	return uv_gpa_to_gnode(gpa) & n_mask;
 }
 
+/* gpa -> node offset*/
+static inline unsigned long uv_gpa_to_offset(unsigned long gpa)
+{
+	return (gpa << uv_hub_info->m_shift) >> uv_hub_info->m_shift;
+}
+
 /* pnode, offset --> socket virtual */
 static inline void *uv_pnode_offset_to_vaddr(int pnode, unsigned long offset)
 {
diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 34b1859..cfeb978 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -832,6 +832,10 @@ void __init uv_system_init(void)
 		uv_cpu_hub_info(cpu)->apic_pnode_shift = uvh_apicid.s.pnode_shift;
 		uv_cpu_hub_info(cpu)->hub_revision = uv_hub_info->hub_revision;
 
+		uv_cpu_hub_info(cpu)->m_shift = 64 - m_val;
+		uv_cpu_hub_info(cpu)->n_lshift = is_uv2_1_hub() ?
+				(m_val == 40 ? 40 : 39) : m_val;
+
 		pnode = uv_apicid_to_pnode(apicid);
 		blade = boot_pnode_to_blade(pnode);
 		lcpu = uv_blade_info[blade].nr_possible_cpus;
@@ -862,8 +866,7 @@ void __init uv_system_init(void)
 		if (uv_node_to_blade[nid] >= 0)
 			continue;
 		paddr = node_start_pfn(nid) << PAGE_SHIFT;
-		paddr = uv_soc_phys_ram_to_gpa(paddr);
-		pnode = (paddr >> m_val) & pnode_mask;
+		pnode = uv_gpa_to_pnode(uv_soc_phys_ram_to_gpa(paddr));
 		blade = boot_pnode_to_blade(pnode);
 		uv_node_to_blade[nid] = blade;
 	}
diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index db8b915..5b55219 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -115,9 +115,6 @@ early_param("nobau", setup_nobau);
 
 /* base pnode in this partition */
 static int uv_base_pnode __read_mostly;
-/* position of pnode (which is nasid>>1): */
-static int uv_nshift __read_mostly;
-static unsigned long uv_mmask __read_mostly;
 
 static DEFINE_PER_CPU(struct ptc_stats, ptcstats);
 static DEFINE_PER_CPU(struct bau_control, bau_control);
@@ -1435,7 +1432,7 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
 {
 	int i;
 	int cpu;
-	unsigned long pa;
+	unsigned long gpa;
 	unsigned long m;
 	unsigned long n;
 	size_t dsize;
@@ -1451,9 +1448,9 @@ static void activation_descriptor_init(int node, int pnode, int base_pnode)
 	bau_desc = kmalloc_node(dsize, GFP_KERNEL, node);
 	BUG_ON(!bau_desc);
 
-	pa = uv_gpa(bau_desc); /* need the real nasid*/
-	n = pa >> uv_nshift;
-	m = pa & uv_mmask;
+	gpa = uv_gpa(bau_desc);
+	n = uv_gpa_to_gnode(gpa);
+	m = uv_gpa_to_offset(gpa);
 
 	/* the 14-bit pnode */
 	write_mmr_descriptor_base(pnode, (n << UV_DESC_PSHIFT | m));
@@ -1525,9 +1522,9 @@ static void pq_init(int node, int pnode)
 		bcp->queue_last		= pqp + (DEST_Q_SIZE - 1);
 	}
 	/*
-	 * need the pnode of where the memory was really allocated
+	 * need the gnode of where the memory was really allocated
 	 */
-	pn = uv_gpa(pqp) >> uv_nshift;
+	pn = uv_gpa_to_gnode(uv_gpa(pqp));
 	first = uv_physnodeaddr(pqp);
 	pn_first = ((unsigned long)pn << UV_PAYLOADQ_PNODE_SHIFT) | first;
 	last = uv_physnodeaddr(pqp + (DEST_Q_SIZE - 1));
@@ -1837,8 +1834,6 @@ static int __init uv_bau_init(void)
 		zalloc_cpumask_var_node(mask, GFP_KERNEL, cpu_to_node(cur_cpu));
 	}
 
-	uv_nshift = uv_hub_info->m_val;
-	uv_mmask = (1UL << uv_hub_info->m_val) - 1;
 	nuvhubs = uv_num_possible_blades();
 	spin_lock_init(&disable_lock);
 	congested_cycles = usec_2_cycles(congested_respns_us);
