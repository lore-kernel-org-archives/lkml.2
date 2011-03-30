Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932867Ab1C3UBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:01:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57259 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1C3UBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:01:03 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Palmer <me@danielpalmer.co.uk>
Subject: Re: PATA_ARTOP reads byte from PCI IO port without mapping it to the right address.
Date: Wed, 30 Mar 2011 22:00:46 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4D937FDC.4090607@danielpalmer.co.uk> <20110330202628.5dc8db5f@lxorguk.ukuu.org.uk> <4D93890A.60307@danielpalmer.co.uk>
In-Reply-To: <4D93890A.60307@danielpalmer.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103302200.47052.arnd@arndb.de>
X-Provags-ID: V02:K0:ej0qjHW+Be9lLMu3GTl1cPWvDoVXZpBgbkMD2glOnDP
 RTqcJ7xbjAyWtVVDwQBJzMZuNS9sqMn57625QcsAAgFymG+RTU
 zX7b3aksRp3g+Jr+b2YW9wvKCWNHtbwbeiq6pnRwWRHwZ2zoCo
 UYIz/UN/tbV+0G05Mto4zjHTFbEpnxU18m+3WJovFyGmxd684P
 /IkZRcnufFZD2p1RqX5GQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 March 2011 21:48:26 Daniel Palmer wrote:
> >  That is the PCI port address.
> 
> I don't pretend to understand most of this fully.
> On the board the PCI address space/PCI controller is apparently at 
> 0xfe240000
> So I guess that when that byte is read it should read from 0xfe240000 + 
> 0x1400?
> That doesn't happen and a read happens at 0x1400 and an oops results.
> I don't know enough to point the finger really.
> 
> There are probably only 2 people using this board still too. So I doubt 
> it really matters. :)

Is this an ARM machine? The platform specific mach/io.h header file
in that case defines an __io() macro that is responsible for mapping
port numbers to virtual addresses.

You have to ioremap() the physical address 0xfe240000 to a virtual
address, and then add the base address to the number inside of the
__io macro, e.g.

/* in mach/io.h: */
extern void __iomem *this_board_pci_iospace;
#define __io(x) ((x & 0xffff) + this_board_pci_iospace)

/* in pci controller setup code: */
this_board_pci_iospace = ioremap(0xfe240000, 0x10000);

	Arnd
