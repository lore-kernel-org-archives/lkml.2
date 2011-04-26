Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab1DZPD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 11:03:28 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:58591
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756207Ab1DZPD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 11:03:26 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zz936eKc3f2Mzz1202hzz8275bh8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LK9LSU-01-2WF-02
X-M-MSG: 
Date: Tue, 26 Apr 2011 17:02:31 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] amd64_edac fixes for 39-rc5
Message-ID: <20110426150231.GC24614@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the git branch below to receive the following updates.

Now the first two are small enough but the last two are not one liners
and don't generally look like -rc5 material. I've added them below for
reference.

They are a software-only fix for a address reporting issue where F15h
CPUs might return wrong error addresses when reporting an MCE.

The reason I'm sending them to you now is because F15h support for
amd64_edac went in with the .39 merge window and amd64_edac in .39 would
be broken without that fix. Concerning the risk, I don't see any since
this code affects F15h _only_ and these CPUs are not being sold yet;
therefore, nothing changes for the remaining families.

So, I'd appreciate if you pulled now so that .39 is not affected but if
you still think it is too risky, I'll understand and will backport them
when their time has come.

Thanks a lot!

The following changes since commit f0e615c3cb72b42191b558c130409335812621d8:

  Linux 2.6.39-rc4 (2011-04-18 21:26:00 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git for-linus

Borislav Petkov (3):
      amd64_edac: Remove node interleave warning
      amd64_edac: Factor in CC6 save area
      amd64_edac: Erratum #637 workaround

Markus Trippelsdorf (1):
      EDAC: Remove debugging output in scrub rate handling

 drivers/edac/amd64_edac.c    |   88 +++++++++++++++++++++++++++++++++++++-----
 drivers/edac/amd64_edac.h    |    3 +
 drivers/edac/edac_mc_sysfs.c |   11 ++---
 3 files changed, 86 insertions(+), 16 deletions(-)

--
commit c1ae68309b0c1ea67b72e9e94e26b4e819022fc7
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Wed Mar 30 15:42:10 2011 +0200

    amd64_edac: Erratum #637 workaround
    
    F15h CPUs may report a non-DRAM address when reporting an error address
    belonging to a CC6 state save area. Add a workaround to detect this
    condition and compute the actual DRAM address of the error as documented
    in the Revision Guide for AMD Family 15h Models 00h-0Fh Processors.
    
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index e17de90b..9a8bebc 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -931,15 +931,63 @@ static int k8_early_channel_count(struct amd64_pvt *pvt)
 /* On F10h and later ErrAddr is MC4_ADDR[47:1] */
 static u64 get_error_address(struct mce *m)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
+	u64 addr;
 	u8 start_bit = 1;
 	u8 end_bit   = 47;
 
-	if (boot_cpu_data.x86 == 0xf) {
+	if (c->x86 == 0xf) {
 		start_bit = 3;
 		end_bit   = 39;
 	}
 
-	return m->addr & GENMASK(start_bit, end_bit);
+	addr = m->addr & GENMASK(start_bit, end_bit);
+
+	/*
+	 * Erratum 637 workaround
+	 */
+	if (c->x86 == 0x15) {
+		struct amd64_pvt *pvt;
+		u64 cc6_base, tmp_addr;
+		u32 tmp;
+		u8 mce_nid, intlv_en;
+
+		if ((addr & GENMASK(24, 47)) >> 24 != 0x00fdf7)
+			return addr;
+
+		mce_nid	= amd_get_nb_id(m->extcpu);
+		pvt	= mcis[mce_nid]->pvt_info;
+
+		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_LIM, &tmp);
+		intlv_en = tmp >> 21 & 0x7;
+
+		/* add [47:27] + 3 trailing bits */
+		cc6_base  = (tmp & GENMASK(0, 20)) << 3;
+
+		/* reverse and add DramIntlvEn */
+		cc6_base |= intlv_en ^ 0x7;
+
+		/* pin at [47:24] */
+		cc6_base <<= 24;
+
+		if (!intlv_en)
+			return cc6_base | (addr & GENMASK(0, 23));
+
+		amd64_read_pci_cfg(pvt->F1, DRAM_LOCAL_NODE_BASE, &tmp);
+
+							/* faster log2 */
+		tmp_addr  = (addr & GENMASK(12, 23)) << __fls(intlv_en + 1);
+
+		/* OR DramIntlvSel into bits [14:12] */
+		tmp_addr |= (tmp & GENMASK(21, 23)) >> 9;
+
+		/* add remaining [11:0] bits from original MC4_ADDR */
+		tmp_addr |= addr & GENMASK(0, 11);
+
+		return cc6_base | tmp_addr;
+	}
+
+	return addr;
 }
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 0110930..9a666cb 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -196,6 +196,7 @@
 
 #define DCT_CFG_SEL			0x10C
 
