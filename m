Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0GKKQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 06:16:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54757 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab0GKKQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 06:16:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaroslav Kysela <perex@perex.cz>
Subject: Re: [PATCH 3/3] sound: push BKL into open functions
Date: Sun, 11 Jul 2010 12:16:36 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA development <alsa-devel@alsa-project.org>
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <1278798701-11171-4-git-send-email-arnd@arndb.de> <alpine.LNX.2.00.1007110913120.16744@eeebox2.perex-int.cz>
In-Reply-To: <alpine.LNX.2.00.1007110913120.16744@eeebox2.perex-int.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007111216.36538.arnd@arndb.de>
X-Provags-ID: V02:K0:ibhLHX2BsfB0SoabLrBe5n2vBM1vMdKcFCnmUXtXdpn
 Fxve2pmcAsqhLJZsjZYVQal1yDM/azc5jmPg/Iya6vu9+qLo28
 Mg8SZxFih80CiJrBzeiGNI3j/9cnCs4ofdpgm8c+iqRSX62H0P
 R7T20CCcGZygf79wOpcePhRpGij5MS0fyiFd1t58x4m8vCB/l9
 Wx3K5kcdspG+lyDZjZohA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This moves the lock_kernel() call from soundcore_open
to the individual OSS device drivers, where we can deal
with it one driver at a time if needed, or just kill
off the drivers.

All core components in ALSA already provide
adequate locking in their open()-functions
and do not require the big kernel lock, so
there is no need to add the BKL there.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Sunday 11 July 2010 09:15:22 Jaroslav Kysela wrote:
> I don't see any reason (benefit) to add gotos to these two functions.
> 
Sorry, I had removed them and then forgot the git-add before
creating the emails. Originally, I had two patches, one for
pushing down the BKL into every sound driver (hence the goto)
and a second patch to remove the BKL again from all the native
alsa drivers. If you prefer, I can also give you the separate
patches, but I figured that since none of the ALSA drivers needs
the BKL, the combined patch would be better.

This is the corrected combined version.

	Arnd

 arch/um/drivers/hostaudio_kern.c   |    6 ++++++
 sound/oss/au1550_ac97.c            |   26 +++++++++++++++++---------
 sound/oss/dmasound/dmasound_core.c |   28 ++++++++++++++++++++++------
 sound/oss/msnd_pinnacle.c          |   10 +++++++---
 sound/oss/sh_dac_audio.c           |    9 +++++++--
 sound/oss/soundcard.c              |   20 +++++++++++---------
 sound/oss/swarm_cs4297a.c          |   17 ++++++++++++++++-
 sound/oss/vwsnd.c                  |    8 ++++++++
 sound/sound_core.c                 |    6 +-----
 9 files changed, 95 insertions(+), 35 deletions(-)

diff --git a/arch/um/drivers/hostaudio_kern.c b/arch/um/drivers/hostaudio_kern.c
index ae42695..68142df 100644
--- a/arch/um/drivers/hostaudio_kern.c
+++ b/arch/um/drivers/hostaudio_kern.c
@@ -8,6 +8,7 @@
 #include "linux/slab.h"
 #include "linux/sound.h"
 #include "linux/soundcard.h"
+#include "linux/smp_lock.h"
 #include "asm/uaccess.h"
 #include "init.h"
 #include "os.h"
@@ -198,7 +199,10 @@ static int hostaudio_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		w = 1;
 
+	lock_kernel();
 	ret = os_open_file(dsp, of_set_rw(OPENFLAGS(), r, w), 0);
