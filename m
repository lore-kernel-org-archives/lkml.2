Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab0INTyH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:54:07 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56814 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab0INTxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:53:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6/7] sound: autoconvert trivial BKL users to private mutex
Date: Tue, 14 Sep 2010 21:53:41 +0200
Message-Id: <1284494022-7346-7-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284494022-7346-1-git-send-email-arnd@arndb.de>
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wmx62/XchxDT6HifFyjtbwovzj2ZaotIjpr7TDUiald
 /mpGcXnjx3Bj2WgYGbk0/xNF2+WnrnD1vCBOdWSZ5DVuE/Jns0
 q2VLMz9TeO/9V7qupoRLXdjYJI/TbVqOlgRruoEFzqgBYgQtUu
 TurhmhVmwtumZ/1JbkVn2nR1O9bq0t2xMK1pG918ntYHCyNdx/
 kb5PsDkG7F0yNsDeHID8Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of the BKL in the OSS sound drivers is
trivial, and each of them only locks against itself,
so it can be turned into per-driver mutexes.

This is the script that was used for the conversion:

file=$1
name=$2
if grep -q lock_kernel ${file} ; then
    if grep -q 'include.*linux.mutex.h' ${file} ; then
            sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
    else
            sed -i 's/include.*<linux\/smp_lock.h>.*$/include <linux\/mutex.h>/g' ${file}
    fi
    sed -i ${file} \
        -e "/^#include.*linux.mutex.h/,$ {
                1,/^\(static\|int\|long\)/ {
                     /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);

} }"  \
    -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
    -e '/[      ]*cycle_kernel_lock();/d'
else
    sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
                -e '/cycle_kernel_lock()/d'
fi

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Takashi Iwai <tiwai@suse.de>
---
 sound/oss/au1550_ac97.c            |   30 +++++++++++++-------------
 sound/oss/dmasound/dmasound_core.c |   41 ++++++++++++++++++-----------------
 sound/oss/msnd_pinnacle.c          |   15 +++++++------
 sound/oss/sh_dac_audio.c           |   13 ++++++-----
 sound/oss/soundcard.c              |   41 ++++++++++++++++++-----------------
 sound/oss/swarm_cs4297a.c          |   20 ++++++++--------
 sound/oss/vwsnd.c                  |   30 +++++++++++++-------------
 7 files changed, 97 insertions(+), 93 deletions(-)

diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
index c6f2621..afb1eab 100644
--- a/sound/oss/au1550_ac97.c
+++ b/sound/oss/au1550_ac97.c
@@ -43,7 +43,6 @@
 #include <linux/sound.h>
 #include <linux/slab.h>
 #include <linux/soundcard.h>
-#include <linux/smp_lock.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/kernel.h>
@@ -77,6 +76,7 @@
 /* Boot options
  * 0 = no VRA, 1 = use VRA if codec supports it
  */
+static DEFINE_MUTEX(au1550_ac97_mutex);
 static int      vra = 1;
 module_param(vra, bool, 0);
 MODULE_PARM_DESC(vra, "if 1 use VRA if codec supports it");
@@ -798,9 +798,9 @@ au1550_llseek(struct file *file, loff_t offset, int origin)
 static int
 au1550_open_mixdev(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&au1550_ac97_mutex);
 	file->private_data = &au1550_state;
-	unlock_kernel();
+	mutex_unlock(&au1550_ac97_mutex);
 	return 0;
 }
 
@@ -824,9 +824,9 @@ au1550_ioctl_mixdev(struct file *file, unsigned int cmd, unsigned long arg)
 	struct ac97_codec *codec = s->codec;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&au1550_ac97_mutex);
 	ret = mixdev_ioctl(codec, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&au1550_ac97_mutex);
 
 	return ret;
 }
@@ -1255,7 +1255,7 @@ au1550_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned long   size;
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&au1550_ac97_mutex);
 	mutex_lock(&s->sem);
 	if (vma->vm_flags & VM_WRITE)
 		db = &s->dma_dac;
