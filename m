Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab2CBJBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 04:01:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:36242 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393Ab2CBJBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 04:01:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72701378"
Subject: Re: [RFC patch] cmpxchg_double: remove local variables to get
 better performance
From: Alex Shi <alex.shi@intel.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: jeremy@goop.org, "asit.k.mallick@intel.com" <asit.k.mallick@intel.com>,
        "x86@kernel.org" <x86@kernel.org>, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>
In-Reply-To: <4F5098B80200007800075F33@nat28.tlf.novell.com>
References: <1330677063.21053.1532.camel@debian>
	 <4F5098B80200007800075F33@nat28.tlf.novell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 02 Mar 2012 17:00:43 +0800
Message-ID: <1330678843.21053.1553.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-02 at 08:54 +0000, Jan Beulich wrote:
> >>> On 02.03.12 at 09:31, Alex Shi <alex.shi@intel.com> wrote:
> > There are some local variables in cmpxchg_double macro, seems these are
> > used to for force casting on input variables to transfer them into '*p1'
> > type. May there are some reason I don't know. But I just saw 2 problems
> > here:
> > 
> > 1, user may mis-use the macro, like give a 'long' type o1, but just use
> > a 'int*' or 'char*' p1.  
> 
> No - see the BUILD_BUG_ON()s right after the lines you suggest to
> remove.
> 
> Further, it seems to be intentional to allow _compatible_ types for
> o1 and o2 - you could pass in a literal number without L suffix here,
> which I don't think you can anymore with the intermediate variable
> removed.

Yes, we can use cast for intermediate data. And actually, current kernel
has live mis-used case on cmpxchg(), that I plan to point out too. 

-- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -203,12 +203,12 @@ static bool make_all_cpus_request(struct kvm *kvm, unsigned int req)

 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
-       int dirty_count = kvm->tlbs_dirty;
+       long dirty_count = kvm->tlbs_dirty;

        smp_mb();
        if (make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
                ++kvm->stat.remote_tlb_flush;
-       cmpxchg(&kvm->tlbs_dirty, dirty_count, 0);
+       cmpxchg(&kvm->tlbs_dirty, dirty_count, 0L);
 }

> 
> > If we remove the force cast here, gcc will check the mis-using in
> > compiling. and user can get the error report in compiling for such
> > issues.
> > 
> > 2, local variable increased the data section, and bring extra memory bus
> 
> These aren't static, so the data section can't possibly increase.

sorry, it is text section increasing. 
> 
> > accesses, that hurt performance in this critical macro.
> 
> With optimization enabled, the compiler should eliminate all unnecessary
> intermediate variables.

oh, I don't know now. I will recheck this point. 
> 
> > I did a little experiment on my nhm i7 desktop, to run the macro with a
> > fixed times, here is the data:
> > 			 using local vars         no local variable
> > with lock prefix,         267700578ns             232079696ns
> > without lock prefix,      34715666ns              34687566ns
> > 
> > So, we may need rethink about the local variable usage here. 
> > 
> > Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> Sorry, but if this counts, this is a nack from me.
> 
> Jan
> 
> > diff --git a/arch/x86/include/asm/cmpxchg.h b/arch/x86/include/asm/cmpxchg.h
> > index b3b7332..8bf9127 100644
> > --- a/arch/x86/include/asm/cmpxchg.h
> > +++ b/arch/x86/include/asm/cmpxchg.h
> > @@ -210,17 +210,15 @@ extern void __add_wrong_size(void)
> >  #define __cmpxchg_double(pfx, p1, p2, o1, o2, n1, n2)			\
> >  ({									\
> >  	bool __ret;							\
> > -	__typeof__(*(p1)) __old1 = (o1), __new1 = (n1);			\
> > -	__typeof__(*(p2)) __old2 = (o2), __new2 = (n2);			\
> >  	BUILD_BUG_ON(sizeof(*(p1)) != sizeof(long));			\
> >  	BUILD_BUG_ON(sizeof(*(p2)) != sizeof(long));			\
> >  	VM_BUG_ON((unsigned long)(p1) % (2 * sizeof(long)));		\
> >  	VM_BUG_ON((unsigned long)((p1) + 1) != (unsigned long)(p2));	\
> >  	asm volatile(pfx "cmpxchg%c4b %2; sete %0"			\
> > -		     : "=a" (__ret), "+d" (__old2),			\
> > +		     : "=a" (__ret), "+d" (o2),				\
> >  		       "+m" (*(p1)), "+m" (*(p2))			\
> > -		     : "i" (2 * sizeof(long)), "a" (__old1),		\
> > -		       "b" (__new1), "c" (__new2));			\
> > +		     : "i" (2 * sizeof(long)), "a" (o1),		\
> > +		       "b" (n1), "c" (n2));				\
> >  	__ret;								\
> >  })
> >  
> 
> 
> 


