Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab2C2Bss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:48:48 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40039 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422Ab2C2Bsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:48:40 -0400
Date: Thu, 29 Mar 2012 12:48:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        Francois Romieu <romieu@fr.zoreil.com>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20120329124824.41fc7503d402b11a58a0dfde@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Mar_2012_12_48_24_+1100_P1mEI_4i7K2bbi9M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Mar_2012_12_48_24_+1100_P1mEI_4i7K2bbi9M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/net/ethernet/realtek/r8169.c between commit df43ac7831a0 ("r8169:
move rtl8169_open after rtl_task it depends on") (and others) from Linus'
tree and commit a9d7e794ea66 ("r8169.c: fix comment typo") from the
trivial tree.

I fixed it up (see below) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/ethernet/realtek/r8169.c
index 27c358c,7f06508..0000000
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@@ -5530,768 -5390,823 +5530,768 @@@ static void rtl_task(struct work_struc
  	struct net_device *dev =3D tp->dev;
  	int i;
 =20
 -	rtnl_lock();
 +	rtl_lock_work(tp);
 =20
 -	if (!netif_running(dev))
 +	if (!netif_running(dev) ||
 +	    !test_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags))
  		goto out_unlock;
 =20
 -	rtl8169_hw_reset(tp);
 -
 -	rtl8169_wait_for_quiescence(dev);
 -
 -	for (i =3D 0; i < NUM_RX_DESC; i++)
 -		rtl8169_mark_to_asic(tp->RxDescArray + i, rx_buf_sz);
 -
 -	rtl8169_tx_clear(tp);
 -	rtl8169_init_ring_indexes(tp);
 +	for (i =3D 0; i < ARRAY_SIZE(rtl_work); i++) {
 +		bool pending;
 =20
 -	rtl_hw_start(dev);
 -	netif_wake_queue(dev);
 -	rtl8169_check_link_status(dev, tp, tp->mmio_addr);
 +		pending =3D test_and_clear_bit(rtl_work[i].bitnr, tp->wk.flags);
 +		if (pending)
 +			rtl_work[i].action(tp);
 +	}
 =20
  out_unlock:
 -	rtnl_unlock();
 -}
 -
 -static void rtl8169_tx_timeout(struct net_device *dev)
 -{
 -	rtl8169_schedule_work(dev, rtl8169_reset_task);
 +	rtl_unlock_work(tp);
  }
 =20
 -static int rtl8169_xmit_frags(struct rtl8169_private *tp, struct sk_buff =
*skb,
 -			      u32 *opts)
 +static int rtl8169_poll(struct napi_struct *napi, int budget)
  {
 -	struct skb_shared_info *info =3D skb_shinfo(skb);
 -	unsigned int cur_frag, entry;
 -	struct TxDesc * uninitialized_var(txd);
 -	struct device *d =3D &tp->pci_dev->dev;
 -
 -	entry =3D tp->cur_tx;
 -	for (cur_frag =3D 0; cur_frag < info->nr_frags; cur_frag++) {
 -		const skb_frag_t *frag =3D info->frags + cur_frag;
 -		dma_addr_t mapping;
 -		u32 status, len;
 -		void *addr;
 +	struct rtl8169_private *tp =3D container_of(napi, struct rtl8169_private=
, napi);
 +	struct net_device *dev =3D tp->dev;
 +	u16 enable_mask =3D RTL_EVENT_NAPI | tp->event_slow;
 +	int work_done=3D 0;
 +	u16 status;
 =20
 -		entry =3D (entry + 1) % NUM_TX_DESC;
 +	status =3D rtl_get_events(tp);
 +	rtl_ack_events(tp, status & ~tp->event_slow);
 =20
 -		txd =3D tp->TxDescArray + entry;
 -		len =3D skb_frag_size(frag);
 -		addr =3D skb_frag_address(frag);
 -		mapping =3D dma_map_single(d, addr, len, DMA_TO_DEVICE);
 -		if (unlikely(dma_mapping_error(d, mapping))) {
 -			if (net_ratelimit())
 -				netif_err(tp, drv, tp->dev,
 -					  "Failed to map TX fragments DMA!\n");
 -			goto err_out;
 -		}
 +	if (status & RTL_EVENT_NAPI_RX)
 +		work_done =3D rtl_rx(dev, tp, (u32) budget);
 =20
 -		/* Anti gcc 2.95.3 bugware (sic) */
 -		status =3D opts[0] | len |
 -			(RingEnd * !((entry + 1) % NUM_TX_DESC));
 +	if (status & RTL_EVENT_NAPI_TX)
 +		rtl_tx(dev, tp);
 =20
 -		txd->opts1 =3D cpu_to_le32(status);
 -		txd->opts2 =3D cpu_to_le32(opts[1]);
 -		txd->addr =3D cpu_to_le64(mapping);
 +	if (status & tp->event_slow) {
 +		enable_mask &=3D ~tp->event_slow;
 =20
 -		tp->tx_skb[entry].len =3D len;
 +		rtl_schedule_task(tp, RTL_FLAG_TASK_SLOW_PENDING);
  	}
 =20
 -	if (cur_frag) {
 -		tp->tx_skb[entry].skb =3D skb;
 -		txd->opts1 |=3D cpu_to_le32(LastFrag);
 -	}
 +	if (work_done < budget) {
 +		napi_complete(napi);
 =20
 -	return cur_frag;
 +		rtl_irq_enable(tp, enable_mask);
 +		mmiowb();
 +	}
 =20
 -err_out:
 -	rtl8169_tx_clear_range(tp, tp->cur_tx + 1, cur_frag);
 -	return -EIO;
 +	return work_done;
  }
 =20
 -static inline void rtl8169_tso_csum(struct rtl8169_private *tp,
 -				    struct sk_buff *skb, u32 *opts)
 +static void rtl8169_rx_missed(struct net_device *dev, void __iomem *ioadd=
r)
  {
 -	const struct rtl_tx_desc_info *info =3D tx_desc_info + tp->txd_version;
 -	u32 mss =3D skb_shinfo(skb)->gso_size;
 -	int offset =3D info->opts_offset;
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 =20
 -	if (mss) {
 -		opts[0] |=3D TD_LSO;
 -		opts[offset] |=3D min(mss, TD_MSS_MAX) << info->mss_shift;
 -	} else if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
 -		const struct iphdr *ip =3D ip_hdr(skb);
 +	if (tp->mac_version > RTL_GIGA_MAC_VER_06)
 +		return;
 =20
 -		if (ip->protocol =3D=3D IPPROTO_TCP)
 -			opts[offset] |=3D info->checksum.tcp;
 -		else if (ip->protocol =3D=3D IPPROTO_UDP)
 -			opts[offset] |=3D info->checksum.udp;
 -		else
 -			WARN_ON_ONCE(1);
 -	}
 +	dev->stats.rx_missed_errors +=3D (RTL_R32(RxMissed) & 0xffffff);
 +	RTL_W32(RxMissed, 0);
  }
 =20
 -static netdev_tx_t rtl8169_start_xmit(struct sk_buff *skb,
 -				      struct net_device *dev)
 +static void rtl8169_down(struct net_device *dev)
  {
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 -	unsigned int entry =3D tp->cur_tx % NUM_TX_DESC;
 -	struct TxDesc *txd =3D tp->TxDescArray + entry;
  	void __iomem *ioaddr =3D tp->mmio_addr;
 -	struct device *d =3D &tp->pci_dev->dev;
 -	dma_addr_t mapping;
 -	u32 status, len;
 -	u32 opts[2];
 -	int frags;
 =20
 -	if (unlikely(TX_BUFFS_AVAIL(tp) < skb_shinfo(skb)->nr_frags)) {
 -		netif_err(tp, drv, dev, "BUG! Tx Ring full when queue awake!\n");
 -		goto err_stop_0;
 -	}
 +	del_timer_sync(&tp->timer);
 =20
 -	if (unlikely(le32_to_cpu(txd->opts1) & DescOwn))
 -		goto err_stop_0;
 +	napi_disable(&tp->napi);
 +	netif_stop_queue(dev);
 =20
 -	len =3D skb_headlen(skb);
 -	mapping =3D dma_map_single(d, skb->data, len, DMA_TO_DEVICE);
 -	if (unlikely(dma_mapping_error(d, mapping))) {
 -		if (net_ratelimit())
 -			netif_err(tp, drv, dev, "Failed to map TX DMA!\n");
 -		goto err_dma_0;
 -	}
 +	rtl8169_hw_reset(tp);
 +	/*
 +	 * At this point device interrupts can not be enabled in any function,
 +	 * as netif_running is not true (rtl8169_interrupt, rtl8169_reset_task)
 +	 * and napi is disabled (rtl8169_poll).
 +	 */
 +	rtl8169_rx_missed(dev, ioaddr);
 =20
 -	tp->tx_skb[entry].len =3D len;
 -	txd->addr =3D cpu_to_le64(mapping);
 +	/* Give a racing hard_start_xmit a few cycles to complete. */
 +	synchronize_sched();
 =20
 -	opts[1] =3D cpu_to_le32(rtl8169_tx_vlan_tag(tp, skb));
 -	opts[0] =3D DescOwn;
 +	rtl8169_tx_clear(tp);
 =20
 -	rtl8169_tso_csum(tp, skb, opts);
 +	rtl8169_rx_clear(tp);
 =20
 -	frags =3D rtl8169_xmit_frags(tp, skb, opts);
 -	if (frags < 0)
 -		goto err_dma_1;
 -	else if (frags)
 -		opts[0] |=3D FirstFrag;
 -	else {
 -		opts[0] |=3D FirstFrag | LastFrag;
 -		tp->tx_skb[entry].skb =3D skb;
 -	}
 +	rtl_pll_power_down(tp);
 +}
 =20
 -	txd->opts2 =3D cpu_to_le32(opts[1]);
 +static int rtl8169_close(struct net_device *dev)
 +{
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	struct pci_dev *pdev =3D tp->pci_dev;
 =20
 -	wmb();
 +	pm_runtime_get_sync(&pdev->dev);
 =20
 -	/* Anti gcc 2.95.3 bugware (sic) */
 -	status =3D opts[0] | len | (RingEnd * !((entry + 1) % NUM_TX_DESC));
 -	txd->opts1 =3D cpu_to_le32(status);
 +	/* Update counters before going down */
 +	rtl8169_update_counters(dev);
 =20
 -	tp->cur_tx +=3D frags + 1;
 +	rtl_lock_work(tp);
 +	clear_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
 =20
 -	wmb();
 +	rtl8169_down(dev);
 +	rtl_unlock_work(tp);
 =20
 -	RTL_W8(TxPoll, NPQ);
 +	free_irq(pdev->irq, dev);
 =20
 -	if (TX_BUFFS_AVAIL(tp) < MAX_SKB_FRAGS) {
 -		netif_stop_queue(dev);
 -		smp_rmb();
 -		if (TX_BUFFS_AVAIL(tp) >=3D MAX_SKB_FRAGS)
 -			netif_wake_queue(dev);
 -	}
 +	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 +			  tp->RxPhyAddr);
 +	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
 +			  tp->TxPhyAddr);
 +	tp->TxDescArray =3D NULL;
 +	tp->RxDescArray =3D NULL;
 =20
 -	return NETDEV_TX_OK;
 +	pm_runtime_put_sync(&pdev->dev);
 =20
 -err_dma_1:
 -	rtl8169_unmap_tx_skb(d, tp->tx_skb + entry, txd);
 -err_dma_0:
 -	dev_kfree_skb(skb);
 -	dev->stats.tx_dropped++;
 -	return NETDEV_TX_OK;
 +	return 0;
 +}
 =20
 -err_stop_0:
 -	netif_stop_queue(dev);
 -	dev->stats.tx_dropped++;
 -	return NETDEV_TX_BUSY;
 +#ifdef CONFIG_NET_POLL_CONTROLLER
 +static void rtl8169_netpoll(struct net_device *dev)
 +{
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 +
 +	rtl8169_interrupt(tp->pci_dev->irq, dev);
  }
 +#endif
 =20
 -static void rtl8169_pcierr_interrupt(struct net_device *dev)
 +static int rtl_open(struct net_device *dev)
  {
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	void __iomem *ioaddr =3D tp->mmio_addr;
  	struct pci_dev *pdev =3D tp->pci_dev;
 -	u16 pci_status, pci_cmd;
 -
 -	pci_read_config_word(pdev, PCI_COMMAND, &pci_cmd);
 -	pci_read_config_word(pdev, PCI_STATUS, &pci_status);
 +	int retval =3D -ENOMEM;
 =20
 -	netif_err(tp, intr, dev, "PCI error (cmd =3D 0x%04x, status =3D 0x%04x)\=
n",
 -		  pci_cmd, pci_status);
 +	pm_runtime_get_sync(&pdev->dev);
 =20
  	/*
- 	 * Rx and Tx desscriptors needs 256 bytes alignment.
 -	 * The recovery sequence below admits a very elaborated explanation:
 -	 * - it seems to work;
 -	 * - I did not see what else could be done;
 -	 * - it makes iop3xx happy.
 -	 *
 -	 * Feel free to adjust to your needs.
++	 * Rx and Tx desscriptors need 256 bytes alignment.
 +	 * dma_alloc_coherent provides more.
  	 */
 -	if (pdev->broken_parity_status)
 -		pci_cmd &=3D ~PCI_COMMAND_PARITY;
 -	else
 -		pci_cmd |=3D PCI_COMMAND_SERR | PCI_COMMAND_PARITY;
 +	tp->TxDescArray =3D dma_alloc_coherent(&pdev->dev, R8169_TX_RING_BYTES,
 +					     &tp->TxPhyAddr, GFP_KERNEL);
 +	if (!tp->TxDescArray)
 +		goto err_pm_runtime_put;
 =20
 -	pci_write_config_word(pdev, PCI_COMMAND, pci_cmd);
 +	tp->RxDescArray =3D dma_alloc_coherent(&pdev->dev, R8169_RX_RING_BYTES,
 +					     &tp->RxPhyAddr, GFP_KERNEL);
 +	if (!tp->RxDescArray)
 +		goto err_free_tx_0;
 =20
 -	pci_write_config_word(pdev, PCI_STATUS,
 -		pci_status & (PCI_STATUS_DETECTED_PARITY |
 -		PCI_STATUS_SIG_SYSTEM_ERROR | PCI_STATUS_REC_MASTER_ABORT |
 -		PCI_STATUS_REC_TARGET_ABORT | PCI_STATUS_SIG_TARGET_ABORT));
 +	retval =3D rtl8169_init_ring(dev);
 +	if (retval < 0)
 +		goto err_free_rx_1;
 =20
 -	/* The infamous DAC f*ckup only happens at boot time */
 -	if ((tp->cp_cmd & PCIDAC) && !tp->dirty_rx && !tp->cur_rx) {
 -		void __iomem *ioaddr =3D tp->mmio_addr;
 +	INIT_WORK(&tp->wk.work, rtl_task);
 =20
 -		netif_info(tp, intr, dev, "disabling PCI DAC\n");
 -		tp->cp_cmd &=3D ~PCIDAC;
 -		RTL_W16(CPlusCmd, tp->cp_cmd);
 -		dev->features &=3D ~NETIF_F_HIGHDMA;
 -	}
 +	smp_mb();
 =20
 -	rtl8169_hw_reset(tp);
 +	rtl_request_firmware(tp);
 =20
 -	rtl8169_schedule_work(dev, rtl8169_reinit_task);
 -}
 +	retval =3D request_irq(pdev->irq, rtl8169_interrupt,
 +			     (tp->features & RTL_FEATURE_MSI) ? 0 : IRQF_SHARED,
 +			     dev->name, dev);
 +	if (retval < 0)
 +		goto err_release_fw_2;
 =20
 -static void rtl8169_tx_interrupt(struct net_device *dev,
 -				 struct rtl8169_private *tp,
 -				 void __iomem *ioaddr)
 -{
 -	unsigned int dirty_tx, tx_left;
 +	rtl_lock_work(tp);
 =20
 -	dirty_tx =3D tp->dirty_tx;
 -	smp_rmb();
 -	tx_left =3D tp->cur_tx - dirty_tx;
 +	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
 =20
 -	while (tx_left > 0) {
 -		unsigned int entry =3D dirty_tx % NUM_TX_DESC;
 -		struct ring_info *tx_skb =3D tp->tx_skb + entry;
 -		u32 status;
 +	napi_enable(&tp->napi);
 =20
 -		rmb();
 -		status =3D le32_to_cpu(tp->TxDescArray[entry].opts1);
 -		if (status & DescOwn)
 -			break;
 +	rtl8169_init_phy(dev, tp);
 =20
 -		rtl8169_unmap_tx_skb(&tp->pci_dev->dev, tx_skb,
 -				     tp->TxDescArray + entry);
 -		if (status & LastFrag) {
 -			dev->stats.tx_packets++;
 -			dev->stats.tx_bytes +=3D tx_skb->skb->len;
 -			dev_kfree_skb(tx_skb->skb);
 -			tx_skb->skb =3D NULL;
 -		}
 -		dirty_tx++;
 -		tx_left--;
 -	}
 +	__rtl8169_set_features(dev, dev->features);
 =20
 -	if (tp->dirty_tx !=3D dirty_tx) {
 -		tp->dirty_tx =3D dirty_tx;
 -		smp_wmb();
 -		if (netif_queue_stopped(dev) &&
 -		    (TX_BUFFS_AVAIL(tp) >=3D MAX_SKB_FRAGS)) {
 -			netif_wake_queue(dev);
 -		}
 -		/*
 -		 * 8168 hack: TxPoll requests are lost when the Tx packets are
 -		 * too close. Let's kick an extra TxPoll request when a burst
 -		 * of start_xmit activity is detected (if it is not detected,
 -		 * it is slow enough). -- FR
 -		 */
 -		smp_rmb();
 -		if (tp->cur_tx !=3D dirty_tx)
 -			RTL_W8(TxPoll, NPQ);
 -	}
 -}
 +	rtl_pll_power_up(tp);
 =20
 -static inline int rtl8169_fragmented_frame(u32 status)
 -{
 -	return (status & (FirstFrag | LastFrag)) !=3D (FirstFrag | LastFrag);
 -}
 +	rtl_hw_start(dev);
 =20
 -static inline void rtl8169_rx_csum(struct sk_buff *skb, u32 opts1)
 -{
 -	u32 status =3D opts1 & RxProtoMask;
 +	netif_start_queue(dev);
 =20
 -	if (((status =3D=3D RxProtoTCP) && !(opts1 & TCPFail)) ||
 -	    ((status =3D=3D RxProtoUDP) && !(opts1 & UDPFail)))
 -		skb->ip_summed =3D CHECKSUM_UNNECESSARY;
 -	else
 -		skb_checksum_none_assert(skb);
 -}
 +	rtl_unlock_work(tp);
 =20
 -static struct sk_buff *rtl8169_try_rx_copy(void *data,
 -					   struct rtl8169_private *tp,
 -					   int pkt_size,
 -					   dma_addr_t addr)
 -{
 -	struct sk_buff *skb;
 -	struct device *d =3D &tp->pci_dev->dev;
 +	tp->saved_wolopts =3D 0;
 +	pm_runtime_put_noidle(&pdev->dev);
 =20
 -	data =3D rtl8169_align(data);
 -	dma_sync_single_for_cpu(d, addr, pkt_size, DMA_FROM_DEVICE);
 -	prefetch(data);
 -	skb =3D netdev_alloc_skb_ip_align(tp->dev, pkt_size);
 -	if (skb)
 -		memcpy(skb->data, data, pkt_size);
 -	dma_sync_single_for_device(d, addr, pkt_size, DMA_FROM_DEVICE);
 +	rtl8169_check_link_status(dev, tp, ioaddr);
 +out:
 +	return retval;
 =20
 -	return skb;
 +err_release_fw_2:
 +	rtl_release_firmware(tp);
 +	rtl8169_rx_clear(tp);
 +err_free_rx_1:
 +	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 +			  tp->RxPhyAddr);
 +	tp->RxDescArray =3D NULL;
 +err_free_tx_0:
 +	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
 +			  tp->TxPhyAddr);
 +	tp->TxDescArray =3D NULL;
 +err_pm_runtime_put:
 +	pm_runtime_put_noidle(&pdev->dev);
 +	goto out;
  }
 =20
 -static int rtl8169_rx_interrupt(struct net_device *dev,
 -				struct rtl8169_private *tp,
 -				void __iomem *ioaddr, u32 budget)
 +static struct rtnl_link_stats64 *
 +rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *sta=
