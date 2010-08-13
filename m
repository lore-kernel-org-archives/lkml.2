Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761966Ab0HMST1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 14:19:27 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34318 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab0HMSTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 14:19:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=kmmxnyd6FM3dG+GYqm/wX4lq8a0EhaIrVbNvsL+vGd12FZBL6YtTQsLQHGWQYJ/k6R
         Rh9HS4wJ5A/Yiw0StshcX5bIo7HX84rA/5F6YlMDMYDuSUG3WickalnvmPWNkZZ+BaG6
         mVH9F05oLryRNIe/dbR08fvC/G1VD1hWIBsD4=
Date: Fri, 13 Aug 2010 22:18:33 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Andrew Lunn <andrew@lunn.ch>,
        Sven Eckelmann <sven.eckelmann@gmx.de>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: batman-adv: design suggestions
Message-ID: <20100813181833.GA5632@albatros>
References: <20100809203403.GA16183@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100809203403.GA16183@albatros>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 00:34 +0400, Vasiliy Kulikov wrote:
> 2) It seems to me that NF_HOOK() at hard-interface.c:458 is misused:
> 
>     ...
> 	ret = NF_HOOK(PF_BRIDGE, NF_BR_LOCAL_IN, skb, dev, NULL,
> 		      batman_skb_recv_finish);
> 	if (ret != 1)
> 		goto err_out;
> 
> 	/* packet should hold at least type and version */
> 	if (unlikely(skb_headlen(skb) < 2))
> 		goto err_free;
> 
> 	/* expect a valid ethernet header here. */
> 	if (unlikely(skb->mac_len != sizeof(struct ethhdr)
> 				|| !skb_mac_header(skb)))
> 		goto err_free;
>     ...
> 
>     static int batman_skb_recv_finish(struct sk_buff *skb)
>     {
>         return NF_ACCEPT;
>     }
> 
>   As I understand, if there is any hook that returns NF_STOLEN, then skb
>   is leaked.

New ideas ;)

a) Currently processing of tables does not confirm to its names.

 From `man ebtables`:
    ...
    filter  is  the  default  table and contains three built-in
    chains: INPUT (for frames destined for the  bridge itself,
    on  the  level of the MAC destination address), OUTPUT (for
    locally-generated or (b)routed  frames)  and  FORWARD (for
    frames being forwarded by the bridge).
    nat is mostly used to change the mac addresses and contains
    three built-in chains: PREROUTING (for altering  frames as
    soon  as they come in), OUTPUT (for altering locally gener‐
    ated or (b)routed  frames  before  they  are  bridged) and
    POSTROUTING  (for  altering  frames as they are about to go
    out). A small note on the naming of chains  PREROUTING and
    POSTROUTING: it would be more accurate to call them PREFOR‐
    WARDING and POSTFORWARDING, but for all those who come from
    the  iptables  world  to  ebtables it is easier to have the
    same names. Note that you can change the name (-E)  if you
    don't like the default.
    ...

   Second argument to this NF_HOOK() should be NF_BR_PRE_ROUTING as it is not
   know yet whether this packet is for local machine.

  NF_BR_LOCAL_IN should locate in interface_rx just before netif_rx [*] - see below
  NF_BR_LOCAL_OUT in interface_tx before big 'if (is_bcast ...)' [*]
  NF_BR_POST_ROUTING in send_skb_packet instead of current NF_BR_LOCAL_OUT
  NF_BR_FORWARD somewhere in recv_{bat,icmp,unicast,bcast}_packet() if
    packet is being forwarded [*]


b) Why do you use bridge tables at all? This layer does not know
anything about batman layer, only ethernet that is only a tunnel for
batman. So, it is able to hook traffic from concrete prev-hop routers,
but not from original sources of packets. I think it is not enough for
network filter.  
   Also if you want to process [*] cases you have to append fake
ethernet headers before network header as NF_HOOK() would use ethernet
header.

So, I see 2 solutions:
 1) write your own table layer similar to ebtables & userland tool :) It
is costly, but you'll be able to fully filter/hook of batman traffic.
 2) write ebtables module to check batman header fields. It is slightly 
slower, but potentially may do the same as (1).

However, I think it is not so important and may be rated as feature.


c) Maybe it's better to give user an ability to tune some network
parameters? Like ttl, whether answer to icmp, ratelimit of generating
output icmps, etc.


d) Why do you send icmp TTL exceeded for the icmp itself? E.g. in case
of loop or/and small default TTL you'll probably get a storm of icmps.
Exactly in this case IP silently drops TTL exceeded icmps ;)


Hope this information will be usefull.


Thanks,
Vasiliy.
