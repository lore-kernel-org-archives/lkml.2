Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756940Ab2FDLVF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:21:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:40819 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2FDLVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:21:03 -0400
Date: Mon, 4 Jun 2012 13:21:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Avi Kivity <avi@redhat.com>
cc: Jan Kiszka <jan.kiszka@siemens.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI
 interrupts
In-Reply-To: <4FCB2359.9020505@redhat.com>
Message-ID: <alpine.LFD.2.02.1206041235540.3086@ionos>
References: <20120601161521.26935.25606.stgit@bling.home>   <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>  <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home> <4FC90961.8030701@siemens.com>
 <4FCB2359.9020505@redhat.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2012, Avi Kivity wrote:

> On 06/01/2012 09:26 PM, Jan Kiszka wrote:
> > 
> >> you suggesting we need a request_edge_threaded_only_irq() API?  Thanks,
> > 
> > I'm just wondering if that restriction for threaded IRQs is really
> > necessary for all use cases we have. Threaded MSIs do not appear to me
> > like have to be handled that conservatively, but maybe I'm missing some
> > detail.
> > 
> 
> btw, I'm hoping we can unthread assigned MSIs.  If the delivery is
> unicast, we can precalculate everything and all the handler has to do is
> set the IRR, KVM_REQ_EVENT, and kick the vcpu.  All of these can be done
> from interrupt context with just RCU locking.

There is really no need to run MSI/MSI-X interrupts threaded for
KVM. I'm running the patch below for quite some time and it works like
a charm.

Thanks,

	tglx
----
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
@@ -346,9 +346,8 @@ static int assigned_device_enable_host_m
 	}
 
 	dev->host_irq = dev->dev->irq;
-	if (request_threaded_irq(dev->host_irq, NULL,
-				 kvm_assigned_dev_thread_msi, 0,
-				 dev->irq_name, dev)) {
+	if (request_irq(dev->host_irq, kvm_assigned_dev_msi_handler, 0,
+			dev->irq_name, dev)) {
 		pci_disable_msi(dev->dev);
 		return -EIO;
 	}
@@ -373,9 +372,9 @@ static int assigned_device_enable_host_m
 		return r;
 
 	for (i = 0; i < dev->entries_nr; i++) {
-		r = request_threaded_irq(dev->host_msix_entries[i].vector,
-					 NULL, kvm_assigned_dev_thread_msix,
-					 0, dev->irq_name, dev);
+		r = request_irq(dev->host_msix_entries[i].vector,
+				kvm_assigned_dev_msix_handler, 0,
+				dev->irq_name, dev);
 		if (r)
 			goto err;
 	}
