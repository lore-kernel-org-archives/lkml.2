Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab2KPBW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 20:22:59 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:55334 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab2KPBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:22:58 -0500
MIME-Version: 1.0
Date: Fri, 16 Nov 2012 09:22:57 +0800
Message-ID: <CABawtvNrQ2wT49dns5gD-m_i4au5BiqQvpovSBEfD=1nbckC0g@mail.gmail.com>
Subject: [patch]mpt2sas/mpt2sas_base.c temporarily mask the corrected AER bit
 while driver initializing to suppress AER
From: Ethan Zhao <ethan.kernel@gmail.com>
To: DL-MPTFusionLinux@lsi.com
Cc: yinghai@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ethan.zhao@oracle.com
Content-Type: multipart/mixed; boundary=047d7bacc17096f3df04ce929bc8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--047d7bacc17096f3df04ce929bc8
Content-Type: text/plain; charset=ISO-8859-1

Hi, Lsi guys,

      On our servers (Sun fire X3-2/2L/2B, Sun fire X4-2/2L/2B ),
while loading mpt2sas driver, the _diag_reset action always triggers
correct AER,
So mask CRER bit before the reset action and restore it after
successful resetting.
      Please help to check the attached patch, I have tested with
upstream kernel 3.7RC4.

      Before applying the patch:

mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32836676 kB)
mpt2sas 0000:50:00.0: irq 106 for MSI/MSI-X
mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 106
mpt2sas0: iomem(0x00000000c7cc0000), mapped(0xffffc900144d8000), size(16384)
mpt2sas0: ioport(0x0000000000005000), size(256)
mpt2sas0: sending diag reset !!
pcieport 0000:00:03.2: AER: Corrected error received: id=001a
pcieport 0000:00:03.2: PCIe Bus Error: severity=Corrected, type=Physical
Layer, id=001a(Receiver ID)
pcieport 0000:00:03.2:   device [8086:3c0a] error
status/mask=00000001/00000000
pcieport 0000:00:03.2:    [ 0] Receiver Error
mpt2sas0: diag reset: SUCCESS
mpt2sas0: Allocated physical memory: size(2998 kB)
mpt2sas0: Current Controller Queue Depth(1331), Max Controller Queue
Depth(1408)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: LSISAS2008: FWVersion(11.05.02.00), ChipRevision(0x03),
BiosVersion(07.21.03.00)


      Applied the patch:


mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (32836676 kB)
mpt2sas 0000:50:00.0: irq 106 for MSI/MSI-X
mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 106
mpt2sas0: iomem(0x00000000c7cc0000), mapped(0xffffc900144d8000), size(16384)
mpt2sas0: ioport(0x0000000000005000), size(256)
mpt2sas0: sending diag reset !!
mpt2sas0: diag reset: SUCCESS
mpt2sas0: Allocated physical memory: size(2998 kB)
mpt2sas0: Current Controller Queue Depth(1331), Max Controller Queue
Depth(1408)
mpt2sas0: Scatter Gather Elements per IO(128)
mpt2sas0: LSISAS2008: FWVersion(11.05.02.00), ChipRevision(0x03),
BiosVersion(07.21.03.00)


Thanks,
Ethan
-------------------------------------------------------------------

>From 88f1ac6124678bbe45112ce070b62e709e7d72f7 Mon Sep 17 00:00:00 2001
From: ethan.zhao <ethan.kernel@gmail.com>
Date: Fri, 16 Nov 2012 04:14:48 -0800
Subject: [PATCH 643/643] On some system, reset action during
initializing will trigger multiple corrected AER,
 So mask corrected error before issue the reset and restore it after reset.
 Tested working with
  LSI Logic / Symbios Logic SAS2008 PCI-Expre ss Fusion-MPT SAS-2 [Falcon]
 and Sun X3-2/2L/2B Servers(SUN FIRE X4170/X4270 M3), Sun X4-2/2L/2B servers


Signed-off-by: ethan.zhao <ethan.kernel@gmail.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ffd85c5..ee54bb9 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3873,6 +3873,17 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc,
int sleep_flag)
 	u32 ioc_state;
 	u32 count;
 	u32 hcb_size;
