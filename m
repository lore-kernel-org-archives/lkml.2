Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124Ab0IVLrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 07:47:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45979 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753020Ab0IVLrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 07:47:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=so6TcuZE0ziLuk6PNqrA9DwzRwJ2U0IOa8VXDCPtN9cpQHe8j7tvWpdxpFj6wElNX9
         4mfDgCwccR36hPZetJ0HZZ+1Cp9oWQYu8wWVmS7DLdloDtco2vh2X1WA+mj2JeA+mk1Z
         N4qzPxotZtKydngxlZVtoexs0sLFbgxRSiKBE=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, Jaroslav Kysela <perex@perex.cz>,
        ralf@linux-mips.org, Frederic Weisbecker <fweisbec@gmail.com>,
        John Kacur <jkacur@redhat.com>
Subject: [PATCH] SOUND-OSS: Remove sh_dac_audio
Date: Wed, 22 Sep 2010 13:47:01 +0200
Message-Id: <1285156021-4973-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the SH DAC oss driver since there is an equivalent alsa driver.
oss has been deprecated for years. Furthermore this driver has BKL code
which we are trying to remove. Rather than attempt to fix this, simply
remove the driver.

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 sound/oss/Kconfig        |    8 -
 sound/oss/Makefile       |    1 -
 sound/oss/sh_dac_audio.c |  325 ----------------------------------------------
 3 files changed, 0 insertions(+), 334 deletions(-)
 delete mode 100644 sound/oss/sh_dac_audio.c

diff --git a/sound/oss/Kconfig b/sound/oss/Kconfig
index a513651..76c0902 100644
--- a/sound/oss/Kconfig
+++ b/sound/oss/Kconfig
@@ -545,11 +545,3 @@ config SOUND_KAHLUA
 
 endif	# SOUND_OSS
 
-config SOUND_SH_DAC_AUDIO
-	tristate "SuperH DAC audio support"
-	depends on CPU_SH3 && HIGH_RES_TIMERS
-
-config SOUND_SH_DAC_AUDIO_CHANNEL
-	int "DAC channel"
-	default "1"
-	depends on SOUND_SH_DAC_AUDIO
diff --git a/sound/oss/Makefile b/sound/oss/Makefile
index 567b8a7..96f14dc 100644
--- a/sound/oss/Makefile
+++ b/sound/oss/Makefile
@@ -9,7 +9,6 @@ obj-$(CONFIG_SOUND_OSS)		+= sound.o
 
 # Please leave it as is, cause the link order is significant !
 
-obj-$(CONFIG_SOUND_SH_DAC_AUDIO)	+= sh_dac_audio.o
 obj-$(CONFIG_SOUND_AEDSP16)	+= aedsp16.o
 obj-$(CONFIG_SOUND_PSS)		+= pss.o ad1848.o mpu401.o
 obj-$(CONFIG_SOUND_TRIX)	+= trix.o ad1848.o sb_lib.o uart401.o
