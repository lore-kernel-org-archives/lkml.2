Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0LIWxR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:53:17 -0500
Received: from kroah.org ([198.145.64.141]:45704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755420Ab0LIWvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:51:55 -0500
Date: Thu, 9 Dec 2010 14:49:16 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.57
Message-ID: <20101209224916.GB2777@kroah.com>
References: <20101209224902.GA2777@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101209224902.GA2777@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 09b28c8..379c5d9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .56
+EXTRAVERSION = .57
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/arm/lib/findbit.S b/arch/arm/lib/findbit.S
index a5ca024..dc91d2d 100644
--- a/arch/arm/lib/findbit.S
+++ b/arch/arm/lib/findbit.S
@@ -148,8 +148,8 @@ ENTRY(_find_next_bit_be)
  */
 .L_found:
 #if __LINUX_ARM_ARCH__ >= 5
-		rsb	r1, r3, #0
-		and	r3, r3, r1
+		rsb	r0, r3, #0
+		and	r3, r3, r0
 		clz	r3, r3
 		rsb	r3, r3, #31
 		add	r0, r2, r3
@@ -164,5 +164,7 @@ ENTRY(_find_next_bit_be)
 		addeq	r2, r2, #1
 		mov	r0, r2
 #endif
+		cmp	r1, r0			@ Clamp to maxbit
+		movlo	r0, r1
 		mov	pc, lr
 
diff --git a/arch/um/os-Linux/time.c b/arch/um/os-Linux/time.c
index dec5678..6e3359d 100644
--- a/arch/um/os-Linux/time.c
+++ b/arch/um/os-Linux/time.c
@@ -60,7 +60,7 @@ static inline long long timeval_to_ns(const struct timeval *tv)
 long long disable_timer(void)
 {
 	struct itimerval time = ((struct itimerval) { { 0, 0 }, { 0, 0 } });
-	int remain, max = UM_NSEC_PER_SEC / UM_HZ;
+	long long remain, max = UM_NSEC_PER_SEC / UM_HZ;
 
 	if (setitimer(ITIMER_VIRTUAL, &time, &time) < 0)
 		printk(UM_KERN_ERR "disable_timer - setitimer failed, "
diff --git a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
index 9943b4c..810ca03 100644
--- a/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
+++ b/arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
@@ -742,6 +742,7 @@ static int acpi_cpufreq_cpu_exit(struct cpufreq_policy *policy)
 		per_cpu(drv_data, policy->cpu) = NULL;
 		acpi_processor_unregister_performance(data->acpi_data,
 						      policy->cpu);
+		kfree(data->freq_table);
 		kfree(data);
 	}
 
diff --git a/block/blk-map.c b/block/blk-map.c
index af37e4a..bdf10b9 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -191,6 +191,8 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 			unaligned = 1;
 			break;
 		}
+		if (!iov[i].iov_len)
+			return -EINVAL;
 	}
 
 	if (unaligned || (q->dma_pad_mask & len))
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9d3ba4..feba425 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2371,8 +2371,11 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 		 *
 		 * If door lock fails, always clear sdev->locked to
 		 * avoid this infinite loop.
+		 *
+		 * This may happen before SCSI scan is complete.  Make
+		 * sure qc->dev->sdev isn't NULL before dereferencing.
 		 */
-		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL)
+		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
 			qc->dev->sdev->locked = 0;
 
 		qc->scsicmd->result = SAM_STAT_CHECK_CONDITION;
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index c904e9a..91d5e90 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -371,6 +371,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 	struct kbd_struct * kbd;
 	unsigned int console;
 	unsigned char ucval;
+	unsigned int uival;
 	void __user *up = (void __user *)arg;
 	int i, perm;
 	int ret = 0;
@@ -516,7 +517,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGETMODE:
-		ucval = vc->vc_mode;
+		uival = vc->vc_mode;
 		goto setint;
 
 	case KDMAPDISP:
@@ -554,7 +555,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGKBMODE:
-		ucval = ((kbd->kbdmode == VC_RAW) ? K_RAW :
+		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
 				 K_XLATE);
@@ -576,9 +577,9 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		break;
 
 	case KDGKBMETA:
-		ucval = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
+		uival = (vc_kbd_mode(kbd, VC_META) ? K_ESCPREFIX : K_METABIT);
 	setint:
-		ret = put_user(ucval, (int __user *)arg);
+		ret = put_user(uival, (int __user *)arg);
 		break;
 
 	case KDGETKEYCODE:
@@ -808,7 +809,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (! VT_IS_IN_USE(i))
 				break;