@@ -1283,7 +1283,7 @@ au1550_mmap(struct file *file, struct vm_area_struct *vma)
 	db->mapped = 1;
 out:
 	mutex_unlock(&s->sem);
-	unlock_kernel();
+	mutex_unlock(&au1550_ac97_mutex);
 	return ret;
 }
 
@@ -1781,9 +1781,9 @@ au1550_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&au1550_ac97_mutex);
 	ret = au1550_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&au1550_ac97_mutex);
 
 	return ret;
 }
@@ -1804,7 +1804,7 @@ au1550_open(struct inode *inode, struct file *file)
 #endif
 
 	file->private_data = s;
-	lock_kernel();
+	mutex_lock(&au1550_ac97_mutex);
 	/* wait for device to become free */
 	mutex_lock(&s->open_mutex);
 	while (s->open_mode & file->f_mode) {
@@ -1861,7 +1861,7 @@ au1550_open(struct inode *inode, struct file *file)
 out:
 	mutex_unlock(&s->open_mutex);
 out2:
-	unlock_kernel();
+	mutex_unlock(&au1550_ac97_mutex);
 	return ret;
 }
 
@@ -1870,12 +1870,12 @@ au1550_release(struct inode *inode, struct file *file)
 {
 	struct au1550_state *s = (struct au1550_state *)file->private_data;
 
-	lock_kernel();
+	mutex_lock(&au1550_ac97_mutex);
 
 	if (file->f_mode & FMODE_WRITE) {
-		unlock_kernel();
+		mutex_unlock(&au1550_ac97_mutex);
 		drain_dac(s, file->f_flags & O_NONBLOCK);
-		lock_kernel();
+		mutex_lock(&au1550_ac97_mutex);
 	}
 
 	mutex_lock(&s->open_mutex);
@@ -1892,7 +1892,7 @@ au1550_release(struct inode *inode, struct file *file)
 	s->open_mode &= ((~file->f_mode) & (FMODE_READ|FMODE_WRITE));
 	mutex_unlock(&s->open_mutex);
 	wake_up(&s->open_wait);
-	unlock_kernel();
+	mutex_unlock(&au1550_ac97_mutex);
 	return 0;
 }
 
diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
index 6ecd41a..87e2c72 100644
--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -181,7 +181,7 @@
 #include <linux/init.h>
 #include <linux/soundcard.h>
 #include <linux/poll.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 
 #include <asm/uaccess.h>
 
@@ -194,6 +194,7 @@
      *  Declarations
      */
 
+static DEFINE_MUTEX(dmasound_core_mutex);
 int dmasound_catchRadius = 0;
 module_param(dmasound_catchRadius, int, 0);
 
@@ -323,22 +324,22 @@ static struct {
 
 static int mixer_open(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	if (!try_module_get(dmasound.mach.owner)) {
-		unlock_kernel();
+		mutex_unlock(&dmasound_core_mutex);
 		return -ENODEV;
 	}
 	mixer.busy = 1;
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 	return 0;
 }
 
 static int mixer_release(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	mixer.busy = 0;
 	module_put(dmasound.mach.owner);
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 	return 0;
 }
 
@@ -370,9 +371,9 @@ static long mixer_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	ret = mixer_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 
 	return ret;
 }
@@ -752,9 +753,9 @@ static int sq_open(struct inode *inode, struct file *file)
 {
 	int rc;
 
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	if (!try_module_get(dmasound.mach.owner)) {
-		unlock_kernel();
+		mutex_unlock(&dmasound_core_mutex);
 		return -ENODEV;
 	}
 
@@ -799,11 +800,11 @@ static int sq_open(struct inode *inode, struct file *file)
 		sound_set_format(AFMT_MU_LAW);
 	}
 #endif
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 	return 0;
  out:
 	module_put(dmasound.mach.owner);
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 	return rc;
 }
 
