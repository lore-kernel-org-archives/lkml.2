Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab0HMVYt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 17:24:49 -0400
Received: from kroah.org ([198.145.64.141]:41119 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab0HMVYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 17:24:21 -0400
Date: Fri, 13 Aug 2010 14:24:09 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 2.6.27.51
Message-ID: <20100813212409.GD22102@kroah.com>
References: <20100813212355.GC22102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100813212355.GC22102@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 040c479..5382c55 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 27
-EXTRAVERSION = .50
+EXTRAVERSION = .51
 NAME = Trembling Tortoise
 
 # *DOCUMENTATION*
diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 001c099..07e27f7 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1179,7 +1179,7 @@ static const struct pv_time_ops xen_time_ops __initdata = {
 	.set_wallclock = xen_set_wallclock,
 	.get_wallclock = xen_get_wallclock,
 	.get_tsc_khz = xen_tsc_khz,
-	.sched_clock = xen_sched_clock,
+	.sched_clock = xen_clocksource_read,
 };
 
 static const struct pv_cpu_ops xen_cpu_ops __initdata = {
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index 685b774..d0f176e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -30,8 +30,6 @@
 #define TIMER_SLOP	100000
 #define NS_PER_TICK	(1000000000LL / HZ)
 
-static cycle_t xen_clocksource_read(void);
-
 /* runstate info updated by Xen */
 static DEFINE_PER_CPU(struct vcpu_runstate_info, runstate);
 
@@ -158,45 +156,6 @@ static void do_stolen_accounting(void)
 	account_steal_time(idle_task(smp_processor_id()), ticks);
 }
 
-/*
- * Xen sched_clock implementation.  Returns the number of unstolen
- * nanoseconds, which is nanoseconds the VCPU spent in RUNNING+BLOCKED
- * states.
- */
-unsigned long long xen_sched_clock(void)
-{
-	struct vcpu_runstate_info state;
-	cycle_t now;
-	u64 ret;
-	s64 offset;
-
-	/*
-	 * Ideally sched_clock should be called on a per-cpu basis
-	 * anyway, so preempt should already be disabled, but that's
-	 * not current practice at the moment.
-	 */
-	preempt_disable();
-
-	now = xen_clocksource_read();
-
-	get_runstate_snapshot(&state);
-
-	WARN_ON(state.state != RUNSTATE_running);
-
-	offset = now - state.state_entry_time;
-	if (offset < 0)
-		offset = 0;
-
-	ret = state.time[RUNSTATE_blocked] +
-		state.time[RUNSTATE_running] +
-		offset;
-
-	preempt_enable();
-
-	return ret;
-}
-
-
 /* Get the TSC speed from Xen */
 unsigned long xen_tsc_khz(void)
 {
@@ -213,7 +172,7 @@ unsigned long xen_tsc_khz(void)
 	return xen_khz;
 }
 
-static cycle_t xen_clocksource_read(void)
+cycle_t xen_clocksource_read(void)
 {
         struct pvclock_vcpu_time_info *src;
 	cycle_t ret;
diff --git a/arch/x86/xen/xen-ops.h b/arch/x86/xen/xen-ops.h
index dd3c231..8a3c823 100644
--- a/arch/x86/xen/xen-ops.h
+++ b/arch/x86/xen/xen-ops.h
@@ -3,6 +3,7 @@
 
 #include <linux/init.h>
 #include <linux/irqreturn.h>
+#include <linux/clocksource.h>
 #include <xen/xen-ops.h>
 
 /* These are code, but not functions.  Defined in entry.S */
@@ -37,7 +38,7 @@ unsigned long xen_tsc_khz(void);
 void __init xen_time_init(void);
 unsigned long xen_get_wallclock(void);
 int xen_set_wallclock(unsigned long time);
-unsigned long long xen_sched_clock(void);
+cycle_t xen_clocksource_read(void);
 
 irqreturn_t xen_debug_interrupt(int irq, void *dev_id);
 
diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 39f6357..1a5d40d 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -265,10 +265,16 @@ nvram_write(struct file *file, const char __user *buf, size_t count, loff_t *ppo
 	unsigned char contents[NVRAM_BYTES];
 	unsigned i = *ppos;
 	unsigned char *tmp;
-	int len;
 
-	len = (NVRAM_BYTES - i) < count ? (NVRAM_BYTES - i) : count;
-	if (copy_from_user(contents, buf, len))
+	if (i >= NVRAM_BYTES)
+		return 0;	/* Past EOF */
+
+	if (count > NVRAM_BYTES - i)
+		count = NVRAM_BYTES - i;
+	if (count > NVRAM_BYTES)
+		return -EFAULT;	/* Can't happen, but prove it to gcc */
+
+	if (copy_from_user(contents, buf, count))
 		return -EFAULT;
 
 	spin_lock_irq(&rtc_lock);
@@ -276,7 +282,7 @@ nvram_write(struct file *file, const char __user *buf, size_t count, loff_t *ppo
 	if (!__nvram_check_checksum())
 		goto checksum_err;
 
-	for (tmp = contents; count-- > 0 && i < NVRAM_BYTES; ++i, ++tmp)
+	for (tmp = contents; count--; ++i, ++tmp)
 		__nvram_write_byte(*tmp, i);
 
 	__nvram_set_checksum();
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index dbf51e9..6fcedbe 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -818,11 +818,29 @@ static int make_request(struct request_queue *q, struct bio * bio)
 		 */
 		bp = bio_split(bio, bio_split_pool,
 			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
+
+		/* Each of these 'make_request' calls will call 'wait_barrier'.
+		 * If the first succeeds but the second blocks due to the resync
+		 * thread raising the barrier, we will deadlock because the
+		 * IO to the underlying device will be queued in generic_make_request
+		 * and will never complete, so will never reduce nr_pending.
+		 * So increment nr_waiting here so no new raise_barriers will
+		 * succeed, and so the second wait_barrier cannot block.
+		 */
+		spin_lock_irq(&conf->resync_lock);
+		conf->nr_waiting++;
+		spin_unlock_irq(&conf->resync_lock);
+
 		if (make_request(q, &bp->bio1))
 			generic_make_request(&bp->bio1);
 		if (make_request(q, &bp->bio2))
 			generic_make_request(&bp->bio2);
 
+		spin_lock_irq(&conf->resync_lock);
+		conf->nr_waiting--;
+		wake_up(&conf->wait_barrier);
+		spin_unlock_irq(&conf->resync_lock);
+
 		bio_pair_release(bp);
 		return 0;
 	bad_map:
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 5368689..e09684e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1833,6 +1833,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS480, quirk_disabl
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3336, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3351, quirk_disable_all_msi);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_VT3364, quirk_disable_all_msi);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_VIA, PCI_DEVICE_ID_VIA_8380_0, quirk_disable_all_msi);
 
 /* Disable MSI on chipsets that are known to not support it */
 static void __devinit quirk_disable_msi(struct pci_dev *dev)
diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
index bbc723a..45cb94c 100644
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -199,7 +199,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 			       "the persistent file for the dentry with name "
 			       "[%s]; rc = [%d]\n", __func__,
 			       ecryptfs_dentry->d_name.name, rc);
-			goto out;
+			goto out_free;
 		}
 	}
 	if ((ecryptfs_inode_to_private(inode)->lower_file->f_flags & O_RDONLY)
@@ -207,7 +207,7 @@ static int ecryptfs_open(struct inode *inode, struct file *file)
 		rc = -EPERM;
 		printk(KERN_WARNING "%s: Lower persistent file is RO; eCryptfs "
 		       "file must hence be opened RO\n", __func__);
-		goto out;
+		goto out_free;
 	}
 	ecryptfs_set_file_lower(
 		file, ecryptfs_inode_to_private(inode)->lower_file);
