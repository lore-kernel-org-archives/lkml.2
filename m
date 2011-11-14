Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab1KNXq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:46:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60458 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766Ab1KNXqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:46:25 -0500
From: Sasha Levin <levinsasha928@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mst@redhat.com, rusty@rustcorp.com.au,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        penberg@kernel.org, mingo@elte.hu,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [RFC 4/5] kvm tools: Free up the MSI-X PBA BAR
Date: Tue, 15 Nov 2011 01:43:16 +0200
Message-Id: <1321314197-5265-5-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1
In-Reply-To: <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
References: <20111114181854.GA24953@redhat.com>
 <1321314197-5265-1-git-send-email-levinsasha928@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Free up the BAR to make space for the new virtio BARs. It isn't required
to have the PBA and the table in the separate BARs, and uniting them will
just give us extra BARs to play with.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 tools/kvm/include/kvm/virtio-pci.h |    1 -
 tools/kvm/virtio/pci.c             |   35 ++++++++++++++---------------------
 2 files changed, 14 insertions(+), 22 deletions(-)

diff --git a/tools/kvm/include/kvm/virtio-pci.h b/tools/kvm/include/kvm/virtio-pci.h
index 2bbb271..73f7486 100644
--- a/tools/kvm/include/kvm/virtio-pci.h
+++ b/tools/kvm/include/kvm/virtio-pci.h
@@ -30,7 +30,6 @@ struct virtio_pci {
 	u32			vq_vector[VIRTIO_PCI_MAX_VQ];
 	u32			gsis[VIRTIO_PCI_MAX_VQ];
 	u32			msix_io_block;
-	u32			msix_pba_block;
 	u64			msix_pba;
 	struct msix_table	msix_table[VIRTIO_PCI_MAX_VQ + VIRTIO_PCI_MAX_CONFIG];
 
diff --git a/tools/kvm/virtio/pci.c b/tools/kvm/virtio/pci.c
index 1660f06..da38ba5 100644
--- a/tools/kvm/virtio/pci.c
+++ b/tools/kvm/virtio/pci.c
@@ -214,23 +214,21 @@ static struct ioport_operations virtio_pci__io_ops = {
 static void callback_mmio_table(u64 addr, u8 *data, u32 len, u8 is_write, void *ptr)
 {
 	struct virtio_pci *vpci = ptr;
-	void *table = &vpci->msix_table;
+	void *table;
+	u32 offset;
 
-	if (is_write)
-		memcpy(table + addr - vpci->msix_io_block, data, len);
-	else
-		memcpy(data, table + addr - vpci->msix_io_block, len);
-}
-
-static void callback_mmio_pba(u64 addr, u8 *data, u32 len, u8 is_write, void *ptr)
-{
-	struct virtio_pci *vpci = ptr;
-	void *pba = &vpci->msix_pba;
+	if (addr > vpci->msix_io_block + PCI_IO_SIZE) {
+		table	= &vpci->msix_pba;
+		offset	= vpci->msix_io_block + PCI_IO_SIZE;
+	} else {
+		table	= &vpci->msix_table;
+		offset	= vpci->msix_io_block;
+	}
 
 	if (is_write)
-		memcpy(pba + addr - vpci->msix_pba_block, data, len);
+		memcpy(table + addr - offset, data, len);
 	else
-		memcpy(data, pba + addr - vpci->msix_pba_block, len);
+		memcpy(data, table + addr - offset, len);
 }
 
 int virtio_pci__signal_vq(struct kvm *kvm, struct virtio_trans *vtrans, u32 vq)
@@ -283,12 +281,10 @@ int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
 	u8 pin, line, ndev;
 
 	vpci->dev = dev;
-	vpci->msix_io_block = pci_get_io_space_block(PCI_IO_SIZE);
-	vpci->msix_pba_block = pci_get_io_space_block(PCI_IO_SIZE);
+	vpci->msix_io_block = pci_get_io_space_block(PCI_IO_SIZE * 2);
 
 	vpci->base_addr = ioport__register(IOPORT_EMPTY, &virtio_pci__io_ops, IOPORT_SIZE, vtrans);
 	kvm__register_mmio(kvm, vpci->msix_io_block, 0x100, callback_mmio_table, vpci);
-	kvm__register_mmio(kvm, vpci->msix_pba_block, 0x100, callback_mmio_pba, vpci);
 
 	vpci->pci_hdr = (struct pci_device_header) {
 		.vendor_id		= PCI_VENDOR_ID_REDHAT_QUMRANET,
@@ -299,10 +295,7 @@ int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
 		.subsys_vendor_id	= PCI_SUBSYSTEM_VENDOR_ID_REDHAT_QUMRANET,
 		.subsys_id		= subsys_id,
 		.bar[0]			= vpci->base_addr | PCI_BASE_ADDRESS_SPACE_IO,
-		.bar[1]			= vpci->msix_io_block | PCI_BASE_ADDRESS_SPACE_MEMORY
-					| PCI_BASE_ADDRESS_MEM_TYPE_64,
-		.bar[3]			= vpci->msix_pba_block | PCI_BASE_ADDRESS_SPACE_MEMORY
-					| PCI_BASE_ADDRESS_MEM_TYPE_64,
+		.bar[1]			= vpci->msix_io_block | PCI_BASE_ADDRESS_SPACE_MEMORY,
 		.status			= PCI_STATUS_CAP_LIST,
 		.capabilities		= (void *)&vpci->pci_hdr.msix - (void *)&vpci->pci_hdr,
 	};
@@ -327,7 +320,7 @@ int virtio_pci__init(struct kvm *kvm, struct virtio_trans *vtrans, void *dev,
 	 * we're not in short of BARs
 	 */
 	vpci->pci_hdr.msix.table_offset = 1; /* Use BAR 1 */
-	vpci->pci_hdr.msix.pba_offset = 3; /* Use BAR 3 */
+	vpci->pci_hdr.msix.pba_offset = 1 | PCI_IO_SIZE; /* Use BAR 1 with offset */
 	vpci->config_vector = 0;
 
 	if (irq__register_device(subsys_id, &ndev, &pin, &line) < 0)
-- 
1.7.8.rc1

