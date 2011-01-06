Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab1AFJVb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:21:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:9203 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751319Ab1AFJV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:21:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,282,1291622400"; 
   d="scan'208";a="644002171"
From: Sheng Yang <sheng@linux.intel.com>
Organization: Intel Opensource Technology Center
To: Ian Campbell <ijc@hellion.org.uk>
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
Date: Thu, 6 Jan 2011 17:23:29 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.35-23-generic; KDE/4.5.1; x86_64; ; )
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com> <201101060920.47797.sheng@linux.intel.com> <1294305030.3831.3590.camel@zakaz.uk.xensource.com>
In-Reply-To: <1294305030.3831.3590.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061723.29523.sheng@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 January 2011 17:10:30 Ian Campbell wrote:
> On Thu, 2011-01-06 at 09:20 +0800, Sheng Yang wrote:
> > On Wednesday 05 January 2011 22:56:28 Ian Campbell wrote:
> > > > > @@ -1384,6 +1365,17 @@ static bool __init xen_hvm_platform(void)
> > > > > 
> > > > >       return true;
> > > > >  
> > > > >  }
> > > > > 
> > > > > +bool xen_hvm_need_lapic(void)
> > > > > +{
> > > > > +     if (xen_pv_domain())
> > > > > +             return false;
> > > > > +     if (xen_hvm_domain() && xen_feature(XENFEAT_hvm_pirqs) &&
> > > > > +                     xen_have_vector_callback)
> > > > > +             return false;
> > > > > +     return (xen_cpuid_base() != 0);
> > > > > +}
> > > > > +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
> > > > > +
> > > 
> > > Since xen_hvm_domain() is always true if xen_cpuid_base() != 0, isn't
> > > 
> > > this more obviously written as:
> > > 	if (!xen_hvm_domain())
> > > 	
> > > 		return false;
> > 
> > XEN_HVM_DOMAIN works only when kernel built with CONFIG_XEN. This patch
> > can also support kernel built without CONFIG_XEN but with
> > CONFIG_X86_X2APIC.
> 
> This function is only compiled when CONFIG_XEN=y, you have a different
> variant for the CONFIG_XEN=n case which just does the xen_cpuid_base()
> check.
> 
> It's actually a bit confusing to have xen_x2apic_para_available() defer
> to xen_hvm_need_lapic() when CONFIG_XEN is enabled but do the check
> itself when it is not. Can we not simply have:
> 
> static inline bool xen_x2apic_para_available(void)
> {
> #ifdef CONFIG_XEN
> 	if (!xen_hvm_domain())
> 		return false;
> 	if (xen_have_vector_callback)
> 		return false;
> 	return true;
> #else
> 	return xen_cpuid_base() != 0;
> #endif
> }
> 
> (either in include/asm/xen/hypervisor.h or out of line in
> arch/x86/kernel/cpu/hypervisor.c if this leads to include dependency
> hell)
> 
> Note that xen_have_vector_callback can be true only if
> xen_feature(XENFEAT_hvm_callback_vector) so I think that bit of the
> check was redundant.

I am not familiar with these dependence, and just followed Stefano's comments.
> 
> Maybe even better would be to separate the general Xen presence logic
> from the decision to use x2apic, e.g.:
> 
> static inline bool xen_para_available(void)
> {
> #ifdef CONFIG_XEN
> 	return xen_hvm_domain();
> #else
> 	return xen_cpuid_base() != 0;
> #endif
> }
> 
> static inline bool xen_x2apic_para_available(void)
> {
> 	if (!xen_para_available())
> 		return false;
> #ifdef CONFIG_XEN
> 	if (xen_have_vector_callback)
> 		return false;
> #endif
> 	return true;
> }
> 
> This could be simplified further if xen_have_vector_callback was #define
> to 0 when CONFIG_XEN=n.

Thanks for the comments, but seems it's a little late. The patches have been there 
for more than a month since the first version, and now they are finally in the 
tree... And since it's not a bug, could we leave it to the later clean up?
 
> > > Also, checking for the XenVMMXenVMM signature alone seems like a very
> > > broad test for checking the availability of a specific feature, is
> > > there nothing more specific which we could/should be testing?
> > 
> > The CPU flag x2apic is checked when we want to enable x2apic, and only
> > Xen which supported x2apic emulation would show this flag.
> 
> A comment to that effect, in the checkin commentary if not the code,
> would be a useful reminder of this.

The caller of the function indicate so, it's in the x2apic enabling code(which is 
the same as KVM). So I think that maybe enough.

--
regards
Yang, Sheng

> 
> Thanks,
> Ian.
