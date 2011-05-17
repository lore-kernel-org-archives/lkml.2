Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab1EQOtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:49:03 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36516 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab1EQOtA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:49:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=wLXCcZMBC1pJqKZdBng7d5wNNfZd5UYnUa59pvKnzQYDAQd7VxJrbPAoSmFxPQnLpX
         jLadFo0RiOhIfrOebT3g==
MIME-Version: 1.0
In-Reply-To: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
References: <334319B2EBE0B144BAE1402B79D82DC5CE13B056@srvpegasus>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 17 May 2011 08:48:38 -0600
Message-ID: <BANLkTimNSe5JjM2+_-XzS7D8XPeZrPL0oA@mail.gmail.com>
Subject: Re: Kernel > 2.6.30: PCI issue causes Kernel freeze at booting
To: "Hornung, Michael" <mhornung@init-ka.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[added linux-pci]

On Tue, May 17, 2011 at 1:01 AM, Hornung, Michael <mhornung@init-ka.de> wrote:
> the system from which I'm talking about is a Menlow XL (Intel Atom Z510PT and SCH US15WPT) platform with 512 megabyte RAM.
> There is one PCIe-switch (PI7C9X20404SL) attached to each of both PCIe-ports of the US15WPT (see attached 2.6.30-lspci.txt for details).

I think you forgot to attach the lspci.

> With both switches enabled, all Kernel versions (vanilla) above 2.6.30 refuse to boot. With only one switch active
> (the other one with no supply voltage ), all Kernel versions boot properly. It does not matter which switch is removed, it
> is sufficient just to remove one of the two.
>
> There is an UART (FPGA IP Core) in that system located at address 1900h using interrupt 3. In order to get Kernel messages at boot time,
> I changed file arch/x86/include/asm/serial.h as follows:
>
> -        { 0, BASE_BAUD, 0x3F8, 4, STD_COM_FLAGS },      /* ttyS0 */     \
> +        { 0, BASE_BAUD, 0x1900, 3, STD_COM_FLAGS },     /* ttyS0 */    \
>
> that is the only change I made to the kernel sources.

Is this UART connected via PCI?  I don't think so, because I don't see
any I/O BARs that include 0x1900.  However, I don't see any ACPI
devices that mention that address either (none of the "pnp 00:xx"
devices include that range).

Since there's no PCI-enumerable device that uses 0x1900, and ACPI
doesn't mention it, we think it's available, and I notice the 2.6.38.6
kernel does assign the [io  0x1000-0x1fff] range to the 00:1c.1 bridge
I/O window.  Now we probably have two devices claiming accesses to
0x1900 (the bridge and the UART).  I don't know whether this is
causing the problem, but it can't be good.

I think the best way to fix this would be to change your BIOS to
include a PNP0501 ACPI device with the appropriate _CRS to tell us
what resources it uses (then you could drop your serial.h change,
too).

If changing the BIOS is impossible, you could at least find out if
this is the problem by adding a quirk in drivers/pnp/quirks.c to
reserve the 0x1900 region by adding an I/O resource to the PNP0c02
device.

Bjorn
