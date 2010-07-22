Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab0GVBPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:15:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:23456 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537Ab0GVBPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:15:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.55,240,1278313200"; 
   d="scan'208";a="302928887"
Message-ID: <4C479BB1.8020102@intel.com>
Date: Wed, 21 Jul 2010 18:15:29 -0700
From: Dan Williams <dan.j.williams@intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Chris Li <lkml@chrisli.org>
CC: David Woodhouse <dwmw2@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: BUG in drivers/dma/ioat/dma_v2.c:314
References: <AANLkTinMqI7hmBYt4eN2oTLZt9_FkoNDHb-9ZF3Z7vls@mail.gmail.com>	<4C2B9DAC.1030806@intel.com>	<1277928125.18854.0.camel@localhost>	<4C2BBACF.3080405@intel.com>	<1277965264.18854.16.camel@localhost>	<4C2C3B07.7050200@intel.com>	<1277968336.4945.3.camel@localhost>	<4C2C4319.6090906@intel.com>	<1277972137.12558.2.camel@localhost>	<4C2CCE67.6070600@intel.com>	<AANLkTimeNp4mMI-6IEl-zlv1DcFF5SyAD4k5O3ZLuCwM@mail.gmail.com>	<AANLkTimNPP00pJewLtlk0SJQYjGUCyBWoxzGbTYltGsM@mail.gmail.com>	<1278324973.16975.68.camel@localhost>	<AANLkTimToKAxKLyONyk7KP4WXCS_FpjRjr1yWB3GCaQk@mail.gmail.com>	<1278463901.20082.34.camel@dwillia2-linux>	<1278474039.31393.8.camel@localhost>	<4C34BDCD.9080607@intel.com>	<AANLkTild7PCKygpPAJRo2G237CY8wJyveM9_Glx8qmoK@mail.gmail.com>	<4C379462.1020704@intel.com>	<1278720554.9522.18.camel@localhost>	<4C3E9F6E.1030508@intel.com>	<1279318325.27733.21.camel@macbook.infradead.org> <AANLkTik80zwMaRYglVt2V3AuXiN90mgovIB3i67teVOL@mail.gmail.com>
In-Reply-To: <AANLkTik80zwMaRYglVt2V3AuXiN90mgovIB3i67teVOL@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------020707000504040502060200"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020707000504040502060200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/2010 3:40 PM, Chris Li wrote:
> On Fri, Jul 16, 2010 at 3:12 PM, David Woodhouse<dwmw2@infradead.org>  wrote:
>> Ah, that's the problem. Sorry, should have noticed this before. Since
>> this is the catch-all IOMMU, the device isn't explicitly listed.
>>
>> You want 'drhd = dmar_find_matched_drhd_unit(pdev);' and then compare
>> vtbar with the reg_base_addr of that one.
>>
>
> Care to send a new patch?
>

Here is v5 with the aforementioned change.

--
Dan

--------------020707000504040502060200
Content-Type: text/plain;
 name="ioat-catch-broken-vtd-v5.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ioat-catch-broken-vtd-v5.patch"

ioat2: catch and recover from broken vtd configurations v5

From: Dan Williams <dan.j.williams@intel.com>

On some platforms (MacPro3,1) the BIOS assigns the ioatdma device to the
incorrect iommu causing iommu-faults when the driver initializes.  Add a quirk
to catch this misconfiguration, and teach the ioatdma driver to treat
initialization failures as non-fatal (just fail the driver load).

Reported-by: Chris Li <lkml@chrisli.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 drivers/dma/ioat/dma.h    |    1 +
 drivers/dma/ioat/dma_v2.c |   24 ++++++++++++++++++++++--
 drivers/dma/ioat/dma_v3.c |    5 ++++-
 drivers/pci/intel-iommu.c |   28 ++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 3 deletions(-)


diff --git a/drivers/dma/ioat/dma.h b/drivers/dma/ioat/dma.h
index 6d3a73b..5216c8a 100644
--- a/drivers/dma/ioat/dma.h
+++ b/drivers/dma/ioat/dma.h
@@ -97,6 +97,7 @@ struct ioat_chan_common {
 	#define IOAT_RESET_PENDING 2
 	#define IOAT_KOBJ_INIT_FAIL 3
 	#define IOAT_RESHAPE_PENDING 4
+	#define IOAT_RUN 5
 	struct timer_list timer;
 	#define COMPLETION_TIMEOUT msecs_to_jiffies(100)
 	#define IDLE_TIMEOUT msecs_to_jiffies(2000)
diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
index 3c8b32a..779f4da 100644
--- a/drivers/dma/ioat/dma_v2.c
+++ b/drivers/dma/ioat/dma_v2.c
@@ -287,7 +287,10 @@ void ioat2_timer_event(unsigned long data)
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
 				__func__, chanerr);
