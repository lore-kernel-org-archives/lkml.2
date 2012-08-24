Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760090Ab2HXTXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 15:23:18 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59585 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab2HXTXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 15:23:12 -0400
From: Erlon Cruz <erlon.cruz@br.flextronics.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev@vger.kernel.org, alevy@redhat.com, FlorianSchandinat@gmx.de,
        Erlon Cruz <erlon.cruz@br.flextronics.com>,
        =?UTF-8?q?Fabiano=20Fid=C3=AAncio?= 
	<Fabiano.Fidencio@fit-tecnologia.org.br>,
        "Rafael F. Santos" <fonsecasantos.rafael@gmail.com>
Subject: [PATCH] qxl-virtio: introducing virtio-qxl driver.
Date: Fri, 24 Aug 2012 16:22:59 -0300
Message-Id: <1345836179-23803-1-git-send-email-erlon.cruz@br.flextronics.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The qxl-virtio driver implements a QXL driver using VirtIO as transport, thus
enabling the use of QXL/Spice in non-PCI architectures. In the actual QXL
driver, all communication between Host and Guest is done through PCI shared
memory.

Signed-off-by: Erlon R. Cruz <erlon.cruz@br.flextronics.com>
Signed-off-by: Fabiano Fidêncio <Fabiano.Fidencio@fit-tecnologia.org.br>
Signed-off-by: Rafael F. Santos <fonsecasantos.rafael@gmail.com>
---
 .gitignore                        |    1 +
 drivers/video/Kconfig             |    6 +
 drivers/video/Makefile            |    3 +
 drivers/video/virtio-qxl-bridge.c |  628 +++++++++++++++++++++++++++++++++++++
 include/linux/Kbuild              |    1 +
 include/linux/virtio_bridge.h     |  159 ++++++++++
 6 files changed, 798 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/virtio-qxl-bridge.c
 create mode 100644 include/linux/virtio_bridge.h

diff --git a/.gitignore b/.gitignore
index 57af07c..ebe7e3e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -84,3 +84,4 @@ GTAGS
 *.orig
 *~
 \#*#
+/nbproject/private/
\ No newline at end of file
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 0217f74..466863b 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2469,4 +2469,10 @@ config FB_SH_MOBILE_MERAM
 	  Up to 4 memory channels can be configured, allowing 4 RGB or
 	  2 YCbCr framebuffers to be configured.
 
+config VIRTIO_QXL
+	tristate "QXL driver over VirtIO"
+	depends on EXPERIMENTAL && VIRTIO
+	help
+	  This driver provides a QXL video device using virtio transport.
+
 endmenu
diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index ee8dafb..a331743 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -170,3 +170,6 @@ obj-$(CONFIG_FB_VIRTUAL)          += vfb.o
 
 #video output switch sysfs driver
 obj-$(CONFIG_VIDEO_OUTPUT_CONTROL) += output.o
