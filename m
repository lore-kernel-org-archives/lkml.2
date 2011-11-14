Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1KNXqe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:46:34 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab1KNXq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:46:27 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        penberg@kernel.org, mingo@elte.hu,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 5/5] kvm tools: Support new virtio-pci configuration layout
Date: Tue, 15 Nov 2011 01:43:17 +0200
Message-Id: <1321314197-5265-6-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
In-Reply-To: <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
References: <20111114181854.GA24953@redhat.com>
 <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 tools/kvm/include/kvm/pci.h        |   13 ++-
 tools/kvm/include/kvm/virtio-pci.h |    4 +
 tools/kvm/virtio/pci.c             |  248 ++++++++++++++++++++++++++++++++++--
 3 files changed, 254 insertions(+), 11 deletions(-)

diff --git a/tools/kvm/include/kvm/pci.h b/tools/kvm/include/kvm/pci.h
index f71af0b..4f5a09f 100644
--- a/tools/kvm/include/kvm/pci.h
+++ b/tools/kvm/include/kvm/pci.h
@@ -39,6 +39,16 @@ struct msix_cap {
 	u32 pba_offset;
 };
 
+struct virtio_cap {
+	u8 cap;
+	u8 next;
+	u8 cap_len;
+	u8 structure_id;
+	u8 bir;
+	u32 size:24;
+	u32 offset;
+};
+
 struct pci_device_header {
 	u16		vendor_id;
 	u16		device_id;
@@ -63,7 +73,8 @@ struct pci_device_header {
 	u8		min_gnt;
 	u8		max_lat;
 	struct msix_cap msix;
-	u8		empty[136]; /* Rest of PCI config space */
+	struct virtio_cap virtio[4];
+	u8		empty[90]; /* Rest of PCI config space */
 	u32		bar_size[6];
 };
 
diff --git a/tools/kvm/include/kvm/virtio-pci.h b/tools/kvm/include/kvm/virtio-pci.h
index 73f7486..fc3c03f 100644
--- a/tools/kvm/include/kvm/virtio-pci.h
+++ b/tools/kvm/include/kvm/virtio-pci.h
@@ -19,6 +19,7 @@ struct virtio_pci_ioevent_param {
 struct virtio_pci {
 	struct pci_device_header pci_hdr;
 	void			*dev;
+	struct kvm		*kvm;
 
 	u16			base_addr;
 	u8			status;
@@ -36,6 +37,9 @@ struct virtio_pci {
 	/* virtio queue */
 	u16			queue_selector;
 	struct virtio_pci_ioevent_param ioeventfds[VIRTIO_PCI_MAX_VQ];
+
+	u32			virtio_mmio;
+	u16			virtio_pio;
 };
 
 int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
diff --git a/tools/kvm/virtio/pci.c b/tools/kvm/virtio/pci.c
index da38ba5..8606d87 100644
--- a/tools/kvm/virtio/pci.c
+++ b/tools/kvm/virtio/pci.c
@@ -40,7 +40,7 @@ static int virtio_pci__init_ioeventfd(struct kvm *kvm, struct virtio_trans *vtra
 	};
 
 	ioevent = (struct ioevent) {
-		.io_addr	= vpci->base_addr + VIRTIO_PCI_QUEUE_NOTIFY,
+		.io_addr	= vpci->virtio_pio,
 		.io_len		= sizeof(u16),
 		.fn		= virtio_pci__ioevent_callback,
 		.fn_ptr		= &vpci->ioeventfds[vq],
@@ -59,7 +59,7 @@ static inline bool virtio_pci__msix_enabled(struct virtio_pci *vpci)
 	return vpci->pci_hdr.msix.ctrl & PCI_MSIX_FLAGS_ENABLE;
 }
 
-static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_trans *vtrans, u16 port,
+static bool virtio_pci_legacy__specific_io_in(struct kvm *kvm, struct virtio_trans *vtrans, u16 port,
 					void *data, int size, int offset)
 {
 	u32 config_offset;
@@ -89,7 +89,8 @@ static bool virtio_pci__specific_io_in(struct kvm *kvm, struct virtio_trans *vtr
 	return false;
 }
 
-static bool virtio_pci__io_in(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
+static bool virtio_pci_legacy__io_in(struct ioport *ioport, struct kvm *kvm,
+					u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
@@ -124,15 +125,15 @@ static bool virtio_pci__io_in(struct ioport *ioport, struct kvm *kvm, u16 port,
 		vpci->isr = VIRTIO_IRQ_LOW;
 		break;
 	default:
-		ret = virtio_pci__specific_io_in(kvm, vtrans, port, data, size, offset);
+		ret = virtio_pci_legacy__specific_io_in(kvm, vtrans, port, data, size, offset);
 		break;
 	};
 
 	return ret;
 }
 
-static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_trans *vtrans, u16 port,
-					void *data, int size, int offset)
+static bool virtio_pci_legacy__specific_io_out(struct kvm *kvm, struct virtio_trans *vtrans,
+					u16 port, void *data, int size, int offset)
 {
 	struct virtio_pci *vpci = vtrans->virtio;
 	u32 config_offset, gsi, vec;
@@ -166,7 +167,8 @@ static bool virtio_pci__specific_io_out(struct kvm *kvm, struct virtio_trans *vt
 	return false;
 }
 
-static bool virtio_pci__io_out(struct ioport *ioport, struct kvm *kvm, u16 port, void *data, int size)
+static bool virtio_pci_legacy__io_out(struct ioport *ioport,
+				struct kvm *kvm, u16 port, void *data, int size)
 {
 	unsigned long offset;
 	bool ret = true;
@@ -199,7 +201,76 @@ static bool virtio_pci__io_out(struct ioport *ioport, struct kvm *kvm, u16 port,
 		vpci->status		= ioport__read8(data);
 		break;
 	default:
-		ret = virtio_pci__specific_io_out(kvm, vtrans, port, data, size, offset);
+		ret = virtio_pci_legacy__specific_io_out(kvm, vtrans, port,
+							data, size, offset);
+		break;
+	};
+
+	return ret;
+}
+
+static struct ioport_operations virtio_pci_legacy__io_ops = {
+	.io_in	= virtio_pci_legacy__io_in,
+	.io_out	= virtio_pci_legacy__io_out,
+};
+
+static bool virtio_pci__io_out(struct ioport *ioport,
+				struct kvm *kvm, u16 port, void *data, int size)
+{
+	unsigned long offset;
+	bool ret = true;
+	u16 val;
+	struct virtio_pci *vpci;
+	struct virtio_trans *vtrans;
+
+	vtrans = ioport->priv;
+	vpci = vtrans->virtio;
+	offset = port - vpci->virtio_pio;
+
+	/*
+	 * 0-1: Notifications
+	 * 2: ISR
+	 */
+	switch (offset) {
+	case 0:
+		val		= ioport__read16(data);
+		vtrans->virtio_ops->notify_vq(kvm, vpci->dev, val);
+		break;
+	case 2:
+		vpci->isr	= ioport__read8(data);
+		break;
+	default:
+		ret = false;
+		break;
+	}
+
+	return ret;
+}
+
+static bool virtio_pci__io_in(struct ioport *ioport, struct kvm *kvm,
+					u16 port, void *data, int size)
+{
+	unsigned long offset;
+	bool ret = true;
+	struct virtio_pci *vpci;
+
+	vpci = ioport->priv;
+	offset = port - vpci->virtio_pio;
+
+	/*
+	 * 0-1: Notifications
+	 * 2: ISR
+	 */
+	switch (offset) {
+	case 0:
+		/* Shouldn't happen */
+	case 2:
+		ioport__write8(data, vpci->isr);
+		kvm__irq_line(kvm, vpci->pci_hdr.irq_line, VIRTIO_IRQ_LOW);
+		vpci->isr = VIRTIO_IRQ_LOW;
+		break;
+	default:
+		ret = false;
 		break;
 	};
 
@@ -231,6 +302,113 @@ static void callback_mmio_table(u64 addr, u8 *data, u32 len, u8 is_write, void *
 		memcpy(data, table + addr - offset, len);
 }
 
+static void virtio_mmio_dev_specific(u64 addr, u8 *data, u32 len, u8 is_write,
+					struct virtio_trans *vtrans)
+{
+	struct virtio_pci *vpci = vtrans->virtio;
+	u32 i;
+
+	for (i = 0; i < len; i++) {
+		if (is_write)
+			vtrans->virtio_ops->set_config(vpci->kvm, vpci->dev,
+							*(u8 *)data + i, addr + i);
+		else
+			data[i] =
+				vtrans->virtio_ops->get_config(vpci->kvm, vpci->dev, addr + i);
+	}
+}
+
+static void virtio_mmio_in(u64 addr, u8 *data, u32 len, u8 is_write,
+					struct virtio_trans *vtrans)
+{
+	struct virtio_pci *vpci = vtrans->virtio;
+
+	switch (addr) {
+	case VIRTIO_PCI_HOST_FEATURES:
+		*(u32 *)data  = vtrans->virtio_ops->get_host_features(vpci->kvm, vpci->dev);
+		break;
+	case VIRTIO_PCI_QUEUE_PFN:
+		*(u32 *)data  = vtrans->virtio_ops->get_pfn_vq(vpci->kvm,
+							vpci->dev, vpci->queue_selector);
+		break;
+	case VIRTIO_PCI_QUEUE_NUM:
+		*(u32 *)data  = vtrans->virtio_ops->get_size_vq(vpci->kvm,
+							vpci->dev, vpci->queue_selector);
+		break;
+	case VIRTIO_PCI_STATUS:
+		*(u8 *)data  = vpci->status;
+		break;
+	case VIRTIO_MSI_CONFIG_VECTOR:
+		*(u8 *)data  = vpci->config_vector;
+		break;
+	case VIRTIO_MSI_QUEUE_VECTOR:
+		*(u8 *)data = vpci->vq_vector[vpci->queue_selector];
+		break;
+	};
+}
+
+static void virtio_mmio_out(u64 addr, u8 *data, u32 len, u8 is_write,
+					struct virtio_trans *vtrans)
+{
+	struct virtio_pci *vpci = vtrans->virtio;
+	u32 val;
+
+	switch (addr) {
+	case VIRTIO_PCI_GUEST_FEATURES:
+		val = *(u32 *)data;
+		vtrans->virtio_ops->set_guest_features(vpci->kvm, vpci, val);
+		break;
+	case VIRTIO_PCI_QUEUE_PFN:
+		val = *(u32 *)data;
+		virtio_pci__init_ioeventfd(vpci->kvm, vtrans, vpci->queue_selector);
+		vtrans->virtio_ops->init_vq(vpci->kvm, vpci->dev, vpci->queue_selector, val);
+		break;
+	case VIRTIO_PCI_QUEUE_SEL:
+		vpci->queue_selector	= *(u16 *)data;
+		break;
+	case VIRTIO_PCI_QUEUE_NOTIFY:
+		val			= *(u16 *)data;
+		vtrans->virtio_ops->notify_vq(vpci->kvm, vpci->dev, val);
+		break;
+	case VIRTIO_PCI_STATUS:
+		vpci->status		= *(u8 *)data;
+		break;
+	case VIRTIO_MSI_CONFIG_VECTOR: {
+		u16 vec, gsi;
+
+		vec = *(u16 *)data;
+		gsi = irq__add_msix_route(vpci->kvm, &vpci->msix_table[vec].msg);
+		vpci->config_gsi = gsi;
+		break;
+	}
+	case VIRTIO_MSI_QUEUE_VECTOR: {
+		u16 vec, gsi;
+
+		vec = vpci->vq_vector[vpci->queue_selector] = *(u16 *)data;
+		gsi = irq__add_msix_route(vpci->kvm, &vpci->msix_table[vec].msg);
+		vpci->gsis[vpci->queue_selector] = gsi;
+		break;
+	}
+	};
+}
+
+static void callback_virtio_mmio(u64 addr, u8 *data, u32 len, u8 is_write, void *ptr)
+{
+	struct virtio_trans *vtrans = ptr;
+	struct virtio_pci *vpci = vtrans->virtio;
+	u32 offset = addr - vpci->virtio_mmio;
+
+	if (offset >= 0x100) {
+		virtio_mmio_dev_specific(offset - 0x100, data, len, is_write, vtrans);
+		return;
+	}
+
+	if (is_write == 0)
+		virtio_mmio_in(offset, data, len, is_write, vtrans);
+	else
+		virtio_mmio_out(offset, data, len, is_write, vtrans);
+}
+
 int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_trans *vtrans, u32 vq)
 {
 	struct virtio_pci *vpci = vtrans->virtio;
@@ -282,10 +460,16 @@ int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
 
 	vpci->dev = dev;
 	vpci->msix_io_block = pci_get_io_space_block(PCI_IO_SIZE * 2);
+	vpci->virtio_mmio = pci_get_io_space_block(PCI_IO_SIZE * 2);
 
-	vpci->base_addr = ioport__register(IOPORT_EMPTY, &virtio_pci__io_ops, IOPORT_SIZE, vtrans);
+	vpci->base_addr = ioport__register(IOPORT_EMPTY,
+				&virtio_pci_legacy__io_ops, IOPORT_SIZE, vtrans);
+	vpci->virtio_pio = ioport__register(IOPORT_EMPTY,
+				&virtio_pci__io_ops, IOPORT_SIZE, vtrans);
 	kvm__register_mmio(kvm, vpci->msix_io_block, 0x100, callback_mmio_table, vpci);
+	kvm__register_mmio(kvm, vpci->virtio_mmio, 0x200, callback_virtio_mmio, vtrans);
 
+	vpci->kvm = kvm;
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= PCI_VENDOR_ID_REDHAT_QUMRANET,
 		.device_id		= device_id,
@@ -296,12 +480,16 @@ int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
 		.subsys_id		= subsys_id,
 		.bar[0]			= vpci->base_addr | PCI_BASE_ADDRESS_SPACE_IO,
 		.bar[1]			= vpci->msix_io_block | PCI_BASE_ADDRESS_SPACE_MEMORY,
+		.bar[2]			= vpci->virtio_mmio | PCI_BASE_ADDRESS_SPACE_MEMORY,
+		.bar_size[2]		= PCI_IO_SIZE * 2,
+		.bar[3]			= vpci->virtio_pio | PCI_BASE_ADDRESS_SPACE_IO,
+		.bar_size[3]		= PCI_IO_SIZE * 2,
 		.status			= PCI_STATUS_CAP_LIST,
 		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
 	};
 
 	vpci->pci_hdr.msix.cap = PCI_CAP_ID_MSIX;
-	vpci->pci_hdr.msix.next = 0;
+	vpci->pci_hdr.msix.next = (void *)&vpci->pci_hdr.virtio[0] - (void *)&vpci->pci_hdr;
 	/*
 	 * We at most have VIRTIO_PCI_MAX_VQ entries for virt queue,
 	 * VIRTIO_PCI_MAX_CONFIG entries for config.
@@ -321,6 +509,46 @@ int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
 	 */
 	vpci->pci_hdr.msix.table_offset = 1; /* Use BAR 1 */
 	vpci->pci_hdr.msix.pba_offset = 1 | PCI_IO_SIZE; /* Use BAR 1 with offset */
+
+	vpci->pci_hdr.virtio[0] = (struct virtio_cap) {
+		.cap = PCI_CAP_ID_VNDR,
+		.next = (void *)&vpci->pci_hdr.virtio[1] - (void *)&vpci->pci_hdr,
+		.cap_len = sizeof(struct virtio_cap),
+		.structure_id = VIRTIO_PCI_CAP_COMMON_CFG,
+		.bir = 2,
+		.size = PCI_IO_SIZE,
+		.offset = 0,
+	};
+
+	vpci->pci_hdr.virtio[1] = (struct virtio_cap) {
+		.cap = PCI_CAP_ID_VNDR,
+		.next = (void *)&vpci->pci_hdr.virtio[2] - (void *)&vpci->pci_hdr,
+		.cap_len = sizeof(struct virtio_cap),
+		.structure_id = VIRTIO_PCI_CAP_ISR_CFG,
+		.bir = 3,
+		.size = 1,
+		.offset = 2,
+	};
+
+	vpci->pci_hdr.virtio[2] = (struct virtio_cap) {
+		.cap = PCI_CAP_ID_VNDR,
+		.next = (void *)&vpci->pci_hdr.virtio[3] - (void *)&vpci->pci_hdr,
+		.cap_len = sizeof(struct virtio_cap),
+		.structure_id = VIRTIO_PCI_CAP_NOTIFY_CFG,
+		.bir = 3,
+		.size = 2,
+		.offset = 0,
+	};
+
+	vpci->pci_hdr.virtio[3] = (struct virtio_cap) {
+		.cap = PCI_CAP_ID_VNDR,
+		.next = 0,
+		.cap_len = sizeof(struct virtio_cap),
+		.structure_id = VIRTIO_PCI_CAP_DEVICE_CFG,
+		.bir = 2,
+		.size = PCI_IO_SIZE,
+		.offset = PCI_IO_SIZE,
+	};
 	vpci->config_vector = 0;
 
 	if (irq__register_device(subsys_id, &ndev, &pin, &line) < 0)
-- 
1.7.8.rc1