-		ucval = i < MAX_NR_CONSOLES ? (i+1) : -1;
+		uival = i < MAX_NR_CONSOLES ? (i+1) : -1;
 		goto setint;		 
 
 	/*
diff --git a/drivers/media/video/ivtv/ivtvfb.c b/drivers/media/video/ivtv/ivtvfb.c
index bdfda48..f5b03db 100644
--- a/drivers/media/video/ivtv/ivtvfb.c
+++ b/drivers/media/video/ivtv/ivtvfb.c
@@ -460,6 +460,8 @@ static int ivtvfb_ioctl(struct fb_info *info, unsigned int cmd, unsigned long ar
 			struct fb_vblank vblank;
 			u32 trace;
 
+			memset(&vblank, 0, sizeof(struct fb_vblank));
+
 			vblank.flags = FB_VBLANK_HAVE_COUNT |FB_VBLANK_HAVE_VCOUNT |
 					FB_VBLANK_HAVE_VSYNC;
 			trace = read_reg(0x028c0) >> 16;
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index b6483dd..0ccbc78 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2258,7 +2258,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_status, S_IWUGO | S_IRUGO, read_status, reboot);
+static DEVICE_ATTR(stat_status, S_IWUSR | S_IRUGO, read_status, reboot);
 
 static ssize_t read_human_status(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2321,7 +2321,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_human_status, S_IWUGO | S_IRUGO, read_human_status, NULL);
+static DEVICE_ATTR(stat_human_status, S_IRUGO, read_human_status, NULL);
 
 static ssize_t read_delin(struct device *dev, struct device_attribute *attr,
 		char *buf)
@@ -2353,7 +2353,7 @@ out:
 	return ret;
 }
 
-static DEVICE_ATTR(stat_delin, S_IWUGO | S_IRUGO, read_delin, NULL);
+static DEVICE_ATTR(stat_delin, S_IRUGO, read_delin, NULL);
 
 #define UEA_ATTR(name, reset) 					\
 								\
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 8657266..a3397c8 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -883,10 +883,11 @@ static int proc_getdriver(struct dev_state *ps, void __user *arg)
 
 static int proc_connectinfo(struct dev_state *ps, void __user *arg)
 {
-	struct usbdevfs_connectinfo ci;
+	struct usbdevfs_connectinfo ci = {
+		.devnum = ps->dev->devnum,
+		.slow = ps->dev->speed == USB_SPEED_LOW
+	};
 
-	ci.devnum = ps->dev->devnum;
-	ci.slow = ps->dev->speed == USB_SPEED_LOW;
 	if (copy_to_user(arg, &ci, sizeof(ci)))
 		return -EFAULT;
 	return 0;
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index 6ef2a89..b1690ba 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -954,10 +954,11 @@ rescan:
 				tmp && tmp != qh;
 				tmp = tmp->qh_next.qh)
 			continue;
-		/* periodic qh self-unlinks on empty */
-		if (!tmp)
-			goto nogood;
-		unlink_async (ehci, qh);
+		/* periodic qh self-unlinks on empty, and a COMPLETING qh
+		 * may already be unlinked.
+		 */
+		if (tmp)
+			unlink_async(ehci, qh);
 		/* FALL THROUGH */
 	case QH_STATE_UNLINK:		/* wait for hw to finish? */
 	case QH_STATE_UNLINK_WAIT:
@@ -972,7 +973,6 @@ idle_timeout:
 		}
 		/* else FALL THROUGH */
 	default:
-nogood:
 		/* caller was supposed to have unlinked any requests;
 		 * that's not our job.  just leak this memory.
 		 */
diff --git a/drivers/usb/misc/cypress_cy7c63.c b/drivers/usb/misc/cypress_cy7c63.c
index 9379404..3465c1f 100644
--- a/drivers/usb/misc/cypress_cy7c63.c
+++ b/drivers/usb/misc/cypress_cy7c63.c
@@ -195,11 +195,9 @@ static ssize_t get_port1_handler(struct device *dev,
 	return read_port(dev, attr, buf, 1, CYPRESS_READ_PORT_ID1);
 }
 
-static DEVICE_ATTR(port0, S_IWUGO | S_IRUGO,
-		   get_port0_handler, set_port0_handler);
+static DEVICE_ATTR(port0, S_IRUGO | S_IWUSR, get_port0_handler, set_port0_handler);
 
