Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1GHFGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 01:06:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755494Ab1GHFGQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 01:06:16 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Jul  7 17:17:02 2011
Message-Id: <20110708001702.920199025@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 07 Jul 2011 17:17:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, greg@kroah.com
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, avi@redhat.com,
        mtosatti@redhat.com, Alex Williamson <alex.williamson@redhat.com>,
        "Acked-by: Jan Kiszka" <jan.kiszka@siemens.com>
Subject: [105/107] Revert "KVM: Save/restore state of assigned PCI device"
In-Reply-To: <20110708001740.GA14031@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

This reverts ed78661f2614d3c9f69c23e280db3bafdabdf5bb as it assumes
the saved PCI state will remain valid for the entire length of time
that it is attached to a guest.  This fails when userspace makes use
of the pci-sysfs reset interface, which invalidates the saved device
state, leaving nothing to be restored after the device is reset on
de-assignment.  This leaves the device in an unusable state.

3.0.0 will add an interface for KVM to save the PCI state in a
buffer unaffected by other callers of pci_reset_function(), but the
most appropriate stable fix seems to be reverting this change since
the original assumption about the device saved state persisting is
incorrect.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Acked-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 virt/kvm/assigned-dev.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -197,8 +197,7 @@ static void kvm_free_assigned_device(str
 {
 	kvm_free_assigned_irq(kvm, assigned_dev);
 
-	__pci_reset_function(assigned_dev->dev);
-	pci_restore_state(assigned_dev->dev);
+	pci_reset_function(assigned_dev->dev);
 
 	pci_release_regions(assigned_dev->dev);
 	pci_disable_device(assigned_dev->dev);
@@ -515,7 +514,6 @@ static int kvm_vm_ioctl_assign_device(st
 	}
 
 	pci_reset_function(dev);
-	pci_save_state(dev);
 
 	match->assigned_dev_id = assigned_dev->assigned_dev_id;
 	match->host_segnr = assigned_dev->segnr;
@@ -546,7 +544,6 @@ out:
 	mutex_unlock(&kvm->lock);
 	return r;
 out_list_del:
-	pci_restore_state(dev);
 	list_del(&match->list);
 	pci_release_regions(dev);
 out_disable:


