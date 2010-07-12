Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0GLRxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 13:53:47 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:49156 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074Ab0GLRxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 13:53:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] sound/oss: convert to unlocked_ioctl
Date: Mon, 12 Jul 2010 19:53:18 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4-next-20100709+; KDE/4.4.90; x86_64; ; )
Cc: Jaroslav Kysela <perex@perex.cz>, LKML <linux-kernel@vger.kernel.org>,
        John Kacur <jkacur@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        ALSA development <alsa-devel@alsa-project.org>
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <201007111216.36538.arnd@arndb.de> <s5h1vb8pugz.wl%tiwai@suse.de>
In-Reply-To: <s5h1vb8pugz.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007121953.19531.arnd@arndb.de>
X-Provags-ID: V02:K0:o0KIE/plOXHDDfmVkDIJEsxOp0khA1DmHRGSpBTsWj8
 UgdYBzH5Qj5uS6Xn1OCcxCgAetFs0BUdqNPvAfDPOEL8+ZGnuc
 NPlVXCRaxGs0ZSIMbcXkGsBPoGHJrWAs70szDKRg6aBbNrKdoc
 PR+kTwNKuKVhFST4ctr5eNf665F+JHanTjNq0RKwWVW/dBMhwY
 tCN3WoA4JxKBKBhwyKWJQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the final conversions for the ioctl file operation so we can remove
it in the next merge window.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
---
On Monday 12 July 2010 17:53:32 Takashi Iwai wrote:
> 
> BTW, do you have an updated patch for native_ioctl conversion wrt
> sound/*?

Almost forgot that, thanks for reminding me!

	Arnd
---

 sound/oss/au1550_ac97.c            |   54 ++++++++++++++++++++++-------------
 sound/oss/dmasound/dmasound_core.c |   35 ++++++++++++++++++----
 sound/oss/msnd_pinnacle.c          |   15 ++++++---
 sound/oss/sh_dac_audio.c           |   18 ++++++++++--
 sound/oss/swarm_cs4297a.c          |   24 ++++++++++++---
 sound/oss/vwsnd.c                  |   24 ++++++++-------
 6 files changed, 119 insertions(+), 51 deletions(-)

diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index fb913e5..0fd256c 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -827,22 +827,26 @@ mixdev_ioctl(struct ac97_codec *codec, unsigned int cmd,
 	return codec->mixer_ioctl(codec, cmd, arg);
 }
 
-static int
-au1550_ioctl_mixdev(struct inode *inode, struct file *file,
-			       unsigned int cmd, unsigned long arg)
+static long
+au1550_ioctl_mixdev(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct au1550_state *s = (struct au1550_state *)file->private_data;
 	struct ac97_codec *codec = s->codec;
+	int ret;
+
+	lock_kernel();
+	ret = mixdev_ioctl(codec, cmd, arg);
+	unlock_kernel();
 
-	return mixdev_ioctl(codec, cmd, arg);
+	return ret;
 }
 
 static /*const */ struct file_operations au1550_mixer_fops = {
-	owner:THIS_MODULE,
-	llseek:au1550_llseek,
-	ioctl:au1550_ioctl_mixdev,
-	open:au1550_open_mixdev,
-	release:au1550_release_mixdev,
+	.owner		= THIS_MODULE,
+	.llseek		= au1550_llseek,
+	.unlocked_ioctl	= au1550_ioctl_mixdev,
+	.open		= au1550_open_mixdev,
+	.release	= au1550_release_mixdev,
 };
 
 static int
@@ -1346,8 +1350,7 @@ dma_count_done(struct dmabuf *db)
 
 
 static int
-au1550_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-							unsigned long arg)
+au1550_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct au1550_state *s = (struct au1550_state *)file->private_data;
 	unsigned long   flags;
@@ -1783,6 +1786,17 @@ au1550_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
 	return mixdev_ioctl(s->codec, cmd, arg);
 }
 
+static long
+au1550_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = au1550_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
 
 static int
 au1550_open(struct inode *inode, struct file *file)
@@ -1893,15 +1907,15 @@ au1550_release(struct inode *inode, struct file *file)
 }
 
 static /*const */ struct file_operations au1550_audio_fops = {
-	owner:		THIS_MODULE,
-	llseek:		au1550_llseek,
-	read:		au1550_read,
-	write:		au1550_write,
-	poll:		au1550_poll,
-	ioctl:		au1550_ioctl,
-	mmap:		au1550_mmap,
-	open:		au1550_open,
-	release:	au1550_release,
+	.owner		= THIS_MODULE,
+	.llseek		= au1550_llseek,
+	.read		= au1550_read,
+	.write		= au1550_write,
+	.poll		= au1550_poll,
+	.unlocked_ioctl	= au1550_unlocked_ioctl,
+	.mmap		= au1550_mmap,
+	.open		= au1550_open,
+	.release	= au1550_release,
 };
 
 MODULE_AUTHOR("Advanced Micro Devices (AMD), dan@embeddededge.com");
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index 5a4f38c..6ecd41a 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -341,8 +341,8 @@ static int mixer_release(struct inode *inode, struct file *file)
 	unlock_kernel();
 	return 0;
 }
