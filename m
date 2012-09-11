Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2IKBSQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 21:18:16 -0400
Received: from smtp-fw-31001.amazon.com ([207.171.178.25]:41739 "EHLO
	smtp-fw-31001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab2IKBSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 21:18:14 -0400
X-IronPort-AV: E=Sophos;i="4.80,401,1344211200"; 
   d="scan'208";a="292710405"
Date: Mon, 10 Sep 2012 18:17:52 -0700
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefan Bader <stefan.bader@canonical.com>, <xen-devel@lists.xen.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RFC] Fix xsave bug on older Xen hypervisors
Message-ID: <20120911011752.GD22357@u002268147cd4502c336d.ant.amazon.com>
References: <1347018043-21252-1-git-send-email-stefan.bader@canonical.com>
 <20120907134701.GF2870@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120907134701.GF2870@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:47:01AM -0400, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 07, 2012 at 01:40:43PM +0200, Stefan Bader wrote:
> > When writing unsupported flags into CR4 (for some time the
> > xen_write_cr4 function would refuse to do anything at all)
> > older Xen hypervisors (and patch can potentially be improved
> > by finding out what older means in version numbers) would
> > crash the guest.
> > 
> > Since Amazon EC2 would at least in the past be affected by that,
> > Fedora and Ubuntu were carrying a hack that would filter out
> > X86_CR4_OSXSAVE before writing to CR4. This would affect any
> > PV guest, even those running on a newer HV.
> > 
> > And this recently caused trouble because some user-space was
> > only partially checking (or maybe only looking at the cpuid
> > bits) and then trying to use xsave even though the OS support
> > was not set.
> > 
> > So I came up with a patch that would
> > - limit the work-around to certain Xen versions
> > - prevent the write to CR4 by unsetting xsave and osxsave in
> >   the cpuid bits
> > 
> > Doing things that way may actually allow this to be acceptable
> > upstream, so I am sending it around, now.
> > It probably could be improved when knowing the exact version
> > to test for but otherwise should allow to work around the guest
> > crash while not preventing xsave on Xen 4.x and newer hosts.
> 
> Perhaps Matt can give us some hints here.. but otherwise this
> "quirk" should fix this. It should also allow one to run a virgin
> kernel on Amazon EC2 - and we can ask the distros to ditch their
> existing work-arounds for this..

Xen 3.4.0 rc1 contained changeset 19288:9ed53e602119, so checking for
major version < 4 is a bit restrictive. That being said, I don't think
that full PV support of xsave landed until 4.0.2.

Anyway, given that Xen advertises support for XSAVE via setting
OSXSAVE, I'm not happy with a version number check.

> > >From dff8885934d4e1274a69c4cedd28a4d18a1255e8 Mon Sep 17 00:00:00 2001
> > From: Stefan Bader <stefan.bader@canonical.com>
> > Date: Fri, 15 Jun 2012 11:54:59 +0200
> > Subject: [PATCH] xen: Mask xsave cpu capability on Xen host < 4
> >
> > Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
[...]
> > +/*
> > + * Older (with no clear statement about what old means) Xen hypervisors
> > + * will crash a PV guest that tries to store OSXSAVE into CR4.
> > + * To prevent this, we force the feature bits related to this off in the
> > + * xen cpuid call. This inline function serves as a centralized test
> > + * on whether the quirk should be done.
> > + */
> > +static inline needs_xsave_quirk(unsigned version)
> > +{
> > +	return (xen_pv_domain() && ((version >> 16) < 4)) ? 1 : 0;

What has me really a bit confused is this: it seems that Xen should be
setting OSXSAVE for the guest if XSAVE is supported. Going back to the
changeset that Konrad point out:

commit 947ccf9c3c30307b774af3666ee74fcd9f47f646
Author: Shan Haitao <haitao.shan@intel.com>
Date:   Tue Nov 9 11:43:36 2010 -0800

    xen: Allow PV-OPS kernel to detect whether XSAVE is supported
    
    Xen fails to mask XSAVE from the cpuid feature, despite not historically
    supporting guest use of XSAVE.  However, now that XSAVE support has been
    added to Xen, we need to reliably detect its presence.
    
    The most reliable way to do this is to look at the OSXSAVE feature in
    cpuid which is set iff the OS (Xen, in this case), has set
    CR4.OSXSAVE.
[...]
+       xsave_mask =
+               (1 << (X86_FEATURE_XSAVE % 32)) |
+               (1 << (X86_FEATURE_OSXSAVE % 32));
+
+       /* Xen will set CR4.OSXSAVE if supported and not disabled by force */
+       if ((cx & xsave_mask) != xsave_mask)
+               cpuid_leaf1_ecx_mask &= ~xsave_mask; /* disable XSAVE & OSXSAVE */

Since this proposed change is basically in the same codepath as the
existing check to see if OSXSAVE is set, I doubt that it will prevent
xsave_init() from writing the killer bits into cr4.

Let me do a bit of testing.

Matt

> > +}
> > +
> >  static void __init xen_banner(void)
> >  {
> >  	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
> > @@ -221,6 +233,8 @@ static void __init xen_banner(void)
> >  	printk(KERN_INFO "Xen version: %d.%d%s%s\n",
> >  	       version >> 16, version & 0xffff, extra.extraversion,
> >  	       xen_feature(XENFEAT_mmu_pt_update_preserve_ad) ? " (preserve-AD)" : "");
> > +	if (needs_xsave_quirk(version))
> > +		printk(KERN_INFO "Forcing xsave off due to Xen version.\n");
> >  }
> >  
> >  #define CPUID_THERM_POWER_LEAF 6
> > @@ -351,6 +365,7 @@ static bool __init xen_check_mwait(void)
> >  }
> >  static void __init xen_init_cpuid_mask(void)
> >  {
> > +	unsigned version = HYPERVISOR_xen_version(XENVER_version, NULL);
> >  	unsigned int ax, bx, cx, dx;
> >  	unsigned int xsave_mask;
> >  
> > @@ -371,7 +386,7 @@ static void __init xen_init_cpuid_mask(void)
> >  		(1 << (X86_FEATURE_OSXSAVE % 32));
> >  
> >  	/* Xen will set CR4.OSXSAVE if supported and not disabled by force */
> > -	if ((cx & xsave_mask) != xsave_mask)
> > +	if (((cx & xsave_mask) != xsave_mask) || needs_xsave_quirk(version))
> >  		cpuid_leaf1_ecx_mask &= ~xsave_mask; /* disable XSAVE & OSXSAVE */
> >  	if (xen_check_mwait())
> >  		cpuid_leaf1_ecx_set_mask = (1 << (X86_FEATURE_MWAIT % 32));
