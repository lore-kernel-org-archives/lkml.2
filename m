Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519Ab2E1IeK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 04:34:10 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50349 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab2E1IeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 04:34:07 -0400
X-Sasl-enc: QJchpFSU6azoyz5pgvpBaygptauztJnIJ98VpmXnSWlg 1338194047
Message-ID: <4FC3387D.8080904@fastmail.fm>
Date: Mon, 28 May 2012 09:34:05 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp.c:1610 tcp_recvmsg+0xb1b/0xc70()
References: <4FBFEACC.8040601@fastmail.fm>  <1337978725.10135.0.camel@edumazet-glaptop>  <1337979331.10135.2.camel@edumazet-glaptop> <4FC0BCE1.6070601@fastmail.fm>  <1338127184.3670.50.camel@edumazet-glaptop> <4FC24987.4090708@fastmail.fm>  <1338140156.3786.10.camel@edumazet-glaptop>  <4FC27CE7.20604@fastmail.fm> <1338164727.2240.14.camel@edumazet-glaptop>
In-Reply-To: <1338164727.2240.14.camel@edumazet-glaptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2012 01:25 AM, Eric Dumazet wrote:
> On Sun, 2012-05-27 at 20:13 +0100, Jack Stone wrote:
> 
>> Could it be something to do with my staging network driver?
> 
> drivers/staging/rtl8712/rtl8712_recv.c
> 
> line 1096
> 
> precvframe->u.hdr.pkt = skb_clone(pskb, GFP_ATOMIC);
> 
> This looks very wrong.
> Make sure you never _never_ hit this path.
> 

I've applied the following debugging patch. Thanks for the suggestion.

diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 8e82ce2..fed62f8 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -1082,23 +1082,16 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
                 * 4 is for skb->data 4 bytes alignment. */
                alloc_sz += 6;
                pkt_copy = netdev_alloc_skb(padapter->pnetdev, alloc_sz);
-               if (pkt_copy) {
-                       pkt_copy->dev = padapter->pnetdev;
-                       precvframe->u.hdr.pkt = pkt_copy;
-                       skb_reserve(pkt_copy, 4 - ((addr_t)(pkt_copy->data)
-                                   % 4));
-                       skb_reserve(pkt_copy, shift_sz);
-                       memcpy(pkt_copy->data, pbuf, tmp_len);
-                       precvframe->u.hdr.rx_head = precvframe->u.hdr.rx_data =
-                                precvframe->u.hdr.rx_tail = pkt_copy->data;
-                       precvframe->u.hdr.rx_end = pkt_copy->data + alloc_sz;
-               } else {
-                       precvframe->u.hdr.pkt = skb_clone(pskb, GFP_ATOMIC);
-                       precvframe->u.hdr.rx_head = pbuf;
-                       precvframe->u.hdr.rx_data = pbuf;
-                       precvframe->u.hdr.rx_tail = pbuf;
-                       precvframe->u.hdr.rx_end = pbuf + alloc_sz;
-               }
+               WARN_ON(!pkt_copy)
+               pkt_copy->dev = padapter->pnetdev;
+               precvframe->u.hdr.pkt = pkt_copy;
+               skb_reserve(pkt_copy, 4 - ((addr_t)(pkt_copy->data)
+                           % 4));
+               skb_reserve(pkt_copy, shift_sz);
+               memcpy(pkt_copy->data, pbuf, tmp_len);
+               precvframe->u.hdr.rx_head = precvframe->u.hdr.rx_data =
+                        precvframe->u.hdr.rx_tail = pkt_copy->data;
+               precvframe->u.hdr.rx_end = pkt_copy->data + alloc_sz;
                recvframe_put(precvframe, tmp_len);
                recvframe_pull(precvframe, drvinfo_sz + RXDESC_SIZE);
                /* because the endian issue, driver avoid reference to the
