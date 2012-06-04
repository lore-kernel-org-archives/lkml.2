Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab2FDLlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 07:41:08 -0400
Received: from david.siemens.de ([192.35.17.14]:33806 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab2FDLkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 07:40:37 -0400
Message-ID: <4FCC9EAC.9090007@siemens.com>
Date: Mon, 04 Jun 2012 13:40:28 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, Alex Williamson <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
References: <20120601161521.26935.25606.stgit@bling.home>   <4FC8F042.5050600@siemens.com> <1338570192.23475.25.camel@bling.home>  <4FC8F867.7080103@siemens.com> <1338573558.23475.41.camel@bling.home> <4FC90961.8030701@siemens.com> <4FCB2359.9020505@redhat.com> <alpine.LFD.2.02.1206041235540.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206041235540.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-04 13:21, Thomas Gleixner wrote:
> On Sun, 3 Jun 2012, Avi Kivity wrote:
> 
>> On 06/01/2012 09:26 PM, Jan Kiszka wrote:
>>>
>>>> you suggesting we need a request_edge_threaded_only_irq() API?  Thanks,
>>>
>>> I'm just wondering if that restriction for threaded IRQs is really
>>> necessary for all use cases we have. Threaded MSIs do not appear to me
>>> like have to be handled that conservatively, but maybe I'm missing some
>>> detail.
>>>
>>
>> btw, I'm hoping we can unthread assigned MSIs.  If the delivery is
>> unicast, we can precalculate everything and all the handler has to do is
>> set the IRR, KVM_REQ_EVENT, and kick the vcpu.  All of these can be done
>> from interrupt context with just RCU locking.
> 
> There is really no need to run MSI/MSI-X interrupts threaded for
> KVM. I'm running the patch below for quite some time and it works like
> a charm.
> 
> Thanks,
> 
> 	tglx
> ----
> Index: linux-2.6/virt/kvm/assigned-dev.c
> ===================================================================
> --- linux-2.6.orig/virt/kvm/assigned-dev.c
> +++ linux-2.6/virt/kvm/assigned-dev.c
> @@ -105,7 +105,7 @@ static irqreturn_t kvm_assigned_dev_thre
>  }
>  
>  #ifdef __KVM_HAVE_MSI
> -static irqreturn_t kvm_assigned_dev_thread_msi(int irq, void *dev_id)
> +static irqreturn_t kvm_assigned_dev_msi_handler(int irq, void *dev_id)
>  {
>  	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
>  
> @@ -117,7 +117,7 @@ static irqreturn_t kvm_assigned_dev_thre
>  #endif
>  
>  #ifdef __KVM_HAVE_MSIX
> -static irqreturn_t kvm_assigned_dev_thread_msix(int irq, void *dev_id)
> +static irqreturn_t kvm_assigned_dev_msix_handler(int irq, void *dev_id)
>  {
>  	struct kvm_assigned_dev_kernel *assigned_dev = dev_id;
>  	int index = find_index_from_host_irq(assigned_dev, irq);
> @@ -346,9 +346,8 @@ static int assigned_device_enable_host_m
>  	}
>  
>  	dev->host_irq = dev->dev->irq;
> -	if (request_threaded_irq(dev->host_irq, NULL,
> -				 kvm_assigned_dev_thread_msi, 0,
> -				 dev->irq_name, dev)) {
> +	if (request_irq(dev->host_irq, kvm_assigned_dev_msi_handler, 0,
> +			dev->irq_name, dev)) {
>  		pci_disable_msi(dev->dev);
>  		return -EIO;
>  	}
> @@ -373,9 +372,9 @@ static int assigned_device_enable_host_m
>  		return r;
>  
>  	for (i = 0; i < dev->entries_nr; i++) {
> -		r = request_threaded_irq(dev->host_msix_entries[i].vector,
> -					 NULL, kvm_assigned_dev_thread_msix,
> -					 0, dev->irq_name, dev);
> +		r = request_irq(dev->host_msix_entries[i].vector,
> +				kvm_assigned_dev_msix_handler, 0,
> +				dev->irq_name, dev);
>  		if (r)
>  			goto err;
>  	}

This may work in practice but has two conceptual problems:
 - we do not want to run a potential broadcast to all VCPUs to run in
   a host IRQ handler
 - crazy user space could have configured the route to end up in the
   PIC or IOAPIC, and both are not hard-IRQ safe (this should probably
   be caught on setup)

So this shortcut requires some checks before being applied to a specific
MSI/MSI-X vector.


Taking KVM aside, my general question remains if threaded MSI handlers
of all devices really need to apply IRQF_ONESHOT though they should have
no use for it.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
