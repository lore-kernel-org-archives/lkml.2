Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751712Ab1K3F0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 00:26:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750767Ab1K3F0L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 00:26:11 -0500
Message-ID: <1322630751.19120.222.camel@bling.home>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Alex Williamson <alex.williamson@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Date: Tue, 29 Nov 2011 22:25:51 -0700
In-Reply-To: <1322628672.21641.39.camel@pasglop>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 15:51 +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2011-11-30 at 13:42 +1100, David Gibson wrote:
> 
> > > +static ssize_t show_iommu_group(struct device *dev,
> > > +				struct device_attribute *attr, char *buf)
> > > +{
> > > +	unsigned int groupid;
> > > +
> > > +	if (iommu_device_group(dev, &groupid))
> > > +		return 0;
> > > +
> > > +	return sprintf(buf, "%u", groupid);
> > > +}
> > > +static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
> > 
> > Hrm.  Assuming the group is is an unsigned int seems dangerous to me.
> > More seriously, we really want these to be unique across the whole
> > system, but they're allocated by the iommu driver which can't
> > guarantee that if it's not the only one present.  Seems to me it would
> > be safer to have an actual iommu_group structure allocated for each
> > group, and use the pointer to it as the ID to hand around (with NULL
> > meaning "no iommu" / untranslated).  The structure could contain a
> > more human readable - or more relevant to platform documentation - ID
> > where appropriate.

Note that iommu drivers are registered per bus_type, so the unique pair
is {bus_type, groupid}, which seems sufficient for vfio.

> Don't forget that to keep sanity, we really want to expose the groups
> via sysfs (per-group dir with symlinks to the devices).
> 
> I'm working with Alexey on providing an in-kernel powerpc specific API
> to expose the PE stuff to whatever's going to interface to VFIO to
> create the groups, though we can eventually collapse that. The idea is
> that on non-PE capable brigdes (old style), I would make a single group
> per host bridge.

If your non-PE capable bridges aren't actually providing isolation, they
should return -ENODEV for the group_device() callback, then vfio will
ignore them.

> In addition, Alex, I noticed that you still have the domain stuff there,
> which is fine I suppose, we could make it a requirement on power that
> you only put a single group in a domain... but the API is still to put
> individual devices in a domain, not groups, and that somewhat sucks.
> 
> You could "fix" that by having some kind of ->domain_enable() or
> whatever that's used to "activate" the domain and verifies that it
> contains entire groups but that looks like a pointless way to complicate
> both the API and the implementation.

Right, groups are currently just a way to identify dependent sets, not a
unit of work.  We can also have group membership change dynamically
(hotplug slot behind a PCIe-to-PCI bridge), so there are cases where we
might need to formally attach/detach a group element to a domain at some
later point.  This really hasn't felt like a stumbling point for vfio,
at least on x86.  Thanks,

Alex

