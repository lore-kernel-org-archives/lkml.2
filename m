Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab0IQAbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 20:31:22 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:6592 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753905Ab0IQAbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 20:31:21 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [PATCH] VMware Balloon: rename module
Date: Thu, 16 Sep 2010 17:31:15 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4+; KDE/4.4.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
References: <AANLkTikWmwVvWzRMK7yvtyqYbd4OeeR1nLsP1OAxbnJg@mail.gmail.com> <201009161623.14722.dtor@vmware.com> <AANLkTinokTUuShVEokYyJApj26CBD-q+xma_55rgdZEM@mail.gmail.com>
In-Reply-To: <AANLkTinokTUuShVEokYyJApj26CBD-q+xma_55rgdZEM@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009161731.16913.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 16, 2010 05:13:32 pm Chetan Loke wrote:
> On Thu, Sep 16, 2010 at 7:23 PM, Dmitry Torokhov <dtor@vmware.com> wrote:
> > Hi Chetan,
> 
> Hi
> 
> >> > In an effort to minimize customer confusion we want to unify naming
> >> > convention for VMware-provided kernel modules. This change renames
> >> > the balloon driver from vmware_ballon to vmw_balloon.
> >> 
> >> What will vmtools name its vmware_balloon driver to? vmw_balloon,
> >> correct?
> > 
> > That is the plan.
> 
> I will have to change my scripts/iso's if there's a mismatch. If
> there's a mismatch then will we end up w/ 2 drivers?
> Or will vmtools cleanup the past residue?

Tools should clean up residue - the "upgrade" is actually "ininstall
everything keeping certain configs and install afresh".

> We prep'd a 2.6.35 iso. Now while updating I will have to wrap a
> special case to account for balloon-renaming.
> The case that I'm worried about is this:
> 1) 2.6.35 - vmware_balloon
> 2) upgrade kernel - now vmw_balloon
> 3) install vmtools  - a new vmware_balloon(?) if this version of
> vmtools didn't pick up the change?

The newer tools should pick up the driver regardless of the name as we
are keying off module alias data (which is PCI_IDs for PCI drivers
such as vmxnet3 and vmw_pvscsi and "magic strings" like "vmware_vmmemctl"
for non-PCI drivers).

> Is there a workaround?
> 
> Sorry, not being a pain but we have had some tough time with
> vmtool-upgrades+udev+vmxnet and vnic addition/deletion recently.
> 
> >> > +   vmballoon_wq = create_freezeable_workqueue("vmmemctl");
> >> 
> >> minor change - vmware_vmmemctl?
> > 
> > I do not think this needs to be changed; it does not have to match
> > the module name, plus, given Tejun's changes, it will all be generic
> > [worker/u:X] soon anyway.
> 
> ok.
> 
> >> side note - is it possible to extend the balloon driver to get a
> >> notification on other events? like CPUs, NICs? Just an event is what
> >> I'm looking for. No action need to be taken in the guest.
> > 
> > No, balloon driver should be limited to ballooning. I think the data
> > you are looking for can be retrieved via GuestSDK (and I believe we
> > are adding balloon_target to the available data).
> 
> No. I think the guestSDK provides the guest, it's personal view of the
> world, no?
> http://www.vmware.com/support/developer/guest-sdk/

Right since guest is supposed to be isolated.

There is vSphere SDK that shoudl allow you to connect to the hostd and
get more information about the host/VC:

http://www.vmware.com/support/developer/viperltoolkit/


> 
> ballooning is an indirect hint that an external event has happened
> within the hypervisor. I'm looking for similar external events.
> guestSDK gives nothing. Because right now there is now way for a
> vmware-guest to cooperate or be a good citizen if it
> doesn't know what's happening in the esx-hypervisor. Now whether to
> add these events in the balloon driver is another thing.
> A separate driver is ok too.

I spoke with resource management team regarding this idea of a VM
"helping" ESX and they felt that this task is better left to the
ESX's memory scheduler. The VM in question will not know all the
data needed (it might be confined to a separate resource pool, etc)
to make good decision.

Still you could use Guest SDK - if you see balloon target rising you
may start unlocking memory you grabbed.

-- 
Dmitry
