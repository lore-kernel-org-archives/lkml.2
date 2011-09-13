Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389Ab1IMJY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:24:28 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59884 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750777Ab1IMJYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:24:25 -0400
X-Sasl-enc: LVQma0WaJmMj26YJHeCrLKXJEPFp6EdLKMPPP2zN8/nZ 1315905863
Message-ID: <4E6F2159.6060606@ladisch.de>
Date: Tue, 13 Sep 2011 11:24:41 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        Jaroslav Kysela <perex@perex.cz>, alsa-devel@alsa-project.org
Subject: Re: [RFC] [PATCH 02/62] mpu401:snd_mpu401_uart_new(): split semantic
 of irq_flags
References: <1315383059-3673-1-git-send-email-yong.zhang0@gmail.com>	<1315383059-3673-3-git-send-email-yong.zhang0@gmail.com>	<4E689E9A.8000407@ladisch.de>	<20110908133700.GB2310@zhy>	<4E68CA15.8000504@ladisch.de>	<20110908144519.GB3069@zhy>	<4E69253F.3090705@ladisch.de>	<20110909013143.GB18249@zhy>	<4E6CCF6C.2020301@ladisch.de>	<s5hvcsy6nr2.wl%tiwai@suse.de>	<4E6E061E.2010000@ladisch.de>	<4E6E6A34.8060104@ladisch.de> <s5hvcswvrty.wl%tiwai@suse.de> <4E6F1194.80106@ladisch.de>
In-Reply-To: <4E6F1194.80106@ladisch.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clemens Ladisch wrote:
> Takashi Iwai wrote:
> > However, if we are going to remove IRQF_DISABLED in near future, and
> > all the callers use IRQF_DISABLED when requesting an irq, why not
> > remove this argument now?  Then the IRQF_DISABLED-removal patch will
> > touch less code.
> 
> I wanted to change only the minimum amount of code needed to make the
> IRQF_DISABLED-removal patch possible, and wait with further cleanups of
> snd_mpu401_uart_new() until after that patch to avoid conflicts.
> 
> However, moving the IRQF_DISABLED into snd_mpu401_uart_new() avoids
> those conflicts, so it's clearly better.

completely untested:

--8<---------------------------------------------------------------->8--
ALSA: mpu401: clean up interrupt specification

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

This patch introduces a new flag MPU401_INFO_IRQ_HOOK for when the
device interrupt is handled by the caller, and makes the allocation of
the interrupt to depend only on the irq parameter.  As suggested by
Takashi, the irq_flags parameter was dropped because, when used, it had
the constant value IRQF_DISABLED.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 Documentation/DocBook/writing-an-alsa-driver.tmpl |   36 +++++++++++---------
 include/sound/mpu401.h                            |    7 ++-
 sound/drivers/mpu401/mpu401.c                     |    3 -
 sound/drivers/mpu401/mpu401_uart.c                |   20 +++++------
 sound/isa/ad1816a/ad1816a.c                       |    2 -
 sound/isa/als100.c                                |    1 
 sound/isa/azt2320.c                               |    3 -
 sound/isa/cmi8330.c                               |    2 -
 sound/isa/cs423x/cs4231.c                         |    1 
 sound/isa/cs423x/cs4236.c                         |    3 -
 sound/isa/es1688/es1688.c                         |    2 -
 sound/isa/es18xx.c                                |    4 +-
 sound/isa/galaxy/galaxy.c                         |    3 -
 sound/isa/gus/gusextreme.c                        |    3 -
 sound/isa/msnd/msnd_pinnacle.c                    |    2 -
 sound/isa/opl3sa2.c                               |    5 +-
 sound/isa/opti9xx/miro.c                          |    3 -
 sound/isa/opti9xx/opti92x-ad1848.c                |    2 -
 sound/isa/sb/jazz16.c                             |    1 
 sound/isa/sb/sb16.c                               |    5 +-
 sound/isa/sc6000.c                                |    3 -
 sound/isa/sscape.c                                |    3 -
 sound/isa/wavefront/wavefront.c                   |    3 -
 sound/pci/als4000.c                               |    5 +-
 sound/pci/au88x0/au88x0_mpu401.c                  |    6 +--
 sound/pci/azt3328.c                               |    5 +-
 sound/pci/cmipci.c                                |    5 +-
 sound/pci/es1938.c                                |    5 +-
 sound/pci/es1968.c                                |    5 +-
 sound/pci/fm801.c                                 |    5 +-
 sound/pci/ice1712/ice1712.c                       |   10 +++--
 sound/pci/maestro3.c                              |    4 +-
 sound/pci/oxygen/oxygen_lib.c                     |    6 +--
 sound/pci/riptide/riptide.c                       |    2 -
 sound/pci/sonicvibes.c                            |    7 ++-
 sound/pci/trident/trident.c                       |    5 +-
 sound/pci/via82xx.c                               |    5 +-
 sound/pci/ymfpci/ymfpci.c                         |    5 +-
 38 files changed, 103 insertions(+), 94 deletions(-)

diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index 598c22f..5de23c0 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -4288,7 +4288,7 @@ struct _snd_pcm_runtime {
 <![CDATA[
   struct snd_rawmidi *rmidi;
   snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401, port, info_flags,
-                      irq, irq_flags, &rmidi);
+                      irq, &rmidi);
 ]]>
           </programlisting>
         </informalexample>
@@ -4343,6 +4343,13 @@ struct _snd_pcm_runtime {
 	by itself to start processing the output stream in the irq handler.
 	</para>
 
+	<para>
+	If the MPU-401 interface shares its interrupt with the other logical
+	devices on the card, set <constant>MPU401_INFO_IRQ_HOOK</constant>
+	(see <link linkend="midi-interface-interrupt-handler"><citetitle>
+	below</citetitle></link>).
+	</para>
+
       <para>
         Usually, the port address corresponds to the command port and
         port + 1 corresponds to the data port. If not, you may change
@@ -4375,14 +4382,12 @@ struct _snd_pcm_runtime {
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
+	The 6th argument specifies the ISA irq number that will be
+	allocated.  If no interrupt is to be allocated (because your
+	code is already allocating a shared interrupt, or because the
+	device does not use interrupts), pass -1 instead.
+	For a MPU-401 device without an interrupt, a polling timer
+	will be used instead.
       </para>
     </section>
 
@@ -4390,12 +4395,13 @@ struct _snd_pcm_runtime {
       <title>Interrupt Handler</title>
       <para>
         When the interrupt is allocated in
-      <function>snd_mpu401_uart_new()</function>, the private
-      interrupt handler is used, hence you don't have anything else to do
-      than creating the mpu401 stuff. Otherwise, you have to call
-      <function>snd_mpu401_uart_interrupt()</function> explicitly when
-      a UART interrupt is invoked and checked in your own interrupt
-      handler.  
+      <function>snd_mpu401_uart_new()</function>, an exclusive ISA
+      interrupt handler is automatically used, hence you don't have
+      anything else to do than creating the mpu401 stuff.  Otherwise, you
+      have to set <constant>MPU401_INFO_IRQ_HOOK</constant>, and call
+      <function>snd_mpu401_uart_interrupt()</function> explicitly from your
+      own interrupt handler when it has determined that a UART interrupt
+      has occurred.
       </para>
 
       <para>
diff --git a/include/sound/mpu401.h b/include/sound/mpu401.h
index 1f1d53f..20230db 100644
--- a/include/sound/mpu401.h
+++ b/include/sound/mpu401.h
@@ -50,7 +50,10 @@
 #define MPU401_INFO_INTEGRATED	(1 << 2)	/* integrated h/w port */
 #define MPU401_INFO_MMIO	(1 << 3)	/* MMIO access */
 #define MPU401_INFO_TX_IRQ	(1 << 4)	/* independent TX irq */
+#define MPU401_INFO_IRQ_HOOK	(1 << 5)	/* mpu401 irq handler is called
+						   from driver irq handler */
 #define MPU401_INFO_NO_ACK	(1 << 6)	/* No ACK cmd needed */
+#define MPU401_INFO_USE_TIMER	(1 << 15)	/* internal */
 
 #define MPU401_MODE_BIT_INPUT		0
 #define MPU401_MODE_BIT_OUTPUT		1
@@ -73,8 +76,7 @@ struct snd_mpu401 {
 	unsigned long port;		/* base port of MPU-401 chip */
 	unsigned long cport;		/* port + 1 (usually) */
 	struct resource *res;		/* port resource */
-	int irq;			/* IRQ number of MPU-401 chip (-1 = poll) */
-	int irq_flags;
+	int irq;			/* IRQ number of MPU-401 chip */
 
 	unsigned long mode;		/* MPU401_MODE_XXXX */
 	int timer_invoked;
@@ -131,7 +133,6 @@ int snd_mpu401_uart_new(struct snd_card *card,
 			unsigned long port,
 			unsigned int info_flags,
 			int irq,
-			int irq_flags,
 			struct snd_rawmidi ** rrawmidi);
 
 #endif /* __SOUND_MPU401_H */
diff --git a/sound/drivers/mpu401/mpu401.c b/sound/drivers/mpu401/mpu401.c
index 149d05a..1c02852 100644
--- a/sound/drivers/mpu401/mpu401.c
+++ b/sound/drivers/mpu401/mpu401.c
@@ -86,8 +86,7 @@ static int snd_mpu401_create(int dev, struct snd_card **rcard)
 	}
 
 	err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401, port[dev], 0,
-				  irq[dev], irq[dev] >= 0 ? IRQF_DISABLED : 0,
-				  NULL);
+				  irq[dev], NULL);
 	if (err < 0) {
 		printk(KERN_ERR "MPU401 not detected at 0x%lx\n", port[dev]);
 		goto _err;
diff --git a/sound/drivers/mpu401/mpu401_uart.c b/sound/drivers/mpu401/mpu401_uart.c
index 2af0999..9d01c18 100644
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
+			if (mpu->info_flags & MPU401_INFO_USE_TIMER)
 				snd_mpu401_uart_add_timer(mpu, 1);
 		}
 		
@@ -383,7 +383,7 @@ snd_mpu401_uart_input_trigger(struct snd_rawmidi_substream *substream, int up)
 		snd_mpu401_uart_input_read(mpu);
 		spin_unlock_irqrestore(&mpu->input_lock, flags);
 	} else {
-		if (mpu->irq < 0)
+		if (mpu->info_flags & MPU401_INFO_USE_TIMER)
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
@@ -509,8 +509,7 @@ static void snd_mpu401_uart_free(struct snd_rawmidi *rmidi)
  * @hardware: the hardware type, MPU401_HW_XXXX
  * @port: the base address of MPU401 port
  * @info_flags: bitflags MPU401_INFO_XXX
- * @irq: the irq number, -1 if no interrupt for mpu
- * @irq_flags: the irq request flags (SA_XXX), 0 if irq was already reserved.
+ * @irq: the ISA irq number, -1 if not to be allocated
  * @rrawmidi: the pointer to store the new rawmidi instance
  *
  * Creates a new MPU-401 instance.
@@ -525,7 +524,7 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 			unsigned short hardware,
 			unsigned long port,
 			unsigned int info_flags,
-			int irq, int irq_flags,
+			int irq,
 			struct snd_rawmidi ** rrawmidi)
 {
 	struct snd_mpu401 *mpu;
@@ -577,8 +576,8 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 		mpu->cport = port + 2;
 	else
 		mpu->cport = port + 1;
-	if (irq >= 0 && irq_flags) {
-		if (request_irq(irq, snd_mpu401_uart_interrupt, irq_flags,
+	if (irq >= 0) {
+		if (request_irq(irq, snd_mpu401_uart_interrupt, IRQF_DISABLED,
 				"MPU401 UART", (void *) mpu)) {
 			snd_printk(KERN_ERR "mpu401_uart: "
 				   "unable to grab IRQ %d\n", irq);
@@ -586,9 +585,10 @@ int snd_mpu401_uart_new(struct snd_card *card, int device,
 			return -EBUSY;
 		}
 	}
+	if (irq < 0 && !(info_flags & MPU401_INFO_IRQ_HOOK))
+		info_flags |= MPU401_INFO_USE_TIMER;
 	mpu->info_flags = info_flags;
 	mpu->irq = irq;
-	mpu->irq_flags = irq_flags;
 	if (card->shortname[0])
 		snprintf(rmidi->name, sizeof(rmidi->name), "%s MIDI",
 			 card->shortname);
diff --git a/sound/isa/ad1816a/ad1816a.c b/sound/isa/ad1816a/ad1816a.c
index 3cb75bc..a87a2b5 100644
--- a/sound/isa/ad1816a/ad1816a.c
+++ b/sound/isa/ad1816a/ad1816a.c
@@ -204,7 +204,7 @@ static int __devinit snd_card_ad1816a_probe(int dev, struct pnp_card_link *pcard
 
 	if (mpu_port[dev] > 0) {
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-					mpu_port[dev], 0, mpu_irq[dev], IRQF_DISABLED,
+					mpu_port[dev], 0, mpu_irq[dev],
 					NULL) < 0)
 			printk(KERN_ERR PFX "no MPU-401 device at 0x%lx.\n", mpu_port[dev]);
 	}
diff --git a/sound/isa/als100.c b/sound/isa/als100.c
index 20becc8..706effd 100644
--- a/sound/isa/als100.c
+++ b/sound/isa/als100.c
@@ -256,7 +256,6 @@ static int __devinit snd_card_als100_probe(int dev,
 					mpu_type,
 					mpu_port[dev], 0, 
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0,
 					NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx\n", mpu_port[dev]);
 	}
diff --git a/sound/isa/azt2320.c b/sound/isa/azt2320.c
index aac8dc1..b7bdbf3 100644
--- a/sound/isa/azt2320.c
+++ b/sound/isa/azt2320.c
@@ -234,8 +234,7 @@ static int __devinit snd_card_azt2320_probe(int dev,
 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_AZT2320,
 				mpu_port[dev], 0,
-				mpu_irq[dev], IRQF_DISABLED,
-				NULL) < 0)
+				mpu_irq[dev], NULL) < 0)
 			snd_printk(KERN_ERR PFX "no MPU-401 device at 0x%lx\n", mpu_port[dev]);
 	}
 
