Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab0G1Wvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:51:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37732 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681Ab0G1Wv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 18:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=n+7ePxaFRAIgDvRXWAKwP98lP6hjERgu/IuR16cViYIDBr5YK8+lz3PY3fzMh76neW
         OqKjWogwysN95KsIsN+zz1M0K8U19vYJjlAR9VQbsEEaEAH6RzTBoEvemOHZ0W4a+cnX
         jihw+4+/SSa2Bi/0Cg/1x1ExwDoTrGRounhfo=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=dORrwVO4H-JkN42=Er-21haEHcxnrhC+NC24J@mail.gmail.com>
References: <1279699090-26032-1-git-send-email-vinod.koul@intel.com>
	<AANLkTi=dORrwVO4H-JkN42=Er-21haEHcxnrhC+NC24J@mail.gmail.com>
Date: Thu, 29 Jul 2010 00:51:26 +0200
X-Google-Sender-Auth: QWHndrllZJ-NnCBuSixzBEHikl4
Message-ID: <AANLkTinsY7zbaTipQCQD8XSui19aH1EjGfPbPiGkub0c@mail.gmail.com>
Subject: Re: Resend [PATCH] intel_mid: Add Mrst & Mfld DMA Drivers
From: Linus Walleij <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Content-Type: multipart/mixed; boundary=0016e6dd8bf22e9516048c7a7531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6dd8bf22e9516048c7a7531
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2010/7/28 Dan Williams <dan.j.williams@intel.com>:
> On Wed, Jul 21, 2010 at 12:58 AM, Vinod Koul <vinod.koul@intel.com> wrote=
:
> [..]
>> +/**
>> + * intel_mid_dma_prep_memcpy - Prep memcpy txn
>> + * @chan: chan for DMA transfer
>> + * @dest: destn address
>> + * @src: src address
>> + * @len: DMA transfer len
>> + * @flags: DMA flags
>> + *
>> + * Perform a DMA memcpy. Note we support slave periphral DMA transfers =
only
>> + * The periphral txn details should be filled in slave structure proper=
ly
>> + * Returns the descriptor for this txn
>> + */
>> +static struct dma_async_tx_descriptor *intel_mid_dma_prep_memcpy(
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct dma_chan *chan, dma=
_addr_t dest,
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_addr_t src, size_t len=
, unsigned long flags)
>
> The use of the prep_dma_memcpy routine instead of prep_slave_sg is a
> bit odd for device-to-memory dma because the dma_addr_t type only
> describes the bus address view of host memory from the device
> perspective. =A0Other slave dma devices are using a backdoor method
> (since a good abstraction does not exist) to associate a known channel
> to a known device and then specifying the host address and a direction
> via prep_slave_sg.

I see two distinct problems this is trying to solve:

1) No runtime channel control (patch pending!)

2) lacking in the DMA engine is actually a prep_slave_buffer() hook that
takes a buffer to/from a certain channel, this is often preferable to
sglists for simple DMA jobs. I mean a little something like this:

From: Linus Walleij <linus.walleij@stericsson.com>
Date: Thu, 29 Jul 2010 00:14:06 +0200
Subject: [PATCH] DMAENGINE: add a slave buffer prep call

