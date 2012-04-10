Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759792Ab2DJX67 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:58:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46465 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab2DJX65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:58:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120410225534.GA28480@electric-eye.fr.zoreil.com>
References: <CACPM=kWa=UWuCMaYAtVMGJ7pzCy-PfyNRWBSuJnTZGtssU0W6g@mail.gmail.com>
	<20120410204249.GA26627@electric-eye.fr.zoreil.com>
	<CACPM=kWsU8QZOHqwEThTQCuSSvaTDoxO1d17EyoW=+kx8QG3vw@mail.gmail.com>
	<20120410225534.GA28480@electric-eye.fr.zoreil.com>
Date: Wed, 11 Apr 2012 01:58:56 +0200
X-Google-Sender-Auth: 8gKNTmi4rRYLS4Ge_FWAjm8hrj4
Message-ID: <CACPM=kUX4dPXW93V_mHBvNb_d-kTUWdMNRyEN80n7ztStiHk=w@mail.gmail.com>
Subject: Re: via-rhine: Problem with lost link after a while
From: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
To: Francois Romieu <romieu@fr.zoreil.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        =?ISO-8859-1?Q?Svenning_S=F8rensen?= <sss@secomea.com>,
        Andreas Mohr <andi@lisas.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

11. apr. 2012 00.55 skrev Francois Romieu <romieu@fr.zoreil.com>:
> Bjarke Istrup Pedersen <gurligebis@gentoo.org> :
>> 10. apr. 2012 22.42 skrev Francois Romieu <romieu@fr.zoreil.com>:
> [...]
>> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;h=3f8c91a7398b9266fbe7abcbe4bd5dffef907643
> [...]
>> Great, I'll try a 3.4-rc2 kernel, and see how it runs.
>>
>> The thread I was talking about earlier is here:
>> http://lists.soekris.com/pipermail/soekris-tech/2012-April/018318.html
>> Is there any of the changes he has there, that makes sense in the new
>> driver you wrote ?
>
> (I did not write a new driver)

Sorry, bad choice of words, meant fixed some issues with the driver :)

> Regarding Svenning's patch:
> - the wmb in alloc_rbufs may help rhine_reset_task().
> - one should probably add one in rhine_rx() as well.
> - rhine_start_tx() is supposed to stop queueing when there is no room left.
>  I'm curious to know if the "Tx descriptor busy" test triggered.
> - the rmb() in rhine_tx() will not make a difference for a single core but
>  it's a good reminder that I should not have forgotten to propagate the
>  xmit / Tx completion fix back from the r8169 driver to the via-rhine one
>  (sigh)
>
> mmiowb is probably missing. I doubt it hits hard right now.

I'll give it a spin tomorrow, and see how it runs :)

> I have not checked if MMIO flushes are missing. Actually I need some sleep.
>
> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
> index fcfa01f..dfa9fc0 100644
> --- a/drivers/net/ethernet/via/via-rhine.c
> +++ b/drivers/net/ethernet/via/via-rhine.c
> @@ -1163,6 +1163,7 @@ static void alloc_rbufs(struct net_device *dev)
>                                       PCI_DMA_FROMDEVICE);
>
>                rp->rx_ring[i].addr = cpu_to_le32(rp->rx_skbuff_dma[i]);
> +               wmb();
>                rp->rx_ring[i].rx_status = cpu_to_le32(DescOwn);
>        }
>        rp->dirty_rx = (unsigned int)(i - RX_RING_SIZE);
> @@ -1709,8 +1710,13 @@ static netdev_tx_t rhine_start_tx(struct sk_buff *skb,
>               ioaddr + ChipCmd1);
>        IOSYNC;
>
> -       if (rp->cur_tx == rp->dirty_tx + TX_QUEUE_LEN)
> +       if (rp->cur_tx == rp->dirty_tx + TX_QUEUE_LEN) {
> +               smp_wmb();
>                netif_stop_queue(dev);
> +               smp_mb();
> +               if (rp->cur_tx != rp->dirty_tx + TX_QUEUE_LEN)
> +                       netif_wake_queue(dev);
> +       }
>
>        netif_dbg(rp, tx_queued, dev, "Transmit frame #%d queued in slot %d\n",
>                  rp->cur_tx - 1, entry);
> @@ -1759,6 +1765,7 @@ static void rhine_tx(struct net_device *dev)
>        struct rhine_private *rp = netdev_priv(dev);
>        int txstatus = 0, entry = rp->dirty_tx % TX_RING_SIZE;
>
> +       smp_rmb();
>        /* find and cleanup dirty tx descriptors */
>        while (rp->dirty_tx != rp->cur_tx) {
>                txstatus = le32_to_cpu(rp->tx_ring[entry].tx_status);
> @@ -1806,8 +1813,12 @@ static void rhine_tx(struct net_device *dev)
>                rp->tx_skbuff[entry] = NULL;
>                entry = (++rp->dirty_tx) % TX_RING_SIZE;
>        }
> -       if ((rp->cur_tx - rp->dirty_tx) < TX_QUEUE_LEN - 4)
> +
> +       smp_mb();
> +       if (netif_queue_stopped(dev) &&
> +           (rp->cur_tx - rp->dirty_tx) < TX_QUEUE_LEN - 4) {
>                netif_wake_queue(dev);
> +       }
>  }
>
>  /**
> @@ -1947,6 +1958,7 @@ static int rhine_rx(struct net_device *dev, int limit)
>                                               PCI_DMA_FROMDEVICE);
>                        rp->rx_ring[entry].addr = cpu_to_le32(rp->rx_skbuff_dma[entry]);
>                }
> +               wmb();
>                rp->rx_ring[entry].rx_status = cpu_to_le32(DescOwn);
>        }
>
> --
> Ueimor
>
> Will code drivers for food.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