+	unlock_kernel();
+
 	if (ret < 0) {
 		kfree(state);
 		return ret;
@@ -254,7 +258,9 @@ static int hostmixer_open_mixdev(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_WRITE)
 		w = 1;
 
+	lock_kernel();
 	ret = os_open_file(mixer, of_set_rw(OPENFLAGS(), r, w), 0);
+	unlock_kernel();
 
 	if (ret < 0) {
 		printk(KERN_ERR "hostaudio_open_mixdev failed to open '%s', "
diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index c1070e3..47143a3 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -43,6 +43,7 @@
 #include <linux/sound.h>
 #include <linux/slab.h>
 #include <linux/soundcard.h>
+#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -807,7 +808,9 @@ au1550_llseek(struct file *file, loff_t offset, int origin)
 static int
 au1550_open_mixdev(struct inode *inode, struct file *file)
 {
+	lock_kernel();
 	file->private_data = &au1550_state;
+	unlock_kernel();
 	return 0;
 }
 
@@ -1797,21 +1800,22 @@ au1550_open(struct inode *inode, struct file *file)
 #endif
 
 	file->private_data = s;
+	lock_kernel();
 	/* wait for device to become free */
 	mutex_lock(&s->open_mutex);
 	while (s->open_mode & file->f_mode) {
-		if (file->f_flags & O_NONBLOCK) {
-			mutex_unlock(&s->open_mutex);
-			return -EBUSY;
-		}
+		ret = -EBUSY;
+		if (file->f_flags & O_NONBLOCK)
+			goto out;		
 		add_wait_queue(&s->open_wait, &wait);
 		__set_current_state(TASK_INTERRUPTIBLE);
 		mutex_unlock(&s->open_mutex);
 		schedule();
 		remove_wait_queue(&s->open_wait, &wait);
 		set_current_state(TASK_RUNNING);
+		ret = -ERESTARTSYS;
 		if (signal_pending(current))
-			return -ERESTARTSYS;
+			goto out2;
 		mutex_lock(&s->open_mutex);
 	}
 
@@ -1840,17 +1844,21 @@ au1550_open(struct inode *inode, struct file *file)
 
 	if (file->f_mode & FMODE_READ) {
 		if ((ret = prog_dmabuf_adc(s)))
-			return ret;
+			goto out;
 	}
 	if (file->f_mode & FMODE_WRITE) {
 		if ((ret = prog_dmabuf_dac(s)))
-			return ret;
+			goto out;
 	}
 
 	s->open_mode |= file->f_mode & (FMODE_READ | FMODE_WRITE);
-	mutex_unlock(&s->open_mutex);
 	mutex_init(&s->sem);
-	return 0;
+	ret = 0;
+out:
+	mutex_unlock(&s->open_mutex);
+out2:
+	unlock_kernel();
+	return ret;
 }
 
 static int
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index 3f3c3f7..5a4f38c 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -323,9 +323,13 @@ static struct {
 
 static int mixer_open(struct inode *inode, struct file *file)
 {
-	if (!try_module_get(dmasound.mach.owner))
+	lock_kernel();
+	if (!try_module_get(dmasound.mach.owner)) {
+		unlock_kernel();
 		return -ENODEV;
+	}
 	mixer.busy = 1;
+	unlock_kernel();
 	return 0;
 }
 
@@ -737,8 +741,11 @@ static int sq_open(struct inode *inode, struct file *file)
 {
 	int rc;
 
-	if (!try_module_get(dmasound.mach.owner))
+	lock_kernel();
+	if (!try_module_get(dmasound.mach.owner)) {
+		unlock_kernel();
 		return -ENODEV;
+	}
 
 	rc = write_sq_open(file); /* checks the f_mode */
 	if (rc)
@@ -781,10 +788,11 @@ static int sq_open(struct inode *inode, struct file *file)
 		sound_set_format(AFMT_MU_LAW);
 	}
 #endif
-
+	unlock_kernel();
 	return 0;
  out:
 	module_put(dmasound.mach.owner);
+	unlock_kernel();
 	return rc;
 }
 
@@ -1226,12 +1234,17 @@ static int state_open(struct inode *inode, struct file *file)
 {
 	char *buffer = state.buf;
 	int len = 0;
+	int ret;
 
+	lock_kernel();
+	ret = -EBUSY;
 	if (state.busy)
-		return -EBUSY;
+		goto out;
 
+	ret = -ENODEV;
 	if (!try_module_get(dmasound.mach.owner))
-		return -ENODEV;
+		goto out;
+
 	state.ptr = 0;
 	state.busy = 1;
 
@@ -1293,7 +1306,10 @@ printk("dmasound: stat buffer used %d bytes\n", len) ;
 		printk(KERN_ERR "dmasound_core: stat buffer overflowed!\n");
 
 	state.len = len;
-	return 0;
+	ret = 0;
+out:
+	unlock_kernel();
+	return ret;
 }
 
 static int state_release(struct inode *inode, struct file *file)
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index a1e3f96..153d822 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -756,12 +756,15 @@ static int dev_open(struct inode *inode, struct file *file)
 	int minor = iminor(inode);
 	int err = 0;
 
+	lock_kernel();
 	if (minor == dev.dsp_minor) {
 		if ((file->f_mode & FMODE_WRITE &&
 		     test_bit(F_AUDIO_WRITE_INUSE, &dev.flags)) ||
 		    (file->f_mode & FMODE_READ &&
-		     test_bit(F_AUDIO_READ_INUSE, &dev.flags)))
-			return -EBUSY;
+		     test_bit(F_AUDIO_READ_INUSE, &dev.flags))) {
+			err = -EBUSY;
+			goto out;
+		}
 
 		if ((err = dsp_open(file)) >= 0) {
 			dev.nresets = 0;
@@ -782,7 +785,8 @@ static int dev_open(struct inode *inode, struct file *file)
 		/* nothing */
 	} else
 		err = -EINVAL;
-
+out:
+	unlock_kernel();
 	return err;
 }
 
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index 4153752..8f0be40 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -16,6 +16,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/sound.h>
+#include <linux/smp_lock.h>
 #include <linux/soundcard.h>
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
@@ -216,13 +217,17 @@ static int dac_audio_open(struct inode *inode, struct file *file)
 {
 	if (file->f_mode & FMODE_READ)
 		return -ENODEV;
-	if (in_use)
+
+	lock_kernel();
+	if (in_use) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	in_use = 1;
 
 	dac_audio_start();
-
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 2d9c513..92aa762 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -210,42 +210,44 @@ static int sound_open(struct inode *inode, struct file *file)
 		printk(KERN_ERR "Invalid minor device %d\n", dev);
 		return -ENXIO;
 	}
