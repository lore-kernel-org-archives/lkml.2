Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932436Ab0HaPNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 11:13:11 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56607 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932421Ab0HaPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 11:13:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kbX1Stj94CpO/qanzD0Va1SR/chkg49E/5dLylqqczVT+tVpehJ9c/F1k2MC39gzmV
         FRoPpC64lIsDvACfbgbSDx6S5KwOHGPYedBY7vGZJwKPHmNVQGs5/2AcUVRIRQfFq9nm
         Bv2AgZIy/k0tl1s8NEy2FzkT7ez0N4DMUrz+0=
Subject: Re: [PATCH] Gigabit Ethernet driver of Topcliff PCH
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>, Sam Ravnborg <sam@ravnborg.org>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>,
        Greg Rose <gregory.v.rose@intel.com>, Maxime Bizon <mbizon@freebox.fr>,
        Kristoffer Glembo <kristoffer@gaisler.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Linn <john.linn@xilinx.com>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, MeeGo <meego-dev@meego.com>,
        "Wang, Qi" <qi.wang@intel.com>, "Wang, Yong Y" <yong.y.wang@intel.com>,
        Andrew <andrew.chih.howe.khor@intel.com>,
        Intel OTC <joel.clark@intel.com>,
        "Foster, Margie" <margie.foster@intel.com>,
        Toshiharu Okada <okada533@dsn.okisemi.com>,
        Tomoya Morinaga <morinaga526@dsn.okisemi.com>,
        Takahiro Shimizu <shimizu394@dsn.okisemi.com>
In-Reply-To: <4C7D0E7A.5060309@dsn.okisemi.com>
References: <4C763A67.5040107@dsn.okisemi.com>
	 <4C7D0E7A.5060309@dsn.okisemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 31 Aug 2010 16:51:03 +0200
Message-ID: <1283266263.2550.106.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 31 août 2010 à 23:15 +0900, Masayuki Ohtake a écrit :
> Hi Sam, Joe and Stephen
> 
> Thank you for your comments.
> We have modified this driver for your comment.
> 
> ---
> Gigabit Ethernet driver of Topcliff PCH

> +			skb->protocol = eth_type_trans(skb, netdev);
> +			if ((tcp_ip_status & PCH_GBE_RXD_ACC_STAT_TCPIPOK) ==
> +			    PCH_GBE_RXD_ACC_STAT_TCPIPOK) {
> +				skb->ip_summed = CHECKSUM_UNNECESSARY;
> +			} else {
> +				skb->ip_summed = CHECKSUM_NONE;
> +			}
> +
> +			if (netif_receive_skb(skb) == NET_RX_DROP) {
> +				adapter->stats.rx_dropped++;

dont use pr_err() here, dropping a frame is a normal condition.

> +				pr_err("Receive Netif Receive Dropped Error\n");
> +			}
> +			(*work_done)++;
> +			netdev->last_rx = jiffies;

really ? last_rx is a thing of the past.

> +			pr_debug
> +			    ("Receive skb->ip_summed: %d length: %d\n",
> +			     skb->ip_summed, length);
> +		}
> +dorrop:
> +		/* return some buffers to hardware, one at a time is too slow */
> +		if (unlikely(cleaned_count >= PCH_GBE_RX_BUFFER_WRITE)) {
> +			pch_gbe_alloc_rx_buffers(adapter, rx_ring,
> +						 cleaned_count);
> +			cleaned_count = 0;
> +		}
> +		if (++i == rx_ring->count)
> +			i = 0;
> +	}
> +	rx_ring->next_to_clean = i;
> +	if (cleaned_count)
> +		pch_gbe_alloc_rx_buffers(adapter, rx_ring, cleaned_count);
> +	return cleaned;
> +}
> +



I find hard to believe this driver needs to copy all outgoing frames on
pre-allocated skbs.

+       /* [Header:14][payload] ---> [Header:14][paddong:2][payload]    */
+       memcpy(tmp_skb->data, skb->data, ETH_HLEN);
+       tmp_skb->data[ETH_HLEN] = 0x00;
+       tmp_skb->data[ETH_HLEN + 1] = 0x00;
+       tmp_skb->len = skb->len;
+       memcpy(&tmp_skb->data[ETH_HLEN + 2], &skb->data[ETH_HLEN],
+              (skb->len - ETH_HLEN));
+       buffer_info->kernel_skb = skb;
+       skb = tmp_skb;

Whats the deal here please ?