-static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
-		       u_long arg)
+
+static int mixer_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	if (_SIOC_DIR(cmd) & _SIOC_WRITE)
 	    mixer.modify_counter++;
@@ -366,11 +366,22 @@ static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
 	return -EINVAL;
 }
 
+static long mixer_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = mixer_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations mixer_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= mixer_ioctl,
+	.unlocked_ioctl	= mixer_unlocked_ioctl,
 	.open		= mixer_open,
 	.release	= mixer_release,
 };
@@ -963,8 +974,7 @@ printk("dmasound_core: tried to set_queue_frags on a locked queue\n") ;
 	return 0 ;
 }
 
-static int sq_ioctl(struct inode *inode, struct file *file, u_int cmd,
-		    u_long arg)
+static int sq_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int val, result;
 	u_long fmt;
@@ -1122,18 +1132,29 @@ static int sq_ioctl(struct inode *inode, struct file *file, u_int cmd,
 		return IOCTL_OUT(arg,val);
 
 	default:
-		return mixer_ioctl(inode, file, cmd, arg);
+		return mixer_ioctl(file, cmd, arg);
 	}
 	return -EINVAL;
 }
 
+static long sq_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = sq_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static const struct file_operations sq_fops =
 {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
 	.write		= sq_write,
 	.poll		= sq_poll,
-	.ioctl		= sq_ioctl,
+	.unlocked_ioctl	= sq_unlocked_ioctl,
 	.open		= sq_open,
 	.release	= sq_release,
 };
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index 153d822..9ffd29f 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -639,21 +639,26 @@ static int mixer_ioctl(unsigned int cmd, unsigned long arg)
 	return -EINVAL;
 }
 
-static int dev_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int minor = iminor(inode);
+	int ret;
 
 	if (cmd == OSS_GETVERSION) {
 		int sound_version = SOUND_VERSION;
 		return put_user(sound_version, (int __user *)arg);
 	}
 
+	ret = -EINVAL;
+
+	lock_kernel();
 	if (minor == dev.dsp_minor)
-		return dsp_ioctl(file, cmd, arg);
+		ret = dsp_ioctl(file, cmd, arg);
 	else if (minor == dev.mixer_minor)
-		return mixer_ioctl(cmd, arg);
+		ret = mixer_ioctl(cmd, arg);
+	unlock_kernel();
 
-	return -EINVAL;
+	return ret;
 }
 
 static void dsp_write_flush(void)
@@ -1109,7 +1114,7 @@ static const struct file_operations dev_fileops = {
 	.owner		= THIS_MODULE,
 	.read		= dev_read,
 	.write		= dev_write,
-	.ioctl		= dev_ioctl,
+	.unlocked_ioctl	= dev_ioctl,
 	.open		= dev_open,
 	.release	= dev_release,
 };
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index 8f0be40..fdb58eb 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -15,6 +15,7 @@
 #include <linux/linkage.h>
 #include <linux/slab.h>
 #include <linux/fs.h>
+#include <linux/smp_lock.h>
 #include <linux/sound.h>
 #include <linux/smp_lock.h>
 #include <linux/soundcard.h>
@@ -93,7 +94,7 @@ static void dac_audio_set_rate(void)
 	wakeups_per_second = ktime_set(0, 1000000000 / rate);
 }
 