ts)
  {
 -	unsigned int cur_rx, rx_left;
 -	unsigned int count;
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	void __iomem *ioaddr =3D tp->mmio_addr;
 +	unsigned int start;
 =20
 -	cur_rx =3D tp->cur_rx;
 -	rx_left =3D NUM_RX_DESC + tp->dirty_rx - cur_rx;
 -	rx_left =3D min(rx_left, budget);
 +	if (netif_running(dev))
 +		rtl8169_rx_missed(dev, ioaddr);
 =20
 -	for (; rx_left > 0; rx_left--, cur_rx++) {
 -		unsigned int entry =3D cur_rx % NUM_RX_DESC;
 -		struct RxDesc *desc =3D tp->RxDescArray + entry;
 -		u32 status;
 +	do {
 +		start =3D u64_stats_fetch_begin_bh(&tp->rx_stats.syncp);
 +		stats->rx_packets =3D tp->rx_stats.packets;
 +		stats->rx_bytes	=3D tp->rx_stats.bytes;
 +	} while (u64_stats_fetch_retry_bh(&tp->rx_stats.syncp, start));
 =20
 -		rmb();
 -		status =3D le32_to_cpu(desc->opts1) & tp->opts1_mask;
 =20
 -		if (status & DescOwn)
 -			break;
 -		if (unlikely(status & RxRES)) {
 -			netif_info(tp, rx_err, dev, "Rx ERROR. status =3D %08x\n",
 -				   status);
 -			dev->stats.rx_errors++;
 -			if (status & (RxRWT | RxRUNT))
 -				dev->stats.rx_length_errors++;
 -			if (status & RxCRC)
 -				dev->stats.rx_crc_errors++;
 -			if (status & RxFOVF) {
 -				rtl8169_schedule_work(dev, rtl8169_reset_task);
 -				dev->stats.rx_fifo_errors++;
 -			}
 -			rtl8169_mark_to_asic(desc, rx_buf_sz);
 -		} else {
 -			struct sk_buff *skb;
 -			dma_addr_t addr =3D le64_to_cpu(desc->addr);
 -			int pkt_size =3D (status & 0x00003fff) - 4;
 +	do {
 +		start =3D u64_stats_fetch_begin_bh(&tp->tx_stats.syncp);
 +		stats->tx_packets =3D tp->tx_stats.packets;
 +		stats->tx_bytes	=3D tp->tx_stats.bytes;
 +	} while (u64_stats_fetch_retry_bh(&tp->tx_stats.syncp, start));
 =20
 -			/*
 -			 * The driver does not support incoming fragmented
 -			 * frames. They are seen as a symptom of over-mtu
 -			 * sized frames.
 -			 */
 -			if (unlikely(rtl8169_fragmented_frame(status))) {
 -				dev->stats.rx_dropped++;
 -				dev->stats.rx_length_errors++;
 -				rtl8169_mark_to_asic(desc, rx_buf_sz);
 -				continue;
 -			}
 +	stats->rx_dropped	=3D dev->stats.rx_dropped;
 +	stats->tx_dropped	=3D dev->stats.tx_dropped;
 +	stats->rx_length_errors =3D dev->stats.rx_length_errors;
 +	stats->rx_errors	=3D dev->stats.rx_errors;
 +	stats->rx_crc_errors	=3D dev->stats.rx_crc_errors;
 +	stats->rx_fifo_errors	=3D dev->stats.rx_fifo_errors;
 +	stats->rx_missed_errors =3D dev->stats.rx_missed_errors;
 =20
 -			skb =3D rtl8169_try_rx_copy(tp->Rx_databuff[entry],
 -						  tp, pkt_size, addr);
 -			rtl8169_mark_to_asic(desc, rx_buf_sz);
 -			if (!skb) {
 -				dev->stats.rx_dropped++;
 -				continue;
 -			}
 +	return stats;
 +}
 =20
 -			rtl8169_rx_csum(skb, status);
 -			skb_put(skb, pkt_size);
 -			skb->protocol =3D eth_type_trans(skb, dev);
 +static void rtl8169_net_suspend(struct net_device *dev)
 +{
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 =20
 -			rtl8169_rx_vlan_tag(desc, skb);
 +	if (!netif_running(dev))
 +		return;
 =20
 -			napi_gro_receive(&tp->napi, skb);
 +	netif_device_detach(dev);
 +	netif_stop_queue(dev);
 =20
 -			dev->stats.rx_bytes +=3D pkt_size;
 -			dev->stats.rx_packets++;
 -		}
 +	rtl_lock_work(tp);
 +	napi_disable(&tp->napi);
 +	clear_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
 +	rtl_unlock_work(tp);
 =20
 -		/* Work around for AMD plateform. */
 -		if ((desc->opts2 & cpu_to_le32(0xfffe000)) &&
 -		    (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_05)) {
 -			desc->opts2 =3D 0;
 -			cur_rx++;
 -		}
 -	}
 +	rtl_pll_power_down(tp);
 +}
 =20
 -	count =3D cur_rx - tp->cur_rx;
 -	tp->cur_rx =3D cur_rx;
 +#ifdef CONFIG_PM
 =20
 -	tp->dirty_rx +=3D count;
 +static int rtl8169_suspend(struct device *device)
 +{
 +	struct pci_dev *pdev =3D to_pci_dev(device);
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
 =20
 -	return count;
 +	rtl8169_net_suspend(dev);
 +
 +	return 0;
  }
 =20
 -static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 +static void __rtl8169_resume(struct net_device *dev)
  {
 -	struct net_device *dev =3D dev_instance;
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 -	void __iomem *ioaddr =3D tp->mmio_addr;
 -	int handled =3D 0;
 -	int status;
 =20
 -	/* loop handling interrupts until we have no new ones or
 -	 * we hit a invalid/hotplug case.
 -	 */
 -	status =3D RTL_R16(IntrStatus);
 -	while (status && status !=3D 0xffff) {
 -		status &=3D tp->intr_event;
 -		if (!status)
 -			break;
 -
 -		handled =3D 1;
 +	netif_device_attach(dev);
 =20
 -		/* Handle all of the error cases first. These will reset
 -		 * the chip, so just exit the loop.
 -		 */
 -		if (unlikely(!netif_running(dev))) {
 -			rtl8169_hw_reset(tp);
 -			break;
 -		}
 +	rtl_pll_power_up(tp);
 =20
 -		if (unlikely(status & RxFIFOOver)) {
 -			switch (tp->mac_version) {
 -			/* Work around for rx fifo overflow */
 -			case RTL_GIGA_MAC_VER_11:
 -				netif_stop_queue(dev);
 -				rtl8169_tx_timeout(dev);
 -				goto done;
 -			default:
 -				break;
 -			}
 -		}
 +	set_bit(RTL_FLAG_TASK_ENABLED, tp->wk.flags);
 =20
 -		if (unlikely(status & SYSErr)) {
 -			rtl8169_pcierr_interrupt(dev);
 -			break;
 -		}
 +	rtl_schedule_task(tp, RTL_FLAG_TASK_RESET_PENDING);
 +}
 =20
 -		if (status & LinkChg)
 -			__rtl8169_check_link_status(dev, tp, ioaddr, true);
 +static int rtl8169_resume(struct device *device)
 +{
 +	struct pci_dev *pdev =3D to_pci_dev(device);
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 =20
 -		/* We need to see the lastest version of tp->intr_mask to
 -		 * avoid ignoring an MSI interrupt and having to wait for
 -		 * another event which may never come.
 -		 */
 -		smp_rmb();
 -		if (status & tp->intr_mask & tp->napi_event) {
 -			RTL_W16(IntrMask, tp->intr_event & ~tp->napi_event);
 -			tp->intr_mask =3D ~tp->napi_event;
 +	rtl8169_init_phy(dev, tp);
 =20
 -			if (likely(napi_schedule_prep(&tp->napi)))
 -				__napi_schedule(&tp->napi);
 -			else
 -				netif_info(tp, intr, dev,
 -					   "interrupt %04x in poll\n", status);
 -		}
 +	if (netif_running(dev))
 +		__rtl8169_resume(dev);
 =20
 -		/* We only get a new MSI interrupt when all active irq
 -		 * sources on the chip have been acknowledged. So, ack
 -		 * everything we've seen and check if new sources have become
 -		 * active to avoid blocking all interrupts from the chip.
 -		 */
 -		RTL_W16(IntrStatus,
 -			(status & RxFIFOOver) ? (status | RxOverflow) : status);
 -		status =3D RTL_R16(IntrStatus);
 -	}
 -done:
 -	return IRQ_RETVAL(handled);
 +	return 0;
  }
 =20
 -static int rtl8169_poll(struct napi_struct *napi, int budget)
 +static int rtl8169_runtime_suspend(struct device *device)
  {
 -	struct rtl8169_private *tp =3D container_of(napi, struct rtl8169_private=
, napi);
 -	struct net_device *dev =3D tp->dev;
 -	void __iomem *ioaddr =3D tp->mmio_addr;
 -	int work_done;
 +	struct pci_dev *pdev =3D to_pci_dev(device);
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
 +	struct rtl8169_private *tp =3D netdev_priv(dev);
 =20
 -	work_done =3D rtl8169_rx_interrupt(dev, tp, ioaddr, (u32) budget);
 -	rtl8169_tx_interrupt(dev, tp, ioaddr);
 +	if (!tp->TxDescArray)
 +		return 0;
 =20
 -	if (work_done < budget) {
 -		napi_complete(napi);
 +	rtl_lock_work(tp);
 +	tp->saved_wolopts =3D __rtl8169_get_wol(tp);
 +	__rtl8169_set_wol(tp, WAKE_ANY);
 +	rtl_unlock_work(tp);
 =20
 -		/* We need for force the visibility of tp->intr_mask
 -		 * for other CPUs, as we can loose an MSI interrupt
 -		 * and potentially wait for a retransmit timeout if we don't.
 -		 * The posted write to IntrMask is safe, as it will
 -		 * eventually make it to the chip and we won't loose anything
 -		 * until it does.
 -		 */
 -		tp->intr_mask =3D 0xffff;
 -		wmb();
 -		RTL_W16(IntrMask, tp->intr_event);
 -	}
 +	rtl8169_net_suspend(dev);
 =20
 -	return work_done;
 +	return 0;
  }
 =20
 -static void rtl8169_rx_missed(struct net_device *dev, void __iomem *ioadd=
r)
 +static int rtl8169_runtime_resume(struct device *device)
  {
 +	struct pci_dev *pdev =3D to_pci_dev(device);
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 =20
 -	if (tp->mac_version > RTL_GIGA_MAC_VER_06)
 -		return;
 +	if (!tp->TxDescArray)
 +		return 0;
 =20
 -	dev->stats.rx_missed_errors +=3D (RTL_R32(RxMissed) & 0xffffff);
 -	RTL_W32(RxMissed, 0);
 +	rtl_lock_work(tp);
 +	__rtl8169_set_wol(tp, tp->saved_wolopts);
 +	tp->saved_wolopts =3D 0;
 +	rtl_unlock_work(tp);
 +
 +	rtl8169_init_phy(dev, tp);
 +
 +	__rtl8169_resume(dev);
 +
 +	return 0;
  }
 =20
 -static void rtl8169_down(struct net_device *dev)
 +static int rtl8169_runtime_idle(struct device *device)
  {
 +	struct pci_dev *pdev =3D to_pci_dev(device);
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 -	void __iomem *ioaddr =3D tp->mmio_addr;
 -
 -	del_timer_sync(&tp->timer);
 =20
 -	netif_stop_queue(dev);
 -
 -	napi_disable(&tp->napi);
 +	return tp->TxDescArray ? -EBUSY : 0;
 +}
 =20
 -	spin_lock_irq(&tp->lock);
 +static const struct dev_pm_ops rtl8169_pm_ops =3D {
 +	.suspend		=3D rtl8169_suspend,
 +	.resume			=3D rtl8169_resume,
 +	.freeze			=3D rtl8169_suspend,
 +	.thaw			=3D rtl8169_resume,
 +	.poweroff		=3D rtl8169_suspend,
 +	.restore		=3D rtl8169_resume,
 +	.runtime_suspend	=3D rtl8169_runtime_suspend,
 +	.runtime_resume		=3D rtl8169_runtime_resume,
 +	.runtime_idle		=3D rtl8169_runtime_idle,
 +};
 =20
 -	rtl8169_hw_reset(tp);
 -	/*
 -	 * At this point device interrupts can not be enabled in any function,
 -	 * as netif_running is not true (rtl8169_interrupt, rtl8169_reset_task,
 -	 * rtl8169_reinit_task) and napi is disabled (rtl8169_poll).
 -	 */
 -	rtl8169_rx_missed(dev, ioaddr);
 +#define RTL8169_PM_OPS	(&rtl8169_pm_ops)
 =20
 -	spin_unlock_irq(&tp->lock);
 +#else /* !CONFIG_PM */
 =20
 -	synchronize_irq(dev->irq);
 +#define RTL8169_PM_OPS	NULL
 =20
 -	/* Give a racing hard_start_xmit a few cycles to complete. */
 -	synchronize_sched();  /* FIXME: should this be synchronize_irq()? */
 +#endif /* !CONFIG_PM */
 =20
 -	rtl8169_tx_clear(tp);
 +static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 +{
 +	void __iomem *ioaddr =3D tp->mmio_addr;
 =20
 -	rtl8169_rx_clear(tp);
 +	/* WoL fails with 8168b when the receiver is disabled. */
 +	switch (tp->mac_version) {
 +	case RTL_GIGA_MAC_VER_11:
 +	case RTL_GIGA_MAC_VER_12:
 +	case RTL_GIGA_MAC_VER_17:
 +		pci_clear_master(tp->pci_dev);
 =20
 -	rtl_pll_power_down(tp);
 +		RTL_W8(ChipCmd, CmdRxEnb);
 +		/* PCI commit */
 +		RTL_R8(ChipCmd);
 +		break;
 +	default:
 +		break;
 +	}
  }
 =20
 -static int rtl8169_close(struct net_device *dev)
 +static void rtl_shutdown(struct pci_dev *pdev)
  {
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 -	struct pci_dev *pdev =3D tp->pci_dev;
 +	struct device *d =3D &pdev->dev;
 =20
 -	pm_runtime_get_sync(&pdev->dev);
 +	pm_runtime_get_sync(d);
 =20
 -	/* Update counters before going down */
 -	rtl8169_update_counters(dev);
 +	rtl8169_net_suspend(dev);
 =20
 -	rtl8169_down(dev);
 +	/* Restore original MAC address */
 +	rtl_rar_set(tp, dev->perm_addr);
 =20
 -	free_irq(dev->irq, dev);
 +	rtl8169_hw_reset(tp);
 =20
 -	dma_free_coherent(&pdev->dev, R8169_RX_RING_BYTES, tp->RxDescArray,
 -			  tp->RxPhyAddr);
 -	dma_free_coherent(&pdev->dev, R8169_TX_RING_BYTES, tp->TxDescArray,
 -			  tp->TxPhyAddr);
 -	tp->TxDescArray =3D NULL;
 -	tp->RxDescArray =3D NULL;
 +	if (system_state =3D=3D SYSTEM_POWER_OFF) {
 +		if (__rtl8169_get_wol(tp) & WAKE_ANY) {
 +			rtl_wol_suspend_quirk(tp);
 +			rtl_wol_shutdown_quirk(tp);
 +		}
 =20
 -	pm_runtime_put_sync(&pdev->dev);
 +		pci_wake_from_d3(pdev, true);
 +		pci_set_power_state(pdev, PCI_D3hot);
 +	}
 =20
 -	return 0;
 +	pm_runtime_put_noidle(d);
  }
 =20
 -static void rtl_set_rx_mode(struct net_device *dev)
 +static void __devexit rtl_remove_one(struct pci_dev *pdev)
  {
 +	struct net_device *dev =3D pci_get_drvdata(pdev);
  	struct rtl8169_private *tp =3D netdev_priv(dev);
 -	void __iomem *ioaddr =3D tp->mmio_addr;
 -	unsigned long flags;
 -	u32 mc_filter[2];	/* Multicast hash filter */
 -	int rx_mode;
 -	u32 tmp =3D 0;
 -
 -	if (dev->flags & IFF_PROMISC) {
 -		/* Unconditionally log net taps. */
 -		netif_notice(tp, link, dev, "Promiscuous mode enabled\n");
 -		rx_mode =3D
 -		    AcceptBroadcast | AcceptMulticast | AcceptMyPhys |
 -		    AcceptAllPhys;
 -		mc_filter[1] =3D mc_filter[0] =3D 0xffffffff;
 -	} else if ((netdev_mc_count(dev) > multicast_filter_limit) ||
 -		   (dev->flags & IFF_ALLMULTI)) {
 -		/* Too many to filter perfectly -- accept all multicasts. */
 -		rx_mode =3D AcceptBroadcast | AcceptMulticast | AcceptMyPhys;
 -		mc_filter[1] =3D mc_filter[0] =3D 0xffffffff;
 -	} else {
 -		struct netdev_hw_addr *ha;
 =20
 -		rx_mode =3D AcceptBroadcast | AcceptMyPhys;
 -		mc_filter[1] =3D mc_filter[0] =3D 0;
 -		netdev_for_each_mc_addr(ha, dev) {
 -			int bit_nr =3D ether_crc(ETH_ALEN, ha->addr) >> 26;
 -			mc_filter[bit_nr >> 5] |=3D 1 << (bit_nr & 31);
 -			rx_mode |=3D AcceptMulticast;
 -		}
 +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_27 ||
 +	    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_28 ||
 +	    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_31) {
 +		rtl8168_driver_stop(tp);
  	}
 =20
 -	spin_lock_irqsave(&tp->lock, flags);
 -
 -	tmp =3D (RTL_R32(RxConfig) & ~RX_CONFIG_ACCEPT_MASK) | rx_mode;
 +	cancel_work_sync(&tp->wk.work);
 =20
 -	if (tp->mac_version > RTL_GIGA_MAC_VER_06) {
 -		u32 data =3D mc_filter[0];
 +	unregister_netdev(dev);
 =20
 -		mc_filter[0] =3D swab32(mc_filter[1]);
 -		mc_filter[1] =3D swab32(data);
 -	}
 +	rtl_release_firmware(tp);
 =20
 -	RTL_W32(MAR0 + 4, mc_filter[1]);
 -	RTL_W32(MAR0 + 0, mc_filter[0]);
 +	if (pci_dev_run_wake(pdev))
 +		pm_runtime_get_noresume(&pdev->dev);
 =20
 -	RTL_W32(RxConfig, tmp);
 +	/* restore original MAC address */
 +	rtl_rar_set(tp, dev->perm_addr);
 =20
 -	spin_unlock_irqrestore(&tp->lock, flags);
 +	rtl_disable_msi(pdev, tp);
 +	rtl8169_release_board(pdev, dev, tp->mmio_addr);
 +	pci_set_drvdata(pdev, NULL);
  }
 =20
 -/**
 - *  rtl8169_get_stats - Get rtl8169 read/write statistics
 - *  @dev: The Ethernet Device to get statistics for
 - *
 - *  Get TX/RX statistics for rtl8169
 - */
 -static struct net_device_stats *rtl8169_get_stats(struct net_device *dev)
 +static const struct net_device_ops rtl_netdev_ops =3D {
 +	.ndo_open		=3D rtl_open,
 +	.ndo_stop		=3D rtl8169_close,
 +	.ndo_get_stats64	=3D rtl8169_get_stats64,
 +	.ndo_start_xmit		=3D rtl8169_start_xmit,
 +	.ndo_tx_timeout		=3D rtl8169_tx_timeout,
 +	.ndo_validate_addr	=3D eth_validate_addr,
 +	.ndo_change_mtu		=3D rtl8169_change_mtu,
 +	.ndo_fix_features	=3D rtl8169_fix_features,
 +	.ndo_set_features	=3D rtl8169_set_features,
 +	.ndo_set_mac_address	=3D rtl_set_mac_address,
 +	.ndo_do_ioctl		=3D rtl8169_ioctl,
 +	.ndo_set_rx_mode	=3D rtl_set_rx_mode,
 +#ifdef CONFIG_NET_POLL_CONTROLLER
 +	.ndo_poll_controller	=3D rtl8169_netpoll,
 +#endif
 +
 +};
 +
 +static const struct rtl_cfg_info {
 +	void (*hw_start)(struct net_device *);
 +	unsigned int region;
 +	unsigned int align;
 +	u16 event_slow;
 +	unsigned features;
 +	u8 default_ver;
 +} rtl_cfg_infos [] =3D {
 +	[RTL_CFG_0] =3D {
 +		.hw_start	=3D rtl_hw_start_8169,
 +		.region		=3D 1,
 +		.align		=3D 0,
 +		.event_slow	=3D SYSErr | LinkChg | RxOverflow | RxFIFOOver,
 +		.features	=3D RTL_FEATURE_GMII,
 +		.default_ver	=3D RTL_GIGA_MAC_VER_01,
 +	},
 +	[RTL_CFG_1] =3D {
 +		.hw_start	=3D rtl_hw_start_8168,
 +		.region		=3D 2,
 +		.align		=3D 8,
 +		.event_slow	=3D SYSErr | LinkChg | RxOverflow,
 +		.features	=3D RTL_FEATURE_GMII | RTL_FEATURE_MSI,
 +		.default_ver	=3D RTL_GIGA_MAC_VER_11,
 +	},
 +	[RTL_CFG_2] =3D {
 +		.hw_start	=3D rtl_hw_start_8101,
 +		.region		=3D 2,
 +		.align		=3D 8,
 +		.event_slow	=3D SYSErr | LinkChg | RxOverflow | RxFIFOOver |
 +				  PCSTimeout,
 +		.features	=3D RTL_FEATURE_MSI,
 +		.default_ver	=3D RTL_GIGA_MAC_VER_13,
 +	}
 +};
 +
 +/* Cfg9346_Unlock assumed. */
 +static unsigned rtl_try_msi(struct rtl8169_private *tp,
 +			    const struct rtl_cfg_info *cfg)
  {
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
  	void __iomem *ioaddr =3D tp->mmio_addr;
 -	unsigned long flags;
 +	unsigned msi =3D 0;
 +	u8 cfg2;
 =20
 -	if (netif_running(dev)) {
 -		spin_lock_irqsave(&tp->lock, flags);
 -		rtl8169_rx_missed(dev, ioaddr);
 -		spin_unlock_irqrestore(&tp->lock, flags);
 +	cfg2 =3D RTL_R8(Config2) & ~MSIEnable;
 +	if (cfg->features & RTL_FEATURE_MSI) {
 +		if (pci_enable_msi(tp->pci_dev)) {
 +			netif_info(tp, hw, tp->dev, "no MSI. Back to INTx.\n");
 +		} else {
 +			cfg2 |=3D MSIEnable;
 +			msi =3D RTL_FEATURE_MSI;
 +		}
  	}
 -
 -	return &dev->stats;
 +	if (tp->mac_version <=3D RTL_GIGA_MAC_VER_06)
 +		RTL_W8(Config2, cfg2);
 +	return msi;
  }
 =20
 -static void rtl8169_net_suspend(struct net_device *dev)
 +static int __devinit
 +rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
  {
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	const struct rtl_cfg_info *cfg =3D rtl_cfg_infos + ent->driver_data;
 +	const unsigned int region =3D cfg->region;
 +	struct rtl8169_private *tp;
 +	struct mii_if_info *mii;
 +	struct net_device *dev;
 +	void __iomem *ioaddr;
 +	int chipset, i;
 +	int rc;
 =20
 -	if (!netif_running(dev))
 -		return;
 +	if (netif_msg_drv(&debug)) {
 +		printk(KERN_INFO "%s Gigabit Ethernet driver %s loaded\n",
 +		       MODULENAME, RTL8169_VERSION);
 +	}
 =20
 -	rtl_pll_power_down(tp);
 +	dev =3D alloc_etherdev(sizeof (*tp));
 +	if (!dev) {
 +		rc =3D -ENOMEM;
 +		goto out;
 +	}
 +
 +	SET_NETDEV_DEV(dev, &pdev->dev);
 +	dev->netdev_ops =3D &rtl_netdev_ops;
 +	tp =3D netdev_priv(dev);
 +	tp->dev =3D dev;
 +	tp->pci_dev =3D pdev;
 +	tp->msg_enable =3D netif_msg_init(debug.msg_enable, R8169_MSG_DEFAULT);
 +
 +	mii =3D &tp->mii;
 +	mii->dev =3D dev;
 +	mii->mdio_read =3D rtl_mdio_read;
 +	mii->mdio_write =3D rtl_mdio_write;
 +	mii->phy_id_mask =3D 0x1f;
 +	mii->reg_num_mask =3D 0x1f;
 +	mii->supports_gmii =3D !!(cfg->features & RTL_FEATURE_GMII);
 +
 +	/* disable ASPM completely as that cause random device stop working
 +	 * problems as well as full system hangs for some PCIe devices users */
 +	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
 +				     PCIE_LINK_STATE_CLKPM);
 =20
 -	netif_device_detach(dev);
 -	netif_stop_queue(dev);
 -}
 +	/* enable device (incl. PCI PM wakeup and hotplug setup) */
 +	rc =3D pci_enable_device(pdev);
 +	if (rc < 0) {
 +		netif_err(tp, probe, dev, "enable failure\n");
 +		goto err_out_free_dev_1;
 +	}
 =20
 -#ifdef CONFIG_PM
 +	if (pci_set_mwi(pdev) < 0)
 +		netif_info(tp, probe, dev, "Mem-Wr-Inval unavailable\n");
 =20
 -static int rtl8169_suspend(struct device *device)
 -{
 -	struct pci_dev *pdev =3D to_pci_dev(device);
 -	struct net_device *dev =3D pci_get_drvdata(pdev);
 +	/* make sure PCI base addr 1 is MMIO */
 +	if (!(pci_resource_flags(pdev, region) & IORESOURCE_MEM)) {
 +		netif_err(tp, probe, dev,
 +			  "region #%d not an MMIO resource, aborting\n",
 +			  region);
 +		rc =3D -ENODEV;
 +		goto err_out_mwi_2;
 +	}
 =20
 -	rtl8169_net_suspend(dev);
 +	/* check for weird/broken PCI region reporting */
 +	if (pci_resource_len(pdev, region) < R8169_REGS_SIZE) {
 +		netif_err(tp, probe, dev,
 +			  "Invalid PCI region size(s), aborting\n");
 +		rc =3D -ENODEV;
 +		goto err_out_mwi_2;
 +	}
 =20
 -	return 0;
 -}
 +	rc =3D pci_request_regions(pdev, MODULENAME);
 +	if (rc < 0) {
 +		netif_err(tp, probe, dev, "could not request regions\n");
 +		goto err_out_mwi_2;
 +	}
 =20
 -static void __rtl8169_resume(struct net_device *dev)
 -{
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	tp->cp_cmd =3D RxChkSum;
 =20
 -	netif_device_attach(dev);
 +	if ((sizeof(dma_addr_t) > 4) &&
 +	    !pci_set_dma_mask(pdev, DMA_BIT_MASK(64)) && use_dac) {
 +		tp->cp_cmd |=3D PCIDAC;
 +		dev->features |=3D NETIF_F_HIGHDMA;
 +	} else {
 +		rc =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 +		if (rc < 0) {
 +			netif_err(tp, probe, dev, "DMA configuration failed\n");
 +			goto err_out_free_res_3;
 +		}
 +	}
 =20
 -	rtl_pll_power_up(tp);
 +	/* ioremap MMIO region */
 +	ioaddr =3D ioremap(pci_resource_start(pdev, region), R8169_REGS_SIZE);
 +	if (!ioaddr) {
 +		netif_err(tp, probe, dev, "cannot remap MMIO, aborting\n");
 +		rc =3D -EIO;
 +		goto err_out_free_res_3;
 +	}
 +	tp->mmio_addr =3D ioaddr;
 =20
 -	rtl8169_schedule_work(dev, rtl8169_reset_task);
 -}
 +	if (!pci_is_pcie(pdev))
 +		netif_info(tp, probe, dev, "not PCI Express\n");
 =20
 -static int rtl8169_resume(struct device *device)
 -{
 -	struct pci_dev *pdev =3D to_pci_dev(device);
 -	struct net_device *dev =3D pci_get_drvdata(pdev);
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	/* Identify chip attached to board */
 +	rtl8169_get_mac_version(tp, dev, cfg->default_ver);
 =20
 -	rtl8169_init_phy(dev, tp);
 +	rtl_init_rxcfg(tp);
 =20
 -	if (netif_running(dev))
 -		__rtl8169_resume(dev);
 +	rtl_irq_disable(tp);
 =20
 -	return 0;
 -}
 +	rtl_hw_reset(tp);
 =20
 -static int rtl8169_runtime_suspend(struct device *device)
 -{
 -	struct pci_dev *pdev =3D to_pci_dev(device);
 -	struct net_device *dev =3D pci_get_drvdata(pdev);
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	rtl_ack_events(tp, 0xffff);
 =20
 -	if (!tp->TxDescArray)
 -		return 0;
 +	pci_set_master(pdev);
 =20
 -	spin_lock_irq(&tp->lock);
 -	tp->saved_wolopts =3D __rtl8169_get_wol(tp);
 -	__rtl8169_set_wol(tp, WAKE_ANY);
 -	spin_unlock_irq(&tp->lock);
 +	/*
 +	 * Pretend we are using VLANs; This bypasses a nasty bug where
 +	 * Interrupts stop flowing on high load on 8110SCd controllers.
 +	 */
 +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_05)
 +		tp->cp_cmd |=3D RxVlan;
 =20
 -	rtl8169_net_suspend(dev);
 +	rtl_init_mdio_ops(tp);
 +	rtl_init_pll_power_ops(tp);
 +	rtl_init_jumbo_ops(tp);
 =20
 -	return 0;
 -}
 +	rtl8169_print_mac_version(tp);
 =20
 -static int rtl8169_runtime_resume(struct device *device)
 -{
 -	struct pci_dev *pdev =3D to_pci_dev(device);
 -	struct net_device *dev =3D pci_get_drvdata(pdev);
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	chipset =3D tp->mac_version;
 +	tp->txd_version =3D rtl_chip_infos[chipset].txd_version;
 =20
 -	if (!tp->TxDescArray)
 -		return 0;
 +	RTL_W8(Cfg9346, Cfg9346_Unlock);
 +	RTL_W8(Config1, RTL_R8(Config1) | PMEnable);
 +	RTL_W8(Config5, RTL_R8(Config5) & PMEStatus);
 +	if ((RTL_R8(Config3) & (LinkUp | MagicPacket)) !=3D 0)
 +		tp->features |=3D RTL_FEATURE_WOL;
 +	if ((RTL_R8(Config5) & (UWF | BWF | MWF)) !=3D 0)
 +		tp->features |=3D RTL_FEATURE_WOL;
 +	tp->features |=3D rtl_try_msi(tp, cfg);
 +	RTL_W8(Cfg9346, Cfg9346_Lock);
 =20
 -	spin_lock_irq(&tp->lock);
 -	__rtl8169_set_wol(tp, tp->saved_wolopts);
 -	tp->saved_wolopts =3D 0;
 -	spin_unlock_irq(&tp->lock);
 +	if (rtl_tbi_enabled(tp)) {
 +		tp->set_speed =3D rtl8169_set_speed_tbi;
 +		tp->get_settings =3D rtl8169_gset_tbi;
 +		tp->phy_reset_enable =3D rtl8169_tbi_reset_enable;
 +		tp->phy_reset_pending =3D rtl8169_tbi_reset_pending;
 +		tp->link_ok =3D rtl8169_tbi_link_ok;
 +		tp->do_ioctl =3D rtl_tbi_ioctl;
 +	} else {
 +		tp->set_speed =3D rtl8169_set_speed_xmii;
 +		tp->get_settings =3D rtl8169_gset_xmii;
 +		tp->phy_reset_enable =3D rtl8169_xmii_reset_enable;
 +		tp->phy_reset_pending =3D rtl8169_xmii_reset_pending;
 +		tp->link_ok =3D rtl8169_xmii_link_ok;
 +		tp->do_ioctl =3D rtl_xmii_ioctl;
 +	}
 =20
 -	rtl8169_init_phy(dev, tp);
 +	mutex_init(&tp->wk.mutex);
 =20
 -	__rtl8169_resume(dev);
 +	/* Get MAC address */
 +	for (i =3D 0; i < ETH_ALEN; i++)
 +		dev->dev_addr[i] =3D RTL_R8(MAC0 + i);
 +	memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
 =20
 -	return 0;
 -}
 +	SET_ETHTOOL_OPS(dev, &rtl8169_ethtool_ops);
 +	dev->watchdog_timeo =3D RTL8169_TX_TIMEOUT;
 =20
 -static int rtl8169_runtime_idle(struct device *device)
 -{
 -	struct pci_dev *pdev =3D to_pci_dev(device);
 -	struct net_device *dev =3D pci_get_drvdata(pdev);
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	netif_napi_add(dev, &tp->napi, rtl8169_poll, R8169_NAPI_WEIGHT);
 =20
 -	return tp->TxDescArray ? -EBUSY : 0;
 -}
 +	/* don't enable SG, IP_CSUM and TSO by default - it might not work
 +	 * properly for all devices */
 +	dev->features |=3D NETIF_F_RXCSUM |
 +		NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
 =20
 -static const struct dev_pm_ops rtl8169_pm_ops =3D {
 -	.suspend		=3D rtl8169_suspend,
 -	.resume			=3D rtl8169_resume,
 -	.freeze			=3D rtl8169_suspend,
 -	.thaw			=3D rtl8169_resume,
 -	.poweroff		=3D rtl8169_suspend,
 -	.restore		=3D rtl8169_resume,
 -	.runtime_suspend	=3D rtl8169_runtime_suspend,
 -	.runtime_resume		=3D rtl8169_runtime_resume,
 -	.runtime_idle		=3D rtl8169_runtime_idle,
 -};
 +	dev->hw_features =3D NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 +		NETIF_F_RXCSUM | NETIF_F_HW_VLAN_TX | NETIF_F_HW_VLAN_RX;
 +	dev->vlan_features =3D NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_TSO |
 +		NETIF_F_HIGHDMA;
 =20
 -#define RTL8169_PM_OPS	(&rtl8169_pm_ops)
 +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_05)
 +		/* 8110SCd requires hardware Rx VLAN - disallow toggling */
 +		dev->hw_features &=3D ~NETIF_F_HW_VLAN_RX;
 =20
 -#else /* !CONFIG_PM */
 +	dev->hw_features |=3D NETIF_F_RXALL;
 +	dev->hw_features |=3D NETIF_F_RXFCS;
 =20
 -#define RTL8169_PM_OPS	NULL
 +	tp->hw_start =3D cfg->hw_start;
 +	tp->event_slow =3D cfg->event_slow;
 =20
 -#endif /* !CONFIG_PM */
 +	tp->opts1_mask =3D (tp->mac_version !=3D RTL_GIGA_MAC_VER_01) ?
 +		~(RxBOVF | RxFOVF) : ~0;
 =20
 -static void rtl_wol_shutdown_quirk(struct rtl8169_private *tp)
 -{
 -	void __iomem *ioaddr =3D tp->mmio_addr;
 +	init_timer(&tp->timer);
 +	tp->timer.data =3D (unsigned long) dev;
 +	tp->timer.function =3D rtl8169_phy_timer;
 =20
 -	/* WoL fails with 8168b when the receiver is disabled. */
 -	switch (tp->mac_version) {
 -	case RTL_GIGA_MAC_VER_11:
 -	case RTL_GIGA_MAC_VER_12:
 -	case RTL_GIGA_MAC_VER_17:
 -		pci_clear_master(tp->pci_dev);
 +	tp->rtl_fw =3D RTL_FIRMWARE_UNKNOWN;
 =20
 -		RTL_W8(ChipCmd, CmdRxEnb);
 -		/* PCI commit */
 -		RTL_R8(ChipCmd);
 -		break;
 -	default:
 -		break;
 -	}
 -}
 +	rc =3D register_netdev(dev);
 +	if (rc < 0)
 +		goto err_out_msi_4;
 =20
 -static void rtl_shutdown(struct pci_dev *pdev)
 -{
 -	struct net_device *dev =3D pci_get_drvdata(pdev);
 -	struct rtl8169_private *tp =3D netdev_priv(dev);
 +	pci_set_drvdata(pdev, dev);
 =20
 -	rtl8169_net_suspend(dev);
 +	netif_info(tp, probe, dev, "%s at 0x%p, %pM, XID %08x IRQ %d\n",
 +		   rtl_chip_infos[chipset].name, ioaddr, dev->dev_addr,
 +		   (u32)(RTL_R32(TxConfig) & 0x9cf0f8ff), pdev->irq);
 +	if (rtl_chip_infos[chipset].jumbo_max !=3D JUMBO_1K) {
 +		netif_info(tp, probe, dev, "jumbo features [frames: %d bytes, "
 +			   "tx checksumming: %s]\n",
 +			   rtl_chip_infos[chipset].jumbo_max,
 +			   rtl_chip_infos[chipset].jumbo_tx_csum ? "ok" : "ko");
 +	}
 =20
 -	/* Restore original MAC address */
 -	rtl_rar_set(tp, dev->perm_addr);
 +	if (tp->mac_version =3D=3D RTL_GIGA_MAC_VER_27 ||
 +	    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_28 ||
 +	    tp->mac_version =3D=3D RTL_GIGA_MAC_VER_31) {
 +		rtl8168_driver_start(tp);
 +	}
 =20
 -	spin_lock_irq(&tp->lock);
 +	device_set_wakeup_enable(&pdev->dev, tp->features & RTL_FEATURE_WOL);
 =20
 -	rtl8169_hw_reset(tp);
 +	if (pci_dev_run_wake(pdev))
 +		pm_runtime_put_noidle(&pdev->dev);
 =20
 -	spin_unlock_irq(&tp->lock);
 +	netif_carrier_off(dev);
 =20
 -	if (system_state =3D=3D SYSTEM_POWER_OFF) {
 -		if (__rtl8169_get_wol(tp) & WAKE_ANY) {
 -			rtl_wol_suspend_quirk(tp);
 -			rtl_wol_shutdown_quirk(tp);
 -		}
 +out:
 +	return rc;
 =20
 -		pci_wake_from_d3(pdev, true);
 -		pci_set_power_state(pdev, PCI_D3hot);
 -	}
 +err_out_msi_4:
 +	rtl_disable_msi(pdev, tp);
 +	iounmap(ioaddr);
 +err_out_free_res_3:
 +	pci_release_regions(pdev);
 +err_out_mwi_2:
 +	pci_clear_mwi(pdev);
 +	pci_disable_device(pdev);
 +err_out_free_dev_1:
 +	free_netdev(dev);
 +	goto out;
  }
 =20
  static struct pci_driver rtl8169_pci_driver =3D {

--Signature=_Thu__29_Mar_2012_12_48_24_+1100_P1mEI_4i7K2bbi9M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPc79oAAoJEECxmPOUX5FEdQgP/0yZinZFjDveh5N005ouhMwL
BCumv2mjmPcL9YY1LRThvxrU4q+ejLZyKQF/n+F/bFms/+NjlBQrCef6G9744Fxn
bVTsumkDMiAqgh2ng5doecntY/bTCWEgciRG0ngTdWJ30wBC0hEk404sZOB9R6be
ar9gL4292iKB8+2QEV6E5k38DBiQRg7dPPU6zhSr9jGqurpSPB/R8LFSZzQdNMp1
VYM0ukxpUhljwFce9LNL4IpQG5XRFHi2wifzlgvlis2RZxRnswrpztQ8z5PVlZKZ
4oSjNKWkZV0lAVz6VCCkN/AEpm0FFf4EltO0stdOdUYdSVrzrNw71vo57dVMJ9QA
tLq8qpwfmGYVNzqKOMQbQT8Z/tvqS2asEL7cQLAdl/mMhIJWlLu7rdLtRYkX9ePm
sY3JQYzND5IaqQ3TzEwu7vyGN+eww6r4nA9HnKW3biYdks7PPjoM2nG+QpZ93U8G
WySpFf5ZS5MUHNxmdpPdnAOOOAq5fkw02USu99wkVjO3f66rTPjuyza0RE5sV7rQ
0UANtT+mMiH0aiJb5ZrL4saWbblVyjkpom/blkSNy20pr3M076pgHLmnU7VUU2yU
dMADosQIMb0HgUL44eAdgD3tfuvGj1hgh5iAn9OXac4b4oVXKuWITGdJGXPbweTh
ganMmeK39i6Y1UHlAHc6
=Ut3l
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Mar_2012_12_48_24_+1100_P1mEI_4i7K2bbi9M--
