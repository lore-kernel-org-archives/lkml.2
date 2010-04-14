Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab0DNEnt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 00:43:49 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:51414 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab0DNEns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 00:43:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MtRC6zgTrU8nOE1MlG5auR2Sz/6kqa5O6Ns/YY7V6dmYXv8j/5HsPVX7OZG8wkxt2h
         dIXiGHpaTwWjRvC4U4DnI5xK+Ixw0jYBPSEkvjZXsDzUmMu6fatR41bkQrttTD9jIxmr
         Rw0p50z7hXtTHPhTcZUDa3JqTYHT7zqJHEcPU=
MIME-Version: 1.0
In-Reply-To: <n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
References: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
	 <20100412174352.4e13113f@lxorguk.ukuu.org.uk>
	 <n2wff6de6f21004121405xd33676f8s81c12e23747b88b0@mail.gmail.com>
Date: Wed, 14 Apr 2010 00:43:29 -0400
Message-ID: <w2jff6de6f21004132143v3a5fbc3aqe7b4e7966d569392@mail.gmail.com>
Subject: Re: Trying to fix ITE-887x parallel/serial driver bugs (including 
	unhandled IRQs)
From: Joseph Krahn <joseph.krahn@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, 2010 at 5:05 PM, Joseph Krahn <joseph.krahn@gmail.com> wrote:
> On Mon, Apr 12, 2010 at 12:43 PM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
...
>> I don't think your description is accurate entirely. The device is picked
>> up by PCi scans and the INTCBAR is then set up by Linux having checked
>> for free address ranges. It's hardly 'random probing' and it isn't a
>> normal BAR or guaranteed to have been configured by anything beforehand.
> Yes, but the drivers don't use INTCBAR. They scan through a herd-coded
> list of possible port ranges:
>
> static int __devinit sio_ite_8872_probe(struct pci_dev *pdev, int autoirq,
>                                         int autodma,
>                                         const struct parport_pc_via_data *via)
> {
>        short inta_addr[6] = { 0x2A0, 0x2C0, 0x220, 0x240, 0x1E0 };
> ...
>        for (i = 0; i < 5; i++) {
>                base_res = request_region(inta_addr[i], 32, "it887x");
>                if (base_res) {
> ...
Oops. I meant that INTCBAR should just be mapped to PCI BAR 0, which
has already been mapped to an available range. The problem with the
recent 8250_pci driver is that it repeats the above process,
requesting an I/O range while the existing range was never released.
This is how I think it should be done:

        /* Map INTC control to BAR 0 */
        intc_base = pci_resource_start(pdev,0);
        intc_res = request_region(intc_base, ITE_887x_POSIO0_IOSIZE,
"it887x_intc");

...
> One possibility is to install custom io_serial_in/out functions. When
> the value of IIR is requested, the INTC can be checked, and modify the
> result to what it should be for a normal UART. That is a bit of a
> hack, but makes it much easier to fit into the existing code.
I am testing a custom io_serial_in() to translate IRQ info. It looks
like a good solution. Based on the current parport_pc driver, the
partport I/O may work like a standard port, and not need any extra IRQ
code.

Instead of adding another UPIO_ definition, it should be possible to
define serial_in and serial_out in the 8250_pci.c quirks init
function. In some cases, but not all, the result from
set_io_from_upio() is allowed to be overridden, so this may be the
intended design. It appears that UPIO_TSI exists only to map
serial_in/out functions.

Thanks,
Joe