-static int dac_audio_ioctl(struct inode *inode, struct file *file,
+static int dac_audio_ioctl(struct file *file,
 			   unsigned int cmd, unsigned long arg)
 {
 	int val;
@@ -159,6 +160,17 @@ static int dac_audio_ioctl(struct inode *inode, struct file *file,
 	return -EINVAL;
 }
 
+static long dac_audio_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = dac_audio_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static ssize_t dac_audio_write(struct file *file, const char *buf, size_t count,
 			       loff_t * ppos)
 {
@@ -242,8 +254,8 @@ static int dac_audio_release(struct inode *inode, struct file *file)
 
 const struct file_operations dac_audio_fops = {
       .read =		dac_audio_read,
-      .write =	dac_audio_write,
-      .ioctl =	dac_audio_ioctl,
+      .write =		dac_audio_write,
+      .unlocked_ioctl =	dac_audio_unlocked_ioctl,
       .open =		dac_audio_open,
       .release =	dac_audio_release,
 };
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 34b0838..b15840a 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -1571,11 +1571,15 @@ static int cs4297a_release_mixdev(struct inode *inode, struct file *file)
 }
 
 
-static int cs4297a_ioctl_mixdev(struct inode *inode, struct file *file,
+static int cs4297a_ioctl_mixdev(struct file *file,
 			       unsigned int cmd, unsigned long arg)
 {
-	return mixer_ioctl((struct cs4297a_state *) file->private_data, cmd,
+	int ret;
+	lock_kernel();
+	ret = mixer_ioctl((struct cs4297a_state *) file->private_data, cmd,
 			   arg);
+	unlock_kernel();
+	return ret;
 }
 
 
@@ -1585,7 +1589,7 @@ static int cs4297a_ioctl_mixdev(struct inode *inode, struct file *file,
 static const struct file_operations cs4297a_mixer_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= no_llseek,
-	.ioctl		= cs4297a_ioctl_mixdev,
+	.unlocked_ioctl	= cs4297a_ioctl_mixdev,
 	.open		= cs4297a_open_mixdev,
 	.release	= cs4297a_release_mixdev,
 };
@@ -1949,7 +1953,7 @@ static int cs4297a_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 
-static int cs4297a_ioctl(struct inode *inode, struct file *file,
+static int cs4297a_ioctl(struct file *file,
 			unsigned int cmd, unsigned long arg)
 {
 	struct cs4297a_state *s =
@@ -2342,6 +2346,16 @@ static int cs4297a_ioctl(struct inode *inode, struct file *file,
 	return mixer_ioctl(s, cmd, arg);
 }
 
+static long cs4297a_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = cs4297a_ioctl(file, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
 
 static int cs4297a_release(struct inode *inode, struct file *file)
 {
@@ -2511,7 +2525,7 @@ static const struct file_operations cs4297a_audio_fops = {
 	.read		= cs4297a_read,
 	.write		= cs4297a_write,
 	.poll		= cs4297a_poll,
-	.ioctl		= cs4297a_ioctl,
+	.unlocked_ioctl	= cs4297a_unlocked_ioctl,
 	.mmap		= cs4297a_mmap,
 	.open		= cs4297a_open,
 	.release	= cs4297a_release,
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 99c94c4..8cd73cd 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -2429,8 +2429,7 @@ static unsigned int vwsnd_audio_poll(struct file *file,
 	return mask;
 }
 
-static int vwsnd_audio_do_ioctl(struct inode *inode,
-				struct file *file,
+static int vwsnd_audio_do_ioctl(struct file *file,
 				unsigned int cmd,
 				unsigned long arg)
 {
@@ -2446,8 +2445,8 @@ static int vwsnd_audio_do_ioctl(struct inode *inode,
 	int ival;
 
 	
-	DBGEV("(inode=0x%p, file=0x%p, cmd=0x%x, arg=0x%lx)\n",
-	      inode, file, cmd, arg);
+	DBGEV("(file=0x%p, cmd=0x%x, arg=0x%lx)\n",
+	      file, cmd, arg);
 	switch (cmd) {
 	case OSS_GETVERSION:		/* _SIOR ('M', 118, int) */
 		DBGX("OSS_GETVERSION\n");
@@ -2885,17 +2884,19 @@ static int vwsnd_audio_do_ioctl(struct inode *inode,
 	return -EINVAL;
 }
 
-static int vwsnd_audio_ioctl(struct inode *inode,
-				struct file *file,
+static long vwsnd_audio_ioctl(struct file *file,
 				unsigned int cmd,
 				unsigned long arg)
 {
 	vwsnd_dev_t *devc = (vwsnd_dev_t *) file->private_data;
 	int ret;
 
+	lock_kernel();
 	mutex_lock(&devc->io_mutex);
-	ret = vwsnd_audio_do_ioctl(inode, file, cmd, arg);
+	ret = vwsnd_audio_do_ioctl(file, cmd, arg);
 	mutex_unlock(&devc->io_mutex);
+	unlock_kernel();
+
 	return ret;
 }
 
@@ -3049,7 +3050,7 @@ static const struct file_operations vwsnd_audio_fops = {
 	.read =		vwsnd_audio_read,
 	.write =	vwsnd_audio_write,
 	.poll =		vwsnd_audio_poll,
-	.ioctl =	vwsnd_audio_ioctl,
+	.unlocked_ioctl = vwsnd_audio_ioctl,
 	.mmap =		vwsnd_audio_mmap,
 	.open =		vwsnd_audio_open,
 	.release =	vwsnd_audio_release,
@@ -3211,8 +3212,7 @@ static int mixer_write_ioctl(vwsnd_dev_t *devc, unsigned int nr, void __user *ar
 
 /* This is the ioctl entry to the mixer driver. */
 
-static int vwsnd_mixer_ioctl(struct inode *ioctl,
-			      struct file *file,
+static long vwsnd_mixer_ioctl(struct file *file,
 			      unsigned int cmd,
 			      unsigned long arg)
 {
@@ -3223,6 +3223,7 @@ static int vwsnd_mixer_ioctl(struct inode *ioctl,
 
 	DBGEV("(devc=0x%p, cmd=0x%x, arg=0x%lx)\n", devc, cmd, arg);
 
+	lock_kernel();
 	mutex_lock(&devc->mix_mutex);
 	{
 		if ((cmd & ~nrmask) == MIXER_READ(0))
@@ -3233,13 +3234,14 @@ static int vwsnd_mixer_ioctl(struct inode *ioctl,
 			retval = -EINVAL;
 	}
 	mutex_unlock(&devc->mix_mutex);
+	unlock_kernel();
 	return retval;
 }
 
 static const struct file_operations vwsnd_mixer_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.ioctl =	vwsnd_mixer_ioctl,
+	.unlocked_ioctl = vwsnd_mixer_ioctl,
 	.open =		vwsnd_mixer_open,
 	.release =	vwsnd_mixer_release,
 };
-- 
1.7.1