@@ -869,7 +870,7 @@ static int sq_release(struct inode *inode, struct file *file)
 {
 	int rc = 0;
 
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 
 	if (file->f_mode & FMODE_WRITE) {
 		if (write_sq.busy)
@@ -900,7 +901,7 @@ static int sq_release(struct inode *inode, struct file *file)
 	write_sq_wake_up(file); /* checks f_mode */
 #endif /* blocking open() */
 
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 
 	return rc;
 }
@@ -1141,9 +1142,9 @@ static long sq_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	ret = sq_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 
 	return ret;
 }
@@ -1257,7 +1258,7 @@ static int state_open(struct inode *inode, struct file *file)
 	int len = 0;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	ret = -EBUSY;
 	if (state.busy)
 		goto out;
@@ -1329,16 +1330,16 @@ printk("dmasound: stat buffer used %d bytes\n", len) ;
 	state.len = len;
 	ret = 0;
 out:
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 	return ret;
 }
 
 static int state_release(struct inode *inode, struct file *file)
 {
-	lock_kernel();
+	mutex_lock(&dmasound_core_mutex);
 	state.busy = 0;
 	module_put(dmasound.mach.owner);
-	unlock_kernel();
+	mutex_unlock(&dmasound_core_mutex);
 	return 0;
 }
 
diff --git a/sound/oss/msnd_pinnacle.c b/sound/oss/msnd_pinnacle.c
index 2e48b17..b4c1eb5 100644
--- a/sound/oss/msnd_pinnacle.c
+++ b/sound/oss/msnd_pinnacle.c
@@ -39,7 +39,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/gfp.h>
 #include <asm/irq.h>
 #include <asm/io.h>
@@ -79,6 +79,7 @@
 					 dev.rec_sample_rate /		\
 					 dev.rec_channels)
 
+static DEFINE_MUTEX(msnd_pinnacle_mutex);
 static multisound_dev_t			dev;
 
 #ifndef HAVE_DSPCODEH
@@ -651,12 +652,12 @@ static long dev_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 	ret = -EINVAL;
 
-	lock_kernel();
+	mutex_lock(&msnd_pinnacle_mutex);
 	if (minor == dev.dsp_minor)
 		ret = dsp_ioctl(file, cmd, arg);
 	else if (minor == dev.mixer_minor)
 		ret = mixer_ioctl(cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&msnd_pinnacle_mutex);
 
 	return ret;
 }
@@ -761,7 +762,7 @@ static int dev_open(struct inode *inode, struct file *file)
 	int minor = iminor(inode);
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&msnd_pinnacle_mutex);
 	if (minor == dev.dsp_minor) {
 		if ((file->f_mode & FMODE_WRITE &&
 		     test_bit(F_AUDIO_WRITE_INUSE, &dev.flags)) ||
@@ -791,7 +792,7 @@ static int dev_open(struct inode *inode, struct file *file)
 	} else
 		err = -EINVAL;
 out:
-	unlock_kernel();
+	mutex_unlock(&msnd_pinnacle_mutex);
 	return err;
 }
 
@@ -800,14 +801,14 @@ static int dev_release(struct inode *inode, struct file *file)
 	int minor = iminor(inode);
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&msnd_pinnacle_mutex);
 	if (minor == dev.dsp_minor)
 		err = dsp_release(file);
 	else if (minor == dev.mixer_minor) {
 		/* nothing */
 	} else
 		err = -EINVAL;
-	unlock_kernel();
+	mutex_unlock(&msnd_pinnacle_mutex);
 	return err;
 }
 
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
index 479e302..53bba16 100644
--- a/sound/oss/sh_dac_audio.c
+++ b/sound/oss/sh_dac_audio.c
@@ -16,7 +16,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/sound.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/soundcard.h>
 #include <linux/interrupt.h>
 #include <linux/hrtimer.h>
