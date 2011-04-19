Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1DSNri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 09:47:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57439 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752622Ab1DSNrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 09:47:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Date: Tue, 19 Apr 2011 15:46:49 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: George Kashperko <george@znau.edu.ua>, Hauke Mehrtens <hauke@hauke-m.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Arend van Spriel <arend@broadcom.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, b43-dev@lists.infradead.org,
        Greg KH <greg@kroah.com>, Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com> <201104181619.35115.arnd@arndb.de> <BANLkTinB-9h=bZg9zg219i2wi3zUCA6mcw@mail.gmail.com>
In-Reply-To: <BANLkTinB-9h=bZg9zg219i2wi3zUCA6mcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201104191546.49632.arnd@arndb.de>
X-Provags-ID: V02:K0:f6zXMJwdVJ92QCRoAAdj3ORnJzu4E/Gzlld7VpPeyMl
 QwEzXNONEz/kdK1N1cEzHEPMzKO8vDyuz/OPvzbxvxI/PB22A9
 PjElyioTOVCikfKhdhRnNNigyyGPQF967RnVCl5bouBWJHlrV4
 RMKnHx2wClU3DedzcRVTDt8ekv/RiwM2PS+tTizyKBnRn8yNJF
 6/0WC2dfe5rU3sA8inlKQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Rafał Miłecki wrote:
> W dniu 18 kwietnia 2011 16:19 użytkownik Arnd Bergmann <arnd@arndb.de> napisał:
> > You mean the hardware has two sets of registers containing the same
> > information, one of them the standard registers, and one with broadcom
> > specific ones?
> >
> > Why don't you just use the standard ones then?
> 
> No. Did you read my first mail in this thread?

I'm sorry, but I found the information in this thread and the related ones
highly confusing and sometimes contradictory. Thanks for clarifying it
once more.

> There is pair of cores for every device. First is AMBA-specific called
> agent/wrapper and second one is Broadcom-specific.
> 
> AMBA specific core called agent/wrapper has AMBA specific registers:
> CID and PID. However we do not ever read that in Broadcom driver,
> because that are useless for us. On AMBA specific core we use only
> some Broadcom specific registers to manage (enable/disable) second
> (Broadcom-specific) core.

Ideally, we should model the devices along the IP blocks and how they
fit together. If I understand correctly what you are saying, your hardware
looks like

pci_dev
  |
  +---------+-----------+ ...
  |         |           |
 amba_dev   amba_dev   amba_dev
   |           |           |
 bcm_dev     bcm_dev     bcm_dev

In that case, you would need three bus types (pci_bus, amba_bus and
your own bcm_bus) and at least seven devices to represent all of it
using the device model. This is possible, but it seems you are also
saying that you don't need the complexity of this, e.g. because you
don't care about the amba device at all.

The easiest shortcut would be to not represent the AMBA devices
at all, and I guess that is fine. Introducing your own bus_type
for the broadcom devices sounds like a correct way to use the
linux driver model, especially if the devices on that bus are
totally independent from one another. I think you should do that
if you have e.g. a PCI card containing a single PCI function with
multiple IP blocks that do completely unrelated things (wifi,
bluetooth, ethernet, ...).

You could also just use platform_devices if you don't want to
introduce your own bus, and there is not much commonality between
the devices in terms of probing them.

However, I would not use the device model if the IP blocks in your
device are just responsible for different aspects of one logical
device, e.g. PHY, power management and DMA within a single network
adapter. If that is what you have, don't use a Linux device for
each of those blocks at all, but instead do a "library" module
for each block: export some interfaces from the module that can
be used by multiple drivers, and create the data structure from
the main driver, filled out with the data describing the IP
block (memory ranges, interrupts, etc).

	Arnd
