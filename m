Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab2CZJFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 05:05:25 -0400
Received: from mail4.ccl.ru ([195.222.140.73]:52398 "EHLO mail4.ccl.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254Ab2CZJFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 05:05:24 -0400
Message-ID: <4F703140.5030005@permonline.ru>
Date: Mon, 26 Mar 2012 15:05:04 +0600
From: Mike Sinkovsky <msink@permonline.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Ethernet driver for the WIZnet W5300 chip
References: <1332149037-12025-1-git-send-email-msink@permonline.ru> <1332586938-2804-1-git-send-email-msink@permonline.ru> <1332605415.3487.14.camel@edumazet-laptop>
In-Reply-To: <1332605415.3487.14.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24.03.2012 22:10, Eric Dumazet wrote:
> As there is no tx interrupt at the end of transmit to eventually XON the
> queue, you cant XOFF it when there it no room in transmit queue.

Actually there is, but is unused in original driver, don't know why.


> Rule to use NETDEV_TX_BUSY is :
>
> Before returning NETDEV_TX_BUSY, qdisc must have been stopped by
> netif_stop_queue(ndev) (and tx completion might call netif_wake_queue()
> later)

I tried handle this situation, and it seems to work perfectly:

@@ -377,7 +377,8 @@ static int w5300_start_tx(struct sk_buff *skb, 
struct net_device *ndev)
          struct w5300_private *priv = netdev_priv(ndev);

          if (unlikely(w5300_read32(priv, W5300_S0_TX_FSR) < skb->len)) {
-                ndev->stats.tx_dropped++;
+                netif_stop_queue(ndev);
+                w5300_write(priv, W5300_S0_IMR, S0_IR_RECV | S0_IR_SENDOK);
                  return NETDEV_TX_BUSY;
          }

@@ -443,6 +444,12 @@ static irqreturn_t w5300_interrupt(int irq, void 
*ndev_instance)
                  __napi_schedule(&priv->napi);
          }

+        if (unlikely(netif_queue_stopped(ndev))) {
+                w5300_write(priv, W5300_S0_IR, S0_IR_SENDOK);
+                w5300_write(priv, W5300_S0_IMR, S0_IR_RECV);
+                netif_wake_queue(ndev);
+        }
+
          return IRQ_HANDLED;
  }

-- 
Mike

