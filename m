Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab1EWGV4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:21:56 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:41557 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028Ab1EWGVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:21:54 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/CuK2RLQ==
X-RZG-CLASS-ID: mo00
Message-ID: <4DD9FCFC.10803@hartkopp.net>
Date: Mon, 23 May 2011 08:21:48 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Icedove/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Subhasish Ghosh <subhasish@mistralsolutions.com>,
        Wolfgang Grandegger <wg@grandegger.com>, sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Netdev@vger.kernel.org,
        m-watkins@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com> <4DCB88A4.2010901@grandegger.com> <4DCBF1B6.6000104@hartkopp.net> <201105221230.56243.arnd@arndb.de>
In-Reply-To: <201105221230.56243.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2011 12:30, Arnd Bergmann wrote:
> On Thursday 12 May 2011 16:41:58 Oliver Hartkopp wrote:
>> E.g. assume you need the CAN-IDs 0x100, 0x200 and 0x300 in your application
>> and for that reason you configure these IDs in the pruss CAN driver.
>>
>> What if someone generates a 100% CAN busload exactly on CAN-ID 0x100 then?
>>
>> Worst case (1MBit/s, DLC=0) you would need to handle about 21.000 irqs/s for
>> the correctly received CAN frames with the filtered CAN-ID 0x100 ...
> 
> Then I guess the main thing that a "smart" CAN implementation like pruss
> should do is interrupt mitigation. When you have a constant flow of
> packets coming in, the hardware should be able to DMA a lot of
> them into kernel memory before the driver is required to pick them up,
> and only get into interrupt driven mode when the kernel has managed
> to process all outstanding packets.
> 
>> This all depends heavily on Linux networking (skb handling, caching, etc) and
>> is pretty fast and optimized!! That was also the reason why it ran on the old
>> PowerPC that smoothly. The mostly seen effect if anything drops is when the
>> application (holding the socket) was not fast enough to handle the incoming
>> data. NB: For that reason we implemented a CAN content filter (CAN_BCM) that
>> is able to do content filtering and timeout monitoring in Kernelspace - all
>> performed in the SoftIRQ.
> 
> Right, dropping packets that no process is waiting for should be done as
> early as possible. In pruss-can, the idea was to do it in hardware, which
> doesn't really work all that well for the reasons discussed before.
> Dropping the frames in the NAPI poll function (softirq time) seems like a
> logical choice.

In 'real world' CAN setups you'll never see 21.000 CAN frames per second (and
therefore 21.000 irqs/s) - you are usually designing CAN network traffic with
less than 60% busload. So interrupt rates somewhere below 1000 irqs/s can be
assumed.

>From what i've seen so far a 3-4 messages rx FIFO and NAPI support just make it.

@Marc/Wolfgang: Would this be also your recommendation for a CAN controller
design that supports SocketCAN in the best way?

As the Linux network stack supports hardware timestamps too, this could be an
additional (optional!) feature.

Regards,
Oliver

>> Having 'Mailboxes' bound to CAN-IDs is something that's useful for 8/16 bit
>> CPUs where an application is tightly bound to the embedded ECUs functionality.
> 
> Makes sense.
> 
> 	Arnd