+	lock_kernel();
 	switch (dev & 0x0f) {
 	case SND_DEV_CTL:
 		dev >>= 4;
 		if (dev >= 0 && dev < MAX_MIXER_DEV && mixer_devs[dev] == NULL) {
 			request_module("mixer%d", dev);
 		}
+		retval = -ENXIO;
 		if (dev && (dev >= num_mixers || mixer_devs[dev] == NULL))
-			return -ENXIO;
+			break;
 	
 		if (!try_module_get(mixer_devs[dev]->owner))
-			return -ENXIO;
+			break;
+
+		retval = 0;
 		break;
 
 	case SND_DEV_SEQ:
 	case SND_DEV_SEQ2:
-		if ((retval = sequencer_open(dev, file)) < 0)
-			return retval;
+		retval = sequencer_open(dev, file);
 		break;
 
 	case SND_DEV_MIDIN:
-		if ((retval = MIDIbuf_open(dev, file)) < 0)
-			return retval;
+		retval = MIDIbuf_open(dev, file);
 		break;
 
 	case SND_DEV_DSP:
 	case SND_DEV_DSP16:
 	case SND_DEV_AUDIO:
-		if ((retval = audio_open(dev, file)) < 0)
-			return retval;
+		retval = audio_open(dev, file);
 		break;
 
 	default:
 		printk(KERN_ERR "Invalid minor device %d\n", dev);
-		return -ENXIO;
+		retval = -ENXIO;
 	}
 
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index 3136c88..34b0838 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -68,6 +68,7 @@
 #include <linux/delay.h>
 #include <linux/sound.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/soundcard.h>
 #include <linux/ac97_codec.h>
 #include <linux/pci.h>
