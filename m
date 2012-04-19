Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752327Ab2DSCeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37066 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab2DSCeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:34:08 -0400
Date: Wed, 18 Apr 2012 23:30:08 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jbaron@redhat.com,
        jan.kiszka@siemens.com
Subject: Re: [PATCH] kvm: lock slots_lock around device assignment
Message-ID: <20120419023008.GB17648@amt.cnet>
References: <20120418034537.26262.80743.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120418034537.26262.80743.stgit@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2012 at 09:46:44PM -0600, Alex Williamson wrote:
> @@ -340,7 +343,11 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
>  	if (!domain)
>  		return 0;
>  
> +	mutex_lock(&kvm->slots_lock);
>  	kvm_iommu_unmap_memslots(kvm);
> +	kvm->arch.iommu_domain = NULL;
> +	mutex_unlock(&kvm->slots_lock);
> +
>  	iommu_domain_free(domain);
>  	return 0;
>  }

This might trigger lockdep warnings due to

kvm_vm_ioctl_create_vcpu
mutex_lock(&kvm->lock)
kvm_put_kvm(kvm)
kvm_destroy_vm
kvm_iommu_unmap_guest 

sequence.

Better drop it, it is not necessary in vm destruction
path (since only user is self).