-			BUG_ON(is_ioat_bug(chanerr));
+			if (test_bit(IOAT_RUN, &chan->state))
+				BUG_ON(is_ioat_bug(chanerr));
+			else /* we never got off the ground */
+				return;
 		}
 
 		/* if we haven't made progress and we have already
@@ -492,6 +495,8 @@ static struct ioat_ring_ent **ioat2_alloc_ring(struct dma_chan *c, int order, gf
 	return ring;
 }
 
+void ioat2_free_chan_resources(struct dma_chan *c);
+
 /* ioat2_alloc_chan_resources - allocate/initialize ioat2 descriptor ring
  * @chan: channel to be initialized
  */
@@ -500,6 +505,7 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	struct ioat2_dma_chan *ioat = to_ioat2_chan(c);
 	struct ioat_chan_common *chan = &ioat->base;
 	struct ioat_ring_ent **ring;
+	u64 status;
 	int order;
 
 	/* have we already been set up? */
@@ -540,7 +546,20 @@ int ioat2_alloc_chan_resources(struct dma_chan *c)
 	tasklet_enable(&chan->cleanup_task);
 	ioat2_start_null_desc(ioat);
 
-	return 1 << ioat->alloc_order;
+	/* check that we got off the ground */
+	udelay(5);
+	status = ioat_chansts(chan);
+	if (is_ioat_active(status) || is_ioat_idle(status)) {
+		set_bit(IOAT_RUN, &chan->state);
+		return 1 << ioat->alloc_order;
+	} else {
+		u32 chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
+
+		dev_err(to_dev(chan), "failed to start channel chanerr: %#x\n",
+			chanerr);
+		ioat2_free_chan_resources(c);
+		return -EFAULT;
+	}
 }
 
 bool reshape_ring(struct ioat2_dma_chan *ioat, int order)
@@ -778,6 +797,7 @@ void ioat2_free_chan_resources(struct dma_chan *c)
 	del_timer_sync(&chan->timer);
 	device->cleanup_fn((unsigned long) c);
 	device->reset_hw(chan);
+	clear_bit(IOAT_RUN, &chan->state);
 
 	spin_lock_bh(&chan->cleanup_lock);
 	spin_lock_bh(&ioat->prep_lock);
diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index 1cdd22e..d0f4990 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -361,7 +361,10 @@ static void ioat3_timer_event(unsigned long data)
 			chanerr = readl(chan->reg_base + IOAT_CHANERR_OFFSET);
 			dev_err(to_dev(chan), "%s: Channel halted (%x)\n",
 				__func__, chanerr);
-			BUG_ON(is_ioat_bug(chanerr));
+			if (test_bit(IOAT_RUN, &chan->state))
+				BUG_ON(is_ioat_bug(chanerr));
+			else /* we never got off the ground */
+				return;
 		}
 
 		/* if we haven't made progress and we have already
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index 796828f..84b8099 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -3029,6 +3029,34 @@ static void __init iommu_exit_mempool(void)
 
 }
 
+static void quirk_ioat_snb_local_iommu(struct pci_dev *pdev)
+{
+	struct dmar_drhd_unit *drhd;
+	u32 vtbar;
+	int rc, i;
+
+	/* We know that this device on this chipset has its own IOMMU.
+	 * If we find it under a different IOMMU, then the BIOS is lying
+	 * to us. Hope that the IOMMU for this device is actually
+	 * disabled, and it needs no translation...
+	 */
+	rc = pci_bus_read_config_dword(pdev->bus, PCI_DEVFN(0, 0), 0xb0, &vtbar);
+	if (rc) {
+		/* "can't" happen */
+		dev_info(&pdev->dev, "failed to run vt-d quirk\n");
+		return;
+	}
+	vtbar &= 0xffff0000;
+
+	/* we know that the this iommu should be at offset 0xa000 from vtbar */
+	drhd = dmar_find_matched_drhd_unit(pdev);
+	if (WARN_TAINT_ONCE(!drhd || drhd->reg_base_addr - vtbar != 0xa000,
+			    TAINT_FIRMWARE_WORKAROUND,
+			    "BIOS assigned incorrect VT-d unit for Intel(R) QuickData Technology device\n"))
+		pdev->dev.archdata.iommu = DUMMY_DEVICE_DOMAIN_INFO;
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_IOAT_SNB, quirk_ioat_snb_local_iommu);
+
 static void __init init_no_remapping_devices(void)
 {
 	struct dmar_drhd_unit *drhd;

--------------020707000504040502060200--
