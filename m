Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab0DLVFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:05:31 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56147 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab0DLVF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:05:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VAP8zx0gskX3F2E3Ad2VyeBw9xZvqZHMN32THHRvW1AeC2s2GwP0tnCOq2l0vlhLUJ
         C3zdC5//RuS9h5ZlSMnNv8Icmc0X21wwpecYYHgAoWOv1Iw1X67mdw7KmCvd74DOqUoM
         gXxcfHmLcJsjk7FUMoL7+pLyoJAJtmrEqrJoI=
MIME-Version: 1.0
In-Reply-To: <20100412174352.4e13113f@lxorguk.ukuu.org.uk>
References: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
	 <20100412174352.4e13113f@lxorguk.ukuu.org.uk>
Date: Mon, 12 Apr 2010 17:05:26 -0400
Message-ID: <n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
Subject: Re: Trying to fix ITE-887x parallel/serial driver bugs (including 
	unhandled IRQs)
From: Joseph Krahn <joseph.krahn@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 12:43 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Both drivers (8250_pci.c and parport_pc.c) probe randomly for the
>> chips control I/O port, instead of using the standard PNP-configured
>> BAR, and they do so independently, stepping on the previous drivers
>> configuration attempt. I think the two drivers should be merged into
>> parport_serial.c because this is a combo chip. However, different
>
> That seems reasonable.
>
> I don't think your description is accurate entirely. The device is picked
> up by PCi scans and the INTCBAR is then set up by Linux having checked
> for free address ranges. It's hardly 'random probing' and it isn't a
> normal BAR or guaranteed to have been configured by anything beforehand.
Yes, but the drivers don't use INTCBAR. They scan through a herd-coded
list of possible port ranges:

static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
                                         int autodma,
                                         const struct parport_pc_via_data *via)
{
        short inta_addr[6] = { 0x2A0, 0x2C0, 0x220, 0x240, 0x1E0 };
...
        for (i = 0; i < 5; i++) {
                base_res = request_region(inta_addr[i], 32, "it887x");
                if (base_res) {
...

>
>> The IT887x chips include an interrupt controller that maps external
>> IRQ inputs to serialized IRQs. Apparently, the I/O ports only present
>> a standard interrupt interface when wired for serialized IRQs. For
>> normal PCI interrupts, it needs a custom interrupt handler to
>> communicate directly with the interrupt-controller port. The current
>
> I guess the obvious thing to do would be to provide one. The serial code
> already supports several such things. What is actually needed or is the
> 'special' handler simply shared IRQ support in which case it ought t just
> work.
The interrupt controller (INTC) provides IRQ status bits in a single
I/O port byte. I only have the datasheet for IT8875F, which is 1
parallel and no serial ports, so my understanding of UART IRQs is sort
of reverse engineering. Polling the UART IIR register shows that it
acts like a normal 16550 UART when set to SERIRQ mode, but I get no
IRQs generated. Setting to standard PCI INTA interrupts, the IRQs are
generated, but the UART IIR registers do not set the IRQ bits.

One possibility is to install custom io_serial_in/out functions. When
the value of IIR is requested, the INTC can be checked, and modify the
result to what it should be for a normal UART. That is a bit of a
hack, but makes it much easier to fit into the existing code.
>
>> serial driver attempts to disable IRQs, and let the core driver revert
>> to polling. However, it does this incorrectly, and can produce
>> unhandled IRQs. (Maybe it was tested on a system with Ser. IRQ?) To
>> avoid extra interrupt-handler code, especially for a less common chip,
>> is it OK to intentionally provide polling-only support?
>
> I'd strongly prefer it worked as well as possible if the the
> documentation to fix it exists. What is involved ?
>
> Alan
>
It is easy to fix the code to use INTCBAR to configure the INTC I/O
port. It is probably not too hard to get a proper driver, if I can
find other users to test different hardware configurations. For
hardware wired to use the chip's serialized IRQ, it probably behaves
like standard PC-style chips, and no special IRQ code is needed. It
would be nice to verify this. Maybe a good approach would be to add
support IRQs, but add a module parameter to disable it.

Joe
