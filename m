Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab0IZA1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 20:27:42 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:61238 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752459Ab0IZA1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 20:27:41 -0400
Date: Sat, 25 Sep 2010 21:14:48 -0300
From: "Gustavo F. Padovan" <padovan@profusion.mobi>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        mathewm@codeaurora.org
Subject: Re: Deadlock in Bluetooth code in 2.6.36
Message-ID: <20100926001448.GA2979@vigoh>
References: <1285104013-9946-1-git-send-email-padovan@profusion.mobi>
 <20100924.211824.242130957.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924.211824.242130957.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* David Miller <davem@davemloft.net> [2010-09-24 21:18:24 -0700]:

> From: "Gustavo F. Padovan" <padovan@profusion.mobi>
> Date: Tue, 21 Sep 2010 18:20:12 -0300
> 
> > My questions here is on how to fix this properly. Maybe
> > sock_alloc_send_skb() should not be used with SOCK_STREAM and reliable
> > protocols and I'm not aware of that? And should I use something like
> > sk_stream_alloc_skb() instead?
> > 
> > Any comments are welcome. With lucky we can fix that for 2.6.36 and
> > together with others fixes we have queued deliver a fully functional
> > L2CAP layer on 2.6.36.
> 
> Use sock_alloc_send_skb() as you do now, but if it fails wait for socket
> space to become available just like TCP does, then loop back and try to
> allocate again if the space-wait doesn't return an error.

sock_alloc_send_skb() doesn't fail when there is no space available
it sleeps and try again later. That is the problem. So if
sock_alloc_send_skb() is called with the socket lock held potentially we
can have a starvation in the backlog queue and then the deadlock due to
be unable to read the acknowledgments packets residing in the backlog
queue.

Our current solution is release the lock before call
sock_alloc_send_skb() and acquire it again when sock_alloc_send_skb()
returns. Patch follows:

------
Bluetooth: Fix deadlock in the ERTM logic                        
                                                                                      
The Enhanced Retransmission Mode(ERTM) is a reliable mode of operation               
of the Bluetooth L2CAP layer. Think on it like a simplified version of                
TCP.                                                                                  
The problem we were facing here was a deadlock. ERTM uses a backlog                   
queue to queue incomimg packets while the user is helding the lock. At                
some moment the sk_sndbuf can be exceeded and we can't alloc new skbs                 
then the code sleep with the lock to wait for memory, that stalls the                 
ERTM connection once we can't read the acknowledgements packets in the                
backlog queue to free memory and make the allocation of outcoming skb
successful.

This patch actually affect all users of bt_skb_send_alloc(), i.e., all
L2CAP modes and SCO.

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
Signed-off-by: Ulisses Furquim <ulisses@profusion.mobi>
---
 include/net/bluetooth/bluetooth.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 27a902d..118b69b 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -161,10 +161,21 @@ static inline struct sk_buff *bt_skb_send_alloc(struct sock *sk, unsigned long l
 {
        struct sk_buff *skb;
 
+       release_sock(sk);
        if ((skb = sock_alloc_send_skb(sk, len + BT_SKB_RESERVE, nb, err))) {
                skb_reserve(skb, BT_SKB_RESERVE);
                bt_cb(skb)->incoming  = 0;
        }
+       lock_sock(sk);
+
+       if (*err)
+               return NULL;
+
+       *err = sock_error(sk);
+       if (*err) {
+               kfree_skb(skb);
+               return NULL;
+       }
 
        return skb;
 }
-- 
1.7.2.2

-- 
Gustavo F. Padovan
ProFUSION embedded systems - http://profusion.mobi
