Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab1LAH2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 02:28:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28907 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1LAH2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 02:28:40 -0500
Message-ID: <1322724505.26545.85.camel@bling.home>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Alex Williamson <alex.williamson@redhat.com>
To: Chris Wright <chrisw@redhat.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Gibson <dwg@au1.ibm.com>, joerg.roedel@amd.com,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, agraf@suse.de, scottwood@freescale.com,
        B08248@freescale.com
Date: Thu, 01 Dec 2011 00:28:25 -0700
In-Reply-To: <20111201020510.GJ29071@x200.localdomain>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
	 <20111201005220.GG29071@x200.localdomain>
	 <20111201005725.GE5427@truffala.fritz.box>
	 <20111201010408.GH29071@x200.localdomain>
	 <1322704207.3729.10.camel@pasglop>
	 <20111201020510.GJ29071@x200.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 18:05 -0800, Chris Wright wrote:
> * Benjamin Herrenschmidt (benh@kernel.crashing.org) wrote:
> > On Wed, 2011-11-30 at 17:04 -0800, Chris Wright wrote:
> > > Heh.  Put it another way.  Generating the group ID is left up to the
> > > IOMMU.  This will break down when there's a system with multiple IOMMU's
> > > on the same bus_type that don't have any awareness of one another.  This
> > > is not the case for the existing series and x86 hw.
> > > 
> > > I'm not opposed to doing the allocation and ptr as id (taking care for
> > > possibility that PCI hotplug/unplug/replug could reuse the same memory
> > > for group id, however).  Just pointing out that the current system works
> > > as is, and there's some value in it's simplicity (overloading ID ==
> > > group structure + pretty printing ID in sysfs, for example). 
> > 
> > Well, ID can work even with multiple domains since we have domains
> > numbers. bdfn is 16-bit, which leaves 16-bit for the domain number,
> > which is sufficient.
> > 
> > So by encoding (domain << 16) | bdfn, we can get away with a 32-bit
> > number... it just sucks.
> 
> Yup, that's just what Alex did for VT-d ;)
> 
> +	union {
> +               struct {
> +                       u8 devfn;
> +                       u8 bus;
> +                       u16 segment;
> +               } pci;
> +               u32 group;
> +	} id;
> 
> Just that the alias table used for AMD IOMMU to map bdf -> requestor ID
> is not multi-segment aware, so the id is only bdf of bridge.
> 
> > Note that on pseries, I wouldn't use bdfn anyway, I would use my
> > internal "PE#" which is also a number that I can constraint to 16-bits.
> > 
> > So I can work with a number as long as it's at least an unsigned int
> > (32-bit), but I think it somewhat sucks, and will impose gratuituous
> > number <-> structure conversions all over, but if we keep the whole
> > group thing an iommu specific data structure, then let's stick to the
> > number and move on with life.

I think you're over emphasizing these number <-> struct conversions.
Nowhere in the iommu/driver core code is there a need for this.  It's a
simple struct device -> groupid translation.  Even in the vfio code we
only need to do lookups based on groupid rarely and never in anything
resembling a performance path.
 
> > We might get better results if we kept the number as
> > 
> > struct iommu_group_id {
> > 	u16	domain;
> > 	u16	group;
> > };
> > 
> > (Or a union of that with an unsigned int)
> > 
> > That way the domain information is available generically (can be match
> > with pci_domain_nr() for example), and sysfs can then be layed out as
> > 
> > /sys/bus/pci/groups/<domain>/<id>
> > 
> > Which is nicer than having enormous id's
> 
> Seems fine to me (although I missed /sys/bus/pci/groups/ introduction),
> except that I think the freescale folks aren't interested in PCI which
> is one reason why the thing is just an opaque id.

I missed the /sys/bus/pci/groups/ introduction as well.  Groupids are
not PCI specific.  FWIW, the current sysfs representation looks
something like this:

$ cat /sys/bus/pci/devices/0000:01:10.6/iommu_group 
384

$ ls -l /sys/devices/virtual/vfio/pci:384
total 0
-r--r--r-- 1 root root 4096 Nov 30 16:25 dev
drwxr-xr-x 2 root root    0 Nov 30 16:25 devices
drwxr-xr-x 2 root root    0 Nov 30 16:25 power
lrwxrwxrwx 1 root root    0 Nov 30 16:24 subsystem -> ../../../../class/vfio
-rw-r--r-- 1 root root 4096 Nov 30 16:24 uevent

$ cat /sys/devices/virtual/vfio/pci:384/dev
252:28

$ ls -l /dev/vfio/pci:384
crw-rw---- 1 root root 252, 28 Nov 30 16:24 /dev/vfio/pci:384

$ ls -l /sys/devices/virtual/vfio/pci:384/devices
total 0
lrwxrwxrwx 1 root root 0 Nov 30 16:36 0000:01:10.0 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.0
lrwxrwxrwx 1 root root 0 Nov 30 16:25 0000:01:10.1 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.1
lrwxrwxrwx 1 root root 0 Nov 30 16:36 0000:01:10.2 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.2
lrwxrwxrwx 1 root root 0 Nov 30 16:25 0000:01:10.3 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.3
lrwxrwxrwx 1 root root 0 Nov 30 16:36 0000:01:10.4 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.4
lrwxrwxrwx 1 root root 0 Nov 30 16:25 0000:01:10.5 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.5
lrwxrwxrwx 1 root root 0 Nov 30 16:36 0000:01:10.6 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.6
lrwxrwxrwx 1 root root 0 Nov 30 16:25 0000:01:10.7 -> ../../../../pci0000:00/0000:00:01.0/0000:01:10.7

$ for i in $(find /sys/devices/virtual/vfio/pci:384/devices/ -type l); do cat $i/iommu_group; echo; done
384
384
384
384
384
384
384
384

I'm a little annoyed with the pci:384 notation, but that seems like how
it works out best for using {bus_type, groupid}.  Thanks,

Alex

