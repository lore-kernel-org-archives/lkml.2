Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543Ab2GIQx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 12:53:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418Ab2GIQxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 12:53:25 -0400
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH] kvm: Fix device assignment threaded irq handler
To: avi@redhat.com, mtosatti@redhat.com, mst@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jan.kiszka@siemens.com
Date: Mon, 09 Jul 2012 10:53:22 -0600
Message-ID: <20120709165152.30002.32440.stgit@bling.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel no longer allows us to pass NULL for the hard handler
without also specifying IRQF_ONESHOT.  IRQF_ONESHOT imposes latency
in the exit path that we don't need for MSI interrupts.  Long term
we'd like to inject these interrupts from the hard handler when
possible.  In the short term, we can create dummy hard handlers
that return us to the previous behavior.  Credit to Michael for
original patch.

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43328

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---

Patch against kvm/master for v3.5

 virt/kvm/assigned-dev.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
index b1e091a..23a41a9 100644
--- a/virt/kvm/assigned-dev.c
+++ b/virt/kvm/assigned-dev.c
@@ -334,6 +334,11 @@ static int assigned_device_enable_host_intx(struct kvm *kvm,
 }
 
 #ifdef __KVM_HAVE_MSI
+static irqreturn_t kvm_assigned_dev_msi(int irq, void *dev_id)
+{
+	return IRQ_WAKE_THREAD;
+}
+
 static int assigned_device_enable_host_msi(struct kvm *kvm,
 					   struct kvm_assigned_dev_kernel *dev)
 {
@@ -346,7 +351,7 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
 	}
 
 	dev->host_irq = dev->dev->irq;
-	if (request_threaded_irq(dev->host_irq, NULL,
+	if (request_threaded_irq(dev->host_irq, kvm_assigned_dev_msi,
 				 kvm_assigned_dev_thread_msi, 0,
 				 dev->irq_name, dev)) {
 		pci_disable_msi(dev->dev);
@@ -358,6 +363,11 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
 #endif
 
 #ifdef __KVM_HAVE_MSIX
+static irqreturn_t kvm_assigned_dev_msix(int irq, void *dev_id)
+{
+	return IRQ_WAKE_THREAD;
+}
+
 static int assigned_device_enable_host_msix(struct kvm *kvm,
 					    struct kvm_assigned_dev_kernel *dev)
 {
@@ -374,7 +384,8 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
 
 	for (i = 0; i < dev->entries_nr; i++) {
 		r = request_threaded_irq(dev->host_msix_entries[i].vector,
-					 NULL, kvm_assigned_dev_thread_msix,
+					 kvm_assigned_dev_msix,
+					 kvm_assigned_dev_thread_msix,
 					 0, dev->irq_name, dev);
 		if (r)
 			goto err;

