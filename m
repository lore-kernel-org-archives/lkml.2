Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab3AFHfd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 02:35:33 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:61199 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945Ab3AFHf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 02:35:28 -0500
Subject: Re: Major network performance regression in 3.7
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20130106025256.GY16031@1wt.eu>
References: <20130105214958.GA19814@1wt.eu>
	 <1357427926.1678.4771.camel@edumazet-glaptop>
	 <20130105232913.GQ16031@1wt.eu>
	 <1357430523.1678.4901.camel@edumazet-glaptop>
	 <20130106005053.GS16031@1wt.eu>
	 <1357435276.1678.5067.camel@edumazet-glaptop>
	 <20130106013027.GV16031@1wt.eu>
	 <1357436430.1678.5111.camel@edumazet-glaptop>
	 <1357437086.1678.5135.camel@edumazet-glaptop>
	 <1357438591.1678.5205.camel@edumazet-glaptop>
	 <20130106025256.GY16031@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jan 2013 23:35:24 -0800
Message-ID: <1357457724.1678.5941.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-01-06 at 03:52 +0100, Willy Tarreau wrote:

> OK so I observed no change with this patch, either on the loopback
> data rate at >16kB MTU, or on the myri. I'm keeping it at hand for
> experimentation anyway.
> 

Yeah, there was no bug. I rewrote it for net-next as a cleanup/optim
only.

> Concerning the loopback MTU, I find it strange that the MTU changes
> the splice() behaviour and not send/recv. I thought that there could
> be a relation between the MTU and the pipe size, but it does not
> appear to be the case either, as I tried various sizes between 16kB
> and 256kB without achieving original performance.


It probably is related to a too small receive window, given the MTU was
multiplied by 4, I guess we need to make some adjustments

You also could try :

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 1ca2536..b68cdfb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -1482,6 +1482,9 @@ int tcp_read_sock(struct sock *sk, read_descriptor_t *desc,
 					break;
 			}
 			used = recv_actor(desc, skb, offset, len);
+			/* Clean up data we have read: This will do ACK frames. */
+			if (used > 0)
+				tcp_cleanup_rbuf(sk, used);
 			if (used < 0) {
 				if (!copied)
 					copied = used;


