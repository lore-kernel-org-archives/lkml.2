Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489Ab2DBOc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:32:26 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:56005 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2DBOc0 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 2 Apr 2012 10:32:26 -0400
Message-Id: <4F79D496020000780007C05B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Mon, 02 Apr 2012 15:32:22 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen/pciback: fix XEN_PCI_OP_enable_msix result
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prior to 2.6.19 and as of 2.6.31, pci_enable_msix() can return a
positive value to indicate the number of vectors (less than the amount
requested) that can be set up for a given device. Returning this as an
operation value (secondary result) is fine, but (primary) operation
results are expected to be negative (error) or zero (success) according
to the protocol. With the frontend fixed to match the XenoLinux
behavior, the backend can now validly return zero (success) here,
passing the upper limit on the number of vectors in op->value.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xen-pciback/pciback_ops.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 3.4-rc1/drivers/xen/xen-pciback/pciback_ops.c
+++ 3.4-rc1-xen-pciback-msix-retval/drivers/xen/xen-pciback/pciback_ops.c
@@ -234,7 +234,7 @@ int xen_pcibk_enable_msix(struct xen_pci
 	if (dev_data)
 		dev_data->ack_intr = 0;
 
-	return result;
+	return result > 0 ? 0 : result;
 }
 
 static



