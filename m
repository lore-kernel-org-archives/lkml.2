Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab0LCL3u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 06:29:50 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:37615 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab0LCL3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 06:29:49 -0500
X-IronPort-AV: E=Sophos;i="4.59,292,1288569600"; 
   d="scan'208";a="3170784"
Date: Fri, 3 Dec 2010 11:29:40 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Sheng Yang <sheng@linux.intel.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Keir Fraser <Keir.Fraser@eu.citrix.com>,
        xen-devel <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: HVM X2APIC support
In-Reply-To: <201012031448.04382.sheng@linux.intel.com>
Message-ID: <alpine.DEB.2.00.1012031119270.14723@kaball-desktop>
References: <1291258990-16080-1-git-send-email-sheng@linux.intel.com> <201012021433.46976.sheng@linux.intel.com> <alpine.DEB.2.00.1012021319240.14723@kaball-desktop> <201012031448.04382.sheng@linux.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Dec 2010, Sheng Yang wrote:
> I suppose only HVM guest without XENFEAT_hvm_pirqs may need this. But does this 
> code covered PV guest as well? We don't need cover them.
> 

We can add a check on xen_pv_domain() to rule PV guests out.

> > }
> > #else
> > static inline bool xen_para_available(void)
> > {
> > 	return (xen_cpuid_base() != 0);
> > }
> > #endif
> > 
> > 
> > This is assuming that enabling x2apic doesn't prevent Linux from
> > receiving evtchns either using the callback vector mechanism or the
> > legacy platform-pci interrupt.
> 
> I suppose only legacy platform-pci would need this, because it would use lapic. 
> Callback vector method would use evtchn so this won't be enabled.
> 

Right, should add a check on xen_have_vector_callback too.


> > Finally when running as dom0 would this feature create problems in the
> > presence of a real x2apic?
> 
> I don't think this can be enabled on dom0.
> 
> This one target on HVM domain, maybe also PVHVM domain without XENFEAT_hvm_pirqs, 
> but not the domains using evtchn.
> 

Ok, a check on xen_pv_domain() will disable x2apic for both pv guests
and dom0:


#ifdef CONFIG_XEN_PVHVM
static inline bool xen_para_available(void)
{
    if (xen_pv_domain())
        return 0;
    if (xen_cpuid_base() != 0 &&
            xen_feature(XENFEAT_hvm_pirqs) &&
            xen_have_vector_callback)
        return 0;
    else
        return 1;
}