diff --git a/sound/isa/cmi8330.c b/sound/isa/cmi8330.c
index fe79a16..dca69f8 100644
--- a/sound/isa/cmi8330.c
+++ b/sound/isa/cmi8330.c
@@ -597,7 +597,7 @@ static int __devinit snd_cmi8330_probe(struct snd_card *card, int dev)
 	if (mpuport[dev] != SNDRV_AUTO_PORT) {
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
 					mpuport[dev], 0, mpuirq[dev],
-					IRQF_DISABLED, NULL) < 0)
+					NULL) < 0)
 			printk(KERN_ERR PFX "no MPU-401 device at 0x%lx.\n",
 				mpuport[dev]);
 	}
diff --git a/sound/isa/cs423x/cs4231.c b/sound/isa/cs423x/cs4231.c
index cb9153e..409fa0a 100644
--- a/sound/isa/cs423x/cs4231.c
+++ b/sound/isa/cs423x/cs4231.c
@@ -131,7 +131,6 @@ static int __devinit snd_cs4231_probe(struct device *dev, unsigned int n)
 			mpu_irq[n] = -1;
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_CS4232,
 					mpu_port[n], 0, mpu_irq[n],
-					mpu_irq[n] >= 0 ? IRQF_DISABLED : 0,
 					NULL) < 0)
 			dev_warn(dev, "MPU401 not detected\n");
 	}
