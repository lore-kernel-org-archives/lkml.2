Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab0ITHYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:24:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:53448 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0ITHYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:24:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
Date: Mon, 20 Sep 2010 00:24:19 -0700
In-Reply-To: <m139t451b4.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 20 Sep 2010 00:19:59 -0700")
Message-ID: <m1eico3mjg.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: [PATCH 5/5] uio: Implement hotunplug support, using libunload
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With this change it is possible to remove a module that implements
a uio device, or to remove the underlying hardware device of a uio
device withot crashing the kernel, or causing user space more problems
than just an I/O error.

The implicit module parameter that was pased  by uio_register_device
to __uio_register_device has been removed as it is now safe to call
uio_unregister_device while uio file handles are open.

In uio all file methods (except release) now must perform their work
inside of the unload_lock.  This guarantees that uio_unregister_device
won't return until all currently running uio methods complete, and
it allows uio to return -EIO after the underlying device has been
unregistered.

The fops->release method must perform the bulk of it's work under the
unload_release_lock.  With release more needs to be done than to
more than wait for the method to finish executing, the release also
needs to handle the info->releae being called early on files that
are not closed when unregister is running.  Taking the unload_release
lock fails if and only if the info->release method has already been
called at the time fops->release runs.

Instead of holding a module reference the uio files have been modified
to instead hold an extra reference to struct uio_device, ensuring
that the uio file_operations functions will not access freed memory
even after the uio device has been unregistered.

The bulk of the changes are simply modifying the code flow of the
uio functions to run under the appropriate unload lock.

uio_open is modestly special in that it needs to run under the
uio_unload lock (to keep the uio device from unloading), but not have
it's file structure on the uio unload list until it is certain
that the open will succeed (ensuring that release will not be called
on a file that we failed to open).  uio_open also careflly grabs
the reference to the uio_device under the idr_mutex to guarnatee
the the uio_device reference held by the idr data structure
is valid while we are incrementing the uio_device reference count.

uio_device_unregister does a fair bit more than what it used to.  All
of the extra work is essentially handling the early shutdown of file
handles when a device is unregistered while files are still open.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c          |  262 +++++++++++++++++++++++++++++++++-----------
 include/linux/uio_driver.h |   10 +--
 2 files changed, 198 insertions(+), 74 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index fc52fbc..b0032e3 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -24,12 +24,13 @@
 #include <linux/string.h>
 #include <linux/kobject.h>
 #include <linux/cdev.h>
+#include <linux/file.h>
 #include <linux/uio_driver.h>
+#include <linux/unload.h>
 
 #define UIO_MAX_DEVICES		(1U << MINORBITS)
 
 struct uio_device {
-	struct module		*owner;
 	struct device		device;
 	int			minor;
 	atomic_t		event;
@@ -38,6 +39,7 @@ struct uio_device {
 	struct uio_info		*info;
 	struct kobject		*map_dir;
 	struct kobject		*portio_dir;
+	struct unload		unload;
 };
 
 static int uio_major;
@@ -424,106 +426,140 @@ static irqreturn_t uio_interrupt(int irq, void *dev_id)
 }
 
 struct uio_listener {
-	struct uio_device *dev;
+	struct unload_file ufile;
 	s32 event_count;
 };
 
