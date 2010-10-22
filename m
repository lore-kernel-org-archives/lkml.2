Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754566Ab0JVA3J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 20:29:09 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48452 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab0JVA3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 20:29:07 -0400
Date: Thu, 21 Oct 2010 17:28:51 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource
 allocation
Message-ID: <20101022002851.GB24820@ram-laptop>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20101006225834.GE2945@ram-laptop>
 <201010081416.57454.bjorn.helgaas@hp.com>
 <20101012070515.GA549@ram-laptop>
 <201010121301.54402.bjorn.helgaas@hp.com>
 <20101018131010.0e4771eb@jbarnes-desktop>
 <20101019171740.GC8437@ram-laptop>
 <20101019112439.53c4901e@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019112439.53c4901e@jbarnes-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:24:39AM -0700, Jesse Barnes wrote:
> On Tue, 19 Oct 2010 10:17:40 -0700
> Ram Pai <linuxram@us.ibm.com> wrote:
> > > So where do we stand with this machine's problem?
> > 
> > I think, this machine with the latest mainline kernel, will see memory resource
> > allocation failure messages. Since the latest kernel does not release and retry
> > to allocate resources, the io resources allocated by the BIOS continue to stay
> > put and hence the problem is masked.
> > 
> > However, any attempt to release and reallocate the resource on that machine
> > will fail; because as pointed out by Bjorn, there is some weird allocation
> > behavior in the current code. Unfortunately I cannot trigger that behavior on
> > any of my machines. 
> > 
> > I have requested data from Peter, who originally reported the problem. 
> > Hope he still has his setup with the Xonar card available for debugging.
> > 
> > Anyway, I do see a smoking gun in pbus_size_io() and pbus_size_mem().  They
> > call resource_size() to find the size requirement of resources of all devices
> > behind the bridge.  However for resources whose start and size are set to zero,
> > resource_size() returns one. Later ALIGN() rounds it up to the next higher
> > alignment boundary.
> 
> Right, if there are no devices with actual sizes behind a given bridge
> window we shouldn't bother to allocate space (that may mean
> re-allocation later if a device is added, but that needs extra work
> anyway).
> 
> And like Bjorn said, I/O sizing has special requirements for PCI-PCI
> bridges, but for others we may be able to make the windows smaller.

Ok. After further investigation, I find that the BIOS has not allocated any
resource to hotplug bridges that have no devices behind them. However
the OS tries to allocate some minimal resources, 4096 I/O ports and 2M mem
window, to the these hotplug bridges but fails because there are not enough
resources to satisfy all the hotplug bridges.

This issue exists even today with the latest mainline kernel but is masked
because no devices are really effected. However Yinghai's reallocation patch
exposed the issue, since it released the BIOS allocated window and tried to
reallocate. Unfortunately it ended up allocating in the wrong order. The
bridges with real devices got no resources, where as the hotplug bridges with
no devices got some mimimal resources.

The details are captured at: https://bugzilla.kernel.org/show_bug.cgi?id=15960

I suppose the solution is to not pre-allocate resources to hotplug bridges that
have no devices behind them, and then bring back Yinghai's reallocation patch.  

Do you agree with the approach?

My concern is some, including Linus, might consider this as plugging yet
another hole, with no gaurantees that it will not-regress any other platform.

I hope Linus is listening.

> 
> > > Ram, do you have other machines that require your override patch?
> > 
> > Yes, I have a couple of machines whose BIOS is unaware of SRIOV resources,
> > These machines need the override patch. :(
> 
> Ok, but hopefully we can make those machines work without extra kernel
> options; at worst maybe we can special case SRIOV resources and cause
> them to trigger more aggressive reallocation.
> 
> > > Until we understand what's failing and why, I'm hesitant to apply a
> > > patch that will work around the problem but require an extra kernel
> > > parameter.
> > 
> > We have already come a full circle here.  The original approach was
> > reverted because it regressed a platform. Now we are rejecting this
> > approach because we want the original approach. 
> 
> Well the original approach had several problems:
>   - unclear try= parameter
>   - undocumented and ad-hoc reallocation behavior
>   - poor (well, lack of) overall design
> 
> The root of the issue is still that we have poor data on where we're
> allowed to put device resources.  Bjorn has been improving this, along
> with changing the way we do allocations so as to avoid problem areas,
> but ultimately this is the area where we need the most work.
> 
> We've tried and failed to add chipset specific drivers to give us safe
> ranges, but those just can't keep up with the number of platforms and
> variations out there.  On x86, I think the only reasonable approach is
> to use the platforms as designed, i.e. use the resources Windows uses
> and in the way Windows uses them.  Anything else just means we'll be
> playing catch up.
> 
> As special cases arise (i.e. ways we use the platform that depart from
> its original design and Windows version), as I suspect this SRIOV issue
> is, we may need to apply additional conditions.  But I'd like to avoid
> that if at all possible.
> 
> So on that note, does Windows on these machines support allocation of
> SRIOV resources?  If so, how is it handled?  Which resource ranges are
> used for the extra BARs?

No. I have not tried windows on these boxes. But last I heard windows
did not support SRIOV. Does it?

RP