diff --git a/sound/isa/cs423x/cs4236.c b/sound/isa/cs423x/cs4236.c
index 999dc1e..0dbde46 100644
--- a/sound/isa/cs423x/cs4236.c
+++ b/sound/isa/cs423x/cs4236.c
@@ -449,8 +449,7 @@ static int __devinit snd_cs423x_probe(struct snd_card *card, int dev)
 			mpu_irq[dev] = -1;
 		if (snd_mpu401_uart_new(card, 0, MPU401_HW_CS4232,
 					mpu_port[dev], 0,
-					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0, NULL) < 0)
+					mpu_irq[dev], NULL) < 0)
 			printk(KERN_WARNING IDENT ": MPU401 not detected\n");
 	}
 
diff --git a/sound/isa/es1688/es1688.c b/sound/isa/es1688/es1688.c
index 0cde813..5493e9e 100644
--- a/sound/isa/es1688/es1688.c
+++ b/sound/isa/es1688/es1688.c
@@ -174,7 +174,7 @@ static int __devinit snd_es1688_probe(struct snd_card *card, unsigned int n)
 			chip->mpu_port > 0) {
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_ES1688,
 				chip->mpu_port, 0,
-				mpu_irq[n], IRQF_DISABLED, NULL);
+				mpu_irq[n], NULL);
 		if (error < 0)
 			return error;
 	}
diff --git a/sound/isa/es18xx.c b/sound/isa/es18xx.c
index fb4d6b3..aeee8f8 100644
--- a/sound/isa/es18xx.c
+++ b/sound/isa/es18xx.c
@@ -2160,8 +2160,8 @@ static int __devinit snd_audiodrive_probe(struct snd_card *card, int dev)
 
 	if (mpu_port[dev] > 0 && mpu_port[dev] != SNDRV_AUTO_PORT) {
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_ES18XX,
-					  mpu_port[dev], 0,
-					  irq[dev], 0, &chip->rmidi);
+					  mpu_port[dev], MPU401_INFO_IRQ_HOOK,
+					  -1, &chip->rmidi);
 		if (err < 0)
 			return err;
 	}
diff --git a/sound/isa/galaxy/galaxy.c b/sound/isa/galaxy/galaxy.c
index ee54df0..e51d324 100644
--- a/sound/isa/galaxy/galaxy.c
+++ b/sound/isa/galaxy/galaxy.c
@@ -585,8 +585,7 @@ static int __devinit snd_galaxy_probe(struct device *dev, unsigned int n)
 
 	if (mpu_port[n] >= 0) {
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-					  mpu_port[n], 0, mpu_irq[n],
-					  IRQF_DISABLED, NULL);
+					  mpu_port[n], 0, mpu_irq[n], NULL);
 		if (err < 0)
 			goto error;
 	}
diff --git a/sound/isa/gus/gusextreme.c b/sound/isa/gus/gusextreme.c
index 008e8e5..c4733c0 100644
--- a/sound/isa/gus/gusextreme.c
+++ b/sound/isa/gus/gusextreme.c
@@ -317,8 +317,7 @@ static int __devinit snd_gusextreme_probe(struct device *dev, unsigned int n)
 
 	if (es1688->mpu_port >= 0x300) {
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_ES1688,
-				es1688->mpu_port, 0,
-				mpu_irq[n], IRQF_DISABLED, NULL);
+				es1688->mpu_port, 0, mpu_irq[n], NULL);
 		if (error < 0)
 			goto out;
 	}
diff --git a/sound/isa/msnd/msnd_pinnacle.c b/sound/isa/msnd/msnd_pinnacle.c
index 91d6023..0961e2c 100644
--- a/sound/isa/msnd/msnd_pinnacle.c
+++ b/sound/isa/msnd/msnd_pinnacle.c
@@ -600,7 +600,7 @@ static int __devinit snd_msnd_attach(struct snd_card *card)
 					  mpu_io[0],
 					  MPU401_MODE_INPUT |
 					  MPU401_MODE_OUTPUT,
