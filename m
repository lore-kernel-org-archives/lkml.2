Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1A1UNd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:13:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48261 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220Ab1A1UNc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:13:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: has the i915 "black screen" boot issue returned? [BISECTED]
Date: Fri, 28 Jan 2011 21:12:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.4.4; x86_64; ; )
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org
References: <alpine.DEB.2.00.1101260634300.10774@localhost6.localdomain6> <1bdc18$jdthb8@fmsmga002.fm.intel.com> <alpine.DEB.2.00.1101281006550.3007@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.00.1101281006550.3007@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101282112.52798.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 28, 2011, Robert P. J. Day wrote:
> On Fri, 28 Jan 2011, Chris Wilson wrote:
> 
> > On Fri, 28 Jan 2011 09:51:01 -0500 (EST), "Robert P. J. Day" <rpjday@crashcourse.ca> wrote:
> > >   sadly, no change -- still black screen.  again, rebooted
> > > successfully under commit 8a327f23.  just to be clear, here's "git
> > > diff":
> > >
> > > $ git diff
> > > diff --git a/include/linux/acpi_io.h b/include/linux/acpi_io.h
> > > index 7180013..e035f3c 100644
> > > --- a/include/linux/acpi_io.h
> > > +++ b/include/linux/acpi_io.h
> > > @@ -7,7 +7,7 @@
> > >  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
> > >                                             acpi_size size)
> > >  {
> > > -       return ioremap_cache(phys, size);
> > > +       return ioremap(phys, size);
> > >  }
> >
> > Ok, that implies the new mapping is fine and not the cause of the issue.
> >
> > Instead you have some OpRegion related regression hidden until till now
> > because the conflicting mapping disabled it for i915.
> >
> > That would be easy to test by returning early in intel_opregion_setup():
> >
> > diff --git a/drivers/gpu/drm/i915/intel_opregion.c
> > b/drivers/gpu/drm/i915/intel_
> > index 9efccb9..8c93201 100644
> > --- a/drivers/gpu/drm/i915/intel_opregion.c
> > +++ b/drivers/gpu/drm/i915/intel_opregion.c
> > @@ -470,6 +470,8 @@ int intel_opregion_setup(struct drm_device *dev)
> >         u32 asls, mboxes;
> >         int err = 0;
> >
> > +       return -ENOTSUPP;
> > +
> >
> >         pci_read_config_dword(dev->pdev, PCI_ASLS, &asls);
> >         DRM_DEBUG_DRIVER("graphic opregion physical addr: 0x%x\n", asls);
> >         if (asls == 0) {
> >
> 
> so you want me to revert to a stock b705120e before doing the above?

Alternatively, you could take the vanilla Linus' tree and replace
ioremap_cache() with ioremap() in include/linux/acpi_io.h .  Please try that
and see if it makes a difference.

Thanks,
Rafael
