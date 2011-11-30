Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1K3Ev7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 23:51:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:35600 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390Ab1K3Ev6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 23:51:58 -0500
Message-ID: <1322628672.21641.39.camel@pasglop>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Gibson <dwg@au1.ibm.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Wed, 30 Nov 2011 15:51:12 +1100
In-Reply-To: <20111130024205.GF5435@truffala.fritz.box>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 13:42 +1100, David Gibson wrote:

> > +static ssize_t show_iommu_group(struct device *dev,
> > +				struct device_attribute *attr, char *buf)
> > +{
> > +	unsigned int groupid;
> > +
> > +	if (iommu_device_group(dev, &groupid))
> > +		return 0;
> > +
> > +	return sprintf(buf, "%u", groupid);
> > +}
> > +static DEVICE_ATTR(iommu_group, S_IRUGO, show_iommu_group, NULL);
> 
> Hrm.  Assuming the group is is an unsigned int seems dangerous to me.
> More seriously, we really want these to be unique across the whole
> system, but they're allocated by the iommu driver which can't
> guarantee that if it's not the only one present.  Seems to me it would
> be safer to have an actual iommu_group structure allocated for each
> group, and use the pointer to it as the ID to hand around (with NULL
> meaning "no iommu" / untranslated).  The structure could contain a
> more human readable - or more relevant to platform documentation - ID
> where appropriate.

Don't forget that to keep sanity, we really want to expose the groups
via sysfs (per-group dir with symlinks to the devices).

I'm working with Alexey on providing an in-kernel powerpc specific API
to expose the PE stuff to whatever's going to interface to VFIO to
create the groups, though we can eventually collapse that. The idea is
that on non-PE capable brigdes (old style), I would make a single group
per host bridge.

In addition, Alex, I noticed that you still have the domain stuff there,
which is fine I suppose, we could make it a requirement on power that
you only put a single group in a domain... but the API is still to put
individual devices in a domain, not groups, and that somewhat sucks.

You could "fix" that by having some kind of ->domain_enable() or
whatever that's used to "activate" the domain and verifies that it
contains entire groups but that looks like a pointless way to complicate
both the API and the implementation.

Cheers,
Ben.


