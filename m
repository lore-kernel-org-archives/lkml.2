Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1LAOeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:34:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1LAOeW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:34:22 -0500
Message-ID: <1322750048.26545.101.camel@bling.home>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Alex Williamson <alex.williamson@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: David Gibson <dwg@au1.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Thu, 01 Dec 2011 07:34:08 -0700
In-Reply-To: <1322735610.24294.9.camel@i7.infradead.org>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
	 <1322722110.26545.68.camel@bling.home>
	 <1322735610.24294.9.camel@i7.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 10:33 +0000, David Woodhouse wrote:
> On Wed, 2011-11-30 at 23:48 -0700, Alex Williamson wrote:
> > I'm not sure if we're getting into VM usage with "assigning" terminology
> > above.  You're free to architect qemu however you want on POWER to make
> > groups be the assignable unit to a guest.  On x86, an individual device
> > is the assignable unit for a guest.  Unassigned group devices will still
> > be required to be held by vfio, they'll just be unused.  Thanks,
> 
> I'm not sure I understand this.
> 
> BY DEFINITION, the smallest assignable unit is the group, surely? Isn't
> that the *point* of the groups? That the IOMMU cannot tell the
> difference between the devices in the group?
> 
> So in *practice*, surely you cannot assign just *one* device from a
> group? You can assign the while group, or nothing.
> 
> You might *pretend* to assign single devices, and we might try to cope
> with the weirdness that happens when you want *one* device of a group to
> be owned by one VM, another device in the same group to be owned by a
> second VM, and a third device from the same group to be driven by a
> native driver in the host. But why not just assign groups as a whole?
> Surely that makes most sense?

We've got multiple levels when we add qemu and guests into the mix.  A
group is the smallest assignable unit for kernel->userspace.  In fact,
vfio is constructed so that the user cannot do anything with a group
until all the devices of the group are bound to the vfio bus drivers.
Qemu, as a userspace driver, must therefore take ownership of the entire
group.  However, there's no requirement that a userspace driver must
make use of all the devices in the group, so qemu is free to expose
individual devices from the group to the guest.  IMHO, it doesn't make
sense to have a default model saying "I know you just wanted the nic,
but it's in the same group as this graphics card, so surprise, you get
both!".  Obviously if a user does want to expose multiple devices from a
group to a guest, we support that too.

Spitting groups among multiple VMs or between VM and native host drivers
defeats the purpose of the group.  Neither of these are allowed.

> Btw, did we get a quirk for the Ricoh multi-function devices which all
> need to be in the same group because they do all their DMA from function
> zero? I think we need another similar quirk for a Marvell SATA
> controller which seems to do its AHCI DMA from its IDE function; see
> https://bugzilla.redhat.com/757166

No, as I mentioned, groups are currently for iommu_ops, not dma_ops,
though it makes sense that iommu drivers could use the group info or
create common quirk infrastructure for handling broken devices like
these.  Thanks,

Alex

