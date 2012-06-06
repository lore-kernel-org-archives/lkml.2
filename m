Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758035Ab2FFTmc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 15:42:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35525 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab2FFTm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 15:42:29 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Khalid Aziz <khalid.aziz@hp.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org
References: <20120427190033.GA17588@ldl.usa.hp.com>
	<20120606135009.GB1517@srcf.ucam.org>
	<1338999463.25761.630.camel@lyra>
	<20120606162703.GA6779@srcf.ucam.org>
	<1339003956.25761.667.camel@lyra>
	<20120606174202.GA8750@srcf.ucam.org>
	<1339006060.25761.689.camel@lyra>
Date: Wed, 06 Jun 2012 12:42:07 -0700
In-Reply-To: <1339006060.25761.689.camel@lyra> (Khalid Aziz's message of "Wed,
	06 Jun 2012 12:07:40 -0600")
Message-ID: <87obowxm5s.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18rH3n/5UQR5OLXX8rQbA96yDJ3ipATTso=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_XMDrugObfuBody_00 obfuscated drug references
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Khalid Aziz <khalid.aziz@hp.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Khalid Aziz <khalid.aziz@hp.com> writes:

> On Wed, 2012-06-06 at 18:42 +0100, Matthew Garrett wrote:
>> On Wed, Jun 06, 2012 at 11:32:36AM -0600, Khalid Aziz wrote:
>> 
>> > Do we agree that if device shutdown routine cleanly shuts down all I/O,
>> > clearing PCI Bus Mster bit should be safe?
>> 
>> In the absence of hardware that dislikes the bus master bit ever being 
>> disabled, yes. Do we know if hardware is ever tested in that situation?
>
> I will wait for device vendors to comment on that. I can't claim I have
> tested more than a few devices that way.

Testing is easy.  kexec into a new kernel.  Shrug.  A long standing
useful kernel feature.  In all other cases I expec the firmware triggers
a board level reset of the hardware to avoid issues during reboot.

>> > If yes, then we only have to deal with broken devices. So the approach 
>> > could be to disable Bus Master bit unless the device ID matches a 
>> > blacklist which we update as we find broken devices. I really don't 
>> > like the idea of maintaining blacklists in the kernel for such things 
>> > but is that a more practical approach? If blacklist does not sound 
>> > good, maybe we can ask drivers to tell PCI subsystem if they are not 
>> > ok with clearing Bus Master bit and then PCI subsystem could skip 
>> > those devices.
>> 
>> Or we could just put responsibility on the drivers to ensure that the 
>> hardware won't continue doing any DMA, either by shutting down the 
>> engines or clearing the bit.

Where the responsibily has squarely been for the last decade, and we
still have issues in the common case.

> I assume device shutdown routine should stop all I/O and shutting down
> DMA engine. Disabling Bus Master bit is just an extra measure of safety.
> I do like the idea of disabling Bus Master bit in device shutdown
> routine. After all, drivers know their hardware best. On the other hand,
> it is change to lots of driver code to implement this which means it
> will end up happening slowly over period of time. I don't mind doing the
> work up front on a good number of drivers I feel comfortable modifying.
> I am ok with pulling out code to clear bus master bit from PCI subsystem
> and replacing it with modified shutdown routines for a few drivers to
> start with.

Absent anyone even knowing if there are devices that exist that can not
tolerate their bus master bit being flipped when DMA is not ongoing I
think the current state of the code is good.  When we find the broken
hardware that can not tolerate a standard PCI bit being used in a
standard way we can add a flag in the core to avoid doing that.

pci_device_shutdown calls drv->shutdown before calling
pci_device_disable.  Which means that only devices that have trouble
with this bit being flipped while DMA is ongoing and don't bother
to stop their own DMA will have a problem.

As for shifting problems I do think we have shifted the problem in a
very positive way.  Now instead of having a random failure at a random
location caused by DMA happing at a random moment for no expected reason
we have failures happening when we disable or enable a device, which
should be much more debugable.

If we encounter devices that can't have their bus master bit disabled at
all we can move that functionality into the drivers or add some sort of
flag so that pci_device_shutdown avoids this on real hardware.

> Does any one see any other issues with modifying driver shutdown
> routines for disabling Bus Master bit? Bjorn, any opinions?

I don't have a problem with moving it all of the way into the drivers
I just think it might be a little bit silly at this point.

Ultimately I don't see the complaint raised by this thread.  Either
the drivers for the broadcom devices in questoin are buggy before we
added the pci_disable_device or those drivers are not buggy.

If we really want to do something to reduce the testing burden and make
certain things work better in general we need to merge the device
shutdown and the device remove methods.  Shrug.  People keep getting
squeamish when I suggest that.

Eric
