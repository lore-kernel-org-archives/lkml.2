Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1AFJKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 04:10:46 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:39674 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751319Ab1AFJKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 04:10:43 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Sheng Yang <sheng@linux.intel.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201101060920.47797.sheng@linux.intel.com>
References: <1292912329-12451-1-git-send-email-sheng@linux.intel.com>
	 <201101051547.12107.sheng@linux.intel.com>
	 <1294239388.3831.3516.camel@zakaz.uk.xensource.com>
	 <201101060920.47797.sheng@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 09:10:30 +0000
Message-ID: <1294305030.3831.3590.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 2/2 v2] xen: HVM X2APIC support
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=z0RUBZs6AVsA:10 a=IkcTkHD0fZMA:10 a=GibqS8P5HScQARpBwNkA:9 a=wSPotpHGhHW_G63k3GEA:7 a=k7eRKnojaU9BESj4x25hd7vp8wUA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 09:20 +0800, Sheng Yang wrote:
> On Wednesday 05 January 2011 22:56:28 Ian Campbell wrote:
> > > > @@ -1384,6 +1365,17 @@ static bool __init xen_hvm_platform(void)
> > > > 
> > > >       return true;
> > > >  
> > > >  }
> > > > 
> > > > +bool xen_hvm_need_lapic(void)
> > > > +{
> > > > +     if (xen_pv_domain())
> > > > +             return false;
> > > > +     if (xen_hvm_domain() && xen_feature(XENFEAT_hvm_pirqs) &&
> > > > +                     xen_have_vector_callback)
> > > > +             return false;
> > > > +     return (xen_cpuid_base() != 0);
> > > > +}
> > > > +EXPORT_SYMBOL_GPL(xen_hvm_need_lapic);
> > > > +
> > 
> > Since xen_hvm_domain() is always true if xen_cpuid_base() != 0, isn't
> > this more obviously written as:
> > 	if (!xen_hvm_domain())
> > 		return false;
> 
> XEN_HVM_DOMAIN works only when kernel built with CONFIG_XEN. This patch can also 
> support kernel built without CONFIG_XEN but with CONFIG_X86_X2APIC.

This function is only compiled when CONFIG_XEN=y, you have a different
variant for the CONFIG_XEN=n case which just does the xen_cpuid_base()
check.

It's actually a bit confusing to have xen_x2apic_para_available() defer
to xen_hvm_need_lapic() when CONFIG_XEN is enabled but do the check
itself when it is not. Can we not simply have:

static inline bool xen_x2apic_para_available(void)
{
#ifdef CONFIG_XEN
	if (!xen_hvm_domain())
		return false;
	if (xen_have_vector_callback)
		return false;
	return true;
#else
	return xen_cpuid_base() != 0;
#endif
}

(either in include/asm/xen/hypervisor.h or out of line in
arch/x86/kernel/cpu/hypervisor.c if this leads to include dependency
hell)

Note that xen_have_vector_callback can be true only if
xen_feature(XENFEAT_hvm_callback_vector) so I think that bit of the
check was redundant.

Maybe even better would be to separate the general Xen presence logic
from the decision to use x2apic, e.g.:

static inline bool xen_para_available(void)
{
#ifdef CONFIG_XEN
	return xen_hvm_domain();
#else
	return xen_cpuid_base() != 0;
#endif
}

static inline bool xen_x2apic_para_available(void)
{
	if (!xen_para_available())
		return false;
#ifdef CONFIG_XEN
	if (xen_have_vector_callback)
		return false;
#endif
	return true;
}

This could be simplified further if xen_have_vector_callback was #define
to 0 when CONFIG_XEN=n.

> > 
> > Also, checking for the XenVMMXenVMM signature alone seems like a very
> > broad test for checking the availability of a specific feature, is there
> > nothing more specific which we could/should be testing?
> 
> The CPU flag x2apic is checked when we want to enable x2apic, and only Xen which 
> supported x2apic emulation would show this flag.

A comment to that effect, in the checkin commentary if not the code,
would be a useful reminder of this.

Thanks,
Ian.

-- 
Ian Campbell
Current Noise: Ramesses - Before The Jackals

Women complain about sex more than men.  Their gripes fall into two
categories: (1) Not enough and (2) Too much.
		-- Ann Landers

