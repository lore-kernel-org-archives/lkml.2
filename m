Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab1EVKbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 06:31:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60886 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab1EVKbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 06:31:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Oliver Hartkopp <socketcan@hartkopp.net>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Sun, 22 May 2011 12:30:56 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Wolfgang Grandegger <wg@grandegger.com>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Netdev@vger.kernel.org,
        m-watkins@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <4DCB88A4.2010901@grandegger.com> <4DCBF1B6.6000104@hartkopp.net>
In-Reply-To: <4DCBF1B6.6000104@hartkopp.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105221230.56243.arnd@arndb.de>
X-Provags-ID: V02:K0:W9vATK90e/+73Z+qnKobesf0Ju0zYOGa9drImb3A6uK
 PyGxWPm6zpGaYAZtl6hNREyHfP9X2jGmkJ3oWfSDvz6AFOGRmo
 BKVuOFjjhOWqRq/eyVF851eNFAmoMDBmS6Bw4aGRFkF1KQyvwP
 yteuGQjJVgb8e47Mna2aAOgOWKNIeY+A0XPP9TV8Q+WTMBZQOz
 jRaCHecpwNe7ltLjKgTag==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 12 May 2011 16:41:58 Oliver Hartkopp wrote:
> E.g. assume you need the CAN-IDs 0x100, 0x200 and 0x300 in your application
> and for that reason you configure these IDs in the pruss CAN driver.
> 
> What if someone generates a 100% CAN busload exactly on CAN-ID 0x100 then?
> 
> Worst case (1MBit/s, DLC=0) you would need to handle about 21.000 irqs/s for
> the correctly received CAN frames with the filtered CAN-ID 0x100 ...

Then I guess the main thing that a "smart" CAN implementation like pruss
should do is interrupt mitigation. When you have a constant flow of
packets coming in, the hardware should be able to DMA a lot of
them into kernel memory before the driver is required to pick them up,
and only get into interrupt driven mode when the kernel has managed
to process all outstanding packets.

> This all depends heavily on Linux networking (skb handling, caching, etc) and
> is pretty fast and optimized!! That was also the reason why it ran on the old
> PowerPC that smoothly. The mostly seen effect if anything drops is when the
> application (holding the socket) was not fast enough to handle the incoming
> data. NB: For that reason we implemented a CAN content filter (CAN_BCM) that
> is able to do content filtering and timeout monitoring in Kernelspace - all
> performed in the SoftIRQ.

Right, dropping packets that no process is waiting for should be done as
early as possible. In pruss-can, the idea was to do it in hardware, which
doesn't really work all that well for the reasons discussed before.
Dropping the frames in the NAPI poll function (softirq time) seems like a
logical choice.

> Having 'Mailboxes' bound to CAN-IDs is something that's useful for 8/16 bit
> CPUs where an application is tightly bound to the embedded ECUs functionality.

Makes sense.

	Arnd
