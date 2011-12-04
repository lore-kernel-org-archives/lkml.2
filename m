Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774Ab1LDRAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 12:00:19 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41656 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751644Ab1LDRAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 12:00:17 -0500
X-Sasl-enc: pWO5+oBalpFe3OHDM6ZowrU1F/VxLW7K8kmtwQ/QxD6w 1323018015
Message-ID: <4EDBA70E.3090905@ladisch.de>
Date: Sun, 04 Dec 2011 17:59:58 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Jeroen Van den Keybus <jeroen.vandenkeybus@gmail.com>
CC: "Huang, Shane" <Shane.Huang@amd.com>, Borislav Petkov <bp@amd64.org>,
        "Nguyen, Dong" <Dong.Nguyen@amd.com>, linux-kernel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net
Subject: Re: Unhandled IRQs on AMD E-450
References: <CAPRPZsCrGXKwYiOTzDde=5=8wMnMX0sxFvnustSSz4Z6BYJNzA@mail.gmail.com>	<20111130154445.GA27198@gere.osrc.amd.com>	<1E8B869C0C6913418421A406C094DF7C0205358F@sshaexmb1.amd.com>	<CAPRPZsAL=xUCjTKaSgq117zppvZS0S7fHB0Ebk-JqXvV1vTPCQ@mail.gmail.com>	<4EDB6C10.10102@ladisch.de>	<CAPRPZsAc8wr_2KsRi3LnGi4ic-CzrFLbRvQfkrXckH--vaLkVQ@mail.gmail.com>	<CAPRPZsBdnrProsTaSYnMKi6Q3dSsP9nYkw0CKnmb-BrmJxBivw@mail.gmail.com>	<CAPRPZsBO_hvAv8o0vKh7XuE+RiEunETaxaPsmdm5yPe5YvOdPA@mail.gmail.com> <CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
In-Reply-To: <CAPRPZsDU2+ApCjQvEzRfOXfMLgfDS1j5zXF7hw4wy5yrzT-_7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeroen Van den Keybus wrote:
> The problem occurs with the e1000 idle (unplugged) and under heavy
> usage (plugged). Time to failure is also in the same order of
> magnitude (i.e. 1..30 minutes). As of now, I never had IRQ 19 disabled
> with the e1000 removed. The e1000 delivered with Ubuntu isn't
> particularly recent (7.3.21-k8-NAPI).

That version number doesn't mean much; there have been many changes to
the kernel driver since it was last updated.

One interesting patch is <http://git.kernel.org/linus/4c11b8adbc48>;
please check if you have it (the file was recently moved into
drivers/net/ethernet/intel/e1000/).  But it's from January, your 3.2-rc*
should already have it.

> I have succeeded in catching a lspci on the SATA controller with INTx+
> while IRQ 19 is disabled.  [...]
> The fact that the next lspci's showed INTx- shows that its pin is
> definitely not stuck, does it not ?

Indeed; that SATA controller appears to work fine.

> I already lost IRQ 16 after 2 minutes. This kernel doesn't have
> support for any audio, so there was only firewire_ohci on this line.
> However, lspci for this device shows a firm INTx+.

Your VT6308 is a widely-used chip, and there are no known interrupt-
related problems with it.

This PCI status register is part of the device itself, i.e., the
FireWire controller chip; there is nothing in the rest of the system,
hardware or software, that could affect this INTx value.  This means
that the controller itself thinks that there is some FireWire-related
reason for the interrupts.

To instruct the firewire-ohci driver to log all interrupts and what the
device thinks the reason for them is, please run:

  echo 4 > /sys/module/firewire_ohci/parameters/debug

As long as there is nothing connected, there should be nothing but
a timing interrupt every 64 seconds, like this:
  firewire_ohci: IRQ 00200000 cycle64Seconds

> After 20 min. IRQ 19 was lost again.
>
> Now _I_ am lost. The only thing that IRQ 16 and IRQ 19 have in common
> is that there are devices on them that do have an INTx line but do not
> use it (MSI instead). However, I ran this kernel with pci=nomsi
> (earlier post) and IRQs 16 and 19 went down as well.

>From the information available so far, it appears that you have two
similar but _independent_ problems with the e1000 and firewire devices.
(It might be possible that static electricity zapped both your PCI card
and the FireWire controller (which is directly near the first PCI slot),
or something like that.)


Regards,
Clemens
