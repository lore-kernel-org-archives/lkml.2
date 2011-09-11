Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270Ab1IKPLF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 11:11:05 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:40851 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754499Ab1IKPLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 11:11:02 -0400
X-Sasl-enc: Q8TBKcZSjZyfdjSASNbbjgMcoWGZFxqptpuMLQd0LcxS 1315753860
Message-ID: <4E6CCF6C.2020301@ladisch.de>
Date: Sun, 11 Sep 2011 17:10:36 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090820)
MIME-Version: 1.0
To: Yong Zhang <yong.zhang0@gmail.com>
CC: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com> <1315383059-3673-3-git-send-email-yong.zhang0@gmail.com> <4E689E9A.8000407@ladisch.de> <20110908133700.GB2310@zhy> <4E68CA15.8000504@ladisch.de> <20110908144519.GB3069@zhy> <4E69253F.3090705@ladisch.de> <20110909013143.GB18249@zhy>
In-Reply-To: <20110909013143.GB18249@zhy>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> On Thu, Sep 08, 2011 at 10:27:43PM +0200, Clemens Ladisch wrote:
> > I'll write a patch that changes this function so that irq<0 means
> > "already reserved", and that "no interrupt" gets another bit in the
> > info_flags parameter.
>
> So my patch will be based on yours;

Here you are; any IRQF changes should now be trivial.


Regards,
Clemens

--8<---------------------------------------------------------------->8--
[PATCH] ALSA: mpu401: clean up interrupt specification

The semantics of snd_mpu401_uart_new()'s interrupt parameters are
somewhat counterintuitive:  To prevent the function from allocating its
own interrupt, either the irq number must be invalid, or the irq_flags
parameter must be zero.  At the same time, the irq parameter being
invalid specifies that the mpu401 code has to work without an interrupt
allocated by the caller.  This implies that, if there is an interrupt
and it is allocated by the caller, the irq parameter must be set to
a valid-looking number which then isn't actually used.

With the removal of IRQF_DISABLED, zero becomes a valid irq_flags value,
which forces us to handle the parameters differently.

This patch introduces a new flag MPU401_INFO_RX_POLL for interrupt-less
operation, and makes the decision to allocate the interrupt to depend
only on the irq parameter.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/DocBook/writing-an-alsa-driver.tmpl |   20 ++++++++++++--------
 include/sound/mpu401.h                            |    4 ++--
 sound/drivers/mpu401/mpu401.c                     |    6 +++---
 sound/drivers/mpu401/mpu401_uart.c                |   13 ++++++-------
 sound/isa/ad1816a/ad1816a.c                       |    5 +++--
 sound/isa/als100.c                                |   10 +++++++---
 sound/isa/azt2320.c                               |    3 ++-
 sound/isa/cmi8330.c                               |    3 ++-
 sound/isa/cs423x/cs4231.c                         |    9 ++++++---
 sound/isa/cs423x/cs4236.c                         |    9 ++++++---
 sound/isa/es18xx.c                                |    2 +-
 sound/isa/galaxy/galaxy.c                         |    3 ++-
 sound/isa/gus/gusextreme.c                        |    3 ++-
 sound/isa/opl3sa2.c                               |    2 +-
 sound/isa/sb/jazz16.c                             |   10 +++++++---
 sound/isa/sb/sb16.c                               |    2 +-
 sound/isa/sc6000.c                                |    7 +++++--
 sound/isa/wavefront/wavefront.c                   |    5 ++++-
 sound/pci/als4000.c                               |    2 +-
 sound/pci/au88x0/au88x0_mpu401.c                  |    4 ++--
 sound/pci/azt3328.c                               |    2 +-
 sound/pci/cmipci.c                                |    2 +-
 sound/pci/es1938.c                                |    2 +-
 sound/pci/es1968.c                                |    2 +-
 sound/pci/fm801.c                                 |    2 +-
 sound/pci/ice1712/ice1712.c                       |    4 ++--
 sound/pci/maestro3.c                              |    2 +-
 sound/pci/oxygen/oxygen_lib.c                     |    2 +-
 sound/pci/riptide/riptide.c                       |    2 +-
 sound/pci/sonicvibes.c                            |    2 +-
 sound/pci/trident/trident.c                       |    2 +-
 sound/pci/via82xx.c                               |    2 +-
 sound/pci/ymfpci/ymfpci.c                         |    2 +-
 33 files changed, 89 insertions(+), 61 deletions(-)

diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index 598c22f..24e21d0 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -4343,6 +4343,12 @@ struct _snd_pcm_runtime {
 	by itself to start processing the output stream in the irq handler.
 	</para>

+	<para>
+	If the card doesn't generate UART interrupts, add the
+	<constant>MPU401_INFO_RX_POLL</constant> flag.  Then a timer
+	interrupt will be invoked for polling.
+	</para>
+
       <para>
         Usually, the port address corresponds to the command port and
         port + 1 corresponds to the data port. If not, you may change
@@ -4375,14 +4381,12 @@ struct _snd_pcm_runtime {
       </para>

       <para>
-        The 6th argument specifies the irq number for UART. If the irq
-      is already allocated, pass 0 to the 7th argument
-      (<parameter>irq_flags</parameter>). Otherwise, pass the flags
-      for irq allocation
-      (<constant>SA_XXX</constant> bits) to it, and the irq will be
-      reserved by the mpu401-uart layer. If the card doesn't generate
-      UART interrupts, pass -1 as the irq number. Then a timer
-      interrupt will be invoked for polling.
+      The 6th argument specifies the irq number that will be allocated.
+      Pass the irq flags for calling <function>request_irq()</function>
+      (<constant>IRQF_XXX</constant> bits) in the 7th argument.
+      If no interrupt is to be allocated (because your code is already
+      allocating it, or because the device does not use interrupts),
+      pass -1 and 0 instead.
       </para>
     </section>

diff --git a/include/sound/mpu401.h b/include/sound/mpu401.h
index 1f1d53f..43e24b2 100644
--- a/include/sound/mpu401.h
+++ b/include/sound/mpu401.h
@@ -50,6 +50,7 @@
 #define MPU401_INFO_INTEGRATED	(1 << 2)	/* integrated h/w port */
 #define MPU401_INFO_MMIO	(1 << 3)	/* MMIO access */
 #define MPU401_INFO_TX_IRQ	(1 << 4)	/* independent TX irq */
+#define MPU401_INFO_RX_POLL	(1 << 5)	/* no RX interrupt; use timer */
 #define MPU401_INFO_NO_ACK	(1 << 6)	/* No ACK cmd needed */

 #define MPU401_MODE_BIT_INPUT		0
@@ -73,8 +74,7 @@ struct snd_mpu401 {
 	unsigned long port;		/* base port of MPU-401 chip */
 	unsigned long cport;		/* port + 1 (usually) */
 	struct resource *res;		/* port resource */
-	int irq;			/* IRQ number of MPU-401 chip (-1 = poll) */
+	int irq;			/* IRQ number of MPU-401 chip */
-	int irq_flags;

 	unsigned long mode;		/* MPU401_MODE_XXXX */
 	int timer_invoked;
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index 149d05a..4917ea1 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -85,9 +85,9 @@ static int snd_mpu401_create(int dev, struct snd_card **rcard)
 		strcat(card->longname, "polled");
 	}

-	err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401, port[dev], 0,
-				  irq[dev], irq[dev] >= 0 ? IRQF_DISABLED : 0,
-				  NULL);
+	err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401, port[dev],
+				  irq[dev] >= 0 ? 0 : MPU401_INFO_RX_POLL,
+				  irq[dev], IRQF_DISABLED, NULL);
 	if (err < 0) {
 		printk(KERN_ERR "MPU401 not detected at 0x%lx\n", port[dev]);
 		goto _err;
diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 2af0999..5642f8f 100644
--- a/sound/drivers/mpu401/mpu401_uart.c
+++ b/sound/drivers/mpu401/mpu401_uart.c
@@ -3,7 +3,7 @@
  *  Routines for control of MPU-401 in UART mode
  *
  *  MPU-401 supports UART mode which is not capable generate transmit
- *  interrupts thus output is done via polling. Also, if irq < 0, then
+ *  interrupts thus output is done via polling. Without interrupt,
  *  input is done also via polling. Do not expect good performance.
  *
  *
@@ -374,7 +374,7 @@ snd_mpu401_uart_input_trigger(struct snd_rawmidi_substream *substream, int up)
 			/* first time - flush FIFO */
 			while (max-- > 0)
 				mpu->read(mpu, MPU401D(mpu));
-			if (mpu->irq < 0)
+			if (mpu->info_flags & MPU401_INFO_RX_POLL)
 				snd_mpu401_uart_add_timer(mpu, 1);
 		}
 		