+
+# Virtio QLX
+obj-$(CONFIG_VIRTIO_QXL) += virtio-qxl-bridge.o
diff --git a/drivers/video/virtio-qxl-bridge.c b/drivers/video/virtio-qxl-bridge.c
new file mode 100644
index 0000000..c799943
--- /dev/null
+++ b/drivers/video/virtio-qxl-bridge.c
@@ -0,0 +1,628 @@
+/*
+ * Virtio QXL Device
+ *
+ *
+ * Authors:
+ *  Erlon R. Cruz <erlon.cruz@br.flextronics.com>
+ *  Rafael F. Santos <Rafael.Santos@fit-tecnologia.org.br>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ring.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_bridge.h>
+#include <linux/mm.h>
+#include <linux/semaphore.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/cdev.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <asm/current.h>
+#include <asm/page.h>
+#include <linux/rwsem.h>
+#include <linux/sched.h>
+
+#define DRIVER_STRING "virtio-qxl-bridge"
+#define SG_ELEMENTS 128
+
+#define DEBUG_ERROR 1
+#define DEBUG_INFO 1
+#define DEBUG_VM 0
+#define DEBUG_SG 0
+#define DEBUG_PUSH_AREA 0
+#define DEBUG_PULL_AREA 0
+#define DEBUG_IOCTL 0
+#define DEBUG_IOPWRITE 0
+#define DEBUG_FOPS 0
+
+ #define dprintk(_level, _fmt, ...)			\
+do {									\
+	if (_level) {						\
+		printk(_fmt, ## __VA_ARGS__);	\
+	}								\
+} while (0)
+
+static inline void printHexa(void *buf, int len)
+{
+	uint8_t *cur, *ubuf;
+	ubuf = (uint8_t *) buf;
+
+	for (cur = ubuf; (cur - ubuf) < len; cur++)
+#ifdef __KERNEL__
+		printk("%02X", *cur);
+#else
+		ErrorF("%02X", *cur);
+#endif
+
+}
+
+dev_t dev;
+int devindex, devno;
+struct semaphore idxsem;
+struct class *virtio_qxl_class;
+
+struct qxl_usrmem_desc {
+	char __user *start;
+	unsigned int len;
+};
+
+struct virtio_qxl_bridge {
+	spinlock_t lock;
+	struct virtio_device *vdev;
+	struct virtqueue *vq;
+	struct scatterlist sg[SG_ELEMENTS];
+	struct scatterlist *vgasg;
+	struct cdev cdev;
+	struct virtioqxl_config config;
+	struct semaphore sem;
+	struct qxl_usrmem_desc mem_desc;
+	struct page **user_pages;
+};
+
+struct vbr_req {
+	struct list_head list;
+	struct vbr_proto_hdr hdr;
+	u8 status;
+};
+
+void put_userpages_vector(struct page **pages, int num_pages, bool dirty)
+{
+	int i;
+
+	for (i = 0; i < num_pages; i++) {
+		if (dirty)
+			set_page_dirty_lock(pages[i]);
+		put_page(pages[i]);
+	}
+}
+
+static int userpages_fill_sg(struct page **upages, struct scatterlist *sg,
+			     u8 __user *virt, int length, int write)
+{
+	struct page *pg;
+	int sg_entries = 0, pagesidx = 0;
+	int tmp_off, rc;
+	uint8_t *ustart, *uend;
+
+	ustart = virt;
+	uend = ustart + length;
+	tmp_off = ((ulong) ustart & ~PAGE_MASK);
+	/* unaligned */
+	if (tmp_off) {
+		int gap = 0, cplen;
+
+		/* Length from offset to the end of the page */
+		gap = PAGE_SIZE - tmp_off;
+		if (gap > length)
+			cplen = length;
+		else
+			cplen = gap;
+
+		down_read(&current->mm->mmap_sem);
+		rc = get_user_pages(current,
+				    current->mm,
+				    (unsigned long)ustart & PAGE_MASK,
+				    1, write, 0, upages + pagesidx++, NULL);
+		up_read(&current->mm->mmap_sem);
+
+		pg = upages[pagesidx - 1];
+		sg_set_page(&sg[sg_entries++], pg, cplen, tmp_off);
+		ustart += cplen;
+		dprintk(DEBUG_SG,
+			"%s: Unaligned buffer: tt len %d, offset %d, gap %d,"
+			" unaligned head %d", __func__, length, tmp_off, gap,
+			cplen);
+	} else {
+		dprintk(DEBUG_SG, "%s: Aligned buffer tt len %d", __func__,
+			length);
+	}
+
+	/* Now start is aligned rigth? hooope so */
+	while (uend - ustart >= PAGE_SIZE) {
+
+		down_read(&current->mm->mmap_sem);
+		rc = get_user_pages(current,
+				    current->mm,
+				    (unsigned long)ustart,
+				    1, write, 0, upages + pagesidx++, NULL);
+		up_read(&current->mm->mmap_sem);
+
+		pg = upages[pagesidx - 1];
+		sg_set_page(&sg[sg_entries++], pg, PAGE_SIZE, 0);
+		ustart += PAGE_SIZE;
+	}
+
+	if (uend - ustart > 0) {
+
+		down_read(&current->mm->mmap_sem);
+		rc = get_user_pages(current,
+				    current->mm,
+				    (unsigned long)ustart,
+				    1, write, 0, upages + pagesidx++, NULL);
+		up_read(&current->mm->mmap_sem);
+
+		if (rc < 0)
+			goto fail;
+
+		pg = upages[pagesidx - 1];
+		sg_set_page(&sg[sg_entries++], pg, uend - ustart, 0);
+		dprintk(DEBUG_SG, " unaligned tail %d", (int)(uend - ustart));
+		ustart += uend - ustart;
+	}
+
+	if (ustart != uend)
+		panic("Anomalous behavior when filling SG\n");
+
+	dprintk(DEBUG_SG, " %d SG entries\n", sg_entries);
+	return sg_entries;
+
+fail:
+	put_userpages_vector(upages, pagesidx - 1, false);
+	return 0;
+}
+
+static int send_packet(struct virtio_qxl_bridge *devdata,
+		       int what, char __user *buffer, int len, int flags)
+{
+	int in, out, mapped_entries = 0;
+	unsigned int readlen;
+	struct vbr_req *rq;
+	struct scatterlist *sg;
+
+	in = out = 0;
+	rq = kzalloc(sizeof(*rq), GFP_KERNEL);
+
+	rq->hdr.flags |= flags;
+	rq->hdr.function = what;
+	/* The offset of the buffer based on the start of video memory */
+	rq->hdr.param = buffer - devdata->mem_desc.start;
+	rq->hdr.len = len;
+
+	switch (what) {
+	case VIRTIOQXL_GETCFG:
+		sg = devdata->sg;
+		sg_set_buf(&sg[out++], &rq->hdr, sizeof(rq->hdr));
+		sg_set_buf(&sg[out + in++], buffer, len);
+		break;
+
+	case VIRTIOQXL_IOPORT_WRITE:
+		sg = devdata->sg;
+		sg_set_buf(&sg[out++], &rq->hdr, sizeof(rq->hdr));
+		sg_set_buf(&sg[out++], buffer, len);
+		break;
+
+	case VIRTIOQXL_GET_RAM:
+		sg = devdata->vgasg;
+		sg_set_buf(&sg[out++], &rq->hdr, sizeof(rq->hdr));
+		in += mapped_entries =
+		    userpages_fill_sg(devdata->user_pages, &sg[out], buffer,
+				      len, 1);
+
+		break;
+
+	case VIRTIOQXL_SET_RAM:
+		sg = devdata->vgasg;
+		sg_set_buf(&sg[out++], &rq->hdr, sizeof(rq->hdr));
+		out += mapped_entries =
+		    userpages_fill_sg(devdata->user_pages, &sg[out], buffer,
+				      len, 0);
+		break;
+	default:
+		panic("%s: virtio QXL request (%d) not supported\n",
+		      DRIVER_STRING, what);
+		break;
+	}
+
+	sg_set_buf(&sg[out + in++], &rq->status, sizeof(rq->status));
+
+	if (virtqueue_add_buf(devdata->vq, sg, out, in, rq, GFP_KERNEL) < 0) {
+		dprintk(DEBUG_ERROR, "%s: error adding buffer\n",
+			DRIVER_STRING);
+		return -1;
+	}
+
+	virtqueue_kick(devdata->vq);
+	while (!virtqueue_get_buf(devdata->vq, &readlen))
+		cpu_relax();
+
+	if (mapped_entries)
+		put_userpages_vector(devdata->user_pages, mapped_entries,
+				     (in > 1));
+
+	kfree(rq);
+	return 0;
+}
+
+static int get_from_host(struct virtio_qxl_bridge *devdata, uint what,
+			 void *bufto, int len)
+{
+	return send_packet(devdata, what, bufto, len, CONFIG_READ);
+}
+
+static int set_on_host(struct virtio_qxl_bridge *devdata, uint what,
+		       void *buffrom, int len)
+{
+	return send_packet(devdata, what, buffrom, len, CONFIG_WRITE);
+}
+
+static int device_open(struct inode *inode, struct file *file)
+{
+	struct virtio_qxl_bridge *virtiodata;
+
+	dprintk(DEBUG_INFO, "%s: entering %s\n", DRIVER_STRING, __func__);
+
+	virtiodata =
+	    container_of(inode->i_cdev, struct virtio_qxl_bridge, cdev);
+	file->private_data = virtiodata;
+
+	return 0;
+}
+
+static long device_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct virtio_qxl_bridge *brdev = file->private_data;
+
+	switch (cmd) {
+
+	case QXL_IOCTL_QXL_IO_GETCFG:{
+			struct virtioqxl_config *cfg;
+			cfg = &brdev->config;
+			copy_to_user((void __user *)arg, cfg,
+				     sizeof(struct virtioqxl_config));
+			break;
+		}
+
+	case QXL_IOCTL_QXL_IO_SET_RAMSTART:{
+
+			copy_from_user(&brdev->mem_desc.start,
+				       (void __user *)arg,
+				       sizeof(brdev->mem_desc.start));
+			brdev->mem_desc.len =
+			    brdev->config.vramsize + brdev->config.ramsize +
+			    brdev->config.romsize;
+
+			dprintk(DEBUG_INFO, "%s: user ram start %p\n",
+				DRIVER_STRING, brdev->mem_desc.start);
+			break;
+		}
+
+	case QXL_IOCTL_NOTIFY_CMD:
+	case QXL_IOCTL_NOTIFY_CURSOR:
+	case QXL_IOCTL_UPDATE_AREA:
+	case QXL_IOCTL_UPDATE_IRQ:
+	case QXL_IOCTL_NOTIFY_OOM:
+	case QXL_IOCTL_RESET:
+	case QXL_IOCTL_SET_MODE:
+	case QXL_IOCTL_LOG:
+	case QXL_IOCTL_MEMSLOT_ADD:
+	case QXL_IOCTL_MEMSLOT_DEL:
+	case QXL_IOCTL_DETACH_PRIMARY:
+	case QXL_IOCTL_ATTACH_PRIMARY:
+	case QXL_IOCTL_CREATE_PRIMARY:
+	case QXL_IOCTL_DESTROY_PRIMARY:
+	case QXL_IOCTL_DESTROY_SURFACE_WAIT:
+	case QXL_IOCTL_DESTROY_ALL_SURFACES:
+	case QXL_IOCTL_UPDATE_AREA_ASYNC:
+	case QXL_IOCTL_MEMSLOT_ADD_ASYNC:
+	case QXL_IOCTL_CREATE_PRIMARY_ASYNC:
+	case QXL_IOCTL_DESTROY_PRIMARY_ASYNC:
+	case QXL_IOCTL_DESTROY_SURFACE_ASYNC:
+	case QXL_IOCTL_DESTROY_ALL_SURFACES_ASYNC:
+	case QXL_IOCTL_FLUSH_SURFACES_ASYNC:
+	case QXL_IOCTL_FLUSH_RELEASE:{
+			struct iowrite_cmd *iocmd =
+			    kmalloc(sizeof(*iocmd), GFP_KERNEL);
+			iocmd->port = _IOC_NR(cmd);
+			iocmd->arg = arg;
+			dprintk(DEBUG_IOPWRITE, " port %d, arg %d\n",
+				iocmd->port, iocmd->arg);
+			set_on_host(brdev, VIRTIOQXL_IOPORT_WRITE, iocmd,
+				    sizeof(*iocmd));
+			kfree(iocmd);
+			break;
+		}
+
+	default:
+		dprintk(DEBUG_INFO, "%s: IOCTL not handled %ui\n", __func__,
+			cmd);
+		return -ENOTTY;
+	}
+
+	return 0;
+}
+
+static ssize_t device_read(struct file *file, char __user *buf, size_t len,
+			   loff_t *f_pos)
+{
+	struct virtio_qxl_bridge *virtiodata = file->private_data;
+
+	if (!virtiodata->mem_desc.start)
+		return -EFAULT;
+
+	if (buf < virtiodata->mem_desc.start ||
+	    (buf + len) >
+	    (virtiodata->mem_desc.start + virtiodata->mem_desc.len))
+		return -EFAULT;
+
+	if (len <= 0)
+		return 0;
+
+	dprintk(DEBUG_FOPS,
+		"%s: virtio_qxl_bridge: %s: reading %d bytes, "
+		"useraddr = %p, videomem offset = %lu\n",
+		DRIVER_STRING, __func__, (int)len, buf,
+		buf - virtiodata->mem_desc.start);
+
+	return get_from_host(virtiodata, VIRTIOQXL_GET_RAM, buf, len);
+}
+
+static ssize_t device_write(struct file *file, const char __user *buf,
+			    size_t len, loff_t *f_pos)
+{
+	struct virtio_qxl_bridge *virtiodata = file->private_data;
+
+	if (!virtiodata->mem_desc.start)
+		return -EFAULT;
+
+	if (buf < virtiodata->mem_desc.start ||
+	    (buf + len) >
+	    (virtiodata->mem_desc.start + virtiodata->mem_desc.len))
+		return -EFAULT;
+
+	if (len <= 0)
+		return 0;
+
+	dprintk(DEBUG_FOPS,
+		"%s: virtio_qxl_bridge: %s: writing %d bytes, "
+		"useraddr = %p, videomem offset = %lu\n",
+		DRIVER_STRING, __func__, (int)len, buf,
+		buf - virtiodata->mem_desc.start);
+
+	return set_on_host(virtiodata, VIRTIOQXL_SET_RAM, (char *)buf, len);
+}
+
+int device_release(struct inode *inode, struct file *file)
+{
+	dprintk(DEBUG_FOPS, "%s: %s\n", DRIVER_STRING, __func__);
+	return 0;
+}
+
+const struct file_operations device_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = device_ioctl,
+	.read = device_read,
+	.write = device_write,
+	.open = device_open,
+	.release = device_release
+};
+
+static int setup_cdev(struct virtio_qxl_bridge *virtiodata)
+{
+	int minor, err = 0;
+	struct device *device;
+
+	down(&idxsem);
+	minor = devindex;
+	devindex++;
+	up(&idxsem);
+
+	devno = MKDEV(MAJOR(dev), minor);
+
+	dprintk(DEBUG_INFO, "%s: %s: adding char device %d/%d\n",
+		DRIVER_STRING, __func__, MAJOR(dev), minor);
+
+	/* Print driver port string */
+	cdev_init(&virtiodata->cdev, &device_fops);
+	virtiodata->cdev.owner = THIS_MODULE;
+	virtiodata->cdev.ops = &device_fops;
+	err = cdev_add(&virtiodata->cdev, devno, 1);
+	if (err) {
+		dprintk(DEBUG_INFO, "%s: error %d adding char device %d",
+			DRIVER_STRING, err, devindex);
+		return err;
+	}
+
+	/* Create a sysfs class entry */
+	device =
+	    device_create(virtio_qxl_class, NULL, devno, NULL, "virtioqxl%u",
+			  minor);
+	if (IS_ERR(device)) {
+		dprintk(DEBUG_INFO, "%s: error %li creating device %d\n",
+			DRIVER_STRING, PTR_ERR(device), devindex);
+		err = PTR_ERR(device);
+		cdev_del(&virtiodata->cdev);
+	}
+	return err;
+}
+
+static void release_cdev(struct virtio_qxl_bridge *virtiodata)
+{
+	device_destroy(virtio_qxl_class, devno);
+	cdev_del(&virtiodata->cdev);
+}
+
+static int __devinit qxl_bridge_probe(struct virtio_device *vdev)
+{
+	int memlen, sg_elements, err = 0;
+	struct virtio_qxl_bridge *brdev;
+	struct virtioqxl_config *cfg;
+
+	dprintk(DEBUG_INFO, "%s: probing\n", DRIVER_STRING);
+
+	brdev = kmalloc(sizeof(struct virtio_qxl_bridge), GFP_KERNEL);
+	if (!brdev)
+		return -ENOMEM;
+
+	dprintk(DEBUG_INFO, "%s: allocated %lu bytes as virtio_data\n",
+		DRIVER_STRING, sizeof(struct virtio_qxl_bridge));
+
+	brdev->vq = virtio_find_single_vq(vdev, NULL, "requests");
+	if (IS_ERR(brdev->vq)) {
+		err = PTR_ERR(brdev->vq);
+		dprintk(DEBUG_ERROR, "%s: error finding vq\n", DRIVER_STRING);
+		goto out_find;
+	}
+
+	cfg = &brdev->config;
+	brdev->vdev = vdev;
+	brdev->vdev->priv = brdev;
+
+	spin_lock_init(&brdev->lock);
+	sg_init_table(brdev->sg, SG_ELEMENTS);
+	sema_init(&brdev->sem, 1);
+
+	err = setup_cdev(brdev);
+	if (err < 0)
+		goto out_cdev;
+
+	get_from_host(brdev, VIRTIOQXL_GETCFG, cfg, sizeof(*cfg));
+	memlen = cfg->ramsize + cfg->vramsize + cfg->romsize;
+	dprintk(DEBUG_INFO,
+		"%s: got config information from host: ram size %d, "
+		"vram size %d, rom size %d\n", DRIVER_STRING, cfg->ramsize,
+		cfg->vramsize, cfg->romsize);
+
+	/* Memmory + alignment + head/tail */
+	sg_elements = cfg->vramsize / PAGE_SIZE + 1 + 2;
+	brdev->vgasg =
+	    kmalloc(sizeof(struct scatterlist) * sg_elements, GFP_KERNEL);
+	if (!brdev->vgasg) {
+		dprintk(DEBUG_ERROR, "%s: error allocating SG memory\n",
+			DRIVER_STRING);
+		goto out_driver_mem;
+	}
+	dprintk(DEBUG_INFO, "%s: allocated table for %d SG elements\n",
+		DRIVER_STRING, sg_elements);
+
+	sg_init_table(brdev->vgasg, sg_elements);
+
+	brdev->mem_desc.start = NULL;
+	brdev->user_pages =
+	    kmalloc((cfg->vramsize / PAGE_SIZE) * sizeof(struct page),
+		    GFP_KERNEL);
+	if (!brdev->user_pages) {
+		dprintk(DEBUG_ERROR, "%s: error allocating page table memory\n",
+			DRIVER_STRING);
+		goto out_driver_mem2;
+	}
+
+	return 0;
+
+out_driver_mem2:
+	kfree(brdev->vgasg);
+out_driver_mem:
+	release_cdev(brdev);
+out_cdev:
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
+out_find:
+	kfree(brdev);
+	return err;
+}
+
+static void __devexit qxl_bridge_remove(struct virtio_device *vdev)
+{
+	struct virtio_qxl_bridge *brdata = vdev->priv;
+
+	kfree(brdata->user_pages);
+	kfree(brdata->vgasg);
+	release_cdev(brdata);
+	vdev->config->reset(vdev);
+	vdev->config->del_vqs(vdev);
+	dprintk(DEBUG_INFO, "%s: removing\n", DRIVER_STRING);
+	kfree(brdata);
+}
+
+static const struct virtio_device_id id_table[] = {
+	{6, VIRTIO_DEV_ANY_ID},
+	{0},
+};
+
+static struct virtio_driver __refdata virtio_qxl = {
+	.driver.name = KBUILD_MODNAME,
+	.driver.owner = THIS_MODULE,
+	.id_table = id_table,
+	.probe = qxl_bridge_probe,
+	.remove = __devexit_p(qxl_bridge_remove),
+};
+
+static int __init init(void)
+{
+	int ret = 0;
+	dev = 0;
+	devindex = 0;
+	devno = 0;
+
+	dprintk(DEBUG_INFO, "%s: init\n", DRIVER_STRING);
+
+	ret = alloc_chrdev_region(&dev, 0, 1, "virtio-qxl-bridge");
+	if (ret < 0) {
+		dprintk(DEBUG_INFO, "%s: can't get major %d\n", DRIVER_STRING,
+			MAJOR(dev));
+		goto out;
+	}
+
+	sema_init(&idxsem, 1);
+
+	virtio_qxl_class = class_create(THIS_MODULE, "virtioqxl");
+	if (IS_ERR(virtio_qxl_class)) {
+		dprintk(DEBUG_INFO, "%s: error creating driver class.\n",
+			DRIVER_STRING);
+		ret = PTR_ERR(virtio_qxl_class);
+		goto class_out;
+	}
+
+	ret = register_virtio_driver(&virtio_qxl);
+	if (!ret)
+		return ret;
+
+	class_destroy(virtio_qxl_class);
+class_out:
+	unregister_chrdev_region(dev, 1);
+out:
+	return ret;
+}
+
+static void __exit finish(void)
+{
+	unregister_virtio_driver(&virtio_qxl);
+	class_destroy(virtio_qxl_class);
+	unregister_chrdev_region(dev, 1);
+	dprintk(DEBUG_INFO, "%s: ...exit.\n", DRIVER_STRING);
+}
+
+module_init(init);
+module_exit(finish);
+
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("VirtIO QXL bridge");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index fa21760..8b814f6 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -397,6 +397,7 @@ header-y += videodev2.h
 header-y += virtio_9p.h
 header-y += virtio_balloon.h
 header-y += virtio_blk.h