This makes it possible for engines to implement slave transfers
to be done to/from a simple kmalloc():ed memory buffer and not
just from scatterlists.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 include/linux/dmaengine.h |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 5204f01..3caff1c 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -350,7 +350,10 @@ struct dma_tx_state {
  * @device_prep_dma_pq_val: prepares a pqzero_sum operation
  * @device_prep_dma_memset: prepares a memset operation
  * @device_prep_dma_interrupt: prepares an end of chain interrupt operatio=
n
- * @device_prep_slave_sg: prepares a slave dma operation
+ * @device_prep_slave_buffer: prepares a slave DMA operation to/from a
+ *     buffer
+ * @device_prep_slave_sg: prepares a slave dma operation to/from a
+ *     scatterlist
  * @device_control: manipulate all pending operations on a channel, return=
s
  *     zero or error code
  * @device_tx_status: poll for transaction completion, the optional
@@ -403,6 +406,10 @@ struct dma_device {
        struct dma_async_tx_descriptor *(*device_prep_dma_interrupt)(
                struct dma_chan *chan, unsigned long flags);

+       struct dma_async_tx_descriptor *(*device_prep_slave_buffer)(
+               struct dma_chan *chan, char *buffer,
+               enum dma_data_direction direction,
+               unsigned long flags);
        struct dma_async_tx_descriptor *(*device_prep_slave_sg)(
                struct dma_chan *chan, struct scatterlist *sgl,
                unsigned int sg_len, enum dma_data_direction direction,
--=20
1.7.2


Evidently the above function should be be possible to implement across
all drivers, and checked for in dmaengine.c. But it is probably best to mak=
e
this optional and make the fact that most engines only support sglists
a bit explicit, so we wrap up the buffer support like this:


From: Linus Walleij <linus.walleij@stericsson.com>
Date: Thu, 29 Jul 2010 00:42:58 +0200
Subject: [PATCH] DMAENGINE: slave sglists and buffers

This renames the DMA engine capability DMA_SLAVE to
DMA_SLAVE_SGLIST with the semantics that the current implementations
assume DMA_SLAVE means the slave supports only scatterlists for
inbound/outbound transfers. This completes the previous patch
by adding as specific single-buffer DMA capability to the API
and renaming all the old users as described.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-at91/at91sam9g45_devices.c |    2 +-
 drivers/dma/at_hdmac.c                   |    8 ++++----
 drivers/dma/coh901318.c                  |    2 +-
 drivers/dma/dmaengine.c                  |    9 ++++++---
 drivers/dma/dw_dmac.c                    |    2 +-
 drivers/dma/fsldma.c                     |   11 ++++++-----
 drivers/dma/ipu/ipu_idmac.c              |    4 ++--
 drivers/dma/pl330.c                      |    2 +-
 drivers/dma/shdma.c                      |    4 ++--
 drivers/dma/ste_dma40.c                  |    9 +++++----
 drivers/dma/timb_dma.c                   |    2 +-
 drivers/dma/txx9dmac.c                   |    5 +++--
 drivers/media/video/mx3_camera.c         |    2 +-
 drivers/mmc/host/atmel-mci.c             |    2 +-
 drivers/mmc/host/tmio_mmc.c              |    2 +-
 drivers/serial/sh-sci.c                  |    2 +-
 drivers/video/mx3fb.c                    |    2 +-
 include/linux/dmaengine.h                |    5 +++--
 sound/atmel/abdac.c                      |    2 +-
 sound/atmel/ac97c.c                      |    4 ++--
 sound/soc/sh/siu_pcm.c                   |    2 +-
 sound/soc/txx9/txx9aclc.c                |    2 +-
 22 files changed, 46 insertions(+), 39 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c
b/arch/arm/mach-at91/at91sam9g45_devices.c
index 809114d..a005bc9 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -68,7 +68,7 @@ static struct platform_device at_hdmac_device =3D {
 void __init at91_add_device_hdmac(void)
 {
 	dma_cap_set(DMA_MEMCPY, atdma_pdata.cap_mask);
-	dma_cap_set(DMA_SLAVE, atdma_pdata.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, atdma_pdata.cap_mask);
 	platform_device_register(&at_hdmac_device);
 }
 #else
diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index e880760..f94b9d1 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -615,7 +615,7 @@ err_desc_get:


 /**
- * atc_prep_slave_sg - prepare descriptors for a DMA_SLAVE transaction
+ * atc_prep_slave_sg - prepare descriptors for a DMA_SLAVE_SGLIST transact=
ion
  * @chan: DMA channel
  * @sgl: scatterlist to transfer to/from
  * @sg_len: number of entries in @scatterlist
@@ -1093,7 +1093,7 @@ static int __init at_dma_probe(struct
platform_device *pdev)
 	if (dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask))
 		atdma->dma_common.device_prep_dma_memcpy =3D atc_prep_dma_memcpy;

-	if (dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)) {
+	if (dma_has_cap(DMA_SLAVE_SGLIST, atdma->dma_common.cap_mask)) {
 		atdma->dma_common.device_prep_slave_sg =3D atc_prep_slave_sg;
 		atdma->dma_common.device_control =3D atc_control;
 	}
@@ -1102,8 +1102,8 @@ static int __init at_dma_probe(struct
platform_device *pdev)

 	dev_info(&pdev->dev, "Atmel AHB DMA Controller ( %s%s), %d channels\n",
 	  dma_has_cap(DMA_MEMCPY, atdma->dma_common.cap_mask) ? "cpy " : "",
-	  dma_has_cap(DMA_SLAVE, atdma->dma_common.cap_mask)  ? "slave " : "",
-	  atdma->dma_common.chancnt);
+	  dma_has_cap(DMA_SLAVE_SGLIST, atdma->dma_common.cap_mask) ?
+		"slave " : "", atdma->dma_common.chancnt);

 	dma_async_device_register(&atdma->dma_common);

diff --git a/drivers/dma/coh901318.c b/drivers/dma/coh901318.c
index a724e6b..d744493 100644
--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1349,7 +1349,7 @@ static int __init coh901318_probe(struct
platform_device *pdev)
 			    base);

 	dma_cap_zero(base->dma_slave.cap_mask);
-	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, base->dma_slave.cap_mask);

 	base->dma_slave.device_alloc_chan_resources =3D coh901318_alloc_chan_reso=
urces;
 	base->dma_slave.device_free_chan_resources =3D coh901318_free_chan_resour=
ces;
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 9d31d5e..0d37c76 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -300,7 +300,6 @@ static int __init dma_channel_table_init(void)
 	 */
 	clear_bit(DMA_INTERRUPT, dma_cap_mask_all.bits);
 	clear_bit(DMA_PRIVATE, dma_cap_mask_all.bits);
-	clear_bit(DMA_SLAVE, dma_cap_mask_all.bits);

 	for_each_dma_cap_mask(cap, dma_cap_mask_all) {
 		channel_table[cap] =3D alloc_percpu(struct dma_chan_tbl_ent);
@@ -690,9 +689,13 @@ int dma_async_device_register(struct dma_device *devic=
e)
 		!device->device_prep_dma_memset);
 	BUG_ON(dma_has_cap(DMA_INTERRUPT, device->cap_mask) &&
 		!device->device_prep_dma_interrupt);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_SLAVE_SGLIST, device->cap_mask) &&
 		!device->device_prep_slave_sg);
-	BUG_ON(dma_has_cap(DMA_SLAVE, device->cap_mask) &&
+	BUG_ON(dma_has_cap(DMA_SLAVE_SGLIST, device->cap_mask) &&
+		!device->device_control);
+	BUG_ON(dma_has_cap(DMA_SLAVE_BUFFER, device->cap_mask) &&
+		!device->device_prep_slave_buffer);
+	BUG_ON(dma_has_cap(DMA_SLAVE_BUFFER, device->cap_mask) &&
 		!device->device_control);

 	BUG_ON(!device->device_alloc_chan_resources);
diff --git a/drivers/dma/dw_dmac.c b/drivers/dma/dw_dmac.c
index a3991ab..e38ea35 100644
--- a/drivers/dma/dw_dmac.c
+++ b/drivers/dma/dw_dmac.c
@@ -1334,7 +1334,7 @@ static int __init dw_probe(struct platform_device *pd=
ev)
 	channel_clear_bit(dw, MASK.ERROR, dw->all_chan_mask);

 	dma_cap_set(DMA_MEMCPY, dw->dma.cap_mask);
-	dma_cap_set(DMA_SLAVE, dw->dma.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, dw->dma.cap_mask);
 	dw->dma.dev =3D &pdev->dev;
 	dw->dma.device_alloc_chan_resources =3D dwc_alloc_chan_resources;
 	dw->dma.device_free_chan_resources =3D dwc_free_chan_resources;
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 8088b14..1b9760a 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -584,16 +584,17 @@ fail:
 }

 /**
- * fsl_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE transaction
+ * fsl_dma_prep_slave_sg - prepare descriptors for a DMA_SLAVE_SGLIST
+ * transaction
  * @chan: DMA channel
  * @sgl: scatterlist to transfer to/from
  * @sg_len: number of entries in @scatterlist
  * @direction: DMA direction
  * @flags: DMAEngine flags
  *
- * Prepare a set of descriptors for a DMA_SLAVE transaction. Following the
- * DMA_SLAVE API, this gets the device-specific information from the
- * chan->private variable.
+ * Prepare a set of descriptors for a DMA_SLAVE_SGLIST transaction.
+ * Following the DMA_SLAVE API, this gets the device-specific information
+ * from the chan->private variable.
  */
 static struct dma_async_tx_descriptor *fsl_dma_prep_slave_sg(
 	struct dma_chan *dchan, struct scatterlist *sgl, unsigned int sg_len,
@@ -1327,7 +1328,7 @@ static int __devinit fsldma_of_probe(struct of_device=
 *op,

 	dma_cap_set(DMA_MEMCPY, fdev->common.cap_mask);
 	dma_cap_set(DMA_INTERRUPT, fdev->common.cap_mask);
-	dma_cap_set(DMA_SLAVE, fdev->common.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, fdev->common.cap_mask);
 	fdev->common.device_alloc_chan_resources =3D fsl_dma_alloc_chan_resources=
;
 	fdev->common.device_free_chan_resources =3D fsl_dma_free_chan_resources;
 	fdev->common.device_prep_dma_interrupt =3D fsl_dma_prep_interrupt;
diff --git a/drivers/dma/ipu/ipu_idmac.c b/drivers/dma/ipu/ipu_idmac.c
index cb26ee9..27d8226 100644
--- a/drivers/dma/ipu/ipu_idmac.c
+++ b/drivers/dma/ipu/ipu_idmac.c
@@ -1665,7 +1665,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	struct dma_device *dma =3D &idmac->dma;
 	int i;

-	dma_cap_set(DMA_SLAVE, dma->cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, dma->cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma->cap_mask);

 	/* Compulsory common fields */
@@ -1675,7 +1675,7 @@ static int __init ipu_idmac_init(struct ipu *ipu)
 	dma->device_tx_status			=3D idmac_tx_status;
 	dma->device_issue_pending		=3D idmac_issue_pending;

-	/* Compulsory for DMA_SLAVE fields */
+	/* Compulsory for DMA_SLAVE_SGLIST fields */
 	dma->device_prep_slave_sg		=3D idmac_prep_slave_sg;
 	dma->device_control			=3D idmac_control;

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 7c50f6d..3974357 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -727,7 +727,7 @@ pl330_probe(struct amba_device *adev, struct amba_id *i=
d)
 			break;
 		case MEMTODEV:
 		case DEVTOMEM:
-			dma_cap_set(DMA_SLAVE, pd->cap_mask);
+			dma_cap_set(DMA_SLAVE_SGLIST, pd->cap_mask);
 			break;
 		default:
 			dev_err(&adev->dev, "DEVTODEV Not Supported\n");
diff --git a/drivers/dma/shdma.c b/drivers/dma/shdma.c
index fb64cf3..5b09f81 100644
--- a/drivers/dma/shdma.c
+++ b/drivers/dma/shdma.c
@@ -1040,7 +1040,7 @@ static int __init sh_dmae_probe(struct
platform_device *pdev)

 	dma_cap_set(DMA_MEMCPY, shdev->common.cap_mask);
 	if (dmars)
-		dma_cap_set(DMA_SLAVE, shdev->common.cap_mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, shdev->common.cap_mask);

 	shdev->common.device_alloc_chan_resources
 		=3D sh_dmae_alloc_chan_resources;
@@ -1049,7 +1049,7 @@ static int __init sh_dmae_probe(struct
platform_device *pdev)
 	shdev->common.device_tx_status =3D sh_dmae_tx_status;
 	shdev->common.device_issue_pending =3D sh_dmae_memcpy_issue_pending;

-	/* Compulsory for DMA_SLAVE fields */
+	/* Compulsory for DMA_SLAVE_SGLIST fields */
 	shdev->common.device_prep_slave_sg =3D sh_dmae_prep_slave_sg;
 	shdev->common.device_control =3D sh_dmae_control;

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 21a7597..f153800 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1210,14 +1210,15 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 {
 	dma_cap_mask_t cap =3D d40c->chan.device->cap_mask;

-	if (dma_has_cap(DMA_MEMCPY, cap) && !dma_has_cap(DMA_SLAVE, cap)) {
+	if (dma_has_cap(DMA_MEMCPY, cap) &&
+		!dma_has_cap(DMA_SLAVE_SGLIST, cap)) {
 		d40c->dma_cfg =3D *d40c->base->plat_data->memcpy_conf_log;
 		d40c->dma_cfg.src_dev_type =3D STEDMA40_DEV_SRC_MEMORY;
 		d40c->dma_cfg.dst_dev_type =3D d40c->base->plat_data->
 			memcpy[d40c->chan.chan_id];

 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
-		   dma_has_cap(DMA_SLAVE, cap)) {
+		   dma_has_cap(DMA_SLAVE_SGLIST, cap)) {
 		d40c->dma_cfg =3D *d40c->base->plat_data->memcpy_conf_phy;
 	} else {
 		dev_err(&d40c->chan.dev->device, "[%s] No memcpy\n",
@@ -2143,7 +2144,7 @@ static int __init d40_dmaengine_init(struct
d40_base *base,
 		      0, base->num_log_chans);

 	dma_cap_zero(base->dma_slave.cap_mask);
-	dma_cap_set(DMA_SLAVE, base->dma_slave.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, base->dma_slave.cap_mask);

 	base->dma_slave.device_alloc_chan_resources =3D d40_alloc_chan_resources;
 	base->dma_slave.device_free_chan_resources =3D d40_free_chan_resources;
@@ -2196,7 +2197,7 @@ static int __init d40_dmaengine_init(struct
d40_base *base,
 		      0, num_reserved_chans);

 	dma_cap_zero(base->dma_both.cap_mask);
-	dma_cap_set(DMA_SLAVE, base->dma_both.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, base->dma_both.cap_mask);
 	dma_cap_set(DMA_MEMCPY, base->dma_both.cap_mask);

 	base->dma_both.device_alloc_chan_resources =3D d40_alloc_chan_resources;
diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 2ec1ed5..75149883 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -744,7 +744,7 @@ static int __devinit td_probe(struct platform_device *p=
dev)
 	td->dma.device_tx_status		=3D td_tx_status;
 	td->dma.device_issue_pending		=3D td_issue_pending;

-	dma_cap_set(DMA_SLAVE, td->dma.cap_mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, td->dma.cap_mask);
 	dma_cap_set(DMA_PRIVATE, td->dma.cap_mask);
 	td->dma.device_prep_slave_sg =3D td_prep_slave_sg;
 	td->dma.device_control =3D td_control;
diff --git a/drivers/dma/txx9dmac.c b/drivers/dma/txx9dmac.c
index cbd83e36..c2d1343 100644
--- a/drivers/dma/txx9dmac.c
+++ b/drivers/dma/txx9dmac.c
@@ -1164,7 +1164,7 @@ static int __init txx9dmac_chan_probe(struct
platform_device *pdev)
 		dma_cap_set(DMA_MEMCPY, dc->dma.cap_mask);
 	} else {
 		dc->dma.device_prep_slave_sg =3D txx9dmac_prep_slave_sg;
-		dma_cap_set(DMA_SLAVE, dc->dma.cap_mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, dc->dma.cap_mask);
 		dma_cap_set(DMA_PRIVATE, dc->dma.cap_mask);
 	}

@@ -1208,7 +1208,8 @@ static int __init txx9dmac_chan_probe(struct
platform_device *pdev)
 	dev_dbg(&pdev->dev, "TXx9 DMA Channel (dma%d%s%s)\n",
 		dc->dma.dev_id,
 		dma_has_cap(DMA_MEMCPY, dc->dma.cap_mask) ? " memcpy" : "",
-		dma_has_cap(DMA_SLAVE, dc->dma.cap_mask) ? " slave" : "");
+		dma_has_cap(DMA_SLAVE_SGLIST, dc->dma.cap_mask) ?
+		" slave" : "");

 	return 0;
 }
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_cam=
era.c
index a9be14c..fd6f735 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -780,7 +780,7 @@ static int acquire_dma_channel(struct
mx3_camera_dev *mx3_cam)
 	}

 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 	dma_cap_set(DMA_PRIVATE, mask);
 	chan =3D dma_request_channel(mask, chan_filter, &rq);
 	if (!chan)
diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
index 95ef864..fae4b39 100644
--- a/drivers/mmc/host/atmel-mci.c
+++ b/drivers/mmc/host/atmel-mci.c
@@ -1728,7 +1728,7 @@ static void atmci_configure_dma(struct atmel_mci *hos=
t)

 		/* Try to grab a DMA channel */
 		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, mask);
 		host->dma.chan =3D
 			dma_request_channel(mask, filter, pdata->dma_slave);
 	}
diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
index ee7d0a5..905ffb2 100644
--- a/drivers/mmc/host/tmio_mmc.c
+++ b/drivers/mmc/host/tmio_mmc.c
@@ -591,7 +591,7 @@ static void tmio_mmc_request_dma(struct tmio_mmc_host *=
host,
 		dma_cap_mask_t mask;

 		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, mask);

 		host->chan_tx =3D dma_request_channel(mask, tmio_mmc_filter,
 						    pdata->dma->chan_priv_tx);
diff --git a/drivers/serial/sh-sci.c b/drivers/serial/sh-sci.c
index c291b3a..0efab71 100644
--- a/drivers/serial/sh-sci.c
+++ b/drivers/serial/sh-sci.c
@@ -1316,7 +1316,7 @@ static void sci_request_dma(struct uart_port *port)
 		return;

 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);

 	param =3D &s->param_tx;

diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
index 7cfc170..ced7d86 100644
--- a/drivers/video/mx3fb.c
+++ b/drivers/video/mx3fb.c
@@ -1482,7 +1482,7 @@ static int mx3fb_probe(struct platform_device *pdev)
 	rq.mx3fb =3D mx3fb;

 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 	dma_cap_set(DMA_PRIVATE, mask);
 	rq.id =3D IDMAC_SDC_0;
 	chan =3D dma_request_channel(mask, chan_filter, &rq);
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 3caff1c..b23be6e 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -66,11 +66,12 @@ enum dma_transaction_type {
 	DMA_INTERRUPT,
 	DMA_PRIVATE,
 	DMA_ASYNC_TX,
-	DMA_SLAVE,
+	DMA_SLAVE_SGLIST,
+	DMA_SLAVE_BUFFER,
 };

 /* last transaction type for creation of the capabilities mask */
-#define DMA_TX_TYPE_END (DMA_SLAVE + 1)
+#define DMA_TX_TYPE_END (DMA_SLAVE_BUFFER + 1)


 /**
diff --git a/sound/atmel/abdac.c b/sound/atmel/abdac.c
index f2f41c8..642bdea 100644
--- a/sound/atmel/abdac.c
+++ b/sound/atmel/abdac.c
@@ -473,7 +473,7 @@ static int __devinit atmel_abdac_probe(struct
platform_device *pdev)
 		dws->tx_reg =3D regs->start + DAC_DATA;

 		dma_cap_zero(mask);
-		dma_cap_set(DMA_SLAVE, mask);
+		dma_cap_set(DMA_SLAVE_SGLIST, mask);

 		dac->dma.chan =3D dma_request_channel(mask, filter, dws);
 	}
diff --git a/sound/atmel/ac97c.c b/sound/atmel/ac97c.c
index 10c3a87..1f0d328 100644
--- a/sound/atmel/ac97c.c
+++ b/sound/atmel/ac97c.c
@@ -1013,7 +1013,7 @@ static int __devinit atmel_ac97c_probe(struct
platform_device *pdev)
 			dws->rx_reg =3D regs->start + AC97C_CARHR + 2;

 			dma_cap_zero(mask);
-			dma_cap_set(DMA_SLAVE, mask);
+			dma_cap_set(DMA_SLAVE_SGLIST, mask);

 			chip->dma.rx_chan =3D dma_request_channel(mask, filter,
 								dws);
@@ -1030,7 +1030,7 @@ static int __devinit atmel_ac97c_probe(struct
platform_device *pdev)
 			dws->tx_reg =3D regs->start + AC97C_CATHR + 2;

 			dma_cap_zero(mask);
-			dma_cap_set(DMA_SLAVE, mask);
+			dma_cap_set(DMA_SLAVE_SGLIST, mask);

 			chip->dma.tx_chan =3D dma_request_channel(mask, filter,
 								dws);
diff --git a/sound/soc/sh/siu_pcm.c b/sound/soc/sh/siu_pcm.c
index 36170be..a8a8738 100644
--- a/sound/soc/sh/siu_pcm.c
+++ b/sound/soc/sh/siu_pcm.c
@@ -350,7 +350,7 @@ static int siu_pcm_open(struct snd_pcm_substream *ss)
 	struct sh_dmae_slave *param;

 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);

 	dev_dbg(dev, "%s, port=3D%d@%p\n", __func__, port, port_info);

diff --git a/sound/soc/txx9/txx9aclc.c b/sound/soc/txx9/txx9aclc.c
index 0e345230..11c9525 100644
--- a/sound/soc/txx9/txx9aclc.c
+++ b/sound/soc/txx9/txx9aclc.c
@@ -331,7 +331,7 @@ static int txx9aclc_dma_init(struct
txx9aclc_soc_device *dev,

 	/* Try to grab a DMA channel */
 	dma_cap_zero(mask);
-	dma_cap_set(DMA_SLAVE, mask);
+	dma_cap_set(DMA_SLAVE_SGLIST, mask);
 	dmadata->dma_chan =3D dma_request_channel(mask, filter, dmadata);
 	if (!dmadata->dma_chan) {
 		dev_err(dev->soc_dev.dev,
--=20
1.7.2


Both patches are also conveniently attached.


Yours,
Linus Walleij

--0016e6dd8bf22e9516048c7a7531
Content-Type: application/octet-stream; 
	name="0001-DMAENGINE-add-a-slave-buffer-prep-call.patch"
Content-Disposition: attachment; 
	filename="0001-DMAENGINE-add-a-slave-buffer-prep-call.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gc6roa6h0

RnJvbSA3NjkxNjM0ZTRhN2EzOWM2YTNiM2M0YmYwM2FmODZlMzcxYmEzMDQwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQHN0ZXJpY3Nz
b24uY29tPgpEYXRlOiBUaHUsIDI5IEp1bCAyMDEwIDAwOjE0OjA2ICswMjAwClN1YmplY3Q6IFtQ
QVRDSCAxLzJdIERNQUVOR0lORTogYWRkIGEgc2xhdmUgYnVmZmVyIHByZXAgY2FsbAoKVGhpcyBt
YWtlcyBpdCBwb3NzaWJsZSBmb3IgZW5naW5lcyB0byBpbXBsZW1lbnQgc2xhdmUgdHJhbnNmZXJz
CnRvIGJlIGRvbmUgdG8vZnJvbSBhIHNpbXBsZSBrbWFsbG9jKCk6ZWQgbWVtb3J5IGJ1ZmZlciBh
bmQgbm90Cmp1c3QgZnJvbSBzY2F0dGVybGlzdHMuCgpTaWduZWQtb2ZmLWJ5OiBMaW51cyBXYWxs
ZWlqIDxsaW51cy53YWxsZWlqQHN0ZXJpY3Nzb24uY29tPgotLS0KIGluY2x1ZGUvbGludXgvZG1h
ZW5naW5lLmggfCAgICA5ICsrKysrKysrLQogMSBmaWxlcyBjaGFuZ2VkLCA4IGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kbWFlbmdpbmUu
aCBiL2luY2x1ZGUvbGludXgvZG1hZW5naW5lLmgKaW5kZXggNTIwNGYwMS4uM2NhZmYxYyAxMDA2
NDQKLS0tIGEvaW5jbHVkZS9saW51eC9kbWFlbmdpbmUuaAorKysgYi9pbmNsdWRlL2xpbnV4L2Rt
YWVuZ2luZS5oCkBAIC0zNTAsNyArMzUwLDEwIEBAIHN0cnVjdCBkbWFfdHhfc3RhdGUgewogICog
QGRldmljZV9wcmVwX2RtYV9wcV92YWw6IHByZXBhcmVzIGEgcHF6ZXJvX3N1bSBvcGVyYXRpb24K
ICAqIEBkZXZpY2VfcHJlcF9kbWFfbWVtc2V0OiBwcmVwYXJlcyBhIG1lbXNldCBvcGVyYXRpb24K
ICAqIEBkZXZpY2VfcHJlcF9kbWFfaW50ZXJydXB0OiBwcmVwYXJlcyBhbiBlbmQgb2YgY2hhaW4g
aW50ZXJydXB0IG9wZXJhdGlvbgotICogQGRldmljZV9wcmVwX3NsYXZlX3NnOiBwcmVwYXJlcyBh
IHNsYXZlIGRtYSBvcGVyYXRpb24KKyAqIEBkZXZpY2VfcHJlcF9zbGF2ZV9idWZmZXI6IHByZXBh
cmVzIGEgc2xhdmUgRE1BIG9wZXJhdGlvbiB0by9mcm9tIGEKKyAqCWJ1ZmZlcgorICogQGRldmlj
ZV9wcmVwX3NsYXZlX3NnOiBwcmVwYXJlcyBhIHNsYXZlIGRtYSBvcGVyYXRpb24gdG8vZnJvbSBh
CisgKglzY2F0dGVybGlzdAogICogQGRldmljZV9jb250cm9sOiBtYW5pcHVsYXRlIGFsbCBwZW5k
aW5nIG9wZXJhdGlvbnMgb24gYSBjaGFubmVsLCByZXR1cm5zCiAgKgl6ZXJvIG9yIGVycm9yIGNv
ZGUKICAqIEBkZXZpY2VfdHhfc3RhdHVzOiBwb2xsIGZvciB0cmFuc2FjdGlvbiBjb21wbGV0aW9u
LCB0aGUgb3B0aW9uYWwKQEAgLTQwMyw2ICs0MDYsMTAgQEAgc3RydWN0IGRtYV9kZXZpY2Ugewog
CXN0cnVjdCBkbWFfYXN5bmNfdHhfZGVzY3JpcHRvciAqKCpkZXZpY2VfcHJlcF9kbWFfaW50ZXJy
dXB0KSgKIAkJc3RydWN0IGRtYV9jaGFuICpjaGFuLCB1bnNpZ25lZCBsb25nIGZsYWdzKTsKIAor
CXN0cnVjdCBkbWFfYXN5bmNfdHhfZGVzY3JpcHRvciAqKCpkZXZpY2VfcHJlcF9zbGF2ZV9idWZm
ZXIpKAorCQlzdHJ1Y3QgZG1hX2NoYW4gKmNoYW4sIGNoYXIgKmJ1ZmZlciwKKwkJZW51bSBkbWFf
ZGF0YV9kaXJlY3Rpb24gZGlyZWN0aW9uLAorCQl1bnNpZ25lZCBsb25nIGZsYWdzKTsKIAlzdHJ1
Y3QgZG1hX2FzeW5jX3R4X2Rlc2NyaXB0b3IgKigqZGV2aWNlX3ByZXBfc2xhdmVfc2cpKAogCQlz
dHJ1Y3QgZG1hX2NoYW4gKmNoYW4sIHN0cnVjdCBzY2F0dGVybGlzdCAqc2dsLAogCQl1bnNpZ25l
ZCBpbnQgc2dfbGVuLCBlbnVtIGRtYV9kYXRhX2RpcmVjdGlvbiBkaXJlY3Rpb24sCi0tIAoxLjcu
MgoK
--0016e6dd8bf22e9516048c7a7531
Content-Type: application/octet-stream; 
	name="0002-DMAENGINE-slave-sglists-and-buffers.patch"
Content-Disposition: attachment; 
	filename="0002-DMAENGINE-slave-sglists-and-buffers.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gc6rpfp61

RnJvbSAxZDQyZmE0MGY1YmQ4OWJlY2E1OTI0MGE0NWNmOTQxYWI4ZTE3NTM1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBXYWxsZWlqIDxsaW51cy53YWxsZWlqQHN0ZXJpY3Nz
b24uY29tPgpEYXRlOiBUaHUsIDI5IEp1bCAyMDEwIDAwOjQyOjU4ICswMjAwClN1YmplY3Q6IFtQ
QVRDSCAyLzJdIERNQUVOR0lORTogc2xhdmUgc2dsaXN0cyBhbmQgYnVmZmVycwoKVGhpcyByZW5h
bWVzIHRoZSBETUEgZW5naW5lIGNhcGFiaWxpdHkgRE1BX1NMQVZFIHRvCkRNQV9TTEFWRV9TR0xJ
U1Qgd2l0aCB0aGUgc2VtYW50aWNzIHRoYXQgdGhlIGN1cnJlbnQgaW1wbGVtZW50YXRpb25zCmFz
c3VtZSBETUFfU0xBVkUgbWVhbnMgdGhlIHNsYXZlIHN1cHBvcnRzIG9ubHkgc2NhdHRlcmxpc3Rz
IGZvcgppbmJvdW5kL291dGJvdW5kIHRyYW5zZmVycy4gVGhpcyBjb21wbGV0ZXMgdGhlIHByZXZp
b3VzIHBhdGNoCmJ5IGFkZGluZyBhcyBzcGVjaWZpYyBzaW5nbGUtYnVmZmVyIERNQSBjYXBhYmls
aXR5IHRvIHRoZSBBUEkKYW5kIHJlbmFtaW5nIGFsbCB0aGUgb2xkIHVzZXJzIGFzIGRlc2NyaWJl
ZC4KClNpZ25lZC1vZmYtYnk6IExpbnVzIFdhbGxlaWogPGxpbnVzLndhbGxlaWpAc3Rlcmljc3Nv
bi5jb20+Ci0tLQogYXJjaC9hcm0vbWFjaC1hdDkxL2F0OTFzYW05ZzQ1X2RldmljZXMuYyB8ICAg
IDIgKy0KIGRyaXZlcnMvZG1hL2F0X2hkbWFjLmMgICAgICAgICAgICAgICAgICAgfCAgICA4ICsr
KystLS0tCiBkcml2ZXJzL2RtYS9jb2g5MDEzMTguYyAgICAgICAgICAgICAgICAgIHwgICAgMiAr
LQogZHJpdmVycy9kbWEvZG1hZW5naW5lLmMgICAgICAgICAgICAgICAgICB8ICAgIDkgKysrKysr
LS0tCiBkcml2ZXJzL2RtYS9kd19kbWFjLmMgICAgICAgICAgICAgICAgICAgIHwgICAgMiArLQog
ZHJpdmVycy9kbWEvZnNsZG1hLmMgICAgICAgICAgICAgICAgICAgICB8ICAgMTEgKysrKysrLS0t
LS0KIGRyaXZlcnMvZG1hL2lwdS9pcHVfaWRtYWMuYyAgICAgICAgICAgICAgfCAgICA0ICsrLS0K
IGRyaXZlcnMvZG1hL3BsMzMwLmMgICAgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBkcml2
ZXJzL2RtYS9zaGRtYS5jICAgICAgICAgICAgICAgICAgICAgIHwgICAgNCArKy0tCiBkcml2ZXJz
L2RtYS9zdGVfZG1hNDAuYyAgICAgICAgICAgICAgICAgIHwgICAgOSArKysrKy0tLS0KIGRyaXZl
cnMvZG1hL3RpbWJfZG1hLmMgICAgICAgICAgICAgICAgICAgfCAgICAyICstCiBkcml2ZXJzL2Rt
YS90eHg5ZG1hYy5jICAgICAgICAgICAgICAgICAgIHwgICAgNSArKystLQogZHJpdmVycy9tZWRp
YS92aWRlby9teDNfY2FtZXJhLmMgICAgICAgICB8ICAgIDIgKy0KIGRyaXZlcnMvbW1jL2hvc3Qv
YXRtZWwtbWNpLmMgICAgICAgICAgICAgfCAgICAyICstCiBkcml2ZXJzL21tYy9ob3N0L3RtaW9f
bW1jLmMgICAgICAgICAgICAgIHwgICAgMiArLQogZHJpdmVycy9zZXJpYWwvc2gtc2NpLmMgICAg
ICAgICAgICAgICAgICB8ICAgIDIgKy0KIGRyaXZlcnMvdmlkZW8vbXgzZmIuYyAgICAgICAgICAg
ICAgICAgICAgfCAgICAyICstCiBpbmNsdWRlL2xpbnV4L2RtYWVuZ2luZS5oICAgICAgICAgICAg
ICAgIHwgICAgNSArKystLQogc291bmQvYXRtZWwvYWJkYWMuYyAgICAgICAgICAgICAgICAgICAg
ICB8ICAgIDIgKy0KIHNvdW5kL2F0bWVsL2FjOTdjLmMgICAgICAgICAgICAgICAgICAgICAgfCAg
ICA0ICsrLS0KIHNvdW5kL3NvYy9zaC9zaXVfcGNtLmMgICAgICAgICAgICAgICAgICAgfCAgICAy
ICstCiBzb3VuZC9zb2MvdHh4OS90eHg5YWNsYy5jICAgICAgICAgICAgICAgIHwgICAgMiArLQog
MjIgZmlsZXMgY2hhbmdlZCwgNDYgaW5zZXJ0aW9ucygrKSwgMzkgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvYXJjaC9hcm0vbWFjaC1hdDkxL2F0OTFzYW05ZzQ1X2RldmljZXMuYyBiL2FyY2gv
YXJtL21hY2gtYXQ5MS9hdDkxc2FtOWc0NV9kZXZpY2VzLmMKaW5kZXggODA5MTE0ZC4uYTAwNWJj
OSAxMDA2NDQKLS0tIGEvYXJjaC9hcm0vbWFjaC1hdDkxL2F0OTFzYW05ZzQ1X2RldmljZXMuYwor
KysgYi9hcmNoL2FybS9tYWNoLWF0OTEvYXQ5MXNhbTlnNDVfZGV2aWNlcy5jCkBAIC02OCw3ICs2
OCw3IEBAIHN0YXRpYyBzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlIGF0X2hkbWFjX2RldmljZSA9IHsK
IHZvaWQgX19pbml0IGF0OTFfYWRkX2RldmljZV9oZG1hYyh2b2lkKQogewogCWRtYV9jYXBfc2V0
KERNQV9NRU1DUFksIGF0ZG1hX3BkYXRhLmNhcF9tYXNrKTsKLQlkbWFfY2FwX3NldChETUFfU0xB
VkUsIGF0ZG1hX3BkYXRhLmNhcF9tYXNrKTsKKwlkbWFfY2FwX3NldChETUFfU0xBVkVfU0dMSVNU
LCBhdGRtYV9wZGF0YS5jYXBfbWFzayk7CiAJcGxhdGZvcm1fZGV2aWNlX3JlZ2lzdGVyKCZhdF9o
ZG1hY19kZXZpY2UpOwogfQogI2Vsc2UKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL2F0X2hkbWFj
LmMgYi9kcml2ZXJzL2RtYS9hdF9oZG1hYy5jCmluZGV4IGU4ODA3NjAuLmY5NGI5ZDEgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvZG1hL2F0X2hkbWFjLmMKKysrIGIvZHJpdmVycy9kbWEvYXRfaGRtYWMu
YwpAQCAtNjE1LDcgKzYxNSw3IEBAIGVycl9kZXNjX2dldDoKIAogCiAvKioKLSAqIGF0Y19wcmVw
X3NsYXZlX3NnIC0gcHJlcGFyZSBkZXNjcmlwdG9ycyBmb3IgYSBETUFfU0xBVkUgdHJhbnNhY3Rp
b24KKyAqIGF0Y19wcmVwX3NsYXZlX3NnIC0gcHJlcGFyZSBkZXNjcmlwdG9ycyBmb3IgYSBETUFf
U0xBVkVfU0dMSVNUIHRyYW5zYWN0aW9uCiAgKiBAY2hhbjogRE1BIGNoYW5uZWwKICAqIEBzZ2w6
IHNjYXR0ZXJsaXN0IHRvIHRyYW5zZmVyIHRvL2Zyb20KICAqIEBzZ19sZW46IG51bWJlciBvZiBl
bnRyaWVzIGluIEBzY2F0dGVybGlzdApAQCAtMTA5Myw3ICsxMDkzLDcgQEAgc3RhdGljIGludCBf
X2luaXQgYXRfZG1hX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJaWYgKGRt
YV9oYXNfY2FwKERNQV9NRU1DUFksIGF0ZG1hLT5kbWFfY29tbW9uLmNhcF9tYXNrKSkKIAkJYXRk
bWEtPmRtYV9jb21tb24uZGV2aWNlX3ByZXBfZG1hX21lbWNweSA9IGF0Y19wcmVwX2RtYV9tZW1j
cHk7CiAKLQlpZiAoZG1hX2hhc19jYXAoRE1BX1NMQVZFLCBhdGRtYS0+ZG1hX2NvbW1vbi5jYXBf
bWFzaykpIHsKKwlpZiAoZG1hX2hhc19jYXAoRE1BX1NMQVZFX1NHTElTVCwgYXRkbWEtPmRtYV9j
b21tb24uY2FwX21hc2spKSB7CiAJCWF0ZG1hLT5kbWFfY29tbW9uLmRldmljZV9wcmVwX3NsYXZl
X3NnID0gYXRjX3ByZXBfc2xhdmVfc2c7CiAJCWF0ZG1hLT5kbWFfY29tbW9uLmRldmljZV9jb250
cm9sID0gYXRjX2NvbnRyb2w7CiAJfQpAQCAtMTEwMiw4ICsxMTAyLDggQEAgc3RhdGljIGludCBf
X2luaXQgYXRfZG1hX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAKIAlkZXZf
aW5mbygmcGRldi0+ZGV2LCAiQXRtZWwgQUhCIERNQSBDb250cm9sbGVyICggJXMlcyksICVkIGNo
YW5uZWxzXG4iLAogCSAgZG1hX2hhc19jYXAoRE1BX01FTUNQWSwgYXRkbWEtPmRtYV9jb21tb24u
Y2FwX21hc2spID8gImNweSAiIDogIiIsCi0JICBkbWFfaGFzX2NhcChETUFfU0xBVkUsIGF0ZG1h
LT5kbWFfY29tbW9uLmNhcF9tYXNrKSAgPyAic2xhdmUgIiA6ICIiLAotCSAgYXRkbWEtPmRtYV9j
b21tb24uY2hhbmNudCk7CisJICBkbWFfaGFzX2NhcChETUFfU0xBVkVfU0dMSVNULCBhdGRtYS0+
ZG1hX2NvbW1vbi5jYXBfbWFzaykgPworCQkic2xhdmUgIiA6ICIiLCBhdGRtYS0+ZG1hX2NvbW1v
bi5jaGFuY250KTsKIAogCWRtYV9hc3luY19kZXZpY2VfcmVnaXN0ZXIoJmF0ZG1hLT5kbWFfY29t
bW9uKTsKIApkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEvY29oOTAxMzE4LmMgYi9kcml2ZXJzL2Rt
YS9jb2g5MDEzMTguYwppbmRleCBhNzI0ZTZiLi5kNzQ0NDkzIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2RtYS9jb2g5MDEzMTguYworKysgYi9kcml2ZXJzL2RtYS9jb2g5MDEzMTguYwpAQCAtMTM0OSw3
ICsxMzQ5LDcgQEAgc3RhdGljIGludCBfX2luaXQgY29oOTAxMzE4X3Byb2JlKHN0cnVjdCBwbGF0
Zm9ybV9kZXZpY2UgKnBkZXYpCiAJCQkgICAgYmFzZSk7CiAKIAlkbWFfY2FwX3plcm8oYmFzZS0+
ZG1hX3NsYXZlLmNhcF9tYXNrKTsKLQlkbWFfY2FwX3NldChETUFfU0xBVkUsIGJhc2UtPmRtYV9z
bGF2ZS5jYXBfbWFzayk7CisJZG1hX2NhcF9zZXQoRE1BX1NMQVZFX1NHTElTVCwgYmFzZS0+ZG1h
X3NsYXZlLmNhcF9tYXNrKTsKIAogCWJhc2UtPmRtYV9zbGF2ZS5kZXZpY2VfYWxsb2NfY2hhbl9y
ZXNvdXJjZXMgPSBjb2g5MDEzMThfYWxsb2NfY2hhbl9yZXNvdXJjZXM7CiAJYmFzZS0+ZG1hX3Ns
YXZlLmRldmljZV9mcmVlX2NoYW5fcmVzb3VyY2VzID0gY29oOTAxMzE4X2ZyZWVfY2hhbl9yZXNv
dXJjZXM7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2RtYS9kbWFlbmdpbmUuYyBiL2RyaXZlcnMvZG1h
L2RtYWVuZ2luZS5jCmluZGV4IDlkMzFkNWUuLjBkMzdjNzYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
ZG1hL2RtYWVuZ2luZS5jCisrKyBiL2RyaXZlcnMvZG1hL2RtYWVuZ2luZS5jCkBAIC0zMDAsNyAr
MzAwLDYgQEAgc3RhdGljIGludCBfX2luaXQgZG1hX2NoYW5uZWxfdGFibGVfaW5pdCh2b2lkKQog
CSAqLwogCWNsZWFyX2JpdChETUFfSU5URVJSVVBULCBkbWFfY2FwX21hc2tfYWxsLmJpdHMpOwog
CWNsZWFyX2JpdChETUFfUFJJVkFURSwgZG1hX2NhcF9tYXNrX2FsbC5iaXRzKTsKLQljbGVhcl9i
aXQoRE1BX1NMQVZFLCBkbWFfY2FwX21hc2tfYWxsLmJpdHMpOwogCiAJZm9yX2VhY2hfZG1hX2Nh
cF9tYXNrKGNhcCwgZG1hX2NhcF9tYXNrX2FsbCkgewogCQljaGFubmVsX3RhYmxlW2NhcF0gPSBh
bGxvY19wZXJjcHUoc3RydWN0IGRtYV9jaGFuX3RibF9lbnQpOwpAQCAtNjkwLDkgKzY4OSwxMyBA
QCBpbnQgZG1hX2FzeW5jX2RldmljZV9yZWdpc3RlcihzdHJ1Y3QgZG1hX2RldmljZSAqZGV2aWNl
KQogCQkhZGV2aWNlLT5kZXZpY2VfcHJlcF9kbWFfbWVtc2V0KTsKIAlCVUdfT04oZG1hX2hhc19j
YXAoRE1BX0lOVEVSUlVQVCwgZGV2aWNlLT5jYXBfbWFzaykgJiYKIAkJIWRldmljZS0+ZGV2aWNl
X3ByZXBfZG1hX2ludGVycnVwdCk7Ci0JQlVHX09OKGRtYV9oYXNfY2FwKERNQV9TTEFWRSwgZGV2
aWNlLT5jYXBfbWFzaykgJiYKKwlCVUdfT04oZG1hX2hhc19jYXAoRE1BX1NMQVZFX1NHTElTVCwg
ZGV2aWNlLT5jYXBfbWFzaykgJiYKIAkJIWRldmljZS0+ZGV2aWNlX3ByZXBfc2xhdmVfc2cpOwot
CUJVR19PTihkbWFfaGFzX2NhcChETUFfU0xBVkUsIGRldmljZS0+Y2FwX21hc2spICYmCisJQlVH
X09OKGRtYV9oYXNfY2FwKERNQV9TTEFWRV9TR0xJU1QsIGRldmljZS0+Y2FwX21hc2spICYmCisJ
CSFkZXZpY2UtPmRldmljZV9jb250cm9sKTsKKwlCVUdfT04oZG1hX2hhc19jYXAoRE1BX1NMQVZF
X0JVRkZFUiwgZGV2aWNlLT5jYXBfbWFzaykgJiYKKwkJIWRldmljZS0+ZGV2aWNlX3ByZXBfc2xh
dmVfYnVmZmVyKTsKKwlCVUdfT04oZG1hX2hhc19jYXAoRE1BX1NMQVZFX0JVRkZFUiwgZGV2aWNl
LT5jYXBfbWFzaykgJiYKIAkJIWRldmljZS0+ZGV2aWNlX2NvbnRyb2wpOwogCiAJQlVHX09OKCFk
ZXZpY2UtPmRldmljZV9hbGxvY19jaGFuX3Jlc291cmNlcyk7CmRpZmYgLS1naXQgYS9kcml2ZXJz
L2RtYS9kd19kbWFjLmMgYi9kcml2ZXJzL2RtYS9kd19kbWFjLmMKaW5kZXggYTM5OTFhYi4uZTM4
ZWEzNSAxMDA2NDQKLS0tIGEvZHJpdmVycy9kbWEvZHdfZG1hYy5jCisrKyBiL2RyaXZlcnMvZG1h
L2R3X2RtYWMuYwpAQCAtMTMzNCw3ICsxMzM0LDcgQEAgc3RhdGljIGludCBfX2luaXQgZHdfcHJv
YmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAljaGFubmVsX2NsZWFyX2JpdChkdywg
TUFTSy5FUlJPUiwgZHctPmFsbF9jaGFuX21hc2spOwogCiAJZG1hX2NhcF9zZXQoRE1BX01FTUNQ
WSwgZHctPmRtYS5jYXBfbWFzayk7Ci0JZG1hX2NhcF9zZXQoRE1BX1NMQVZFLCBkdy0+ZG1hLmNh
cF9tYXNrKTsKKwlkbWFfY2FwX3NldChETUFfU0xBVkVfU0dMSVNULCBkdy0+ZG1hLmNhcF9tYXNr
KTsKIAlkdy0+ZG1hLmRldiA9ICZwZGV2LT5kZXY7CiAJZHctPmRtYS5kZXZpY2VfYWxsb2NfY2hh
bl9yZXNvdXJjZXMgPSBkd2NfYWxsb2NfY2hhbl9yZXNvdXJjZXM7CiAJZHctPmRtYS5kZXZpY2Vf
ZnJlZV9jaGFuX3Jlc291cmNlcyA9IGR3Y19mcmVlX2NoYW5fcmVzb3VyY2VzOwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9kbWEvZnNsZG1hLmMgYi9kcml2ZXJzL2RtYS9mc2xkbWEuYwppbmRleCA4MDg4
YjE0Li4xYjk3NjBhIDEwMDY0NAotLS0gYS9kcml2ZXJzL2RtYS9mc2xkbWEuYworKysgYi9kcml2
ZXJzL2RtYS9mc2xkbWEuYwpAQCAtNTg0LDE2ICs1ODQsMTcgQEAgZmFpbDoKIH0KIAogLyoqCi0g
KiBmc2xfZG1hX3ByZXBfc2xhdmVfc2cgLSBwcmVwYXJlIGRlc2NyaXB0b3JzIGZvciBhIERNQV9T
TEFWRSB0cmFuc2FjdGlvbgorICogZnNsX2RtYV9wcmVwX3NsYXZlX3NnIC0gcHJlcGFyZSBkZXNj
cmlwdG9ycyBmb3IgYSBETUFfU0xBVkVfU0dMSVNUCisgKiB0cmFuc2FjdGlvbgogICogQGNoYW46
IERNQSBjaGFubmVsCiAgKiBAc2dsOiBzY2F0dGVybGlzdCB0byB0cmFuc2ZlciB0by9mcm9tCiAg
KiBAc2dfbGVuOiBudW1iZXIgb2YgZW50cmllcyBpbiBAc2NhdHRlcmxpc3QKICAqIEBkaXJlY3Rp
b246IERNQSBkaXJlY3Rpb24KICAqIEBmbGFnczogRE1BRW5naW5lIGZsYWdzCiAgKgotICogUHJl
cGFyZSBhIHNldCBvZiBkZXNjcmlwdG9ycyBmb3IgYSBETUFfU0xBVkUgdHJhbnNhY3Rpb24uIEZv
bGxvd2luZyB0aGUKLSAqIERNQV9TTEFWRSBBUEksIHRoaXMgZ2V0cyB0aGUgZGV2aWNlLXNwZWNp
ZmljIGluZm9ybWF0aW9uIGZyb20gdGhlCi0gKiBjaGFuLT5wcml2YXRlIHZhcmlhYmxlLgorICog
UHJlcGFyZSBhIHNldCBvZiBkZXNjcmlwdG9ycyBmb3IgYSBETUFfU0xBVkVfU0dMSVNUIHRyYW5z
YWN0aW9uLgorICogRm9sbG93aW5nIHRoZSBETUFfU0xBVkUgQVBJLCB0aGlzIGdldHMgdGhlIGRl
dmljZS1zcGVjaWZpYyBpbmZvcm1hdGlvbgorICogZnJvbSB0aGUgY2hhbi0+cHJpdmF0ZSB2YXJp
YWJsZS4KICAqLwogc3RhdGljIHN0cnVjdCBkbWFfYXN5bmNfdHhfZGVzY3JpcHRvciAqZnNsX2Rt
YV9wcmVwX3NsYXZlX3NnKAogCXN0cnVjdCBkbWFfY2hhbiAqZGNoYW4sIHN0cnVjdCBzY2F0dGVy
bGlzdCAqc2dsLCB1bnNpZ25lZCBpbnQgc2dfbGVuLApAQCAtMTMyNyw3ICsxMzI4LDcgQEAgc3Rh
dGljIGludCBfX2RldmluaXQgZnNsZG1hX29mX3Byb2JlKHN0cnVjdCBvZl9kZXZpY2UgKm9wLAog
CiAJZG1hX2NhcF9zZXQoRE1BX01FTUNQWSwgZmRldi0+Y29tbW9uLmNhcF9tYXNrKTsKIAlkbWFf
Y2FwX3NldChETUFfSU5URVJSVVBULCBmZGV2LT5jb21tb24uY2FwX21hc2spOwotCWRtYV9jYXBf
c2V0KERNQV9TTEFWRSwgZmRldi0+Y29tbW9uLmNhcF9tYXNrKTsKKwlkbWFfY2FwX3NldChETUFf
U0xBVkVfU0dMSVNULCBmZGV2LT5jb21tb24uY2FwX21hc2spOwogCWZkZXYtPmNvbW1vbi5kZXZp
Y2VfYWxsb2NfY2hhbl9yZXNvdXJjZXMgPSBmc2xfZG1hX2FsbG9jX2NoYW5fcmVzb3VyY2VzOwog
CWZkZXYtPmNvbW1vbi5kZXZpY2VfZnJlZV9jaGFuX3Jlc291cmNlcyA9IGZzbF9kbWFfZnJlZV9j
aGFuX3Jlc291cmNlczsKIAlmZGV2LT5jb21tb24uZGV2aWNlX3ByZXBfZG1hX2ludGVycnVwdCA9
IGZzbF9kbWFfcHJlcF9pbnRlcnJ1cHQ7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2RtYS9pcHUvaXB1
X2lkbWFjLmMgYi9kcml2ZXJzL2RtYS9pcHUvaXB1X2lkbWFjLmMKaW5kZXggY2IyNmVlOS4uMjdk
ODIyNiAxMDA2NDQKLS0tIGEvZHJpdmVycy9kbWEvaXB1L2lwdV9pZG1hYy5jCisrKyBiL2RyaXZl
cnMvZG1hL2lwdS9pcHVfaWRtYWMuYwpAQCAtMTY2NSw3ICsxNjY1LDcgQEAgc3RhdGljIGludCBf
X2luaXQgaXB1X2lkbWFjX2luaXQoc3RydWN0IGlwdSAqaXB1KQogCXN0cnVjdCBkbWFfZGV2aWNl
ICpkbWEgPSAmaWRtYWMtPmRtYTsKIAlpbnQgaTsKIAotCWRtYV9jYXBfc2V0KERNQV9TTEFWRSwg
ZG1hLT5jYXBfbWFzayk7CisJZG1hX2NhcF9zZXQoRE1BX1NMQVZFX1NHTElTVCwgZG1hLT5jYXBf
bWFzayk7CiAJZG1hX2NhcF9zZXQoRE1BX1BSSVZBVEUsIGRtYS0+Y2FwX21hc2spOwogCiAJLyog
Q29tcHVsc29yeSBjb21tb24gZmllbGRzICovCkBAIC0xNjc1LDcgKzE2NzUsNyBAQCBzdGF0aWMg
aW50IF9faW5pdCBpcHVfaWRtYWNfaW5pdChzdHJ1Y3QgaXB1ICppcHUpCiAJZG1hLT5kZXZpY2Vf
dHhfc3RhdHVzCQkJPSBpZG1hY190eF9zdGF0dXM7CiAJZG1hLT5kZXZpY2VfaXNzdWVfcGVuZGlu
ZwkJPSBpZG1hY19pc3N1ZV9wZW5kaW5nOwogCi0JLyogQ29tcHVsc29yeSBmb3IgRE1BX1NMQVZF
IGZpZWxkcyAqLworCS8qIENvbXB1bHNvcnkgZm9yIERNQV9TTEFWRV9TR0xJU1QgZmllbGRzICov
CiAJZG1hLT5kZXZpY2VfcHJlcF9zbGF2ZV9zZwkJPSBpZG1hY19wcmVwX3NsYXZlX3NnOwogCWRt
YS0+ZGV2aWNlX2NvbnRyb2wJCQk9IGlkbWFjX2NvbnRyb2w7CiAKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvZG1hL3BsMzMwLmMgYi9kcml2ZXJzL2RtYS9wbDMzMC5jCmluZGV4IDdjNTBmNmQuLjM5NzQz
NTcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1hL3BsMzMwLmMKKysrIGIvZHJpdmVycy9kbWEvcGwz
MzAuYwpAQCAtNzI3LDcgKzcyNyw3IEBAIHBsMzMwX3Byb2JlKHN0cnVjdCBhbWJhX2RldmljZSAq
YWRldiwgc3RydWN0IGFtYmFfaWQgKmlkKQogCQkJYnJlYWs7CiAJCWNhc2UgTUVNVE9ERVY6CiAJ
CWNhc2UgREVWVE9NRU06Ci0JCQlkbWFfY2FwX3NldChETUFfU0xBVkUsIHBkLT5jYXBfbWFzayk7
CisJCQlkbWFfY2FwX3NldChETUFfU0xBVkVfU0dMSVNULCBwZC0+Y2FwX21hc2spOwogCQkJYnJl
YWs7CiAJCWRlZmF1bHQ6CiAJCQlkZXZfZXJyKCZhZGV2LT5kZXYsICJERVZUT0RFViBOb3QgU3Vw
cG9ydGVkXG4iKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvZG1hL3NoZG1hLmMgYi9kcml2ZXJzL2Rt
YS9zaGRtYS5jCmluZGV4IGZiNjRjZjMuLjViMDlmODEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1h
L3NoZG1hLmMKKysrIGIvZHJpdmVycy9kbWEvc2hkbWEuYwpAQCAtMTA0MCw3ICsxMDQwLDcgQEAg
c3RhdGljIGludCBfX2luaXQgc2hfZG1hZV9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpw
ZGV2KQogCiAJZG1hX2NhcF9zZXQoRE1BX01FTUNQWSwgc2hkZXYtPmNvbW1vbi5jYXBfbWFzayk7
CiAJaWYgKGRtYXJzKQotCQlkbWFfY2FwX3NldChETUFfU0xBVkUsIHNoZGV2LT5jb21tb24uY2Fw
X21hc2spOworCQlkbWFfY2FwX3NldChETUFfU0xBVkVfU0dMSVNULCBzaGRldi0+Y29tbW9uLmNh
cF9tYXNrKTsKIAogCXNoZGV2LT5jb21tb24uZGV2aWNlX2FsbG9jX2NoYW5fcmVzb3VyY2VzCiAJ
CT0gc2hfZG1hZV9hbGxvY19jaGFuX3Jlc291cmNlczsKQEAgLTEwNDksNyArMTA0OSw3IEBAIHN0
YXRpYyBpbnQgX19pbml0IHNoX2RtYWVfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRl
dikKIAlzaGRldi0+Y29tbW9uLmRldmljZV90eF9zdGF0dXMgPSBzaF9kbWFlX3R4X3N0YXR1czsK
IAlzaGRldi0+Y29tbW9uLmRldmljZV9pc3N1ZV9wZW5kaW5nID0gc2hfZG1hZV9tZW1jcHlfaXNz
dWVfcGVuZGluZzsKIAotCS8qIENvbXB1bHNvcnkgZm9yIERNQV9TTEFWRSBmaWVsZHMgKi8KKwkv
KiBDb21wdWxzb3J5IGZvciBETUFfU0xBVkVfU0dMSVNUIGZpZWxkcyAqLwogCXNoZGV2LT5jb21t
b24uZGV2aWNlX3ByZXBfc2xhdmVfc2cgPSBzaF9kbWFlX3ByZXBfc2xhdmVfc2c7CiAJc2hkZXYt
PmNvbW1vbi5kZXZpY2VfY29udHJvbCA9IHNoX2RtYWVfY29udHJvbDsKIApkaWZmIC0tZ2l0IGEv
ZHJpdmVycy9kbWEvc3RlX2RtYTQwLmMgYi9kcml2ZXJzL2RtYS9zdGVfZG1hNDAuYwppbmRleCAy
MWE3NTk3Li5mMTUzODAwIDEwMDY0NAotLS0gYS9kcml2ZXJzL2RtYS9zdGVfZG1hNDAuYworKysg
Yi9kcml2ZXJzL2RtYS9zdGVfZG1hNDAuYwpAQCAtMTIxMCwxNCArMTIxMCwxNSBAQCBzdGF0aWMg
aW50IGQ0MF9jb25maWdfbWVtY3B5KHN0cnVjdCBkNDBfY2hhbiAqZDQwYykKIHsKIAlkbWFfY2Fw
X21hc2tfdCBjYXAgPSBkNDBjLT5jaGFuLmRldmljZS0+Y2FwX21hc2s7CiAKLQlpZiAoZG1hX2hh
c19jYXAoRE1BX01FTUNQWSwgY2FwKSAmJiAhZG1hX2hhc19jYXAoRE1BX1NMQVZFLCBjYXApKSB7
CisJaWYgKGRtYV9oYXNfY2FwKERNQV9NRU1DUFksIGNhcCkgJiYKKwkJIWRtYV9oYXNfY2FwKERN
QV9TTEFWRV9TR0xJU1QsIGNhcCkpIHsKIAkJZDQwYy0+ZG1hX2NmZyA9ICpkNDBjLT5iYXNlLT5w
bGF0X2RhdGEtPm1lbWNweV9jb25mX2xvZzsKIAkJZDQwYy0+ZG1hX2NmZy5zcmNfZGV2X3R5cGUg
PSBTVEVETUE0MF9ERVZfU1JDX01FTU9SWTsKIAkJZDQwYy0+ZG1hX2NmZy5kc3RfZGV2X3R5cGUg
PSBkNDBjLT5iYXNlLT5wbGF0X2RhdGEtPgogCQkJbWVtY3B5W2Q0MGMtPmNoYW4uY2hhbl9pZF07
CiAKIAl9IGVsc2UgaWYgKGRtYV9oYXNfY2FwKERNQV9NRU1DUFksIGNhcCkgJiYKLQkJICAgZG1h
X2hhc19jYXAoRE1BX1NMQVZFLCBjYXApKSB7CisJCSAgIGRtYV9oYXNfY2FwKERNQV9TTEFWRV9T
R0xJU1QsIGNhcCkpIHsKIAkJZDQwYy0+ZG1hX2NmZyA9ICpkNDBjLT5iYXNlLT5wbGF0X2RhdGEt
Pm1lbWNweV9jb25mX3BoeTsKIAl9IGVsc2UgewogCQlkZXZfZXJyKCZkNDBjLT5jaGFuLmRldi0+
ZGV2aWNlLCAiWyVzXSBObyBtZW1jcHlcbiIsCkBAIC0yMTQzLDcgKzIxNDQsNyBAQCBzdGF0aWMg
aW50IF9faW5pdCBkNDBfZG1hZW5naW5lX2luaXQoc3RydWN0IGQ0MF9iYXNlICpiYXNlLAogCQkg
ICAgICAwLCBiYXNlLT5udW1fbG9nX2NoYW5zKTsKIAogCWRtYV9jYXBfemVybyhiYXNlLT5kbWFf
c2xhdmUuY2FwX21hc2spOwotCWRtYV9jYXBfc2V0KERNQV9TTEFWRSwgYmFzZS0+ZG1hX3NsYXZl
LmNhcF9tYXNrKTsKKwlkbWFfY2FwX3NldChETUFfU0xBVkVfU0dMSVNULCBiYXNlLT5kbWFfc2xh
dmUuY2FwX21hc2spOwogCiAJYmFzZS0+ZG1hX3NsYXZlLmRldmljZV9hbGxvY19jaGFuX3Jlc291
cmNlcyA9IGQ0MF9hbGxvY19jaGFuX3Jlc291cmNlczsKIAliYXNlLT5kbWFfc2xhdmUuZGV2aWNl
X2ZyZWVfY2hhbl9yZXNvdXJjZXMgPSBkNDBfZnJlZV9jaGFuX3Jlc291cmNlczsKQEAgLTIxOTYs
NyArMjE5Nyw3IEBAIHN0YXRpYyBpbnQgX19pbml0IGQ0MF9kbWFlbmdpbmVfaW5pdChzdHJ1Y3Qg
ZDQwX2Jhc2UgKmJhc2UsCiAJCSAgICAgIDAsIG51bV9yZXNlcnZlZF9jaGFucyk7CiAKIAlkbWFf
Y2FwX3plcm8oYmFzZS0+ZG1hX2JvdGguY2FwX21hc2spOwotCWRtYV9jYXBfc2V0KERNQV9TTEFW
RSwgYmFzZS0+ZG1hX2JvdGguY2FwX21hc2spOworCWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJ
U1QsIGJhc2UtPmRtYV9ib3RoLmNhcF9tYXNrKTsKIAlkbWFfY2FwX3NldChETUFfTUVNQ1BZLCBi
YXNlLT5kbWFfYm90aC5jYXBfbWFzayk7CiAKIAliYXNlLT5kbWFfYm90aC5kZXZpY2VfYWxsb2Nf
Y2hhbl9yZXNvdXJjZXMgPSBkNDBfYWxsb2NfY2hhbl9yZXNvdXJjZXM7CmRpZmYgLS1naXQgYS9k
cml2ZXJzL2RtYS90aW1iX2RtYS5jIGIvZHJpdmVycy9kbWEvdGltYl9kbWEuYwppbmRleCAyZWMx
ZWQ1Li43NTE0OTg4MyAxMDA2NDQKLS0tIGEvZHJpdmVycy9kbWEvdGltYl9kbWEuYworKysgYi9k
cml2ZXJzL2RtYS90aW1iX2RtYS5jCkBAIC03NDQsNyArNzQ0LDcgQEAgc3RhdGljIGludCBfX2Rl
dmluaXQgdGRfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikKIAl0ZC0+ZG1hLmRl
dmljZV90eF9zdGF0dXMJCT0gdGRfdHhfc3RhdHVzOwogCXRkLT5kbWEuZGV2aWNlX2lzc3VlX3Bl
bmRpbmcJCT0gdGRfaXNzdWVfcGVuZGluZzsKIAotCWRtYV9jYXBfc2V0KERNQV9TTEFWRSwgdGQt
PmRtYS5jYXBfbWFzayk7CisJZG1hX2NhcF9zZXQoRE1BX1NMQVZFX1NHTElTVCwgdGQtPmRtYS5j
YXBfbWFzayk7CiAJZG1hX2NhcF9zZXQoRE1BX1BSSVZBVEUsIHRkLT5kbWEuY2FwX21hc2spOwog
CXRkLT5kbWEuZGV2aWNlX3ByZXBfc2xhdmVfc2cgPSB0ZF9wcmVwX3NsYXZlX3NnOwogCXRkLT5k
bWEuZGV2aWNlX2NvbnRyb2wgPSB0ZF9jb250cm9sOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9kbWEv
dHh4OWRtYWMuYyBiL2RyaXZlcnMvZG1hL3R4eDlkbWFjLmMKaW5kZXggY2JkODNlMzYuLmMyZDEz
NDMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZG1hL3R4eDlkbWFjLmMKKysrIGIvZHJpdmVycy9kbWEv
dHh4OWRtYWMuYwpAQCAtMTE2NCw3ICsxMTY0LDcgQEAgc3RhdGljIGludCBfX2luaXQgdHh4OWRt
YWNfY2hhbl9wcm9iZShzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCQlkbWFfY2FwX3Nl
dChETUFfTUVNQ1BZLCBkYy0+ZG1hLmNhcF9tYXNrKTsKIAl9IGVsc2UgewogCQlkYy0+ZG1hLmRl
dmljZV9wcmVwX3NsYXZlX3NnID0gdHh4OWRtYWNfcHJlcF9zbGF2ZV9zZzsKLQkJZG1hX2NhcF9z
ZXQoRE1BX1NMQVZFLCBkYy0+ZG1hLmNhcF9tYXNrKTsKKwkJZG1hX2NhcF9zZXQoRE1BX1NMQVZF
X1NHTElTVCwgZGMtPmRtYS5jYXBfbWFzayk7CiAJCWRtYV9jYXBfc2V0KERNQV9QUklWQVRFLCBk
Yy0+ZG1hLmNhcF9tYXNrKTsKIAl9CiAKQEAgLTEyMDgsNyArMTIwOCw4IEBAIHN0YXRpYyBpbnQg
X19pbml0IHR4eDlkbWFjX2NoYW5fcHJvYmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRldikK
IAlkZXZfZGJnKCZwZGV2LT5kZXYsICJUWHg5IERNQSBDaGFubmVsIChkbWElZCVzJXMpXG4iLAog
CQlkYy0+ZG1hLmRldl9pZCwKIAkJZG1hX2hhc19jYXAoRE1BX01FTUNQWSwgZGMtPmRtYS5jYXBf
bWFzaykgPyAiIG1lbWNweSIgOiAiIiwKLQkJZG1hX2hhc19jYXAoRE1BX1NMQVZFLCBkYy0+ZG1h
LmNhcF9tYXNrKSA/ICIgc2xhdmUiIDogIiIpOworCQlkbWFfaGFzX2NhcChETUFfU0xBVkVfU0dM
SVNULCBkYy0+ZG1hLmNhcF9tYXNrKSA/CisJCSIgc2xhdmUiIDogIiIpOwogCiAJcmV0dXJuIDA7
CiB9CmRpZmYgLS1naXQgYS9kcml2ZXJzL21lZGlhL3ZpZGVvL214M19jYW1lcmEuYyBiL2RyaXZl
cnMvbWVkaWEvdmlkZW8vbXgzX2NhbWVyYS5jCmluZGV4IGE5YmUxNGMuLmZkNmY3MzUgMTAwNjQ0
Ci0tLSBhL2RyaXZlcnMvbWVkaWEvdmlkZW8vbXgzX2NhbWVyYS5jCisrKyBiL2RyaXZlcnMvbWVk
aWEvdmlkZW8vbXgzX2NhbWVyYS5jCkBAIC03ODAsNyArNzgwLDcgQEAgc3RhdGljIGludCBhY3F1
aXJlX2RtYV9jaGFubmVsKHN0cnVjdCBteDNfY2FtZXJhX2RldiAqbXgzX2NhbSkKIAl9CiAKIAlk
bWFfY2FwX3plcm8obWFzayk7Ci0JZG1hX2NhcF9zZXQoRE1BX1NMQVZFLCBtYXNrKTsKKwlkbWFf
Y2FwX3NldChETUFfU0xBVkVfU0dMSVNULCBtYXNrKTsKIAlkbWFfY2FwX3NldChETUFfUFJJVkFU
RSwgbWFzayk7CiAJY2hhbiA9IGRtYV9yZXF1ZXN0X2NoYW5uZWwobWFzaywgY2hhbl9maWx0ZXIs
ICZycSk7CiAJaWYgKCFjaGFuKQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9zdC9hdG1lbC1t
Y2kuYyBiL2RyaXZlcnMvbW1jL2hvc3QvYXRtZWwtbWNpLmMKaW5kZXggOTVlZjg2NC4uZmFlNGIz
OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9tbWMvaG9zdC9hdG1lbC1tY2kuYworKysgYi9kcml2ZXJz
L21tYy9ob3N0L2F0bWVsLW1jaS5jCkBAIC0xNzI4LDcgKzE3MjgsNyBAQCBzdGF0aWMgdm9pZCBh
dG1jaV9jb25maWd1cmVfZG1hKHN0cnVjdCBhdG1lbF9tY2kgKmhvc3QpCiAKIAkJLyogVHJ5IHRv
IGdyYWIgYSBETUEgY2hhbm5lbCAqLwogCQlkbWFfY2FwX3plcm8obWFzayk7Ci0JCWRtYV9jYXBf
c2V0KERNQV9TTEFWRSwgbWFzayk7CisJCWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJU1QsIG1h
c2spOwogCQlob3N0LT5kbWEuY2hhbiA9CiAJCQlkbWFfcmVxdWVzdF9jaGFubmVsKG1hc2ssIGZp
bHRlciwgcGRhdGEtPmRtYV9zbGF2ZSk7CiAJfQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9tbWMvaG9z
dC90bWlvX21tYy5jIGIvZHJpdmVycy9tbWMvaG9zdC90bWlvX21tYy5jCmluZGV4IGVlN2QwYTUu
LjkwNWZmYjIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbW1jL2hvc3QvdG1pb19tbWMuYworKysgYi9k
cml2ZXJzL21tYy9ob3N0L3RtaW9fbW1jLmMKQEAgLTU5MSw3ICs1OTEsNyBAQCBzdGF0aWMgdm9p
ZCB0bWlvX21tY19yZXF1ZXN0X2RtYShzdHJ1Y3QgdG1pb19tbWNfaG9zdCAqaG9zdCwKIAkJZG1h
X2NhcF9tYXNrX3QgbWFzazsKIAogCQlkbWFfY2FwX3plcm8obWFzayk7Ci0JCWRtYV9jYXBfc2V0
KERNQV9TTEFWRSwgbWFzayk7CisJCWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJU1QsIG1hc2sp
OwogCiAJCWhvc3QtPmNoYW5fdHggPSBkbWFfcmVxdWVzdF9jaGFubmVsKG1hc2ssIHRtaW9fbW1j
X2ZpbHRlciwKIAkJCQkJCSAgICBwZGF0YS0+ZG1hLT5jaGFuX3ByaXZfdHgpOwpkaWZmIC0tZ2l0
IGEvZHJpdmVycy9zZXJpYWwvc2gtc2NpLmMgYi9kcml2ZXJzL3NlcmlhbC9zaC1zY2kuYwppbmRl
eCBjMjkxYjNhLi4wZWZhYjcxIDEwMDY0NAotLS0gYS9kcml2ZXJzL3NlcmlhbC9zaC1zY2kuYwor
KysgYi9kcml2ZXJzL3NlcmlhbC9zaC1zY2kuYwpAQCAtMTMxNiw3ICsxMzE2LDcgQEAgc3RhdGlj
IHZvaWQgc2NpX3JlcXVlc3RfZG1hKHN0cnVjdCB1YXJ0X3BvcnQgKnBvcnQpCiAJCXJldHVybjsK
IAogCWRtYV9jYXBfemVybyhtYXNrKTsKLQlkbWFfY2FwX3NldChETUFfU0xBVkUsIG1hc2spOwor
CWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJU1QsIG1hc2spOwogCiAJcGFyYW0gPSAmcy0+cGFy
YW1fdHg7CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmlkZW8vbXgzZmIuYyBiL2RyaXZlcnMvdmlk
ZW8vbXgzZmIuYwppbmRleCA3Y2ZjMTcwLi5jZWQ3ZDg2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3Zp
ZGVvL214M2ZiLmMKKysrIGIvZHJpdmVycy92aWRlby9teDNmYi5jCkBAIC0xNDgyLDcgKzE0ODIs
NyBAQCBzdGF0aWMgaW50IG14M2ZiX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYp
CiAJcnEubXgzZmIgPSBteDNmYjsKIAogCWRtYV9jYXBfemVybyhtYXNrKTsKLQlkbWFfY2FwX3Nl
dChETUFfU0xBVkUsIG1hc2spOworCWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJU1QsIG1hc2sp
OwogCWRtYV9jYXBfc2V0KERNQV9QUklWQVRFLCBtYXNrKTsKIAlycS5pZCA9IElETUFDX1NEQ18w
OwogCWNoYW4gPSBkbWFfcmVxdWVzdF9jaGFubmVsKG1hc2ssIGNoYW5fZmlsdGVyLCAmcnEpOwpk
aWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9kbWFlbmdpbmUuaCBiL2luY2x1ZGUvbGludXgvZG1h
ZW5naW5lLmgKaW5kZXggM2NhZmYxYy4uYjIzYmU2ZSAxMDA2NDQKLS0tIGEvaW5jbHVkZS9saW51
eC9kbWFlbmdpbmUuaAorKysgYi9pbmNsdWRlL2xpbnV4L2RtYWVuZ2luZS5oCkBAIC02NiwxMSAr
NjYsMTIgQEAgZW51bSBkbWFfdHJhbnNhY3Rpb25fdHlwZSB7CiAJRE1BX0lOVEVSUlVQVCwKIAlE
TUFfUFJJVkFURSwKIAlETUFfQVNZTkNfVFgsCi0JRE1BX1NMQVZFLAorCURNQV9TTEFWRV9TR0xJ
U1QsCisJRE1BX1NMQVZFX0JVRkZFUiwKIH07CiAKIC8qIGxhc3QgdHJhbnNhY3Rpb24gdHlwZSBm
b3IgY3JlYXRpb24gb2YgdGhlIGNhcGFiaWxpdGllcyBtYXNrICovCi0jZGVmaW5lIERNQV9UWF9U
WVBFX0VORCAoRE1BX1NMQVZFICsgMSkKKyNkZWZpbmUgRE1BX1RYX1RZUEVfRU5EIChETUFfU0xB
VkVfQlVGRkVSICsgMSkKIAogCiAvKioKZGlmZiAtLWdpdCBhL3NvdW5kL2F0bWVsL2FiZGFjLmMg
Yi9zb3VuZC9hdG1lbC9hYmRhYy5jCmluZGV4IGYyZjQxYzguLjY0MmJkZWEgMTAwNjQ0Ci0tLSBh
L3NvdW5kL2F0bWVsL2FiZGFjLmMKKysrIGIvc291bmQvYXRtZWwvYWJkYWMuYwpAQCAtNDczLDcg
KzQ3Myw3IEBAIHN0YXRpYyBpbnQgX19kZXZpbml0IGF0bWVsX2FiZGFjX3Byb2JlKHN0cnVjdCBw
bGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJCWR3cy0+dHhfcmVnID0gcmVncy0+c3RhcnQgKyBEQUNf
REFUQTsKIAogCQlkbWFfY2FwX3plcm8obWFzayk7Ci0JCWRtYV9jYXBfc2V0KERNQV9TTEFWRSwg
bWFzayk7CisJCWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJU1QsIG1hc2spOwogCiAJCWRhYy0+
ZG1hLmNoYW4gPSBkbWFfcmVxdWVzdF9jaGFubmVsKG1hc2ssIGZpbHRlciwgZHdzKTsKIAl9CmRp
ZmYgLS1naXQgYS9zb3VuZC9hdG1lbC9hYzk3Yy5jIGIvc291bmQvYXRtZWwvYWM5N2MuYwppbmRl
eCAxMGMzYTg3Li4xZjBkMzI4IDEwMDY0NAotLS0gYS9zb3VuZC9hdG1lbC9hYzk3Yy5jCisrKyBi
L3NvdW5kL2F0bWVsL2FjOTdjLmMKQEAgLTEwMTMsNyArMTAxMyw3IEBAIHN0YXRpYyBpbnQgX19k
ZXZpbml0IGF0bWVsX2FjOTdjX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBkZXYpCiAJ
CQlkd3MtPnJ4X3JlZyA9IHJlZ3MtPnN0YXJ0ICsgQUM5N0NfQ0FSSFIgKyAyOwogCiAJCQlkbWFf
Y2FwX3plcm8obWFzayk7Ci0JCQlkbWFfY2FwX3NldChETUFfU0xBVkUsIG1hc2spOworCQkJZG1h
X2NhcF9zZXQoRE1BX1NMQVZFX1NHTElTVCwgbWFzayk7CiAKIAkJCWNoaXAtPmRtYS5yeF9jaGFu
ID0gZG1hX3JlcXVlc3RfY2hhbm5lbChtYXNrLCBmaWx0ZXIsCiAJCQkJCQkJCWR3cyk7CkBAIC0x
MDMwLDcgKzEwMzAsNyBAQCBzdGF0aWMgaW50IF9fZGV2aW5pdCBhdG1lbF9hYzk3Y19wcm9iZShz
dHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQogCQkJZHdzLT50eF9yZWcgPSByZWdzLT5zdGFy
dCArIEFDOTdDX0NBVEhSICsgMjsKIAogCQkJZG1hX2NhcF96ZXJvKG1hc2spOwotCQkJZG1hX2Nh
cF9zZXQoRE1BX1NMQVZFLCBtYXNrKTsKKwkJCWRtYV9jYXBfc2V0KERNQV9TTEFWRV9TR0xJU1Qs
IG1hc2spOwogCiAJCQljaGlwLT5kbWEudHhfY2hhbiA9IGRtYV9yZXF1ZXN0X2NoYW5uZWwobWFz
aywgZmlsdGVyLAogCQkJCQkJCQlkd3MpOwpkaWZmIC0tZ2l0IGEvc291bmQvc29jL3NoL3NpdV9w
Y20uYyBiL3NvdW5kL3NvYy9zaC9zaXVfcGNtLmMKaW5kZXggMzYxNzBiZS4uYThhODczOCAxMDA2
NDQKLS0tIGEvc291bmQvc29jL3NoL3NpdV9wY20uYworKysgYi9zb3VuZC9zb2Mvc2gvc2l1X3Bj
bS5jCkBAIC0zNTAsNyArMzUwLDcgQEAgc3RhdGljIGludCBzaXVfcGNtX29wZW4oc3RydWN0IHNu
ZF9wY21fc3Vic3RyZWFtICpzcykKIAlzdHJ1Y3Qgc2hfZG1hZV9zbGF2ZSAqcGFyYW07CiAKIAlk
bWFfY2FwX3plcm8obWFzayk7Ci0JZG1hX2NhcF9zZXQoRE1BX1NMQVZFLCBtYXNrKTsKKwlkbWFf
Y2FwX3NldChETUFfU0xBVkVfU0dMSVNULCBtYXNrKTsKIAogCWRldl9kYmcoZGV2LCAiJXMsIHBv
cnQ9JWRAJXBcbiIsIF9fZnVuY19fLCBwb3J0LCBwb3J0X2luZm8pOwogCmRpZmYgLS1naXQgYS9z
b3VuZC9zb2MvdHh4OS90eHg5YWNsYy5jIGIvc291bmQvc29jL3R4eDkvdHh4OWFjbGMuYwppbmRl
eCAwZTM0NTIzMC4uMTFjOTUyNSAxMDA2NDQKLS0tIGEvc291bmQvc29jL3R4eDkvdHh4OWFjbGMu
YworKysgYi9zb3VuZC9zb2MvdHh4OS90eHg5YWNsYy5jCkBAIC0zMzEsNyArMzMxLDcgQEAgc3Rh
dGljIGludCB0eHg5YWNsY19kbWFfaW5pdChzdHJ1Y3QgdHh4OWFjbGNfc29jX2RldmljZSAqZGV2
LAogCiAJLyogVHJ5IHRvIGdyYWIgYSBETUEgY2hhbm5lbCAqLwogCWRtYV9jYXBfemVybyhtYXNr
KTsKLQlkbWFfY2FwX3NldChETUFfU0xBVkUsIG1hc2spOworCWRtYV9jYXBfc2V0KERNQV9TTEFW
RV9TR0xJU1QsIG1hc2spOwogCWRtYWRhdGEtPmRtYV9jaGFuID0gZG1hX3JlcXVlc3RfY2hhbm5l
bChtYXNrLCBmaWx0ZXIsIGRtYWRhdGEpOwogCWlmICghZG1hZGF0YS0+ZG1hX2NoYW4pIHsKIAkJ
ZGV2X2VycihkZXYtPnNvY19kZXYuZGV2LAotLSAKMS43LjIKCg==
--0016e6dd8bf22e9516048c7a7531--
