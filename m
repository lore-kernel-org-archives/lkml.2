Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab2JLJdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 05:33:14 -0400
Received: from mail.x86-64.org ([217.9.48.20]:56212 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756579Ab2JLJdN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 05:33:13 -0400
Date: Fri, 12 Oct 2012 11:33:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH v2] Fix AMD Northbridge-ID contiguity assumptions
Message-ID: <20121012093310.GC19420@aftab.osrc.amd.com>
References: <1349270474-28808-1-git-send-email-daniel@numascale-asia.com>
 <20121004131801.GD21028@aftab.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121004131801.GD21028@aftab.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 04, 2012 at 03:18:02PM +0200, Borislav Petkov wrote:
> On Wed, Oct 03, 2012 at 09:21:14PM +0800, Daniel J Blueman wrote:
> > The AMD Northbridge initialisation code and EDAC assume the Northbridge IDs
> > are contiguous, which no longer holds on federated systems with multiple
> > HyperTransport fabrics and multiple PCI domains.
> > 
> > Address this assumption by searching the Northbridge ID array, rather than
> > directly indexing it, using the upper bits for the PCI domain.
> > 
> > v2: Fix Northbridge entry initialisation
> > 
> > Tested on a single-socket system and 3-server federated system.
> > 
> > Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> > ---
> >  arch/x86/include/asm/amd_nb.h |   23 +++++++++++++++++++++--
> >  arch/x86/kernel/amd_nb.c      |   16 +++++++++-------
> >  drivers/edac/amd64_edac.c     |   18 +++++++++---------
> >  drivers/edac/amd64_edac.h     |    6 ------

Ok,

I've been meaning to clean up that amd_nb.c code which iterates over all
PCI devices on the system just so it can count the NBs and then do it
again in order to do the ->misc and ->link assignment.

So below is what I've come up with and it builds but it is completely
untested and I might be completely off, for all I know.

The basic idea, though, is to have the first 8 NB descriptors in an
array of 8 and use that for a fast lookup on all those single-board
machines where the number of the northbridges is the number of physical
processors on the board (or x2, if a MCM).

Then, there's a linked list of all further NB descriptors which should
work in your case of confederated systems.

Btw, I've also reused your get_node_id function and the edac changes are
still pending but they should be trivial once this new approach pans
out.

Thanks.

--
diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index b3341e9cd8fd..14579f836c28 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -4,6 +4,8 @@
 #include <linux/ioport.h>
 #include <linux/pci.h>
 