@@ -383,7 +383,7 @@ snd_mpu401_uart_input_trigger(struct snd_rawmidi_substream *substream, int up)
 		snd_mpu401_uart_input_read(mpu);
 		spin_unlock_irqrestore(&mpu->input_lock, flags);
 	} else {
-		if (mpu->irq < 0)
+		if (mpu->info_flags & MPU401_INFO_RX_POLL)
 			snd_mpu401_uart_remove_timer(mpu, 1);
 		clear_bit(MPU401_MODE_BIT_INPUT_TRIGGER, &mpu->mode);
 	}
@@ -496,7 +496,7 @@ static struct snd_rawmidi_ops snd_mpu401_uart_input =
 static void snd_mpu401_uart_free(struct snd_rawmidi *rmidi)
 {
 	struct snd_mpu401 *mpu = rmidi->private_data;
-	if (mpu->irq_flags && mpu->irq >= 0)
+	if (mpu->irq >= 0)
 		free_irq(mpu->irq, (void *) mpu);
 	release_and_free_resource(mpu->res);
 	kfree(mpu);
@@ -510,7 +510,7 @@ static void snd_mpu401_uart_free(struct snd_rawmidi *rmidi)
  * @port: the base address of MPU401 port
  * @info_flags: bitflags MPU401_INFO_XXX
  * @irq: the irq number, -1 if no interrupt for mpu
- * @irq_flags: the irq request flags (SA_XXX), 0 if irq was already reserved.
+ * @irq_flags: the irq request flags (IRQF_XXX)
  * @rrawmidi: the pointer to store the new rawmidi instance
  *
  * Creates a new MPU-401 instance.
@@ -577,7 +577,7 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 		mpu->cport = port + 2;
 	else
 		mpu->cport = port + 1;
-	if (irq >= 0 && irq_flags) {
+	if (irq >= 0) {
 		if (request_irq(irq, snd_mpu401_uart_interrupt, irq_flags,
 				"MPU401 UART", (void *) mpu)) {
 			snd_printk(KERN_ERR "mpu401_uart: "
@@ -588,7 +588,6 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 	}
 	mpu->info_flags = info_flags;
 	mpu->irq = irq;
-	mpu->irq_flags = irq_flags;
 	if (card->shortname[0])
 		snprintf(rmidi->name, sizeof(rmidi->name), "%s MIDI",
 			 card->shortname);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 3cb75bc..490d51f 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -203,9 +203,10 @@ static int __devinit snd_card_ad1816a_probe(int dev, struct pnp_card_link *pcard
 	}

 	if (mpu_port[dev] > 0) {
+		int mpu_flags = mpu_irq[dev] >= 0 ? 0 : MPU401_INFO_RX_POLL;
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-					mpu_port[dev], 0, mpu_irq[dev], IRQF_DISABLED,
-					NULL) < 0)
+					mpu_port[dev], mpu_flags,
+					mpu_irq[dev], IRQF_DISABLED, NULL) < 0)
 			printk(KERN_ERR PFX "no MPU-401 device at 0x%lx.\n", mpu_port[dev]);
 	}

diff --git a/sound/isa/als100.c b/sound/isa/als100.c
index 20becc8..3355609 100644
--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -245,18 +245,22 @@ static int __devinit snd_card_als100_probe(int dev,

 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
 		int mpu_type = MPU401_HW_ALS100;
+		int mpu_flags = 0;

-		if (mpu_irq[dev] == SNDRV_AUTO_IRQ)
+		if (mpu_irq[dev] == SNDRV_AUTO_IRQ) {
 			mpu_irq[dev] = -1;
+			mpu_flags = MPU401_INFO_RX_POLL;
+		}

 		if (pid->driver_data == SB_HW_DT019X)
 			mpu_type = MPU401_HW_MPU401;

 		if (snd_mpu401_uart_new(card, 0,
 					mpu_type,
-					mpu_port[dev], 0,
+					mpu_port[dev],
+					mpu_flags,
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0,
+					IRQF_DISABLED,
 					NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx\n", mpu_port[dev]);
 	}
diff --git a/sound/isa/azt2320.c b/sound/isa/azt2320.c
index aac8dc1..4dc2dc9 100644
--- a/sound/isa/azt2320.c
+++ b/sound/isa/azt2320.c
@@ -232,8 +232,9 @@ static int __devinit snd_card_azt2320_probe(int dev,
 	}

 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
+		int mpu_flags = mpu_irq[dev] >= 0 ? 0 : MPU401_INFO_RX_POLL;
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_AZT2320,
-				mpu_port[dev], 0,
+				mpu_port[dev], mpu_flags,
 				mpu_irq[dev], IRQF_DISABLED,
 				NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx\n", mpu_port[dev]);
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index fe79a16..7829aaa 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -595,8 +595,9 @@ static int __devinit snd_cmi8330_probe(struct snd_card *card, int dev)
 	}

 	if (mpuport[dev] != SNDRV_AUTO_PORT) {
+		int mpuflags = mpuirq[dev] >= 0 ? 0 : MPU401_INFO_RX_POLL;
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-					mpuport[dev], 0, mpuirq[dev],
+					mpuport[dev], mpuflags, mpuirq[dev],
 					IRQF_DISABLED, NULL) < 0)
 			printk(KERN_ERR PFX "no MPU-401 device at 0x%lx.\n",
 				mpuport[dev]);
diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
index cb9153e..6ae72ea 100644
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -127,11 +127,14 @@ static int __devinit snd_cs4231_probe(struct device *dev, unsigned int n)
 		goto out;

 	if (mpu_port[n] > 0 && mpu_port[n] != SNDRV_AUTO_PORT) {
+		int mpu_flags = 0;
-		if (mpu_irq[n] == SNDRV_AUTO_IRQ)
+		if (mpu_irq[n] == SNDRV_AUTO_IRQ) {
 			mpu_irq[n] = -1;
+			mpu_flags = MPU401_INFO_RX_POLL;
+		}
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_CS4232,
-					mpu_port[n], 0, mpu_irq[n],
-					mpu_irq[n] >= 0 ? IRQF_DISABLED : 0,
+					mpu_port[n], mpu_flags, mpu_irq[n],
+					IRQF_DISABLED,
 					NULL) < 0)
 			dev_warn(dev, "MPU401 not detected\n");
 	}
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 999dc1e..71994df 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -445,12 +445,15 @@ static int __devinit snd_cs423x_probe(struct snd_card *card, int dev)
 	}

 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
+		int mpu_flags = 0;
-		if (mpu_irq[dev] == SNDRV_AUTO_IRQ)
+		if (mpu_irq[dev] == SNDRV_AUTO_IRQ) {
 			mpu_irq[dev] = -1;
+			mpu_flags = MPU401_INFO_RX_POLL;
+		}
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_CS4232,
-					mpu_port[dev], 0,
+					mpu_port[dev], mpu_flags,
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0, NULL) < 0)
+					IRQF_DISABLED, NULL) < 0)
 			printk(KERN_WARNING IDENT ": MPU401 not detected\n");
 	}

diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index fb4d6b3..106760f 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -2161,7 +2161,7 @@ static int __devinit snd_audiodrive_probe(struct snd_card *card, int dev)
 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_ES18XX,
 					  mpu_port[dev], 0,
-					  irq[dev], 0, &chip->rmidi);
+					  -1, 0, &chip->rmidi);
 		if (err < 0)
 			return err;
 	}
diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
index ee54df0..645deff 100644
--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -584,8 +584,9 @@ static int __devinit snd_galaxy_probe(struct device *dev, unsigned int n)
 		goto error;

 	if (mpu_port[n] >= 0) {
+		int mpu_flags = mpu_irq[n] >= 0 ? 0 : MPU401_INFO_RX_POLL;
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-					  mpu_port[n], 0, mpu_irq[n],
+					  mpu_port[n], mpu_flags, mpu_irq[n],
 					  IRQF_DISABLED, NULL);
 		if (err < 0)
 			goto error;
