Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0J3Pb5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 11:31:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43638 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab0J3Pbx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 11:31:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TcHc9EsmzmK7qchFNPb168m75sNCX01Ib5CqlaQ6lPl24Dtaz+v8pfRNXq406r/6Nw
         kLeWfry9eC0++TH1l00DoEn56Bqj5Lyzulv++8HtptH0NCBOnkqmIr0FdY+vi6BlYJmm
         uYAZTDNEZn9ySzqNznIpkw2yOzY47XV+fVOpM=
Date: Sat, 30 Oct 2010 19:31:47 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: kernel-janitors@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: kvm: fix information leak to userland
Message-ID: <20101030153147.GA14169@albatros>
References: <1288447871-7715-1-git-send-email-segooon@gmail.com>
 <4CCC2D11.7090109@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CCC2D11.7090109@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 30, 2010 at 16:34 +0200, Jan Kiszka wrote:
> Am 30.10.2010 16:11, Vasiliy Kulikov wrote:
> > Structure kvm_ppc_pvinfo is copied to userland with pad field
> > unitialized.  Structure kvm_clock_data is copied to userland with
> > flags and pad fields unitialized.  It leads to leaking of contents
> > of kernel stack memory.
> 
> This description only partially matches your patch, please fix.

What do you mean?  Two structures are copied with some fields with old
stack values.  Smth valuable else?

> > 
> > Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> > ---
> >  I cannot compile this driver, so it is not tested at all.
> 
> Why? It should be compilable (provided you have a x86 toolchain).

Hmm, I can't say...  Now it is compilable, but I precisely know that it
failed with "no such header" or smth like this.  Forget it.

> > 
> >  As it is not compilable, I've missed and typed wrong var name in v1, sorry.
> > 
> >  arch/x86/kvm/x86.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > index b0818f6..261f3d0 100644
> > --- a/arch/x86/kvm/x86.c
> > +++ b/arch/x86/kvm/x86.c
> > @@ -2896,6 +2896,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
> >  	case KVM_GET_DEBUGREGS: {
> >  		struct kvm_debugregs dbgregs;
> >  
> > +		memset(&dbgregs, 0, sizeof(dbgregs));
> >  		kvm_vcpu_ioctl_x86_get_debugregs(vcpu, &dbgregs);
> >  
> >  		r = -EFAULT;
> > @@ -3481,11 +3482,11 @@ long kvm_arch_vm_ioctl(struct file *filp,
> >  		struct kvm_clock_data user_ns;
> >  		u64 now_ns;
> >  
> > +		memset(&user_ns, 0, sizeof(user_ns));
> >  		local_irq_disable();
> >  		now_ns = get_kernel_ns();
> >  		user_ns.clock = kvm->arch.kvmclock_offset + now_ns;
> >  		local_irq_enable();
> > -		user_ns.flags = 0;
> >  
> >  		r = -EFAULT;
> >  		if (copy_to_user(argp, &user_ns, sizeof(user_ns)))
> 
> I would rather clear the padding/reserved fields (in both cases). No
> need to double-initialize properly set fields.

Maybe you're right, but from my point of view it's much safer to
explicitly set it to zeroes and then maybe change some of the fields.
Anybody like me who search for such bug will know that it is initialized
at the copy_to_user() level.  If somebody wants to add smth to this code
might move field initalizing to new function; to explore this situation
one should explore this function, etc.

E.g. I searched this bug with copy_to_user() copying struct without
explicit copy_from_user() or memset().

Weaker argument: setting fields to zeroes logically related to
copy_to_user() level, but not initialization as it is correct data unit
with some unitialized not-used-yet field.  On kernel level (without
sending it to userspace) it is OK and even faster.

> There are more interfaces in KVM for obtaining data from the kernel via
> padded structures. Did you check them all (kvm_vcpu_events come to my mind)?

Not all of them yet, at least one place with kvm_vcpu_events is not initialized too.
I'll send the patch today.


Thanks,

-- 
Vasiliy
