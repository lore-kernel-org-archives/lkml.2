Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123Ab0DNWs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:48:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:51824 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757035Ab0DNWs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:48:28 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Michael Barkowski <michaelbarkowski@ruggedcom.com>
Cc: "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
       "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: hdlc_ppp: why no detach()?
References: <4BC32B00.1030600@ruggedcom.com>
Date: Thu, 15 Apr 2010 00:48:25 +0200
In-Reply-To: <4BC32B00.1030600@ruggedcom.com> (Michael Barkowski's message of
	"Mon, 12 Apr 2010 10:15:28 -0400")
Message-ID: <m3633todl2.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michael,

Michael Barkowski <michaelbarkowski@ruggedcom.com> writes:

> I am looking at your hdlc_ppp code and I don't understand: why is there
> not the equivalent of fr_detach() in there?

I assume you mean .detach = fr_destroy(). It's used only to kill
subdevices, i.e. it has nothing to do with the interface being up/down.

> pc8300_drv:cpc_remove_one() frees netdevs quite confidently but I wonder
> how it can be so sure that there are not skbs in hdlc_ppp's tx_queue
> associated with those devices before freeing them....q

Theoretically all paths adding skbs to the tx_queue should send them out
before returning (possibly also on behalf of other devices). However I
wonder if it's the case. Let's see: Only ppp_tx_cp() adds to the queue
directly:
- ppp_rx() (calls ppp_tx_flush())
- ppp_timer (calls ppp_tx_flush())
- ppp_cp_event():
  - ppp_cp_parse_cr() (calls ppp_tx_flush())
  - ppp_stop() calls ppp_cp_event(), but it won't queue any skb, it only
    marks the connection as closed and does the same to IPCP and IPV6CP.

This means the problematic part is ppp_start() which calls
ppp_cp_event(LCP, START) = IRC | SCR | 3 meaning
Initialize-Restart-Count, Send-Configure-Request and change state to
REQ_SENT. This causes two problems:

1. The SCR packet will be delayed by 2 seconds (both first and second
   SCR will be sent the same time). Perhaps we delay only a little
   (instead of full 2 seconds) and only then send the initial packet.

2. (as you noted) the skb will be added to tx_queue and left there. If
   we happen to "ifconfig up" and "rmmod driver" before receiving any
   packet and before ppp->req_timeout (2 seconds) and before any other
   PPP interface does the same, we will eventually get skb with invalid
   ->dev. This is simple to drain in .close (detach is a wrong place
   since it may be called long after the interface is deactivated, there
   is no need to delay it past .close). The fix for #1 will already fix
   #2, but the redundant safety doesn't cost us anything.

Thanks for noting the problem, I'll post a patch shortly.

Also it seems the timeouts etc. should be configurable. ATM we're only
fixing bugs, good.
-- 
Krzysztof Halasa