+#define NUM_POSSIBLE_NBS	8
+
 struct amd_nb_bus_dev_range {
 	u8 bus;
 	u8 dev_base;
@@ -51,12 +53,22 @@ struct amd_northbridge {
 	struct pci_dev *link;
 	struct amd_l3_cache l3_cache;
 	struct threshold_bank *bank4;
+	u32 node;
+	struct list_head nbl;
 };
 
 struct amd_northbridge_info {
 	u16 num;
 	u64 flags;
-	struct amd_northbridge *nb;
+
+	/*
+	 * The first 8 elems are for fast lookup of NB descriptors on single-
+	 * system image setups, i.e. "normal" boxes. The nb_list, OTOH, is a
+	 * list of additional NB descriptors which exist on confederate systems
+	 * like NumaScale.
+	 */
+	struct amd_northbridge *nbs[NUM_POSSIBLE_NBS];
+	struct list_head nb_list;
 };
 extern struct amd_northbridge_info amd_northbridges;
 
@@ -78,7 +90,22 @@ static inline bool amd_nb_has_feature(unsigned feature)
 
 static inline struct amd_northbridge *node_to_amd_nb(int node)
 {
-	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct amd_northbridge *nb, *nb_tmp;
+
+	if (node < NUM_POSSIBLE_NBS && node < nbi->num)
+		return nbi->nbs[node];
+
+	list_for_each_entry_safe(nb, nb_tmp, &nbi->nb_list, nbl)
+		if (node == nb->node)
+			return nb;
+
+	return NULL;
+}
+
+static inline u32 amd_get_node_id(struct pci_dev *pdev)
+{
+	return (pci_domain_nr(pdev->bus) << 8) | (PCI_SLOT(pdev->devfn) - 0x18);
 }
 
 #else
diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index aadf3359e2a7..85b47a907c91 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -50,58 +50,71 @@ static struct pci_dev *next_northbridge(struct pci_dev *dev,
 	return dev;
 }
 
-int amd_cache_northbridges(void)
+static int _alloc_nb_desc(struct pci_dev *misc)
 {
-	u16 i = 0;
+	struct amd_northbridge_info *nbi = &amd_northbridges;
 	struct amd_northbridge *nb;
-	struct pci_dev *misc, *link;
 
-	if (amd_nb_num())
-		return 0;
+	nb = kzalloc(sizeof(*nb), GFP_KERNEL);
+	if (!nb)
+		return -ENOMEM;
+
+	nb->misc = misc;
+	nb->link = next_northbridge(nb->link, amd_nb_link_ids);
+
+	if (nbi->num < NUM_POSSIBLE_NBS) {
+		nbi->nbs[nbi->num] = nb;
+	} else {
+		INIT_LIST_HEAD(&nb->nbl);
+		list_add_tail(&nb->nbl, &nbi->nb_list);
+	}
+
+	nb->node = amd_get_node_id(misc);
+	nbi->num++;
+
+	return 0;
+}
 
-	misc = NULL;
-	while ((misc = next_northbridge(misc, amd_nb_misc_ids)) != NULL)
-		i++;
+int amd_cache_northbridges(void)
+{
+	struct amd_northbridge_info *nbi = &amd_northbridges;
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	struct pci_dev *misc = NULL;
 
-	if (i == 0)
+	if (amd_nb_num())
 		return 0;
 
-	nb = kzalloc(i * sizeof(struct amd_northbridge), GFP_KERNEL);
-	if (!nb)
-		return -ENOMEM;
+	INIT_LIST_HEAD(&nbi->nb_list);
 
-	amd_northbridges.nb = nb;
-	amd_northbridges.num = i;
+	do {
+		misc = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, misc);
+		if (!misc)
+			break;
 
-	link = misc = NULL;
-	for (i = 0; i != amd_nb_num(); i++) {
-		node_to_amd_nb(i)->misc = misc =
-			next_northbridge(misc, amd_nb_misc_ids);
-		node_to_amd_nb(i)->link = link =
-			next_northbridge(link, amd_nb_link_ids);
-        }
+		if (pci_match_id(amd_nb_misc_ids, misc)) {
+			if (_alloc_nb_desc(misc) < 0)
+				return -ENOMEM;
+		}
+	} while (misc);
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
-	    boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_GART;
+	if (c->x86 == 0xf || c->x86 == 0x10 || c->x86 == 0x15)
+		nbi->flags |= AMD_NB_GART;
 
 	/*
 	 * Some CPU families support L3 Cache Index Disable. There are some
 	 * limitations because of E382 and E388 on family 0x10.
 	 */
-	if (boot_cpu_data.x86 == 0x10 &&
-	    boot_cpu_data.x86_model >= 0x8 &&
-	    (boot_cpu_data.x86_model > 0x9 ||
-	     boot_cpu_data.x86_mask >= 0x1))
-		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+	if (c->x86 == 0x10 && c->x86_model >= 0x8 &&
+	    (c->x86_model > 0x9 || c->x86_mask >= 0x1))
+		nbi->flags |= AMD_NB_L3_INDEX_DISABLE;
 
-	if (boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_L3_INDEX_DISABLE;
+	if (c->x86 == 0x15)
+		nbi->flags |= AMD_NB_L3_INDEX_DISABLE;
 
 	/* L3 cache partitioning is supported on family 0x15 */
-	if (boot_cpu_data.x86 == 0x15)
-		amd_northbridges.flags |= AMD_NB_L3_PARTITIONING;
+	if (c->x86 == 0x15)
+		nbi->flags |= AMD_NB_L3_PARTITIONING;
 
 	return 0;
 }

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
