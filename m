Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab0JSWXC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 18:23:02 -0400
Received: from 34.97.116-78.rev.gaoland.net ([78.116.97.34]:57203 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754479Ab0JSWXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 18:23:00 -0400
X-Greylist: delayed 849 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2010 18:22:56 EDT
Date: Wed, 20 Oct 2010 00:07:24 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Networking <linux-net@vger.kernel.org>
Subject: Re: [2.6.36-rc5] r8169 regression...
Message-ID: <20101019220724.GA16254@electric-eye.fr.zoreil.com>
Mail-Followup-To: Francois Romieu <romieu@fr.zoreil.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Networking <linux-net@vger.kernel.org>
References: <AANLkTimdrM0H=b1OzmJ_mxMFqe-Y-Hxs5Lof5PAmVdbj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimdrM0H=b1OzmJ_mxMFqe-Y-Hxs5Lof5PAmVdbj@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Blueman <daniel.blueman@gmail.com> :
> Since 2.6.36-rc5, I've been seeing unexpected link up and (as a
> side-effect) pending softirq messages [1] when transferring data over
> a r8169 adapter ("RTL8168d/8111d").
>
> The recent change [2] to make the r8169 driver sensitive to receive
> overflow events is clearly unnecessary for this MAC revision (since it
> was fine without before), so it may be worthwhile to reintroduce the
> 'tp->mac_version == RTL_GIGA_MAC_VER_11' condition on resetting the
> link, tweaked to the problematic MAC version in the Thinkpad X100e.

Matthew, can you apply the patch below and send your XID line ?

At this stage in -rc, I'd rather revert [2], live with some Thinkpad
X100e crashes when under network load while the screen turns off and
avoid any new pesky regression. David ?

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index 992db2f..15b8e57 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -3208,7 +3208,7 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	netif_info(tp, probe, dev, "%s at 0x%lx, %pM, XID %08x IRQ %d\n",
 		   rtl_chip_info[tp->chipset].name,
 		   dev->base_addr, dev->dev_addr,
-		   (u32)(RTL_R32(TxConfig) & 0x9cf0f8ff), dev->irq);
+		   (u32)(RTL_R32(TxConfig) & 0xfcf0f8ff), dev->irq);
 
 	rtl8169_init_phy(dev, tp);
 
[...]
> As a second bonus, we find a latent softirq. When a receive overflow
> is now detected, we get the callchain
> rtl8169_tx_timeout->rtl8169_schedule_work which causes
> rtl8169_reset_task->rtl8169_rx_interrupt->netif_rx from outside the
> interrupt handler. I could cook a patch which would ensure
> netif_rx_ni() is called outside the interrupt handler, but do we care?

You can remove rtl8169_rx_interrupt in rtl8169_reset_task so that
rtl8169_rx_interrupt be only called from softirq context. It will
save some what-is-the-current-context code and avoid a circular
rtl8169_rx_interrupt <-> rtl8169_reset_task dependency.

[...]
> --- [2]
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=801e147cde02f04b5c2f42764cd43a89fc7400a2

-- 
Ueimor
