Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751102Ab2IKWYI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:24:08 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52689 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2IKWXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:23:33 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org>
References: <201209112255.10486.rjw@sisk.pl>
	<Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org>
Date: Wed, 12 Sep 2012 08:23:32 +1000
Message-ID: <CAPM=9tzp8MnoGttxB=WrOZ8nMAESJn_0GAHT84PdmSgri==aCA@mail.gmail.com>
Subject: Re: runtime PM and special power switches
From: Dave Airlie <airlied@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 7:32 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 11 Sep 2012, Rafael J. Wysocki wrote:
>
>> Hi,
>>
>> On Tuesday, September 11, 2012, Dave Airlie wrote:
>> > Hi Rafael,
>> >
>> > I've been investigating runtime PM support for some use-cases on GPUs.
>> >
>> > In some laptops we have a secondary GPU (optimus) that can be powered
>> > up for certain 3D tasks and then turned off when finished with. Now I
>> > did an initial pass on supporting it without using the kernel runtime
>> > PM stuff, but Alan said I should take a look so here I am.
>>
>> Alan Stern or Alan Cox? :-)
>>
>> > While I've started to get a handle on things, we have a bit of an
>> > extra that I'm not sure we cater for.
>> >
>> > Currently we get called from the PCI layer which after we are finished
>> > with our runtime suspend callback, will go put the device into the
>> > correct state etc, however on these optimus/powerxpress laptops we
>> > have a separate ACPI or platform driver controlled power switch that
>> > we need to call once the PCI layer is finished the job. This switch
>> > effectively turns the power to the card completely off leaving it
>> > drawing no power.
>> >
>> > No we can't hit the switch from the driver callback as the PCI layer
>> > will get lost, so I'm wondering how you'd envisage we could plug this
>> > in.
>>
>> Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
>> doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
>> set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
>> so perhaps it's not even too dangerous.
>
> This sounds more like a job for a power domain.  Unless the power
> switch is already in the device hierarchy as a parent to the PCI
> device.

I'll have to investigate power domains then,

The switch is hidden in many different places, one some laptops its in
a ACPI _DSM on one GPU, on others its in an ACPI _DSM on the other
one, in some its in a different ACPI _DSM, then we have it in the ACPI
ATPX method on others, and finally Apple have it in a piece of hw that
isn't just on the LPC bus or somewhere like that.

Currently we just hide it all inside vga_switcheroo and I'd just need
an interface to call that once the layers have stopped poking
registers in PCI config space, if we could fix PCI runtime suspend so
the driver was the last to get called then that would also not suck.

Dave.
