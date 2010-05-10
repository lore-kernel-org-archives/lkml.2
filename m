Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757737Ab0EJXNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:13:15 -0400
Received: from kroah.org ([198.145.64.141]:45322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923Ab0EJW6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:25 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:41 2010
Message-Id: <20100510223541.063022214@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Chiang <achiang@canonical.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg@redhat.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [74/98] PCI: Ensure we re-enable devices on resume
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Garrett <mjg@redhat.com>

commit cc2893b6af5265baa1d68b17b136cffca9e40cfa upstream.

If the firmware puts a device back into D0 state at resume time, we'll
update its state in resume_noirq and thus skip the platform resume code.
Calling that code twice should be safe and we ought to avoid getting to
that point anyway, so remove the check and also allow the platform pci
code to be called for D0.

Fixes USB not being powered after resume on recent Lenovo machines.

Acked-by: Alex Chiang <achiang@canonical.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -601,7 +601,7 @@ static void __pci_start_power_transition
  */
 int __pci_complete_power_transition(struct pci_dev *dev, pci_power_t state)
 {
-	return state > PCI_D0 ?
+	return state >= PCI_D0 ?
 			pci_platform_power_transition(dev, state) : -EINVAL;
 }
 EXPORT_SYMBOL_GPL(__pci_complete_power_transition);
@@ -638,10 +638,6 @@ int pci_set_power_state(struct pci_dev *
 		 */
 		return 0;
 
-	/* Check if we're already there */
-	if (dev->current_state == state)
-		return 0;
-
 	__pci_start_power_transition(dev, state);
 
 	/* This device is quirked not to be put into D3, so


