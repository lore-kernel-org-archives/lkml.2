Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103Ab0IASvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 14:51:20 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:43028 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563Ab0IASvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 14:51:18 -0400
X-Auth-Info: n8NluNjHG8ZdYGxbJ3Qk5Kqo9THYCA3F5pb43Ougtf8=
Message-ID: <4C7EA0CC.2030609@grandegger.com>
Date: Wed, 01 Sep 2010 20:51:56 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Andrew Chih Howe <andrew.chih.howe.khor@intel.com>, Qi <qi.wang@intel.com>,
        ML netdev <netdev@vger.kernel.org>, gregkh@suse.de,
        ML linux-kernel <linux-kernel@vger.kernel.org>,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        socketcan-core@lists.berlios.de, arjan@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Christian Pellegrin <chripell@fsfe.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_CAN driver to 2.6.35
References: <4C61EDE5.4030505@dsn.okisemi.com>	<4C62981B.8050402@grandegger.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A28EA26CC@shsmsx501.ccr.corp.intel.com>	<4C63B6C9.5050804@grandegger.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A28EA29DF@shsmsx501.ccr.corp.intel.com> <000501cb49a9$9cd4bf00$66f8800a@maildom.okisemi.com>
In-Reply-To: <000501cb49a9$9cd4bf00$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/01/2010 09:45 AM, Masayuki Ohtake wrote:
> Sorry, for late response.
> ----- Original Message ----- 
> From: "Wang, Qi" <qi.wang@intel.com>
> To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
> Cc: "Khor, Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>; <gregkh@suse.de>; <arjan@linux.intel.com>; "Wang, Yong
> Y" <yong.y.wang@intel.com>; "Wolfgang Grandegger" <wg@grandegger.com>
> Sent: Thursday, August 12, 2010 6:00 PM
> Subject: RE: [MeeGo-Dev][PATCH] Topcliff: Update PCH_CAN driver to 2.6.35
...
>>>>> - The values for the hw-specific bit-timing registers should be derived
>>>>>   from the calculated values in "priv->can.bittiming":
>>>>>
>>>>>   http://lxr.linux.no/#linux+v2.6.35/include/linux/can/netlink.h#L17
>>>>>
> 
> I show current pch_can code below.
> 
> +static int pch_set_bittiming(struct net_device *ndev)
> +{
> + struct pch_can_priv *priv = netdev_priv(ndev);
> + struct pch_can_os *dev_can_os = priv->pch_can_os_p;
> + const struct can_bittiming *bt = &priv->can.bittiming;
> 
> Is the above TRUE, isn't it ?

The code fragment looks good. In that function you should then *derive*
the values of the bit-timing registers from the data fields of "bt". For
the SJA1000, you find the code here:

http://lxr.linux.no/#linux+v2.6.35/drivers/net/can/sja1000/sja1000.c#L202

>>>>> - The driver should handle state changes and communicate them to the
>>>>>   user space via error messages, if possible.
>>>>>
> What's "state chage" mean ?

Googling for "can bis states" returned:

http://www.softing.com/home/en/industrial-automation/products/can-bus/more-can-bus/error-handling/error-states.php?navanchor=3010510

The CAN controller usually triggers an interrupt when the state changes,
which allows the driver to track the CAN state and deliver that
information to the user space.

>>>>> - The driver should report errors to the user space via error messages.
>>>>>
> Is the above mean using alloc_can_err_skb and set error info and notify to kernel with netif_rx ?

Yes. Please search "Documentation/networking/can.txt" for "error frames"
for further information.

>>>>> - Bus errors seem not to be handled properly.I'm missing can_bus_off().
>>>>>   Does the controller recover from bus-off automatically?
> No.
> CAN driver recovers from Bus-off state.

You mean: "It does *not" recover automatically"! Right?

> 
>>>>>
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

It is a *requirement* as Oliver already pointed out. It's easy to
achieve if just one TX object is used but it might be tricky with more
than one.

Wolfgang.
