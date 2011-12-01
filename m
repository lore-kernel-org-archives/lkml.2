Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab1LAVqz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 16:46:55 -0500
Received: from gate.crashing.org ([63.228.1.57]:36028 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab1LAVqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 16:46:54 -0500
Message-ID: <1322775989.3729.35.camel@pasglop>
Subject: Re: [PATCH 1/4] iommu: Add iommu_device_group callback and
 iommu_group sysfs entry
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, David Gibson <dwg@au1.ibm.com>,
        joerg.roedel@amd.com, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, chrisw@redhat.com, agraf@suse.de,
        scottwood@freescale.com, B08248@freescale.com
Date: Fri, 02 Dec 2011 08:46:29 +1100
In-Reply-To: <1322750048.26545.101.camel@bling.home>
References: <20111021195412.8438.9951.stgit@s20.home>
	 <20111021195605.8438.81609.stgit@s20.home>
	 <20111130024205.GF5435@truffala.fritz.box>
	 <1322628672.21641.39.camel@pasglop> <1322630751.19120.222.camel@bling.home>
	 <20111201000337.GA5427@truffala.fritz.box>
	 <1322722110.26545.68.camel@bling.home>
	 <1322735610.24294.9.camel@i7.infradead.org>
	 <1322750048.26545.101.camel@bling.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 07:34 -0700, Alex Williamson wrote:

> We've got multiple levels when we add qemu and guests into the mix.  A
> group is the smallest assignable unit for kernel->userspace.  In fact,
> vfio is constructed so that the user cannot do anything with a group
> until all the devices of the group are bound to the vfio bus drivers.
> Qemu, as a userspace driver, must therefore take ownership of the entire
> group.  However, there's no requirement that a userspace driver must
> make use of all the devices in the group, so qemu is free to expose
> individual devices from the group to the guest.

Sure but that has nothing to do with your kernel->user API. As you said,
you still need to take "ownership" of the entire group. If qemu chose to
only present to the guest part of that group, it's qemu's problem.

Put it differently. One day, maybe, we'll finally get some clues and
implement a proper way for admin tools to know what can or cannot be put
into a guest. In any case, how would you present to the user
(administrator) the groups ? By individual devices with odd behaviours /
errors etc... when the said user/admin tries to put individual devices
into different partitions while  they belong in the same group ? Or by
just exposing ... groups ?

So while those various tools will want to see what's in the group (to
represent it to the user, to expose it to the guest, for other finer
grained operations such as MSI setup, etc...) the basic unit of
ownership is and remains the group, and I don't see how it makes sense
to have your underlying iommu interface operate on anything else.

>   IMHO, it doesn't make
> sense to have a default model saying "I know you just wanted the nic,
> but it's in the same group as this graphics card, so surprise, you get
> both!".  Obviously if a user does want to expose multiple devices from a
> group to a guest, we support that too.

No you don't get it. That's the wrong way around. The user will be
presented to start with with a group of nic+graphics card so that user
knows from the beginning what's going on.

Because your other option is to put the nic in ... and suddenly have the
graphic card go away from the host without showing up in a guest. That
won't be any better than having it "just show up" in the guest without
asking for it.

IE. In both cases, it's wrong. The only thing that makes sense is from
the beginning, expose those two as a group so that the user has no other
choice but put them both into the guest at once and have it represented
to the user as such to begin with.

> Spitting groups among multiple VMs or between VM and native host drivers
> defeats the purpose of the group.  Neither of these are allowed.
> 
> > Btw, did we get a quirk for the Ricoh multi-function devices which all
> > need to be in the same group because they do all their DMA from function
> > zero? I think we need another similar quirk for a Marvell SATA
> > controller which seems to do its AHCI DMA from its IDE function; see
> > https://bugzilla.redhat.com/757166
> 
> No, as I mentioned, groups are currently for iommu_ops, not dma_ops,
> though it makes sense that iommu drivers could use the group info or
> create common quirk infrastructure for handling broken devices like
> these.  Thanks,

Which is why the group info in iommu_ops should just be a representation
of something else under the hood that needs to be sorted out more
clearly than what we are doing at the moment.

Cheers,
Ben.


