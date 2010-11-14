Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab0KNI7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 03:59:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59156 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754317Ab0KNI7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 03:59:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=PTGViJ2YQjdPkfFviThdAqbU5wUeYTApN7ZNGbHT4fP9k29tQC0XRcpDgGzCt2J2CC
         iVMKKTy/BNgY8mWYXZZOncTgM4GwnfZleMr8e1hDoO5QCgw/Ev4tczaI2b/43I+zOWoH
         OL9C1vw2KunBtA43mxzx2twkkQuUkVhLGzCw0=
Subject: Re: [PATCH/RFC] netfilter: nf_conntrack_sip: Handle quirky Cisco
 phones
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "Pekka Savola (ipv6)" <pekkas@netcore.fi>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
In-Reply-To: <28d666269c390965f1a4edca42f93c12@localhost>
References: <28d666269c390965f1a4edca42f93c12@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 14 Nov 2010 09:59:35 +0100
Message-ID: <1289725175.2743.65.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le dimanche 14 novembre 2010 à 00:32 -0800, Kevin Cernekee a écrit :
> Most SIP devices use a source port of 5060/udp on SIP requests, so the
> response automatically comes back to port 5060:
> 
> phone_ip:5060 -> proxy_ip:5060   REGISTER
> proxy_ip:5060 -> phone_ip:5060   100 Trying
> 
> The newer Cisco IP phones, however, use a randomly chosen high source
> port for the SIP request but expect the response on port 5060:
> 
> phone_ip:49173 -> proxy_ip:5060  REGISTER
> proxy_ip:5060 -> phone_ip:5060   100 Trying
> 
> Standard Linux NAT, with or without nf_nat_sip, will send the reply back
> to port 49173, not 5060:
> 
> phone_ip:49173 -> proxy_ip:5060  REGISTER
> proxy_ip:5060 -> phone_ip:49173  100 Trying
> 
> But the phone is not listening on 49173, so it will never see the reply.
> 
> This issue was seen on a Cisco CP-7965G, firmware 8-5(3).  It appears
> to be a well-known problem on 7941 and newer:
> 
> http://www.voip-info.org/wiki/view/Standalone+Cisco+7941%252F7961+without+a+local+PBX
> 
> Search for "Connecting to the outside world"
> 
> I contacted Cisco support and they were not amenable to changing the
> behavior.  It appears to be RFC3261-compliant, as the "Sent-by port"
> field in the request specifies 5060:
> 

There is a difference between being RFC compliant, and being usable.

Most SIP sotfwares I know will break with such a stupid CISCO behavior.



> 18.2.2 Sending Responses
> 
>    The server transport uses the value of the top Via header field in
>    order to determine where to send a response.  It MUST follow the
>    following process:
> 
> ...
> 
>       o  Otherwise (for unreliable unicast transports), if the top Via
>          has a "received" parameter, the response MUST be sent to the
>          address in the "received" parameter, using the port indicated
>          in the "sent-by" value, or using port 5060 if none is specified
>          explicitly.  If this fails, for example, elicits an ICMP "port
>          unreachable" response, the procedures of Section 5 of [4]
>          SHOULD be used to determine where to send the response.
> 
> This patch modifies nf_*_sip to work around this quirk, by rewriting
> the response port to 5060 when the following conditions are met:
> 
>  - User-Agent starts with "Cisco"
> 
>  - Incoming TTL was exactly 64 (meaning that our system is the phone's
>    local router, not an intermediate router)
> 

This seems a hack to me, sorry. How many different vendors will switch
to "Cisco" broken way, and we have to patch over and over ?

I would like to get an exact SIP exchange to make sure their is not
another way to handle this without adding a "Cisco" string somewhere...

Please provide a pcap or tcpdump -A

Thanks