-					  mpu_irq[0], IRQF_DISABLED,
+					  mpu_irq[0],
 					  &chip->rmidi);
 		if (err < 0) {
 			printk(KERN_ERR LOGNAME
diff --git a/sound/isa/opl3sa2.c b/sound/isa/opl3sa2.c
index 9b915e2..de99f47 100644
--- a/sound/isa/opl3sa2.c
+++ b/sound/isa/opl3sa2.c
@@ -707,8 +707,9 @@ static int __devinit snd_opl3sa2_probe(struct snd_card *card, int dev)
 	}
 	if (midi_port[dev] >= 0x300 && midi_port[dev] < 0x340) {
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_OPL3SA2,
-					       midi_port[dev], 0,
-					       xirq, 0, &chip->rmidi)) < 0)
+					       midi_port[dev],
+					       MPU401_INFO_IRQ_HOOK, -1,
+					       &chip->rmidi)) < 0)
 			return err;
 	}
 	sprintf(card->longname, "%s at 0x%lx, irq %d, dma %d",
diff --git a/sound/isa/opti9xx/miro.c b/sound/isa/opti9xx/miro.c
index 8c24102..d94d0f3 100644
--- a/sound/isa/opti9xx/miro.c
+++ b/sound/isa/opti9xx/miro.c
@@ -1377,8 +1377,7 @@ static int __devinit snd_miro_probe(struct snd_card *card)
 		rmidi = NULL;
 	else {
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-				mpu_port, 0, miro->mpu_irq, IRQF_DISABLED,
-				&rmidi);
+				mpu_port, 0, miro->mpu_irq, &rmidi);
 		if (error < 0)
 			snd_printk(KERN_WARNING "no MPU-401 device at 0x%lx?\n",
 				   mpu_port);
diff --git a/sound/isa/opti9xx/opti92x-ad1848.c b/sound/isa/opti9xx/opti92x-ad1848.c
index c35dc68..346e12b 100644
--- a/sound/isa/opti9xx/opti92x-ad1848.c
+++ b/sound/isa/opti9xx/opti92x-ad1848.c
@@ -914,7 +914,7 @@ static int __devinit snd_opti9xx_probe(struct snd_card *card)
 		rmidi = NULL;
 	else {
 		error = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-				mpu_port, 0, mpu_irq, IRQF_DISABLED, &rmidi);
+				mpu_port, 0, mpu_irq, &rmidi);
 		if (error)
 			snd_printk(KERN_WARNING "no MPU-401 device at 0x%lx?\n",
 				   mpu_port);
diff --git a/sound/isa/sb/jazz16.c b/sound/isa/sb/jazz16.c
index 8ccbcdd..54e3c2c 100644
--- a/sound/isa/sb/jazz16.c
+++ b/sound/isa/sb/jazz16.c
@@ -322,7 +322,6 @@ static int __devinit snd_jazz16_probe(struct device *devptr, unsigned int dev)
 					MPU401_HW_MPU401,
 					mpu_port[dev], 0,
 					mpu_irq[dev],
-					mpu_irq[dev] >= 0 ? IRQF_DISABLED : 0,
 					NULL) < 0)
 			snd_printk(KERN_ERR "no MPU-401 device at 0x%lx\n",
 					mpu_port[dev]);
diff --git a/sound/isa/sb/sb16.c b/sound/isa/sb/sb16.c
index 4d1c5a3..237f8bd 100644
--- a/sound/isa/sb/sb16.c
+++ b/sound/isa/sb/sb16.c
@@ -394,8 +394,9 @@ static int __devinit snd_sb16_probe(struct snd_card *card, int dev)
 
 	if (chip->mpu_port > 0 && chip->mpu_port != SNDRV_AUTO_PORT) {
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_SB,
-					       chip->mpu_port, 0,
-					       xirq, 0, &chip->rmidi)) < 0)
+					       chip->mpu_port,
+					       MPU401_INFO_IRQ_HOOK, -1,
+					       &chip->rmidi)) < 0)
 			return err;
 		chip->rmidi_callback = snd_mpu401_uart_interrupt;
 	}
diff --git a/sound/isa/sc6000.c b/sound/isa/sc6000.c
index 9a8bbf6..207c161 100644
--- a/sound/isa/sc6000.c
+++ b/sound/isa/sc6000.c
@@ -658,8 +658,7 @@ static int __devinit snd_sc6000_probe(struct device *devptr, unsigned int dev)
 		if (snd_mpu401_uart_new(card, 0,
 					MPU401_HW_MPU401,
 					mpu_port[dev], 0,
-					mpu_irq[dev], IRQF_DISABLED,
-					NULL) < 0)
+					mpu_irq[dev], NULL) < 0)
 			snd_printk(KERN_ERR "no MPU-401 device at 0x%lx ?\n",
 					mpu_port[dev]);
 	}
