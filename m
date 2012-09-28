Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945957Ab2I1U5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:57:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56628 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422971Ab2I1UsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:48:08 -0400
X-Sasl-enc: xb27oIz8aHJZpO2VkjAjUJhoJ5xSAz/vy7wh5BtpWeMj 1348865288
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Matthew Garrett <mjg@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 080/127] xhci: Make handover code more robust
Date: Fri, 28 Sep 2012 13:34:13 -0700
Message-Id: <20120928203055.246152963@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit e955a1cd086de4d165ae0f4c7be7289d84b63bdc upstream.

My test platform (Intel DX79SI) boots reliably under BIOS, but frequently
crashes when booting via UEFI. I finally tracked this down to the xhci
handoff code. It seems that reads from the device occasionally just return
0xff, resulting in xhci_find_next_cap_offset generating a value that's
larger than the resource region. We then oops when attempting to read the
value. Sanity checking that value lets us avoid the crash.

I've no idea what's causing the underlying problem, and xhci still doesn't
actually *work* even with this, but the machine at least boots which will
probably make further debugging easier.

This should be backported to kernels as old as 2.6.31, that contain the
commit 66d4eadd8d067269ea8fead1a50fe87c2979a80d "USB: xhci: BIOS handoff
and HW initialization."

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/pci-quirks.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -839,12 +839,12 @@ static void __devinit quirk_usb_handoff_
 	void __iomem *op_reg_base;
 	u32 val;
 	int timeout;
+	int len = pci_resource_len(pdev, 0);
 
 	if (!mmio_resource_enabled(pdev, 0))
 		return;
 
-	base = ioremap_nocache(pci_resource_start(pdev, 0),
-				pci_resource_len(pdev, 0));
+	base = ioremap_nocache(pci_resource_start(pdev, 0), len);
 	if (base == NULL)
 		return;
 
@@ -854,9 +854,17 @@ static void __devinit quirk_usb_handoff_
 	 */
 	ext_cap_offset = xhci_find_next_cap_offset(base, XHCI_HCC_PARAMS_OFFSET);
 	do {
+		if ((ext_cap_offset + sizeof(val)) > len) {
+			/* We're reading garbage from the controller */
+			dev_warn(&pdev->dev,
+				 "xHCI controller failing to respond");
+			return;
+		}
+
 		if (!ext_cap_offset)
 			/* We've reached the end of the extended capabilities */
 			goto hc_init;
+
 		val = readl(base + ext_cap_offset);
 		if (XHCI_EXT_CAPS_ID(val) == XHCI_EXT_CAPS_LEGACY)
 			break;


