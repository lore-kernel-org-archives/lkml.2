Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0JAM7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 08:59:35 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53558 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932466Ab0JAM7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 08:59:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MMxO+CXXNhPkVk30hqWMwqg12CD+NN5VLT/lD7O0C/uFGORSuFrr8VVULAb9mZEhfM
         z7mXodCLM/oyNSfTrWfah1Z2w5+wgvMi5qqaWt+1KbSzKTlo0BkbrwUDT0nnedoTVLry
         k7DVVgZFFwWiUt7nS5klpOn4k202HNAn46lvk=
Subject: Re: Packet time delays on multi-core systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Alexey Vlasov <renton@renton.name>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
In-Reply-To: <20101001101650.GD4094@beaver.vrungel.ru>
References: <20100929191851.GC86786@beaver.vrungel.ru>
	 <1285796721.5211.156.camel@edumazet-laptop>
	 <20100930062419.GD86786@beaver.vrungel.ru>
	 <1285828432.5211.812.camel@edumazet-laptop>
	 <20100930122321.GA1575@beaver.vrungel.ru>
	 <1285850669.2615.426.camel@edumazet-laptop>
	 <20100930173732.GB4094@beaver.vrungel.ru>
	 <1285869782.2615.920.camel@edumazet-laptop>
	 <20100930181556.GC4094@beaver.vrungel.ru>
	 <1285872765.2615.1008.camel@edumazet-laptop>
	 <20101001101650.GD4094@beaver.vrungel.ru>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 14:59:26 +0200
Message-ID: <1285937966.2641.117.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 01 octobre 2010 à 14:16 +0400, Alexey Vlasov a écrit :

> I have also found that:
> 1. rx overruns is increasing.
> 2. rx_queue_drop_packet_count is increasing.

So you flood machine with packets, its not an idle one ?

I thought you were doing experiments with light trafic.


> # ethtool -S eth0 | grep drop
>      tx_dropped: 0
>      rx_queue_drop_packet_count: 1260743751
>      dropped_smbus: 0
>      rx_queue_0_drops: 0
>      rx_queue_1_drops: 0
>      rx_queue_2_drops: 0
>      rx_queue_3_drops: 0
> 


ethtool -S eth0   (full output, not small parts)


> 3. By sending SYN-packets by hping, RST packet doesn't send, but I don't know may 
> be it is just some feature in 2.6.32.
> newbox # hping -c 1 -S -p 80 111.111.111.111
> HPING 111.111.111.111 (eth0 111.111.111.111): S set, 40 headers + 0 data bytes
> len=46 ip=111.111.111.111 ttl=58 DF id=11471 sport=80 flags=SA seq=0 win=65535 rtt=99.0 ms
> 
> --- 111.111.111.111 hping statistic ---
> 1 packets tramitted, 1 packets received, 0% packet loss
> round-trip min/avg/max = 99.0/99.0/99.0 ms
> 
> 13:59:07.439528 IP newbox.2777 > 111.111.111.111.80: S 345595033:345595033(0) win 512
> 13:59:07.439626 IP 111.111.111.111.80 > newbox.2777: S 1178827395:1178827395(0) ack 345595034 win 65535 <mss 1460>
> 13:59:10.439368 IP 111.111.111.111.80 > newbox.2777: S 1178827395:1178827395(0) ack 345595034 win 65535 <mss 1460>
> 13:59:16.439313 IP 111.111.111.111.80 > newbox.2777: S 1178827395:1178827395(0) ack 345595034 win 65535 <mss 1460>
> 13:59:28.439206 IP 111.111.111.111.80 > newbox.2777: S 1178827395:1178827395(0) ack 345595034 win 65535 <mss 1460>
> 
> As a result I got doubles:

Are you playing with trafic shaping ?

tc -s -d qdisc



> DUP! len=46 ip=111.111.111.111 ttl=58 DF id=27454 sport=80 flags=SA seq=0 win=65535 rtt=3137.8 ms
> 
> Example of another TCP-session from 2.6.28 kernel:
> oldbox # hping -c 1 -S -p 80 111.111.111.111
> HPING 111.111.111.111 (eth0 111.111.111.111): S set, 40 headers + 0 data bytes
> len=46 ip=111.111.111.111 ttl=58 DF id=53180 sport=80 flags=SA seq=0 win=65535 rtt=2.9 ms
> 
> --- 111.111.111.111 hping statistic ---
> 1 packets tramitted, 1 packets received, 0% packet loss
> round-trip min/avg/max = 2.9/2.9/2.9 ms
> 
> 14:01:45.225136 IP oldbox.2776 > 111.111.111.111.80: S 1983626200:1983626200(0) win 512
> 14:01:45.225288 IP 111.111.111.111.80 > oldbox.2776: S 3796385036:3796385036(0) ack 1983626201 win 65535 <mss 1460>
> 14:01:45.227990 IP oldbox.2776 > 111.111.111.111.80: R 1983626201:1983626201(0) win 0
> 


