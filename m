Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab0IAREU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 13:04:20 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:34084 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab0IARET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 13:04:19 -0400
X-RZG-AUTH: :P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrAyK0j4gdocUeI5dkns1Rb9x0bmito
X-RZG-CLASS-ID: mo00
Message-ID: <4C7E8784.9060509@hartkopp.net>
Date: Wed, 01 Sep 2010 19:04:04 +0200
From: Oliver Hartkopp <socketcan@hartkopp.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Wolfgang Grandegger <wg@grandegger.com>,
        "Wang, Yong Y" <yong.y.wang@intel.com>, arjan@linux.intel.com,
        gregkh@suse.de, Qi <qi.wang@intel.com>,
        Andrew Chih Howe <andrew.chih.howe.khor@intel.com>,
        ML linux-kernel <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>, socketcan-core@lists.berlios.de,
        Samuel Ortiz <sameo@linux.intel.com>, Barry Song <21cnbao@gmail.com>,
        Christian Pellegrin <chripell@fsfe.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: out-of-order tx objects - was Re: [MeeGo-Dev][PATCH] Topcliff: Update
 PCH_CAN driver to 2.6.35
References: <4C61EDE5.4030505@dsn.okisemi.com> <4C62981B.8050402@grandegger.com> <D5AB6E638E5A3E4B8F4406B113A5A19A28EA26CC@shsmsx501.ccr.corp.intel.com> <4C63B6C9.5050804@grandegger.com> <D5AB6E638E5A3E4B8F4406B113A5A19A28EA29DF@shsmsx501.ccr.corp.intel.com> <000501cb49a9$9cd4bf00$66f8800a@maildom.okisemi.com>
In-Reply-To: <000501cb49a9$9cd4bf00$66f8800a@maildom.okisemi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ohtake,

i'm only picking up the out-of-order issue here ...

On 01.09.2010 09:45, Masayuki Ohtake wrote:

>>>>> - I see that the driver uses many TX and RX objects. How do you avoid
>>>>>   out-of-order transmission and reception?
>>>> What do you mean out-of-order RX and TX?
>>>> Atom processor only supports in-order execution, and PCIe-based peripherals
>>> can solve it with consumer-producer model. Actually IC designer will take care
>>> of out-of-order PCIe CPLD transaction.
>>>
>>> I mean out-of-order transmission to or from the CAN bus. This is handled
>>> by the CAN controller hardware. It has nothing to to with the processor.
> Cannot avoid occurring rx or tx our-of-order.

The CAN frames that are sent by the local system have to touch the wire in the
same order as you put them into the socket as user.

An example:

You send CAN-frames with CAN Identifiers via can-raw sockets

0x123
0x456
0x010

and of course you expect these frames sent in exactly this order.
This is easy to archive as you get each of these CAN frames out of the
netdevices tx-queue in this order.

The problems comes up when you use multiple "tx objects" of your CAN
controller. Some CAN controllers have a "magic intelligence" that leads to
some re-ordering according to the CAN-Identifiers priority.

E.g.

0x123
0x456
0x010

leads to

0x123
0x010
0x456

because you pushed these CAN-frames into different tx objects and the CAN
controller sorts them on its own by priority. For CAN newbies: A lower CAN-ID
value has a higher priority in arbitration on the *physical* layer.

In the example above the CAN controller checks after sending the 0x123 CAN
frame if there's a priority order in the tx objects that are ready to send,
and selects 0x010 ...

This behaviour might be interesting in single-user/single-application
environments - but it is just wrong in multi-user systems where several
different applications use the (same) CAN bus. Standard networking behaviour.

Please ensure that the CAN frame order given by the tx-queue of the Linux
kernel netdevice infrastructure is send on the wire in the same order.

This usually leads to the use of ONLY ONE tx object of your CAN controller.
Probably you can use two tx objects to increase the throughput if this does
not have any impact to the frame order. See your controllers documentation for
details about this tx object behaviour.

I hope this makes the question of Wolfgang a bit clearer :-)

Regards,
Oliver
