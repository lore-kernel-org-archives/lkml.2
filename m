Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab2ISXef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:34:35 -0400
Received: from tex.lwn.net ([70.33.254.29]:41753 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963Ab2ISXec (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:34:32 -0400
Date: Wed, 19 Sep 2012 17:35:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Allen Huang (=?UTF-8?B?6buD5YGJ5qC8?=) 
	<allen_huang@davicom.com.tw>
Cc: <linux-kernel@vger.kernel.org>,
        "'Michael Chen'" <michael_chen@mail.davicom.com.tw>,
        "'Charles'" <charles_tsai@davicom.com.tw>,
        "'Joseph Chang'" <joseph_chang@mail.davicom.com.tw>
Subject: Re: Davicom DM9000C driver
Message-ID: <20120919173524.7bf4a974@lwn.net>
In-Reply-To: <20120919055333.3ECF95F94D@mail.davicom.com.tw>
References: <20120919055333.3ECF95F94D@mail.davicom.com.tw>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2012 13:58:08 +0800
Allen Huang (黃偉格)  <allen_huang@davicom.com.tw> wrote:

> I'm Allen Huang from Davicom. We are hereby opensourcing the linux
> driver for our DM9000C. 

That is great, but please read the development process documentation on
how best to submit something like this.  We would much rather see a patch
(inline, not as an attachment) to facilitate the review.

I'm going to take a quick look, but this is *not* a thorough review.

> /*
>  *      Davicom DM9000 Fast Ethernet driver for Linux.
>  * 	Copyright (C) 1997  Sten Wang
>  *
>  * 	This program is free software; you can redistribute it and/or
>  * 	modify it under the terms of the GNU General Public License
>  * 	as published by the Free Software Foundation; either version 2
>  * 	of the License, or (at your option) any later version.
>  *
>  * 	This program is distributed in the hope that it will be useful,
>  * 	but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * 	GNU General Public License for more details.
>  *
>  * (C) Copyright 1997-1998 DAVICOM Semiconductor,Inc. All Rights Reserved.

This line contradicts what comes above; GPL is not "all rights reserved."

>  * Additional updates, Copyright:
>  *	Ben Dooks <ben@simtec.co.uk>
>  *	Sascha Hauer <s.hauer@pengutronix.de>
>  *  
>  * 2010.07.20 V_R1 1.Write PHY Reg27 = 0xE100
>  *								 2.Just enable PHY once after GPIO setting in dm9000_init_dm9000()

The 80-column limit isn't as set in stone as it once was, but this still
pushes the limits rather farther than needed.  In general, though,
changelog information belongs in the VCS, not in the header comments.

> /* DM9000 register address locking.
>  *
>  * The DM9000 uses an address register to control where data written
>  * to the data register goes. This means that the address register
>  * must be preserved over interrupts or similar calls.
>  *
>  * During interrupt and other critical calls, a spinlock is used to
>  * protect the system, but the calls themselves save the address
>  * in the address register in case they are interrupting another
>  * access to the device.
>  *
>  * For general accesses a lock is provided so that calls which are
>  * allowed to sleep are serialised so that the address register does
>  * not need to be saved. This lock also serves to serialise access
>  * to the EEPROM and PHY access registers which are shared between
>  * these two devices.
>  */

This seems like a bit of a strange locking scheme.  Are the accesses to
this register pair so slow that you can't just protect the set with a
spinlock and be done with it?

> /* Structure/enum declaration ------------------------------- */
> typedef struct board_info {

typedef is strongly discouraged in kernel code; just use "struct
board_info" in your code.  Though a more descriptive name wouldn't hurt. 

> 	void __iomem	*io_addr;	/* Register I/O base address */
> 	void __iomem	*io_data;	/* Data I/O address */
> 	u16		 irq;		/* IRQ */
> 
> 	u16		tx_pkt_cnt;
> 	u16		queue_pkt_len;
> 	u16		queue_start_addr;
> 	u16		dbug_cnt;
> 	u8		io_mode;		/* 0:word, 2:byte */
> 	u8		phy_addr;
> 	u8		imr_all;
> 
> 	unsigned int	flags;
> 	unsigned int	in_suspend :1;
> 	int		debug_level;

This structure will have a lot of holes; maybe that's not a problem.

[...]
> 
> static void
> dm9000_phy_write(struct net_device *dev,
> 		 int phyaddr_unused, int reg, int value);

Why not just define this function here and avoid the forward declaration? 

> /* debug code */
> 
> #define dm9000_dbg(db, lev, msg...) do {		\
> 	if ((lev) < CONFIG_DM9000_DEBUGLEVEL &&		\
> 	    (lev) < db->debug_level) {			\
> 		dev_dbg(db->dev, msg);			\
> 	}						\
> } while (0)

We have nice dynamic debugging facilities that make this kind of stuff
unnecessary.  See https://lwn.net/Articles/434833/

> /* DM9000 network board routine ---------------------------- */
> 
> static void
> dm9000_reset(board_info_t * db)
> {
> 	dev_dbg(db->dev, "resetting device\n");
> 
> 	/* RESET device */
> 	writeb(DM9000_NCR, db->io_addr);
> 	udelay(200);
> 	writeb(NCR_RST, db->io_data);
> 	udelay(200);
> }
> 
> /*
>  *   Read a byte from I/O port
>  */
> static u8
> ior(board_info_t * db, int reg)
> {
> 	writeb(reg, db->io_addr);
> 	return readb(db->io_data);
> }
> 
> /*
>  *   Write a byte to I/O port
>  */
> 
> static void
> iow(board_info_t * db, int reg, int value)
> {
> 	writeb(reg, db->io_addr);
> 	writeb(value, db->io_data);
> }

So the locking you were talking about is clearly happening at a higher
level than here.  It would be good to note what locking is expected by
these functions.

> static void dm9000_set_io(struct board_info *db, int byte_width)
> {
> 	/* use the size of the data resource to work out what IO
> 	 * routines we want to use
> 	 */
> 
> 	switch (byte_width) {
> 	case 1:
> 		db->dumpblk = dm9000_dumpblk_8bit;
> 		db->outblk  = dm9000_outblk_8bit;
> 		db->inblk   = dm9000_inblk_8bit;
> 		break;
> 
> 
> 	case 3:
> 		dev_dbg(db->dev, ": 3 byte IO, falling back to 16bit\n");
> 	case 2:
> 		db->dumpblk = dm9000_dumpblk_16bit;
> 		db->outblk  = dm9000_outblk_16bit;
> 		db->inblk   = dm9000_inblk_16bit;
> 		break;
> 
> 	case 4:
> 	default:
> 		db->dumpblk = dm9000_dumpblk_32bit;
> 		db->outblk  = dm9000_outblk_32bit;
> 		db->inblk   = dm9000_inblk_32bit;
> 		break;
> 	}
> }

It might be nice to move these function pointers into their own structure.
You could then declare them static and const and just assign the structure
pointer here.

> static void dm9000_schedule_poll(board_info_t *db)
> {
> 	if (db->type == TYPE_DM9000E)
> 		schedule_delayed_work(&db->phy_poll, HZ * 2);

Coding style: HZ*2.  Running checkpatch would be a good idea.

[...]

> /*
>  *  Read a word data from EEPROM
>  */
> static void
> dm9000_read_eeprom(board_info_t *db, int offset, u8 *to)
> {
> 	unsigned long flags;
> 
> 	if (db->flags & DM9000_PLATF_NO_EEPROM) {
> 		to[0] = 0xff;
> 		to[1] = 0xff;
> 		return;
> 	}
> 
> 	mutex_lock(&db->addr_lock);

So I'm still really confused by this locking.  What is ->addr_lock
protecting? 

> 	spin_lock_irqsave(&db->lock, flags);
> 
> 	iow(db, DM9000_EPAR, offset);
> 	iow(db, DM9000_EPCR, EPCR_ERPRR);
> 
> 	spin_unlock_irqrestore(&db->lock, flags);
> 
> 	dm9000_wait_eeprom(db);
> 
> 	/* delay for at-least 150uS */
> 	msleep(1);
> 
> 	spin_lock_irqsave(&db->lock, flags);
> 
> 	iow(db, DM9000_EPCR, 0x0);
> 
> 	to[0] = ior(db, DM9000_EPDRL);
> 	to[1] = ior(db, DM9000_EPDRH);
> 
> 	spin_unlock_irqrestore(&db->lock, flags);
> 
> 	mutex_unlock(&db->addr_lock);
> }
> 
> /*
>  * Write a word data to SROM
>  */
> static void
> dm9000_write_eeprom(board_info_t *db, int offset, u8 *data)
> {
> 	unsigned long flags;
> 
> 	if (db->flags & DM9000_PLATF_NO_EEPROM)
> 		return;
> 
> 	mutex_lock(&db->addr_lock);
> 
> 	spin_lock_irqsave(&db->lock, flags);
> 	iow(db, DM9000_EPAR, offset);
> 	iow(db, DM9000_EPDRH, data[1]);
> 	iow(db, DM9000_EPDRL, data[0]);
> 	iow(db, DM9000_EPCR, EPCR_WEP | EPCR_ERPRW);
> 	spin_unlock_irqrestore(&db->lock, flags);
> 
> 	dm9000_wait_eeprom(db);
> 
> 	mdelay(1);	/* wait at least 150uS to clear */

Why mdelay() here?  You used msleep() above.

> 	spin_lock_irqsave(&db->lock, flags);
> 	iow(db, DM9000_EPCR, 0);
> 	spin_unlock_irqrestore(&db->lock, flags);
> 
> 	mutex_unlock(&db->addr_lock);
> }

[...]
> static void
> dm9000_poll_work(struct work_struct *w)
> {
> 	struct delayed_work *dw = container_of(w, struct delayed_work, work);
> 	board_info_t *db = container_of(dw, board_info_t, phy_poll);
> 	struct net_device *ndev = db->ndev;
> 
> //JJ2
> //	if (db->flags & DM9000_PLATF_SIMPLE_PHY &&
> //	    !(db->flags & DM9000_PLATF_EXT_PHY)) {
> //  =

This kind of stuff should come out - either you need it or you don't.

> 		if(1){						

Likewise.  Plus the coding syle is wrong :)

> 		unsigned nsr = dm9000_read_locked(db, DM9000_NSR);
> 		unsigned old_carrier = netif_carrier_ok(ndev) ? 1 : 0;
> 		unsigned new_carrier;
> 
> 		new_carrier = (nsr & NSR_LINKST) ? 1 : 0;
> 
> 		if (old_carrier != new_carrier) {
> 			
> 			if (new_carrier)
> 			  printk(KERN_INFO "[dm9000%c %s Ethernet Driver, V%s]: Link-Up!!\n",dm9000_type_to_char(db->type), CARDNAME, DRV_VERSION); //JJ2

Why not dev_info() here?

> 			else
> 			  printk(KERN_INFO "[%s Ethernet Driver, V%s]: Link-Down!!\n", CARDNAME, DRV_VERSION); //JJ2
> 			
> 			if (netif_msg_link(db))
> 				dm9000_show_carrier(db, new_carrier, nsr);
> 
> 			if (!new_carrier)
> 				netif_carrier_off(ndev);
> 			else
> 				netif_carrier_on(ndev);
> 		}
> 	} else
> 		mii_check_media(&db->mii, netif_msg_link(db), 0);
> 	
> 	if (netif_running(ndev))
> 		dm9000_schedule_poll(db);
> }
> 
> /* dm9000_release_board
>  *
>  * release a board, and any mapped resources
>  */
> 
> static void
> dm9000_release_board(struct platform_device *pdev, struct board_info *db)
> {
> 	/* unmap our resources */
> 
> 	iounmap(db->io_addr);
> 	iounmap(db->io_data);
> 
> 	/* release the resources */
> 
> 	release_resource(db->data_req);

I think this wants to be release_mem_region()

> 	kfree(db->data_req);

...and this shouldn't be here at all.

> 	release_resource(db->addr_req);
> 	kfree(db->addr_req);
> }

[...]

> /*
>  * Initilize dm9000 board
>  */
> static void
> dm9000_init_dm9000(struct net_device *dev)
> {
> 	board_info_t *db = netdev_priv(dev);
> 	unsigned int imr;
> 
> 	dm9000_dbg(db, 1, "entering %s\n", __func__);
> 
> 	/* I/O mode */
> 	db->io_mode = ior(db, DM9000_ISR) >> 6;	/* ISR bit7:6 keeps I/O mode */

So this looks like it wants the lock held?

> 	/* GPIO0 on pre-activate PHY */
> //V_R1	iow(db, DM9000_GPR, 0);	/* REG_1F bit0 activate phyxcer */
> 	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */
> 	iow(db, DM9000_GPR, 0);	/* Enable PHY */
>         mdelay(20);  //V_R2
> 
> 	dm9000_phy_write(dev, 0, 0, 0x8000); //V_R2 reset PHY
>         mdelay (20);

...and now we have 40ms of hard delay with the lock held and interrupts
disabled?  Ouch.

> //	if (db->flags & DM9000_PLATF_EXT_PHY)
> //		iow(db, DM9000_NCR, NCR_EXT_PHY);
> 
> 	/* Program operating register */
> 	iow(db, DM9000_TCR, 0);	        /* TX Polling clear */
> 	iow(db, DM9000_BPTR, 0x3f);	/* Less 3Kb, 200us */
> 	iow(db, DM9000_FCR, 0xff);	/* Flow Control */
> 	iow(db, DM9000_SMCR, 0);        /* Special Mode */
> 	/* clear TX status */
> 	iow(db, DM9000_NSR, NSR_WAKEST | NSR_TX2END | NSR_TX1END);
> 	iow(db, DM9000_ISR, ISR_CLR_STATUS); /* Clear interrupt status */
> 
> 	/* Set address filter table */
> 	dm9000_hash_table(dev);
> 
> 	imr = IMR_PAR | IMR_PTM | IMR_PRM;
> 	if (db->type != TYPE_DM9000E)
> 		imr |= IMR_LNKCHNG;
> 
> 	db->imr_all = imr;
> 
> 	/* Enable TX/RX interrupt mask */
> 	iow(db, DM9000_IMR, imr);
> 
> 	/* Init Driver variable */
> 	db->tx_pkt_cnt = 0;
> 	db->queue_pkt_len = 0;
> 	dev->trans_start = 0;
> 	
> 	dm9000_phy_write(dev, 0, 27, 0xE100); //V_R1
> }
> 
> /* Our watchdog timed out. Called by the networking layer */
> static void dm9000_timeout(struct net_device *dev)
> {
> 	board_info_t *db = netdev_priv(dev);
> 	u8 reg_save;
> 	unsigned long flags;
> 
> 	/* Save previous register address */
> 	reg_save = readb(db->io_addr);
> 	spin_lock_irqsave(&db->lock, flags);

Repeating myself, but I still don't get this; why not just protect all
accesses to the register pair and avoid this kind of error-prone stuff?

> 	netif_stop_queue(dev);
> 	printk(KERN_INFO "[%s Ethernet Driver, V%s]: Timeout!!\n", CARDNAME, DRV_VERSION); //JJ1
> 	dm9000_reset(db);
> 	dm9000_init_dm9000(dev);

So we can have that 40ms with interrupts off whenever a timeout occurs.

> 	/* We can accept TX packets again */
> 	dev->trans_start = jiffies;
> 	netif_wake_queue(dev);
> 
> 	/* Restore previous register address */
> 	writeb(reg_save, db->io_addr);
> 	spin_unlock_irqrestore(&db->lock, flags);
> }
> 
> /*
>  *  Hardware start transmission.
>  *  Send a packet to media from the upper layer.
>  */
> static int
> dm9000_start_xmit(struct sk_buff *skb, struct net_device *dev)
> {
> 	unsigned long flags;
> 	board_info_t *db = netdev_priv(dev);
> 
> 	dm9000_dbg(db, 3, "%s:\n", __func__);
> 
> 	if (db->tx_pkt_cnt > 1)
> 		return 1;
> 
> 	spin_lock_irqsave(&db->lock, flags);
> 
> 	/* Move data to DM9000 TX RAM */
> 	writeb(DM9000_MWCMD, db->io_addr);

So this time you don't save the address.  I'm glad somebody knows when that
needs to happen.

> 	(db->outblk)(db->io_data, skb->data, skb->len);
> 	dev->stats.tx_bytes += skb->len;
> 
> 	db->tx_pkt_cnt++;
> 	/* TX control: First packet immediately send, second packet queue */
> 	if (db->tx_pkt_cnt == 1) {
> 		/* Set TX length to DM9000 */
> 		iow(db, DM9000_TXPLL, skb->len);
> 		iow(db, DM9000_TXPLH, skb->len >> 8);
> 
> 		/* Issue TX polling command */
> 		iow(db, DM9000_TCR, TCR_TXREQ);	/* Cleared after TX complete */
> 
> 		dev->trans_start = jiffies;	/* save the time stamp */
> 	} else {
> 		/* Second packet */
> 		db->queue_pkt_len = skb->len;
> 		netif_stop_queue(dev);
> 	}
> 
> 	spin_unlock_irqrestore(&db->lock, flags);
> 
> 	/* free this SKB */
> 	dev_kfree_skb(skb);
> 
> 	return 0;
> }

[...]

> struct dm9000_rxhdr {
> 	u8	RxPktReady;
> 	u8	RxStatus;
> 	__le16	RxLen;
> } __attribute__((__packed__));

I'd put this at the top with the rest.

> /*
>  *  Received a packet and pass to upper layer
>  */
> static void
> dm9000_rx(struct net_device *dev)
> {
> 	board_info_t *db = netdev_priv(dev);
> 	struct dm9000_rxhdr rxhdr;
> 	struct sk_buff *skb;
> 	u8 rxbyte, *rdptr;
> 	bool GoodPacket;
> 	int RxLen;
> 
> 	/* Check packet ready or not */
> 	do {
> 		ior(db, DM9000_MRCMDX);	/* Dummy read */

Who has taken the spinlock to make this safe?

> 		/* Get most updated data */
> 		rxbyte = readb(db->io_data);

Who has set io_addr here?  Are you counting on that ior() call to do it?

> 		/* Status check: this byte must be 0 or 1 */
> 		if (rxbyte > DM9000_PKT_RDY) {
> 			dev_warn(db->dev, "status check fail: %d\n", rxbyte);
> 			iow(db, DM9000_RCR, 0x00);	/* Stop Device */
> 			iow(db, DM9000_ISR, IMR_PAR);	/* Stop INT request */
> 			return;
> 		}
> 
> 		if (rxbyte != DM9000_PKT_RDY)
> 			return;
> 
> 		/* A packet ready now  & Get status/length */
> 		GoodPacket = true;
> 		writeb(DM9000_MRCMD, db->io_addr);
> 
> 		(db->inblk)(db->io_data, &rxhdr, sizeof(rxhdr));
> 
> 		RxLen = le16_to_cpu(rxhdr.RxLen);
> 
> 		if (netif_msg_rx_status(db))
> 			dev_dbg(db->dev, "RX: status %02x, length %04x\n",
> 				rxhdr.RxStatus, RxLen);
> 
> 		/* Packet Status check */
> 		if (RxLen < 0x40) {
> 			GoodPacket = false;
> 			if (netif_msg_rx_err(db))
> 				dev_dbg(db->dev, "RX: Bad Packet (runt)\n");
> 		}
> 
> 		if (RxLen > DM9000_PKT_MAX) {
> 			dev_dbg(db->dev, "RST: RX Len:%x\n", RxLen);
> 		}

No brackets needed for single-line bodies

> 		/* rxhdr.RxStatus is identical to RSR register. */
> 		if (rxhdr.RxStatus & (RSR_FOE | RSR_CE | RSR_AE |
> 				      RSR_PLE | RSR_RWTO |
> 				      RSR_LCS | RSR_RF)) {
> 			GoodPacket = false;
> 			if (rxhdr.RxStatus & RSR_FOE) {
> 				if (netif_msg_rx_err(db))
> 					dev_dbg(db->dev, "fifo error\n");
> 				dev->stats.rx_fifo_errors++;
> 				printk(KERN_INFO "[%s Ethernet Driver, V%s]: FIFO Over Flow!!\n", CARDNAME, DRV_VERSION); //JJ1
> 			}
> 			if (rxhdr.RxStatus & RSR_CE) {
> 				if (netif_msg_rx_err(db))
> 					dev_dbg(db->dev, "crc error\n");
> 				dev->stats.rx_crc_errors++;
> 			}
> 			if (rxhdr.RxStatus & RSR_RF) {
> 				if (netif_msg_rx_err(db))
> 					dev_dbg(db->dev, "length error\n");
> 				dev->stats.rx_length_errors++;
> 			}
> 		}
> 
> 		/* Move data from DM9000 */
> 		if (GoodPacket
> 		    && ((skb = dev_alloc_skb(RxLen + 4)) != NULL)) {
> 			skb_reserve(skb, 2);
> 			rdptr = (u8 *) skb_put(skb, RxLen - 4);
> 
> 			/* Read received packet from RX SRAM */
> 
> 			(db->inblk)(db->io_data, rdptr, RxLen);
> 			dev->stats.rx_bytes += RxLen;
> 
> 			/* Pass to upper layer */
> 			skb->protocol = eth_type_trans(skb, dev);
> 			netif_rx(skb);
> 			dev->stats.rx_packets++;
> 
> 		} else {
> 			/* need to dump the packet's data */
> 
> 			(db->dumpblk)(db->io_data, RxLen);
> 		}
> 	} while (rxbyte == DM9000_PKT_RDY);
> }
> 
> static irqreturn_t dm9000_interrupt(int irq, void *dev_id)
> {
> 	struct net_device *dev = dev_id;
> 	board_info_t *db = netdev_priv(dev);
> 	int int_status;
> 	unsigned long flags;
> 	u8 reg_save;
> 
> 	dm9000_dbg(db, 3, "entering %s\n", __func__);
> 
> 	/* A real interrupt coming */
> 
> 	/* holders of db->lock must always block IRQs */

...and here is not the place to document that.

> 	spin_lock_irqsave(&db->lock, flags);
> 
> 	/* Save previous register address */
> 	reg_save = readb(db->io_addr);
> 
> 	/* Disable all interrupts */
> 	iow(db, DM9000_IMR, IMR_PAR);
> 
> 	/* Got DM9000 interrupt status */
> 	int_status = ior(db, DM9000_ISR);	/* Got ISR */
> 	iow(db, DM9000_ISR, int_status);	/* Clear ISR status */
> 
> 	if (netif_msg_intr(db))
> 		dev_dbg(db->dev, "interrupt status %02x\n", int_status);
> 
> 	/* Received the coming packet */
> 	if (int_status & ISR_PRS)
> 		dm9000_rx(dev);
> 
> 	/* Trnasmit Interrupt check */
> 	if (int_status & ISR_PTS)
> 		dm9000_tx_done(dev, db);
> 
> 	if (db->type != TYPE_DM9000E) {
> 		if (int_status & ISR_LNKCHNG) {
> 			/* fire a link-change request */
> 			schedule_delayed_work(&db->phy_poll, 1);
> 		}
> 	}
> 
> 	/* Re-enable interrupt mask */
> 	iow(db, DM9000_IMR, db->imr_all);
> 
> 	/* Restore previous register address */
> 	writeb(reg_save, db->io_addr);
> 
> 	 spin_unlock_irqrestore(&db->lock, flags);
> 
> 	return IRQ_HANDLED;

Did you ever check to see that the interrupt was actually from your device? 

> }

...and this is where I ran out of time, sorry.  Hope this much was helpful.

jon
