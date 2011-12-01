Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1LAAii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:38:38 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:55901 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab1LAAih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:38:37 -0500
Date: Thu, 1 Dec 2011 11:03:37 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Message-ID: <20111201000337.GA5427@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	joerg.roedel@amd.com, dwmw2@infradead.org,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	chrisw@redhat.com, agraf@suse.de, scottwood@freescale.com,
	B08248@freescale.com
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195605.8438.81609.stgit@s20.home>
 <20111130024205.GF5435@truffala.fritz.box>
 <1322628672.21641.39.camel@pasglop>
 <1322630751.19120.222.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322630751.19120.222.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11113014-6102-0000-0000-0000004BF776
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:25:51PM -0700, Alex Williamson wrote:
> On Wed, 2011-11-30 at 15:51 +1100, Benjamin Herrenschmidt wrote:
> > On Wed, 2011-11-30 at 13:42 +1100, David Gibson wrote:
> > 
> > > > +static ssize_t show_iommu_group(struct device *dev,
> > > > +				struct device_attribute *attr, char *buf)
> > > > +{
> > > > +	unsigned int groupid;
> > > > +
> > > > +	if (iommu_device_group(dev, &groupid))
> > > > +		return 0;
> > > > +
> > > > +	return sprintf(buf, "%u", groupid);
> > > > +}
> > > > +static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
> > > 
> > > Hrm.  Assuming the group is is an unsigned int seems dangerous to me.
> > > More seriously, we really want these to be unique across the whole
> > > system, but they're allocated by the iommu driver which can't
> > > guarantee that if it's not the only one present.  Seems to me it would
> > > be safer to have an actual iommu_group structure allocated for each
> > > group, and use the pointer to it as the ID to hand around (with NULL
> > > meaning "no iommu" / untranslated).  The structure could contain a
> > > more human readable - or more relevant to platform documentation - ID
> > > where appropriate.
> 
> Note that iommu drivers are registered per bus_type, so the unique pair
> is {bus_type, groupid}, which seems sufficient for vfio.

Hrm.  That's.. far from obvious.  And still breaks down if we have two
separate iommus on the same bus type (e.g. two independent PCI host
bridges with inbuilt IOMMUs).

> > Don't forget that to keep sanity, we really want to expose the groups
> > via sysfs (per-group dir with symlinks to the devices).
> > 
> > I'm working with Alexey on providing an in-kernel powerpc specific API
> > to expose the PE stuff to whatever's going to interface to VFIO to
> > create the groups, though we can eventually collapse that. The idea is
> > that on non-PE capable brigdes (old style), I would make a single group
> > per host bridge.
> 
> If your non-PE capable bridges aren't actually providing isolation, they
> should return -ENODEV for the group_device() callback, then vfio will
> ignore them.
> 
> > In addition, Alex, I noticed that you still have the domain stuff there,
> > which is fine I suppose, we could make it a requirement on power that
> > you only put a single group in a domain... but the API is still to put
> > individual devices in a domain, not groups, and that somewhat sucks.
> > 
> > You could "fix" that by having some kind of ->domain_enable() or
> > whatever that's used to "activate" the domain and verifies that it
> > contains entire groups but that looks like a pointless way to complicate
> > both the API and the implementation.
> 
> Right, groups are currently just a way to identify dependent sets, not a
> unit of work.

I'm not quite sure what you mean by "unit of work".  But assigning the
groups as a unit generally makes more sense to me than assigning
devices individually, but only being able to use them when the group
is together.  Particularly when things are hotplugged into groups.

>  We can also have group membership change dynamically
> (hotplug slot behind a PCIe-to-PCI bridge), so there are cases where we
> might need to formally attach/detach a group element to a domain at some
> later point.  This really hasn't felt like a stumbling point for vfio,
> at least on x86.  Thanks,
> 
> Alex
> 

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

