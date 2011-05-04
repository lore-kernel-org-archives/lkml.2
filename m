Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1EDOtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:49:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58504 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752Ab1EDOs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:48:58 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
Date: Wed, 4 May 2011 16:48:36 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        linux-arm-kernel@lists.infradead.org,
        "Marc Kleine-Budde" <mkl@pengutronix.de>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, Netdev@vger.kernel.org,
        nsekhar@ti.com, open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        m-watkins@ti.com
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <201105041511.54095.arnd@arndb.de> <4DC163D7.9010309@grandegger.com>
In-Reply-To: <4DC163D7.9010309@grandegger.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041648.37199.arnd@arndb.de>
X-Provags-ID: V02:K0:E+ILACLBLgdtI7FVuFEyt+rmc6TUfnXKKoh0OCRGWWj
 XcG8SXjmKMtoHjH8P7TMS7rVc5dcNeKHk/Csivxw8yVcIQOjTy
 Lo3kX2QAZE7+Pt7P8tb3sgNiUF1aVPEt3UmVJQy3nX5puU9uk5
 mTU5tqznzu1Am2NB4SPIFg6vtqttCmKq3WADR/4lSude99/c2c
 7ZZi8J3bVcG2avvKXpBVA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 May 2011, Wolfgang Grandegger wrote:
> On 05/04/2011 03:11 PM, Arnd Bergmann wrote:

> > Wolfgang, I'm a bit worried by the API being split between sockets and sysfs.
> > The problem is that once the sysfs API is established, users will start
> > relying on it, and you can no longer migrate away from it, even when
> > a later version of the Socket CAN also supports setting through a different
> > interface. What is the current interface to set mail box IDs in software?
> 
> Note that this CAN controller is *very* special. It cannot handle all
> CAN id's due to a lack or resources. The PRUSS firmware is able to
> manage just up to 8 different CAN identifiers out of the usual 4096
> (12-bit) or even more for the extended CAN ids using 29 bits. 

So for other controllers, they can simply access every ID within
the range (12 or 29 bits), but there is no need to configure?

What are these IDs for? Do they identify a local port, a remote address,
a connection, or something else?

> There is
> no other CAN controller with such rather serious limitations and
> therefore there exists also no appropriate interface. I think using
> sysfs is OK for such device-specific parameters, at least for the time
> being.

It sounds like it's not very scalable, especially since the implementation
is done completely in firmware. Imagine a new firmware version suddenly
supporting 256 ids instead of 8 -- you'd then have to create 256 sysfs
files to be compatible if I understand you correctly.

> > How hard would it be to implement that feature in Socket CAN?
> 
> CAN controllers usually provide some kind of hardware CAN id filtering,
> but in a very hardware dependent way. A generic interface may be able to
> handle the PRUSS restrictions as well. CAN devices are usually
> configured through the netlink interface. e.g.
> 
>   $ ip link set can0 up type can bitrate 125000
> 
> and such a common interface would be netlink based as well.

Agreed.

> > Is that something that Subhasish or someone else could to as a prerequisite
> > to merging the driver?
> 
> Any ideas on how to handle hardware filtering in a generic way are
> welcome. I will try to come up with a proposal sooner than later.

It sounds to me like the best solution would be change the firmware
to lift that restriction and simply allow all IDs, in case it's not
actually a hardware limitation (which sounds unlikely).

If that's not possible, maybe it's possible to define a generic
filtering interface using netlink, and then either do it completely
in the kernel, or using the hardware support.

	Arnd
