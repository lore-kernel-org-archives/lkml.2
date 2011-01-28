Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab1A1UVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:21:25 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:51245 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab1A1UVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:21:24 -0500
Date: Fri, 28 Jan 2011 15:21:04 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: has the i915 "black screen" boot issue returned? [BISECTED]
In-Reply-To: <201101282112.52798.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1101281516330.4568@localhost6.localdomain6>
References: <alpine.DEB.2.00.1101260634300.10774@localhost6.localdomain6> <1bdc18$jdthb8@fmsmga002.fm.intel.com> <alpine.DEB.2.00.1101281006550.3007@localhost6.localdomain6> <201101282112.52798.rjw@sisk.pl>
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

On Fri, 28 Jan 2011, Rafael J. Wysocki wrote:

> On Friday, January 28, 2011, Robert P. J. Day wrote:
> > On Fri, 28 Jan 2011, Chris Wilson wrote:
> >
> > > On Fri, 28 Jan 2011 09:51:01 -0500 (EST), "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > > >   sadly, no change -- still black screen.  again, rebooted
> > > > successfully under commit 8a327f23.  just to be clear, here's "git
> > > > diff":
> > > >
> > > > $ git diff
> > > > diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
> > > > index 7180013..e035f3c 100644
> > > > --- a/include/linux/acpi_io.h
> > > > +++ b/include/linux/acpi_io.h
> > > > @@ -7,7 +7,7 @@
> > > >  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
> > > >                                             acpi_size size)
> > > >  {
> > > > -       return ioremap_cache(phys, size);
> > > > +       return ioremap(phys, size);
> > > >  }
> > >
> > > Ok, that implies the new mapping is fine and not the cause of the issue.
> > >
> > > Instead you have some OpRegion related regression hidden until till now
> > > because the conflicting mapping disabled it for i915.
> > >
> > > That would be easy to test by returning early in intel_opregion_setup():
> > >
> > > diff --git a/drivers/gpu/drm/i915/intel_opregion.c
> > > b/drivers/gpu/drm/i915/intel_
> > > index 9efccb9..8c93201 100644
> > > --- a/drivers/gpu/drm/i915/intel_opregion.c
> > > +++ b/drivers/gpu/drm/i915/intel_opregion.c
> > > @@ -470,6 +470,8 @@ int intel_opregion_setup(struct drm_device *dev)
> > >         u32 asls, mboxes;
> > >         int err = 0;
> > >
> > > +       return -ENOTSUPP;
> > > +
> > >
> > >         pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
> > >         DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
> > >         if (asls == 0) {
> > >
> >
> > so you want me to revert to a stock b705120e before doing the above?
>
> Alternatively, you could take the vanilla Linus' tree and replace
> ioremap_cache() with ioremap() in include/linux/acpi_io.h .  Please try that
> and see if it makes a difference.

  been there, done that, that's all so ... this morning.  i continued
bisecting and playing and eventually verified the following
workaround for an earlier working version of the kernel:

$ git diff
diff --git a/drivers/gpu/drm/i915/intel_opregion.c b/drivers/gpu/drm/i915/intel_opregion.c
index 64fd644..28adc6d 100644
--- a/drivers/gpu/drm/i915/intel_opregion.c
+++ b/drivers/gpu/drm/i915/intel_opregion.c
@@ -495,6 +495,8 @@ int intel_opregion_setup(struct drm_device *dev)
                opregion->acpi = base + OPREGION_ACPI_OFFSET;
        }

+return 0; // rday
+
        if (mboxes & MBOX_SWSCI) {
                DRM_DEBUG_DRIVER("SWSCI supported\n");
                opregion->swsci = base + OPREGION_SWSCI_OFFSET;


  this was based on a suggestion by chris wilson to deactivate the
"mboxes" tests in that single source file and see what happened.
adding the "return 0" above suddenly gave me a properly booting
kernel.  i applied the same diff to the current kernel and it's
building as we speak.

rday

p.s.  having that "return 0" *after* that test but before the next one
still gave me a black screen.

-- 

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
