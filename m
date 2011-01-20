Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab1ATPy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:54:58 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64884 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab1ATPy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:54:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=AnYlKov6R4cvS0ZKOUvwfg/DBz3OzpSHg9zOKMt2amtz4wRktI4xpGiferXRchngQl
         18l+ZsereUVxiJrcI74AuaJuEWTz0pvI0qbCdNracPWjrupP/sTMUPVVyULsXN4Dg6aM
         YbFvOPCQY6MnSUnDKYTun0zxPIaNWQOiMUbmc=
MIME-Version: 1.0
In-Reply-To: <1295538105.2825.308.camel@edumazet-laptop>
References: <1295256060-2091-1-git-send-email-ratbert.chuang@gmail.com>
 <1295537418-2057-1-git-send-email-ratbert.chuang@gmail.com> <1295538105.2825.308.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Thu, 20 Jan 2011 23:54:35 +0800
Message-ID: <AANLkTikpp3pC4BW-1mb7FvPgggAFL31ZDpoo=FRR57yy@mail.gmail.com>
Subject: Re: [PATCH v3] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Eric,

On Thu, Jan 20, 2011 at 11:41 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 20 janvier 2011 à 23:30 +0800, Po-Yu Chuang a écrit :
>
>> +static bool ftmac100_tx_complete_packet(struct ftmac100 *priv)
>> +{
>> +     struct net_device *netdev = priv->netdev;
>> +     struct ftmac100_txdes *txdes;
>> +     struct sk_buff *skb;
>> +     dma_addr_t map;
>> +
>> +     if (priv->tx_pending == 0)
>> +             return false;
>> +
>> +     txdes = ftmac100_current_clean_txdes(priv);
>> +
>> +     if (ftmac100_txdes_owned_by_dma(txdes))
>> +             return false;
>> +
>> +     skb = ftmac100_txdes_get_skb(txdes);
>> +     map = ftmac100_txdes_get_dma_addr(txdes);
>> +
>> +     if (unlikely(ftmac100_txdes_excessive_collision(txdes) ||
>> +                  ftmac100_txdes_late_collision(txdes))) {
>> +             /*
>> +              * packet transmitted to ethernet lost due to late collision
>> +              * or excessive collision
>> +              */
>> +             netdev->stats.tx_aborted_errors++;
>> +     } else {
>> +             netdev->stats.tx_packets++;
>> +             netdev->stats.tx_bytes += skb->len;
>> +     }
>> +
>> +     dma_unmap_single(priv->dev, map, skb_headlen(skb), DMA_TO_DEVICE);
>> +
>> +     dev_kfree_skb_irq(skb);
>> +
>> +     ftmac100_txdes_reset(txdes);
>> +
>> +     ftmac100_tx_clean_pointer_advance(priv);
>> +
>> +     priv->tx_pending--;
>> +     netif_wake_queue(netdev);
>> +
>> +     return true;
>> +}
>> +
>> +static void ftmac100_tx_complete(struct ftmac100 *priv)
>> +{
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&priv->tx_lock, flags);
>> +     while (ftmac100_tx_complete_packet(priv))
>> +             ;
>> +     spin_unlock_irqrestore(&priv->tx_lock, flags);
>> +}
>> +
>
> I dont understand why you still block hard IRQS, after full NAPI
> conversion.
>
> Now you run from NAPI, and softirq handler, are you sure you still need
> to block hard IRQ and tx_lock ?
>
> It seems to me ftmac100_xmit() could only block softirqs (but they
> already are blocked by caller), so you could use spin_lock() from
> ftmac100_xmit()

I was not quite clear about when to use what kinds of locking.
After your explanation, now I understand.
I will submit v4 tomorrow.

really appreciate,
Po-Yu Chuang
