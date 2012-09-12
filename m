Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab2ILFNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 01:13:45 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50224 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab2ILFNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 01:13:43 -0400
MIME-Version: 1.0
In-Reply-To: <201209120058.16701.rjw@sisk.pl>
References: <201209112255.10486.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org>
	<CAPM=9tzp8MnoGttxB=WrOZ8nMAESJn_0GAHT84PdmSgri==aCA@mail.gmail.com>
	<201209120058.16701.rjw@sisk.pl>
Date: Wed, 12 Sep 2012 15:13:40 +1000
Message-ID: <CAPM=9twQJSCX64kYsAikteZoJOH9m8e6AWuj-e_Ouyk3HmyOuQ@mail.gmail.com>
Subject: Re: runtime PM and special power switches
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 8:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Wednesday, September 12, 2012, Dave Airlie wrote:
>> On Wed, Sep 12, 2012 at 7:32 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
>> > On Tue, 11 Sep 2012, Rafael J. Wysocki wrote:
>> >
>> >> Hi,
>> >>
>> >> On Tuesday, September 11, 2012, Dave Airlie wrote:
>> >> > Hi Rafael,
>> >> >
>> >> > I've been investigating runtime PM support for some use-cases on GPUs.
>> >> >
>> >> > In some laptops we have a secondary GPU (optimus) that can be powered
>> >> > up for certain 3D tasks and then turned off when finished with. Now I
>> >> > did an initial pass on supporting it without using the kernel runtime
>> >> > PM stuff, but Alan said I should take a look so here I am.
>> >>
>> >> Alan Stern or Alan Cox? :-)
>> >>
>> >> > While I've started to get a handle on things, we have a bit of an
>> >> > extra that I'm not sure we cater for.
>> >> >
>> >> > Currently we get called from the PCI layer which after we are finished
>> >> > with our runtime suspend callback, will go put the device into the
>> >> > correct state etc, however on these optimus/powerxpress laptops we
>> >> > have a separate ACPI or platform driver controlled power switch that
>> >> > we need to call once the PCI layer is finished the job. This switch
>> >> > effectively turns the power to the card completely off leaving it
>> >> > drawing no power.
>> >> >
>> >> > No we can't hit the switch from the driver callback as the PCI layer
>> >> > will get lost, so I'm wondering how you'd envisage we could plug this
>> >> > in.
>> >>
>> >> Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
>> >> doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
>> >> set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
>> >> so perhaps it's not even too dangerous.
>> >
>> > This sounds more like a job for a power domain.  Unless the power
>> > switch is already in the device hierarchy as a parent to the PCI
>> > device.
>>
>> I'll have to investigate power domains then,
>>
>> The switch is hidden in many different places, one some laptops its in
>> a ACPI _DSM on one GPU, on others its in an ACPI _DSM on the other
>> one, in some its in a different ACPI _DSM, then we have it in the ACPI
>> ATPX method on others, and finally Apple have it in a piece of hw that
>> isn't just on the LPC bus or somewhere like that.
>>
>> Currently we just hide it all inside vga_switcheroo and I'd just need
>> an interface to call that once the layers have stopped poking
>> registers in PCI config space, if we could fix PCI runtime suspend so
>> the driver was the last to g 2et called then that would also not suck.
>
> Well, as I said, we may try to change the PCI layer so that it doesn't
> access the device any more in pci_pm_runtime_suspend() if it sees that
> pci_dev->state_saved has been set by the driver's callback.  Then,
> your drivers would only need to set pci_dev->state_saved in their
> .runtime_suspend() callbacks.
>

Actually it appears I'll need this, I'd forgotten things are a bit
messier than I thought

So there are two variants on the _DSM for nvidia dual-gpu machines,
the older pre-optimus _DSM requires
an explicit power off call post-D3, however for optimus _DSM the D3
transition will flick the power switch, however
the pci code then goes and seem to turn the device back to D0 for some
reason. So yes after save state,
I'd really appreciate if it the pci layer would stop poking my device.

> Alternatively, which may be less hackish but more work, you can set the
> pm_domain pointer in the device structure to a struct dev_pm_domain whose
> ops will just call the corresponding bus type's ops except for
> .runtime_suspend() that will execute the additional ACPI stuff after calling
> the bus type's method.

I've mostly written this, and it seems to work, I've jsut set a
pm_domain in the vga switcheroo code that copies the dev->bus->pm
into a private structure. I'll need this for the old nvidia and radeon
poweroffs.

Dave.