diff --git a/sound/isa/sscape.c b/sound/isa/sscape.c
index e2d5d2d..f2379e1 100644
--- a/sound/isa/sscape.c
+++ b/sound/isa/sscape.c
@@ -825,8 +825,7 @@ static int __devinit create_mpu401(struct snd_card *card, int devnum,
 	int err;
 
 	err = snd_mpu401_uart_new(card, devnum, MPU401_HW_MPU401, port,
-				  MPU401_INFO_INTEGRATED, irq, IRQF_DISABLED,
-				  &rawmidi);
+				  MPU401_INFO_INTEGRATED, irq, &rawmidi);
 	if (err == 0) {
 		struct snd_mpu401 *mpu = rawmidi->private_data;
 		mpu->open_input = mpu401_open;
diff --git a/sound/isa/wavefront/wavefront.c b/sound/isa/wavefront/wavefront.c
index 711670e..83f291d 100644
--- a/sound/isa/wavefront/wavefront.c
+++ b/sound/isa/wavefront/wavefront.c
@@ -449,8 +449,7 @@ snd_wavefront_probe (struct snd_card *card, int dev)
 	if (cs4232_mpu_port[dev] > 0 && cs4232_mpu_port[dev] != SNDRV_AUTO_PORT) {
 		err = snd_mpu401_uart_new(card, midi_dev, MPU401_HW_CS4232,
 					  cs4232_mpu_port[dev], 0,
-					  cs4232_mpu_irq[dev], IRQF_DISABLED,
-					  NULL);
+					  cs4232_mpu_irq[dev], NULL);
 		if (err < 0) {
 			snd_printk (KERN_ERR "can't allocate CS4232 MPU-401 device\n");
 			return err;
diff --git a/sound/pci/als4000.c b/sound/pci/als4000.c
index a9c1af3..0462869 100644
--- a/sound/pci/als4000.c
+++ b/sound/pci/als4000.c
@@ -931,8 +931,9 @@ static int __devinit snd_card_als4000_probe(struct pci_dev *pci,
 
 	if ((err = snd_mpu401_uart_new( card, 0, MPU401_HW_ALS4000,
 					iobase + ALS4K_IOB_30_MIDI_DATA,
-					MPU401_INFO_INTEGRATED,
-					pci->irq, 0, &chip->rmidi)) < 0) {
+					MPU401_INFO_INTEGRATED |
+					MPU401_INFO_IRQ_HOOK,
+					-1, &chip->rmidi)) < 0) {
 		printk(KERN_ERR "als4000: no MPU-401 device at 0x%lx?\n",
 				iobase + ALS4K_IOB_30_MIDI_DATA);
 		goto out_err;
diff --git a/sound/pci/au88x0/au88x0_mpu401.c b/sound/pci/au88x0/au88x0_mpu401.c
index 0dc8d25..e6c6a0f 100644
--- a/sound/pci/au88x0/au88x0_mpu401.c
+++ b/sound/pci/au88x0/au88x0_mpu401.c
@@ -84,7 +84,7 @@ static int __devinit snd_vortex_midi(vortex_t * vortex)
 #ifdef VORTEX_MPU401_LEGACY
 	if ((temp =
 	     snd_mpu401_uart_new(vortex->card, 0, MPU401_HW_MPU401, 0x330,
-				 0, 0, 0, &rmidi)) != 0) {
+				 MPU401_INFO_IRQ_HOOK, -1, &rmidi)) != 0) {
 		hwwrite(vortex->mmio, VORTEX_CTRL,
 			(hwread(vortex->mmio, VORTEX_CTRL) &
 			 ~CTRL_MIDI_PORT) & ~CTRL_MIDI_EN);
@@ -94,8 +94,8 @@ static int __devinit snd_vortex_midi(vortex_t * vortex)
 	port = (unsigned long)(vortex->mmio + VORTEX_MIDI_DATA);
 	if ((temp =
 	     snd_mpu401_uart_new(vortex->card, 0, MPU401_HW_AUREAL, port,
-				 MPU401_INFO_INTEGRATED | MPU401_INFO_MMIO,
-				 0, 0, &rmidi)) != 0) {
+				 MPU401_INFO_INTEGRATED | MPU401_INFO_MMIO |
+				 MPU401_INFO_IRQ_HOOK, -1, &rmidi)) != 0) {
 		hwwrite(vortex->mmio, VORTEX_CTRL,
 			(hwread(vortex->mmio, VORTEX_CTRL) &
 			 ~CTRL_MIDI_PORT) & ~CTRL_MIDI_EN);
diff --git a/sound/pci/azt3328.c b/sound/pci/azt3328.c
index 579fc0d..d24fe42 100644
--- a/sound/pci/azt3328.c
+++ b/sound/pci/azt3328.c
@@ -2652,8 +2652,9 @@ snd_azf3328_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	   since our hardware ought to be similar, thus use same ID. */
 	err = snd_mpu401_uart_new(
 		card, 0,
-		MPU401_HW_AZT2320, chip->mpu_io, MPU401_INFO_INTEGRATED,
-		pci->irq, 0, &chip->rmidi
+		MPU401_HW_AZT2320, chip->mpu_io,
+		MPU401_INFO_INTEGRATED | MPU401_INFO_IRQ_HOOK,
+		-1, &chip->rmidi
 	);
 	if (err < 0) {
 		snd_printk(KERN_ERR "azf3328: no MPU-401 device at 0x%lx?\n",
diff --git a/sound/pci/cmipci.c b/sound/pci/cmipci.c
index 9cf99fb..da9c732 100644
--- a/sound/pci/cmipci.c
+++ b/sound/pci/cmipci.c
@@ -3228,8 +3228,9 @@ static int __devinit snd_cmipci_create(struct snd_card *card, struct pci_dev *pc
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_CMIPCI,
 					       iomidi,
 					       (integrated_midi ?
-						MPU401_INFO_INTEGRATED : 0),
-					       cm->irq, 0, &cm->rmidi)) < 0) {
+						MPU401_INFO_INTEGRATED : 0) |
+					       MPU401_INFO_IRQ_HOOK,
+					       -1, &cm->rmidi)) < 0) {
 			printk(KERN_ERR "cmipci: no UART401 device at 0x%lx\n", iomidi);
 		}
 	}
