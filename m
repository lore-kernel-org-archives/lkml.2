Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2GNLQO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 07:16:14 -0400
Received: from www.linutronix.de ([62.245.132.108]:47842 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab2GNLQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 07:16:12 -0400
Date: Sat, 14 Jul 2012 13:16:08 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM fixes for 3.5-rc6
In-Reply-To: <500118F1.8060300@web.de>
Message-ID: <alpine.LFD.2.02.1207141253490.32033@ionos>
References: <4FFEBB39.8090308@redhat.com> <CA+55aFwAXbrQRKg_cJT04H_XnoEPjJ0O711C5uA6fRY35DVhKQ@mail.gmail.com> <CA+55aFy=ogfJu3WuoCCDseysxOOn_UEAnv_7Ldsa45VV7fMVPg@mail.gmail.com> <alpine.LFD.2.02.1207131928000.32033@ionos> <alpine.LFD.2.02.1207140208270.32033@ionos>
 <500118F1.8060300@web.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jul 2012, Jan Kiszka wrote:
> On 2012-07-14 04:25, Thomas Gleixner wrote:
> This patch here is a workaround to unbreak devices assignment in 3.5
> after the IRQ layer changes without regressing noticeable /wrt overhead.

Yeah, workaround and regression are the proper marketing buzzwords to
excuse mindless hackery.

It took me a minute to figure out that there is no reason at all to
use a threaded interrupt handler for MSI and MSIX.

If you folks are so concerned about performance and overhead then
someone familiar with that code should have done the obvious change
long before the oneshot modifications took place.

I can't be bothered to do a performance test myself, but I bet it's
making an order of magnitude more of a difference than the "oh so
noticeable" few cycles in irq_finalize_oneshot().

Thanks,

	tglx


Index: linux-2.6/virt/kvm/assigned-dev.c
===================================================================
--- linux-2.6.orig/virt/kvm/assigned-dev.c
+++ linux-2.6/virt/kvm/assigned-dev.c
@@ -105,7 +105,7 @@ static irqreturn_t kvm_assigned_dev_thre
 }
 
 #ifdef __KVM_HAVE_MSI
-static irqreturn_t kvm_assigned_dev_thread_msi(int irq, void *dev_id)
+static irqreturn_t kvm_assigned_dev_msi_handler(int irq, void *dev_id)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
 
@@ -117,7 +117,7 @@ static irqreturn_t kvm_assigned_dev_thre
 #endif
 
 #ifdef __KVM_HAVE_MSIX
-static irqreturn_t kvm_assigned_dev_thread_msix(int irq, void *dev_id)
+static irqreturn_t kvm_assigned_dev_msix_handler(int irq, void *dev_id)
 {
 	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
 	int index = find_index_from_host_irq(assigned_dev, irq);
@@ -334,11 +334,6 @@ static int assigned_device_enable_host_i
 }
 
 #ifdef __KVM_HAVE_MSI
-static irqreturn_t kvm_assigned_dev_msi(int irq, void *dev_id)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 static int assigned_device_enable_host_msi(struct kvm *kvm,
 					   struct kvm_assigned_dev_kernel *dev)
 {
@@ -351,9 +346,8 @@ static int assigned_device_enable_host_m
 	}
 
 	dev->host_irq = dev->dev->irq;
-	if (request_threaded_irq(dev->host_irq, kvm_assigned_dev_msi,
-				 kvm_assigned_dev_thread_msi, 0,
-				 dev->irq_name, dev)) {
+	if (request_irq(dev->host_irq, kvm_assigned_dev_msi_handler, 0,
+			dev->irq_name, dev)) {
 		pci_disable_msi(dev->dev);
 		return -EIO;
 	}
@@ -363,11 +357,6 @@ static int assigned_device_enable_host_m
 #endif
 
 #ifdef __KVM_HAVE_MSIX
-static irqreturn_t kvm_assigned_dev_msix(int irq, void *dev_id)
-{
-	return IRQ_WAKE_THREAD;
-}
-
 static int assigned_device_enable_host_msix(struct kvm *kvm,
 					    struct kvm_assigned_dev_kernel *dev)
 {
@@ -383,10 +372,9 @@ static int assigned_device_enable_host_m
 		return r;
 
 	for (i = 0; i < dev->entries_nr; i++) {
-		r = request_threaded_irq(dev->host_msix_entries[i].vector,
-					 kvm_assigned_dev_msix,
-					 kvm_assigned_dev_thread_msix,
-					 0, dev->irq_name, dev);
+		r = request_irq(dev->host_msix_entries[i].vector,
+				kvm_assigned_dev_msix_handler,
+				0, dev->irq_name, dev);
 		if (r)
 			goto err;
 	}