diff --git a/sound/isa/gus/gusextreme.c b/sound/isa/gus/gusextreme.c
index 008e8e5..872b659 100644
--- a/sound/isa/gus/gusextreme.c
+++ b/sound/isa/gus/gusextreme.c
@@ -316,8 +316,9 @@ static int __devinit snd_gusextreme_probe(struct device *dev, unsigned int n)
 	}

 	if (es1688->mpu_port >= 0x300) {
+		int mpu_flags = mpu_irq[n] >= 0 ? 0 : MPU401_INFO_RX_POLL;
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_ES1688,
-				es1688->mpu_port, 0,
+				es1688->mpu_port, mpu_flags,
 				mpu_irq[n], IRQF_DISABLED, NULL);
 		if (error < 0)
 			goto out;
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 9b915e2..38dc53b 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -708,7 +708,7 @@ static int __devinit snd_opl3sa2_probe(struct snd_card *card, int dev)
 	if (midi_port[dev] >= 0x300 && midi_port[dev] < 0x340) {
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_OPL3SA2,
 					       midi_port[dev], 0,
-					       xirq, 0, &chip->rmidi)) < 0)
+					       -1, 0, &chip->rmidi)) < 0)
 			return err;
 	}
 	sprintf(card->longname, "%s at 0x%lx, irq %d, dma %d",
diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
index 8ccbcdd..49ee7db 100644
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -315,14 +315,18 @@ static int __devinit snd_jazz16_probe(struct device *devptr, unsigned int dev)
 			goto err_free;
 	}
 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
+		int mpu_flags = 0;
+
-		if (mpu_irq[dev] == SNDRV_AUTO_IRQ)
+		if (mpu_irq[dev] == SNDRV_AUTO_IRQ) {
 			mpu_irq[dev] = -1;
+			mpu_flags = MPU401_INFO_RX_POLL;
+		}

 		if (snd_mpu401_uart_new(card, 0,
 					MPU401_HW_MPU401,
-					mpu_port[dev], 0,
+					mpu_port[dev], mpu_flags,
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0,
+					IRQF_DISABLED,
 					NULL) < 0)
 			snd_printk(KERN_ERR "no MPU-401 device at 0x%lx\n",
 					mpu_port[dev]);
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 4d1c5a3..8d751ba 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -395,7 +395,7 @@ static int __devinit snd_sb16_probe(struct snd_card *card, int dev)
 	if (chip->mpu_port > 0 && chip->mpu_port != SNDRV_AUTO_PORT) {
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_SB,
 					       chip->mpu_port, 0,
-					       xirq, 0, &chip->rmidi)) < 0)
+					       -1, 0, &chip->rmidi)) < 0)
 			return err;
 		chip->rmidi_callback = snd_mpu401_uart_interrupt;
 	}
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 9a8bbf6..6f778cf 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -653,11 +653,14 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
 	}

 	if (mpu_port[dev] != SNDRV_AUTO_PORT) {
+		int mpu_flags = 0;
-		if (mpu_irq[dev] == SNDRV_AUTO_IRQ)
+		if (mpu_irq[dev] == SNDRV_AUTO_IRQ) {
 			mpu_irq[dev] = -1;
+			mpu_flags = MPU401_INFO_RX_POLL;
+		}
 		if (snd_mpu401_uart_new(card, 0,
 					MPU401_HW_MPU401,
-					mpu_port[dev], 0,
+					mpu_port[dev], mpu_flags,
 					mpu_irq[dev], IRQF_DISABLED,
 					NULL) < 0)
 			snd_printk(KERN_ERR "no MPU-401 device at 0x%lx ?\n",
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index 711670e..dc2548f 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -447,8 +447,11 @@ snd_wavefront_probe (struct snd_card *card, int dev)
 	/* -------- CS4232 MPU-401 interface -------- */

 	if (cs4232_mpu_port[dev] > 0 && cs4232_mpu_port[dev] != SNDRV_AUTO_PORT) {
+		int mpu_flags = 0;
+		if (cs4232_mpu_irq[dev] < 0)
+			mpu_flags = MPU401_INFO_RX_POLL;
 		err = snd_mpu401_uart_new(card, midi_dev, MPU401_HW_CS4232,
-					  cs4232_mpu_port[dev], 0,
+					  cs4232_mpu_port[dev], mpu_flags,
 					  cs4232_mpu_irq[dev], IRQF_DISABLED,
 					  NULL);
 		if (err < 0) {
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index a9c1af3..8f65858 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -932,7 +932,7 @@ static int __devinit snd_card_als4000_probe(struct pci_dev *pci,
 	if ((err = snd_mpu401_uart_new( card, 0, MPU401_HW_ALS4000,
 					iobase + ALS4K_IOB_30_MIDI_DATA,
 					MPU401_INFO_INTEGRATED,
-					pci->irq, 0, &chip->rmidi)) < 0) {
+					-1, 0, &chip->rmidi)) < 0) {
 		printk(KERN_ERR "als4000: no MPU-401 device at 0x%lx?\n",
 				iobase + ALS4K_IOB_30_MIDI_DATA);
 		goto out_err;
diff --git a/sound/pci/au88x0/au88x0_mpu401.c b/sound/pci/au88x0/au88x0_mpu401.c
index 0dc8d25..344d329 100644
--- a/sound/pci/au88x0/au88x0_mpu401.c
+++ b/sound/pci/au88x0/au88x0_mpu401.c
@@ -84,7 +84,7 @@ static int __devinit snd_vortex_midi(vortex_t * vortex)
 #ifdef VORTEX_MPU401_LEGACY
 	if ((temp =
 	     snd_mpu401_uart_new(vortex->card, 0, MPU401_HW_MPU401, 0x330,
-				 0, 0, 0, &rmidi)) != 0) {
+				 0, -1, 0, &rmidi)) != 0) {
 		hwwrite(vortex->mmio, VORTEX_CTRL,
 			(hwread(vortex->mmio, VORTEX_CTRL) &
 			 ~CTRL_MIDI_PORT) & ~CTRL_MIDI_EN);
@@ -95,7 +95,7 @@ static int __devinit snd_vortex_midi(vortex_t * vortex)
 	if ((temp =
 	     snd_mpu401_uart_new(vortex->card, 0, MPU401_HW_AUREAL, port,
 				 MPU401_INFO_INTEGRATED | MPU401_INFO_MMIO,
-				 0, 0, &rmidi)) != 0) {
+				 -1, 0, &rmidi)) != 0) {
 		hwwrite(vortex->mmio, VORTEX_CTRL,
 			(hwread(vortex->mmio, VORTEX_CTRL) &
 			 ~CTRL_MIDI_PORT) & ~CTRL_MIDI_EN);
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 579fc0d..9c5461a 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2653,7 +2653,7 @@ snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	err = snd_mpu401_uart_new(
 		card, 0,
 		MPU401_HW_AZT2320, chip->mpu_io, MPU401_INFO_INTEGRATED,
-		pci->irq, 0, &chip->rmidi
+		-1, 0, &chip->rmidi
 	);
 	if (err < 0) {
 		snd_printk(KERN_ERR "azf3328: no MPU-401 device at 0x%lx?\n",
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 9cf99fb..5e89278 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3229,7 +3229,7 @@ static int __devinit snd_cmipci_create(struct snd_card *card, struct pci_dev *pc
 					       iomidi,
 					       (integrated_midi ?
 						MPU401_INFO_INTEGRATED : 0),
-					       cm->irq, 0, &cm->rmidi)) < 0) {
+					       -1, 0, &cm->rmidi)) < 0) {
 			printk(KERN_ERR "cmipci: no UART401 device at 0x%lx\n", iomidi);
 		}
 	}
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 26a5a2f..09d3af6 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1855,7 +1855,7 @@ static int __devinit snd_es1938_probe(struct pci_dev *pci,
 	}
 	if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
 				chip->mpu_port, MPU401_INFO_INTEGRATED,