@@ -303,12 +303,40 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
 	return rc;
 }
 
-static int ecryptfs_ioctl(struct inode *inode, struct file *file,
-			  unsigned int cmd, unsigned long arg);
+static long
+ecryptfs_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct file *lower_file = NULL;
+	long rc = -ENOTTY;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (lower_file && lower_file->f_op && lower_file->f_op->unlocked_ioctl)
+		rc = lower_file->f_op->unlocked_ioctl(lower_file, cmd, arg);
+	return rc;
+}
+
+#ifdef CONFIG_COMPAT
+static long
+ecryptfs_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct file *lower_file = NULL;
+	long rc = -ENOIOCTLCMD;
+
+	if (ecryptfs_file_to_private(file))
+		lower_file = ecryptfs_file_to_lower(file);
+	if (lower_file && lower_file->f_op && lower_file->f_op->compat_ioctl)
+		rc = lower_file->f_op->compat_ioctl(lower_file, cmd, arg);
+	return rc;
+}
+#endif
 
 const struct file_operations ecryptfs_dir_fops = {
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ecryptfs_compat_ioctl,
+#endif
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -325,7 +353,10 @@ const struct file_operations ecryptfs_main_fops = {
 	.write = do_sync_write,
 	.aio_write = generic_file_aio_write,
 	.readdir = ecryptfs_readdir,
-	.ioctl = ecryptfs_ioctl,
+	.unlocked_ioctl = ecryptfs_unlocked_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = ecryptfs_compat_ioctl,
+#endif
 	.mmap = generic_file_mmap,
 	.open = ecryptfs_open,
 	.flush = ecryptfs_flush,
@@ -334,20 +365,3 @@ const struct file_operations ecryptfs_main_fops = {
 	.fasync = ecryptfs_fasync,
 	.splice_read = generic_file_splice_read,
 };
-
-static int
-ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	       unsigned long arg)
-{
-	int rc = 0;
-	struct file *lower_file = NULL;
-
-	if (ecryptfs_file_to_private(file))
-		lower_file = ecryptfs_file_to_lower(file);
-	if (lower_file && lower_file->f_op && lower_file->f_op->ioctl)
-		rc = lower_file->f_op->ioctl(ecryptfs_inode_to_lower(inode),
-					     lower_file, cmd, arg);
-	else
-		rc = -ENOTTY;
-	return rc;
-}
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 9b7f2cd..f35a40b 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -85,46 +85,25 @@ struct ea_buffer {
 #define EA_MALLOC	0x0008
 
 
+static int is_known_namespace(const char *name)
+{
+	if (strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN) &&
+	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
+	    strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
+	    strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
+		return false;
+
+	return true;
+}
+
 /*
  * These three routines are used to recognize on-disk extended attributes
  * that are in a recognized namespace.  If the attribute is not recognized,
  * "os2." is prepended to the name
  */
-static inline int is_os2_xattr(struct jfs_ea *ea)
+static int is_os2_xattr(struct jfs_ea *ea)
 {
-	/*
-	 * Check for "system."
-	 */
-	if ((ea->namelen >= XATTR_SYSTEM_PREFIX_LEN) &&
-	    !strncmp(ea->name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
-		return false;
-	/*
-	 * Check for "user."
-	 */
-	if ((ea->namelen >= XATTR_USER_PREFIX_LEN) &&
-	    !strncmp(ea->name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
-		return false;
-	/*
-	 * Check for "security."
-	 */
-	if ((ea->namelen >= XATTR_SECURITY_PREFIX_LEN) &&
-	    !strncmp(ea->name, XATTR_SECURITY_PREFIX,
-		     XATTR_SECURITY_PREFIX_LEN))
-		return false;
-	/*
-	 * Check for "trusted."
-	 */
-	if ((ea->namelen >= XATTR_TRUSTED_PREFIX_LEN) &&
-	    !strncmp(ea->name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN))
-		return false;
-	/*
-	 * Add any other valid namespace prefixes here
-	 */
-
-	/*
-	 * We assume it's OS/2's flat namespace
-	 */
-	return true;
+	return !is_known_namespace(ea->name);
 }
 
 static inline int name_size(struct jfs_ea *ea)
@@ -768,13 +747,23 @@ static int can_set_xattr(struct inode *inode, const char *name,
 	if (!strncmp(name, XATTR_SYSTEM_PREFIX, XATTR_SYSTEM_PREFIX_LEN))
 		return can_set_system_xattr(inode, name, value, value_len);
 
+	if (!strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN)) {
+		/*
+		 * This makes sure that we aren't trying to set an
+		 * attribute in a different namespace by prefixing it
+		 * with "os2."
+		 */
+		if (is_known_namespace(name + XATTR_OS2_PREFIX_LEN))
+				return -EOPNOTSUPP;
+		return 0;
+	}
+
 	/*
 	 * Don't allow setting an attribute in an unknown namespace.
 	 */
 	if (strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN) &&
 	    strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN) &&
-	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN) &&
-	    strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN))
+	    strncmp(name, XATTR_USER_PREFIX, XATTR_USER_PREFIX_LEN))
 		return -EOPNOTSUPP;
 
 	return 0;
@@ -956,19 +945,8 @@ ssize_t __jfs_getxattr(struct inode *inode, const char *name, void *data,
 	int xattr_size;
 	ssize_t size;
 	int namelen = strlen(name);
-	char *os2name = NULL;
 	char *value;
 
-	if (strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
-		os2name = kmalloc(namelen - XATTR_OS2_PREFIX_LEN + 1,
-				  GFP_KERNEL);
-		if (!os2name)
-			return -ENOMEM;
-		strcpy(os2name, name + XATTR_OS2_PREFIX_LEN);
-		name = os2name;
-		namelen -= XATTR_OS2_PREFIX_LEN;
-	}
-
 	down_read(&JFS_IP(inode)->xattr_sem);
 
 	xattr_size = ea_get(inode, &ea_buf, 0);
@@ -1006,8 +984,6 @@ ssize_t __jfs_getxattr(struct inode *inode, const char *name, void *data,
       out:
 	up_read(&JFS_IP(inode)->xattr_sem);
 
-	kfree(os2name);
-
 	return size;
 }
 
@@ -1016,6 +992,19 @@ ssize_t jfs_getxattr(struct dentry *dentry, const char *name, void *data,
 {
 	int err;
 
+	if (strncmp(name, XATTR_OS2_PREFIX, XATTR_OS2_PREFIX_LEN) == 0) {
+		/*
+		 * skip past "os2." prefix
+		 */
+		name += XATTR_OS2_PREFIX_LEN;
+		/*
+		 * Don't allow retrieving properly prefixed attributes
+		 * by prepending them with "os2."
+		 */
+		if (is_known_namespace(name))
+			return -EOPNOTSUPP;
+	}
+
 	err = __jfs_getxattr(dentry->d_inode, name, data, buf_size);
 
 	return err;
diff --git a/fs/signalfd.c b/fs/signalfd.c
index b07565c..d98bea8 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -87,6 +87,7 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 		 err |= __put_user(kinfo->si_tid, &uinfo->ssi_tid);
 		 err |= __put_user(kinfo->si_overrun, &uinfo->ssi_overrun);
 		 err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
+		 err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
 		break;
 	case __SI_POLL:
 		err |= __put_user(kinfo->si_band, &uinfo->ssi_band);
@@ -110,6 +111,7 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
 		err |= __put_user(kinfo->si_uid, &uinfo->ssi_uid);
 		err |= __put_user((long) kinfo->si_ptr, &uinfo->ssi_ptr);
+		err |= __put_user(kinfo->si_int, &uinfo->ssi_int);
 		break;
 	default:
 		/*
diff --git a/fs/splice.c b/fs/splice.c
index 2f2d8c1..4e1ea5e 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -366,17 +366,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
 		 * If the page isn't uptodate, we may need to start io on it
 		 */
 		if (!PageUptodate(page)) {
-			/*
-			 * If in nonblock mode then dont block on waiting
-			 * for an in-flight io page
-			 */
-			if (flags & SPLICE_F_NONBLOCK) {
-				if (!trylock_page(page)) {
-					error = -EAGAIN;
-					break;
-				}
-			} else
-				lock_page(page);
+			lock_page(page);
 
 			/*
 			 * Page was truncated, or invalidated by the
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index f2e574d..801c08b 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -176,6 +176,9 @@ int bdi_register(struct backing_dev_info *bdi, struct device *parent,
 	int ret = 0;
 	struct device *dev;
 
+	if (bdi->dev)	/* The driver needs to use separate queues per device */
+		goto exit;
+
 	va_start(args, fmt);
 	dev = device_create_vargs(bdi_class, parent, MKDEV(0, 0), bdi, fmt, args);
 	va_end(args);