@@ -34,6 +34,7 @@
 
 #define BUFFER_SIZE 48000
 
+static DEFINE_MUTEX(sh_dac_audio_mutex);
 static int rate;
 static int empty;
 static char *data_buffer, *buffer_begin, *buffer_end;
@@ -163,9 +164,9 @@ static long dac_audio_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&sh_dac_audio_mutex);
 	ret = dac_audio_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&sh_dac_audio_mutex);
 
 	return ret;
 }
@@ -229,16 +230,16 @@ static int dac_audio_open(struct inode *inode, struct file *file)
 	if (file->f_mode & FMODE_READ)
 		return -ENODEV;
 
-	lock_kernel();
+	mutex_lock(&sh_dac_audio_mutex);
 	if (in_use) {
-		unlock_kernel();
+		mutex_unlock(&sh_dac_audio_mutex);
 		return -EBUSY;
 	}
 
 	in_use = 1;
 
 	dac_audio_start();
-	unlock_kernel();
+	mutex_unlock(&sh_dac_audio_mutex);
 	return 0;
 }
 
diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 92aa762..938ed94 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -40,7 +40,7 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/module.h>
 #include <linux/mm.h>
 #include <linux/device.h>
@@ -56,6 +56,7 @@
  * Table for permanently allocated memory (used when unloading the module)
  */
 void *          sound_mem_blocks[MAX_MEM_BLOCKS];
+static DEFINE_MUTEX(soundcard_mutex);
 int             sound_nblocks = 0;
 
 /* Persistent DMA buffers */
@@ -151,7 +152,7 @@ static ssize_t sound_read(struct file *file, char __user *buf, size_t count, lof
 	 *	big one anyway, we might as well bandage here..
 	 */
 	 
-	lock_kernel();
+	mutex_lock(&soundcard_mutex);
 	
 	DEB(printk("sound_read(dev=%d, count=%d)\n", dev, count));
 	switch (dev & 0x0f) {
@@ -169,7 +170,7 @@ static ssize_t sound_read(struct file *file, char __user *buf, size_t count, lof
 	case SND_DEV_MIDIN:
 		ret = MIDIbuf_read(dev, file, buf, count);
 	}
-	unlock_kernel();
+	mutex_unlock(&soundcard_mutex);
 	return ret;
 }
 
@@ -178,7 +179,7 @@ static ssize_t sound_write(struct file *file, const char __user *buf, size_t cou
 	int dev = iminor(file->f_path.dentry->d_inode);
 	int ret = -EINVAL;
 	
-	lock_kernel();
+	mutex_lock(&soundcard_mutex);
 	DEB(printk("sound_write(dev=%d, count=%d)\n", dev, count));
 	switch (dev & 0x0f) {
 	case SND_DEV_SEQ:
@@ -196,7 +197,7 @@ static ssize_t sound_write(struct file *file, const char __user *buf, size_t cou
 		ret =  MIDIbuf_write(dev, file, buf, count);
 		break;
 	}
-	unlock_kernel();
+	mutex_unlock(&soundcard_mutex);
 	return ret;
 }
 
@@ -210,7 +211,7 @@ static int sound_open(struct inode *inode, struct file *file)
 		printk(KERN_ERR "Invalid minor device %d\n", dev);
 		return -ENXIO;
 	}
-	lock_kernel();
+	mutex_lock(&soundcard_mutex);
 	switch (dev & 0x0f) {
 	case SND_DEV_CTL:
 		dev >>= 4;
@@ -247,7 +248,7 @@ static int sound_open(struct inode *inode, struct file *file)
 		retval = -ENXIO;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&soundcard_mutex);
 	return 0;
 }
 
