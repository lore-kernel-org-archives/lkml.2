Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1LBFLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 00:11:11 -0500
Received: from matrix.voodoobox.net ([75.127.97.206]:38325 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1LBFK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 00:10:57 -0500
X-Greylist: delayed 2460 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Dec 2011 00:10:56 EST
Subject: [PATCH 1/2] ALSA: sis7019 - give slow codecs more time to reset
From: David Dillow <dave@thedillows.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel mailing list <alsa-devel@alsa-project.org>,
        linux-kernel@vger.kernel.org, misiu <tjosko@yahoo.com>
Date: Thu, 01 Dec 2011 23:26:53 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1322800014.26859.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some AC97 codec and board combinations that have been observed
to take a very long time to respond after the cold reset has completed.
In one case, more than 350 ms was required. To allow users to have sound
on those platforms, we'll wait up to 500ms for the codec to become
ready.
    
As a board may have multiple codecs, with some faster than others to
reset, we add a module parameter to inform the driver which codecs
should be present.
    
Reported-by: KotCzarny <tjosko@yahoo.com>
Signed-off-by: David Dillow <dave@thedillows.org>
--
This should probably be fed to stable as well.

 sound/pci/sis7019.c |   64 ++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 53 insertions(+), 11 deletions(-)


diff --git a/sound/pci/sis7019.c b/sound/pci/sis7019.c
index a391e62..28dfafb 100644
--- a/sound/pci/sis7019.c
+++ b/sound/pci/sis7019.c
@@ -41,6 +41,7 @@ MODULE_SUPPORTED_DEVICE("{{SiS,SiS7019 Audio Accelerator}}");
 static int index = SNDRV_DEFAULT_IDX1;	/* Index 0-MAX */
 static char *id = SNDRV_DEFAULT_STR1;	/* ID for this card */
 static int enable = 1;
+static int codecs = 1;
 
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for SiS7019 Audio Accelerator.");
@@ -48,6 +49,8 @@ module_param(id, charp, 0444);
 MODULE_PARM_DESC(id, "ID string for SiS7019 Audio Accelerator.");
 module_param(enable, bool, 0444);
 MODULE_PARM_DESC(enable, "Enable SiS7019 Audio Accelerator.");
+module_param(codecs, int, 0444);
+MODULE_PARM_DESC(codecs, "Set bit to indicate that codec number is expected to be present (default 1)");
 
 static DEFINE_PCI_DEVICE_TABLE(snd_sis7019_ids) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x7019) },
@@ -140,6 +143,9 @@ struct sis7019 {
 	dma_addr_t silence_dma_addr;
 };
 
+/* These values are also used by the module param 'codecs' to indicate
+ * which codecs should be present.
+ */
 #define SIS_PRIMARY_CODEC_PRESENT	0x0001
 #define SIS_SECONDARY_CODEC_PRESENT	0x0002
 #define SIS_TERTIARY_CODEC_PRESENT	0x0004
@@ -1078,6 +1084,7 @@ static int sis_chip_init(struct sis7019 *sis)
 {
 	unsigned long io = sis->ioport;
 	void __iomem *ioaddr = sis->ioaddr;
+	unsigned long timeout;
 	u16 status;
 	int count;
 	int i;
@@ -1104,21 +1111,45 @@ static int sis_chip_init(struct sis7019 *sis)
 	while ((inw(io + SIS_AC97_STATUS) & SIS_AC97_STATUS_BUSY) && --count)
 		udelay(1);
 
+	/* Command complete, we can let go of the semaphore now.
+	 */
+	outl(SIS_AC97_SEMA_RELEASE, io + SIS_AC97_SEMA);
+	if (!count)
+		return -EIO;
+
 	/* Now that we've finished the reset, find out what's attached.
+	 * There are some codec/board combinations that take an extremely
+	 * long time to come up. 350+ ms has been observed in the field,
+	 * so we'll give them up to 500ms.
 	 */
-	status = inl(io + SIS_AC97_STATUS);
-	if (status & SIS_AC97_STATUS_CODEC_READY)
-		sis->codecs_present |= SIS_PRIMARY_CODEC_PRESENT;
-	if (status & SIS_AC97_STATUS_CODEC2_READY)
-		sis->codecs_present |= SIS_SECONDARY_CODEC_PRESENT;
-	if (status & SIS_AC97_STATUS_CODEC3_READY)
-		sis->codecs_present |= SIS_TERTIARY_CODEC_PRESENT;
-
-	/* All done, let go of the semaphore, and check for errors
+	sis->codecs_present = 0;
+	timeout = msecs_to_jiffies(500) + jiffies;
+	while (time_before_eq(jiffies, timeout)) {
+		status = inl(io + SIS_AC97_STATUS);
+		if (status & SIS_AC97_STATUS_CODEC_READY)
+			sis->codecs_present |= SIS_PRIMARY_CODEC_PRESENT;
+		if (status & SIS_AC97_STATUS_CODEC2_READY)
+			sis->codecs_present |= SIS_SECONDARY_CODEC_PRESENT;
+		if (status & SIS_AC97_STATUS_CODEC3_READY)
+			sis->codecs_present |= SIS_TERTIARY_CODEC_PRESENT;
+
+		if (sis->codecs_present == codecs)
+			break;
+
+		msleep(1);
+	}
+
+	/* All done, check for errors.
 	 */
-	outl(SIS_AC97_SEMA_RELEASE, io + SIS_AC97_SEMA);
-	if (!sis->codecs_present || !count)
+	if (!sis->codecs_present) {
+		printk(KERN_ERR "sis7019: could not find any codecs\n");
 		return -EIO;
+	}
+
+	if (sis->codecs_present != codecs) {
+		printk(KERN_WARNING "sis7019: missing codecs, found %0x, expected %0x\n",
+		       sis->codecs_present, codecs);
+	}
 
 	/* Let the hardware know that the audio driver is alive,
 	 * and enable PCM slots on the AC-link for L/R playback (3 & 4) and
@@ -1390,6 +1421,17 @@ static int __devinit snd_sis7019_probe(struct pci_dev *pci,
 	if (!enable)
 		goto error_out;
 
+	/* The user can specify which codecs should be present so that we
+	 * can wait for them to show up if they are slow to recover from
+	 * the AC97 cold reset. We default to a single codec, the primary.
+	 *
+	 * We assume that SIS_PRIMARY_*_PRESENT matches bits 0-2.
+	 */
+	codecs &= SIS_PRIMARY_CODEC_PRESENT | SIS_SECONDARY_CODEC_PRESENT |
+		  SIS_TERTIARY_CODEC_PRESENT;
+	if (!codecs)
+		codecs = SIS_PRIMARY_CODEC_PRESENT;
+
 	rc = snd_card_create(index, id, THIS_MODULE, sizeof(*sis), &card);
 	if (rc < 0)
 		goto error_out;


