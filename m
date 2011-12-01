Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab1LAA5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 19:57:36 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:32938 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599Ab1LAA5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 19:57:35 -0500
Date: Thu, 1 Dec 2011 11:57:25 +1100
From: David Gibson <dwg@au1.ibm.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        joerg.roedel@amd.com, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        agraf@suse.de, scottwood@freescale.com, B08248@freescale.com
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Message-ID: <20111201005725.GE5427@truffala.fritz.box>
Mail-Followup-To: David Gibson <dwg@au1.ibm.com>,
	Chris Wright <chrisw@redhat.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	joerg.roedel@amd.com, dwmw2@infradead.org,
	iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	agraf@suse.de, scottwood@freescale.com, B08248@freescale.com
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195605.8438.81609.stgit@s20.home>
 <20111130024205.GF5435@truffala.fritz.box>
 <1322628672.21641.39.camel@pasglop>
 <1322630751.19120.222.camel@bling.home>
 <20111201000337.GA5427@truffala.fritz.box>
 <20111201005220.GG29071@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201005220.GG29071@x200.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11113014-6102-0000-0000-0000004BFD5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 04:52:20PM -0800, Chris Wright wrote:
> * David Gibson (dwg@au1.ibm.com) wrote:
> > On Tue, Nov 29, 2011 at 10:25:51PM -0700, Alex Williamson wrote:
> > > On Wed, 2011-11-30 at 15:51 +1100, Benjamin Herrenschmidt wrote:
> > > > On Wed, 2011-11-30 at 13:42 +1100, David Gibson wrote:
> > > > 
> > > > > > +static ssize_t show_iommu_group(struct device *dev,
> > > > > > +				struct device_attribute *attr, char *buf)
> > > > > > +{
> > > > > > +	unsigned int groupid;
> > > > > > +
> > > > > > +	if (iommu_device_group(dev, &groupid))
> > > > > > +		return 0;
> > > > > > +
> > > > > > +	return sprintf(buf, "%u", groupid);
> > > > > > +}
> > > > > > +static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
> > > > > 
> > > > > Hrm.  Assuming the group is is an unsigned int seems dangerous to me.
> > > > > More seriously, we really want these to be unique across the whole
> > > > > system, but they're allocated by the iommu driver which can't
> > > > > guarantee that if it's not the only one present.  Seems to me it would
> > > > > be safer to have an actual iommu_group structure allocated for each
> > > > > group, and use the pointer to it as the ID to hand around (with NULL
> > > > > meaning "no iommu" / untranslated).  The structure could contain a
> > > > > more human readable - or more relevant to platform documentation - ID
> > > > > where appropriate.
> > > 
> > > Note that iommu drivers are registered per bus_type, so the unique pair
> > > is {bus_type, groupid}, which seems sufficient for vfio.
> > 
> > Hrm.  That's.. far from obvious.  And still breaks down if we have two
> > separate iommus on the same bus type (e.g. two independent PCI host
> > bridges with inbuilt IOMMUs).
> 
> Happens to still work for Intel IOMMU on x86 the way Alex wrote the
> Intel VT-d patch in this series, as well as AMD IOMMU.  The caveat for
> AMD IOMMU is that the groupid generation would break (as-is) once
> there's support for multiple PCI segments.  This is not an inherent
> shortcoming of the groupid mechanism though, just a current limitation
> of AMD IOMMU's implementation.  Alex overloaded B:D.F for those which is
> a convenient id since that maps to the device (or in the case of devices
> behind a PCIe-to-PCI bridge, the requestor ID of all devices behind the
> bridge, or "the group").

"Happens to still work" is not exactly a ringing endorsement.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