@@ -255,7 +256,7 @@ static int sound_release(struct inode *inode, struct file *file)
 {
 	int dev = iminor(inode);
 
-	lock_kernel();
+	mutex_lock(&soundcard_mutex);
 	DEB(printk("sound_release(dev=%d)\n", dev));
 	switch (dev & 0x0f) {
 	case SND_DEV_CTL:
@@ -280,7 +281,7 @@ static int sound_release(struct inode *inode, struct file *file)
 	default:
 		printk(KERN_ERR "Sound error: Releasing unknown device 0x%02x\n", dev);
 	}
-	unlock_kernel();
+	mutex_unlock(&soundcard_mutex);
 
 	return 0;
 }
@@ -354,7 +355,7 @@ static long sound_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (cmd == OSS_GETVERSION)
 		return __put_user(SOUND_VERSION, (int __user *)p);
 	
-	lock_kernel();
+	mutex_lock(&soundcard_mutex);
 	if (_IOC_TYPE(cmd) == 'M' && num_mixers > 0 &&   /* Mixer ioctl */
 	    (dev & 0x0f) != SND_DEV_CTL) {              
 		dtype = dev & 0x0f;
@@ -369,7 +370,7 @@ static long sound_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 			ret = sound_mixer_ioctl(dev >> 4, cmd, p);
 			break;
 		}
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return ret;
 	}
 
@@ -399,7 +400,7 @@ static long sound_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 
 	}
-	unlock_kernel();
+	mutex_unlock(&soundcard_mutex);
 	return ret;
 }
 
@@ -439,35 +440,35 @@ static int sound_mmap(struct file *file, struct vm_area_struct *vma)
 		printk(KERN_ERR "Sound: mmap() not supported for other than audio devices\n");
 		return -EINVAL;
 	}
-	lock_kernel();
+	mutex_lock(&soundcard_mutex);
 	if (vma->vm_flags & VM_WRITE)	/* Map write and read/write to the output buf */
 		dmap = audio_devs[dev]->dmap_out;
 	else if (vma->vm_flags & VM_READ)
 		dmap = audio_devs[dev]->dmap_in;
 	else {
 		printk(KERN_ERR "Sound: Undefined mmap() access\n");
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return -EINVAL;
 	}
 
 	if (dmap == NULL) {
 		printk(KERN_ERR "Sound: mmap() error. dmap == NULL\n");
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return -EIO;
 	}
 	if (dmap->raw_buf == NULL) {
 		printk(KERN_ERR "Sound: mmap() called when raw_buf == NULL\n");
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return -EIO;
 	}
 	if (dmap->mapping_flags) {
 		printk(KERN_ERR "Sound: mmap() called twice for the same DMA buffer\n");
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return -EIO;
 	}
 	if (vma->vm_pgoff != 0) {
 		printk(KERN_ERR "Sound: mmap() offset must be 0.\n");
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return -EINVAL;
 	}
 	size = vma->vm_end - vma->vm_start;
@@ -478,7 +479,7 @@ static int sound_mmap(struct file *file, struct vm_area_struct *vma)
 	if (remap_pfn_range(vma, vma->vm_start,
 			virt_to_phys(dmap->raw_buf) >> PAGE_SHIFT,
 			vma->vm_end - vma->vm_start, vma->vm_page_prot)) {
-		unlock_kernel();
+		mutex_unlock(&soundcard_mutex);
 		return -EAGAIN;
 	}
 
@@ -490,7 +491,7 @@ static int sound_mmap(struct file *file, struct vm_area_struct *vma)
 	memset(dmap->raw_buf,
 	       dmap->neutral_byte,
 	       dmap->bytes_in_use);
-	unlock_kernel();
+	mutex_unlock(&soundcard_mutex);
 	return 0;
 }
 
diff --git a/sound/oss/swarm_cs4297a.c b/sound/oss/swarm_cs4297a.c
index b15840a..44357d8 100644
--- a/sound/oss/swarm_cs4297a.c
+++ b/sound/oss/swarm_cs4297a.c
@@ -68,7 +68,6 @@
 #include <linux/delay.h>
 #include <linux/sound.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/soundcard.h>
 #include <linux/ac97_codec.h>
 #include <linux/pci.h>
