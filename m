Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934137Ab1IJWYy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 18:24:54 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57108 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933810Ab1IJWYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 18:24:53 -0400
Message-ID: <4E6BE469.3060502@vlnb.net>
Date: Sat, 10 Sep 2011 18:27:53 -0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.17) Gecko/20110424 Mnenhy/0.8.3 Thunderbird/3.1.10
MIME-Version: 1.0
To: open-iscsi@googlegroups.com
CC: Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Full duplex
References: <4E6047A9.1020208@vlnb.net> <4E610108.6090602@cs.wisc.edu> <4E6971F4.2020903@vlnb.net> <4E6BDA55.5010203@vlnb.net>
In-Reply-To: <4E6BDA55.5010203@vlnb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Yb4jM86m0Kh17ZqVWT+WSY6TcxZOXIHP08vtbxL56oZ
 RZ3uERV4k24+Qf5xUsIuYWKgUAv2WP4iOMZUXcN7dPrJmouJcN
 4LaQWGukMa4JzWO+xrOl/eO/pwZlrDtfdY2iE0Rfu8c9vRKPrm
 k4E+Zvteo4kEqm+/m/JjbHE2zG1aGPkzvBNR63nX6Ew5HMjRk2
 GHnOqYVpDcgD8DndRlH/V5Zx2mqWm0GBPEstq10cMhLrAYoWZD
 00osZrWn+CRvFq9Ho1NWNGaiqyFIHKlsCw4GiAN2FdfhbJ63dG
 Y434owLQlWU4ibvIXFQVCcfhpJjngp3/l1vKDtU6P2th64U5PP
 +eMc22ifwneQhcULLUDM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vladislav Bolkhovitin, on 09/10/2011 05:44 PM wrote:
> Vladislav Bolkhovitin, on 09/08/2011 09:55 PM wrote:
>> Mike Christie, on 09/02/2011 12:15 PM wrote:
>>> On 09/01/2011 10:04 PM, Vladislav Bolkhovitin wrote:
>>>> Hi,
>>>>
>>>> I've done some tests and looks like open-iscsi doesn't support full duplex speed
>>>> on bidirectional data transfers from a single drive.
>>>>
>>>> My test is simple: 2 dd's doing big transfers in parallel over 1 GbE link from a
>>>> ramdisk or nullio iSCSI device. One dd is reading and another one is writing. I'm
>>>> watching throughput using vmstat. When any of the dd's working alone, I have full
>>>> single direction link utilization (~120 MB/s) in both directions, but when both
>>>> transfers working in parallel, throughput on any of them immediately drops in 2
>>>> times to 55-60 MB/s (sum is the same 120 MB/s).
>>>>
>>>> For sure, I tested bidirectional possibility of a single TCP connection and it
>>>> does provide near 2 times throughput increase (~200 MB/s).
>>>>
>>>> Interesting, that doing another direction transfer from the same device imported
>>>> from another iSCSI target provides expected full duplex 2x aggregate throughput
>>>> increase.
>>>>
>>>> I tried several iSCSI targets + I'm pretty confident that iSCSI-SCST is capable to
>>>> provide full duplex transfers, but from some look on the open-iscsi code I can't
>>>> see the serialization point in it. Looks like open-iscsi receives and sends data
>>>> in different threads (the requester process and per connection iscsi_q_X workqueue
>>>> correspondingly), so should be capable to have full duplex.
>>>
>>> Yeah, we send from the iscsi_q workqueue and receive from the network
>>> softirq if the net driver supports NAPI.
>>>>
>>>> Does anyone have idea what could be the serialization point preventing full duplex
>>>> speed?
>>>
>>> Did you do any lock profiliing and is the session->lock look the
>>> problem? It is taken in both the receive and xmit paths and also the
>>> queuecommand path.
>>
>> Just done it. /proc/lock_stat says that there is no significant contention for
>> session->lock.
>>
>> >From other side, session->lock is a spinlock, so, if it was the serialization
>> point, we would see big CPU consumption on the initiator. But we have a plenty of
>> CPU time there.
>>
>> So, there must be other serialization point.
> 
> Update. Using sg_dd with blk_sgio=1 (SG_IO) instead of dd I was able to achieve
> bidi speed 92 MB/s in each direction.
> 
> Thus, the iSCSI stack works as expected well and the serialization point must be
> somewhere higher in the block stack. Both buffered and direct dd demonstrate the
> same serialized behavior described above.

...even using the corresponding iSCSI device formatted in ext4 with the dd's
working over 2 _separate_ files.

In other words, apparently, for user space applications not smart enough to use sg
interface there is no way to use full duplex capability of the link. No tricks can
give them the double throughput.

I tried with Fibre Channel and see the same with the only difference that if the
same device from the same target imported as 2 LUNs (i.e. as multipath), both
those LUNs can work bidirectionally. In iSCSI you need to import this device from
2 separate iSCSI targets to achieve that.

Vlad
