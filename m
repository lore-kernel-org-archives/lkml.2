Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1G3Ocp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 10:32:45 -0400
Received: from lucidpixels.com ([72.73.18.11]:46789 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785Ab1G3Ock (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 10:32:40 -0400
Date: Sat, 30 Jul 2011 10:32:39 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
Message-ID: <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
References: <alpine.DEB.2.02.1107271851410.25432@p34.internal.lan> <4E318BD0.40202@lwfinger.net> <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 30 Jul 2011, Justin Piszcz wrote:

>
>
> On Sat, 30 Jul 2011, Justin Piszcz wrote:
>
>> 
>> 
>> On Sat, 30 Jul 2011, Stanislaw Gruszka wrote:
>> 
>>> We should clear skb->data not skb itself. Bug was introduced by:
>>> commit 0b8004aa12d13ec750d102ba4082a95f0107c649 "rt2x00: Properly
>>> reserve room for descriptors in skbs".
>>> 
>>> Cc: stable@kernel.org # 2.6.36+
>>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>>> ---
>>> drivers/net/wireless/rt2x00/rt2800lib.c |    3 +--
>>> 1 files changed, 1 insertions(+), 2 deletions(-)
>>> 
>>> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c 
>>> b/drivers/net/wireless/rt2x00/rt2800lib.c
>>> index 75d2c6c..f94d669 100644
>>> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>>> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>>> @@ -703,8 +703,7 @@ void rt2800_write_beacon(struct queue_entry *entry, 
>>> struct txentry_desc *txdesc)
>>> 	/*
>>> 	 * Add space for the TXWI in front of the skb.
>>> 	 */
>>> -	skb_push(entry->skb, TXWI_DESC_SIZE);
>>> -	memset(entry->skb, 0, TXWI_DESC_SIZE);
>>> +	memset(skb_push(entry->skb, TXWI_DESC_SIZE), 0, TXWI_DESC_SIZE);
>>>
>>> 	/*
>>> 	 * Register descriptor details in skb frame descriptor.
>>> -- 
>>> 1.7.4
>>> 
>> 
>> Hi,
>> 
>> Testing w/ Linux kernel 3.0:
>> 
>> # patch -p1 < ../patch3
>> patching file drivers/net/wireless/rt2x00/rt2800lib.c
>> Hunk #1 succeeded at 784 (offset 81 lines).
>> 
>> Compiled/installed.
>> 
>> Will reboot shortly, need to run a backup first, thanks.
>> 
>> Justin.
>> 
>> 
>
> Hi,
>
> Patched, its working, latency is MUCH better than before the patch!
>
> PING atomw.internal.lan (192.168.0.2) 56(84) bytes of data.
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=1 ttl=64 time=0.535 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=0.589 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=48.8 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=1.14 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=64.5 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=0.582 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=7 ttl=64 time=80.6 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=8 ttl=64 time=51.9 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=9 ttl=64 time=35.5 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=10 ttl=64 time=0.614 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=11 ttl=64 time=0.497 
> ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=12 ttl=64 time=41.5 
> ms
>
> $ uptime
> 10:19:18 up 5 min,  2 users,  load average: 1.32, 1.02, 0.47
>
> It hasn't crashed yet, if you don't hear from me/stating it has crashed 
> again,
> then you can assume its stable, I'll let you know if anything happens.
>

Hmm..

The joy was short lived :(
$ ssh: connect to host atomw port 22: No route to host

Going to see if there is a dump now.

Justin.