+#define listener_idev(LISTENER) \
+	container_of((LISTENER)->ufile.unload, struct uio_device, unload)
+
 static int uio_open(struct inode *inode, struct file *filep)
 {
 	struct uio_device *idev;
-	struct uio_listener *listener;
+	struct uio_listener *listener = NULL;
 	int ret = 0;
 
 	mutex_lock(&minor_lock);
 	idev = idr_find(&uio_idr, iminor(inode));
+	if (idev)
+		get_device(&idev->device);
 	mutex_unlock(&minor_lock);
-	if (!idev) {
-		ret = -ENODEV;
-		goto out;
-	}
-
-	if (!try_module_get(idev->owner)) {
-		ret = -ENODEV;
-		goto out;
-	}
+	ret = -ENODEV;
+	if (!idev)
+		goto err_out;
 
 	listener = kmalloc(sizeof(*listener), GFP_KERNEL);
-	if (!listener) {
-		ret = -ENOMEM;
-		goto err_alloc_listener;
-	}
+	ret = -ENOMEM;
+	if (!listener)
+		goto err_out;
 
-	listener->dev = idev;
+	unload_file_init(&listener->ufile, filep, &idev->unload);
 	listener->event_count = atomic_read(&idev->event);
 	filep->private_data = listener;
 
-	if (idev->info->open) {
+	/*
+	 * Take the users lock before opening the file to ensure the
+	 * file is not unregistered while it is being opened.
+	 */
+	ret = -EIO;
+	if (!unload_trylock(&idev->unload))
+		goto err_out;
+
+	ret = 0;
+	if (idev->info->open)
 		ret = idev->info->open(idev->info, inode);
-		if (ret)
-			goto err_infoopen;
+	
+	/*
+	 * Add to the listener list only if the open succeeds.
+	 * This ensures that uio_unregister_device won't call
+	 * release unless open has succeeded.
+	 */
+	if (ret == 0)
+		unload_file_attach(&listener->ufile, &idev->unload);
+	unload_unlock(&idev->unload);
+err_out:
+	if (ret) {
+		if (idev)
+			put_device(&idev->device);
+		kfree(listener);
 	}
-	return 0;
-
-err_infoopen:
-	kfree(listener);
-
-err_alloc_listener:
-	module_put(idev->owner);
-
-out:
 	return ret;
 }
 
 static int uio_fasync(int fd, struct file *filep, int on)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
+	int ret = -EIO;
 
-	return fasync_helper(fd, filep, on, &idev->async_queue);
+	if (unload_trylock(&idev->unload)) {
+		ret = fasync_helper(fd, filep, on, &idev->async_queue);
+		unload_unlock(&idev->unload);
+	}
+
+	return ret;
 }
 
 static int uio_release(struct inode *inode, struct file *filep)
 {
 	int ret = 0;
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
+
+	if (unload_release_trylock(&listener->ufile)) {
 
-	if (idev->info->release)
-		ret = idev->info->release(idev->info, inode);
+		if (idev->info->release)
+			ret = idev->info->release(idev->info, inode);
 
-	module_put(idev->owner);
+		unload_release_unlock(&listener->ufile);
+	}
 	kfree(listener);
+	put_device(&idev->device);
 	return ret;
 }
 
 static unsigned int uio_poll(struct file *filep, poll_table *wait)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
+	unsigned int ret;
+
+	if (!unload_trylock(&idev->unload))
+		return POLLERR;
 
+	ret = POLLERR;
 	if (!idev->info->irq)
-		return -EIO;
+		goto out;
 
 	poll_wait(filep, &idev->wait, wait);
+	ret = 0;
 	if (listener->event_count != atomic_read(&idev->event))
-		return POLLIN | POLLRDNORM;
-	return 0;
+		ret = POLLIN | POLLRDNORM;
+
+out:
+	unload_unlock(&idev->unload);
+	return ret;
 }
 
 static ssize_t uio_read(struct file *filep, char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 	DECLARE_WAITQUEUE(wait, current);
 	ssize_t retval;
 	s32 event_count;
 
-	if (!idev->info->irq)
+	if (!unload_trylock(&idev->unload))
 		return -EIO;
 
+	retval = -EIO;
+	if (!idev->info->irq)
+		goto out;
+
+	retval = -EIO;
 	if (count != sizeof(s32))
-		return -EINVAL;
+		goto out;
 
 	add_wait_queue(&idev->wait, &wait);
 
@@ -550,12 +586,21 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 			retval = -ERESTARTSYS;
 			break;
 		}
+		unload_unlock(&idev->unload);
+
 		schedule();
+
+		if (!unload_trylock(&idev->unload)) {
+			retval = -EIO;
+			break;
+		}
 	} while (1);
 
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&idev->wait, &wait);
 
+out:
+	unload_unlock(&idev->unload);
 	return retval;
 }
 
@@ -563,24 +608,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 			size_t count, loff_t *ppos)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 	ssize_t retval;
 	s32 irq_on;
 
