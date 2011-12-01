Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab1LAGsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 01:48:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab1LAGsp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 01:48:45 -0500
Message-ID: <1322722110.26545.68.camel@bling.home>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Alex Williamson <alex.williamson@redhat.com>
To: David Gibson <dwg@au1.ibm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Wed, 30 Nov 2011 23:48:30 -0700
In-Reply-To: <20111201000337.GA5427@truffala.fritz.box>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 11:03 +1100, David Gibson wrote:
> On Tue, Nov 29, 2011 at 10:25:51PM -0700, Alex Williamson wrote:
> > On Wed, 2011-11-30 at 15:51 +1100, Benjamin Herrenschmidt wrote:
> > > On Wed, 2011-11-30 at 13:42 +1100, David Gibson wrote:
> > > 
> > > > > +static ssize_t show_iommu_group(struct device *dev,
> > > > > +				struct device_attribute *attr, char *buf)
> > > > > +{
> > > > > +	unsigned int groupid;
> > > > > +
> > > > > +	if (iommu_device_group(dev, &groupid))
> > > > > +		return 0;
> > > > > +
> > > > > +	return sprintf(buf, "%u", groupid);
> > > > > +}
> > > > > +static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
> > > > 
> > > > Hrm.  Assuming the group is is an unsigned int seems dangerous to me.
> > > > More seriously, we really want these to be unique across the whole
> > > > system, but they're allocated by the iommu driver which can't
> > > > guarantee that if it's not the only one present.  Seems to me it would
> > > > be safer to have an actual iommu_group structure allocated for each
> > > > group, and use the pointer to it as the ID to hand around (with NULL
> > > > meaning "no iommu" / untranslated).  The structure could contain a
> > > > more human readable - or more relevant to platform documentation - ID
> > > > where appropriate.
> > 
> > Note that iommu drivers are registered per bus_type, so the unique pair
> > is {bus_type, groupid}, which seems sufficient for vfio.
> 
> Hrm.  That's.. far from obvious.  And still breaks down if we have two
> separate iommus on the same bus type (e.g. two independent PCI host
> bridges with inbuilt IOMMUs).

See bus_set_iommu(struct bus_type *bus, struct iommu_ops *ops).  It
wasn't long ago that we had a global iommu_ops.  Are heterogeneous
iommus using different drivers on the same bus_type really a possibility
on your system, or are we dealing with hypothetical situations?  You'd
currently need to multiplex iommu_ops callbacks between the drivers
yourself.

> > > Don't forget that to keep sanity, we really want to expose the groups
> > > via sysfs (per-group dir with symlinks to the devices).
> > > 
> > > I'm working with Alexey on providing an in-kernel powerpc specific API
> > > to expose the PE stuff to whatever's going to interface to VFIO to
> > > create the groups, though we can eventually collapse that. The idea is
> > > that on non-PE capable brigdes (old style), I would make a single group
> > > per host bridge.
> > 
> > If your non-PE capable bridges aren't actually providing isolation, they
> > should return -ENODEV for the group_device() callback, then vfio will
> > ignore them.
> > 
> > > In addition, Alex, I noticed that you still have the domain stuff there,
> > > which is fine I suppose, we could make it a requirement on power that
> > > you only put a single group in a domain... but the API is still to put
> > > individual devices in a domain, not groups, and that somewhat sucks.
> > > 
> > > You could "fix" that by having some kind of ->domain_enable() or
> > > whatever that's used to "activate" the domain and verifies that it
> > > contains entire groups but that looks like a pointless way to complicate
> > > both the API and the implementation.
> > 
> > Right, groups are currently just a way to identify dependent sets, not a
> > unit of work.
> 
> I'm not quite sure what you mean by "unit of work".  But assigning the
> groups as a unit generally makes more sense to me than assigning
> devices individually, but only being able to use them when the group
> is together.  Particularly when things are hotplugged into groups.

iommu_attach_device() takes a device as a "unit of work", not a group.
If we have a group in use by a userspace driver and a new physical
device is hotplugged into the host and belongs to the group, we need the
granularity of the device to be able to add it to the domain.

I'm not sure if we're getting into VM usage with "assigning" terminology
above.  You're free to architect qemu however you want on POWER to make
groups be the assignable unit to a guest.  On x86, an individual device
is the assignable unit for a guest.  Unassigned group devices will still
be required to be held by vfio, they'll just be unused.  Thanks,

Alex

