Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1FOVr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 17:47:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39249 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754883Ab1FOVrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 17:47:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type;
        b=gDiFogmScut1qFYQDEZm9undQxT6AryIdaesRJLwecpjO8RtaJe/2zBUob5vFPfp82
         kO8px2Ul7sIYv6FJs3c7c5Cu75bGLYmwDsr8HD5jOEObtmlPGJ5jglN2moNV9cov+fb7
         deo4MLNbxqqzX7/3L8R4/g5GHw69A5r3tEcU4=
Message-ID: <4DF92869.50105@gmail.com>
Date: Wed, 15 Jun 2011 23:47:21 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH v2] xhci: Add reset on resume quirk for asrock p67 host
Content-Type: multipart/mixed;
 boundary="------------010406020907000809020702"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010406020907000809020702
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

The asrock p67 xhci controller completely dies on resume, add a
quirk for this, to bring the host back online after a suspend.

This should be backported to stable kernels up until 2.6.37.

Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: stable@kernel.org
---
V2: Fix inversed logic, and correct kernel version

diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 17541d0..cb16de2 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -29,6 +29,9 @@
 #define PCI_VENDOR_ID_FRESCO_LOGIC	0x1b73
 #define PCI_DEVICE_ID_FRESCO_LOGIC_PDK	0x1000
 
+#define PCI_VENDOR_ID_ETRON		0x1b6f
+#define PCI_DEVICE_ID_ASROCK_P67	0x7023
+
 static const char hcd_name[] = "xhci_hcd";
 
 /* called after powerup, by probe or system-pm "wakeup" */
@@ -134,6 +137,11 @@ static int xhci_pci_setup(struct usb_hcd *hcd)
 		xhci->quirks |= XHCI_EP_LIMIT_QUIRK;
 		xhci->limit_active_eps = 64;
 	}
+	if (pdev->vendor == PCI_VENDOR_ID_ETRON &&
+			pdev->device == PCI_DEVICE_ID_ASROCK_P67) {
+		xhci->quirks |= XHCI_RESET_ON_RESUME;
+		xhci_dbg(xhci, "QUIRK: Resetting on resume\n");
+	}
 
 	/* Make sure the HC is halted. */
 	retval = xhci_halt(xhci);
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 06e7023..17a0a08 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -759,6 +759,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		msleep(100);
 
 	spin_lock_irq(&xhci->lock);
