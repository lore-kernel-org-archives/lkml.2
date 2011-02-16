Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933559Ab1BPAw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:52:27 -0500
Received: from kroah.org ([198.145.64.141]:52668 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab1BPAwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:52:14 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:21:16 2011
Message-Id: <20110216002116.319283887@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:22:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: [patch 173/176] drm/i915: Only bind to function 0 of the PCI device
In-Reply-To: <20110216002212.GA9246@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 5fe49d86f9d01044abf687a8cd21edef636d58aa upstream.

Early chipsets (gen2/3) used function 1 as a placeholder for multi-head.
We used to ignore these since they were not assigned to
PCI_CLASS_DISPLAY_VGA. However with 934f992c7 we attempt to bind to all
Intel PCI_CLASS_DISPLAY devices (and functions) to work in multi-gpu
systems. This fails hard on gen2/3.

Reported-by: Ferenc Wágner <wferi@niif.hu>
Tested-by: Ferenc Wágner <wferi@niif.hu>
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=28012
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_drv.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -414,6 +414,14 @@ int i965_reset(struct drm_device *dev, u
 static int __devinit
 i915_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
+	/* Only bind to function 0 of the device. Early generations
+	 * used function 1 as a placeholder for multi-head. This causes
+	 * us confusion instead, especially on the systems where both
+	 * functions have the same PCI-ID!
+	 */
+	if (PCI_FUNC(pdev->devfn))
+		return -ENODEV;
+
 	return drm_get_pci_dev(pdev, ent, &driver);
 }
 


