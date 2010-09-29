Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0I2A0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 20:26:35 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48079 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0I2A0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 20:26:33 -0400
Date: Wed, 29 Sep 2010 01:26:32 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: huang ying <huang.ying.caritas@gmail.com>
cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 3/6] x86, NMI, Rename memory parity error to PCI SERR
 error
In-Reply-To: <AANLkTineDMoGdtZUnnDKxCo_Xreud2MUWWn0GR7iDgAa@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1009290048130.21189@eddie.linux-mips.org>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>        <1284087065-32722-3-git-send-email-ying.huang@intel.com>        <alpine.LFD.2.00.1009212333280.6717@eddie.linux-mips.org>
 <AANLkTineDMoGdtZUnnDKxCo_Xreud2MUWWn0GR7iDgAa@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

> >  Things perhaps changed over the last few years while I have not been
> > watching, but for many years the bit #7 of the NMI status port
> > (implemented by the southbridge at 0x61 in the port I/O space) was still
> > used for memory parity or ECC errors even after the original IBM PC/AT.
> > The usual arrangement was in the event of a memory error the memory
> > controller in the northbridge would assert the chip's PCI SERR output
> > line, which in turn would be trapped by the southbridge and converted to
> > an NMI event while setting the said bit in the NMI status port.  See e.g.
> > the 82349HX System Controller datasheet (Intel document number 290551).
> 
> Thanks for your information. So EDAC function call in NMI handler
> should be kept?

 I've seen EDAC mentioned before, but I lack further details as to what it 
is -- if you give me a link to the relevant piece of documentation, then 
I'll see if I can find some time to look into it.  Otherwise I can't 
comment on it, sorry.

> But as you pointed out, the function name of
> corresponding handler should be PCI SERR instead of memory parity. It
> just can be used to report memory error on some system. I think we can
> rename the function and string to PCI SERR and add some comments for
> EDAC function call that checks memory errors.

 Linux can certainly run on pre-PCI x86 machines; while I agree it makes 
sense to update the references to match reality, I think you need to be 
careful about it.  "A memory or system error" might be a good compromise 
-- mentioning parity explicitly may not be a good idea; I'm sure there 
must have been ECC x86 systems made even before PCI (think EISA -- these 
often were quite sophisticated; unsure about IBM's MCA).

 Otherwise if you think you absolutely *must* mention "PCI SERR" where 
relevant, then I suggest that you investigate how to determine whether the 
kernel is running on a PCI system (something along the lines of 
(CONFIG_PCI && pci_host_bridge_found)) and adjust the message accordingly 
based on actual configuration.

> >  So the name of the error reported is not that unjustified except, of
> > course, to be precise the handler would have to scan the state of the SERR
> > output reported by all the PCI devices in the PCI configuration space to
> > find the originator and then interpret the event accordingly.  Which
> > obviously means the only piece of code that could exactly know what the
> > reason was is the respective device driver as causes of SERR are
> > device-specific and may require processing of device-specific registers to
> > determine the cause and/or recover (a device reset may be required in some
> > cases).
> 
> In addition to PCI SERR, I think modern system rely more on PCIE AER,
> which can report more information about error. There are recovery
> support for PCIE AER in kernel already. Do we need some similar
> mechanism for PCI SERR? Because PCIE AER becomes more and more common
> on server platform, I think some minimal check such as scaning devices
> SERR/PERR bit should be sufficient.

 Even you you don't care about 1990s' vintage computers (which you have 
the right not to) I'd expect legacy PCI/PCI-X to stay around for a while 
as it was with ISA as not all option cards will ever be redesigned as PCIe 
options.  And even if they do, then people may not necessarily want to 
throw away all their old still-working peripheral hardware when they 
upgrade the system, especially the more sophisticated or expensive bits.

> >  OTOH, for CPU stores and DMA transactions the event will always be
> > asynchronous and an NMI might be a better option, as in the case of parity
> > and MBE ECC errors the whole system will probably have to be brought down,
> > and with SBE ECC errors scrubbing can be done at any time and otherwise
> > (except from logging and/or marking the physical page bad, as required) no
> > action is needed.
> 
> In fact, MCE is a special exception, it can be used for asynchronous
> events too. Such as memory error detected by patrol scrubbing, please
> take a look at latest Intel 64 and IA32 architectures software
> developer's manual Vol 3A section 15.9.3: Architecturally Defined UCR
> Errors.

 The MCE has always had an asynchronous option -- even the original 
implementation in the Pentium CPU had a BUSCHK# input line which was 
cleverly used by the i430NX/Neptune chipset to signal hard ECC errors (so 
the handler had the address of the failing bus transaction readily 
available in the Machine Check Address MSR), but regrettably never after.

 The problem with using the MCE for non-CPU related events such as DMA 
transfers that failed is the choice of the target CPU in multi-processor 
systems.  Is there a well-defined way for routing such events that an OS 
like Linux could use?  It better not went to an off-line processor for 
example.

 There's no such problem with system NMIs as they can be routed to the CPU 
of choice by means of LINT1 input configuration in the local APIC unit of 
the concerned processors.

  Maciej
