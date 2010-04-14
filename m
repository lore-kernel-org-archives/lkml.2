Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab0DNRrI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 13:47:08 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:65498 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab0DNRrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 13:47:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IODnqTdRONNYSfALH8HsxFmjIV1ysi12MRVro8OC5t1bD0jZcukVB6dv2tvE6CgtzW
         A+8uHAws4I699duiYe7+qM7HTXmPHKXPMPBczSyweZrTPPK+te1f3WxIzkfYq7HXfYV2
         9i0oLbQQW2RhRe8QxnZR/q9cjXei6kkBYDOXE=
MIME-Version: 1.0
In-Reply-To: <20100414131140.5c6187ab@lxorguk.ukuu.org.uk>
References: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
	 <20100412174352.4e13113f@lxorguk.ukuu.org.uk>
	 <n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
	 <20100414131140.5c6187ab@lxorguk.ukuu.org.uk>
Date: Wed, 14 Apr 2010 13:46:56 -0400
Message-ID: <z2qff6de6f21004141046ke8eb9f62q4cdd87dc136f76a1@mail.gmail.com>
Subject: Re: Trying to fix ITE-887x parallel/serial driver bugs (including 
	unhandled IRQs)
From: Joseph Krahn <joseph.krahn@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 8:11 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> > for free address ranges. It's hardly 'random probing' and it isn't a
>> > normal BAR or guaranteed to have been configured by anything beforehand.
>
>> Yes, but the drivers don't use INTCBAR. They scan through a herd-coded
>> list of possible port ranges:
>
> They can't just use INTCBAR as it may not have been configured by anything
> before the device is probed. We do need to find and assign suitable ports
> although this should probably be done via the PCI quirks on PCI setup.
>
>> The interrupt controller (INTC) provides IRQ status bits in a single
>> I/O port byte. I only have the datasheet for IT8875F, which is 1
>> parallel and no serial ports, so my understanding of UART IRQs is sort
>> of reverse engineering. Polling the UART IIR register shows that it
>> acts like a normal 16550 UART when set to SERIRQ mode, but I get no
>> IRQs generated. Setting to standard PCI INTA interrupts, the IRQs are
>> generated, but the UART IIR registers do not set the IRQ bits.
>
> Weird design.
>
> http://kr.ic-on-line.cn/IOL/viewpdf/IT8871F_200216.htm
>
> provides a tiny bit of info on the uart side but I've not found any
> complete documentation.
I already have the above document. It says that a proper driver is not
needed in MS-Windows, implying standard I/O interfaces. I think the
chip was originally designed to build into motherboards with
serialized IRQs, and the INTA IRQ quirk is a design flaw.

The ite887x 8250_pci author, Niels de Vos, had the relevant data sheets:
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg137333.html
However, an email bounced. I'll see if I can contact someone at the company.

>
>> One possibility is to install custom io_serial_in/out functions. When
>> the value of IIR is requested, the INTC can be checked, and modify the
>> result to what it should be for a normal UART. That is a bit of a
>> hack, but makes it much easier to fit into the existing code.
>
> Seems a good starting point. The serial side code is robust for shared
> IRQs.
>
> Alan
>
My current code moves the driver to parport_serial.c, and 8250_pci.c
only has the code to install the custom serial_in(), to deal with
interrupts.

The different 887x devices can have no serial or no parallel ports,
but all have the same PCI id. My code just lets parport_serial handle
the serial-only and parallel-only cases. Is that approach better than
having two modules that both match the same PCI id?

The code could also be left separate, with parport_serial skipping
devices with no parallel ports. The two device-init routines should
not interfere with each other as long as they both use PCI BAR 0 to
map INTCBAR.

The custom serial_in function only sets the interrupt pending bits for
IIR, and not the interrupt-type bits 1-3. I think the current serial
driver not use these status bits, so this should be OK.

Thanks,
Joe Krahn