@@ -94,6 +93,7 @@
 
 struct cs4297a_state;
 
+static DEFINE_MUTEX(swarm_cs4297a_mutex);
 static void stop_dac(struct cs4297a_state *s);
 static void stop_adc(struct cs4297a_state *s);
 static void start_dac(struct cs4297a_state *s);
@@ -1535,7 +1535,7 @@ static int cs4297a_open_mixdev(struct inode *inode, struct file *file)
 	CS_DBGOUT(CS_FUNCTION | CS_OPEN, 4,
 		  printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()+\n"));
 
-	lock_kernel();
+	mutex_lock(&swarm_cs4297a_mutex);
 	list_for_each(entry, &cs4297a_devs)
 	{
 		s = list_entry(entry, struct cs4297a_state, list);
@@ -1547,7 +1547,7 @@ static int cs4297a_open_mixdev(struct inode *inode, struct file *file)
 		CS_DBGOUT(CS_FUNCTION | CS_OPEN | CS_ERROR, 2,
 			printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()- -ENODEV\n"));
 
-		unlock_kernel();
+		mutex_unlock(&swarm_cs4297a_mutex);
 		return -ENODEV;
 	}
 	VALIDATE_STATE(s);
@@ -1555,7 +1555,7 @@ static int cs4297a_open_mixdev(struct inode *inode, struct file *file)
 
 	CS_DBGOUT(CS_FUNCTION | CS_OPEN, 4,
 		  printk(KERN_INFO "cs4297a: cs4297a_open_mixdev()- 0\n"));
-	unlock_kernel();
+	mutex_unlock(&swarm_cs4297a_mutex);
 
 	return nonseekable_open(inode, file);
 }
@@ -1575,10 +1575,10 @@ static int cs4297a_ioctl_mixdev(struct file *file,
 			       unsigned int cmd, unsigned long arg)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&swarm_cs4297a_mutex);
 	ret = mixer_ioctl((struct cs4297a_state *) file->private_data, cmd,
 			   arg);
-	unlock_kernel();
+	mutex_unlock(&swarm_cs4297a_mutex);
 	return ret;
 }
 
@@ -2350,9 +2350,9 @@ static long cs4297a_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&swarm_cs4297a_mutex);
 	ret = cs4297a_ioctl(file, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&swarm_cs4297a_mutex);
 
 	return ret;
 }
@@ -2509,9 +2509,9 @@ static int cs4297a_open(struct inode *inode, struct file *file)
 {
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&swarm_cs4297a_mutex);
 	ret = cs4297a_open(inode, file);
-	unlock_kernel();
+	mutex_unlock(&swarm_cs4297a_mutex);
 
 	return ret;
 }
diff --git a/sound/oss/vwsnd.c b/sound/oss/vwsnd.c
index 8cd73cd..643f111 100644
--- a/sound/oss/vwsnd.c
+++ b/sound/oss/vwsnd.c
@@ -145,7 +145,6 @@
 #include <linux/init.h>
 
 #include <linux/spinlock.h>
-#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/interrupt.h>
 #include <linux/mutex.h>
@@ -160,6 +159,7 @@
 
 #ifdef VWSND_DEBUG
 
