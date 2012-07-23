Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab2GWUcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 16:32:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46032 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab2GWUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 16:32:35 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: rusty@rustcorp.com.au, mst@redhat.com, penberg@kernel.org,
        asias.hejun@gmail.com
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, anthony@codemonkey.ws,
        wency@cn.fujitsu.com, Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 2/2] kvm tools: support virtio-notifier
Date: Mon, 23 Jul 2012 22:32:41 +0200
Message-Id: <1343075561-29316-3-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
References: <1343075561-29316-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch supports the new virtio-notifier driver.

When the guest experiences a panic or an OOM, it will notify the host and
the host will notify the user of the event.

We also ping echo packets every second to the guest to see if it's still
alive and well, I haven't actually taken care of the case when echos are
gone for some reason since I'm trying to think of something useful to do
with that besides yell on stdout.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 tools/kvm/Makefile                      |    1 +
 tools/kvm/builtin-run.c                 |    6 +
 tools/kvm/include/kvm/virtio-notifier.h |    9 ++
 tools/kvm/include/kvm/virtio-pci-dev.h  |    1 +
 tools/kvm/virtio/notifier.c             |  203 +++++++++++++++++++++++++++++++
 5 files changed, 220 insertions(+), 0 deletions(-)
 create mode 100644 tools/kvm/include/kvm/virtio-notifier.h
 create mode 100644 tools/kvm/virtio/notifier.c

diff --git a/tools/kvm/Makefile b/tools/kvm/Makefile
index f9e1ec1..6827c1f 100644
--- a/tools/kvm/Makefile
+++ b/tools/kvm/Makefile
@@ -89,6 +89,7 @@ OBJS	+= hw/pci-shmem.o
 OBJS	+= kvm-ipc.o
 OBJS	+= builtin-sandbox.o
 OBJS	+= virtio/mmio.o
+OBJS	+= virtio/notifier.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/)
diff --git a/tools/kvm/builtin-run.c b/tools/kvm/builtin-run.c
index 750d30c..90ac622 100644
--- a/tools/kvm/builtin-run.c
+++ b/tools/kvm/builtin-run.c
@@ -33,6 +33,7 @@
 #include "kvm/pci-shmem.h"
 #include "kvm/kvm-ipc.h"
 #include "kvm/builtin-debug.h"
+#include "kvm/virtio-notifier.h"
 
 #include <linux/types.h>
 #include <linux/err.h>
@@ -99,6 +100,7 @@ static bool using_rootfs;
 static bool custom_rootfs;
 static bool no_net;
 static bool no_dhcp;
+static bool virtio_notifier;
 extern bool ioport_debug;
 extern bool mmio_debug;
 static int  kvm_run_wrapper;
