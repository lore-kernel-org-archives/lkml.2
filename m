Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab0CSUrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:47:08 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:42956 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752162Ab0CSUrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:47:04 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH 4/4] Add VMware memory balloon driver
To: linux-kernel@vger.kernel.org
Cc: pv-drivers@vmware.com, Alok Kataria <akataria@vmware.com>,
       Saileshkumar Jain <sajain@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 19 Mar 2010 13:47:03 -0700
Message-ID: <20100319204702.4418.92437.stgit@localhost.localdomain>
In-Reply-To: <20100319204628.4418.84674.stgit@localhost.localdomain>
References: <20100319204628.4418.84674.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a virtio-based transport between VMware's hypervisor
and virtio_ballon driver that allows host control guest memory
ballooning.

Reviewed-by: Alok Kataria <akataria@vmware.com>
Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

 drivers/misc/Kconfig          |   13 +
 drivers/misc/Makefile         |    1 
 drivers/misc/vmware_balloon.c |  626 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 640 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmware_balloon.c

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2191c8d..de7e97e 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -311,6 +311,19 @@ config TI_DAC7512
 	  This driver can also be built as a module. If so, the module
 	  will be calles ti_dac7512.
 
+config VMWARE_BALLOON
+	tristate "VMware Balloon Driver"
+	depends on VIRTIO && X86
+	help
+	  This option enables virtio based transport between VMware hypervisor
+	  and virtio_balloon and allows host control memory ballooning within
+	  the guest.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vmware_balloon.
+
 source "drivers/misc/c2port/Kconfig"
 source "drivers/misc/eeprom/Kconfig"
 source "drivers/misc/cb710/Kconfig"
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 27c4843..7b6f7ee 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -29,3 +29,4 @@ obj-$(CONFIG_C2PORT)		+= c2port/
 obj-$(CONFIG_IWMC3200TOP)      += iwmc3200top/
 obj-y				+= eeprom/
 obj-y				+= cb710/
+obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
new file mode 100644
index 0000000..4f56e46
--- /dev/null
+++ b/drivers/misc/vmware_balloon.c
@@ -0,0 +1,626 @@
+/*
+ * VMware Balloon driver (virtio-based).
+ *
+ * Copyright (C) 2008-2010, VMware, Inc. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; version 2 of the License and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ * NON INFRINGEMENT.  See the GNU General Public License for more
+ * details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Maintained by: Dmitry Torokhov <dtor@vmware.com>
+ *
+ */
+
+//#define DEBUG
+//#define VERBOSE_DEBUG
+
+#include <linux/module.h>
+#include <linux/virtio.h>
+#include <linux/virtio_config.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_balloon.h>
+#include <asm/vmware.h>
+
+MODULE_AUTHOR("VMware, Inc.");
+MODULE_DESCRIPTION("VMware balloon over virtio driver");
+MODULE_ALIAS("dmi:*:svnVMware*:*");
+MODULE_ALIAS("vmware_balloon");
+MODULE_LICENSE("GPL");
+
+/* ================================================================= */
+
+#define VMW_BALLOON_HV_PORT		0x5670
+#define VMW_BALLOON_HV_MAGIC		0x456c6d6f
+#define VMW_BALLOON_PROTOCOL_VERSION	2
+#define VMW_BALLOON_GUEST_ID		1	/* Linux */
+
+#define VMW_BALLOON_CMD_START		0
+#define VMW_BALLOON_CMD_GET_TARGET	1
+#define VMW_BALLOON_CMD_LOCK		2
+#define VMW_BALLOON_CMD_UNLOCK		3
+#define VMW_BALLOON_CMD_GUEST_ID	4
+
+/* use config value for max balloon size */
+#define BALLOON_MAX_SIZE_USE_CONFIG	0
+
+/* error codes */
+#define VMW_BALLOON_SUCCESS		0
+#define VMW_BALLOON_FAILURE		-1
+#define VMW_BALLOON_ERROR_CMD_INVALID	1
+#define VMW_BALLOON_ERROR_PPN_INVALID	2
+#define VMW_BALLOON_ERROR_PPN_LOCKED	3
+#define VMW_BALLOON_ERROR_PPN_UNLOCKED	4
+#define VMW_BALLOON_ERROR_PPN_PINNED	5
+#define VMW_BALLOON_ERROR_PPN_NOTNEEDED	6
+#define VMW_BALLOON_ERROR_RESET		7
+#define VMW_BALLOON_ERROR_BUSY		8
+
+#define VMWARE_BALLOON_CMD(cmd, data, result)		\
+({							\
+	unsigned long __stat, __dummy1, __dummy2;	\
+	__asm__ __volatile__ ("inl (%%dx)" :		\
+		"=a"(__stat),				\
+		"=c"(__dummy1),				\
+		"=d"(__dummy2),				\
+		"=b"(result) :				\
+		"0"(VMW_BALLOON_HV_MAGIC),		\
+		"1"(VMW_BALLOON_CMD_##cmd),		\
+		"2"(VMW_BALLOON_HV_PORT),		\
+		"3"(data) :				\
+		"memory");				\
+	result &= -1UL;					\
+	__stat & -1UL;					\
+})
+
+/* ================================================================= */
+
+#define STATS_INC(x)
+
+struct vmballoon_dev {
+	struct virtio_device vdev;
+	struct virtqueue vqs[2];
+	struct virtio_balloon_config config;
+	struct timer_list poll_timer;	/* for polling host for target size */
+	struct sysinfo sysinfo;
+	u8 status;
+	void *vb;
+	bool target_current;
+};
+
+static struct vmballoon_dev *to_vmballoon_dev(struct virtio_device *vdev)
+{
+	return container_of(vdev, struct vmballoon_dev, vdev);
+}
+
+static void vmballoon_release_device(struct device *dev)
+{
+	struct virtio_device *vdev =
+		container_of(dev, struct virtio_device, dev);
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+
+	dev_vdbg(&bdev->vdev.dev, "executing %s\n", __func__);
+	kfree(bdev);
+}
+
+static void vmballoon_signal_reset(struct vmballoon_dev *bdev)
+{
+	struct virtio_driver *drv = container_of(bdev->vdev.dev.driver,
+						 struct virtio_driver, driver);
+	if (!bdev->config.reset_pending) {
+		bdev->config.reset_completed = false;
+		bdev->config.reset_pending = true;
+		/*
+		 * Make sure config is written before we signal that
+		 * it is changed. We are running on x86 so simple
+		 * barrier() is enough.
+		 */
+		barrier();
+		if (drv->config_changed)
+			drv->config_changed(&bdev->vdev);
+	}
+}
+
+static bool vmballoon_send_start(struct vmballoon_dev *bdev)
+{
+	unsigned long status, dummy;
+
+	STATS_INC(bdev->stats.start);
+
+	status = VMWARE_BALLOON_CMD(START, VMW_BALLOON_PROTOCOL_VERSION, dummy);
+	if (status == VMW_BALLOON_SUCCESS)
+		return true;
+
+	dev_vdbg(&bdev->vdev.dev, "%s - failed, hv returns %ld\n",
+		 __func__, status);
+	STATS_INC(bdev->stats.start_fail);
+	return false;
+}
+
+static bool vmballoon_check_status(struct vmballoon_dev *bdev,
+				   unsigned long status)
+{
+	switch (status) {
+	case VMW_BALLOON_SUCCESS:
+		return true;
+
+	case VMW_BALLOON_ERROR_RESET:
+		vmballoon_signal_reset(bdev);
+		/* fall through */
+
+	default:
+		return false;
+	}
+}
+
+static bool vmballoon_send_guest_id(struct vmballoon_dev *bdev)
+{
+	unsigned long status, dummy;
+
+	status = VMWARE_BALLOON_CMD(GUEST_ID, VMW_BALLOON_GUEST_ID, dummy);
+
+	STATS_INC(bdev->stats.guestType);
+
+	if (vmballoon_check_status(bdev, status))
+		return true;
+
+	dev_vdbg(&bdev->vdev.dev, "%s - failed, hv returns %ld\n",
+		 __func__, status);
+	STATS_INC(bdev->stats.guest_type_fail);
+	return false;
+}
+
+static bool vmballoon_send_get_target(struct vmballoon_dev *bdev,
+				      u32 *new_target)
+{
+	unsigned long status;
+	unsigned long target;
+	unsigned long limit;
+	u32 limit32;
+
+	if (bdev->config.reset_pending)
+		return false;
+
+	/*
+	 * si_meminfo() is cheap. Moreover, we want to provide dynamic
+	 * max balloon size later. So let us call si_meminfo() every
+	 * iteration.
+	 */
+	si_meminfo(&bdev->sysinfo);
+	limit = bdev->sysinfo.totalram;
+
+	/* Ensure limit fits in 32-bits */
+	limit32 = (u32)limit;
+	if (limit != limit32)
+		return false;
+
+	/* update stats */
+	STATS_INC(bdev->stats.target);
+
+	status = VMWARE_BALLOON_CMD(GET_TARGET, limit, target);
+	if (vmballoon_check_status(bdev, status)) {
+		*new_target = target;
+		return true;
+	}
+
+	dev_vdbg(&bdev->vdev.dev, "%s - failed, hv returns %ld\n",
+		 __func__, status);
+	STATS_INC(bdev->stats.target_fail);
+	return false;
+}
+
+static bool vmballoon_send_lock_page(struct vmballoon_dev *bdev,
+				     unsigned long pfn)
+{
+	unsigned long status, dummy;
+	u32 pfn32;
+
+	pfn32 = (u32)pfn;
+	if (pfn32 != pfn)
+		return false;
+
+	if (bdev->config.reset_pending)
+		return false;
+
+	STATS_INC(bdev->stats.lock);
+
+	status = VMWARE_BALLOON_CMD(LOCK, pfn, dummy);
+	if (vmballoon_check_status(bdev, status))
+		return true;
+
+	dev_vdbg(&bdev->vdev.dev, "%s - ppn %lx, hv returns %ld\n",
+		 __func__, pfn, status);
+	STATS_INC(bdev->stats.lock_fail);
+	return false;
+}
+
+static bool vmballoon_send_unlock_page(struct vmballoon_dev *bdev,
+					unsigned long pfn)
+{
+	unsigned long status, dummy;
+	u32 pfn32;
+
+	pfn32 = (u32)pfn;
+	if (pfn32 != pfn)
+		return false;
+
+	if (bdev->config.reset_pending)
+		return false;
+
+	STATS_INC(bdev->stats.unlock);
+
+	status = VMWARE_BALLOON_CMD(UNLOCK, pfn, dummy);
+	if (vmballoon_check_status(bdev, status))
+		return true;
+
+	dev_vdbg(&bdev->vdev.dev, "%s - ppn %lx, hv returns %ld\n",
+		 __func__, pfn, status);
+	STATS_INC(bdev->stats.unlock_fail);
+	return false;
+}
+
+static void vmballoon_do_reset(struct vmballoon_dev *bdev)
+{
+	dev_vdbg(&bdev->vdev.dev, "executing %s\n", __func__);
+
+	/* send start command */
+	if (vmballoon_send_start(bdev)) {
+		bdev->config.reset_pending = false;
+		vmballoon_send_guest_id(bdev);
+	}
+}
+
+static void vmballoon_poll_host(unsigned long data)
+{
+	struct vmballoon_dev *bdev = (struct vmballoon_dev *) data;
+	struct virtio_driver *drv = container_of(bdev->vdev.dev.driver,
+						 struct virtio_driver, driver);
+	u32 new_target;
+
+	STATS_INC(bdev->stats.timer);
+
+	if (bdev->config.reset_pending) {
+		if (!bdev->config.reset_completed)
+			goto out;
+
+		vmballoon_do_reset(bdev);
+	}
+
+	if (vmballoon_send_get_target(bdev, &new_target)) {
+		bdev->target_current = true;
+		if (new_target != le32_to_cpu(bdev->config.num_pages)) {
+			dev_dbg(&bdev->vdev.dev,
+				"%s: target changed (was %d, now %d pages)\n",
+				__func__,
+				le32_to_cpu(bdev->config.num_pages),
+				new_target);
+			bdev->config.num_pages = cpu_to_le32(new_target);
+			/*
+			 * Make sure new target is written before we signal
+			 * that it is changed. We are running on x86 so simple
+			 * barrier() is enough.
+			 */
+			barrier();
+			if (drv->config_changed)
+				drv->config_changed(&bdev->vdev);
+		}
+	}
+
+out:
+	mod_timer(&bdev->poll_timer, round_jiffies(jiffies + HZ));
+}
+
+/* Virtqueue config operations */
+
+static int vmballoon_vq_add_buf(struct virtqueue *vq,
+				struct scatterlist sg[],
+				unsigned int out_num,
+				unsigned int in_num,
+				void *data)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vq->vdev);
+	bool success;
+	struct scatterlist *sg_tmp;
+	struct scatterlist *sg_out;
+	u32 *pfns;
+	unsigned int npfns;
+	struct scatterlist *sg_in = NULL;
+	unsigned int sg_in_idx, sg_in_size;
+	u8 *pfns_state;
+	unsigned int total_pfns = 0, refused_pfns = 0;
+	unsigned int i, j;
+
+	dev_dbg(&bdev->vdev.dev, "executing %s for %s\n", __func__, vq->name);
+
+	if (out_num == 0 || in_num == 0)
+		return -EINVAL;
+
+	for_each_sg(sg, sg_tmp, out_num + 1, i)
+		sg_in = sg_tmp;
+	BUG_ON(sg_in == NULL);
+
+	pfns_state = sg_virt(sg_in);
+	sg_in_idx = 0;
+	sg_in_size = sg_in->length / sizeof(pfns_state[0]);
+
+	for_each_sg(sg, sg_out, out_num, i) {
+
+		pfns = sg_virt(sg_out);
+		npfns = sg_out->length / sizeof(pfns[0]);
+		total_pfns += npfns;
+
+		for (j = 0; j < npfns; j++) {
+
+			success = (unsigned long)vq->priv == 0 ?
+				vmballoon_send_lock_page(bdev, pfns[j]) :
+				vmballoon_send_unlock_page(bdev, pfns[j]);
+
+			if (sg_in_idx >= sg_in_size) {
+				sg_in = sg_next(sg_in);
+				BUG_ON(sg_in == NULL);
+
+				pfns_state = sg_virt(sg_in);
+				sg_in_idx = 0;
+				sg_in_size = sg_in->length /
+						sizeof(pfns_state[0]);
+			}
+
+			if (success) {
+				pfns_state[sg_in_idx++] = VIRTIO_BALLOON_PFN_OK;
+			} else {
+				pfns_state[sg_in_idx++] = VIRTIO_BALLOON_PFN_FAIL;
+				refused_pfns++;
+			}
+		}
+	}
+
+	bdev->vb = data;
+	bdev->target_current = false;
+
+	dev_dbg(&vq->vdev->dev, "done %s (%d requested, %d refused)\n",
+		__func__, total_pfns, refused_pfns);
+	return 0;
+}
+
+static void *vmballoon_vq_get_buf(struct virtqueue *vq, unsigned int *len)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vq->vdev);
+
+	dev_vdbg(&vq->vdev->dev, "executing %s\n", __func__);
+
+	return bdev->vb;
+}
+
+static void vmballoon_vq_kick(struct virtqueue *vq)
+{
+	dev_vdbg(&vq->vdev->dev, "executing %s\n", __func__);
+
+	/*
+	 * We contact hypervisor in vmballoon_vq_add_buf() so here
+	 * we just signal the completion.
+	 */
+	vq->callback(vq);
+}
+
+static void vmballoon_vq_disable_cb(struct virtqueue *vq)
+{
+	dev_vdbg(&vq->vdev->dev, "executing %s\n", __func__);
+}
+
+static bool vmballoon_vq_enable_cb(struct virtqueue *vq)
+{
+	dev_vdbg(&vq->vdev->dev, "executing %s\n", __func__);
+	return false;
+}
+
+static struct virtqueue_ops vmballoon_vq_ops = {
+	.add_buf	= vmballoon_vq_add_buf,
+	.get_buf	= vmballoon_vq_get_buf,
+	.kick		= vmballoon_vq_kick,
+	.disable_cb	= vmballoon_vq_disable_cb,
+	.enable_cb	= vmballoon_vq_enable_cb,
+};
+
+/* Virtdevice config operations */
+
+static u32 vmballoon_get_features(struct virtio_device *vdev)
+{
+	unsigned long features;
+
+	dev_vdbg(&vdev->dev, "executing %s\n", __func__);
+
+	__set_bit(VIRTIO_BALLOON_F_MUST_TELL_HOST, &features);
+	__set_bit(VIRTIO_BALLOON_F_HOST_MAY_REFUSE, &features);
+
+	return features;
+}
+
+static void vmballoon_finalize_features(struct virtio_device *vdev)
+{
+	dev_vdbg(&vdev->dev, "executing %s\n", __func__);
+}
+
+static void vmballoon_get_target(struct vmballoon_dev *bdev)
+{
+	u32 new_target;
+
+	if (bdev->target_current) {
+		dev_vdbg(&bdev->vdev.dev,
+			 "%s: target is current, skipping host query\n",
+			 __func__);
+	} else if (vmballoon_send_get_target(bdev, &new_target)) {
+		bdev->target_current = true;
+		if (le32_to_cpu(bdev->config.num_pages) != new_target) {
+			dev_dbg(&bdev->vdev.dev,
+				"%s: target now is %d pages (%dM)\n",
+				__func__, new_target, new_target >> 8);
+			bdev->config.num_pages = cpu_to_le32(new_target);
+		}
+	}
+}
+
+static void vmballoon_get(struct virtio_device *vdev, unsigned offset,
+			  void *buf, unsigned len)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+
+	dev_vdbg(&vdev->dev, "%s: reading %d bytes at offset %d\n",
+		__func__, len, offset);
+
+	if (offset == offsetof(struct virtio_balloon_config, num_pages))
+		vmballoon_get_target(bdev);
+
+	memcpy(buf, (u8 *)&bdev->config + offset, len);
+}
+
+static void vmballoon_set(struct virtio_device *vdev, unsigned offset,
+			  const void *buf, unsigned len)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+
+	dev_dbg(&vdev->dev, "%s: writing %d bytes at offset %d\n",
+		__func__, len, offset);
+
+	memcpy((u8 *)&bdev->config + offset, buf, len);
+}
+
+static u8 vmballoon_get_status(struct virtio_device *vdev)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+
+	dev_vdbg(&bdev->vdev.dev, "executing %s\n", __func__);
+	return bdev->status;
+}
+
+static void vmballoon_set_status(struct virtio_device *vdev, u8 status)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+
+	dev_vdbg(&bdev->vdev.dev, "executing %s\n", __func__);
+	bdev->status = status;
+}
+
+static int vmballoon_find_vqs(struct virtio_device *vdev, unsigned nvqs,
+			      struct virtqueue *vqs[],
+			      vq_callback_t *callbacks[],
+			      const char *names[])
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+	struct virtqueue *vq;
+	long i;
+
+	dev_vdbg(&bdev->vdev.dev, "executing %s\n", __func__);
+
+	if (nvqs != 2)
+		return -EINVAL;
+
+	for (i = 0; i < nvqs; i++) {
+		vq = &bdev->vqs[i];
+
+		memset(vq, 0, sizeof(*vq));
+		INIT_LIST_HEAD(&vq->list);
+		vq->callback = callbacks[i];
+		vq->name = names[i];
+		vq->vdev = vdev;
+		vq->vq_ops = &vmballoon_vq_ops;
+		vq->priv = (void *) i;
+
+		vqs[i] = vq;
+	}
+
+	/*
+	 * Reset and start balloon interface
+	 */
+	vmballoon_do_reset(bdev);
+
+	/*
+	 * Start polling host for the target balloon size
+	 */
+	mod_timer(&bdev->poll_timer, round_jiffies(jiffies + HZ));
+
+	return 0;
+}
+
+static void vmballoon_del_vqs(struct virtio_device *vdev)
+{
+	/*
+	 * We are using statically allocated virtqueues, no need to do
+	 * anything here.
+	 */
+}
+
+static void vmballoon_reset(struct virtio_device *vdev)
+{
+	struct vmballoon_dev *bdev = to_vmballoon_dev(vdev);
+
+	dev_vdbg(&bdev->vdev.dev, "executing %s", __func__);
+
+	/* Stop host polling */
+	del_timer_sync(&bdev->poll_timer);
+
+	/* Virtio core expects us to reset the status */
+	bdev->status = 0;
+}
+
+static struct virtio_config_ops vmballoon_config_ops = {
+	.get_features		= vmballoon_get_features,
+	.finalize_features	= vmballoon_finalize_features,
+	.get			= vmballoon_get,
+	.set			= vmballoon_set,
+	.get_status		= vmballoon_get_status,
+	.set_status		= vmballoon_set_status,
+	.reset			= vmballoon_reset,
+	.find_vqs		= vmballoon_find_vqs,
+	.del_vqs		= vmballoon_del_vqs,
+};
+
+static struct vmballoon_dev *vmballoon_dev;
+
+static int __init vmballoon_init(void)
+{
+	struct virtio_device *vdev;
+	int err;
+
+	/*
+	 * Check if we are running on VMware's hypervisor and bail out
+	 * if we are not.
+	 */
+	if (!vmware_platform())
+		return -ENODEV;
+
+	vmballoon_dev = kzalloc(sizeof(struct vmballoon_dev), GFP_KERNEL);
+	if (!vmballoon_dev)
+		return -ENOMEM;
+
+	setup_timer(&vmballoon_dev->poll_timer,
+		    vmballoon_poll_host, (unsigned long)vmballoon_dev);
+
+	vdev = &vmballoon_dev->vdev;
+	vdev->dev.release = vmballoon_release_device;
+	vdev->id.device = VIRTIO_ID_BALLOON;
+	vdev->config = &vmballoon_config_ops;
+
+	err = register_virtio_device(&vmballoon_dev->vdev);
+	if (err) {
+		kfree(&vmballoon_dev->vdev);
+		return err;
+	}
+
+	return 0;
+}
+module_init(vmballoon_init)
+
+static void __exit vmballoon_exit(void)
+{
+	unregister_virtio_device(&vmballoon_dev->vdev);
+}
+module_exit(vmballoon_exit)