+	if (xhci->quirks & XHCI_RESET_ON_RESUME)
+		hibernated = true;
 
 	if (!hibernated) {
 		/* step 1: restore register */
diff --git a/drivers/usb/host/xhci.h b/drivers/usb/host/xhci.h
index 7d1ea3b..b769a75 100644
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -1308,6 +1308,7 @@ struct xhci_hcd {
  */
 #define XHCI_EP_LIMIT_QUIRK	(1 << 5)
 #define XHCI_BROKEN_MSI		(1 << 6)
+#define XHCI_RESET_ON_RESUME	(1 << 7)
 	unsigned int		num_active_eps;
 	unsigned int		limit_active_eps;
 	/* There are two roothubs to keep track of bus suspend info for */



--------------010406020907000809020702
Content-Type: application/mbox;
 name="xhci.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="xhci.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS1wY2kuYyBiL2RyaXZlcnMvdXNi
L2hvc3QveGhjaS1wY2kuYwppbmRleCAxNzU0MWQwLi5jYjE2ZGUyIDEwMDY0NAotLS0gYS9k
cml2ZXJzL3VzYi9ob3N0L3hoY2ktcGNpLmMKKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNp
LXBjaS5jCkBAIC0yOSw2ICsyOSw5IEBACiAjZGVmaW5lIFBDSV9WRU5ET1JfSURfRlJFU0NP
X0xPR0lDCTB4MWI3MwogI2RlZmluZSBQQ0lfREVWSUNFX0lEX0ZSRVNDT19MT0dJQ19QREsJ
MHgxMDAwCiAKKyNkZWZpbmUgUENJX1ZFTkRPUl9JRF9FVFJPTgkJMHgxYjZmCisjZGVmaW5l
IFBDSV9ERVZJQ0VfSURfQVNST0NLX1A2NwkweDcwMjMKKwogc3RhdGljIGNvbnN0IGNoYXIg
aGNkX25hbWVbXSA9ICJ4aGNpX2hjZCI7CiAKIC8qIGNhbGxlZCBhZnRlciBwb3dlcnVwLCBi
eSBwcm9iZSBvciBzeXN0ZW0tcG0gIndha2V1cCIgKi8KQEAgLTEzNCw2ICsxMzcsMTEgQEAg
c3RhdGljIGludCB4aGNpX3BjaV9zZXR1cChzdHJ1Y3QgdXNiX2hjZCAqaGNkKQogCQl4aGNp
LT5xdWlya3MgfD0gWEhDSV9FUF9MSU1JVF9RVUlSSzsKIAkJeGhjaS0+bGltaXRfYWN0aXZl
X2VwcyA9IDY0OwogCX0KKwlpZiAocGRldi0+dmVuZG9yID09IFBDSV9WRU5ET1JfSURfRVRS
T04gJiYKKwkJCXBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0FTUk9DS19QNjcpIHsK
KwkJeGhjaS0+cXVpcmtzIHw9IFhIQ0lfUkVTRVRfT05fUkVTVU1FOworCQl4aGNpX2RiZyh4
aGNpLCAiUVVJUks6IFJlc2V0dGluZyBvbiByZXN1bWVcbiIpOworCX0KIAogCS8qIE1ha2Ug
c3VyZSB0aGUgSEMgaXMgaGFsdGVkLiAqLwogCXJldHZhbCA9IHhoY2lfaGFsdCh4aGNpKTsK
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhjaS5jIGIvZHJpdmVycy91c2IvaG9z
dC94aGNpLmMKaW5kZXggMDZlNzAyMy4uMTdhMGEwOCAxMDA2NDQKLS0tIGEvZHJpdmVycy91
c2IvaG9zdC94aGNpLmMKKysrIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmMKQEAgLTc1OSw2
ICs3NTksOCBAQCBpbnQgeGhjaV9yZXN1bWUoc3RydWN0IHhoY2lfaGNkICp4aGNpLCBib29s
IGhpYmVybmF0ZWQpCiAJCW1zbGVlcCgxMDApOwogCiAJc3Bpbl9sb2NrX2lycSgmeGhjaS0+
bG9jayk7CisJaWYgKHhoY2ktPnF1aXJrcyAmIFhIQ0lfUkVTRVRfT05fUkVTVU1FKQorCQlo
aWJlcm5hdGVkID0gdHJ1ZTsKIAogCWlmICghaGliZXJuYXRlZCkgewogCQkvKiBzdGVwIDE6
IHJlc3RvcmUgcmVnaXN0ZXIgKi8KZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2hvc3QveGhj
aS5oIGIvZHJpdmVycy91c2IvaG9zdC94aGNpLmgKaW5kZXggN2QxZWEzYi4uYjc2OWE3NSAx
MDA2NDQKLS0tIGEvZHJpdmVycy91c2IvaG9zdC94aGNpLmgKKysrIGIvZHJpdmVycy91c2Iv
aG9zdC94aGNpLmgKQEAgLTEzMDgsNiArMTMwOCw3IEBAIHN0cnVjdCB4aGNpX2hjZCB7CiAg
Ki8KICNkZWZpbmUgWEhDSV9FUF9MSU1JVF9RVUlSSwkoMSA8PCA1KQogI2RlZmluZSBYSENJ
X0JST0tFTl9NU0kJCSgxIDw8IDYpCisjZGVmaW5lIFhIQ0lfUkVTRVRfT05fUkVTVU1FCSgx
IDw8IDcpCiAJdW5zaWduZWQgaW50CQludW1fYWN0aXZlX2VwczsKIAl1bnNpZ25lZCBpbnQJ
CWxpbWl0X2FjdGl2ZV9lcHM7CiAJLyogVGhlcmUgYXJlIHR3byByb290aHVicyB0byBrZWVw
IHRyYWNrIG9mIGJ1cyBzdXNwZW5kIGluZm8gZm9yICovCg==
--------------010406020907000809020702--