-				chip->irq, 0, &chip->rmidi) < 0) {
+				-1, 0, &chip->rmidi) < 0) {
 		printk(KERN_ERR "es1938: unable to initialize MPU-401\n");
 	} else {
 		// this line is vital for MIDI interrupt handling on ess-solo1
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 99ea932..16d897b 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2844,7 +2844,7 @@ static int __devinit snd_es1968_probe(struct pci_dev *pci,
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
 					       chip->io_port + ESM_MPU401_PORT,
 					       MPU401_INFO_INTEGRATED,
-					       chip->irq, 0, &chip->rmidi)) < 0) {
+					       -1, 0, &chip->rmidi)) < 0) {
 			printk(KERN_WARNING "es1968: skipping MPU-401 MIDI support..\n");
 		}
 	}
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index f9123f0..746568e 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1307,7 +1307,7 @@ static int __devinit snd_card_fm801_probe(struct pci_dev *pci,
 	if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_FM801,
 				       FM801_REG(chip, MPU401_DATA),
 				       MPU401_INFO_INTEGRATED,
-				       chip->irq, 0, &chip->rmidi)) < 0) {
+				       -1, 0, &chip->rmidi)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 0ccc0eb..051fc08 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2749,7 +2749,7 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_ICE1712,
 			ICEREG(ice, MPU1_CTRL),
 			(c->mpu401_1_info_flags | MPU401_INFO_INTEGRATED),