@@ -1534,6 +1535,7 @@ static int cs4297a_open_mixdev(struct inode *inode, struct file *file)
 	CS_DBGOUT(CS_FUNCTION | CS_OPEN, 4,
 		  printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()+\n"));
 
+	lock_kernel();
 	list_for_each(entry, &cs4297a_devs)
 	{
 		s = list_entry(entry, struct cs4297a_state, list);
@@ -1544,6 +1546,8 @@ static int cs4297a_open_mixdev(struct inode *inode, struct file *file)
 	{
 		CS_DBGOUT(CS_FUNCTION | CS_OPEN | CS_ERROR, 2,
 			printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()- -ENODEV\n"));
+
+		unlock_kernel();
 		return -ENODEV;
 	}
 	VALIDATE_STATE(s);
@@ -1551,6 +1555,7 @@ static int cs4297a_open_mixdev(struct inode *inode, struct file *file)
 
 	CS_DBGOUT(CS_FUNCTION | CS_OPEN, 4,
 		  printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()- 0\n"));
+	unlock_kernel();
 
 	return nonseekable_open(inode, file);
 }
@@ -2369,7 +2374,7 @@ static int cs4297a_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int cs4297a_open(struct inode *inode, struct file *file)
+static int cs4297a_locked_open(struct inode *inode, struct file *file)
 {
 	int minor = iminor(inode);
 	struct cs4297a_state *s=NULL;
@@ -2486,6 +2491,16 @@ static int cs4297a_open(struct inode *inode, struct file *file)
 	return nonseekable_open(inode, file);
 }
 
+static int cs4297a_open(struct inode *inode, struct file *file)
+{
+	int ret;
+
+	lock_kernel();
+	ret = cs4297a_open(inode, file);
+	unlock_kernel();
+
+	return ret;
+}
 
 // ******************************************************************************************
 //   Wave (audio) file operations struct.
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 20b3b32..99c94c4 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -2921,6 +2921,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 
 	DBGE("(inode=0x%p, file=0x%p)\n", inode, file);
 
+	lock_kernel();
 	INC_USE_COUNT;
 	for (devc = vwsnd_dev_list; devc; devc = devc->next_dev)
 		if ((devc->audio_minor & ~0x0F) == (minor & ~0x0F))
@@ -2928,6 +2929,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 
 	if (devc == NULL) {
 		DEC_USE_COUNT;
+		unlock_kernel();
 		return -ENODEV;
 	}
 
@@ -2936,11 +2938,13 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 		mutex_unlock(&devc->open_mutex);
 		if (file->f_flags & O_NONBLOCK) {
 			DEC_USE_COUNT;
+			unlock_kernel();
 			return -EBUSY;
 		}
 		interruptible_sleep_on(&devc->open_wait);
 		if (signal_pending(current)) {
 			DEC_USE_COUNT;
+			unlock_kernel();
 			return -ERESTARTSYS;
 		}
 		mutex_lock(&devc->open_mutex);
@@ -2993,6 +2997,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 
 	file->private_data = devc;
 	DBGRV();
+	unlock_kernel();
 	return 0;
 }
 
@@ -3062,15 +3067,18 @@ static int vwsnd_mixer_open(struct inode *inode, struct file *file)
 	DBGEV("(inode=0x%p, file=0x%p)\n", inode, file);
 
 	INC_USE_COUNT;
+	lock_kernel();
 	for (devc = vwsnd_dev_list; devc; devc = devc->next_dev)
 		if (devc->mixer_minor == iminor(inode))
 			break;
 
 	if (devc == NULL) {
 		DEC_USE_COUNT;
+		unlock_kernel();
 		return -ENODEV;
 	}
 	file->private_data = devc;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/sound/sound_core.c b/sound/sound_core.c
index c8627fc..cb61317 100644
--- a/sound/sound_core.c
+++ b/sound/sound_core.c
@@ -629,12 +629,8 @@ static int soundcore_open(struct inode *inode, struct file *file)
 		file->f_op = new_fops;
 		spin_unlock(&sound_loader_lock);
 
-		if (file->f_op->open) {
-			/* TODO: push down BKL into indivial open functions */
-			lock_kernel();
+		if (file->f_op->open)
 			err = file->f_op->open(inode,file);
-			unlock_kernel();
-		}
 
 		if (err) {
 			fops_put(file->f_op);
