Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab0JTPW7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 11:22:59 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50170 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753652Ab0JTPW5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 11:22:57 -0400
From: "Guzman Lugo, Fernando" <fernando.lugo@ti.com>
To: "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
CC: "Hiroshi.DOYU@nokia.com" <Hiroshi.DOYU@nokia.com>,
        "felipe.contreras@nokia.com" <felipe.contreras@nokia.com>,
        "david.cohen@nokia.com" <david.cohen@nokia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Wed, 20 Oct 2010 10:22:49 -0500
Subject: RE: [PATCHv4 4/4] iommu: create new api to set valid da range
Thread-Topic: [PATCHv4 4/4] iommu: create new api to set valid da range
Thread-Index: ActwMc5BOuU3bOZ7QL63DnGIeA4L7wANmd3A
Message-ID: <496565EC904933469F292DDA3F1663E602F4935CD8@dlee06.ent.ti.com>
References: <1287542932-14206-1-git-send-email-x0095840@ti.com>
	<1287542932-14206-2-git-send-email-x0095840@ti.com>
	<1287542932-14206-3-git-send-email-x0095840@ti.com>
	<1287542932-14206-4-git-send-email-x0095840@ti.com>
	<1287542932-14206-5-git-send-email-x0095840@ti.com>
 <AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
In-Reply-To: <AANLkTimSQabHv3AOFFR4m3POjmuGvN18u7TNsPyauH8D@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: felipe.contreras@gmail.com [mailto:felipe.contreras@gmail.com] 
> Sent: Wednesday, October 20, 2010 3:36 AM
> To: Guzman Lugo, Fernando
> Cc: Hiroshi.DOYU@nokia.com; felipe.contreras@nokia.com; 
> david.cohen@nokia.com; linux-kernel@vger.kernel.org; 
> linux-omap@vger.kernel.org
> Subject: Re: [PATCHv4 4/4] iommu: create new api to set valid da range
> 
> On Wed, Oct 20, 2010 at 5:48 AM, Fernando Guzman Lugo 
> <x0095840@ti.com> wrote:
> > Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF range.
> > With this new API the valid range can be set.
> >
> > Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> 
> I don't see the point in having an API. It could be done 

Thanks to this api we can make this:


A new kconfig parameter for DMM size is added. Also DMM is
allocated in the last part of the IVA MMU capable address.
So that DMM address are far away of shared memory address
reducing the probability of shared memory corruption.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 drivers/staging/tidspbridge/Kconfig                |    8 ++++++++
 drivers/staging/tidspbridge/core/tiomap3430.c      |   18 ++++++++++++++++--
 .../tidspbridge/include/dspbridge/dsp-mmu.h        |    3 +++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/tidspbridge/Kconfig b/drivers/staging/tidspbridge/Kconfig
index 672008f..37e47f5 100644
--- a/drivers/staging/tidspbridge/Kconfig
+++ b/drivers/staging/tidspbridge/Kconfig
@@ -42,6 +42,14 @@ config TIDSPBRIDGE_MEMPOOL_SIZE
 	  Allocate specified size of memory at booting time to avoid allocation
 	  failure under heavy memory fragmentation after some use time.
 
+config TIDSPBRIDGE_DMM_SIZE
+	hex "DMM capable memory size (Byte)"
+	depends on TIDSPBRIDGE
+	default "0x10000000"
+	help
+	  Memory size of DSP virtural address for Dynamic Memory Mapping.
+	  Please make sure the size is 4K aligned.
+
 config TIDSPBRIDGE_DEBUG
 	bool "Debug Support"
 	depends on TIDSPBRIDGE
diff --git a/drivers/staging/tidspbridge/core/tiomap3430.c b/drivers/staging/tidspbridge/core/tiomap3430.c
index c28dcf1..31f1dd6 100644
--- a/drivers/staging/tidspbridge/core/tiomap3430.c
+++ b/drivers/staging/tidspbridge/core/tiomap3430.c
@@ -345,7 +345,6 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 					OMAP343X_CONTROL_IVA2_BOOTMOD));
 		}
 	}
-
 	if (!status) {
 		(*pdata->dsp_prm_rmw_bits)(OMAP3430_RST2_IVA2_MASK, 0,
 					OMAP3430_IVA2_MOD, OMAP2_RM_RSTCTRL);
@@ -362,6 +361,11 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 	if (!status) {
 		dev_context->dsp_mmu = mmu;
 		sm_sg = &dev_context->sh_s;
+		/* Set valid range to map shared memory */
+		status = iommu_set_da_range(mmu, sm_sg->seg0_da,
+					sm_sg->seg1_da + sm_sg->seg1_size);
+	}
+	if (!status) {
 		sg0_da = iommu_kmap(mmu, sm_sg->seg0_da, sm_sg->seg0_pa,
 			sm_sg->seg0_size, IOVMF_ENDIAN_LITTLE | IOVMF_ELSZ_32);
 		if (IS_ERR_VALUE(sg0_da)) {
@@ -411,7 +415,17 @@ static int bridge_brd_start(struct bridge_dev_context *dev_ctxt,
 			l4_i++;
 		}
 	}
-
+	if (!status) {
+		/* Set valid range for DMM mapings */
+		if (MAX_DSP_MMU_DA - CONFIG_TIDSPBRIDGE_DMM_SIZE <
+					sm_sg->seg1_da + sm_sg->seg1_size) {
+			dev_err(bridge, "DMM size too big!\n");
+			status = -ENOMEM;
+		} else {
+			status = iommu_set_da_range(mmu, MAX_DSP_MMU_DA -
+				CONFIG_TIDSPBRIDGE_DMM_SIZE, MAX_DSP_MMU_DA);
+		}
+	}
 	/* Lock the above TLB entries and get the BIOS and load monitor timer
 	 * information */
 	if (!status) {
diff --git a/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h b/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
index cb38d4c..bbbe9e6 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/dsp-mmu.h
@@ -22,6 +22,9 @@
 #include <plat/iommu.h>
 #include <plat/iovmm.h>
 
+/* Last patch is not mapped to detect buffer overflow in DSP side */
+#define MAX_DSP_MMU_DA 0xFFFFF000
+
 /**
  * dsp_mmu_init() - initialize dsp_mmu module and returns a handle
  *
-- 
1.6.3.3

With this patch we ara mapping SHM (shared memory) at the beginning of 
Iva2 iommu capabile address, it is from 0x11000000 to 0x203f0000 which 
Include some parts not used. And we can mapped the DMM at the end of
The Iva2 iommu capable address it is from 0xFFFFF000 - DMMSIZE to 0xFFFFF000.

This way we have separated the DMM part from SHM range and DMM buffer can not
Be allocated near to SHM segments or in the part not used between SHM the segments.
With this we make more unlikely an unintentional corruption of SHM memory by
Some node running on the DSP side. Also we avoid an underflow of some buffer below
0xFFFFF000 - DMMSIZE because that part would be always unmapped and would trigger
A mmufualt. Aso the overflow of the last buffer is avoid too, because it will 
trigger a mmufault when it reach last page (0xFFFFF000) because it is never mapped.
Moreover avoid and address overflow (0xFFFFFFFF + 0x1) which would write DSP memory 
Area (0x0 to 0x10FFFFFF).

So I have some advantages having that control. Please let me know what you think.
I can move the elements to platform data if you want, I am agree with that change.

The patch I showed above would be sent if this patch is accepted and after merging it.

Regards,
Fernando.

> through platform data, and the usage of 0xFFFFF000 instead of 
> ULONG_MAX is independent of this.
> 



[snip]
> Felipe Contreras
> 