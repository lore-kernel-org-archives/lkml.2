Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab0DZQGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 12:06:22 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:52000 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab0DZQGU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 12:06:20 -0400
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Apr 2010 12:06:20 EDT
X-Sasl-enc: HiFDQIRm2hqBjGHPLGy7cawtu8Gf8E//Tq6gOAMAcOzA 1272297381
Message-ID: <4BD5B7A4.1040209@ladisch.de>
Date: Mon, 26 Apr 2010 17:56:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] firewire: ohci: add MSI support
References: <4BD5667B.1030900@ladisch.de> <4BD5A6C0.3030704@s5r6.in-berlin.de>
In-Reply-To: <4BD5A6C0.3030704@s5r6.in-berlin.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> Clemens Ladisch wrote:
> > This patch adds support for message-signaled interrupts.
> > 
> > Any native PCI-Express OHCI controller should support MSI, but most are
> > just PCI cores behind a PCI-E/PCI bridge.  The only chips that are known
> > to claim to support MSI are the Lucent/Agere/LSI FW643 and the VIA
> > VT6315, none of which I have been able to test.
> 
> I got a FW643 card a few days ago and can test that one.  Also, I have a
> JMicron JMB381 native PCIe 1394a controller.  The latter is a less ideal
> test specimen since it is buggy already without MSI (soon stops to
> operate if one dares to mix isochronous and asynchronous I/O; sometimes
> also if there is a bus reset at an inconvenient time).

Problematic MSI implementations usually deliver no interrupt or forget
to disable the INTx interrupt (so that the interrupt never gets
deasserted); these bugs should be visible immediately.

> From lspci:
> 
> 04:00.0 FireWire (IEEE 1394): Agere Systems FW643 PCI Express1394b Controller (PHY/Link) (rev 07) (prog-if 10 [OHCI])
>         Capabilities: [4c] MSI: Enable- Count=1/1 Maskable- 64bit+
> 
> 0a:00.0 FireWire (IEEE 1394): JMicron Technology Corp. IEEE 1394 Host Controller (prog-if 10 [OHCI])
>         Capabilities: [94] MSI: Enable- Count=1/1 Maskable- 64bit-
> 
> Does "MSI 00", "MSI: Enable-" mean they do or don't support MSI?  Asks a
> PCIe newbie.

The "MSI: Enable-" means that it's supported but not enabled at the
moment.

> OK, an online encyclopedia informs me that MSI or MSI-X is required by PCIe.

That requirement doesn't help us if there is an old PCI chip behind a
PCIe/PCI bridge (even if only virtually inside one chip, such as the TI
XIO2xxx).

> The FW643 (actually two of them) sits behind a PCIe switch:
> 
> 03:04.0 PCI bridge: PLX Technology, Inc. PEX 8505 5-lane, 5-port PCI Express Switch (rev aa) (prog-if 00 [Normal decode])
>         Capabilities: [48] MSI: Enable+ Count=1/2 Maskable+ 64bit+
> 
> I hope this switch does not make things any more interesting.

Interrupt messages should be passed through like just any other messages
(such as memory or I/O reads or writes), so it shouldn't be able to
introduce MSI-related problems.

(The PEX8505's MSI registers are for interrupts that come from the
switch itself, probably for power management or error reporting; have
a look into /proc/interrupts.)


Regards,
Clemens
