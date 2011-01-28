Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab1A1OcU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:32:20 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:44656 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699Ab1A1OcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:32:19 -0500
Date: Fri, 28 Jan 2011 09:32:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: dri-devel@lists.freedesktop.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: has the i915 "black screen" boot issue returned? [BISECTED]
In-Reply-To: <849307$bbh907@azsmga001.ch.intel.com>
Message-ID: <alpine.DEB.2.00.1101280928170.2760@localhost6.localdomain6>
References: <alpine.DEB.2.00.1101260634300.10774@localhost6.localdomain6> <b9dded$hp9kfu@orsmga002.jf.intel.com> <alpine.DEB.2.00.1101270641490.2923@localhost6.localdomain6> <b9dded$hpa5rf@orsmga002.jf.intel.com> <alpine.DEB.2.00.1101270710510.17636@localhost6.localdomain6>
 <1bdc18$jdgfni@fmsmga002.fm.intel.com> <alpine.DEB.2.00.1101270840380.2736@localhost6.localdomain6> <0d30dc$ksovh8@orsmga001.jf.intel.com> <alpine.DEB.2.00.1101270854420.4898@localhost6.localdomain6> <b7da2f$q8lpcn@fmsmga001.fm.intel.com>
 <alpine.DEB.2.00.1101271634260.2761@localhost6.localdomain6> <alpine.DEB.2.00.1101271730400.2583@localhost6.localdomain6> <849307$bbem1h@azsmga001.ch.intel.com> <alpine.DEB.2.00.1101280421430.2739@localhost6.localdomain6> <0d30dc$kt3gd6@orsmga001.jf.intel.com>
 <alpine.DEB.2.00.1101280850550.2796@localhost6.localdomain6> <849307$bbh907@azsmga001.ch.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011, Chris Wilson wrote:

> On Fri, 28 Jan 2011 08:53:59 -0500 (EST), "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > so the culprit appears to be:
> >
> > b705120e4198315f4ae043de06c62f65e0851fd3 is the first bad commit
> > commit b705120e4198315f4ae043de06c62f65e0851fd3
> > Author: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> > Date:   Sun Jan 23 18:17:17 2011 +0000
> >
> >     drm/i915: Use consistent mappings for OpRegion between ACPI and i915
> >
> >     The opregion is a shared memory region between ACPI and the graphics
> >     driver. As the ACPI mapping has been changed to cachable in commit
> >     6d5bbf00d251cc73223a71422d69e069dc2e0b8d, mapping the intel opregion
> >     non-cachable now fails. As no bus-master hardware is involved in the
> >     opregion, cachable map should do no harm.
> >
> >     Tested on a Fujitsu Lifebook P8010.
> >
> >     Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
> >     [ickle: convert to acpi_os_ioremap for consistency]
> >     Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> >
> >
> >   thoughts?  once again, the salient output from "lspci -v":
>
> Indeed looks like using ioremap_cache is not as safe as was assumed. Does
>
> diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
> index 7180013..42108ab 100644
> --- a/include/linux/acpi_io.h
> +++ b/include/linux/acpi_io.h
> @@ -7,7 +7,7 @@
>  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
>                                             acpi_size size)
>  {
> -       return ioremap_cache(phys, size);
> +       return ioremap_wc(phys, size);
>  }
>
>  int acpi_os_map_generic_address(struct acpi_generic_address *addr);

  that didn't appear to make a difference.  same black screen issue.
BTW, here's an excerpt from /var/log/dmesg for a *successful* boot (i
just rebooted to 8a327f23):

...
[   24.037114] intel ips 0000:00:1f.6: failed to get i915 symbols, graphics turbo disabled
...
[   27.155660] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   27.155665] i915 0000:00:02.0: setting latency timer to 64
[   27.217407] mtrr: no more MTRRs available
[   27.217411] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   27.217848] ioremap error for 0xb3752000-0xb3755000, requested 0x10, got 0x0
[   27.217933] i915 0000:00:02.0: irq 42 for MSI/MSI-X
[   27.217938] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   27.217940] [drm] Driver supports precise vblank timestamp query.
...

if any of that is of any use.

> fix your boot issue or do we need to go back to using uncached:
>
> +       return ioremap(phys, size);

  is that the next change you want me to try?

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
