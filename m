Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761182Ab0J0NGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 09:06:04 -0400
Received: from bhuna.collabora.co.uk ([93.93.128.226]:38450 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514Ab0J0NGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 09:06:00 -0400
Message-ID: <4CC8226F.5080807@collabora.co.uk>
Date: Wed, 27 Oct 2010 14:00:31 +0100
From: Ian Molton <ian.molton@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, QEMU Developers <qemu-devel@nongnu.org>,
        virtualization@lists.osdl.org
Subject: Re: [Qemu-devel] Re: [PATCH] Implement a virtio GPU transport
References: <4CAC9CD1.2050601@collabora.co.uk> <4CB1D79A.6070805@redhat.com>	<4CBD739A.2010500@collabora.co.uk> <4CBD7560.6080207@redhat.com>
In-Reply-To: <4CBD7560.6080207@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------030405000805070409030504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030405000805070409030504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 19/10/10 11:39, Avi Kivity wrote:
> On 10/19/2010 12:31 PM, Ian Molton wrote:

>>> 2. should start with a patch to the virtio-pci spec to document what
>>> you're doing
>>
>> Where can I find that spec?
>
> http://ozlabs.org/~rusty/virtio-spec/

Ok, but I'm not patching that until theres been some review.

There are links to the associated qemu and guest OS changes in my 
original email.

>> It doesnt, at present... It could be changed fairly easily ithout
>> breaking anything if that happens though.
>
> The hypervisor and the guest can be changed independently. The driver
> should be coded so that it doesn't depend on hypervisor implementation
> details.

Fixed - updated patch tested and attached.

-Ian

--------------030405000805070409030504
Content-Type: text/x-patch;
 name="virtio_gl.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="virtio_gl.patch"

diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index 30879df..35699a0 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -1 +1 @@
-obj-y			+= drm/ vga/
+obj-y			+= drm/ vga/ misc/
diff --git a/drivers/gpu/misc/Kconfig b/drivers/gpu/misc/Kconfig
new file mode 100644
index 0000000..50043d3
--- /dev/null
+++ b/drivers/gpu/misc/Kconfig
@@ -0,0 +1,8 @@
+config VIRTIOGL
+        tristate "Virtio userspace memory transport"
+        depends on VIRTIO_PCI
+        default n
+        help
+          A Driver to facilitate transferring data from userspace to a
+          hypervisor (eg. qemu)
+
diff --git a/drivers/gpu/misc/Makefile b/drivers/gpu/misc/Makefile
new file mode 100644
index 0000000..d9ab333
--- /dev/null
+++ b/drivers/gpu/misc/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_VIRTIOGL)          += virtio-gl.o
diff --git a/drivers/gpu/misc/virtio-gl.c b/drivers/gpu/misc/virtio-gl.c
new file mode 100644
index 0000000..ad3ba14
--- /dev/null
+++ b/drivers/gpu/misc/virtio-gl.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (C) 2010 Intel Corporation
+ *
+ * Author: Ian Molton <ian.molton@collabora.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/fs.h>
+#include <linux/dma-mapping.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/miscdevice.h>
+#include <linux/virtio.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_config.h>
+
+#define DEVICE_NAME "glmem"
+
+/* Define to use debugging checksums on transfers */
+#undef DEBUG_GLIO
+
+struct virtio_gl_data {
+	char *buffer;
+	int pages;
+	unsigned int pid;
+	struct completion done;
+};
+
+struct virtio_gl_header {
+	int pid;
+	int buf_size;
+	int r_buf_size;
+#ifdef DEBUG_GLIO
+	int sum;
+#endif
+	char buffer;
+} __packed;
+
+#define to_virtio_gl_data(a)   ((struct virtio_gl_data *)(a)->private_data)
+
+#ifdef DEBUG_GLIO
+#define SIZE_OUT_HEADER (sizeof(int)*4)
+#define SIZE_IN_HEADER (sizeof(int)*2)
+#else
+#define SIZE_OUT_HEADER (sizeof(int)*3)
+#define SIZE_IN_HEADER sizeof(int)
+#endif
+
+static struct virtqueue *vq;
+
+static void glmem_done(struct virtqueue *vq)
+{
+	struct virtio_gl_data *gldata;
+	int count;
+
+	gldata = virtqueue_get_buf(vq, &count);
+
+	if (!gldata)
+		BUG();
+
+	complete(&gldata->done);
+}
+
+/* This is videobuf_vmalloc_to_sg() from videobuf-dma-sg.c with
+ * some modifications
+ */
+static struct scatterlist *vmalloc_to_sg(struct scatterlist *sg_list,
+				unsigned char *virt, unsigned int pages)
+{
+	struct page *pg;
+
+	/* unaligned */
+	BUG_ON((ulong)virt & ~PAGE_MASK);
+
+	/* Fill with elements for the data */
+	while (pages) {
+		pg = vmalloc_to_page(virt);
+		if (!pg)
+			goto err;
+
+		sg_set_page(sg_list, pg, PAGE_SIZE, 0);
+		virt += PAGE_SIZE;
+		sg_list++;
+		pages--;
+	}
+
+	return sg_list;
+
+err:
+	kfree(sg_list);
+	return NULL;
+}
+
+static int put_data(struct virtio_gl_data *gldata)
+{
+	struct scatterlist *sg, *sg_list;
+	unsigned int ret, o_page, i_page, sg_entries;
+	struct virtio_gl_header *header =
+				(struct virtio_gl_header *)gldata->buffer;
+
+	ret = header->buf_size;
+
+	o_page = (header->buf_size + PAGE_SIZE-1) >> PAGE_SHIFT;
+	i_page = (header->r_buf_size + PAGE_SIZE-1) >> PAGE_SHIFT;
+
+	header->pid = gldata->pid;
+
+	if ((o_page && i_page) &&
+		(o_page > gldata->pages || i_page > gldata->pages)) {
+		i_page = 0;
+	}
+
+	if (o_page > gldata->pages)
+		o_page = gldata->pages;
+
+	if (i_page > gldata->pages)
+		i_page = gldata->pages;
+
+	if (!o_page)
+		o_page = 1;
+
+	sg_entries = o_page + i_page;
+
+	sg_list = kcalloc(sg_entries, sizeof(struct scatterlist), GFP_KERNEL);
+
+	if (!sg_list) {
+		ret = -EIO;
+		goto out;
+	}
+
+	sg_init_table(sg_list, sg_entries);
+
+	sg = vmalloc_to_sg(sg_list, gldata->buffer, o_page);
+	sg = vmalloc_to_sg(sg, gldata->buffer, i_page);
+
+	if (!sg) {
+		ret = -EIO;
+		goto out_free;
+	}
+
+	/* Transfer data */
+	if (virtqueue_add_buf(vq, sg_list, o_page, i_page, gldata) >= 0) {
+		virtqueue_kick(vq);
+		/* Chill out until it's done with the buffer. */
+		wait_for_completion(&gldata->done);
+	}
+
+out_free:
+	kfree(sg_list);
+out:
+	return ret;
+}
+
+static void free_buffer(struct virtio_gl_data *gldata)
+{
+	if (gldata->buffer) {
+		vfree(gldata->buffer);
+		gldata->buffer = NULL;
+	}
+}
+
+static int glmem_open(struct inode *inode, struct file *file)
+{
+	struct virtio_gl_data *gldata = kzalloc(sizeof(struct virtio_gl_data),
+						GFP_KERNEL);
+
+	if (!gldata)
+		return -ENXIO;
+
+	gldata->pid = pid_nr(task_pid(current));
+	init_completion(&gldata->done);
+
+	file->private_data = gldata;
+
+	return 0;
+}
+
+static int glmem_mmap(struct file *filp, struct vm_area_struct *vma)
+{
+	struct virtio_gl_data *gldata = to_virtio_gl_data(filp);
+	int pages = (vma->vm_end - vma->vm_start) / PAGE_SIZE;
+
+	/* Set a reasonable limit */
+	if (pages > 16)
+		return -ENOMEM;
+
+	/* for now, just allow one buffer to be mmap()ed. */
+	if (gldata->buffer)
+		return -EIO;
+
+	gldata->buffer = vmalloc_user(pages*PAGE_SIZE);
+
+	if (!gldata->buffer)
+		return -ENOMEM;
+
+	gldata->pages = pages;
+
+	if (remap_vmalloc_range(vma, gldata->buffer, 0) < 0) {
+		vfree(gldata->buffer);
+		return -EIO;
+	}
+
+	vma->vm_flags |= VM_DONTEXPAND;
+
+	return 0;
+}
+
+static int glmem_fsync(struct file *filp, int datasync)
+{
+	struct virtio_gl_data *gldata = to_virtio_gl_data(filp);
+
+	put_data(gldata);
+
+	return 0;
+}
+
+static int glmem_release(struct inode *inode, struct file *file)
+{
+	struct virtio_gl_data *gldata = to_virtio_gl_data(file);
+
+	if (gldata && gldata->buffer) {
+		struct virtio_gl_header *header =
+				(struct virtio_gl_header *)gldata->buffer;
+
+		/* Make sure the host hears about the process ending / dying */
+		header->pid = gldata->pid;
+		header->buf_size = SIZE_OUT_HEADER + 2;
+		header->r_buf_size = SIZE_IN_HEADER;
+		*(short *)(&header->buffer) = -1;
+
+		put_data(gldata);
+		free_buffer(gldata);
+	}
+
+	kfree(gldata);
+
+	return 0;
+}
+
+static const struct file_operations glmem_fops = {
+	.owner		= THIS_MODULE,
+	.open		= glmem_open,
+	.mmap		= glmem_mmap,
+	.fsync		= glmem_fsync,
+	.release	= glmem_release,
+};
+
+static struct miscdevice glmem_dev = {
+	MISC_DYNAMIC_MINOR,
+	DEVICE_NAME,
+	&glmem_fops
+};
+
+static int glmem_probe(struct virtio_device *vdev)
+{
+	int ret;
+
+	/* We expect a single virtqueue. */
+	vq = virtio_find_single_vq(vdev, glmem_done, "output");
+	if (IS_ERR(vq))
+		return PTR_ERR(vq);
+
+	ret = misc_register(&glmem_dev);
+	if (ret) {
+		printk(KERN_ERR "glmem: cannot register glmem_dev as misc");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+static void __devexit glmem_remove(struct virtio_device *vdev)
+{
+	vdev->config->reset(vdev);
+	misc_deregister(&glmem_dev);
+	vdev->config->del_vqs(vdev);
+}
+
+static struct virtio_device_id id_table[] = {
+	{ VIRTIO_ID_GL, VIRTIO_DEV_ANY_ID },
+	{ 0 },
+};
+
+static struct virtio_driver virtio_gl_driver = {
+	.driver	= {
+		.name =  KBUILD_MODNAME,
+		.owner = THIS_MODULE,
+	},
+	.id_table =     id_table,
+	.probe =        glmem_probe,
+	.remove =       __devexit_p(glmem_remove),
+};
+
+static int __init glmem_init(void)
+{
+	return register_virtio_driver(&virtio_gl_driver);
+}
+
+static void __exit glmem_exit(void)
+{
+	unregister_virtio_driver(&virtio_gl_driver);
+}
+
+module_init(glmem_init);
+module_exit(glmem_exit);
+
+MODULE_DEVICE_TABLE(virtio, id_table);
+MODULE_DESCRIPTION("Virtio gl passthrough driver");
+MODULE_LICENSE("GPL v2");
+
diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index 3d94a14..9a9a6cc 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -16,6 +16,7 @@ source "drivers/char/agp/Kconfig"
 source "drivers/gpu/vga/Kconfig"
 
 source "drivers/gpu/drm/Kconfig"
+source "drivers/gpu/misc/Kconfig"
 
 config VGASTATE
        tristate
diff --git a/include/linux/virtio_ids.h b/include/linux/virtio_ids.h
index 06660c0..663b496 100644
--- a/include/linux/virtio_ids.h
+++ b/include/linux/virtio_ids.h
@@ -12,6 +12,7 @@
 #define VIRTIO_ID_CONSOLE	3 /* virtio console */
 #define VIRTIO_ID_RNG		4 /* virtio ring */
 #define VIRTIO_ID_BALLOON	5 /* virtio balloon */
+#define VIRTIO_ID_GL		6 /* virtio usermem */
 #define VIRTIO_ID_9P		9 /* 9p virtio console */
 
 #endif /* _LINUX_VIRTIO_IDS_H */

--------------030405000805070409030504--
