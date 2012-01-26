Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab2AZQW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 11:22:58 -0500
Received: from paperboy.avencall.com ([91.194.178.22]:47148 "EHLO
	mx1.corp.avencall.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752641Ab2AZQW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 11:22:56 -0500
Date: Thu, 26 Jan 2012 17:22:48 +0100
From: Guillaume Knispel <gknispel@proformatique.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Guillaume Knispel <gknispel@proformatique.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Xavier Carcelle <xcarcelle@avencall.com>,
        =?ISO-8859-1?Q?No=E9?= Rubinstein <nrubinstein@avencall.com>
Subject: Re: How to "register" a GSI for a non PCI non ISA device
Message-ID: <20120126172248.72b0efa5@xilun>
In-Reply-To: <20120126153239.GA14367@phenom.dumpdata.com>
References: <20120124184203.1b0878c2@xilun>
	<4F1F99A5.1000206@kernel.org>
	<20120125182314.7834c75b@xilun>
	<20120125190214.GC18606@phenom.dumpdata.com>
	<20120126160719.3b9be3b3@xilun>
	<20120126153239.GA14367@phenom.dumpdata.com>
Organization: Avencall
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jan 2012 10:32:39 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Thu, Jan 26, 2012 at 04:07:19PM +0100, Guillaume Knispel wrote:
> > On Wed, 25 Jan 2012 14:02:14 -0500
> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > 
> > > On Wed, Jan 25, 2012 at 06:23:14PM +0100, Guillaume Knispel wrote:
> > >
> > > > can't call it explicitly from my LKM, there should better be a way to
> > > > make it be called when an ACPI thing is done, or maybe a legacy table
> > > > parsed.
> > > 
> > > Can you do it the way xen does? Look in arch/x86/xen/pci.c
> > 
> > Did not found this file. Besides, isn't Xen a separate architecture
> 
> Duh! I meant arch/x86/pci/xen.c
> 
> > from mainline x86, compiled built-in? My goal is to only touch LKM and
> 
> Not anymore. It is dynamically on if the kernel detects its running under the
> hypervisor.
> 
> I am still unclear what you are trying to do. Is it that
> you have _PRT ACPI tables and your want to have your module be called
> when those are parsed? If so, then __acpi_register_gsi is your guy - 
> and you can over-write it to your platform. Granted at that point that
> function parameter should be guarded by some form of locking. Perhaps
> provide a acpi_register_gsi_fnc() that can be exported out. Would
> that work for you (I can cook up a patch for that)?

Sorry if I was unclear, I'll try to make things more explicit.

We build the platform which obviously differs a little from a PC (but
just because of the presence of those additional non-ISA non-PCI
devices), but as far as software is concerned we are trying to make the
system run with a standard unmodified Linux kernel already built by
Debian (because rebuilding our own would shift the maintenance of
that kernel on us instead of Debian, and we would not be good at that)

So what we can act on are the LKM and the system firmware, but not the
bzImage.

The problem I'm facing is that I don't know how to setup a GSI, what
used to be done by directly calling acpi_register_gsi(), which was
possible from an LKM when it was exported (for example in 2.6.18,
which was the kernel used by Intel for their dev board).

Because acpi_register_gsi() is not exported anymore, I'm trying to find
a way to make it be called during system startup. My current best guess
is that if I write the right magic spell somewhere in the DSDT or maybe
a kind of legacy BIOS table, the acpi_register_gsi() will be called
during the boot and will configure the GSI with the desired level
triggering, so that the LKM will just have to request_irq() (but on
which irq number? same as gsi number?) and everything will work fine.

I don't think I've to replace acpi_register_gsi() by my own
implementation; the GSI in question is a standard one on the only
IO APIC in the system. So everything looks pretty simple. The only
question is how to make use of that GSI from the software side,
first how to configure it to level trigger active low, then how to
request it from a LKM given that the LKM in question does not drive
a PCI device that makes use of the interrupt we want.

The simplified architecture is the following:

 Intel 80579 System on Chip                | External chip
                                           |
+----------+            +-----+            |  +---------+
| CPU + NB |--- PCI ----| LEB |--- // bus ----| telecom |
+----------+            +-----+            |  |  chip   |
     |                                     |  +---------+
 +--------+                                |   |
 | IOAPIC |----------------- GSI 32 -----------+
 +--------+                                |

The LKM will register as a driver for the PCI enumerable LEB then use
it to drive the telecom chip. GSI 32 is unrelated to the LEB.

> But this a bit complicated by the fact that ACPI parsing is done
> early in the bootup processes - so your module should be compiled in
> - otherwise you might miss the the 'request_irq' calls done by drivers
> that are done _before_ your module is loaded.
> 
> Unless you want to re-trigger the ACPI _PRT parsing and call your
> module once more for all interrupts? But that would imply unload
> all existing modules, then reload them once more..
> 
> Or is it that you just want to set the APIC parameters differently?
> Wouldn't then the be better of implementing an ' struct apic ' which
> would have most, of them set to the existing (apic_physflat) and just
> over-write the ones you really care about - like write and read?
> 
> > system firmware if necessary.
> > 
> > > > As we first target an unmodified (if possible) 2.6.32 kernel from
> > > > Debian Squeeze, I can't just re-export acpi_register_gsi() and call it
> > > > a day. (If I've no other choice I'll obviously do it, but this would be
> > > > quite bad for future maintenance).
> > > 
> > > Oh wow. That is ancient. 3.2?
> > 
> > 3.2 when a Debian stable will feature 3.2 :)
> 
> Ah OK.

-- 
Guillaume Knispel
Avencall - 10 bis, rue Lucien Voilin - 92800 Puteaux