-static DEVICE_ATTR(port1, S_IWUGO | S_IRUGO,
-		   get_port1_handler, set_port1_handler);
+static DEVICE_ATTR(port1, S_IRUGO | S_IWUSR, get_port1_handler, set_port1_handler);
 
 
 static int cypress_probe(struct usb_interface *interface,
diff --git a/drivers/usb/misc/iowarrior.c b/drivers/usb/misc/iowarrior.c
index a4ef77e..2f75bb0 100644
--- a/drivers/usb/misc/iowarrior.c
+++ b/drivers/usb/misc/iowarrior.c
@@ -551,6 +551,7 @@ static long iowarrior_ioctl(struct file *file, unsigned int cmd,
 			/* needed for power consumption */
 			struct usb_config_descriptor *cfg_descriptor = &dev->udev->actconfig->desc;
 
+			memset(&info, 0, sizeof(info));
 			/* directly from the descriptor */
 			info.vendor = le16_to_cpu(dev->udev->descriptor.idVendor);
 			info.product = dev->product_id;
diff --git a/drivers/usb/misc/sisusbvga/sisusb.c b/drivers/usb/misc/sisusbvga/sisusb.c
index 69c34a5..7c9a914 100644
--- a/drivers/usb/misc/sisusbvga/sisusb.c
+++ b/drivers/usb/misc/sisusbvga/sisusb.c
@@ -3031,6 +3031,7 @@ sisusb_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 #else
 			x.sisusb_conactive  = 0;
 #endif
+			memset(x.sisusb_reserved, 0, sizeof(x.sisusb_reserved));
 
 			if (copy_to_user((void __user *)arg, &x, sizeof(x)))
 				retval = -EFAULT;
diff --git a/drivers/usb/misc/trancevibrator.c b/drivers/usb/misc/trancevibrator.c
index 03368ed..9bd59e6 100644
--- a/drivers/usb/misc/trancevibrator.c
+++ b/drivers/usb/misc/trancevibrator.c
@@ -85,7 +85,7 @@ static ssize_t set_speed(struct device *dev, struct device_attribute *attr,
 	return count;
 }
 
-static DEVICE_ATTR(speed, S_IWUGO | S_IRUGO, show_speed, set_speed);
+static DEVICE_ATTR(speed, S_IRUGO | S_IWUSR, show_speed, set_speed);
 
 static int tv_probe(struct usb_interface *interface,
 		    const struct usb_device_id *id)
diff --git a/drivers/usb/misc/usbled.c b/drivers/usb/misc/usbled.c
index 06cb719..9650de9 100644
--- a/drivers/usb/misc/usbled.c
+++ b/drivers/usb/misc/usbled.c
@@ -94,7 +94,7 @@ static ssize_t set_##value(struct device *dev, struct device_attribute *attr, co
 	change_color(led);						\
 	return count;							\
 }									\
-static DEVICE_ATTR(value, S_IWUGO | S_IRUGO, show_##value, set_##value);
+static DEVICE_ATTR(value, S_IRUGO | S_IWUSR, show_##value, set_##value);
 show_set(blue);
 show_set(red);
 show_set(green);
diff --git a/drivers/usb/storage/sierra_ms.c b/drivers/usb/storage/sierra_ms.c
index 4359a2c..78ed40e 100644
--- a/drivers/usb/storage/sierra_ms.c
+++ b/drivers/usb/storage/sierra_ms.c
@@ -120,7 +120,7 @@ static ssize_t show_truinst(struct device *dev, struct device_attribute *attr,
 	}
 	return result;
 }
-static DEVICE_ATTR(truinst, S_IWUGO | S_IRUGO, show_truinst, NULL);
+static DEVICE_ATTR(truinst, S_IRUGO, show_truinst, NULL);
 
 int sierra_ms_init(struct us_data *us)
 {
diff --git a/fs/bio.c b/fs/bio.c
index 3cba7ae..4ad38a6 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -593,6 +593,12 @@ struct bio *bio_copy_user_iov(struct request_queue *q, struct sg_iovec *iov,
 		end = (uaddr + iov[i].iov_len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		start = uaddr >> PAGE_SHIFT;
 
+		/*
+		 * Overflow, abort
+		 */
+		if (end < start)
+			return ERR_PTR(-EINVAL);
+
 		nr_pages += end - start;
 		len += iov[i].iov_len;
 	}
@@ -691,6 +697,12 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 		unsigned long end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 		unsigned long start = uaddr >> PAGE_SHIFT;
 
+		/*
+		 * Overflow, abort
+		 */
+		if (end < start)
+			return ERR_PTR(-EINVAL);
+
 		nr_pages += end - start;
 		/*
 		 * buffer must be aligned to at least hardsector size for now
@@ -718,7 +730,7 @@ static struct bio *__bio_map_user_iov(struct request_queue *q,
 		unsigned long start = uaddr >> PAGE_SHIFT;
 		const int local_nr_pages = end - start;
 		const int page_limit = cur_page + local_nr_pages;
-		
+
 		ret = get_user_pages_fast(uaddr, local_nr_pages,
 				write_to_vm, &pages[cur_page]);
 		if (ret < local_nr_pages) {
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 1c1220e..30f9a51 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -70,15 +70,19 @@ ecryptfs_create_underlying_file(struct inode *lower_dir_inode,
 	struct vfsmount *lower_mnt = ecryptfs_dentry_to_lower_mnt(dentry);
 	struct dentry *dentry_save;
 	struct vfsmount *vfsmount_save;
+	unsigned int flags_save;
 	int rc;
 
 	dentry_save = nd->path.dentry;
 	vfsmount_save = nd->path.mnt;
+	flags_save = nd->flags;
 	nd->path.dentry = lower_dentry;
 	nd->path.mnt = lower_mnt;
+	nd->flags &= ~LOOKUP_OPEN;
 	rc = vfs_create(lower_dir_inode, lower_dentry, mode, nd);
 	nd->path.dentry = dentry_save;
 	nd->path.mnt = vfsmount_save;
+	nd->flags = flags_save;
 	return rc;
 }
 
diff --git a/include/net/x25.h b/include/net/x25.h
index 2cda040..21926a0 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -182,6 +182,10 @@ extern int  sysctl_x25_clear_request_timeout;
 extern int  sysctl_x25_ack_holdback_timeout;
 extern int  sysctl_x25_forward;
 
+extern int x25_parse_address_block(struct sk_buff *skb,
+		struct x25_address *called_addr,
+		struct x25_address *calling_addr);
+
 extern int  x25_addr_ntoa(unsigned char *, struct x25_address *,
 			  struct x25_address *);
 extern int  x25_addr_aton(unsigned char *, struct x25_address *,
diff --git a/ipc/compat.c b/ipc/compat.c
index ab76fb0..5e3e3a1 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -242,6 +242,8 @@ long compat_sys_semctl(int first, int second, int third, void __user *uptr)
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
+	memset(&s64, 0, sizeof(s64));
+
 	if (!uptr)
 		return -EINVAL;
 	if (get_user(pad, (u32 __user *) uptr))
@@ -422,6 +424,8 @@ long compat_sys_msgctl(int first, int second, void __user *uptr)
 	int version = compat_ipc_parse_version(&second);
 	void __user *p;
 
+	memset(&m64, 0, sizeof(m64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_INFO:
 	case IPC_RMID:
@@ -595,6 +599,8 @@ long compat_sys_shmctl(int first, int second, void __user *uptr)
 	int err, err2;
 	int version = compat_ipc_parse_version(&second);
 
+	memset(&s64, 0, sizeof(s64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_RMID:
 	case SHM_LOCK:
diff --git a/ipc/compat_mq.c b/ipc/compat_mq.c
index d8d1e9f..380ea4f 100644
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
@@ -53,6 +53,9 @@ asmlinkage long compat_sys_mq_open(const char __user *u_name,
 	void __user *p = NULL;
 	if (u_attr && oflag & O_CREAT) {
 		struct mq_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
 		p = compat_alloc_user_space(sizeof(attr));
 		if (get_compat_mq_attr(&attr, u_attr) ||
 		    copy_to_user(p, &attr, sizeof(attr)))
@@ -127,6 +130,8 @@ asmlinkage long compat_sys_mq_getsetattr(mqd_t mqdes,
 	struct mq_attr __user *p = compat_alloc_user_space(2 * sizeof(*p));
 	long ret;
 
+	memset(&mqstat, 0, sizeof(mqstat));
+
 	if (u_mqstat) {
 		if (get_compat_mq_attr(&mqstat, u_mqstat) ||
 		    copy_to_user(p, &mqstat, sizeof(mqstat)))
diff --git a/ipc/sem.c b/ipc/sem.c
index 0c0b28e..0cd0c51 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -560,6 +560,8 @@ static unsigned long copy_semid_to_user(void __user *buf, struct semid64_ds *in,
 	    {
 		struct semid_ds out;
 
+		memset(&out, 0, sizeof(out));
+
 		ipc64_perm_to_ipc_perm(&in->sem_perm, &out.sem_perm);
 
 		out.sem_otime	= in->sem_otime;
diff --git a/ipc/shm.c b/ipc/shm.c
index 37caa44..dfca4d8 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -469,6 +469,7 @@ static inline unsigned long copy_shmid_to_user(void __user *buf, struct shmid64_
 	    {
 		struct shmid_ds out;
 
+		memset(&out, 0, sizeof(out));
 		ipc64_perm_to_ipc_perm(&in->shm_perm, &out.shm_perm);
 		out.shm_segsz	= in->shm_segsz;
 		out.shm_atime	= in->shm_atime;
diff --git a/kernel/exit.c b/kernel/exit.c
index 8715136..ac5ab8c 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1004,6 +1004,15 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	/*
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index a866389..4950d88 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -81,6 +81,7 @@ int percpu_counter_init(struct percpu_counter *fbc, s64 amount)
 	if (!fbc->counters)
 		return -ENOMEM;
 #ifdef CONFIG_HOTPLUG_CPU
+	INIT_LIST_HEAD(&fbc->list);
 	mutex_lock(&percpu_counters_lock);
 	list_add(&fbc->list, &percpu_counters);
 	mutex_unlock(&percpu_counters_lock);
diff --git a/mm/internal.h b/mm/internal.h
index 92729ea..362319a 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -49,7 +49,7 @@ extern void __free_pages_bootmem(struct page *page, unsigned int order);
  */
 static inline unsigned long page_order(struct page *page)
 {
-	VM_BUG_ON(!PageBuddy(page));
+	/* PageBuddy() must be checked by the caller */
 	return page_private(page);
 }
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 89fee2d..070b4da 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -612,7 +612,7 @@ static int test_pages_in_a_zone(unsigned long start_pfn, unsigned long end_pfn)
  * Scanning pfn is much easier than scanning lru list.
  * Scan pfn from start to end and Find LRU page.
  */
-int scan_lru_pages(unsigned long start, unsigned long end)
+unsigned long scan_lru_pages(unsigned long start, unsigned long end)
 {
 	unsigned long pfn;
 	struct page *page;
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index b759b7d..3981302 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1404,7 +1404,7 @@ unsigned slab_node(struct mempolicy *policy)
 		(void)first_zones_zonelist(zonelist, highest_zoneidx,
 							&policy->v.nodes,
 							&zone);
-		return zone->node;
+		return zone ? zone->node : numa_node_id();
 	}
 
 	default:
diff --git a/net/can/bcm.c b/net/can/bcm.c
index be700a5..7a4c818 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -121,7 +121,7 @@ struct bcm_sock {
 	struct list_head tx_ops;
 	unsigned long dropped_usr_msgs;
 	struct proc_dir_entry *bcm_proc_read;
-	char procname [9]; /* pointer printed in ASCII with \0 */
+	char procname [20]; /* pointer printed in ASCII with \0 */
 };
 
 static inline struct bcm_sock *bcm_sk(const struct sock *sk)
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 14ada53..ffe8509 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -256,7 +256,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
 	if (regs.len > reglen)
 		regs.len = reglen;
 
-	regbuf = kmalloc(reglen, GFP_USER);
+	regbuf = kzalloc(reglen, GFP_USER);
 	if (!regbuf)
 		return -ENOMEM;
 
diff --git a/net/core/stream.c b/net/core/stream.c
index a6b3437..b07e5fa 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -139,10 +139,10 @@ int sk_stream_wait_memory(struct sock *sk, long *timeo_p)
 
 		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
-		sk_wait_event(sk, &current_timeo, !sk->sk_err &&
-						  !(sk->sk_shutdown & SEND_SHUTDOWN) &&
-						  sk_stream_memory_free(sk) &&
-						  vm_wait);
+		sk_wait_event(sk, &current_timeo, sk->sk_err ||
+						  (sk->sk_shutdown & SEND_SHUTDOWN) ||
+						  (sk_stream_memory_free(sk) &&
+						  !vm_wait));
 		sk->sk_write_pending--;
 
 		if (vm_wait) {
diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index 3c23ab3..1140f81 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -1558,6 +1558,8 @@ static int __dn_getsockopt(struct socket *sock, int level,int optname, char __us
 			if (r_len > sizeof(struct linkinfo_dn))
 				r_len = sizeof(struct linkinfo_dn);
 
+			memset(&link, 0, sizeof(link));
+
 			switch(sock->state) {
 				case SS_CONNECTING:
 					link.idn_linkstate = LL_CONNECTING;
diff --git a/net/econet/af_econet.c b/net/econet/af_econet.c
index 9aae86f..2aa1786 100644
--- a/net/econet/af_econet.c
+++ b/net/econet/af_econet.c
@@ -296,23 +296,14 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 	mutex_lock(&econet_mutex);
 
-	if (saddr == NULL) {
-		struct econet_sock *eo = ec_sk(sk);
-
-		addr.station = eo->station;
-		addr.net     = eo->net;
-		port	     = eo->port;
-		cb	     = eo->cb;
-	} else {
-		if (msg->msg_namelen < sizeof(struct sockaddr_ec)) {
-			mutex_unlock(&econet_mutex);
-			return -EINVAL;
-		}
-		addr.station = saddr->addr.station;
-		addr.net = saddr->addr.net;
-		port = saddr->port;
-		cb = saddr->cb;
-	}
+        if (saddr == NULL || msg->msg_namelen < sizeof(struct sockaddr_ec)) {
+                mutex_unlock(&econet_mutex);
+                return -EINVAL;
+        }
+        addr.station = saddr->addr.station;
+        addr.net = saddr->addr.net;
+        port = saddr->port;
+        cb = saddr->cb;
 
 	/* Look for a device with the right network number. */
 	dev = net2dev_map[addr.net];
@@ -350,7 +341,6 @@ static int econet_sendmsg(struct kiocb *iocb, struct socket *sock,
 
 		eb = (struct ec_cb *)&skb->cb;
 
-		/* BUG: saddr may be NULL */
 		eb->cookie = saddr->cookie;
 		eb->sec = *saddr;
 		eb->sent = ec_tx_done;
@@ -671,6 +661,9 @@ static int ec_dev_ioctl(struct socket *sock, unsigned int cmd, void __user *arg)
 	err = 0;
 	switch (cmd) {
 	case SIOCSIFADDR:
+		if (!capable(CAP_NET_ADMIN))
+			return -EPERM;
+
 		edev = dev->ec_ptr;
 		if (edev == NULL) {
 			/* Magic up a new one. */
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 9440ba6..dc2caaf 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -347,8 +347,6 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 	 */
 
 	mask = 0;
-	if (sk->sk_err)
-		mask = POLLERR;
 
 	/*
 	 * POLLHUP is certainly not done right. But poll() doesn't
@@ -413,6 +411,11 @@ unsigned int tcp_poll(struct file *file, struct socket *sock, poll_table *wait)
 		if (tp->urg_data & TCP_URG_VALID)
 			mask |= POLLPRI;
 	}
+	/* This barrier is coupled with smp_wmb() in tcp_reset() */
+	smp_rmb();
+	if (sk->sk_err)
+		mask |= POLLERR;
+
 	return mask;
 }
 
@@ -2754,12 +2757,14 @@ void __init tcp_init(void)
 
 	/* Set the pressure threshold to be a fraction of global memory that
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
-	 * memory, with a floor of 128 pages.
+	 * memory, with a floor of 128 pages, and a ceiling that prevents an
+	 * integer overflow.
 	 */
 	nr_pages = totalram_pages - totalhigh_pages;
 	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
 	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
+	limit = min(limit, INT_MAX * 4UL / 3 / 2);
 	sysctl_tcp_mem[0] = limit / 4 * 3;
 	sysctl_tcp_mem[1] = limit;
 	sysctl_tcp_mem[2] = sysctl_tcp_mem[0] * 2;
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 4eca4d3..8d2f942 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -3617,6 +3617,8 @@ static void tcp_reset(struct sock *sk)
 	default:
 		sk->sk_err = ECONNRESET;
 	}
+	/* This barrier is coupled with smp_rmb() in tcp_poll() */
+	smp_wmb();
 
 	if (!sock_flag(sk, SOCK_DEAD))
 		sk->sk_error_report(sk);
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index a9b62ee..0ef8809 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1722,11 +1722,13 @@ void __init udp_init(void)
 
 	/* Set the pressure threshold up by the same strategy of TCP. It is a
 	 * fraction of global memory that is up to 1/2 at 256 MB, decreasing
-	 * toward zero with the amount of memory, with a floor of 128 pages.
+	 * toward zero with the amount of memory, with a floor of 128 pages,
+	 * and a ceiling that prevents an integer overflow.
 	 */
 	limit = min(nr_all_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
 	limit = (limit * (nr_all_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
+	limit = min(limit, INT_MAX * 4UL / 3 / 2);
 	sysctl_udp_mem[0] = limit / 4 * 3;
 	sysctl_udp_mem[1] = limit;
 	sysctl_udp_mem[2] = sysctl_udp_mem[0] * 2;
diff --git a/net/ipv4/xfrm4_policy.c b/net/ipv4/xfrm4_policy.c
index c63de0a..e4454c9 100644
--- a/net/ipv4/xfrm4_policy.c
+++ b/net/ipv4/xfrm4_policy.c
@@ -69,7 +69,7 @@ __xfrm4_find_bundle(struct flowi *fl, struct xfrm_policy *policy)
 		if (xdst->u.rt.fl.oif == fl->oif &&	/*XXX*/
 		    xdst->u.rt.fl.fl4_dst == fl->fl4_dst &&
 		    xdst->u.rt.fl.fl4_src == fl->fl4_src &&
-		    xdst->u.rt.fl.fl4_tos == fl->fl4_tos &&
+                    !((xdst->u.rt.fl.fl4_tos ^ fl->fl4_tos) & IPTOS_RT_MASK) &&
 		    xfrm_bundle_ok(policy, xdst, fl, AF_INET, 0)) {
 			dst_clone(dst);
 			break;
@@ -81,7 +81,7 @@ __xfrm4_find_bundle(struct flowi *fl, struct xfrm_policy *policy)
 
 static int xfrm4_get_tos(struct flowi *fl)
 {
-	return fl->fl4_tos;
+	return IPTOS_RT_MASK & fl->fl4_tos; /* Strip ECN bits */
 }
 
 static int xfrm4_init_path(struct xfrm_dst *path, struct dst_entry *dst,
diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 6011bad..e41f735 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -64,6 +64,7 @@ struct nf_ct_frag6_queue
 	struct inet_frag_queue	q;
 
 	__be32			id;		/* fragment id		*/
+	u32			user;
 	struct in6_addr		saddr;
 	struct in6_addr		daddr;
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 63442a1..bb7cc04 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1507,14 +1507,13 @@ out:
  *	i.e. Path MTU discovery
  */
 
-void rt6_pmtu_discovery(struct in6_addr *daddr, struct in6_addr *saddr,
-			struct net_device *dev, u32 pmtu)
+static void rt6_do_pmtu_disc(struct in6_addr *daddr, struct in6_addr *saddr,
+			     struct net *net, u32 pmtu, int ifindex)
 {
 	struct rt6_info *rt, *nrt;
-	struct net *net = dev_net(dev);
 	int allfrag = 0;
 
-	rt = rt6_lookup(net, daddr, saddr, dev->ifindex, 0);
+	rt = rt6_lookup(net, daddr, saddr, ifindex, 0);
 	if (rt == NULL)
 		return;
 
@@ -1582,6 +1581,27 @@ out:
 	dst_release(&rt->u.dst);
 }
 
+void rt6_pmtu_discovery(struct in6_addr *daddr, struct in6_addr *saddr,
+			struct net_device *dev, u32 pmtu)
+{
+	struct net *net = dev_net(dev);
+
+	/*
+	 * RFC 1981 states that a node "MUST reduce the size of the packets it
+	 * is sending along the path" that caused the Packet Too Big message.
+	 * Since it's not possible in the general case to determine which
+	 * interface was used to send the original packet, we update the MTU
+	 * on the interface that will be used to send future packets. We also
+	 * update the MTU on the interface that received the Packet Too Big in
+	 * case the original packet was forced out that interface with
+	 * SO_BINDTODEVICE or similar. This is the next best thing to the
+	 * correct behaviour, which would be to update the MTU on all
+	 * interfaces.
+	 */
+	rt6_do_pmtu_disc(daddr, saddr, net, pmtu, 0);
+	rt6_do_pmtu_disc(daddr, saddr, net, pmtu, dev->ifindex);
+}
+
 /*
  *	Misc support functions
  */
diff --git a/net/irda/iriap.c b/net/irda/iriap.c
index 4a105dc..1c33994 100644
--- a/net/irda/iriap.c
+++ b/net/irda/iriap.c
@@ -501,7 +501,8 @@ static void iriap_getvaluebyclass_confirm(struct iriap_cb *self,
 		IRDA_DEBUG(4, "%s(), strlen=%d\n", __func__, value_len);
 
 		/* Make sure the string is null-terminated */
-		fp[n+value_len] = 0x00;
+		if (n + value_len < skb->len)
+			fp[n + value_len] = 0x00;
 		IRDA_DEBUG(4, "Got string %s\n", fp+n);
 
 		/* Will truncate to IAS_MAX_STRING bytes */
diff --git a/net/irda/parameters.c b/net/irda/parameters.c
index fc1a205..71cd38c 100644
--- a/net/irda/parameters.c
+++ b/net/irda/parameters.c
@@ -298,6 +298,8 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 
 	p.pi = pi;     /* In case handler needs to know */
 	p.pl = buf[1]; /* Extract length of value */
+	if (p.pl > 32)
+		p.pl = 32;
 
 	IRDA_DEBUG(2, "%s(), pi=%#x, pl=%d\n", __func__,
 		   p.pi, p.pl);
@@ -318,7 +320,7 @@ static int irda_extract_string(void *self, __u8 *buf, int len, __u8 pi,
 		   (__u8) str[0], (__u8) str[1]);
 
 	/* Null terminate string */
-	str[p.pl+1] = '\0';
+	str[p.pl] = '\0';
 
 	p.pv.c = str; /* Handler will need to take a copy */
 
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f132243..103c252 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -680,7 +680,7 @@ static int rose_bind(struct socket *sock, struct sockaddr *uaddr, int addr_len)
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	if ((dev = rose_dev_get(&addr->srose_addr)) == NULL) {
@@ -740,7 +740,7 @@ static int rose_connect(struct socket *sock, struct sockaddr *uaddr, int addr_le
 	if (addr_len == sizeof(struct sockaddr_rose) && addr->srose_ndigis > 1)
 		return -EINVAL;
 
-	if (addr->srose_ndigis > ROSE_MAX_DIGIS)
+	if ((unsigned int) addr->srose_ndigis > ROSE_MAX_DIGIS)
 		return -EINVAL;
 
 	/* Source + Destination digis should not exceed ROSE_MAX_DIGIS */
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 0b65354..8ef36ca 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -1179,7 +1179,8 @@ SCTP_STATIC __init int sctp_init(void)
 
 	/* Set the pressure threshold to be a fraction of global memory that
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
-	 * memory, with a floor of 128 pages.
+	 * memory, with a floor of 128 pages, and a ceiling that prevents an
+	 * integer overflow.
 	 * Note this initalizes the data in sctpv6_prot too
 	 * Unabashedly stolen from tcp_init
 	 */
@@ -1187,6 +1188,7 @@ SCTP_STATIC __init int sctp_init(void)
 	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
 	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
+	limit = min(limit, INT_MAX * 4UL / 3 / 2);
 	sysctl_sctp_mem[0] = limit / 4 * 3;
 	sysctl_sctp_mem[1] = limit;
 	sysctl_sctp_mem[2] = sysctl_sctp_mem[0] * 2;
diff --git a/net/socket.c b/net/socket.c
index 058d965..d146030 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1691,6 +1691,8 @@ SYSCALL_DEFINE6(sendto, int, fd, void __user *, buff, size_t, len,
 	struct iovec iov;
 	int fput_needed;
 
+	if (len > INT_MAX)
+		len = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
@@ -1748,6 +1750,8 @@ SYSCALL_DEFINE6(recvfrom, int, fd, void __user *, ubuf, size_t, size,
 	int err, err2;
 	int fput_needed;
 
+	if (size > INT_MAX)
+		size = INT_MAX;
 	sock = sockfd_lookup_light(fd, &err, &fput_needed);
 	if (!sock)
 		goto out;
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 220a5e3..ff56d5e 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -80,6 +80,41 @@ struct compat_x25_subscrip_struct {
 };
 #endif
 
+
+int x25_parse_address_block(struct sk_buff *skb,
+		struct x25_address *called_addr,
+		struct x25_address *calling_addr)
+{
+	unsigned char len;
+	int needed;
+	int rc;
+
+	if (skb->len < 1) {
+		/* packet has no address block */
+		rc = 0;
+		goto empty;
+	}
+
+	len = *skb->data;
+	needed = 1 + (len >> 4) + (len & 0x0f);
+
+	if (skb->len < needed) {
+		/* packet is too short to hold the addresses it claims
+		   to hold */
+		rc = -1;
+		goto empty;
+	}
+
+	return x25_addr_ntoa(skb->data, called_addr, calling_addr);
+
+empty:
+	*called_addr->x25_addr = 0;
+	*calling_addr->x25_addr = 0;
+
+	return rc;
+}
+
+
 int x25_addr_ntoa(unsigned char *p, struct x25_address *called_addr,
 		  struct x25_address *calling_addr)
 {
@@ -871,16 +906,26 @@ int x25_rx_call_request(struct sk_buff *skb, struct x25_neigh *nb,
 	/*
 	 *	Extract the X.25 addresses and convert them to ASCII strings,
 	 *	and remove them.
+	 *
+	 *	Address block is mandatory in call request packets
 	 */
-	addr_len = x25_addr_ntoa(skb->data, &source_addr, &dest_addr);
+	addr_len = x25_parse_address_block(skb, &source_addr, &dest_addr);
+	if (addr_len <= 0)
+		goto out_clear_request;
 	skb_pull(skb, addr_len);
 
 	/*
 	 *	Get the length of the facilities, skip past them for the moment
 	 *	get the call user data because this is needed to determine
 	 *	the correct listener
+	 *
+	 *	Facilities length is mandatory in call request packets
 	 */
+	if (skb->len < 1)
+		goto out_clear_request;
 	len = skb->data[0] + 1;
+	if (skb->len < len)
+		goto out_clear_request;
 	skb_pull(skb,len);
 
 	/*
diff --git a/net/x25/x25_facilities.c b/net/x25/x25_facilities.c
index a21f664..804afd3 100644
--- a/net/x25/x25_facilities.c
+++ b/net/x25/x25_facilities.c
@@ -35,7 +35,7 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 		struct x25_dte_facilities *dte_facs, unsigned long *vc_fac_mask)
 {
 	unsigned char *p = skb->data;
-	unsigned int len = *p++;
+	unsigned int len;
 
 	*vc_fac_mask = 0;
 
@@ -50,9 +50,19 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 	memset(dte_facs->called_ae, '\0', sizeof(dte_facs->called_ae));
 	memset(dte_facs->calling_ae, '\0', sizeof(dte_facs->calling_ae));
 
+	if (skb->len < 1)
+		return 0;
+
+	len = *p++;
+
+	if (len >= skb->len)
+		return -1;
+
 	while (len > 0) {
 		switch (*p & X25_FAC_CLASS_MASK) {
 		case X25_FAC_CLASS_A:
+			if (len < 2)
+				return 0;
 			switch (*p) {
 			case X25_FAC_REVERSE:
 				if((p[1] & 0x81) == 0x81) {
@@ -96,6 +106,8 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			len -= 2;
 			break;
 		case X25_FAC_CLASS_B:
+			if (len < 3)
+				return 0;
 			switch (*p) {
 			case X25_FAC_PACKET_SIZE:
 				facilities->pacsize_in  = p[1];
@@ -117,6 +129,8 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			len -= 3;
 			break;
 		case X25_FAC_CLASS_C:
+			if (len < 4)
+				return 0;
 			printk(KERN_DEBUG "X.25: unknown facility %02X, "
 			       "values %02X, %02X, %02X\n",
 			       p[0], p[1], p[2], p[3]);
@@ -124,26 +138,26 @@ int x25_parse_facilities(struct sk_buff *skb, struct x25_facilities *facilities,
 			len -= 4;
 			break;
 		case X25_FAC_CLASS_D:
+			if (len < p[1] + 2)
+				return 0;
 			switch (*p) {
 			case X25_FAC_CALLING_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->calling_len = p[2];
 				memcpy(dte_facs->calling_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLING_AE;
 				break;
 			case X25_FAC_CALLED_AE:
-				if (p[1] > X25_MAX_DTE_FACIL_LEN)
-					break;
+				if (p[1] > X25_MAX_DTE_FACIL_LEN || p[1] <= 1)
+					return 0;
 				dte_facs->called_len = p[2];
 				memcpy(dte_facs->called_ae, &p[3], p[1] - 1);
 				*vc_fac_mask |= X25_MASK_CALLED_AE;
 				break;
 			default:
 				printk(KERN_DEBUG "X.25: unknown facility %02X,"
-					"length %d, values %02X, %02X, "
-					"%02X, %02X\n",
-					p[0], p[1], p[2], p[3], p[4], p[5]);
+					"length %d\n", p[0], p[1]);
 				break;
 			}
 			len -= p[1] + 2;
@@ -247,6 +261,8 @@ int x25_negotiate_facilities(struct sk_buff *skb, struct sock *sk,
 	memcpy(new, ours, sizeof(*new));
 
 	len = x25_parse_facilities(skb, &theirs, dte, &x25->vc_facil_mask);
+	if (len < 0)
+		return len;
 
 	/*
 	 *	They want reverse charging, we won't accept it.
diff --git a/net/x25/x25_in.c b/net/x25/x25_in.c
index 7d7c3ab..88d7652 100644
--- a/net/x25/x25_in.c
+++ b/net/x25/x25_in.c
@@ -89,6 +89,7 @@ static int x25_queue_rx_frame(struct sock *sk, struct sk_buff *skb, int more)
 static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametype)
 {
 	struct x25_address source_addr, dest_addr;
+	int len;
 
 	switch (frametype) {
 		case X25_CALL_ACCEPTED: {
@@ -106,11 +107,19 @@ static int x25_state1_machine(struct sock *sk, struct sk_buff *skb, int frametyp
 			 *	Parse the data in the frame.
 			 */
 			skb_pull(skb, X25_STD_MIN_LEN);
-			skb_pull(skb, x25_addr_ntoa(skb->data, &source_addr, &dest_addr));
-			skb_pull(skb,
-				 x25_parse_facilities(skb, &x25->facilities,
+
+			len = x25_parse_address_block(skb, &source_addr,
+						&dest_addr);
+			if (len > 0)
+				skb_pull(skb, len);
+
+			len = x25_parse_facilities(skb, &x25->facilities,
 						&x25->dte_facilities,
-						&x25->vc_facil_mask));
+						&x25->vc_facil_mask);
+			if (len > 0)
+				skb_pull(skb, len);
+			else
+				return -1;
 			/*
 			 *	Copy any Call User Data.
 			 */
