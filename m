Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530Ab2FAQjl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 12:39:41 -0400
Received: from goliath.siemens.de ([192.35.17.28]:33836 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965486Ab2FAQjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 12:39:39 -0400
Message-ID: <4FC8F042.5050600@siemens.com>
Date: Fri, 01 Jun 2012 18:39:30 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "avi@redhat.com" <avi@redhat.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yongjie.ren@intel.com" <yongjie.ren@intel.com>
Subject: Re: [PATCH] KVM: Use IRQF_ONESHOT for assigned device MSI interrupts
References: <20120601161521.26935.25606.stgit@bling.home>
In-Reply-To: <20120601161521.26935.25606.stgit@bling.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-01 18:16, Alex Williamson wrote:
> The kernel no longer allows us to pass NULL for a hard interrupt
> handler without IRQF_ONESHOT.  Should have been using this flag
> anyway.

This make the IRQ handling tail a bit slower (due to
irq_finalize_oneshot). MSIs are edge-triggered, so there was no need for
masking in theory. Hmm, can't we trust the information that an IRQ
grabbed here is really a MSI type?

Jan

> 
> Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43328
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  virt/kvm/assigned-dev.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/assigned-dev.c b/virt/kvm/assigned-dev.c
> index 01f572c..e804d14 100644
> --- a/virt/kvm/assigned-dev.c
> +++ b/virt/kvm/assigned-dev.c
> @@ -347,7 +347,7 @@ static int assigned_device_enable_host_msi(struct kvm *kvm,
>  
>  	dev->host_irq = dev->dev->irq;
>  	if (request_threaded_irq(dev->host_irq, NULL,
> -				 kvm_assigned_dev_thread_msi, 0,
> +				 kvm_assigned_dev_thread_msi, IRQF_ONESHOT,
>  				 dev->irq_name, dev)) {
>  		pci_disable_msi(dev->dev);
>  		return -EIO;
> @@ -375,7 +375,7 @@ static int assigned_device_enable_host_msix(struct kvm *kvm,
>  	for (i = 0; i < dev->entries_nr; i++) {
>  		r = request_threaded_irq(dev->host_msix_entries[i].vector,
>  					 NULL, kvm_assigned_dev_thread_msix,
> -					 0, dev->irq_name, dev);
> +					 IRQF_ONESHOT, dev->irq_name, dev);
>  		if (r)
>  			goto err;
>  	}
> 

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
