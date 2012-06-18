Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2FRRQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 13:16:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736Ab2FRRQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 13:16:04 -0400
Date: Mon, 18 Jun 2012 20:15:50 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: x86@kernel.org, kvm@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, gleb@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCHv7 3/8] kvm_para: guest side for eoi avoidance
Message-ID: <20120618171550.GA28797@redhat.com>
References: <cover.1339681762.git.mst@redhat.com>
 <4c5bedc5cb55dcea1676b913a0f6da3f04b03145.1339681762.git.mst@redhat.com>
 <4FDF3874.2050208@redhat.com>
 <20120618145041.GE26540@redhat.com>
 <4FDF42E7.8050902@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FDF42E7.8050902@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 06:01:59PM +0300, Avi Kivity wrote:
> On 06/18/2012 05:50 PM, Michael S. Tsirkin wrote:
> > 
> >> >  
> >> > +/* size alignment is implied but just to make it explicit. */
> >> > +static DEFINE_PER_CPU(unsigned long, kvm_apic_eoi) __aligned(2) =
> >> > +	KVM_PV_EOI_DISABLED;
> >> 
> >> You're actually breaking the alignment.  ulong has 8 byte alignment
> >> sometimes and you can make it cross cache boundary this way.
> > 
> > No, if you look at the definition of __aligned
> > you will see that it limits the alignment from below.
> > Compiler still applies the natural size alignment.
> > You are not the first to get confused. So I wonder: is it better
> > to add a comment or simply remove __aligned here.
> 
> Both.

Will do.

> >> >  
> >> > +	if (kvm_para_has_feature(KVM_FEATURE_PV_EOI)) {
> >> > +		__get_cpu_var(kvm_apic_eoi) = 0;
> >> > +		wrmsrl(MSR_KVM_PV_EOI_EN, __pa(&__get_cpu_var(kvm_apic_eoi)) |
> >> > +		       KVM_MSR_ENABLED);
> >> 
> >> Bad formatting.
> > 
> > I guess temporary will make it prettier.
> > 	unsigned long pa;
> > 	__get_cpu_var(kvm_apic_eoi) = 0;
> > 	pa = __pa(&__get_cpu_var(kvm_apic_eoi)) | KVM_MSR_ENABLED;
> > 	wrmsrl(MSR_KVM_PV_EOI_EN, pa);
> 
> That, or
> 
> +		wrmsrl(MSR_KVM_PV_EOI_EN,
> +                      __pa(&__get_cpu_var(kvm_apic_eoi)) | _ENABLED);
> 
> You have an argument split over two lines with no helpful indentation to
> show this.
> 
> >> 
> >> 
> >> Please check that the kexec path also disables pveoi.
> > 
> > The chunk in kvm_pv_guest_cpu_reboot does this, doesn't it?
> 
> Dunno, does it?

I thought it absolutely does but now I noticed this:

Without CONFIG_KEXEC_JUMP, it calls kernel_restart_prepare
which invokes notifiers. So fine.
But with CONFIG_KEXEC_JUMP it does suspend which is way more complex -
it stops all other cpus so we are fine but still not sure about the last
one.

Any idea?

How does it work for e.g. ASYNC_PF?

> 
> 
> -- 
> error compiling committee.c: too many arguments to function
> 