+static DEFINE_MUTEX(vwsnd_mutex);
 static int shut_up = 1;
 
 /*
@@ -2891,11 +2891,11 @@ static long vwsnd_audio_ioctl(struct file *file,
 	vwsnd_dev_t *devc = (vwsnd_dev_t *) file->private_data;
 	int ret;
 
-	lock_kernel();
+	mutex_lock(&vwsnd_mutex);
 	mutex_lock(&devc->io_mutex);
 	ret = vwsnd_audio_do_ioctl(file, cmd, arg);
 	mutex_unlock(&devc->io_mutex);
-	unlock_kernel();
+	mutex_unlock(&vwsnd_mutex);
 
 	return ret;
 }
@@ -2922,7 +2922,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 
 	DBGE("(inode=0x%p, file=0x%p)\n", inode, file);
 
-	lock_kernel();
+	mutex_lock(&vwsnd_mutex);
 	INC_USE_COUNT;
 	for (devc = vwsnd_dev_list; devc; devc = devc->next_dev)
 		if ((devc->audio_minor & ~0x0F) == (minor & ~0x0F))
@@ -2930,7 +2930,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 
 	if (devc == NULL) {
 		DEC_USE_COUNT;
-		unlock_kernel();
+		mutex_unlock(&vwsnd_mutex);
 		return -ENODEV;
 	}
 
@@ -2939,13 +2939,13 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 		mutex_unlock(&devc->open_mutex);
 		if (file->f_flags & O_NONBLOCK) {
 			DEC_USE_COUNT;
-			unlock_kernel();
+			mutex_unlock(&vwsnd_mutex);
 			return -EBUSY;
 		}
 		interruptible_sleep_on(&devc->open_wait);
 		if (signal_pending(current)) {
 			DEC_USE_COUNT;
-			unlock_kernel();
+			mutex_unlock(&vwsnd_mutex);
 			return -ERESTARTSYS;
 		}
 		mutex_lock(&devc->open_mutex);
@@ -2998,7 +2998,7 @@ static int vwsnd_audio_open(struct inode *inode, struct file *file)
 
 	file->private_data = devc;
 	DBGRV();
-	unlock_kernel();
+	mutex_unlock(&vwsnd_mutex);
 	return 0;
 }
 
@@ -3012,7 +3012,7 @@ static int vwsnd_audio_release(struct inode *inode, struct file *file)
 	vwsnd_port_t *wport = NULL, *rport = NULL;
 	int err = 0;
 
-	lock_kernel();
+	mutex_lock(&vwsnd_mutex);
 	mutex_lock(&devc->io_mutex);
 	{
 		DBGEV("(inode=0x%p, file=0x%p)\n", inode, file);
@@ -3040,7 +3040,7 @@ static int vwsnd_audio_release(struct inode *inode, struct file *file)
 	wake_up(&devc->open_wait);
 	DEC_USE_COUNT;
 	DBGR();
-	unlock_kernel();
+	mutex_unlock(&vwsnd_mutex);
 	return err;
 }
 
@@ -3068,18 +3068,18 @@ static int vwsnd_mixer_open(struct inode *inode, struct file *file)
 	DBGEV("(inode=0x%p, file=0x%p)\n", inode, file);
 
 	INC_USE_COUNT;
-	lock_kernel();
+	mutex_lock(&vwsnd_mutex);
 	for (devc = vwsnd_dev_list; devc; devc = devc->next_dev)
 		if (devc->mixer_minor == iminor(inode))
 			break;
 
 	if (devc == NULL) {
 		DEC_USE_COUNT;
-		unlock_kernel();
+		mutex_unlock(&vwsnd_mutex);
 		return -ENODEV;
 	}
 	file->private_data = devc;
-	unlock_kernel();
+	mutex_unlock(&vwsnd_mutex);
 	return 0;
 }
 
@@ -3223,7 +3223,7 @@ static long vwsnd_mixer_ioctl(struct file *file,
 
 	DBGEV("(devc=0x%p, cmd=0x%x, arg=0x%lx)\n", devc, cmd, arg);
 
-	lock_kernel();
+	mutex_lock(&vwsnd_mutex);
 	mutex_lock(&devc->mix_mutex);
 	{
 		if ((cmd & ~nrmask) == MIXER_READ(0))
@@ -3234,7 +3234,7 @@ static long vwsnd_mixer_ioctl(struct file *file,
 			retval = -EINVAL;
 	}
 	mutex_unlock(&devc->mix_mutex);
-	unlock_kernel();
+	mutex_unlock(&vwsnd_mutex);
 	return retval;
 }
 
-- 
1.7.1