diff --git a/sound/pci/es1938.c b/sound/pci/es1938.c
index 26a5a2f..718a264 100644
--- a/sound/pci/es1938.c
+++ b/sound/pci/es1938.c
@@ -1854,8 +1854,9 @@ static int __devinit snd_es1938_probe(struct pci_dev *pci,
 		}
 	}
 	if (snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
-				chip->mpu_port, MPU401_INFO_INTEGRATED,
-				chip->irq, 0, &chip->rmidi) < 0) {
+				chip->mpu_port,
+				MPU401_INFO_INTEGRATED | MPU401_INFO_IRQ_HOOK,
+				-1, &chip->rmidi) < 0) {
 		printk(KERN_ERR "es1938: unable to initialize MPU-401\n");
 	} else {
 		// this line is vital for MIDI interrupt handling on ess-solo1
diff --git a/sound/pci/es1968.c b/sound/pci/es1968.c
index 99ea932..407e4ab 100644
--- a/sound/pci/es1968.c
+++ b/sound/pci/es1968.c
@@ -2843,8 +2843,9 @@ static int __devinit snd_es1968_probe(struct pci_dev *pci,
 	if (enable_mpu[dev]) {
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_MPU401,
 					       chip->io_port + ESM_MPU401_PORT,
-					       MPU401_INFO_INTEGRATED,
-					       chip->irq, 0, &chip->rmidi)) < 0) {
+					       MPU401_INFO_INTEGRATED |
+					       MPU401_INFO_IRQ_HOOK,
+					       -1, &chip->rmidi)) < 0) {
 			printk(KERN_WARNING "es1968: skipping MPU-401 MIDI support..\n");
 		}
 	}
diff --git a/sound/pci/fm801.c b/sound/pci/fm801.c
index f9123f0..c55b1b3 100644
--- a/sound/pci/fm801.c
+++ b/sound/pci/fm801.c
@@ -1306,8 +1306,9 @@ static int __devinit snd_card_fm801_probe(struct pci_dev *pci,
 	}
 	if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_FM801,
 				       FM801_REG(chip, MPU401_DATA),
-				       MPU401_INFO_INTEGRATED,
-				       chip->irq, 0, &chip->rmidi)) < 0) {
+				       MPU401_INFO_INTEGRATED |
+				       MPU401_INFO_IRQ_HOOK,
+				       -1, &chip->rmidi)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
diff --git a/sound/pci/ice1712/ice1712.c b/sound/pci/ice1712/ice1712.c
index 0ccc0eb..8531b98 100644
--- a/sound/pci/ice1712/ice1712.c
+++ b/sound/pci/ice1712/ice1712.c
@@ -2748,8 +2748,9 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 	if (!c->no_mpu401) {
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_ICE1712,
 			ICEREG(ice, MPU1_CTRL),
-			(c->mpu401_1_info_flags | MPU401_INFO_INTEGRATED),
-			ice->irq, 0, &ice->rmidi[0]);
+			c->mpu401_1_info_flags |
+			MPU401_INFO_INTEGRATED | MPU401_INFO_IRQ_HOOK,
+			-1, &ice->rmidi[0]);
 		if (err < 0) {
 			snd_card_free(card);
 			return err;
@@ -2764,8 +2765,9 @@ static int __devinit snd_ice1712_probe(struct pci_dev *pci,
 			/*  2nd port used  */
 			err = snd_mpu401_uart_new(card, 1, MPU401_HW_ICE1712,
 				ICEREG(ice, MPU2_CTRL),
-				(c->mpu401_2_info_flags | MPU401_INFO_INTEGRATED),
-				ice->irq, 0, &ice->rmidi[1]);
+				c->mpu401_2_info_flags |
+				MPU401_INFO_INTEGRATED | MPU401_INFO_IRQ_HOOK,
+				-1, &ice->rmidi[1]);
 
 			if (err < 0) {
 				snd_card_free(card);
diff --git a/sound/pci/maestro3.c b/sound/pci/maestro3.c
index 0378126..2fd4bf2 100644
--- a/sound/pci/maestro3.c
+++ b/sound/pci/maestro3.c
@@ -2820,8 +2820,8 @@ snd_m3_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 	/* TODO enable MIDI IRQ and I/O */
 	err = snd_mpu401_uart_new(chip->card, 0, MPU401_HW_MPU401,
 				  chip->iobase + MPU401_DATA_PORT,
-				  MPU401_INFO_INTEGRATED,
-				  chip->irq, 0, &chip->rmidi);
+				  MPU401_INFO_INTEGRATED | MPU401_INFO_IRQ_HOOK,
+				  -1, &chip->rmidi);
 	if (err < 0)
 		printk(KERN_WARNING "maestro3: no MIDI support.\n");
 #endif
diff --git a/sound/pci/oxygen/oxygen_lib.c b/sound/pci/oxygen/oxygen_lib.c
index 82311fc..53e5508 100644
--- a/sound/pci/oxygen/oxygen_lib.c
+++ b/sound/pci/oxygen/oxygen_lib.c
@@ -678,15 +678,15 @@ int oxygen_pci_probe(struct pci_dev *pci, int index, char *id,
 		goto err_card;
 
 	if (chip->model.device_config & (MIDI_OUTPUT | MIDI_INPUT)) {
-		unsigned int info_flags = MPU401_INFO_INTEGRATED;
+		unsigned int info_flags =
+				MPU401_INFO_INTEGRATED | MPU401_INFO_IRQ_HOOK;
 		if (chip->model.device_config & MIDI_OUTPUT)
 			info_flags |= MPU401_INFO_OUTPUT;
 		if (chip->model.device_config & MIDI_INPUT)
 			info_flags |= MPU401_INFO_INPUT;
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_CMIPCI,
 					  chip->addr + OXYGEN_MPU401,
-					  info_flags, 0, 0,
-					  &chip->midi);
+					  info_flags, -1, &chip->midi);
 		if (err < 0)
 			goto err_card;
 	}
diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index e34ae14..88cc776 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -2109,7 +2109,7 @@ snd_card_riptide_probe(struct pci_dev *pci, const struct pci_device_id *pci_id)
 		val = mpu_port[dev];
 		pci_write_config_word(chip->pci, PCI_EXT_MPU_Base, val);
 		err = snd_mpu401_uart_new(card, 0, MPU401_HW_RIPTIDE,
-					  val, 0, chip->irq, 0,
+					  val, MPU401_INFO_IRQ_HOOK, -1,
 					  &chip->rmidi);
 		if (err < 0)
 			snd_printk(KERN_WARNING
diff --git a/sound/pci/sonicvibes.c b/sound/pci/sonicvibes.c
index 2571a67..c500816 100644
--- a/sound/pci/sonicvibes.c
+++ b/sound/pci/sonicvibes.c
@@ -1493,9 +1493,10 @@ static int __devinit snd_sonic_probe(struct pci_dev *pci,
 		return err;
 	}
 	if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_SONICVIBES,
-				       sonic->midi_port, MPU401_INFO_INTEGRATED,
-				       sonic->irq, 0,
-				       &midi_uart)) < 0) {
+				       sonic->midi_port,
+				       MPU401_INFO_INTEGRATED |
+				       MPU401_INFO_IRQ_HOOK,
+				       -1, &midi_uart)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
diff --git a/sound/pci/trident/trident.c b/sound/pci/trident/trident.c
index d8a128f..5e707ef 100644
--- a/sound/pci/trident/trident.c
+++ b/sound/pci/trident/trident.c
@@ -148,8 +148,9 @@ static int __devinit snd_trident_probe(struct pci_dev *pci,
 	if (trident->device != TRIDENT_DEVICE_ID_SI7018 &&
 	    (err = snd_mpu401_uart_new(card, 0, MPU401_HW_TRID4DWAVE,
 				       trident->midi_port,
-				       MPU401_INFO_INTEGRATED,
-				       trident->irq, 0, &trident->rmidi)) < 0) {
+				       MPU401_INFO_INTEGRATED |
+				       MPU401_INFO_IRQ_HOOK,
+				       -1, &trident->rmidi)) < 0) {
 		snd_card_free(card);
 		return err;
 	}
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index f03fd62..35d5f43 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2068,8 +2068,9 @@ static int __devinit snd_via686_init_misc(struct via82xx *chip)
 	pci_write_config_byte(chip->pci, VIA_PNP_CONTROL, legacy_cfg);
 	if (chip->mpu_res) {
 		if (snd_mpu401_uart_new(chip->card, 0, MPU401_HW_VIA686A,
-					mpu_port, MPU401_INFO_INTEGRATED,
-					chip->irq, 0, &chip->rmidi) < 0) {
+					mpu_port, MPU401_INFO_INTEGRATED |
+					MPU401_INFO_IRQ_HOOK, -1,
+					&chip->rmidi) < 0) {
 			printk(KERN_WARNING "unable to initialize MPU-401"
 			       " at 0x%lx, skipping\n", mpu_port);
 			legacy &= ~VIA_FUNC_ENABLE_MIDI;
diff --git a/sound/pci/ymfpci/ymfpci.c b/sound/pci/ymfpci/ymfpci.c
index 511d576..3253b04 100644
--- a/sound/pci/ymfpci/ymfpci.c
+++ b/sound/pci/ymfpci/ymfpci.c
@@ -305,8 +305,9 @@ static int __devinit snd_card_ymfpci_probe(struct pci_dev *pci,
 	if (chip->mpu_res) {
 		if ((err = snd_mpu401_uart_new(card, 0, MPU401_HW_YMFPCI,
 					       mpu_port[dev],
-					       MPU401_INFO_INTEGRATED,
-					       pci->irq, 0, &chip->rawmidi)) < 0) {
+					       MPU401_INFO_INTEGRATED |
+					       MPU401_INFO_IRQ_HOOK,
+					       -1, &chip->rawmidi)) < 0) {
 			printk(KERN_WARNING "ymfpci: cannot initialize MPU401 at 0x%lx, skipping...\n", mpu_port[dev]);
 			legacy_ctrl &= ~YMFPCI_LEGACY_MIEN; /* disable MPU401 irq */
 			pci_write_config_word(pci, PCIR_DSXG_LEGACY, legacy_ctrl);