+#define DRAM_LOCAL_NODE_BASE		0x120
 #define DRAM_LOCAL_NODE_LIM		0x124
 
 #define DRAM_BASE_HI			0x140

commit f08e457cecece7fbbdad3add9defac3373a59b5a
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Mon Mar 21 20:45:06 2011 +0100

    amd64_edac: Factor in CC6 save area
    
    F15h and later use a portion of DRAM as a CC6 storage area. BIOS
    programs D18F1x[17C:140,7C:40] DRAM Base/Limit accordingly by
    subtracting the storage area from the DRAM limit setting. However, in
    order for edac to consider that part of DRAM too, we need to include it
    into the per-node range.
    
    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 601142a..e17de90b 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -944,12 +944,13 @@ static u64 get_error_address(struct mce *m)
 
 static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 {
+	struct cpuinfo_x86 *c = &boot_cpu_data;
 	int off = range << 3;
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_LO + off,  &pvt->ranges[range].base.lo);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_LO + off, &pvt->ranges[range].lim.lo);
 
-	if (boot_cpu_data.x86 == 0xf)
+	if (c->x86 == 0xf)
 		return;
 
 	if (!dram_rw(pvt, range))
@@ -957,6 +958,31 @@ static void read_dram_base_limit_regs(struct amd64_pvt *pvt, unsigned range)
 
 	amd64_read_pci_cfg(pvt->F1, DRAM_BASE_HI + off,  &pvt->ranges[range].base.hi);
 	amd64_read_pci_cfg(pvt->F1, DRAM_LIMIT_HI + off, &pvt->ranges[range].lim.hi);
+
+	/* Factor in CC6 save area by reading dst node's limit reg */
+	if (c->x86 == 0x15) {
+		struct pci_dev *f1 = NULL;
+		u8 nid = dram_dst_node(pvt, range);
+		u32 llim;
+
+		f1 = pci_get_domain_bus_and_slot(0, 0, PCI_DEVFN(0x18 + nid, 1));
+		if (WARN_ON(!f1))
+			return;
+
+		amd64_read_pci_cfg(f1, DRAM_LOCAL_NODE_LIM, &llim);
+
+		pvt->ranges[range].lim.lo &= GENMASK(0, 15);
+
+					    /* {[39:27],111b} */
+		pvt->ranges[range].lim.lo |= ((llim & 0x1fff) << 3 | 0x7) << 16;
+
+		pvt->ranges[range].lim.hi &= GENMASK(0, 7);
+
+					    /* [47:40] */
+		pvt->ranges[range].lim.hi |= llim >> 13;
+
+		pci_dev_put(f1);
+	}
 }
 
 static void k8_map_sysaddr_to_csrow(struct mem_ctl_info *mci, u64 sys_addr,
diff --git a/drivers/edac/amd64_edac.h b/drivers/edac/amd64_edac.h
index 11be36a..0110930 100644
--- a/drivers/edac/amd64_edac.h
+++ b/drivers/edac/amd64_edac.h
@@ -196,6 +196,8 @@
 
 #define DCT_CFG_SEL			0x10C
 
+#define DRAM_LOCAL_NODE_LIM		0x124
+
 #define DRAM_BASE_HI			0x140
 #define DRAM_LIMIT_HI			0x144
 

-- 
Regards/Gruss,
Boris.

Operating Systems Research Center
Advanced Micro Devices, Inc.