-	if (!idev->info->irq)
+	if (!unload_trylock(&idev->unload))
 		return -EIO;
 
+	retval = -EIO;
+	if (!idev->info->irq)
+		goto out;
+
+	retval = -EINVAL;
 	if (count != sizeof(s32))
-		return -EINVAL;
+		goto out;
 
+	retval = -ENOSYS;
 	if (!idev->info->irqcontrol)
-		return -ENOSYS;
+		goto out;
 
+	retval = -EFAULT;
 	if (copy_from_user(&irq_on, buf, count))
-		return -EFAULT;
+		goto out;
 
 	retval = idev->info->irqcontrol(idev->info, irq_on);
 
+out:
+	unload_unlock(&idev->unload);
 	return retval ? retval : sizeof(s32);
 }
 
@@ -598,16 +652,22 @@ static int uio_find_mem_index(struct vm_area_struct *vma)
 	return -1;
 }
 
-static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+static int uio_logical_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
 	struct page *page;
 	unsigned long offset;
+	int ret;
+	int mi;
 
-	int mi = uio_find_mem_index(vma);
-	if (mi < 0)
+	if (!unload_trylock(&idev->unload))
 		return VM_FAULT_SIGBUS;
 
+	ret = VM_FAULT_SIGBUS;
+	mi = uio_find_mem_index(vma);
+	if (mi < 0)
+		goto out;
+
 	/*
 	 * We need to subtract mi because userspace uses offset = N*PAGE_SIZE
 	 * to use mem[N].
@@ -621,11 +681,26 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 							+ offset);
 	get_page(page);
 	vmf->page = page;
-	return 0;
+	ret = 0;
+out:
+	unload_unlock(&idev->unload);
+	return ret;
 }
 
-static const struct vm_operations_struct uio_vm_ops = {
-	.fault = uio_vma_fault,
+static const struct vm_operations_struct uio_logical_vm_ops = {
+	.fault = uio_logical_fault,
+};
+
+static int uio_physical_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	/* The pages should always be mapped, so we should never get
+	 * here unless the device has been hotunplugged
+	 */
+	return VM_FAULT_SIGBUS;
+}
+
+static const struct vm_operations_struct uio_physical_vm_ops = {
+	.fault = uio_physical_fault,
 };
 
 static int uio_mmap_physical(struct vm_area_struct *vma)