diff --git a/sound/oss/sh_dac_audio.c b/sound/oss/sh_dac_audio.c
deleted file mode 100644
index 479e302..0000000
--- a/sound/oss/sh_dac_audio.c
+++ /dev/null
@@ -1,325 +0,0 @@
-/*
- * sound/oss/sh_dac_audio.c
- *
- * SH DAC based sound :(
- *
- *  Copyright (C) 2004,2005  Andriy Skulysh
- *
- * This file is subject to the terms and conditions of the GNU General Public
- * License.  See the file "COPYING" in the main directory of this archive
- * for more details.
- */
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/sched.h>
-#include <linux/linkage.h>
-#include <linux/slab.h>
-#include <linux/fs.h>
-#include <linux/sound.h>
-#include <linux/smp_lock.h>
-#include <linux/soundcard.h>
-#include <linux/interrupt.h>
-#include <linux/hrtimer.h>
-#include <asm/io.h>
-#include <asm/uaccess.h>
-#include <asm/irq.h>
-#include <asm/delay.h>
-#include <asm/clock.h>
-#include <cpu/dac.h>
-#include <asm/machvec.h>
-#include <mach/hp6xx.h>
-#include <asm/hd64461.h>
-
-#define MODNAME "sh_dac_audio"
-
-#define BUFFER_SIZE 48000
-
-static int rate;
-static int empty;
-static char *data_buffer, *buffer_begin, *buffer_end;
-static int in_use, device_major;
-static struct hrtimer hrtimer;
-static ktime_t wakeups_per_second;
-
-static void dac_audio_start_timer(void)
-{
-	hrtimer_start(&hrtimer, wakeups_per_second, HRTIMER_MODE_REL);
-}
-
-static void dac_audio_stop_timer(void)
-{
-	hrtimer_cancel(&hrtimer);
-}
-
-static void dac_audio_reset(void)
-{
-	dac_audio_stop_timer();
-	buffer_begin = buffer_end = data_buffer;
-	empty = 1;
-}
-
-static void dac_audio_sync(void)
-{
-	while (!empty)
-		schedule();
-}
-
-static void dac_audio_start(void)
-{
-	if (mach_is_hp6xx()) {
-		u16 v = __raw_readw(HD64461_GPADR);
-		v &= ~HD64461_GPADR_SPEAKER;
-		__raw_writew(v, HD64461_GPADR);
-	}
-
-	sh_dac_enable(CONFIG_SOUND_SH_DAC_AUDIO_CHANNEL);
-}
-static void dac_audio_stop(void)
-{
-	dac_audio_stop_timer();
-
-	if (mach_is_hp6xx()) {
-		u16 v = __raw_readw(HD64461_GPADR);
-		v |= HD64461_GPADR_SPEAKER;
-		__raw_writew(v, HD64461_GPADR);
-	}
-
-	sh_dac_output(0, CONFIG_SOUND_SH_DAC_AUDIO_CHANNEL);
-	sh_dac_disable(CONFIG_SOUND_SH_DAC_AUDIO_CHANNEL);
-}
-
-static void dac_audio_set_rate(void)
-{
-	wakeups_per_second = ktime_set(0, 1000000000 / rate);
-}
-
-static int dac_audio_ioctl(struct file *file,
-			   unsigned int cmd, unsigned long arg)
-{
-	int val;
-
-	switch (cmd) {
-	case OSS_GETVERSION:
-		return put_user(SOUND_VERSION, (int *)arg);
-
-	case SNDCTL_DSP_SYNC:
-		dac_audio_sync();
-		return 0;
-
-	case SNDCTL_DSP_RESET:
-		dac_audio_reset();
-		return 0;
-
-	case SNDCTL_DSP_GETFMTS:
-		return put_user(AFMT_U8, (int *)arg);
-
-	case SNDCTL_DSP_SETFMT:
-		return put_user(AFMT_U8, (int *)arg);
-
-	case SNDCTL_DSP_NONBLOCK:
-		spin_lock(&file->f_lock);
-		file->f_flags |= O_NONBLOCK;
-		spin_unlock(&file->f_lock);
-		return 0;
-
-	case SNDCTL_DSP_GETCAPS:
-		return 0;
-
-	case SOUND_PCM_WRITE_RATE:
-		val = *(int *)arg;
-		if (val > 0) {
-			rate = val;
-			dac_audio_set_rate();
-		}
-		return put_user(rate, (int *)arg);
-
-	case SNDCTL_DSP_STEREO:
-		return put_user(0, (int *)arg);
-
-	case SOUND_PCM_WRITE_CHANNELS:
-		return put_user(1, (int *)arg);
-
-	case SNDCTL_DSP_SETDUPLEX:
-		return -EINVAL;
-
-	case SNDCTL_DSP_PROFILE:
-		return -EINVAL;
-
-	case SNDCTL_DSP_GETBLKSIZE:
-		return put_user(BUFFER_SIZE, (int *)arg);
-
-	case SNDCTL_DSP_SETFRAGMENT:
-		return 0;
-
-	default:
-		printk(KERN_ERR "sh_dac_audio: unimplemented ioctl=0x%x\n",
-		       cmd);
-		return -EINVAL;
-	}
-	return -EINVAL;
-}
-
-static long dac_audio_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
-{
-	int ret;
-
-	lock_kernel();
-	ret = dac_audio_ioctl(file, cmd, arg);
-	unlock_kernel();
-
-	return ret;
-}
-
-static ssize_t dac_audio_write(struct file *file, const char *buf, size_t count,
-			       loff_t * ppos)
-{
-	int free;
-	int nbytes;
-
-	if (!count) {
-		dac_audio_sync();
-		return 0;
-	}
-
-	free = buffer_begin - buffer_end;
-
-	if (free < 0)
-		free += BUFFER_SIZE;
-	if ((free == 0) && (empty))
-		free = BUFFER_SIZE;
-	if (count > free)
-		count = free;
-	if (buffer_begin > buffer_end) {
-		if (copy_from_user((void *)buffer_end, buf, count))
-			return -EFAULT;
-
-		buffer_end += count;
-	} else {
-		nbytes = data_buffer + BUFFER_SIZE - buffer_end;
-		if (nbytes > count) {
-			if (copy_from_user((void *)buffer_end, buf, count))
-				return -EFAULT;
-			buffer_end += count;
-		} else {
-			if (copy_from_user((void *)buffer_end, buf, nbytes))
-				return -EFAULT;
-			if (copy_from_user
-			    ((void *)data_buffer, buf + nbytes, count - nbytes))
-				return -EFAULT;
-			buffer_end = data_buffer + count - nbytes;
-		}
-	}
-
-	if (empty) {
-		empty = 0;
-		dac_audio_start_timer();
-	}
-
-	return count;
-}
-
-static ssize_t dac_audio_read(struct file *file, char *buf, size_t count,
-			      loff_t * ppos)
-{
-	return -EINVAL;
-}
-
-static int dac_audio_open(struct inode *inode, struct file *file)
-{
-	if (file->f_mode & FMODE_READ)
-		return -ENODEV;
-
-	lock_kernel();
-	if (in_use) {
-		unlock_kernel();
-		return -EBUSY;
-	}
-
-	in_use = 1;
-
-	dac_audio_start();
-	unlock_kernel();
-	return 0;
-}
-
-static int dac_audio_release(struct inode *inode, struct file *file)
-{
-	dac_audio_sync();
-	dac_audio_stop();
-	in_use = 0;
-
-	return 0;
-}
-
-const struct file_operations dac_audio_fops = {
-      .read =		dac_audio_read,
-      .write =		dac_audio_write,
-      .unlocked_ioctl =	dac_audio_unlocked_ioctl,
-      .open =		dac_audio_open,
-      .release =	dac_audio_release,
-};
-
-static enum hrtimer_restart sh_dac_audio_timer(struct hrtimer *handle)
-{
-	if (!empty) {
-		sh_dac_output(*buffer_begin, CONFIG_SOUND_SH_DAC_AUDIO_CHANNEL);
-		buffer_begin++;
-
-		if (buffer_begin == data_buffer + BUFFER_SIZE)
-			buffer_begin = data_buffer;
-		if (buffer_begin == buffer_end)
-			empty = 1;
-	}
-
-	if (!empty)
-		hrtimer_start(&hrtimer, wakeups_per_second, HRTIMER_MODE_REL);
-
-	return HRTIMER_NORESTART;
-}
-
-static int __init dac_audio_init(void)
-{
-	if ((device_major = register_sound_dsp(&dac_audio_fops, -1)) < 0) {
-		printk(KERN_ERR "Cannot register dsp device");
-		return device_major;
-	}
-
-	in_use = 0;
-
-	data_buffer = kmalloc(BUFFER_SIZE, GFP_KERNEL);
-	if (data_buffer == NULL)
-		return -ENOMEM;
-
-	dac_audio_reset();
-	rate = 8000;
-	dac_audio_set_rate();
-
-	/* Today: High Resolution Timer driven DAC playback.
-	 * The timer callback gets called once per sample. Ouch.
-	 *
-	 * Future: A much better approach would be to use the
-	 * SH7720 CMT+DMAC+DAC hardware combination like this:
-	 * - Program sample rate using CMT0 or CMT1
-	 * - Program DMAC to use CMT for timing and output to DAC
-	 * - Play sound using DMAC, let CPU sleep.
-	 * - While at it, rewrite this driver to use ALSA.
-	 */
-
-	hrtimer_init(&hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hrtimer.function = sh_dac_audio_timer;
-
-	return 0;
-}
-
-static void __exit dac_audio_exit(void)
-{
-	unregister_sound_dsp(device_major);
-	kfree((void *)data_buffer);
-}
-
-module_init(dac_audio_init);
-module_exit(dac_audio_exit);
-
-MODULE_AUTHOR("Andriy Skulysh, askulysh@image.kiev.ua");
-MODULE_DESCRIPTION("SH DAC sound driver");
-MODULE_LICENSE("GPL");
-- 
1.7.2.2

