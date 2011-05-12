Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab1ELOmP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:42:15 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:31861 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757805Ab1ELOmO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:42:14 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrT1q0ngWNsKR9Dbc7nsXB+5k/CuK6W1EA=
X-RZG-CLASS-ID: mo00
Message-ID: <4DCBF1B6.6000104@hartkopp.net>
Date: Thu, 12 May 2011 16:41:58 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.15) Gecko/20110402 Icedove/3.1.9
MIME-Version: 1.0
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
CC: Wolfgang Grandegger <wg@grandegger.com>, Arnd Bergmann <arnd@arndb.de>,
        sachi@mistralsolutions.com,
        davinci-linux-open-source@linux.davincidsp.com, nsekhar@ti.com,
        open list <linux-kernel@vger.kernel.org>,
        CAN NETWORK DRIVERS <socketcan-core@lists.berlios.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Netdev@vger.kernel.org,
        m-watkins@ti.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v4 1/1] can: add pruss CAN driver.
References: <1303474267-6344-1-git-send-email-subhasish@mistralsolutions.com>	<2BFFDAA0A0DE4820876E5549867938EC@subhasishg>	<201105112331.47954.arnd@arndb.de>	<201105112344.44171.arnd@arndb.de> <4DCB88A4.2010901@grandegger.com>
In-Reply-To: <4DCB88A4.2010901@grandegger.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.05.2011 09:13, Wolfgang Grandegger wrote:
> On 05/11/2011 11:44 PM, Arnd Bergmann wrote:
>> On Wednesday 11 May 2011, Arnd Bergmann wrote:
>>> If that interpretation is right, I would seriously recommend rethinking
>>> the design of the CAN firmware for pruss, so you can start doing something
>>> useful with the offload engine that fits into the Socket CAN API, or that
>>> would be a useful extension to Socket CAN that is also implementable in
>>> the kernel for all other drivers in a meaningful way.
>>
>> I've looked some more into the CAN socket implementation, and I suppose that
>> the idea of the pruss driver was really to help do the work from the
>> can_rcv_filter function in hardware.
> 
> That software filter is per socket while the hardware filter will be per
> device.

Hi all,

i took some while to get behind all the arguments for me :-)

Wolfgangs suggestion

>  A simple interface using:
> 
>   ip link set can0 type can filter <id>:<mask> [<id>:<mask> ...]
> 

indeed would just be fine - but IMHO it doesn't help for the pruss CAN driver.

The problem is, that you plan to filter on a CAN-identifier base. This is not
only very application dependent (as Kurt already pointed out) - it also does
not bring any safety that your system does not explode on heavy CAN load.

E.g. assume you need the CAN-IDs 0x100, 0x200 and 0x300 in your application
and for that reason you configure these IDs in the pruss CAN driver.

What if someone generates a 100% CAN busload exactly on CAN-ID 0x100 then?

Worst case (1MBit/s, DLC=0) you would need to handle about 21.000 irqs/s for
the correctly received CAN frames with the filtered CAN-ID 0x100 ...

At the beginnig of the SocketCAN development, we had a PowerPC (E603) @ 133MHz
that was able to handle 4 (dumb) SJA1000 CAN controllers without problems.

Maybe i should tell a bit more about what's happening at CAN frame receive time:

1. IRQ happens
2. Read CAN frame from CAN controller registers
3. Allocate a socketbuffer (skb) and queue it into the netdevice rx queue
4. Softirq handles the new skb
5. Check the (specialized/optimized) CAN-ID filters for this CAN device
6. Enqueue the data to the sockets recv buffer(s) and/or drop the skb.

This all depends heavily on Linux networking (skb handling, caching, etc) and
is pretty fast and optimized!! That was also the reason why it ran on the old
PowerPC that smoothly. The mostly seen effect if anything drops is when the
application (holding the socket) was not fast enough to handle the incoming
data. NB: For that reason we implemented a CAN content filter (CAN_BCM) that
is able to do content filtering and timeout monitoring in Kernelspace - all
performed in the SoftIRQ.

Having 'Mailboxes' bound to CAN-IDs is something that's useful for 8/16 bit
CPUs where an application is tightly bound to the embedded ECUs functionality.

IMO you should try to implement an 'open' pruss CAN driver without filtering
as it doesn't really help (see above). The networking stack can cope with the
load. In all cases (with/without filters) the reduction the irqload could be a
way to investigate (e.g. think about dropping CAN frames based on the irqload).

But you should try the 'open' way first. And i think with your current driver
you could just filter for one CAN-ID (e.g. 0x100) and then produce the heavy
CAN busload with this CAN-ID 0x100 and a second CAN node, right?

Regards,
Oliver
