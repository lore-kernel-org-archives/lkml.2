Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1CWNrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:47:33 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:62319 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab1CWNrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:47:32 -0400
Subject: [PATCH v2] sound/oss: remove offset from load_patch callbacks
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, security@kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 09:47:22 -0400
Message-ID: <1300888042.1968.7.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Was: [PATCH] sound/oss/midi_synth: prevent underflow, use of
uninitialized value, and signedness issue

The offset passed to midi_synth_load_patch() can be essentially
arbitrary.  If it's greater than the header length, this will result in
a copy_from_user(dst, src, negative_val).  While this will just return
-EFAULT on x86, on other architectures this may cause memory corruption.
Additionally, the length field of the sysex_info structure may not be
initialized prior to its use.  Finally, a signed comparison may result
in an unintentionally large loop.

On suggestion by Takashi Iwai, version two removes the offset argument
from the load_patch callbacks entirely, which also resolves similar
issues in opl3.  Compile tested only.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: stable@kernel.org
---
 sound/oss/dev_table.h  |    2 +-
 sound/oss/midi_synth.c |   27 ++++++++++++---------------
 sound/oss/midi_synth.h |    2 +-
 sound/oss/opl3.c       |    4 ++--
 sound/oss/sequencer.c  |    2 +-
 5 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/sound/oss/dev_table.h b/sound/oss/dev_table.h
index b7617be..0199a31 100644
--- a/sound/oss/dev_table.h
+++ b/sound/oss/dev_table.h
@@ -271,7 +271,7 @@ struct synth_operations
 	void (*reset) (int dev);
 	void (*hw_control) (int dev, unsigned char *event);
 	int (*load_patch) (int dev, int format, const char __user *addr,
-	     int offs, int count, int pmgr_flag);
+	     int count, int pmgr_flag);
 	void (*aftertouch) (int dev, int voice, int pressure);
 	void (*controller) (int dev, int voice, int ctrl_num, int value);
 	void (*panning) (int dev, int voice, int value);
diff --git a/sound/oss/midi_synth.c b/sound/oss/midi_synth.c
index 3c09374..8d3611c 100644
--- a/sound/oss/midi_synth.c
+++ b/sound/oss/midi_synth.c
@@ -476,7 +476,7 @@ EXPORT_SYMBOL(midi_synth_hw_control);
 
 int
 midi_synth_load_patch(int dev, int format, const char __user *addr,
-		      int offs, int count, int pmgr_flag)
+		      int count, int pmgr_flag)
 {
 	int             orig_dev = synth_devs[dev]->midi_dev;
 
@@ -491,16 +491,14 @@ midi_synth_load_patch(int dev, int format, const char __user *addr,
 	if (!prefix_cmd(orig_dev, 0xf0))
 		return 0;
 
+	/* Invalid patch format */
 	if (format != SYSEX_PATCH)
-	{
-/*		  printk("MIDI Error: Invalid patch format (key) 0x%x\n", format);*/
 		  return -EINVAL;
-	}
+
+	/* Patch header too short */
 	if (count < hdr_size)
-	{
-/*		printk("MIDI Error: Patch header too short\n");*/
 		return -EINVAL;
-	}
+
 	count -= hdr_size;
 
 	/*
@@ -508,16 +506,15 @@ midi_synth_load_patch(int dev, int format, const char __user *addr,
 	 * been transferred already.
 	 */
 
-	if(copy_from_user(&((char *) &sysex)[offs], &(addr)[offs], hdr_size - offs))
+	if (copy_from_user(&sysex, addr, hdr_size))
 		return -EFAULT;
- 
- 	if (count < sysex.len)
-	{
-/*		printk(KERN_WARNING "MIDI Warning: Sysex record too short (%d<%d)\n", count, (int) sysex.len);*/
+
+	/* Sysex record too short */
+	if ((unsigned)count < (unsigned)sysex.len)
 		sysex.len = count;
-	}
-  	left = sysex.len;
-  	src_offs = 0;
+
+	left = sysex.len;
+	src_offs = 0;
 
 	for (i = 0; i < left && !signal_pending(current); i++)
 	{
diff --git a/sound/oss/midi_synth.h b/sound/oss/midi_synth.h
index 6bc9d00..b64ddd6 100644
--- a/sound/oss/midi_synth.h
+++ b/sound/oss/midi_synth.h
@@ -8,7 +8,7 @@ int midi_synth_open (int dev, int mode);
 void midi_synth_close (int dev);
 void midi_synth_hw_control (int dev, unsigned char *event);
 int midi_synth_load_patch (int dev, int format, const char __user * addr,
-		 int offs, int count, int pmgr_flag);
+		 int count, int pmgr_flag);
 void midi_synth_panning (int dev, int channel, int pressure);
 void midi_synth_aftertouch (int dev, int channel, int pressure);
 void midi_synth_controller (int dev, int channel, int ctrl_num, int value);
diff --git a/sound/oss/opl3.c b/sound/oss/opl3.c
index 938c48c..a3bec38 100644
--- a/sound/oss/opl3.c
+++ b/sound/oss/opl3.c
@@ -820,7 +820,7 @@ static void opl3_hw_control(int dev, unsigned char *event)
 }
 
 static int opl3_load_patch(int dev, int format, const char __user *addr,
-		int offs, int count, int pmgr_flag)
+		int count, int pmgr_flag)
 {
 	struct sbi_instrument ins;
 
@@ -834,7 +834,7 @@ static int opl3_load_patch(int dev, int format, const char __user *addr,
 	 * What the fuck is going on here?  We leave junk in the beginning
 	 * of ins and then check the field pretty close to that beginning?
 	 */
-	if(copy_from_user(&((char *) &ins)[offs], addr + offs, sizeof(ins) - offs))
+	if (copy_from_user(&ins, addr, sizeof(ins)))
 		return -EFAULT;
 
 	if (ins.channel < 0 || ins.channel >= SBFM_MAXINSTR)
diff --git a/sound/oss/sequencer.c b/sound/oss/sequencer.c
index 5ea1098..2e842cb 100644
--- a/sound/oss/sequencer.c
+++ b/sound/oss/sequencer.c
@@ -241,7 +241,7 @@ int sequencer_write(int dev, struct file *file, const char __user *buf, int coun
 				return -ENXIO;
 
 			fmt = (*(short *) &event_rec[0]) & 0xffff;
-			err = synth_devs[dev]->load_patch(dev, fmt, buf, p + 4, c, 0);
+			err = synth_devs[dev]->load_patch(dev, fmt, buf, c, 0);
 			if (err < 0)
 				return err;
 