+header-y += virtio_bridge.h
 header-y += virtio_config.h
 header-y += virtio_console.h
 header-y += virtio_ids.h
diff --git a/include/linux/virtio_bridge.h b/include/linux/virtio_bridge.h
new file mode 100644
index 0000000..a5f6472
--- /dev/null
+++ b/include/linux/virtio_bridge.h
@@ -0,0 +1,159 @@
+/*
+ * Virtio QXL
+ *
+ *
+ * Authors:
+ *  Erlon R. Cruz <erlon.cruz@br.flextronics.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#ifndef VIRTIO_BRIDGE_H
+#define VIRTIO_BRIDGE_H
+
+#include <linux/types.h>
+
+#ifdef __KERNEL__
+/* Taken from spice-protocol */
+enum {
+	QXL_IO_NOTIFY_CMD,
+	QXL_IO_NOTIFY_CURSOR,
+	QXL_IO_UPDATE_AREA,
+	QXL_IO_UPDATE_IRQ,
+	QXL_IO_NOTIFY_OOM,
+	QXL_IO_RESET,
+	QXL_IO_SET_MODE,	/* qxl-1 */
+	QXL_IO_LOG,
+	/* appended for qxl-2 */
+	QXL_IO_MEMSLOT_ADD,
+	QXL_IO_MEMSLOT_DEL,
+	QXL_IO_DETACH_PRIMARY,
+	QXL_IO_ATTACH_PRIMARY,
+	QXL_IO_CREATE_PRIMARY,
+	QXL_IO_DESTROY_PRIMARY,
+	QXL_IO_DESTROY_SURFACE_WAIT,
+	QXL_IO_DESTROY_ALL_SURFACES,
+	/* appended for qxl-3 */
+	QXL_IO_UPDATE_AREA_ASYNC,
+	QXL_IO_MEMSLOT_ADD_ASYNC,
+	QXL_IO_CREATE_PRIMARY_ASYNC,
+	QXL_IO_DESTROY_PRIMARY_ASYNC,
+	QXL_IO_DESTROY_SURFACE_ASYNC,
+	QXL_IO_DESTROY_ALL_SURFACES_ASYNC,
+	QXL_IO_FLUSH_SURFACES_ASYNC,
+	QXL_IO_FLUSH_RELEASE,
+	QXL_IO_RANGE_SIZE
+};
+
+/* Transport operations between guest kernel and host */
+enum {
+	VIRTIOQXL_GETCFG,
+	VIRTIOQXL_IOPORT_WRITE,
+	VIRTIOQXL_GET_RAM,
+	VIRTIOQXL_SET_RAM
+};
+
+enum {
+	VIRTIOQXL_STATUS_DONE,
+	VIRTIOQXL_STATUS_ERROR,
+	VIRTIOQXL_STATUS_RANGE
+};
+
+/* TODO: Merge this num with guest_host_cmd? */
+/* Read configs from the host device */
+#define CONFIG_READ 0x00000001
+/* Write configs on the host device */
+#define CONFIG_WRITE 0x00000002
+
+#endif
+
+/* Commands betweend xf86 driver and kernel virtio driver */
+enum {
+	QXL_IO_PUSH_AREA = 100,
+	QXL_IO_PULL_AREA,
+	QXL_IO_GETCFG,
+	QXL_IO_SET_RAMSTART
+};
+
+struct qxl_ram_area {
+	__u32 offset;
+	__u32 len;
+};
+
+struct vbr_proto_hdr {
+	__u32 function;
+	__u32 flags;
+	__u32 param;		/* Parameter related var */
+	__u32 len;
+};
+
+struct iowrite_cmd {
+	__u32 port;
+	__u32 arg;
+};
+
+struct virtioqxl_config {
+	__u32 configsize;
+	__u32 ramsize;
+	__u32 vramsize;
+	__u32 romsize;
+	__u32 virtiomem[0];
+};
+
+#define QXLMAGIC 'v'
+
+#define QXL_IOCTL_NOTIFY_CMD _IOW(QXLMAGIC,\
+					QXL_IO_NOTIFY_CMD, __u32)
+#define QXL_IOCTL_NOTIFY_CURSOR _IOW(QXLMAGIC, \
+					QXL_IO_NOTIFY_CURSOR, __u32)
+#define QXL_IOCTL_UPDATE_AREA _IOW(QXLMAGIC, \
+					QXL_IO_UPDATE_AREA, __u32)
+#define QXL_IOCTL_UPDATE_IRQ _IOW(QXLMAGIC, \
+					QXL_IO_UPDATE_IRQ, __u32)
+#define QXL_IOCTL_NOTIFY_OOM _IOW(QXLMAGIC, \
+					QXL_IO_NOTIFY_OOM, __u32)
+#define QXL_IOCTL_RESET _IOW(QXLMAGIC, \
+					QXL_IO_RESET, __u32)
+#define QXL_IOCTL_SET_MODE _IOW(QXLMAGIC, \
+					QXL_IO_SET_MODE, __u32)
+#define QXL_IOCTL_LOG _IOW(QXLMAGIC, \
+					QXL_IO_LOG, __u32)
+#define QXL_IOCTL_MEMSLOT_ADD _IOW(QXLMAGIC, \
+					QXL_IO_MEMSLOT_ADD, __u32)
+#define QXL_IOCTL_MEMSLOT_DEL _IOW(QXLMAGIC, \
+					QXL_IO_MEMSLOT_DEL, __u32)
+#define QXL_IOCTL_DETACH_PRIMARY _IOW(QXLMAGIC, \
+					QXL_IO_DETACH_PRIMARY, __u32)
+#define QXL_IOCTL_ATTACH_PRIMARY _IOW(QXLMAGIC, \
+					 QXL_IO_ATTACH_PRIMARY, __u32)
+#define QXL_IOCTL_CREATE_PRIMARY _IOW(QXLMAGIC, \
+					QXL_IO_CREATE_PRIMARY, __u32)
+#define QXL_IOCTL_DESTROY_PRIMARY _IOW(QXLMAGIC, \
+					QXL_IO_DESTROY_PRIMARY, __u32)
+#define QXL_IOCTL_DESTROY_SURFACE_WAIT _IOW(QXLMAGIC, \
+					QXL_IO_DESTROY_SURFACE_WAIT, __u32)
+#define QXL_IOCTL_DESTROY_ALL_SURFACES _IOW(QXLMAGIC, \
+					QXL_IO_DESTROY_ALL_SURFACES, __u32)
+#define QXL_IOCTL_UPDATE_AREA_ASYNC _IOW(QXLMAGIC, \
+					QXL_IO_UPDATE_AREA_ASYNC, __u32)
+#define QXL_IOCTL_MEMSLOT_ADD_ASYNC _IOW(QXLMAGIC, \
+					QXL_IO_MEMSLOT_ADD_ASYNC, __u32)
+#define QXL_IOCTL_CREATE_PRIMARY_ASYNC _IOW(QXLMAGIC, \
+					QXL_IO_CREATE_PRIMARY_ASYNC, __u32)
+#define QXL_IOCTL_DESTROY_PRIMARY_ASYNC _IOW(QXLMAGIC, \
+					QXL_IO_DESTROY_PRIMARY_ASYNC, __u32)
+#define QXL_IOCTL_DESTROY_SURFACE_ASYNC _IOW(QXLMAGIC, \
+					QXL_IO_DESTROY_SURFACE_ASYNC, __u32)
+#define QXL_IOCTL_DESTROY_ALL_SURFACES_ASYNC _IOW(QXLMAGIC, \
+				QXL_IO_DESTROY_ALL_SURFACES_ASYNC, __u32)
+#define QXL_IOCTL_FLUSH_SURFACES_ASYNC _IOW(QXLMAGIC, \
+					QXL_IO_FLUSH_SURFACES_ASYNC, __u32)
+#define QXL_IOCTL_FLUSH_RELEASE _IOW(QXLMAGIC, \
+					QXL_IO_FLUSH_RELEASE, __u32)
+#define QXL_IOCTL_QXL_IO_GETCFG _IOW(QXLMAGIC, \
+					QXL_IO_GETCFG, struct virtioqxl_config)
+#define QXL_IOCTL_QXL_IO_SET_RAMSTART _IOW(QXLMAGIC, \
+					QXL_IO_SET_RAMSTART, __u32)
+#endif /*  VIRTIO_BRIDGE_H */
-- 
1.7.4.1

