Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2AZPfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 10:35:19 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:42398 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab2AZPfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 10:35:17 -0500
Date: Thu, 26 Jan 2012 10:32:39 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Guillaume Knispel <gknispel@proformatique.com>
Cc: Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Xavier Carcelle <xcarcelle@avencall.com>,
        =?iso-8859-1?B?Tm/p?= Rubinstein <nrubinstein@avencall.com>
Subject: Re: How to "register" a GSI for a non PCI non ISA device
Message-ID: <20120126153239.GA14367@phenom.dumpdata.com>
References: <20120124184203.1b0878c2@xilun>
 <4F1F99A5.1000206@kernel.org>
 <20120125182314.7834c75b@xilun>
 <20120125190214.GC18606@phenom.dumpdata.com>
 <20120126160719.3b9be3b3@xilun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126160719.3b9be3b3@xilun>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090209.4F2172AA.0101,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 04:07:19PM +0100, Guillaume Knispel wrote:
> On Wed, 25 Jan 2012 14:02:14 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Wed, Jan 25, 2012 at 06:23:14PM +0100, Guillaume Knispel wrote:
> > > On Wed, 25 Jan 2012 00:56:53 -0500
> > > Len Brown <lenb@kernel.org> wrote:
> > > 
> > > > What is the benefit of implementing ACPI on this custom system?
> > > 
> > > For our short term project it seems to be more a necessity than a
> > > benefit. ACPI is supported by the SoC, tables are already largely
> > > provided by Coreboot, the whole x86 ecosystem including Linux is more
> > > or less based around ACPI, and my whole interrogation comes from the
> > > fact that *acpi*_register_gsi() seems to be necessary to configure a
> > > GSI in the APIC but is not exported anymore, so my guess is that if I
> > 
> > Hm, isn't it __acpi_register_gsi?
> 
> __acpi_register_gsi exists on recent kernels, it is the pointer to
> the underlying implementation of that function depending on the
> platform (x86 / xen-x86) and on the variant of the platform (pic/apic).
> acpi_register_gsi still exists and it calls __acpi_register_gsi.
> 
> > > can't call it explicitly from my LKM, there should better be a way to
> > > make it be called when an ACPI thing is done, or maybe a legacy table
> > > parsed.
> > 
> > Can you do it the way xen does? Look in arch/x86/xen/pci.c
> 
> Did not found this file. Besides, isn't Xen a separate architecture

Duh! I meant arch/x86/pci/xen.c

> from mainline x86, compiled built-in? My goal is to only touch LKM and

Not anymore. It is dynamically on if the kernel detects its running under the
hypervisor.

I am still unclear what you are trying to do. Is it that
you have _PRT ACPI tables and your want to have your module be called
when those are parsed? If so, then __acpi_register_gsi is your guy - 
and you can over-write it to your platform. Granted at that point that
function parameter should be guarded by some form of locking. Perhaps
provide a acpi_register_gsi_fnc() that can be exported out. Would
that work for you (I can cook up a patch for that)?

But this a bit complicated by the fact that ACPI parsing is done
early in the bootup processes - so your module should be compiled in
- otherwise you might miss the the 'request_irq' calls done by drivers
that are done _before_ your module is loaded.

Unless you want to re-trigger the ACPI _PRT parsing and call your
module once more for all interrupts? But that would imply unload
all existing modules, then reload them once more..

Or is it that you just want to set the APIC parameters differently?
Wouldn't then the be better of implementing an ' struct apic ' which
would have most, of them set to the existing (apic_physflat) and just
over-write the ones you really care about - like write and read?

> system firmware if necessary.
> 
> > > As we first target an unmodified (if possible) 2.6.32 kernel from
> > > Debian Squeeze, I can't just re-export acpi_register_gsi() and call it
> > > a day. (If I've no other choice I'll obviously do it, but this would be
> > > quite bad for future maintenance).
> > 
> > Oh wow. That is ancient. 3.2?
> 
> 3.2 when a Debian stable will feature 3.2 :)

Ah OK.
