Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1LACFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 21:05:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1LACFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 21:05:24 -0500
Date: Wed, 30 Nov 2011 18:05:10 -0800
From: Chris Wright <chrisw@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Chris Wright <chrisw@redhat.com>, David Gibson <dwg@au1.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
Message-ID: <20111201020510.GJ29071@x200.localdomain>
References: <20111021195412.8438.9951.stgit@s20.home>
 <20111021195605.8438.81609.stgit@s20.home>
 <20111130024205.GF5435@truffala.fritz.box>
 <1322628672.21641.39.camel@pasglop>
 <1322630751.19120.222.camel@bling.home>
 <20111201000337.GA5427@truffala.fritz.box>
 <20111201005220.GG29071@x200.localdomain>
 <20111201005725.GE5427@truffala.fritz.box>
 <20111201010408.GH29071@x200.localdomain>
 <1322704207.3729.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322704207.3729.10.camel@pasglop>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> On Wed, 2011-11-30 at 17:04 -0800, Chris Wright wrote:
> > Heh.  Put it another way.  Generating the group ID is left up to the
> > IOMMU.  This will break down when there's a system with multiple IOMMU's
> > on the same bus_type that don't have any awareness of one another.  This
> > is not the case for the existing series and x86 hw.
> > 
> > I'm not opposed to doing the allocation and ptr as id (taking care for
> > possibility that PCI hotplug/unplug/replug could reuse the same memory
> > for group id, however).  Just pointing out that the current system works
> > as is, and there's some value in it's simplicity (overloading ID ==
> > group structure + pretty printing ID in sysfs, for example). 
> 
> Well, ID can work even with multiple domains since we have domains
> numbers. bdfn is 16-bit, which leaves 16-bit for the domain number,
> which is sufficient.
> 
> So by encoding (domain << 16) | bdfn, we can get away with a 32-bit
> number... it just sucks.

Yup, that's just what Alex did for VT-d ;)

+	union {
+               struct {
+                       u8 devfn;
+                       u8 bus;
+                       u16 segment;
+               } pci;
+               u32 group;
+	} id;

Just that the alias table used for AMD IOMMU to map bdf -> requestor ID
is not multi-segment aware, so the id is only bdf of bridge.

> Note that on pseries, I wouldn't use bdfn anyway, I would use my
> internal "PE#" which is also a number that I can constraint to 16-bits.
> 
> So I can work with a number as long as it's at least an unsigned int
> (32-bit), but I think it somewhat sucks, and will impose gratuituous
> number <-> structure conversions all over, but if we keep the whole
> group thing an iommu specific data structure, then let's stick to the
> number and move on with life.
> 
> We might get better results if we kept the number as
> 
> struct iommu_group_id {
> 	u16	domain;
> 	u16	group;
> };
> 
> (Or a union of that with an unsigned int)
> 
> That way the domain information is available generically (can be match
> with pci_domain_nr() for example), and sysfs can then be layed out as
> 
> /sys/bus/pci/groups/<domain>/<id>
> 
> Which is nicer than having enormous id's

Seems fine to me (although I missed /sys/bus/pci/groups/ introduction),
except that I think the freescale folks aren't interested in PCI which
is one reason why the thing is just an opaque id.

thanks,
-chris
