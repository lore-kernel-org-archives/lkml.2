Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1A1OK2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 09:10:28 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:42544 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1A1OK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 09:10:26 -0500
Date: Fri, 28 Jan 2011 09:10:12 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Chris Wilson <chris@chris-wilson.co.uk>
cc: dri-devel@lists.freedesktop.org, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: has the i915 "black screen" boot issue returned? [BISECTED]
In-Reply-To: <849307$bbh907@azsmga001.ch.intel.com>
Message-ID: <alpine.DEB.2.00.1101280905510.3018@localhost6.localdomain6>
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

  *sigh*.  there was, in fact, an "ioremap_error" message displayed
*very* early in the boot sequence, but it was generated even for
successful boots so i never paid it any mind.  in hindsight, might
have been useful to have mentioned it.

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

  ok, i'll make this single change and report back shortly.

rday

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