@@ -638,6 +713,7 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 	vma->vm_flags |= VM_IO | VM_RESERVED;
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	vma->vm_ops = &uio_physical_vm_ops;
 
 	return remap_pfn_range(vma,
 			       vma->vm_start,
@@ -649,41 +725,54 @@ static int uio_mmap_physical(struct vm_area_struct *vma)
 static int uio_mmap_logical(struct vm_area_struct *vma)
 {
 	vma->vm_flags |= VM_RESERVED;
-	vma->vm_ops = &uio_vm_ops;
+	vma->vm_ops = &uio_logical_vm_ops;
 	return 0;
 }
 
 static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct uio_listener *listener = filep->private_data;
-	struct uio_device *idev = listener->dev;
+	struct uio_device *idev = listener_idev(listener);
 	int mi;
 	unsigned long requested_pages, actual_pages;
+	int ret;
+
+	if (!unload_trylock(&idev->unload))
+		return -EIO;
 
+	ret = -EINVAL;
 	if (vma->vm_end < vma->vm_start)
-		return -EINVAL;
+		goto out;
 
 	vma->vm_private_data = idev;
 
+	ret = -EINVAL;
 	mi = uio_find_mem_index(vma);
 	if (mi < 0)
-		return -EINVAL;
+		goto out;
 
 	requested_pages = (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 	actual_pages = ((idev->info->mem[mi].addr & ~PAGE_MASK)
 			+ idev->info->mem[mi].size + PAGE_SIZE -1) >> PAGE_SHIFT;
+	ret = -EINVAL;
 	if (requested_pages > actual_pages)
-		return -EINVAL;
+		goto out;
 
 	switch (idev->info->mem[mi].memtype) {
 		case UIO_MEM_PHYS:
-			return uio_mmap_physical(vma);
+			ret = uio_mmap_physical(vma);
+			break;
 		case UIO_MEM_LOGICAL:
 		case UIO_MEM_VIRTUAL:
-			return uio_mmap_logical(vma);
+			ret = uio_mmap_logical(vma);
+			break;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			break;
 	}
+out:
+	unload_unlock(&idev->unload);
+	return ret;
 }
 
 static const struct file_operations uio_fops = {
@@ -782,9 +871,7 @@ static void uio_device_release(struct device *dev)
  *
  * returns zero on success or a negative error code.
  */
-int __uio_register_device(struct module *owner,
-			  struct device *parent,
-			  struct uio_info *info)
+int uio_register_device(struct device *parent, struct uio_info *info)
 {
 	struct uio_device *idev;
 	int ret = 0;
@@ -800,10 +887,10 @@ int __uio_register_device(struct module *owner,
 		goto err_kzalloc;
 	}
 
-	idev->owner = owner;
 	idev->info = info;
 	init_waitqueue_head(&idev->wait);
 	atomic_set(&idev->event, 0);
+	unload_init(&idev->unload);
 
 	ret = uio_get_minor(idev);
 	if (ret)
@@ -852,7 +939,7 @@ err_get_minor:
 err_kzalloc:
 	return ret;
 }
-EXPORT_SYMBOL_GPL(__uio_register_device);
+EXPORT_SYMBOL_GPL(uio_register_device);
 
 /**
  * uio_unregister_device - unregister a industrial IO device
@@ -862,12 +949,54 @@ EXPORT_SYMBOL_GPL(__uio_register_device);
 void uio_unregister_device(struct uio_info *info)
 {
 	struct uio_device *idev;
+	struct unload_file *ufile;
+	struct hlist_node *n1, *n2;
 
 	if (!info || !info->uio_dev)
 		return;
 
 	idev = info->uio_dev;
 
+	/*
+	 * Stop accepting new callers into the uio functions, and wait
+	 * until all existing callers into the uio functions are done.
+	 */
+	unload_barrier(&idev->unload);
+
+	/* Notify listeners that the uio devices has gone. */
+	wake_up_interruptible_all(&idev->wait);
+	kill_fasync(&idev->async_queue, SIGIO, POLL_ERR);
+
+	/*
+	 * unload_barrier froze the idev->unload.ufiles list and grabbed
+	 * a reference to every file on that list.  Now cleanup those files
+	 * and drop the extra reference.
+	 */
+	hlist_for_each_entry_safe(ufile, n1, n2, &idev->unload.ufiles, list) {
+		struct file *file = ufile->file;
+		struct inode *inode = file->f_dentry->d_inode;
+
+		/* Cause all mappings to trigger a SIGBUS */
+		unmap_mapping_range(inode->i_mapping, 0, 0, 1);
+
+		/* Remove the file from the fasync list because any
+		 * future attempts to add/remove this file from this
+		 * list will return -EIO.
+		 */
+		fasync_helper(-1, file, 0, &idev->async_queue);
+
+		/* Now that userspace is totally blocked off run the
+		 * release code to clean up, the uio devices data
+		 * structures.
+		 */
+		if (info->release)
+			info->release(info, inode);
+
+		/* Forget about this file */
+		unload_file_detach(ufile);
+		fput(file);
+	}
+
 	uio_free_minor(idev);
 
 	if (info->irq && (info->irq != UIO_IRQ_CUSTOM))
@@ -875,6 +1004,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_dev_del_attributes(idev);
 
+	idev->info = NULL;
 	device_unregister(&idev->device);
 
 	return;
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 33789d4..2551737 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -94,14 +94,8 @@ struct uio_info {
 };
 
 extern int __must_check
-	__uio_register_device(struct module *owner,
-			      struct device *parent,
-			      struct uio_info *info);
-static inline int __must_check
-	uio_register_device(struct device *parent, struct uio_info *info)
-{
-	return __uio_register_device(THIS_MODULE, parent, info);
-}
+	uio_register_device(struct device *parent, struct uio_info *info);
+
 extern void uio_unregister_device(struct uio_info *info);
 extern void uio_event_notify(struct uio_info *info);
 
-- 
1.7.2.2

