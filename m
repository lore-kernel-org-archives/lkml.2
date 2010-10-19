Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087Ab0JSSZs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 14:25:48 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:45397 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752599Ab0JSSZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 14:25:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bqCBh2iyss6BtUT4g9zopX5We24v/FTShuUO6u+9hEa5JwwAG7kZCNyWNTDtNHLaM19H6lDbHGM0je6e+LdMxbqR/f1/ag1vRy0Tp6hwywWGT/ieAjNDZ3zH3Cp9Yxni;
Date: Tue, 19 Oct 2010 11:24:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de,
        Yinghai Lu <yinghai@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC v2 PATCH 1/1] PCI: override BIOS/firmware resource
 allocation
Message-ID: <20101019112439.53c4901e@jbarnes-desktop>
In-Reply-To: <20101019171740.GC8437@ram-laptop>
References: <20101006225834.GE2945@ram-laptop>
	<201010081416.57454.bjorn.helgaas@hp.com>
	<20101012070515.GA549@ram-laptop>
	<201010121301.54402.bjorn.helgaas@hp.com>
	<20101018131010.0e4771eb@jbarnes-desktop>
	<20101019171740.GC8437@ram-laptop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 10:17:40 -0700
Ram Pai <linuxram@us.ibm.com> wrote:
> > So where do we stand with this machine's problem?
> 
> I think, this machine with the latest mainline kernel, will see memory resource
> allocation failure messages. Since the latest kernel does not release and retry
> to allocate resources, the io resources allocated by the BIOS continue to stay
> put and hence the problem is masked.
> 
> However, any attempt to release and reallocate the resource on that machine
> will fail; because as pointed out by Bjorn, there is some weird allocation
> behavior in the current code. Unfortunately I cannot trigger that behavior on
> any of my machines. 
> 
> I have requested data from Peter, who originally reported the problem. 
> Hope he still has his setup with the Xonar card available for debugging.
> 
> Anyway, I do see a smoking gun in pbus_size_io() and pbus_size_mem().  They
> call resource_size() to find the size requirement of resources of all devices
> behind the bridge.  However for resources whose start and size are set to zero,
> resource_size() returns one. Later ALIGN() rounds it up to the next higher
> alignment boundary.

Right, if there are no devices with actual sizes behind a given bridge
window we shouldn't bother to allocate space (that may mean
re-allocation later if a device is added, but that needs extra work
anyway).

And like Bjorn said, I/O sizing has special requirements for PCI-PCI
bridges, but for others we may be able to make the windows smaller.

> > Ram, do you have other machines that require your override patch?
> 
> Yes, I have a couple of machines whose BIOS is unaware of SRIOV resources,
> These machines need the override patch. :(

Ok, but hopefully we can make those machines work without extra kernel
options; at worst maybe we can special case SRIOV resources and cause
them to trigger more aggressive reallocation.

> > Until we understand what's failing and why, I'm hesitant to apply a
> > patch that will work around the problem but require an extra kernel
> > parameter.
> 
> We have already come a full circle here.  The original approach was
> reverted because it regressed a platform. Now we are rejecting this
> approach because we want the original approach. 

Well the original approach had several problems:
  - unclear try= parameter
  - undocumented and ad-hoc reallocation behavior
  - poor (well, lack of) overall design

The root of the issue is still that we have poor data on where we're
allowed to put device resources.  Bjorn has been improving this, along
with changing the way we do allocations so as to avoid problem areas,
but ultimately this is the area where we need the most work.

We've tried and failed to add chipset specific drivers to give us safe
ranges, but those just can't keep up with the number of platforms and
variations out there.  On x86, I think the only reasonable approach is
to use the platforms as designed, i.e. use the resources Windows uses
and in the way Windows uses them.  Anything else just means we'll be
playing catch up.

As special cases arise (i.e. ways we use the platform that depart from
its original design and Windows version), as I suspect this SRIOV issue
is, we may need to apply additional conditions.  But I'd like to avoid
that if at all possible.

So on that note, does Windows on these machines support allocation of
SRIOV resources?  If so, how is it handled?  Which resource ranges are
used for the extra BARs?

-- 
Jesse Barnes, Intel Open Source Technology Center
