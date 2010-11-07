Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab0KGUsZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 15:48:25 -0500
Received: from mail.perches.com ([173.55.12.10]:4540 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0KGUsX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 15:48:23 -0500
Subject: [PATCH] drivers/staging/cx25821: Use pr_fmt and pr_<level>
From: Joe Perches <joe@perches.com>
To: devel <devel@linuxdriverproject.org>, hiep.huynh@conexant.com,
        shu.lin@conexant.com
Cc: linux-media <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 07 Nov 2010 12:48:21 -0800
Message-ID: <1289162901.29216.306.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix several defects with bad line continuation uses that
introduce whitespace.
Fix several defects with lines missing "\n".
Standardize prefixes via pr_fmt.
Remove internal cx25821 prefixes.
Standardize :%s():" ... __func__ uses.
Coalesce long formats.
Add KERN_<level> prefixes via pr_<level> to printks.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/cx25821/cx25821-alsa.c             |   71 ++++----
 drivers/staging/cx25821/cx25821-audio-upstream.c   |   66 ++++----
 drivers/staging/cx25821/cx25821-cards.c            |    2 +
 drivers/staging/cx25821/cx25821-core.c             |  191 ++++++++++----------
 drivers/staging/cx25821/cx25821-i2c.c              |   19 ++-
 drivers/staging/cx25821/cx25821-medusa-video.c     |    7 +-
 .../staging/cx25821/cx25821-video-upstream-ch2.c   |   63 +++----
 drivers/staging/cx25821/cx25821-video-upstream.c   |   90 ++++------
 drivers/staging/cx25821/cx25821-video.c            |   82 ++++-----
 drivers/staging/cx25821/cx25821-video.h            |    9 +-
 drivers/staging/cx25821/cx25821.h                  |    9 +-
 11 files changed, 287 insertions(+), 322 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-alsa.c b/drivers/staging/cx25821/cx25821-alsa.c
index 2a01dc0..9a205a3 100644
--- a/drivers/staging/cx25821/cx25821-alsa.c
+++ b/drivers/staging/cx25821/cx25821-alsa.c
@@ -20,6 +20,8 @@
  *
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/device.h>
@@ -42,11 +44,16 @@
 
 #define AUDIO_SRAM_CHANNEL	SRAM_CH08
 
-#define dprintk(level, fmt, arg...)	if (debug >= level) \
-	printk(KERN_INFO "%s/1: " fmt, chip->dev->name , ## arg)
-
-#define dprintk_core(level, fmt, arg...)	if (debug >= level) \
-	printk(KERN_DEBUG "%s/1: " fmt, chip->dev->name , ## arg)
+#define dprintk(level, fmt, arg...)				\
+do {								\
+	if (debug >= level)					\
+		pr_info("%s/1: " fmt, chip->dev->name, ##arg);	\
+} while (0)
+#define dprintk_core(level, fmt, arg...)				\
+do {									\
+	if (debug >= level)						\
+		printk(KERN_DEBUG "%s/1: " fmt, chip->dev->name, ##arg); \
+} while (0)
 
 /****************************************************************************
 	Data type declarations - Can be moded to a header file later
@@ -173,12 +180,11 @@ static int _cx25821_start_audio_dma(struct cx25821_audio_dev *chip)
 		 tmp | FLD_AUD_DST_PK_MODE | FLD_AUD_DST_ENABLE |
 		 FLD_AUD_CLK_ENABLE);
 
-	/* printk(KERN_INFO "DEBUG: Start audio DMA, %d B/line,"
-				"cmds_start(0x%x)= %d lines/FIFO, %d periods, "
-				"%d byte buffer\n", buf->bpl,
-				audio_ch->cmds_start,
-				cx_read(audio_ch->cmds_start + 12)>>1,
-				chip->num_periods, buf->bpl *chip->num_periods);
+	/*
+	pr_info("DEBUG: Start audio DMA, %d B/line, cmds_start(0x%x)= %d lines/FIFO, %d periods, %d byte buffer\n",
+		buf->bpl, audio_ch->cmds_start,
+		cx_read(audio_ch->cmds_start + 12)>>1,
+		chip->num_periods, buf->bpl * chip->num_periods);
 	*/
 
 	/* Enables corresponding bits at AUD_INT_STAT */
@@ -259,8 +265,7 @@ static void cx25821_aud_irq(struct cx25821_audio_dev *chip, u32 status,
 
 	/* risc op code error */
 	if (status & AUD_INT_OPC_ERR) {
-		printk(KERN_WARNING "WARNING %s/1: Audio risc op code error\n",
-		       dev->name);
+		pr_warn("WARNING %s/1: Audio risc op code error\n", dev->name);
 
 		cx_clear(AUD_INT_DMA_CTL,
 			 FLD_AUD_DST_A_RISC_EN | FLD_AUD_DST_A_FIFO_EN);
@@ -269,8 +274,7 @@ static void cx25821_aud_irq(struct cx25821_audio_dev *chip, u32 status,
 						[AUDIO_SRAM_CHANNEL]);
 	}
 	if (status & AUD_INT_DN_SYNC) {
-		printk(KERN_WARNING "WARNING %s: Downstream sync error!\n",
-		       dev->name);
+		pr_warn("WARNING %s: Downstream sync error!\n", dev->name);
 		cx_write(AUD_A_GPCNT_CTL, GP_COUNT_CONTROL_RESET);
 		return;
 	}
@@ -388,8 +392,7 @@ static int snd_cx25821_pcm_open(struct snd_pcm_substream *substream)
 	unsigned int bpl = 0;
 
 	if (!chip) {
-		printk(KERN_ERR "DEBUG: cx25821 can't find device struct."
-		       " Can't proceed with open\n");
+		pr_err("DEBUG: cx25821 can't find device struct. Can't proceed with open\n");
 		return -ENODEV;
 	}
 
@@ -479,8 +482,7 @@ static int snd_cx25821_hw_params(struct snd_pcm_substream *substream,
 					  chip->period_size, chip->num_periods,
 					  1);
 	if (ret < 0) {
-		printk(KERN_INFO
-			"DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
+		pr_info("DEBUG: ERROR after cx25821_risc_databuffer_audio()\n");
 		goto error;
 	}
 
@@ -608,8 +610,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
 
 	err = snd_pcm_new(chip->card, name, device, 0, 1, &pcm);
 	if (err < 0) {
-		printk(KERN_INFO "ERROR: FAILED snd_pcm_new() in %s\n",
-		       __func__);
+		pr_info("ERROR: FAILED snd_pcm_new() in %s\n", __func__);
 		return err;
 	}
 	pcm->private_data = chip;
@@ -674,23 +675,21 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 	int err;
 
 	if (devno >= SNDRV_CARDS) {
-		printk(KERN_INFO "DEBUG ERROR: devno >= SNDRV_CARDS %s\n",
-		       __func__);
+		pr_info("DEBUG ERROR: devno >= SNDRV_CARDS %s\n", __func__);
 		return -ENODEV;
 	}
 
 	if (!enable[devno]) {
 		++devno;
-		printk(KERN_INFO "DEBUG ERROR: !enable[devno] %s\n", __func__);
+		pr_info("DEBUG ERROR: !enable[devno] %s\n", __func__);
 		return -ENOENT;
 	}
 
 	err = snd_card_create(index[devno], id[devno], THIS_MODULE,
 			 sizeof(struct cx25821_audio_dev), &card);
 	if (err < 0) {
-		printk(KERN_INFO
-		       "DEBUG ERROR: cannot create snd_card_new in %s\n",
-		       __func__);
+		pr_info("DEBUG ERROR: cannot create snd_card_new in %s\n",
+			__func__);
 		return err;
 	}
 
@@ -712,16 +711,15 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 			  IRQF_SHARED | IRQF_DISABLED, chip->dev->name, chip);
 
 	if (err < 0) {
-		printk(KERN_ERR "ERROR %s: can't get IRQ %d for ALSA\n",
+		pr_err("ERROR %s: can't get IRQ %d for ALSA\n",
 		       chip->dev->name, dev->pci->irq);
 		goto error;
 	}
 
 	err = snd_cx25821_pcm(chip, 0, "cx25821 Digital");
 	if (err < 0) {
-		printk(KERN_INFO
-		       "DEBUG ERROR: cannot create snd_cx25821_pcm %s\n",
-		       __func__);
+		pr_info("DEBUG ERROR: cannot create snd_cx25821_pcm %s\n",
+			__func__);
 		goto error;
 	}
 
@@ -732,13 +730,13 @@ static int cx25821_audio_initdev(struct cx25821_dev *dev)
 		chip->iobase, chip->irq);
 	strcpy(card->mixername, "CX25821");
 
-	printk(KERN_INFO "%s/%i: ALSA support for cx25821 boards\n",
-	       card->driver, devno);
+	pr_info("%s/%i: ALSA support for cx25821 boards\n",
+		card->driver, devno);
 
 	err = snd_card_register(card);
 	if (err < 0) {
-		printk(KERN_INFO "DEBUG ERROR: cannot register sound card %s\n",
-		       __func__);
+		pr_info("DEBUG ERROR: cannot register sound card %s\n",
+			__func__);
 		goto error;
 	}
 
@@ -778,8 +776,7 @@ static int cx25821_alsa_init(void)
 	}
 
 	if (dev == NULL)
-		printk(KERN_INFO
-		       "cx25821 ERROR ALSA: no cx25821 cards found\n");
+		pr_info("ERROR ALSA: no cx25821 cards found\n");
 
 	return 0;
 
diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
index 1607b0d..7992a3b 100644
--- a/drivers/staging/cx25821/cx25821-audio-upstream.c
+++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "cx25821-video.h"
 #include "cx25821-audio-upstream.h"
 
@@ -221,7 +223,7 @@ void cx25821_stop_upstream_audio(struct cx25821_dev *dev)
 
 	if (!dev->_audio_is_running) {
 		printk(KERN_DEBUG
-		    "cx25821: No audio file is currently running so return!\n");
+		       pr_fmt("No audio file is currently running so return!\n"));
 		return;
 	}
 	/* Disable RISC interrupts */
@@ -281,19 +283,19 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
+		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_audiofilename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk(KERN_ERR "%s: File has no file operations registered!\n",
+			pr_err("%s(): File has no file operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk(KERN_ERR "%s: File has no READ operations registered!\n",
+			pr_err("%s(): File has no READ operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -320,9 +322,8 @@ int cx25821_get_audio_data(struct cx25821_dev *dev,
 			frame_offset += vfs_read_retval;
 
 			if (vfs_read_retval < line_size) {
-				printk(KERN_INFO
-				       "Done: exit %s() since no more bytes to read from Audio file.\n",
-				       __func__);
+				pr_info("Done: exit %s() since no more bytes to read from Audio file\n",
+					__func__);
 				break;
 			}
 		}
@@ -346,7 +347,7 @@ static void cx25821_audioups_handler(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _audio_work_entry);
 
 	if (!dev) {
-		printk(KERN_ERR "ERROR %s(): since container_of(work_struct) FAILED!\n",
+		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
 		       __func__);
 		return;
 	}
@@ -373,19 +374,19 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk(KERN_ERR "%s(): ERROR opening file(%s) with errno = %d!\n",
+		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_audiofilename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk(KERN_ERR "%s: File has no file operations registered!\n",
+			pr_err("%s(): File has no file operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk(KERN_ERR "%s: File has no READ operations registered!\n",
+			pr_err("%s(): File has no READ operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -414,9 +415,8 @@ int cx25821_openfile_audio(struct cx25821_dev *dev,
 				offset += vfs_read_retval;
 
 				if (vfs_read_retval < line_size) {
-					printk(KERN_INFO
-					       "Done: exit %s() since no more bytes to read from Audio file.\n",
-					       __func__);
+					pr_info("Done: exit %s() since no more bytes to read from Audio file\n",
+						__func__);
 					break;
 				}
 			}
@@ -459,7 +459,7 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	if (!dev->_risc_virt_addr) {
 		printk(KERN_DEBUG
-			"cx25821 ERROR: pci_alloc_consistent() FAILED to allocate memory for RISC program! Returning.\n");
+		       pr_fmt("ERROR: pci_alloc_consistent() FAILED to allocate memory for RISC program! Returning\n"));
 		return -ENOMEM;
 	}
 	/* Clear out memory at address */
@@ -474,7 +474,7 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 
 	if (!dev->_audiodata_buf_virt_addr) {
 		printk(KERN_DEBUG
-			"cx25821 ERROR: pci_alloc_consistent() FAILED to allocate memory for data buffer! Returning.\n");
+		       pr_fmt("ERROR: pci_alloc_consistent() FAILED to allocate memory for data buffer! Returning\n"));
 		return -ENOMEM;
 	}
 	/* Clear out memory at address */
@@ -490,7 +490,7 @@ static int cx25821_audio_upstream_buffer_prepare(struct cx25821_dev *dev,
 					       dev->_audio_lines_count);
 	if (ret < 0) {
 		printk(KERN_DEBUG
-		      "cx25821 ERROR creating audio upstream RISC programs!\n");
+		       pr_fmt("ERROR creating audio upstream RISC programs!\n"));
 		goto error;
 	}
 
@@ -569,16 +569,16 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 		spin_unlock(&dev->slock);
 	} else {
 		if (status & FLD_AUD_SRC_OF)
-			printk(KERN_WARNING "%s: Audio Received Overflow Error Interrupt!\n",
-			       __func__);
+			pr_warn("%s(): Audio Received Overflow Error Interrupt!\n",
+				__func__);
 
 		if (status & FLD_AUD_SRC_SYNC)
-			printk(KERN_WARNING "%s: Audio Received Sync Error Interrupt!\n",
-			       __func__);
+			pr_warn("%s(): Audio Received Sync Error Interrupt!\n",
+				__func__);
 
 		if (status & FLD_AUD_SRC_OPC_ERR)
-			printk(KERN_WARNING "%s: Audio Received OpCode Error Interrupt!\n",
-			       __func__);
+			pr_warn("%s(): Audio Received OpCode Error Interrupt!\n",
+				__func__);
 
 		/* Read and write back the interrupt status register to clear
 		 * our bits */
@@ -586,8 +586,8 @@ int cx25821_audio_upstream_irq(struct cx25821_dev *dev, int chan_num,
 	}
 
 	if (dev->_audiofile_status == END_OF_FILE) {
-		printk(KERN_WARNING "cx25821: EOF Channel Audio Framecount = %d\n",
-		       dev->_audioframe_count);
+		pr_warn("EOF Channel Audio Framecount = %d\n",
+			dev->_audioframe_count);
 		return -1;
 	}
 	/* ElSE, set the interrupt mask register, re-enable irq. */
@@ -644,9 +644,8 @@ static void cx25821_wait_fifo_enable(struct cx25821_dev *dev,
 
 		/* 10 millisecond timeout */
 		if (count++ > 1000) {
-			printk(KERN_ERR
-			       "cx25821 ERROR: %s() fifo is NOT turned on. Timeout!\n",
-			     __func__);
+			pr_err("ERROR: %s() fifo is NOT turned on. Timeout!\n",
+			       __func__);
 			return;
 		}
 
@@ -696,8 +695,8 @@ int cx25821_start_audio_dma_upstream(struct cx25821_dev *dev,
 	    request_irq(dev->pci->irq, cx25821_upstream_irq_audio,
 			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get upstream IRQ %d\n", dev->name,
-		       dev->pci->irq);
+		pr_err("%s: can't get upstream IRQ %d\n",
+		       dev->name, dev->pci->irq);
 		goto fail_irq;
 	}
 
@@ -726,7 +725,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	int str_length = 0;
 
 	if (dev->_audio_is_running) {
-		printk(KERN_WARNING "Audio Channel is still running so return!\n");
+		pr_warn("Audio Channel is still running so return!\n");
 		return 0;
 	}
 
@@ -740,7 +739,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 
 	if (!dev->_irq_audio_queues) {
 		printk(KERN_DEBUG
-			"cx25821 ERROR: create_singlethread_workqueue() for Audio FAILED!\n");
+		       pr_fmt("ERROR: create_singlethread_workqueue() for Audio FAILED!\n"));
 		return -ENOMEM;
 	}
 
@@ -787,8 +786,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
 	retval =
 	    cx25821_audio_upstream_buffer_prepare(dev, sram_ch, _line_size);
 	if (retval < 0) {
-		printk(KERN_ERR
-		       "%s: Failed to set up Audio upstream buffers!\n",
+		pr_err("%s: Failed to set up Audio upstream buffers!\n",
 		       dev->name);
 		goto error;
 	}
diff --git a/drivers/staging/cx25821/cx25821-cards.c b/drivers/staging/cx25821/cx25821-cards.c
index da0f56d..94e8d68 100644
--- a/drivers/staging/cx25821/cx25821-cards.c
+++ b/drivers/staging/cx25821/cx25821-cards.c
@@ -21,6 +21,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/pci.h>
diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 300da31..a216b62 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -21,6 +21,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/i2c.h>
 #include <linux/slab.h>
 #include "cx25821.h"
@@ -332,7 +334,7 @@ struct cx25821_dmaqueue mpegq;
 
 static int cx25821_risc_decode(u32 risc)
 {
-	static char *instr[16] = {
+	static const char * const instr[16] = {
 		[RISC_SYNC >> 28] = "sync",
 		[RISC_WRITE >> 28] = "write",
 		[RISC_WRITEC >> 28] = "writec",
@@ -344,7 +346,7 @@ static int cx25821_risc_decode(u32 risc)
 		[RISC_WRITECM >> 28] = "writecm",
 		[RISC_WRITECR >> 28] = "writecr",
 	};
-	static int incr[16] = {
+	static const int incr[16] = {
 		[RISC_WRITE >> 28] = 3,
 		[RISC_JUMP >> 28] = 3,
 		[RISC_SKIP >> 28] = 1,
@@ -353,7 +355,7 @@ static int cx25821_risc_decode(u32 risc)
 		[RISC_WRITECM >> 28] = 3,
 		[RISC_WRITECR >> 28] = 4,
 	};
-	static char *bits[] = {
+	static const char * const bits[] = {
 		"12", "13", "14", "resync",
 		"cnt0", "cnt1", "18", "19",
 		"20", "21", "22", "23",
@@ -361,13 +363,13 @@ static int cx25821_risc_decode(u32 risc)
 	};
 	int i;
 
-	printk("0x%08x [ %s", risc,
-	       instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
+	pr_cont("0x%08x [ %s",
+		risc, instr[risc >> 28] ? instr[risc >> 28] : "INVALID");
 	for (i = ARRAY_SIZE(bits) - 1; i >= 0; i--) {
 		if (risc & (1 << (i + 12)))
-			printk(" %s", bits[i]);
+			pr_cont(" %s", bits[i]);
 	}
-	printk(" count=%d ]\n", risc & 0xfff);
+	pr_cont(" count=%d ]\n", risc & 0xfff);
 	return incr[risc >> 28] ? incr[risc >> 28] : 1;
 }
 
@@ -620,16 +622,15 @@ void cx25821_sram_channel_dump(struct cx25821_dev *dev, struct sram_channel *ch)
 	u32 risc;
 	unsigned int i, j, n;
 
-	printk(KERN_WARNING "%s: %s - dma channel status dump\n", dev->name,
-	       ch->name);
+	pr_warn("%s: %s - dma channel status dump\n", dev->name, ch->name);
 	for (i = 0; i < ARRAY_SIZE(name); i++)
-		printk(KERN_WARNING "cmds + 0x%2x:   %-15s: 0x%08x\n", i * 4,
-		       name[i], cx_read(ch->cmds_start + 4 * i));
+		pr_warn("cmds + 0x%2x:   %-15s: 0x%08x\n",
+			i * 4, name[i], cx_read(ch->cmds_start + 4 * i));
 
 	j = i * 4;
 	for (i = 0; i < 4;) {
 		risc = cx_read(ch->cmds_start + 4 * (i + 14));
-		printk(KERN_WARNING "cmds + 0x%2x:   risc%d: ", j + i * 4, i);
+		pr_warn("cmds + 0x%2x:   risc%d: ", j + i * 4, i);
 		i += cx25821_risc_decode(risc);
 	}
 
@@ -637,36 +638,35 @@ void cx25821_sram_channel_dump(struct cx25821_dev *dev, struct sram_channel *ch)
 		risc = cx_read(ch->ctrl_start + 4 * i);
 		/* No consideration for bits 63-32 */
 
-		printk(KERN_WARNING "ctrl + 0x%2x (0x%08x): iq %x: ", i * 4,
-		       ch->ctrl_start + 4 * i, i);
+		pr_warn("ctrl + 0x%2x (0x%08x): iq %x: ",
+			i * 4, ch->ctrl_start + 4 * i, i);
 		n = cx25821_risc_decode(risc);
 		for (j = 1; j < n; j++) {
 			risc = cx_read(ch->ctrl_start + 4 * (i + j));
-			printk(KERN_WARNING
-			       "ctrl + 0x%2x :   iq %x: 0x%08x [ arg #%d ]\n",
-			       4 * (i + j), i + j, risc, j);
+			pr_warn("ctrl + 0x%2x :   iq %x: 0x%08x [ arg #%d ]\n",
+				4 * (i + j), i + j, risc, j);
 		}
 	}
 
-	printk(KERN_WARNING "        :   fifo: 0x%08x -> 0x%x\n",
-	       ch->fifo_start, ch->fifo_start + ch->fifo_size);
-	printk(KERN_WARNING "        :   ctrl: 0x%08x -> 0x%x\n",
-	       ch->ctrl_start, ch->ctrl_start + 6 * 16);
-	printk(KERN_WARNING "        :   ptr1_reg: 0x%08x\n",
-	       cx_read(ch->ptr1_reg));
-	printk(KERN_WARNING "        :   ptr2_reg: 0x%08x\n",
-	       cx_read(ch->ptr2_reg));
-	printk(KERN_WARNING "        :   cnt1_reg: 0x%08x\n",
-	       cx_read(ch->cnt1_reg));
-	printk(KERN_WARNING "        :   cnt2_reg: 0x%08x\n",
-	       cx_read(ch->cnt2_reg));
+	pr_warn("        :   fifo: 0x%08x -> 0x%x\n",
+		ch->fifo_start, ch->fifo_start + ch->fifo_size);
+	pr_warn("        :   ctrl: 0x%08x -> 0x%x\n",
+		ch->ctrl_start, ch->ctrl_start + 6 * 16);
+	pr_warn("        :   ptr1_reg: 0x%08x\n",
+		cx_read(ch->ptr1_reg));
+	pr_warn("        :   ptr2_reg: 0x%08x\n",
+		cx_read(ch->ptr2_reg));
+	pr_warn("        :   cnt1_reg: 0x%08x\n",
+		cx_read(ch->cnt1_reg));
+	pr_warn("        :   cnt2_reg: 0x%08x\n",
+		cx_read(ch->cnt2_reg));
 }
 EXPORT_SYMBOL(cx25821_sram_channel_dump);
 
 void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
 				     struct sram_channel *ch)
 {
-	static char *name[] = {
+	static const char * const name[] = {
 		"init risc lo",
 		"init risc hi",
 		"cdt base",
@@ -686,18 +686,18 @@ void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
 	u32 risc, value, tmp;
 	unsigned int i, j, n;
 
-	printk(KERN_INFO "\n%s: %s - dma Audio channel status dump\n",
-	       dev->name, ch->name);
+	pr_info("\n%s: %s - dma Audio channel status dump\n",
+		dev->name, ch->name);
 
 	for (i = 0; i < ARRAY_SIZE(name); i++)
-		printk(KERN_INFO "%s: cmds + 0x%2x:   %-15s: 0x%08x\n",
-		       dev->name, i * 4, name[i],
-		       cx_read(ch->cmds_start + 4 * i));
+		pr_info("%s: cmds + 0x%2x:   %-15s: 0x%08x\n",
+			dev->name, i * 4, name[i],
+			cx_read(ch->cmds_start + 4 * i));
 
 	j = i * 4;
 	for (i = 0; i < 4;) {
 		risc = cx_read(ch->cmds_start + 4 * (i + 14));
-		printk(KERN_WARNING "cmds + 0x%2x:   risc%d: ", j + i * 4, i);
+		pr_warn("cmds + 0x%2x:   risc%d: ", j + i * 4, i);
 		i += cx25821_risc_decode(risc);
 	}
 
@@ -705,44 +705,43 @@ void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
 		risc = cx_read(ch->ctrl_start + 4 * i);
 		/* No consideration for bits 63-32 */
 
-		printk(KERN_WARNING "ctrl + 0x%2x (0x%08x): iq %x: ", i * 4,
-		       ch->ctrl_start + 4 * i, i);
+		pr_warn("ctrl + 0x%2x (0x%08x): iq %x: ",
+			i * 4, ch->ctrl_start + 4 * i, i);
 		n = cx25821_risc_decode(risc);
 
 		for (j = 1; j < n; j++) {
 			risc = cx_read(ch->ctrl_start + 4 * (i + j));
-			printk(KERN_WARNING
-			       "ctrl + 0x%2x :   iq %x: 0x%08x [ arg #%d ]\n",
-			       4 * (i + j), i + j, risc, j);
+			pr_warn("ctrl + 0x%2x :   iq %x: 0x%08x [ arg #%d ]\n",
+				4 * (i + j), i + j, risc, j);
 		}
 	}
 
-	printk(KERN_WARNING "        :   fifo: 0x%08x -> 0x%x\n",
-	       ch->fifo_start, ch->fifo_start + ch->fifo_size);
-	printk(KERN_WARNING "        :   ctrl: 0x%08x -> 0x%x\n",
-	       ch->ctrl_start, ch->ctrl_start + 6 * 16);
-	printk(KERN_WARNING "        :   ptr1_reg: 0x%08x\n",
-	       cx_read(ch->ptr1_reg));
-	printk(KERN_WARNING "        :   ptr2_reg: 0x%08x\n",
-	       cx_read(ch->ptr2_reg));
-	printk(KERN_WARNING "        :   cnt1_reg: 0x%08x\n",
-	       cx_read(ch->cnt1_reg));
-	printk(KERN_WARNING "        :   cnt2_reg: 0x%08x\n",
-	       cx_read(ch->cnt2_reg));
+	pr_warn("        :   fifo: 0x%08x -> 0x%x\n",
+		ch->fifo_start, ch->fifo_start + ch->fifo_size);
+	pr_warn("        :   ctrl: 0x%08x -> 0x%x\n",
+		ch->ctrl_start, ch->ctrl_start + 6 * 16);
+	pr_warn("        :   ptr1_reg: 0x%08x\n",
+		cx_read(ch->ptr1_reg));
+	pr_warn("        :   ptr2_reg: 0x%08x\n",
+		cx_read(ch->ptr2_reg));
+	pr_warn("        :   cnt1_reg: 0x%08x\n",
+		cx_read(ch->cnt1_reg));
+	pr_warn("        :   cnt2_reg: 0x%08x\n",
+		cx_read(ch->cnt2_reg));
 
 	for (i = 0; i < 4; i++) {
 		risc = cx_read(ch->cmds_start + 56 + (i * 4));
-		printk(KERN_WARNING "instruction %d = 0x%x\n", i, risc);
+		pr_warn("instruction %d = 0x%x\n", i, risc);
 	}
 
 	/* read data from the first cdt buffer */
 	risc = cx_read(AUD_A_CDT);
-	printk(KERN_WARNING "\nread cdt loc=0x%x\n", risc);
+	pr_warn("\nread cdt loc=0x%x\n", risc);
 	for (i = 0; i < 8; i++) {
 		n = cx_read(risc + i * 4);
-		printk(KERN_WARNING "0x%x ", n);
+		pr_cont("0x%x ", n);
 	}
-	printk(KERN_WARNING "\n\n");
+	pr_cont("\n\n");
 
 	value = cx_read(CLK_RST);
 	CX25821_INFO(" CLK_RST = 0x%x\n\n", value);
@@ -870,7 +869,7 @@ static int cx25821_get_resources(struct cx25821_dev *dev)
 	     dev->name))
 		return 0;
 
-	printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx\n",
+	pr_err("%s: can't get MMIO memory @ 0x%llx\n",
 	       dev->name, (unsigned long long)pci_resource_start(dev->pci, 0));
 
 	return -EBUSY;
@@ -880,8 +879,8 @@ static void cx25821_dev_checkrevision(struct cx25821_dev *dev)
 {
 	dev->hwrevision = cx_read(RDR_CFG2) & 0xff;
 
-	printk(KERN_INFO "%s() Hardware revision = 0x%02x\n", __func__,
-	       dev->hwrevision);
+	pr_info("%s(): Hardware revision = 0x%02x\n",
+		__func__, dev->hwrevision);
 }
 
 static void cx25821_iounmap(struct cx25821_dev *dev)
@@ -901,9 +900,9 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 {
 	int io_size = 0, i;
 
-	printk(KERN_INFO "\n***********************************\n");
-	printk(KERN_INFO "cx25821 set up\n");
-	printk(KERN_INFO "***********************************\n\n");
+	pr_info("\n***********************************\n");
+	pr_info("cx25821 set up\n");
+	pr_info("***********************************\n\n");
 
 	mutex_init(&dev->lock);
 
@@ -920,13 +919,11 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	strcpy(cx25821_boards[CX25821_BOARD].name, "cx25821");
 
 	if (dev->pci->device != 0x8210) {
-		printk(KERN_INFO
-		       "%s() Exiting. Incorrect Hardware device = 0x%02x\n",
-		       __func__, dev->pci->device);
+		pr_info("%s(): Exiting. Incorrect Hardware device = 0x%02x\n",
+			__func__, dev->pci->device);
 		return -1;
 	} else {
-		printk(KERN_INFO "Athena Hardware device = 0x%02x\n",
-		       dev->pci->device);
+		pr_info("Athena Hardware device = 0x%02x\n", dev->pci->device);
 	}
 
 	/* Apply a sensible clock frequency for the PCIe bridge */
@@ -956,8 +953,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	dev->i2c_bus[0].i2c_period = (0x07 << 24);	/* 1.95MHz */
 
 	if (cx25821_get_resources(dev) < 0) {
-		printk(KERN_ERR "%s No more PCIe resources for "
-		       "subsystem: %04x:%04x\n",
+		pr_err("%s: No more PCIe resources for subsystem: %04x:%04x\n",
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
@@ -985,11 +981,11 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	dev->bmmio = (u8 __iomem *) dev->lmmio;
 
-	printk(KERN_INFO "%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
-	       dev->name, dev->pci->subsystem_vendor,
-	       dev->pci->subsystem_device, cx25821_boards[dev->board].name,
-	       dev->board, card[dev->nr] == dev->board ?
-	       "insmod option" : "autodetected");
+	pr_info("%s: subsystem: %04x:%04x, board: %s [card=%d,%s]\n",
+		dev->name, dev->pci->subsystem_vendor,
+		dev->pci->subsystem_device, cx25821_boards[dev->board].name,
+		dev->board, card[dev->nr] == dev->board ?
+		"insmod option" : "autodetected");
 
 	/* init hardware */
 	cx25821_initialize(dev);
@@ -1004,8 +1000,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	cx25821_card_setup(dev);
 
 	if (medusa_video_init(dev) < 0)
-		CX25821_ERR("%s() Failed to initialize medusa!\n"
-		, __func__);
+		CX25821_ERR("%s(): Failed to initialize medusa!\n", __func__);
 
 	cx25821_video_register(dev);
 
@@ -1017,13 +1012,12 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	if (video_register_device
 	    (dev->ioctl_dev, VFL_TYPE_GRABBER, VIDEO_IOCTL_CH) < 0) {
 		cx25821_videoioctl_unregister(dev);
-		printk(KERN_ERR
-		   "%s() Failed to register video adapter for IOCTL, so \
-		   unregistering videoioctl device.\n", __func__);
+		pr_err("%s(): Failed to register video adapter for IOCTL, so unregistering videoioctl device\n",
+		       __func__);
 	}
 
 	cx25821_dev_checkrevision(dev);
-	CX25821_INFO("cx25821 setup done!\n");
+	CX25821_INFO("setup done!\n");
 
 	return 0;
 }
@@ -1362,20 +1356,20 @@ void cx25821_print_irqbits(char *name, char *tag, char **strings,
 {
 	unsigned int i;
 
-	printk(KERN_DEBUG "%s: %s [0x%x]", name, tag, bits);
+	printk(KERN_DEBUG pr_fmt("%s: %s [0x%x]"), name, tag, bits);
 
 	for (i = 0; i < len; i++) {
 		if (!(bits & (1 << i)))
 			continue;
 		if (strings[i])
-			printk(" %s", strings[i]);
+			pr_cont(" %s", strings[i]);
 		else
-			printk(" %d", i);
+			pr_cont(" %d", i);
 		if (!(mask & (1 << i)))
 			continue;
-		printk("*");
+		pr_cont("*");
 	}
-	printk("\n");
+	pr_cont("\n");
 }
 EXPORT_SYMBOL(cx25821_print_irqbits);
 
@@ -1405,12 +1399,12 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 	if (pci_enable_device(pci_dev)) {
 		err = -EIO;
 
-		printk(KERN_INFO "pci enable failed! ");
+		pr_info("pci enable failed!\n");
 
 		goto fail_unregister_device;
 	}
 
-	printk(KERN_INFO "cx25821 Athena pci enable !\n");
+	pr_info("Athena pci enable !\n");
 
 	err = cx25821_dev_setup(dev);
 	if (err) {
@@ -1423,14 +1417,13 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 	/* print pci info */
 	pci_read_config_byte(pci_dev, PCI_CLASS_REVISION, &dev->pci_rev);
 	pci_read_config_byte(pci_dev, PCI_LATENCY_TIMER, &dev->pci_lat);
-	printk(KERN_INFO "%s/0: found at %s, rev: %d, irq: %d, "
-	       "latency: %d, mmio: 0x%llx\n", dev->name,
-	       pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
-	       dev->pci_lat, (unsigned long long)dev->base_io_addr);
+	pr_info("%s/0: found at %s, rev: %d, irq: %d, latency: %d, mmio: 0x%llx\n",
+		dev->name, pci_name(pci_dev), dev->pci_rev, pci_dev->irq,
+		dev->pci_lat, (unsigned long long)dev->base_io_addr);
 
 	pci_set_master(pci_dev);
 	if (!pci_dma_supported(pci_dev, 0xffffffff)) {
-		printk("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
+		pr_err("%s/0: Oops: no 32bit PCI DMA ???\n", dev->name);
 		err = -EIO;
 		goto fail_irq;
 	}
@@ -1440,15 +1433,14 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 			dev->name, dev);
 
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get IRQ %d\n", dev->name,
-		       pci_dev->irq);
+		pr_err("%s: can't get IRQ %d\n", dev->name, pci_dev->irq);
 		goto fail_irq;
 	}
 
 	return 0;
 
 fail_irq:
-	printk(KERN_INFO "cx25821 cx25821_initdev() can't get IRQ !\n");
+	pr_info("cx25821_initdev() can't get IRQ !\n");
 	cx25821_dev_unregister(dev);
 
 fail_unregister_pci:
@@ -1510,9 +1502,10 @@ static struct pci_driver cx25821_pci_driver = {
 static int __init cx25821_init(void)
 {
 	INIT_LIST_HEAD(&cx25821_devlist);
-	printk(KERN_INFO "cx25821 driver version %d.%d.%d loaded\n",
-	       (CX25821_VERSION_CODE >> 16) & 0xff,
-	       (CX25821_VERSION_CODE >> 8) & 0xff, CX25821_VERSION_CODE & 0xff);
+	pr_info("driver version %d.%d.%d loaded\n",
+		(CX25821_VERSION_CODE >> 16) & 0xff,
+		(CX25821_VERSION_CODE >> 8) & 0xff,
+		CX25821_VERSION_CODE & 0xff);
 	return pci_register_driver(&cx25821_pci_driver);
 }
 
diff --git a/drivers/staging/cx25821/cx25821-i2c.c b/drivers/staging/cx25821/cx25821-i2c.c
index 2b14bcc..130dfeb 100644
--- a/drivers/staging/cx25821/cx25821-i2c.c
+++ b/drivers/staging/cx25821/cx25821-i2c.c
@@ -21,6 +21,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "cx25821.h"
 #include <linux/i2c.h>
 
@@ -32,10 +34,11 @@ static unsigned int i2c_scan;
 module_param(i2c_scan, int, 0444);
 MODULE_PARM_DESC(i2c_scan, "scan i2c bus at insmod time");
 
-#define dprintk(level, fmt, arg...)\
-	do { if (i2c_debug >= level)\
-		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
-	} while (0)
+#define dprintk(level, fmt, arg...)					\
+do {									\
+	if (i2c_debug >= level)						\
+		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ##arg);	\
+} while (0)
 
 #define I2C_WAIT_DELAY 32
 #define I2C_WAIT_RETRY 64
@@ -98,7 +101,7 @@ static int i2c_sendbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_slave_did_ack(i2c_adap))
 			return -EIO;
 
-		dprintk(1, "%s() returns 0\n", __func__);
+		dprintk(1, "%s(): returns 0\n", __func__);
 		return 0;
 	}
 
@@ -163,7 +166,7 @@ eio:
 	retval = -EIO;
 err:
 	if (i2c_debug)
-		printk(KERN_ERR " ERR: %d\n", retval);
+		pr_err(" ERR: %d\n", retval);
 	return retval;
 }
 
@@ -187,7 +190,7 @@ static int i2c_readbytes(struct i2c_adapter *i2c_adap,
 		if (!i2c_slave_did_ack(i2c_adap))
 			return -EIO;
 
-		dprintk(1, "%s() returns 0\n", __func__);
+		dprintk(1, "%s(): returns 0\n", __func__);
 		return 0;
 	}
 
@@ -227,7 +230,7 @@ eio:
 	retval = -EIO;
 err:
 	if (i2c_debug)
-		printk(KERN_ERR " ERR: %d\n", retval);
+		pr_err(" ERR: %d\n", retval);
 	return retval;
 }
 
diff --git a/drivers/staging/cx25821/cx25821-medusa-video.c b/drivers/staging/cx25821/cx25821-medusa-video.c
index 1e11e0c..fc780d0 100644
--- a/drivers/staging/cx25821/cx25821-medusa-video.c
+++ b/drivers/staging/cx25821/cx25821-medusa-video.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "cx25821.h"
 #include "cx25821-medusa-video.h"
 #include "cx25821-biffuncs.h"
@@ -499,9 +501,8 @@ void medusa_set_resolution(struct cx25821_dev *dev, int width,
 
 	/* validate the width - cannot be negative */
 	if (width > MAX_WIDTH) {
-		printk
-		    ("cx25821 %s() : width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
-		     __func__, width, MAX_WIDTH);
+		pr_info("%s(): width %d > MAX_WIDTH %d ! resetting to MAX_WIDTH\n",
+			__func__, width, MAX_WIDTH);
 		width = MAX_WIDTH;
 	}
 
diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
index 405e2db..e2efacd 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "cx25821-video.h"
 #include "cx25821-video-upstream-ch2.h"
 
@@ -211,8 +213,7 @@ void cx25821_stop_upstream_video_ch2(struct cx25821_dev *dev)
 	u32 tmp = 0;
 
 	if (!dev->_is_running_ch2) {
-		printk
-		    ("cx25821: No video file is currently running so return!\n");
+		pr_info("No video file is currently running so return!\n");
 		return;
 	}
 	/* Disable RISC interrupts */
@@ -301,19 +302,19 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 	myfile = filp_open(dev->_filename_ch2, O_RDONLY | O_LARGEFILE, 0);
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
-			__func__, dev->_filename_ch2, open_errno);
+		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
+		       __func__, dev->_filename_ch2, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk("%s: File has no file operations registered!",
+			pr_err("%s(): File has no file operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk("%s: File has no READ operations registered!",
+			pr_err("%s(): File has no READ operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
@@ -340,9 +341,8 @@ int cx25821_get_frame_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			frame_offset += vfs_read_retval;
 
 			if (vfs_read_retval < line_size) {
-				printk(KERN_INFO
-				       "Done: exit %s() since no more bytes to read from Video file.\n",
-				       __func__);
+				pr_info("Done: exit %s() since no more bytes to read from Video file\n",
+					__func__);
 				break;
 			}
 		}
@@ -366,8 +366,8 @@ static void cx25821_vidups_handler_ch2(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _irq_work_entry_ch2);
 
 	if (!dev) {
-		printk("ERROR %s(): since container_of(work_struct) FAILED!\n",
-			__func__);
+		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
+		       __func__);
 		return;
 	}
 
@@ -393,21 +393,20 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk("%s(): ERROR opening file(%s) with errno = %d!\n",
-			__func__, dev->_filename_ch2, open_errno);
+		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
+		       __func__, dev->_filename_ch2, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk("%s: File has no file operations registered!",
+			pr_err("%s(): File has no file operations registered!\n",
 			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk
-			    ("%s: File has no READ operations registered!  Returning.",
-			     __func__);
+			pr_err("%s(): File has no READ operations registered!  Returning\n",
+			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
@@ -435,9 +434,8 @@ int cx25821_openfile_ch2(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 				offset += vfs_read_retval;
 
 				if (vfs_read_retval < line_size) {
-					printk(KERN_INFO
-					       "Done: exit %s() since no more bytes to read from Video file.\n",
-					       __func__);
+					pr_info("Done: exit %s() since no more bytes to read from Video file\n",
+						__func__);
 					break;
 				}
 			}
@@ -483,8 +481,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 	dev->_risc_size_ch2 = dev->upstream_riscbuf_size_ch2;
 
 	if (!dev->_dma_virt_addr_ch2) {
-		printk
-		    ("cx25821: FAILED to allocate memory for Risc buffer! Returning.\n");
+		pr_err("FAILED to allocate memory for Risc buffer! Returning\n");
 		return -ENOMEM;
 	}
 
@@ -504,8 +501,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 	dev->_data_buf_size_ch2 = dev->upstream_databuf_size_ch2;
 
 	if (!dev->_data_buf_virt_addr_ch2) {
-		printk
-		    ("cx25821: FAILED to allocate memory for data buffer! Returning.\n");
+		pr_err("FAILED to allocate memory for data buffer! Returning\n");
 		return -ENOMEM;
 	}
 
@@ -521,8 +517,7 @@ static int cx25821_upstream_buffer_prepare_ch2(struct cx25821_dev *dev,
 	    cx25821_risc_buffer_upstream_ch2(dev, dev->pci, 0, bpl,
 					     dev->_lines_count_ch2);
 	if (ret < 0) {
-		printk(KERN_INFO
-			"cx25821: Failed creating Video Upstream Risc programs!\n");
+		pr_info("Failed creating Video Upstream Risc programs!\n");
 		goto error;
 	}
 
@@ -602,8 +597,8 @@ int cx25821_video_upstream_irq_ch2(struct cx25821_dev *dev, int chan_num,
 	}
 
 	if (dev->_file_status_ch2 == END_OF_FILE) {
-		printk("cx25821: EOF Channel 2 Framecount = %d\n",
-		       dev->_frame_count_ch2);
+		pr_info("EOF Channel 2 Framecount = %d\n",
+			dev->_frame_count_ch2);
 		return -1;
 	}
 	/* ElSE, set the interrupt mask register, re-enable irq. */
@@ -714,8 +709,8 @@ int cx25821_start_video_dma_upstream_ch2(struct cx25821_dev *dev,
 	    request_irq(dev->pci->irq, cx25821_upstream_irq_ch2,
 			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get upstream IRQ %d\n", dev->name,
-		       dev->pci->irq);
+		pr_err("%s: can't get upstream IRQ %d\n",
+		       dev->name, dev->pci->irq);
 		goto fail_irq;
 	}
 	/* Start the DMA  engine */
@@ -744,7 +739,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	int str_length = 0;
 
 	if (dev->_is_running_ch2) {
-		printk("Video Channel is still running so return!\n");
+		pr_info("Video Channel is still running so return!\n");
 		return 0;
 	}
 
@@ -756,8 +751,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	    create_singlethread_workqueue("cx25821_workqueue2");
 
 	if (!dev->_irq_queues_ch2) {
-		printk
-		    ("cx25821: create_singlethread_workqueue() for Video FAILED!\n");
+		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
 		return -ENOMEM;
 	}
 	/*
@@ -829,8 +823,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
 	    cx25821_upstream_buffer_prepare_ch2(dev, sram_ch,
 						dev->_line_size_ch2);
 	if (retval < 0) {
-		printk(KERN_ERR
-		       "%s: Failed to set up Video upstream buffers!\n",
+		pr_err("%s: Failed to set up Video upstream buffers!\n",
 		       dev->name);
 		goto error;
 	}
diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
index 16bf74d..31b4e3c 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream.c
+++ b/drivers/staging/cx25821/cx25821-video-upstream.c
@@ -20,6 +20,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "cx25821-video.h"
 #include "cx25821-video-upstream.h"
 
@@ -257,8 +259,7 @@ void cx25821_stop_upstream_video_ch1(struct cx25821_dev *dev)
 	u32 tmp = 0;
 
 	if (!dev->_is_running) {
-		printk
-		   (KERN_INFO "cx25821: No video file is currently running so return!\n");
+		pr_info("No video file is currently running so return!\n");
 		return;
 	}
 	/* Disable RISC interrupts */
@@ -346,23 +347,20 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-		printk(KERN_ERR
-		   "%s(): ERROR opening file(%s) with errno = %d!\n",
-		   __func__, dev->_filename, open_errno);
+		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
+		       __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk(KERN_ERR
-			   "%s: File has no file operations registered!",
-			   __func__);
+			pr_err("%s(): File has no file operations registered!\n",
+			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk(KERN_ERR
-			   "%s: File has no READ operations registered!",
-			   __func__);
+			pr_err("%s(): File has no READ operations registered!\n",
+			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
@@ -388,10 +386,8 @@ int cx25821_get_frame(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 			frame_offset += vfs_read_retval;
 
 			if (vfs_read_retval < line_size) {
-				printk(KERN_INFO
-				      "Done: exit %s() since no more bytes to \
-				      read from Video file.\n",
-				       __func__);
+				pr_info("Done: exit %s() since no more bytes to read from Video file\n",
+					__func__);
 				break;
 			}
 		}
@@ -415,9 +411,8 @@ static void cx25821_vidups_handler(struct work_struct *work)
 	    container_of(work, struct cx25821_dev, _irq_work_entry);
 
 	if (!dev) {
-		printk(KERN_ERR
-		   "ERROR %s(): since container_of(work_struct) FAILED!\n",
-		   __func__);
+		pr_err("ERROR %s(): since container_of(work_struct) FAILED!\n",
+		       __func__);
 		return;
 	}
 
@@ -443,23 +438,20 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 
 	if (IS_ERR(myfile)) {
 		const int open_errno = -PTR_ERR(myfile);
-	       printk(KERN_ERR  "%s(): ERROR opening file(%s) with errno = %d!\n",
+		pr_err("%s(): ERROR opening file(%s) with errno = %d!\n",
 		       __func__, dev->_filename, open_errno);
 		return PTR_ERR(myfile);
 	} else {
 		if (!(myfile->f_op)) {
-			printk(KERN_ERR
-			   "%s: File has no file operations registered!",
-			   __func__);
+			pr_err("%s(): File has no file operations registered!\n",
+			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
 
 		if (!myfile->f_op->read) {
-			printk(KERN_ERR
-			   "%s: File has no READ operations registered!  \
-			   Returning.",
-			     __func__);
+			pr_err("%s(): File has no READ operations registered!  Returning\n",
+			       __func__);
 			filp_close(myfile, NULL);
 			return -EIO;
 		}
@@ -487,10 +479,8 @@ int cx25821_openfile(struct cx25821_dev *dev, struct sram_channel *sram_ch)
 				offset += vfs_read_retval;
 
 				if (vfs_read_retval < line_size) {
-					printk(KERN_INFO
-					    "Done: exit %s() since no more \
-					    bytes to read from Video file.\n",
-					       __func__);
+					pr_info("Done: exit %s() since no more bytes to read from Video file\n",
+						__func__);
 					break;
 				}
 			}
@@ -534,9 +524,7 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 	dev->_risc_size = dev->upstream_riscbuf_size;
 
 	if (!dev->_dma_virt_addr) {
-		printk
-		   (KERN_ERR "cx25821: FAILED to allocate memory for Risc \
-		   buffer! Returning.\n");
+		pr_err("FAILED to allocate memory for Risc buffer! Returning\n");
 		return -ENOMEM;
 	}
 
@@ -556,9 +544,7 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 	dev->_data_buf_size = dev->upstream_databuf_size;
 
 	if (!dev->_data_buf_virt_addr) {
-		printk
-		   (KERN_ERR "cx25821: FAILED to allocate memory for data \
-		   buffer! Returning.\n");
+		pr_err("FAILED to allocate memory for data buffer! Returning\n");
 		return -ENOMEM;
 	}
 
@@ -574,8 +560,7 @@ int cx25821_upstream_buffer_prepare(struct cx25821_dev *dev,
 	    cx25821_risc_buffer_upstream(dev, dev->pci, 0, bpl,
 					 dev->_lines_count);
 	if (ret < 0) {
-		printk(KERN_INFO
-		    "cx25821: Failed creating Video Upstream Risc programs!\n");
+		pr_info("Failed creating Video Upstream Risc programs!\n");
 		goto error;
 	}
 
@@ -652,22 +637,20 @@ int cx25821_video_upstream_irq(struct cx25821_dev *dev, int chan_num,
 		spin_unlock(&dev->slock);
 	} else {
 		if (status & FLD_VID_SRC_UF)
-			printk
-			   (KERN_ERR "%s: Video Received Underflow Error \
-			   Interrupt!\n", __func__);
+			pr_err("%s(): Video Received Underflow Error Interrupt!\n",
+			       __func__);
 
 		if (status & FLD_VID_SRC_SYNC)
-			printk(KERN_ERR "%s: Video Received Sync Error \
-				Interrupt!\n", __func__);
+			pr_err("%s(): Video Received Sync Error Interrupt!\n",
+			       __func__);
 
 		if (status & FLD_VID_SRC_OPC_ERR)
-			printk(KERN_ERR "%s: Video Received OpCode Error \
-				Interrupt!\n", __func__);
+			pr_err("%s(): Video Received OpCode Error Interrupt!\n",
+			       __func__);
 	}
 
 	if (dev->_file_status == END_OF_FILE) {
-		printk(KERN_ERR "cx25821: EOF Channel 1 Framecount = %d\n",
-		       dev->_frame_count);
+		pr_err("EOF Channel 1 Framecount = %d\n", dev->_frame_count);
 		return -1;
 	}
 	/* ElSE, set the interrupt mask register, re-enable irq. */
@@ -775,8 +758,8 @@ int cx25821_start_video_dma_upstream(struct cx25821_dev *dev,
 	    request_irq(dev->pci->irq, cx25821_upstream_irq,
 			IRQF_SHARED | IRQF_DISABLED, dev->name, dev);
 	if (err < 0) {
-		printk(KERN_ERR "%s: can't get upstream IRQ %d\n", dev->name,
-		       dev->pci->irq);
+		pr_err("%s: can't get upstream IRQ %d\n",
+		       dev->name, dev->pci->irq);
 		goto fail_irq;
 	}
 
@@ -806,7 +789,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	int str_length = 0;
 
 	if (dev->_is_running) {
-		printk(KERN_INFO "Video Channel is still running so return!\n");
+		pr_info("Video Channel is still running so return!\n");
 		return 0;
 	}
 
@@ -817,9 +800,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	dev->_irq_queues = create_singlethread_workqueue("cx25821_workqueue");
 
 	if (!dev->_irq_queues) {
-		printk
-		   (KERN_ERR "cx25821: create_singlethread_workqueue() for \
-		   Video FAILED!\n");
+		pr_err("create_singlethread_workqueue() for Video FAILED!\n");
 		return -ENOMEM;
 	}
 	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
@@ -895,8 +876,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
 	/* Allocating buffers and prepare RISC program */
 	retval = cx25821_upstream_buffer_prepare(dev, sram_ch, dev->_line_size);
 	if (retval < 0) {
-		printk(KERN_ERR
-		       "%s: Failed to set up Video upstream buffers!\n",
+		pr_err("%s: Failed to set up Video upstream buffers!\n",
 		       dev->name);
 		goto error;
 	}
diff --git a/drivers/staging/cx25821/cx25821-video.c b/drivers/staging/cx25821/cx25821-video.c
index e7f1d57..4e184e8 100644
--- a/drivers/staging/cx25821/cx25821-video.c
+++ b/drivers/staging/cx25821/cx25821-video.c
@@ -24,6 +24,8 @@
  *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include "cx25821-video.h"
 
 MODULE_DESCRIPTION("v4l2 driver module for cx25821 based TV cards");
@@ -104,7 +106,7 @@ struct cx25821_fmt *format_by_fourcc(unsigned int fourcc)
 		if (formats[i].fourcc == fourcc)
 			return formats + i;
 
-	printk(KERN_ERR "%s(0x%08x) NOT FOUND\n", __func__, fourcc);
+	pr_err("%s(0x%08x) NOT FOUND\n", __func__, fourcc);
 	return NULL;
 }
 
@@ -159,15 +161,15 @@ void cx25821_video_wakeup(struct cx25821_dev *dev, struct cx25821_dmaqueue *q,
 	else
 		mod_timer(&q->timeout, jiffies + BUFFER_TIMEOUT);
 	if (bc != 1)
-		printk(KERN_ERR "%s: %d buffers handled (should be 1)\n",
+		pr_err("%s: %d buffers handled (should be 1)\n",
 		       __func__, bc);
 }
 
 #ifdef TUNER_FLAG
 int cx25821_set_tvnorm(struct cx25821_dev *dev, v4l2_std_id norm)
 {
-	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n", __func__,
-		(unsigned int)norm, v4l2_norm_to_name(norm));
+	dprintk(1, "%s(norm = 0x%08x) name: [%s]\n",
+		__func__, (unsigned int)norm, v4l2_norm_to_name(norm));
 
 	dev->tvnorm = norm;
 
@@ -267,7 +269,7 @@ int cx25821_video_mux(struct cx25821_dev *dev, unsigned int input)
 	struct v4l2_routing route;
 	memset(&route, 0, sizeof(route));
 
-	dprintk(1, "%s() video_mux: %d [vmux=%d, gpio=0x%x,0x%x,0x%x,0x%x]\n",
+	dprintk(1, "%s(): video_mux: %d [vmux=%d, gpio=0x%x,0x%x,0x%x,0x%x]\n",
 		__func__, input, INPUT(input)->vmux, INPUT(input)->gpio0,
 		INPUT(input)->gpio1, INPUT(input)->gpio2, INPUT(input)->gpio3);
 	dev->input = input;
@@ -400,8 +402,8 @@ int cx25821_video_irq(struct cx25821_dev *dev, int chan_num, u32 status)
 
 	/* risc op code error */
 	if (status & (1 << 16)) {
-		printk(KERN_WARNING "%s, %s: video risc op code error\n",
-		       dev->name, channel->name);
+		pr_warn("%s, %s: video risc op code error\n",
+			dev->name, channel->name);
 		cx_clear(channel->dma_ctl, 0x11);
 		cx25821_sram_channel_dump(dev, channel);
 	}
@@ -458,7 +460,7 @@ void cx25821_video_unregister(struct cx25821_dev *dev, int chan_num)
 	       btcx_riscmem_free(dev->pci,
 		       &dev->channels[chan_num].vidq.stopper);
 
-		printk(KERN_WARNING "device %d released!\n", chan_num);
+		pr_warn("device %d released!\n", chan_num);
 	}
 
 }
@@ -590,7 +592,7 @@ int cx25821_buffer_prepare(struct videobuf_queue *q, struct videobuf_buffer *vb,
 		init_buffer = 1;
 		rc = videobuf_iolock(q, &buf->vb, NULL);
 		if (0 != rc) {
-			printk(KERN_DEBUG "videobuf_iolock failed!\n");
+			printk(KERN_DEBUG pr_fmt("videobuf_iolock failed!\n"));
 			goto fail;
 		}
 	}
@@ -1038,8 +1040,8 @@ static int vidioc_s_fmt_vid_cap(struct file *file, void *priv,
        dev->channels[fh->channel_id].cif_width = fh->width;
        medusa_set_resolution(dev, fh->width, SRAM_CH00);
 
-       dprintk(2, "%s() width=%d height=%d field=%d\n", __func__, fh->width,
-	       fh->height, fh->vidq.field);
+	dprintk(2, "%s(): width=%d height=%d field=%d\n", __func__, fh->width,
+		fh->height, fh->vidq.field);
 	v4l2_fill_mbus_format(&mbus_fmt, &f->fmt.pix, V4L2_MBUS_FMT_FIXED);
 	cx25821_call_all(dev, video, s_mbus_fmt, &mbus_fmt);
 
@@ -1070,14 +1072,14 @@ static int vidioc_log_status(struct file *file, void *priv)
        u32 tmp = 0;
 
        snprintf(name, sizeof(name), "%s/2", dev->name);
-       printk(KERN_INFO "%s/2: ============  START LOG STATUS  ============\n",
-	      dev->name);
+	pr_info("%s/2: ============  START LOG STATUS  ============\n",
+		dev->name);
        cx25821_call_all(dev, core, log_status);
        tmp = cx_read(sram_ch->dma_ctl);
-       printk(KERN_INFO "Video input 0 is %s\n",
-	      (tmp & 0x11) ? "streaming" : "stopped");
-       printk(KERN_INFO "%s/2: =============  END LOG STATUS  =============\n",
-	      dev->name);
+	pr_info("Video input 0 is %s\n",
+		(tmp & 0x11) ? "streaming" : "stopped");
+	pr_info("%s/2: =============  END LOG STATUS  =============\n",
+		dev->name);
        return 0;
 }
 
@@ -1319,7 +1321,7 @@ int cx25821_vidioc_g_input(struct file *file, void *priv, unsigned int *i)
 	struct cx25821_dev *dev = ((struct cx25821_fh *)priv)->dev;
 
 	*i = dev->input;
-	dprintk(1, "%s() returns %d\n", __func__, *i);
+	dprintk(1, "%s(): returns %d\n", __func__, *i);
 	return 0;
 }
 
@@ -1339,7 +1341,7 @@ int cx25821_vidioc_s_input(struct file *file, void *priv, unsigned int i)
 	}
 
 	if (i > 2) {
-		dprintk(1, "%s() -EINVAL\n", __func__);
+		dprintk(1, "%s(): -EINVAL\n", __func__);
 		return -EINVAL;
 	}
 
@@ -1390,7 +1392,7 @@ int cx25821_vidioc_s_frequency(struct file *file, void *priv, struct v4l2_freque
 		if (0 != err)
 			return err;
        } else {
-	       printk(KERN_ERR "Invalid fh pointer!\n");
+	       pr_err("Invalid fh pointer!\n");
 	       return -EINVAL;
 	}
 
@@ -1733,12 +1735,10 @@ static long video_ioctl_upstream9(struct file *file, unsigned int cmd,
 
        data_from_user = (struct upstream_user_struct *)arg;
 
-       if (!data_from_user) {
-	       printk
-		   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
-		    __func__);
-	       return 0;
-       }
+	if (!data_from_user) {
+		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
+		return 0;
+	}
 
        command = data_from_user->command;
 
@@ -1776,12 +1776,10 @@ static long video_ioctl_upstream10(struct file *file, unsigned int cmd,
 
        data_from_user = (struct upstream_user_struct *)arg;
 
-       if (!data_from_user) {
-	       printk
-		   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
-		    __func__);
-	       return 0;
-       }
+	if (!data_from_user) {
+		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
+		return 0;
+	}
 
        command = data_from_user->command;
 
@@ -1819,12 +1817,10 @@ static long video_ioctl_upstream11(struct file *file, unsigned int cmd,
 
        data_from_user = (struct upstream_user_struct *)arg;
 
-       if (!data_from_user) {
-	       printk
-		   ("cx25821 in %s(): Upstream data is INVALID. Returning.\n",
-		    __func__);
-	       return 0;
-       }
+	if (!data_from_user) {
+		pr_err("%s(): Upstream data is INVALID. Returning\n", __func__);
+		return 0;
+	}
 
        command = data_from_user->command;
 
@@ -1866,12 +1862,10 @@ static long video_ioctl_set(struct file *file, unsigned int cmd,
 
        data_from_user = (struct downstream_user_struct *)arg;
 
-       if (!data_from_user) {
-	       printk(
-	       "cx25821 in %s(): User data is INVALID. Returning.\n",
-	       __func__);
-	       return 0;
-       }
+	if (!data_from_user) {
+		pr_err("%s(): User data is INVALID. Returning\n", __func__);
+		return 0;
+	}
 
        command = data_from_user->command;
 
diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
index cc6034b..e9497f4 100644
--- a/drivers/staging/cx25821/cx25821-video.h
+++ b/drivers/staging/cx25821/cx25821-video.h
@@ -49,10 +49,11 @@
 
 #define VIDEO_DEBUG 0
 
-#define dprintk(level, fmt, arg...)\
-    do { if (VIDEO_DEBUG >= level)\
-	printk(KERN_DEBUG "%s/0: " fmt, dev->name, ## arg);\
-    } while (0)
+#define dprintk(level, fmt, arg...)					\
+do {									\
+	if (VIDEO_DEBUG >= level)					\
+		printk(KERN_DEBUG "%s/0: " fmt, dev->name, ##arg);	\
+} while (0)
 
 /* For IOCTL to identify running upstream */
 #define UPSTREAM_START_VIDEO        700
diff --git a/drivers/staging/cx25821/cx25821.h b/drivers/staging/cx25821/cx25821.h
index c940001..5511523 100644
--- a/drivers/staging/cx25821/cx25821.h
+++ b/drivers/staging/cx25821/cx25821.h
@@ -519,9 +519,12 @@ extern struct sram_channel cx25821_sram_channels[];
 #define Set_GPIO_Bit(Bit)                       (1 << Bit)
 #define Clear_GPIO_Bit(Bit)                     (~(1 << Bit))
 
-#define CX25821_ERR(fmt, args...)      printk(KERN_ERR  "cx25821(%d): " fmt, dev->board, ## args)
-#define CX25821_WARN(fmt, args...)     printk(KERN_WARNING "cx25821(%d): " fmt, dev->board , ## args)
-#define CX25821_INFO(fmt, args...)     printk(KERN_INFO "cx25821(%d): " fmt, dev->board , ## args)
+#define CX25821_ERR(fmt, args...)			\
+	pr_err("(%d): " fmt, dev->board, ##args)
+#define CX25821_WARN(fmt, args...)			\
+	pr_warn("(%d): " fmt, dev->board, ##args)
+#define CX25821_INFO(fmt, args...)			\
+	pr_info("(%d): " fmt, dev->board, ##args)
 
 extern int cx25821_i2c_register(struct cx25821_i2c *bus);
 extern void cx25821_card_setup(struct cx25821_dev *dev);


