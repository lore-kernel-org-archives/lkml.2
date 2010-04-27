Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab0D0JZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:25:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:17429 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1749667Ab0D0JZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:25:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,279,1270450800"; 
   d="scan'208";a="270502396"
Subject: Re: [PATCH 2/2] KVM, Fix QEMU-KVM is killed by guest SRAO MCE
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
       kvm@vger.kernel.org
In-Reply-To: <4BD69680.10402@redhat.com>
References: <1272351860.24125.15.camel@yhuang-dev.sh.intel.com>
	 <4BD69680.10402@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Apr 2010 17:25:41 +0800
Message-ID: <1272360341.24125.116.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-27 at 15:47 +0800, Avi Kivity wrote:
> (please copy kvm@vger.kernel.org on kvm patches)

Sorry, will do that for all future patches.

> On 04/27/2010 10:04 AM, Huang Ying wrote:
> >
> > +static void kvm_send_hwpoison_signal(struct kvm *kvm, gfn_t gfn)
> > +{
> > +	char buf[1];
> > +	void __user *hva;
> > +	int r;
> > +
> > +	/* Touch the page, so send SIGBUS */
> > +	hva = (void __user *)gfn_to_hva(kvm, gfn);
> > +	r = copy_from_user(buf, hva, 1);
> >    
> 
> No error check?  What will a copy_from_user() of poisoned page expected 
> to return?
> 
> Best to return -EFAULT on failure for consistency.

Just want to use the side effect of copy_from_user, SIGBUS will be sent
to current process because the page touched is marked as poisoned. That
is, failure is expected, so the return value is not checked.

> > +}
> > +
> >   static int nonpaging_map(struct kvm_vcpu *vcpu, gva_t v, int write, gfn_t gfn)
> >   {
> >   	int r;
> > @@ -1997,7 +2009,11 @@ static int nonpaging_map(struct kvm_vcpu
> >   	/* mmio */
> >   	if (is_error_pfn(pfn)) {
> >   		kvm_release_pfn_clean(pfn);
> > -		return 1;
> > +		if (is_hwpoison_pfn(pfn)) {
> > +			kvm_send_hwpoison_signal(vcpu->kvm, gfn);
> > +			return 0;
> > +		} else
> > +			return 1;
> >   	}
> >    
> 
> This is duplicated several times.  Please introduce a kvm_handle_bad_page():
> 
>      if (is_error_pfn(pfn))
>          return kvm_handle_bad_page(vcpu->kvm, gfn, pfn);

OK. Will do that.

Best Regards,
Huang Ying