+	struct pci_dev *us_dev = ioc->pdev->bus->self;
+	int pos = pci_pcie_cap(us_dev);
+	u16 devctl;
+	
+	/* On some system, reset action will trigger corrected AER,
+	 * So mask corrected error before issue the reset and enable it
+	 * after reset
+	 */
+	pci_read_config_word(us_dev, pos + PCI_EXP_DEVCTL, &devctl);
+	pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL,
+		(devctl & ~PCI_EXP_DEVCTL_CERE));

 	printk(MPT2SAS_INFO_FMT "sending diag reset !!\n", ioc->name);
 	drsprintk(ioc, printk(MPT2SAS_INFO_FMT "clear interrupts\n",
@@ -3971,6 +3982,7 @@ _base_diag_reset(struct MPT2SAS_ADAPTER *ioc,
int sleep_flag)
 	}

 	printk(MPT2SAS_INFO_FMT "diag reset: SUCCESS\n", ioc->name);
+	pci_write_config_word(us_dev, pos + PCI_EXP_DEVCTL, devctl);
 	return 0;

  out:
-- 
1.7.1

--047d7bacc17096f3df04ce929bc8
Content-Type: application/octet-stream; 
	name="0643-On-some-system-reset-action-during-initializing-will.patch"
Content-Disposition: attachment; 
	filename="0643-On-some-system-reset-action-during-initializing-will.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h9km5koj0

RnJvbSA4OGYxYWM2MTI0Njc4YmJlNDUxMTJjZTA3MGI2MmU3MDllN2Q3MmY3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBldGhhbi56aGFvIDxldGhhbi5rZXJuZWxAZ21haWwuY29tPgpE
YXRlOiBGcmksIDE2IE5vdiAyMDEyIDA0OjE0OjQ4IC0wODAwClN1YmplY3Q6IFtQQVRDSCA2NDMv
NjQzXSBPbiBzb21lIHN5c3RlbSwgcmVzZXQgYWN0aW9uIGR1cmluZyBpbml0aWFsaXppbmcgd2ls
bCB0cmlnZ2VyIG11bHRpcGxlIGNvcnJlY3RlZCBBRVIsCiBTbyBtYXNrIGNvcnJlY3RlZCBlcnJv
ciBiZWZvcmUgaXNzdWUgdGhlIHJlc2V0IGFuZCByZXN0b3JlIGl0IGFmdGVyIHJlc2V0LgogVGVz
dGVkIHdvcmtpbmcgd2l0aAogIExTSSBMb2dpYyAvIFN5bWJpb3MgTG9naWMgU0FTMjAwOCBQQ0kt
RXhwcmUgc3MgRnVzaW9uLU1QVCBTQVMtMiBbRmFsY29uXQogYW5kIFN1biBYMy0yLzJMLzJCIFNl
cnZlcnMoU1VOIEZJUkUgWDQxNzAvWDQyNzAgTTMpLCBTdW4gWDQtMi8yTC8yQiBzZXJ2ZXJzCgoK
U2lnbmVkLW9mZi1ieTogZXRoYW4uemhhbyA8ZXRoYW4ua2VybmVsQGdtYWlsLmNvbT4KLS0tCiBk
cml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2FzX2Jhc2UuYyB8ICAgMTIgKysrKysrKysrKysrCiAx
IGZpbGVzIGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zY3NpL21wdDJzYXMvbXB0MnNhc19iYXNlLmMgYi9kcml2ZXJzL3Njc2kv
bXB0MnNhcy9tcHQyc2FzX2Jhc2UuYwppbmRleCBmZmQ4NWM1Li5lZTU0YmI5IDEwMDY0NAotLS0g
YS9kcml2ZXJzL3Njc2kvbXB0MnNhcy9tcHQyc2FzX2Jhc2UuYworKysgYi9kcml2ZXJzL3Njc2kv
bXB0MnNhcy9tcHQyc2FzX2Jhc2UuYwpAQCAtMzg3Myw2ICszODczLDE3IEBAIF9iYXNlX2RpYWdf
cmVzZXQoc3RydWN0IE1QVDJTQVNfQURBUFRFUiAqaW9jLCBpbnQgc2xlZXBfZmxhZykKIAl1MzIg
aW9jX3N0YXRlOwogCXUzMiBjb3VudDsKIAl1MzIgaGNiX3NpemU7CisJc3RydWN0IHBjaV9kZXYg
KnVzX2RldiA9IGlvYy0+cGRldi0+YnVzLT5zZWxmOworCWludCBwb3MgPSBwY2lfcGNpZV9jYXAo
dXNfZGV2KTsKKwl1MTYgZGV2Y3RsOworCQorCS8qIE9uIHNvbWUgc3lzdGVtLCByZXNldCBhY3Rp
b24gd2lsbCB0cmlnZ2VyIGNvcnJlY3RlZCBBRVIsIAorCSAqIFNvIG1hc2sgY29ycmVjdGVkIGVy
cm9yIGJlZm9yZSBpc3N1ZSB0aGUgcmVzZXQgYW5kIGVuYWJsZSBpdCAKKwkgKiBhZnRlciByZXNl
dAorCSAqLworCXBjaV9yZWFkX2NvbmZpZ193b3JkKHVzX2RldiwgcG9zICsgUENJX0VYUF9ERVZD
VEwsICZkZXZjdGwpOworCXBjaV93cml0ZV9jb25maWdfd29yZCh1c19kZXYsIHBvcyArIFBDSV9F
WFBfREVWQ1RMLAorCQkoZGV2Y3RsICYgflBDSV9FWFBfREVWQ1RMX0NFUkUpKTsKIAogCXByaW50
ayhNUFQyU0FTX0lORk9fRk1UICJzZW5kaW5nIGRpYWcgcmVzZXQgISFcbiIsIGlvYy0+bmFtZSk7
CiAJZHJzcHJpbnRrKGlvYywgcHJpbnRrKE1QVDJTQVNfSU5GT19GTVQgImNsZWFyIGludGVycnVw
dHNcbiIsCkBAIC0zOTcxLDYgKzM5ODIsNyBAQCBfYmFzZV9kaWFnX3Jlc2V0KHN0cnVjdCBNUFQy
U0FTX0FEQVBURVIgKmlvYywgaW50IHNsZWVwX2ZsYWcpCiAJfQogCiAJcHJpbnRrKE1QVDJTQVNf
SU5GT19GTVQgImRpYWcgcmVzZXQ6IFNVQ0NFU1NcbiIsIGlvYy0+bmFtZSk7CisJcGNpX3dyaXRl
X2NvbmZpZ193b3JkKHVzX2RldiwgcG9zICsgUENJX0VYUF9ERVZDVEwsIGRldmN0bCk7CiAJcmV0
dXJuIDA7CiAKICBvdXQ6Ci0tIAoxLjcuMQoK
--047d7bacc17096f3df04ce929bc8--
