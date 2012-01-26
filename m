Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab2AZRYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:24:55 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:38551 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926Ab2AZRYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:24:52 -0500
MIME-Version: 1.0
In-Reply-To: <20120126172248.72b0efa5@xilun>
References: <20120124184203.1b0878c2@xilun> <4F1F99A5.1000206@kernel.org>
 <20120125182314.7834c75b@xilun> <20120125190214.GC18606@phenom.dumpdata.com>
 <20120126160719.3b9be3b3@xilun> <20120126153239.GA14367@phenom.dumpdata.com> <20120126172248.72b0efa5@xilun>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 26 Jan 2012 10:24:31 -0700
Message-ID: <CAErSpo5vCr4Y3Q6U1=yYLcSBH-85koMKDte4rzw4tyuKocYXYA@mail.gmail.com>
Subject: Re: How to "register" a GSI for a non PCI non ISA device
To: Guillaume Knispel <gknispel@proformatique.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Xavier Carcelle <xcarcelle@avencall.com>,
        =?ISO-8859-1?Q?No=E9_Rubinstein?= <nrubinstein@avencall.com>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 9:22 AM, Guillaume Knispel
<gknispel@proformatique.com> wrote:
> On Thu, 26 Jan 2012 10:32:39 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>
>> On Thu, Jan 26, 2012 at 04:07:19PM +0100, Guillaume Knispel wrote:
>> > On Wed, 25 Jan 2012 14:02:14 -0500
>> > Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >
>> > > On Wed, Jan 25, 2012 at 06:23:14PM +0100, Guillaume Knispel wrote:
>> > >
>> > > > can't call it explicitly from my LKM, there should better be a way to
>> > > > make it be called when an ACPI thing is done, or maybe a legacy table
>> > > > parsed.
>> > >
>> > > Can you do it the way xen does? Look in arch/x86/xen/pci.c
>> >
>> > Did not found this file. Besides, isn't Xen a separate architecture
>>
>> Duh! I meant arch/x86/pci/xen.c
>>
>> > from mainline x86, compiled built-in? My goal is to only touch LKM and
>>
>> Not anymore. It is dynamically on if the kernel detects its running under the
>> hypervisor.
>>
>> I am still unclear what you are trying to do. Is it that
>> you have _PRT ACPI tables and your want to have your module be called
>> when those are parsed? If so, then __acpi_register_gsi is your guy -
>> and you can over-write it to your platform. Granted at that point that
>> function parameter should be guarded by some form of locking. Perhaps
>> provide a acpi_register_gsi_fnc() that can be exported out. Would
>> that work for you (I can cook up a patch for that)?
>
> Sorry if I was unclear, I'll try to make things more explicit.
>
> We build the platform which obviously differs a little from a PC (but
> just because of the presence of those additional non-ISA non-PCI
> devices), but as far as software is concerned we are trying to make the
> system run with a standard unmodified Linux kernel already built by
> Debian (because rebuilding our own would shift the maintenance of
> that kernel on us instead of Debian, and we would not be good at that)
>
> So what we can act on are the LKM and the system firmware, but not the
> bzImage.
>
> The problem I'm facing is that I don't know how to setup a GSI, what
> used to be done by directly calling acpi_register_gsi(), which was
> possible from an LKM when it was exported (for example in 2.6.18,
> which was the kernel used by Intel for their dev board).

A driver should never need to use acpi_register_gsi() directly.  It
sounds like you have a non-PCI device that would be described as an
ACPI device in the DSDT.  In the Device definition, you include a _CRS
method that tells the kernel what GSI it is using.  The PNPACPI
subsystem will parse _CRS and should do the acpi_register_gsi() for
you.  Then your driver would use pnp_register_driver() and pnp_irq()
to learn the IRQ.  drivers/tty/serial/8250_pnp.c is an example.

Bjorn
