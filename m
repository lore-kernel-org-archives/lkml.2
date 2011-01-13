Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab1AMOWq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 09:22:46 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56444 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666Ab1AMOWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 09:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Mq5JodAI/8BzAPWWab8sRcpBuQwVNi3WwW1jVMifh5MAbjOMYDde4pEoQasUiXj+tx
         mgy8nHIoKrdcBYcBljGogUrU49SCxytIRbKTjw45VjJHQfel/H8tHOlO6n8Nj+ZF0IP7
         G499HMiQgiPFtODRa/xOdwINC/kuyvl/9WvIU=
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
References: <1294919372-1904-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 15:22:39 +0100
Message-ID: <1294928559.3570.130.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 13 janvier 2011 à 19:49 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
> MII.  This driver has been working on some ARM/NDS32 SoC including
> Faraday A320 and Andes AG101.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> ---
>  drivers/net/Kconfig    |    9 +
>  drivers/net/Makefile   |    1 +
>  drivers/net/ftmac100.c | 1341 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/ftmac100.h |  180 +++++++
>  4 files changed, 1531 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/ftmac100.c
>  create mode 100644 drivers/net/ftmac100.h

Hi

1) please use netdev_alloc_skb_ip_align() instead of dev_alloc_skb() +
skb_reserve(skb, NET_IP_ALIGN);

2) Dont include a "struct net_device_stats stats" in struct ftmac100,
you can use the one included in struct net_device
  (You can then remove ftmac100_get_stats())

3) Dont "netdev->last_rx = jiffies;" : This is not driver job.
 Ditto for trans_start

4) You must comment why wmb() is needed in ftmac100_xmit()

5) Why isnt NAPI used too for TX completions ?
   BTW, I am not sure we want a define. All new drivers must use NAPI.

6) Use is_valid_ether_addr() instead of is_zero_ether_addr() in
ftmac100_probe()

7) "static struct ethtool_ops ftmac100_ethtool_ops" should be const :
	"static const struct ethtool_ops ftmac100_ethtool_ops"
  Ditto for :
	"static struct net_device_ops ftmac100_netdev_ops"


8) Why an interrupt handler (ftmac100_interrupt()) needs to block
interrupts with spin_lock_irqsave(&priv->hw_lock, flags); ?

9) Instead of dev_info(&netdev->dev ...) , please consider netdev_info()


