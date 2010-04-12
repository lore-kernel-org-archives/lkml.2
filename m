Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752357Ab0DLPeV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 11:34:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab0DLPeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 11:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=imwsAAu70VChBG000EoYTE2Y5SU57fG1bXC+dwNTgfxQ8dbabpL22kYOhEnKoQG5r1
         nz1rW/vnrjRYU4eAnpO57/ITlDmXi3BRrUv6FrjshYyiiTS8MNFtAH1ku3i5965mGOHd
         Up8SMXKm5zWX2OJUYVs6rpmFbQQov8V5ItKvs=
MIME-Version: 1.0
Date: Mon, 12 Apr 2010 11:34:18 -0400
Message-ID: <q2lff6de6f21004120834k72cfd554v188b9d2b5a01012c@mail.gmail.com>
Subject: Trying to fix ITE-887x parallel/serial driver bugs (including 
	unhandled IRQs)
From: Joseph Krahn <joseph.krahn@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ITE-887x parallel and serial port drivers are badly designed. I am
working on a patch to fix this, but have some questions.

Both drivers (8250_pci.c and parport_pc.c) probe randomly for the
chips control I/O port, instead of using the standard PNP-configured
BAR, and they do so independently, stepping on the previous drivers
configuration attempt. I think the two drivers should be merged into
parport_serial.c because this is a combo chip. However, different
variants of the chip have the same PCI vendor/device IDs, but may have
only serial or only parallel ports. Is it OK to have a driver in
parport_serial.c for chip that has only serial ports? Keeping a
separate driver in 8250_pci.c means having two drivers for the same
PCI device ID.

The IT887x chips include an interrupt controller that maps external
IRQ inputs to serialized IRQs. Apparently, the I/O ports only present
a standard interrupt interface when wired for serialized IRQs. For
normal PCI interrupts, it needs a custom interrupt handler to
communicate directly with the interrupt-controller port. The current
serial driver attempts to disable IRQs, and let the core driver revert
to polling. However, it does this incorrectly, and can produce
unhandled IRQs. (Maybe it was tested on a system with Ser. IRQ?) To
avoid extra interrupt-handler code, especially for a less common chip,
is it OK to intentionally provide polling-only support?

Thanks,
Joe Krahn
