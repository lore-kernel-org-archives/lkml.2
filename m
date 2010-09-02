Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0IBGcJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:32:09 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35832 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0IBGcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:32:07 -0400
X-Auth-Info: WUbTo6iI9ISgIy9v7i3Nv0EzbkjQn89NWLy2+t55g2o=
Message-ID: <4C7F450C.4010002@grandegger.com>
Date: Thu, 02 Sep 2010 08:32:44 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
CC: Andrew Chih Howe <andrew.chih.howe.khor@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        ML netdev <netdev@vger.kernel.org>, gregkh@suse.de,
        "Wang, Yong Y" <yong.y.wang@intel.com>,
        ML linux-kernel <linux-kernel@vger.kernel.org>,
        socketcan-core@lists.berlios.de,
        Morinaga <morinaga526@dsn.okisemi.com>, arjan@linux.intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Christian Pellegrin <chripell@fsfe.org>, Qi <qi.wang@intel.com>
Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_CAN driver to 2.6.35
References: <4C61EDE5.4030505@dsn.okisemi.com>	<4C62981B.8050402@grandegger.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A28EA26CC@shsmsx501.ccr.corp.intel.com>	<4C63B6C9.5050804@grandegger.com>	<D5AB6E638E5A3E4B8F4406B113A5A19A28EA29DF@shsmsx501.ccr.corp.intel.com>	<000501cb49a9$9cd4bf00$66f8800a@maildom.okisemi.com>	<4C7EA0CC.2030609@grandegger.com> <001301cb4a4d$b4c4ba80$66f8800a@maildom.okisemi.com>
In-Reply-To: <001301cb4a4d$b4c4ba80$66f8800a@maildom.okisemi.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2010 05:19 AM, Masayuki Ohtake wrote:
> ----- Original Message ----- 
> From: "Wolfgang Grandegger" <wg@grandegger.com>
> To: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
> Cc: "Andrew Chih Howe" <andrew.chih.howe.khor@intel.com>; "Qi" <qi.wang@intel.com>; "ML netdev"
> <netdev@vger.kernel.org>; <gregkh@suse.de>; "ML linux-kernel" <linux-kernel@vger.kernel.org>; "Wang, Yong Y"
> <yong.y.wang@intel.com>; <socketcan-core@lists.berlios.de>; <arjan@linux.intel.com>; "David S. Miller"
> <davem@davemloft.net>; "Christian Pellegrin" <chripell@fsfe.org>; "Samuel Ortiz" <sameo@linux.intel.com>
> Sent: Thursday, September 02, 2010 3:51 AM
> Subject: Re: [MeeGo-Dev][PATCH] Topcliff: Update PCH_CAN driver to 2.6.35
> 
>> ...
>>>>>>> - The values for the hw-specific bit-timing registers should be derived
>>>>>>>   from the calculated values in "priv->can.bittiming":
>>>>>>>
>>>>>>>   http://lxr.linux.no/#linux+v2.6.35/include/linux/can/netlink.h#L17
>>>>>>>
>>>
>>> I show current pch_can code below.
>>>
>>> +static int pch_set_bittiming(struct net_device *ndev)
>>> +{
>>> + struct pch_can_priv *priv = netdev_priv(ndev);
>>> + struct pch_can_os *dev_can_os = priv->pch_can_os_p;
>>> + const struct can_bittiming *bt = &priv->can.bittiming;
>>>
>>> Is the above TRUE, isn't it ?
>>
>> The code fragment looks good. In that function you should then *derive*
>> the values of the bit-timing registers from the data fields of "bt". For
>> the SJA1000, you find the code here:
>>
>> http://lxr.linux.no/#linux+v2.6.35/drivers/net/can/sja1000/sja1000.c#L202
>>
> 
> I can't understand the your saying.
> I think our can driver is implemented like your saying.
> 
> In function "pch_set_bittiming", get the value of the bit-timing registers from
> the data fields of "bt" at "pch_can_set_baud_custom" or "pch_can_set_baud_simple".

Please *remove* "pch_can_set_baud_custom" or "pch_can_set_baud_simple"
and use the fields of "const struct can_bittiming *bt" *directly*:

  /* Getting the appropriate register value. */
  reg_val = (((bt->brp & MSK_BITT_BRP) << BIT_BITT_BRP) |
	    ((bt->prop_seg + bt->phase_seg1 - 1) << BIT_BITT_TSEG1) |
            ...

> Could you indicate in more detail ?

Please have a closer look to the link mentioned above.

>>>>>>> - The driver should handle state changes and communicate them to the
>>>>>>>   user space via error messages, if possible.
>>>>>>>
>>> What's "state chage" mean ?
>>
>> Googling for "can bis states" returned:
>>
>>
> http://www.softing.com/home/en/industrial-automation/products/can-bus/more-can-bus/error-handling/error-states.php?navanchor=3010510
>>
>> The CAN controller usually triggers an interrupt when the state changes,
>> which allows the driver to track the CAN state and deliver that
>> information to the user space.
> 
> I could understand your saying.
> In our current code, our driver can detect state change, but doesn't notify to
> can-core module or kennel protocol stack.
> We will modify our driver to notify to these.

The code is your friend. Please have a more detailed look to the SJA1000
driver, e.g. search it for "state".

Wolfgang.