@@ -442,6 +444,7 @@ static const struct option options[] = {
 	OPT_BOOLEAN('\0', "vnc", &vnc, "Enable VNC framebuffer"),
 	OPT_BOOLEAN('\0', "sdl", &sdl, "Enable SDL framebuffer"),
 	OPT_BOOLEAN('\0', "rng", &virtio_rng, "Enable virtio Random Number Generator"),
+	OPT_BOOLEAN('\0', "notifier", &virtio_notifier, "Enable virtio notifier"),
 	OPT_CALLBACK('\0', "9p", NULL, "dir_to_share,tag_name",
 		     "Enable virtio 9p to share files between host and guest", virtio_9p_rootdir_parser),
 	OPT_STRING('\0', "console", &console, "serial, virtio or hv",
@@ -1182,6 +1185,9 @@ static int kvm_cmd_run_init(int argc, const char **argv)
 	if (virtio_rng)
 		virtio_rng__init(kvm);
 
+	if (virtio_notifier)
+		virtio_notif__init(kvm);
+
 	if (balloon)
 		virtio_bln__init(kvm);
 
diff --git a/tools/kvm/include/kvm/virtio-notifier.h b/tools/kvm/include/kvm/virtio-notifier.h
new file mode 100644
index 0000000..5673fc2
--- /dev/null
+++ b/tools/kvm/include/kvm/virtio-notifier.h
@@ -0,0 +1,9 @@
+#ifndef KVM__NOTIF_VIRTIO_H
+#define KVM__NOTIF_VIRTIO_H
+
+struct kvm;
+
+int virtio_notif__init(struct kvm *kvm);
+int virtio_notif__exit(struct kvm *kvm);
+
+#endif /* KVM__RNG_VIRTIO_H */
diff --git a/tools/kvm/include/kvm/virtio-pci-dev.h b/tools/kvm/include/kvm/virtio-pci-dev.h
index 7ceb125..a387ecd 100644
--- a/tools/kvm/include/kvm/virtio-pci-dev.h
+++ b/tools/kvm/include/kvm/virtio-pci-dev.h
@@ -13,6 +13,7 @@
 #define PCI_DEVICE_ID_VIRTIO_CONSOLE		0x1003
 #define PCI_DEVICE_ID_VIRTIO_RNG		0x1004
 #define PCI_DEVICE_ID_VIRTIO_BLN		0x1005
+#define PCI_DEVICE_ID_VIRTIO_NOTIFIER		0x1006
 #define PCI_DEVICE_ID_VIRTIO_9P			0x1009
 #define PCI_DEVICE_ID_VESA			0x2000
 #define PCI_DEVICE_ID_PCI_SHMEM			0x0001
diff --git a/tools/kvm/virtio/notifier.c b/tools/kvm/virtio/notifier.c
new file mode 100644
index 0000000..c17546b
--- /dev/null
+++ b/tools/kvm/virtio/notifier.c
@@ -0,0 +1,203 @@
+#include "kvm/virtio-notifier.h"
+
+#include "kvm/virtio-pci-dev.h"
+
+#include "kvm/virtio.h"
+#include "kvm/util.h"
+#include "kvm/kvm.h"
+#include "kvm/threadpool.h"
+#include "kvm/guest_compat.h"
+
+#include <linux/virtio_ring.h>
+#include <linux/virtio_notifier.h>
+
+#include <linux/list.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <pthread.h>
+#include <linux/kernel.h>
+
+#define NUM_VIRT_QUEUES			2
+#define VIRTIO_NOTIFIER_QUEUE_SIZE	128
+
+struct ntf_dev_job {
+	struct virt_queue	*vq;
+	struct ntf_dev		*ndev;
+	struct thread_pool__job	job_id;
+};
+
+struct ntf_dev {
+	struct list_head	list;
+	struct virtio_device	vdev;
+
+	/* virtio queue */
+	struct virt_queue	vqs[NUM_VIRT_QUEUES];
+	struct ntf_dev_job	jobs[NUM_VIRT_QUEUES];
+};
+
+static LIST_HEAD(ndevs);
+static int compat_id = -1;
+
+static void set_config(struct kvm *kvm, void *dev, u8 data, u32 offset)
+{
+	/* Unused */
+}
+
+static u8 get_config(struct kvm *kvm, void *dev, u32 offset)
+{
+	/* Unused */
+	return 0;
+}
+
+static u32 get_host_features(struct kvm *kvm, void *dev)
+{
+	/* Unused */
+	return 0;
+}
+
+static void set_guest_features(struct kvm *kvm, void *dev, u32 features)
+{
+	/* Unused */
+}
+
+static bool virtio_ntf_do_io_request(struct kvm *kvm, struct ntf_dev *ndev, struct virt_queue *queue)
+{
+	struct iovec iov[VIRTIO_NOTIFIER_QUEUE_SIZE];
+	unsigned int len = 0;
+	u16 out, in, head;
+	u32 *counters;
+
+	head = virt_queue__get_iov(queue, iov, &out, &in, kvm);
+	counters = iov[0].iov_base;
+
+	printf("\n\n New updated counters from guest:\n\tPanic: %u OOM: %u\n\n",
+		counters[VIRTIO_NOTIF_PANIC], counters[VIRTIO_NOTIF_OOM]);
+
+	virt_queue__set_used_elem(queue, head, len);
+
+	return true;
+}
+
+static bool virtio_ntf_do_echo_request(struct kvm *kvm, struct ntf_dev *ndev, struct virt_queue *queue)
+{
+	struct iovec iov[VIRTIO_NOTIFIER_QUEUE_SIZE];
+	u16 out, in, head;
+
+	sleep(1);
+	head = virt_queue__get_iov(queue, iov, &out, &in, kvm);
+	virt_queue__set_used_elem(queue, head, iov[0].iov_len);
+
+	return true;
+}
+
+static void virtio_ntf_do_io(struct kvm *kvm, void *param)
+{
+	struct ntf_dev_job *job	= param;
+	struct virt_queue *vq	= job->vq;
+	struct ntf_dev *ndev	= job->ndev;
+
+	if ((vq - ndev->vqs) == 0) {
+		while (virt_queue__available(vq))
+			virtio_ntf_do_io_request(kvm, ndev, vq);
+	} else {
+		virtio_ntf_do_echo_request(kvm, ndev, vq);
+	}
+
+	ndev->vdev.ops->signal_vq(kvm, &ndev->vdev, vq - ndev->vqs);
+}
+
+static int init_vq(struct kvm *kvm, void *dev, u32 vq, u32 pfn)
+{
+	struct ntf_dev *ndev = dev;
+	struct virt_queue *queue;
+	struct ntf_dev_job *job;
+	void *p;
+
+	compat__remove_message(compat_id);
+
+	queue		= &ndev->vqs[vq];
+	queue->pfn	= pfn;
+	p		= guest_pfn_to_host(kvm, queue->pfn);
+
+	job = &ndev->jobs[vq];
+
+	vring_init(&queue->vring, VIRTIO_NOTIFIER_QUEUE_SIZE, p, VIRTIO_PCI_VRING_ALIGN);
+
+	*job = (struct ntf_dev_job) {
+		.vq	= queue,
+		.ndev	= ndev,
+	};
+
+	thread_pool__init_job(&job->job_id, kvm, virtio_ntf_do_io, job);
+
+	return 0;
+}
+
+static int notify_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct ntf_dev *ndev = dev;
+
+	thread_pool__do_job(&ndev->jobs[vq].job_id);
+
+	return 0;
+}
+
+static int get_pfn_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	struct ntf_dev *ndev = dev;
+
+	return ndev->vqs[vq].pfn;
+}
+
+static int get_size_vq(struct kvm *kvm, void *dev, u32 vq)
+{
+	return VIRTIO_NOTIFIER_QUEUE_SIZE;
+}
+
+static struct virtio_ops ntf_dev_virtio_ops = (struct virtio_ops) {
+	.set_config		= set_config,
+	.get_config		= get_config,
+	.get_host_features	= get_host_features,
+	.set_guest_features	= set_guest_features,
+	.init_vq		= init_vq,
+	.notify_vq		= notify_vq,
+	.get_pfn_vq		= get_pfn_vq,
+	.get_size_vq		= get_size_vq,
+};
+
+int virtio_notif__init(struct kvm *kvm)
+{
+	struct ntf_dev *ndev;
+	int r;
+
+	ndev = malloc(sizeof(*ndev));
+	if (ndev == NULL)
+		return -ENOMEM;
+
+	r = virtio_init(kvm, ndev, &ndev->vdev, &ntf_dev_virtio_ops,
+			VIRTIO_PCI, PCI_DEVICE_ID_VIRTIO_NOTIFIER, VIRTIO_ID_NOTIFIER, PCI_CLASS_RNG);
+	if (r < 0)
+		goto cleanup;
+
+	list_add_tail(&ndev->list, &ndevs);
+
+	return 0;
+cleanup:
+	free(ndev);
+
+	return r;
+}
+
+int virtio_notif__exit(struct kvm *kvm)
+{
+	struct ntf_dev *ndev, *tmp;
+
+	list_for_each_entry_safe(ndev, tmp, &ndevs, list) {
+		list_del(&ndev->list);
+		ndev->vdev.ops->exit(kvm, &ndev->vdev);
+		free(ndev);
+	}
+
+	return 0;
+}
-- 
1.7.8.6