-			ice->irq, 0, &ice->rmidi[0]);
+			-1, 0, &ice->rmidi[0]);
 		if (err < 0) {
 			snd_card_free(card);
 			return err;
@@ -2765,7 +2765,7 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 			err = snd_mpu401_uart_new(card, 1, MPU401_HW_ICE1712,
 				ICEREG(ice, MPU2_CTRL),
 				(c->mpu401_2_info_flags | MPU401_INFO_INTEGRATED),
-				ice->irq, 0, &ice->rmidi[1]);
+				-1, 0, &ice->rmidi[1]);

 			if (err < 0) {
 				snd_card_free(card);
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 0378126..9c8dd1d 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2821,7 +2821,7 @@ snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	err = snd_mpu401_uart_new(chip->card, 0, MPU401_HW_MPU401,
 				  chip->iobase + MPU401_DATA_PORT,
 				  MPU401_INFO_INTEGRATED,
-				  chip->irq, 0, &chip->rmidi);
+				  -1, 0, &chip->rmidi);
 	if (err < 0)
 		printk(KERN_WARNING "maestro3: no MIDI support.\n");
 #endif
diff --git a/sound/pci/oxygen/oxygen_lib.c b/sound/pci/oxygen/oxygen_lib.c
index 82311fc..4882c62 100644
--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -685,7 +685,7 @@ int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
 			info_flags |= MPU401_INFO_INPUT;
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_CMIPCI,
 					  chip->addr + OXYGEN_MPU401,
-					  info_flags, 0, 0,
+					  info_flags, -1, 0,
 					  &chip->midi);
 		if (err < 0)
 			goto err_card;
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index e34ae14..1af64a1 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -2109,7 +2109,7 @@ snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 		val = mpu_port[dev];
 		pci_write_config_word(chip->pci, PCI_EXT_MPU_Base, val);
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_RIPTIDE,
-					  val, 0, chip->irq, 0,
+					  val, 0, -1, 0,
 					  &chip->rmidi);
 		if (err < 0)
 			snd_printk(KERN_WARNING
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 2571a67..3da90cd 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1494,7 +1494,7 @@ static int __devinit snd_sonic_probe(struct pci_dev *pci,
 	}
 	if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_SONICVIBES,
 				       sonic->midi_port, MPU401_INFO_INTEGRATED,
-				       sonic->irq, 0,
+				       -1, 0,
 				       &midi_uart)) < 0) {
 		snd_card_free(card);
 		return err;
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
index d8a128f..8ea70b9 100644
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -149,7 +149,7 @@ static int __devinit snd_trident_probe(struct pci_dev *pci,
 	    (err = snd_mpu401_uart_new(card, 0, MPU401_HW_TRID4DWAVE,
 				       trident->midi_port,
 				       MPU401_INFO_INTEGRATED,
-				       trident->irq, 0, &trident->rmidi)) < 0) {
+				       -1, 0, &trident->rmidi)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index f03fd62..7575ff8 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2069,7 +2069,7 @@ static int __devinit snd_via686_init_misc(struct via82xx *chip)
 	if (chip->mpu_res) {
 		if (snd_mpu401_uart_new(chip->card, 0, MPU401_HW_VIA686A,
 					mpu_port, MPU401_INFO_INTEGRATED,
-					chip->irq, 0, &chip->rmidi) < 0) {
+					-1, 0, &chip->rmidi) < 0) {
 			printk(KERN_WARNING "unable to initialize MPU-401"
 			       " at 0x%lx, skipping\n", mpu_port);
 			legacy &= ~VIA_FUNC_ENABLE_MIDI;
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 511d576..ad974fd 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -306,7 +306,7 @@ static int __devinit snd_card_ymfpci_probe(struct pci_dev *pci,
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_YMFPCI,
 					       mpu_port[dev],
 					       MPU401_INFO_INTEGRATED,
-					       pci->irq, 0, &chip->rawmidi)) < 0) {
+					       -1, 0, &chip->rawmidi)) < 0) {
 			printk(KERN_WARNING "ymfpci: cannot initialize MPU401 at 0x%lx, skipping...\n", mpu_port[dev]);
 			legacy_ctrl &= ~YMFPCI_LEGACY_MIEN; /* disable MPU401 irq */
 			pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
