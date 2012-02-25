Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab2BYJw5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 04:52:57 -0500
Received: from www17.your-server.de ([213.133.104.17]:55979 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab2BYJwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 04:52:55 -0500
Message-ID: <1330163565.1419.5.camel@localhost.localdomain>
Subject: Re: NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
From: Thomas Meyer <thomas@m3y3r.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jcliburn@gmail.com, chris.snook@gmail.com,
        netdev <netdev@vger.kernel.org>, Josh Boyer <jwboyer@gmail.com>
Date: Sat, 25 Feb 2012 10:52:45 +0100
In-Reply-To: <1330111229.15610.50.camel@edumazet-laptop>
References: <1329063403.1449.14.camel@localhost.localdomain>
	 <CA+5PVA52+0vOMF6+tvMPkgzhdTKJRQnrjD4FfVmBZs0TMDJ5cg@mail.gmail.com>
	 <1329204997.24837.15.camel@edumazet-laptop>
	 <1329366846.5646.1.camel@edumazet-laptop>
	 <1329847015.5133.4.camel@localhost.localdomain>
	 <1329848093.18384.35.camel@edumazet-laptop>
	 <1330111229.15610.50.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 24.02.2012, 20:20 +0100 schrieb Eric Dumazet:
> Le mardi 21 février 2012 à 19:14 +0100, Eric Dumazet a écrit :
> > Le mardi 21 février 2012 à 18:56 +0100, Thomas Meyer a écrit :
> > 
> > > Bad news. Just did hit the issue again, with above patch applied.
> > > 
> > > abrt_version:   2.0.7
> > > cmdline:        BOOT_IMAGE=/vmlinuz-3.2.6 root=/dev/sda2 rootfstype=ext4 rootflags=data=writeback ro quiet rhgb
> > > kernel:         3.2.6
> > > reason:         [177799.342250] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x1e7/0x1f0()
> > > time:           Di 21 Feb 2012 18:09:16 CET
> > > 
> > > backtrace:
> > > :[177799.342250] WARNING: at net/sched/sch_generic.c:255 dev_watchdog+0x1e7/0x1f0()
> > > :[177799.342254] Hardware name: Aspire 1810T
> > > :[177799.342256] NETDEV WATCHDOG: eth0 (atl1c): transmit queue 0 timed out
> > > :[177799.342259] Modules linked in: vfat fat fuse bluetooth nf_conntrack_ipv6 nf_defrag_ipv6 ip6t_REJECT ip6table_filter ip6_tables snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_seq arc4 snd_seq_device snd_pcm iwlwifi uvcvideo mac80211 snd_timer videodev cfg80211 snd usb_storage v4l2_compat_ioctl32 atl1c acer_wmi soundcore sparse_keymap snd_page_alloc rfkill wmi joydev acerhdf pcspkr virtio_net virtio virtio_ring kvm_intel kvm uinput ipv6 [last unloaded: scsi_wait_scan]
> > > :[177799.342303] Pid: 4980, comm: alsa-sink Not tainted 3.2.6 #7
> > > :[177799.342306] Call Trace:
> > > :[177799.342309]  <IRQ>  [<ffffffff810322ca>] warn_slowpath_common+0x7a/0xb0
> > > :[177799.342320]  [<ffffffff810323a1>] warn_slowpath_fmt+0x41/0x50
> > > :[177799.342325]  [<ffffffff8100375b>] ? do_IRQ+0x5b/0xd0
> > > :[177799.342330]  [<ffffffff813e94b7>] dev_watchdog+0x1e7/0x1f0
> > > :[177799.342336]  [<ffffffff8103cfcf>] run_timer_softirq+0xef/0x210
> > > :[177799.342341]  [<ffffffff813e92d0>] ? qdisc_reset+0x50/0x50
> > > :[177799.342345]  [<ffffffff81037827>] __do_softirq+0x87/0x110
> > > :[177799.342350]  [<ffffffff8149483a>] call_softirq+0x1a/0x30
> > > :[177799.342354]  [<ffffffff810038bd>] do_softirq+0x4d/0x80
> > > :[177799.342358]  [<ffffffff81037a8e>] irq_exit+0x7e/0xa0
> > > :[177799.342363]  [<ffffffff8101903a>] smp_apic_timer_interrupt+0x5a/0x90
> > > :[177799.342368]  [<ffffffff814942a9>] apic_timer_interrupt+0x69/0x70
> > > :[177799.342371]  <EOI>  [<ffffffff814948d7>] ? sysenter_dispatch+0x7/0x26
> > > 
> > > END:
> > > 
> > 
> > Thanks
> > 
> > This driver xmit function is racy I suspect, and several patches will be
> > needed to fix bugs.
> > 
> 
> Here is a cumulative patch to hopefuly remove the races in this driver,
> could you please test it ?

Hi,

just building a 3.2.7 kernel with your patch applied. I will watch out
for the warning in the next days.

many thanks for the patch!

kind regards
thomas

> 
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c.h b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> index ca70e16..3b2851b 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c.h
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c.h
> @@ -576,7 +576,6 @@ struct atl1c_adapter {
>  	u16 link_duplex;
>  
>  	spinlock_t mdio_lock;
> -	spinlock_t tx_lock;
>  	atomic_t irq_sem;
>  
>  	struct work_struct common_task;
> diff --git a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> index 1ff3c6d..896eb20 100644
> --- a/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> +++ b/drivers/net/ethernet/atheros/atl1c/atl1c_main.c
> @@ -784,7 +784,6 @@ static int __devinit atl1c_sw_init(struct atl1c_adapter *adapter)
>  	atl1c_set_rxbufsize(adapter, adapter->netdev);
>  	atomic_set(&adapter->irq_sem, 1);
>  	spin_lock_init(&adapter->mdio_lock);
> -	spin_lock_init(&adapter->tx_lock);
>  	set_bit(__AT_DOWN, &adapter->flags);
>  
>  	return 0;
> @@ -1653,9 +1652,11 @@ static bool atl1c_clean_tx_irq(struct atl1c_adapter *adapter,
>  		atomic_set(&tpd_ring->next_to_clean, next_to_clean);
>  	}
>  
> -	if (netif_queue_stopped(adapter->netdev) &&
> -			netif_carrier_ok(adapter->netdev)) {
> -		netif_wake_queue(adapter->netdev);
> +	if (netif_carrier_ok(adapter->netdev)) {
> +		/* make sure atl1c_xmit_frame() see our changes */
> +		smp_mb();
> +		if (netif_queue_stopped(adapter->netdev))
> +			netif_wake_queue(adapter->netdev);
>  	}
>  
>  	return true;
> @@ -2228,7 +2229,6 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>  					  struct net_device *netdev)
>  {
>  	struct atl1c_adapter *adapter = netdev_priv(netdev);
> -	unsigned long flags;
>  	u16 tpd_req = 1;
>  	struct atl1c_tpd_desc *tpd;
>  	enum atl1c_trans_queue type = atl1c_trans_normal;
> @@ -2239,24 +2239,20 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>  	}
>  
>  	tpd_req = atl1c_cal_tpd_req(skb);
> -	if (!spin_trylock_irqsave(&adapter->tx_lock, flags)) {
> -		if (netif_msg_pktdata(adapter))
> -			dev_info(&adapter->pdev->dev, "tx locked\n");
> -		return NETDEV_TX_LOCKED;
> -	}
>  
>  	if (atl1c_tpd_avail(adapter, type) < tpd_req) {
>  		/* no enough descriptor, just stop queue */
>  		netif_stop_queue(netdev);
> -		spin_unlock_irqrestore(&adapter->tx_lock, flags);
> -		return NETDEV_TX_BUSY;
> +		smp_mb();
> +		if (atl1c_tpd_avail(adapter, type) < tpd_req)
> +			return NETDEV_TX_BUSY;
> +		netif_wake_queue(netdev);
>  	}
>  
>  	tpd = atl1c_get_tpd(adapter, type);
>  
>  	/* do TSO and check sum */
>  	if (atl1c_tso_csum(adapter, skb, &tpd, type) != 0) {
> -		spin_unlock_irqrestore(&adapter->tx_lock, flags);
>  		dev_kfree_skb_any(skb);
>  		return NETDEV_TX_OK;
>  	}
> @@ -2277,7 +2273,6 @@ static netdev_tx_t atl1c_xmit_frame(struct sk_buff *skb,
>  	atl1c_tx_map(adapter, skb, tpd, type);
>  	atl1c_tx_queue(adapter, skb, tpd, type);
>  
> -	spin_unlock_irqrestore(&adapter->tx_lock, flags);
>  	return NETDEV_TX_OK;
>  }
>  
> 
> 



