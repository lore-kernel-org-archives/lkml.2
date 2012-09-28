Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964876Ab2I1S44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:56:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862Ab2I1S4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:56:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [ 063/262] staging: comedi: amplc_pci224: Fix PCI ref count
Date: Fri, 28 Sep 2012 11:49:52 -0700
Message-Id: <20120928183005.393264140@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit cadf84bfeb80e216fde328d357fe856160157d2c upstream.

When attaching a PCI device manually via the comedi driver `attach` hook
(`pci224_attach()`) (called by the comedi core for the
`COMEDI_DEVCONFIG` ioctl), its reference count is incremented in the
`for_each_pci_dev` loop (in `pci224_find_pci_dev()`).  It is decremented
when the `detach` hook (`pci224_detach()`) is called to detach the
device.  However, when the PCI device is attached automatically via the
`attach_pci` hook (`pci224_attach_pci()`, called at probe time via
`comedi_pci_auto_config()`) it's reference count is not incremented so
there will be an unmatched decrement when detaching the device.

Increment the PCI device reference count in `pci224_attach_pci()` to
correct the mismatch.

Once support for manual configuration has been removed from this driver,
the calls to `pci_dev_get()` and `pci_dev_put()` can be removed.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/comedi/drivers/amplc_pci224.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/staging/comedi/drivers/amplc_pci224.c
+++ b/drivers/staging/comedi/drivers/amplc_pci224.c
@@ -1519,6 +1519,13 @@ pci224_attach_pci(struct comedi_device *
 		       dev->minor, DRIVER_NAME);
 		return -EINVAL;
 	}
+	/*
+	 * Need to 'get' the PCI device to match the 'put' in pci224_detach().
+	 * TODO: Remove the pci_dev_get() and matching pci_dev_put() once
+	 * support for manual attachment of PCI devices via pci224_attach()
+	 * has been removed.
+	 */
+	pci_dev_get(pci_dev);
 	return pci224_attach_common(dev, pci_dev, NULL);
 }
 


