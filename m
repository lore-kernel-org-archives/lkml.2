Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab2DSC62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752665Ab2DSC61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:58:27 -0400
Message-ID: <1334804304.3112.243.camel@bling.home>
Subject: Re: [PATCH] kvm: lock slots_lock around device assignment
From: Alex Williamson <alex.williamson@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, jbaron@redhat.com,
        jan.kiszka@siemens.com
Date: Wed, 18 Apr 2012 20:58:24 -0600
In-Reply-To: <20120419023008.GB17648@amt.cnet>
References: <20120418034537.26262.80743.stgit@bling.home>
	 <20120419023008.GB17648@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 23:30 -0300, Marcelo Tosatti wrote:
> On Tue, Apr 17, 2012 at 09:46:44PM -0600, Alex Williamson wrote:
> > @@ -340,7 +343,11 @@ int kvm_iommu_unmap_guest(struct kvm *kvm)
> >  	if (!domain)
> >  		return 0;
> >  
> > +	mutex_lock(&kvm->slots_lock);
> >  	kvm_iommu_unmap_memslots(kvm);
> > +	kvm->arch.iommu_domain = NULL;
> > +	mutex_unlock(&kvm->slots_lock);
> > +
> >  	iommu_domain_free(domain);
> >  	return 0;
> >  }
> 
> This might trigger lockdep warnings due to
> 
> kvm_vm_ioctl_create_vcpu
> mutex_lock(&kvm->lock)
> kvm_put_kvm(kvm)
> kvm_destroy_vm
> kvm_iommu_unmap_guest 
> 
> sequence.
> 
> Better drop it, it is not necessary in vm destruction
> path (since only user is self).

I actually ran this with lockdep and didn't generate a warning;
hopefully I had it configured correctly.  Also, we'll soon be unmapping
the guest any time we remove the last assigned device so this will no
longer be a vm destruction-only path.  We can just as easily race adding
new mappings or removing already removed ones on that path.  We also
acquire kvm->lock in the mapping path:

kvm_vm_ioctl_assign_device() {
mutex_lock(&kvm->lock);
if (!kvm->arch.iommu_domain) {
      r = kvm_iommu_map_guest(kvm);

which by inspection and the lock ordering note in kvm_main seems to be
ok.  Thanks,

Alex

