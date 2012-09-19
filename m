Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2ISGZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:25:46 -0400
Received: from davicom.com.tw ([202.39.11.22]:37220 "EHLO mail.davicom.com.tw"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755729Ab2ISGZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:25:43 -0400
X-Greylist: delayed 1654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Sep 2012 02:25:41 EDT
From: =?big5?B?QWxsZW4gSHVhbmcgKLbAsLau5ik=?= 
	<allen_huang@davicom.com.tw>
To: <linux-kernel@vger.kernel.org>
Cc: "'Michael Chen'" <michael_chen@mail.davicom.com.tw>,
        "'Charles'" <charles_tsai@davicom.com.tw>,
        "'Joseph Chang'" <joseph_chang@mail.davicom.com.tw>
Subject: Davicom DM9000C driver 
Date: Wed, 19 Sep 2012 13:58:08 +0800
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0011_01CD966E.CC5824B0"
X-Mailer: Microsoft Office Outlook, Build 11.0.5510
thread-index: Ac2Ulv6Ig5XUXgeGQRGhzYK7/f2cggBfInggAAAhx1AABFjYwA==
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5512
Message-Id: <20120919055333.3ECF95F94D@mail.davicom.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0011_01CD966E.CC5824B0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: 7bit

Hi,

I'm Allen Huang from Davicom. We are hereby opensourcing the linux
driver for our DM9000C. 

We would appreciate any comments that you have on our driver and
whether it is ready to go into the kernel. Please see DM9000C driver in the
attachment.

Best regards, 

Allen


------=_NextPart_000_0011_01CD966E.CC5824B0
Content-Type: application/octet-stream;
	name="dm9000_KT2.6.31.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dm9000_KT2.6.31.c"

/*=0A=
 *      Davicom DM9000 Fast Ethernet driver for Linux.=0A=
 * 	Copyright (C) 1997  Sten Wang=0A=
 *=0A=
 * 	This program is free software; you can redistribute it and/or=0A=
 * 	modify it under the terms of the GNU General Public License=0A=
 * 	as published by the Free Software Foundation; either version 2=0A=
 * 	of the License, or (at your option) any later version.=0A=
 *=0A=
 * 	This program is distributed in the hope that it will be useful,=0A=
 * 	but WITHOUT ANY WARRANTY; without even the implied warranty of=0A=
 * 	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the=0A=
 * 	GNU General Public License for more details.=0A=
 *=0A=
 * (C) Copyright 1997-1998 DAVICOM Semiconductor,Inc. All Rights =
Reserved.=0A=
 *=0A=
 * Additional updates, Copyright:=0A=
 *	Ben Dooks <ben@simtec.co.uk>=0A=
 *	Sascha Hauer <s.hauer@pengutronix.de>=0A=
 *  =0A=
 * 2010.07.20 V_R1 1.Write PHY Reg27 =3D 0xE100=0A=
 *								 2.Just enable PHY once after GPIO setting in =
dm9000_init_dm9000()=0A=
 *								 3.Remove power down PHY in dm9000_shutdown()=0A=
 * 2010.07.20 V_R2 1.Delay 20ms after PHY power on=0A=
 *								 2.Reset PHY after PHY power on in dm9000_init_dm9000()=0A=
 * 2012.06.05 KT2.6.31_R2 1. Add the solution to fix the power-on FIFO =
data bytes shift issue! (Wr NCR 0x03)=0A=
 */=0A=
=0A=
#include <linux/module.h>=0A=
#include <linux/ioport.h>=0A=
#include <linux/netdevice.h>=0A=
#include <linux/etherdevice.h>=0A=
#include <linux/init.h>=0A=
#include <linux/skbuff.h>=0A=
#include <linux/version.h>=0A=
#include <linux/spinlock.h>=0A=
#include <linux/crc32.h>=0A=
#include <linux/mii.h>=0A=
#include <linux/ethtool.h>=0A=
#include <linux/dm9000.h>=0A=
#include <linux/delay.h>=0A=
#include <linux/platform_device.h>=0A=
#include <linux/irq.h>=0A=
=0A=
#include <asm/delay.h>=0A=
#include <asm/irq.h>=0A=
#include <asm/io.h>=0A=
=0A=
#include "dm9000.h"=0A=
=0A=
/* Board/System/Debug information/definition ---------------- */=0A=
=0A=
#define DM9000_PHY		0x40	/* PHY address 0x01 */=0A=
=0A=
#define CARDNAME	"dm9000"=0A=
#define DRV_VERSION	"2.6.31"=0A=
=0A=
/*=0A=
 * Transmit timeout, default 5 seconds.=0A=
 */=0A=
static int watchdog =3D 5000;=0A=
module_param(watchdog, int, 0400);=0A=
MODULE_PARM_DESC(watchdog, "transmit timeout in milliseconds");=0A=
=0A=
/* DM9000 register address locking.=0A=
 *=0A=
 * The DM9000 uses an address register to control where data written=0A=
 * to the data register goes. This means that the address register=0A=
 * must be preserved over interrupts or similar calls.=0A=
 *=0A=
 * During interrupt and other critical calls, a spinlock is used to=0A=
 * protect the system, but the calls themselves save the address=0A=
 * in the address register in case they are interrupting another=0A=
 * access to the device.=0A=
 *=0A=
 * For general accesses a lock is provided so that calls which are=0A=
 * allowed to sleep are serialised so that the address register does=0A=
 * not need to be saved. This lock also serves to serialise access=0A=
 * to the EEPROM and PHY access registers which are shared between=0A=
 * these two devices.=0A=
 */=0A=
=0A=
/* The driver supports the original DM9000E, and now the two newer=0A=
 * devices, DM9000A and DM9000B.=0A=
 */=0A=
=0A=
enum dm9000_type {=0A=
	TYPE_DM9000E,	/* original DM9000 */=0A=
	TYPE_DM9000A,=0A=
	TYPE_DM9000B=0A=
};=0A=
=0A=
/* Structure/enum declaration ------------------------------- */=0A=
typedef struct board_info {=0A=
=0A=
	void __iomem	*io_addr;	/* Register I/O base address */=0A=
	void __iomem	*io_data;	/* Data I/O address */=0A=
	u16		 irq;		/* IRQ */=0A=
=0A=
	u16		tx_pkt_cnt;=0A=
	u16		queue_pkt_len;=0A=
	u16		queue_start_addr;=0A=
	u16		dbug_cnt;=0A=
	u8		io_mode;		/* 0:word, 2:byte */=0A=
	u8		phy_addr;=0A=
	u8		imr_all;=0A=
=0A=
	unsigned int	flags;=0A=
	unsigned int	in_suspend :1;=0A=
	int		debug_level;=0A=
=0A=
	enum dm9000_type type;=0A=
=0A=
	void (*inblk)(void __iomem *port, void *data, int length);=0A=
	void (*outblk)(void __iomem *port, void *data, int length);=0A=
	void (*dumpblk)(void __iomem *port, int length);=0A=
=0A=
	struct device	*dev;	     /* parent device */=0A=
=0A=
	struct resource	*addr_res;   /* resources found */=0A=
	struct resource *data_res;=0A=
	struct resource	*addr_req;   /* resources requested */=0A=
	struct resource *data_req;=0A=
	struct resource *irq_res;=0A=
=0A=
	struct mutex	 addr_lock;	/* phy and eeprom access lock */=0A=
=0A=
	struct delayed_work phy_poll;=0A=
	struct net_device  *ndev;=0A=
=0A=
	spinlock_t	lock;=0A=
=0A=
	struct mii_if_info mii;=0A=
	u32		msg_enable;=0A=
} board_info_t;=0A=
=0A=
static void=0A=
dm9000_phy_write(struct net_device *dev,=0A=
		 int phyaddr_unused, int reg, int value);=0A=
=0A=
/* debug code */=0A=
=0A=
#define dm9000_dbg(db, lev, msg...) do {		\=0A=
	if ((lev) < CONFIG_DM9000_DEBUGLEVEL &&		\=0A=
	    (lev) < db->debug_level) {			\=0A=
		dev_dbg(db->dev, msg);			\=0A=
	}						\=0A=
} while (0)=0A=
=0A=
static inline board_info_t *to_dm9000_board(struct net_device *dev)=0A=
{=0A=
	return netdev_priv(dev);=0A=
}=0A=
=0A=
/* DM9000 network board routine ---------------------------- */=0A=
=0A=
static void=0A=
dm9000_reset(board_info_t * db)=0A=
{=0A=
	dev_dbg(db->dev, "resetting device\n");=0A=
=0A=
	/* RESET device */=0A=
	writeb(DM9000_NCR, db->io_addr);=0A=
	udelay(200);=0A=
	writeb(NCR_RST, db->io_data);=0A=
	udelay(200);=0A=
}=0A=
=0A=
/*=0A=
 *   Read a byte from I/O port=0A=
 */=0A=
static u8=0A=
ior(board_info_t * db, int reg)=0A=
{=0A=
	writeb(reg, db->io_addr);=0A=
	return readb(db->io_data);=0A=
}=0A=
=0A=
/*=0A=
 *   Write a byte to I/O port=0A=
 */=0A=
=0A=
static void=0A=
iow(board_info_t * db, int reg, int value)=0A=
{=0A=
	writeb(reg, db->io_addr);=0A=
	writeb(value, db->io_data);=0A=
}=0A=
=0A=
/* routines for sending block to chip */=0A=
=0A=
static void dm9000_outblk_8bit(void __iomem *reg, void *data, int count)=0A=
{=0A=
	writesb(reg, data, count);=0A=
}=0A=
=0A=
static void dm9000_outblk_16bit(void __iomem *reg, void *data, int count)=0A=
{=0A=
	writesw(reg, data, (count+1) >> 1);=0A=
}=0A=
=0A=
static void dm9000_outblk_32bit(void __iomem *reg, void *data, int count)=0A=
{=0A=
	writesl(reg, data, (count+3) >> 2);=0A=
}=0A=
=0A=
/* input block from chip to memory */=0A=
=0A=
static void dm9000_inblk_8bit(void __iomem *reg, void *data, int count)=0A=
{=0A=
	readsb(reg, data, count);=0A=
}=0A=
=0A=
=0A=
static void dm9000_inblk_16bit(void __iomem *reg, void *data, int count)=0A=
{=0A=
	readsw(reg, data, (count+1) >> 1);=0A=
}=0A=
=0A=
static void dm9000_inblk_32bit(void __iomem *reg, void *data, int count)=0A=
{=0A=
	readsl(reg, data, (count+3) >> 2);=0A=
}=0A=
=0A=
/* dump block from chip to null */=0A=
=0A=
static void dm9000_dumpblk_8bit(void __iomem *reg, int count)=0A=
{=0A=
	int i;=0A=
	int tmp;=0A=
=0A=
	for (i =3D 0; i < count; i++)=0A=
		tmp =3D readb(reg);=0A=
}=0A=
=0A=
static void dm9000_dumpblk_16bit(void __iomem *reg, int count)=0A=
{=0A=
	int i;=0A=
	int tmp;=0A=
=0A=
	count =3D (count + 1) >> 1;=0A=
=0A=
	for (i =3D 0; i < count; i++)=0A=
		tmp =3D readw(reg);=0A=
}=0A=
=0A=
static void dm9000_dumpblk_32bit(void __iomem *reg, int count)=0A=
{=0A=
	int i;=0A=
	int tmp;=0A=
=0A=
	count =3D (count + 3) >> 2;=0A=
=0A=
	for (i =3D 0; i < count; i++)=0A=
		tmp =3D readl(reg);=0A=
}=0A=
=0A=
/* dm9000_set_io=0A=
 *=0A=
 * select the specified set of io routines to use with the=0A=
 * device=0A=
 */=0A=
=0A=
static void dm9000_set_io(struct board_info *db, int byte_width)=0A=
{=0A=
	/* use the size of the data resource to work out what IO=0A=
	 * routines we want to use=0A=
	 */=0A=
=0A=
	switch (byte_width) {=0A=
	case 1:=0A=
		db->dumpblk =3D dm9000_dumpblk_8bit;=0A=
		db->outblk  =3D dm9000_outblk_8bit;=0A=
		db->inblk   =3D dm9000_inblk_8bit;=0A=
		break;=0A=
=0A=
=0A=
	case 3:=0A=
		dev_dbg(db->dev, ": 3 byte IO, falling back to 16bit\n");=0A=
	case 2:=0A=
		db->dumpblk =3D dm9000_dumpblk_16bit;=0A=
		db->outblk  =3D dm9000_outblk_16bit;=0A=
		db->inblk   =3D dm9000_inblk_16bit;=0A=
		break;=0A=
=0A=
	case 4:=0A=
	default:=0A=
		db->dumpblk =3D dm9000_dumpblk_32bit;=0A=
		db->outblk  =3D dm9000_outblk_32bit;=0A=
		db->inblk   =3D dm9000_inblk_32bit;=0A=
		break;=0A=
	}=0A=
}=0A=
=0A=
static void dm9000_schedule_poll(board_info_t *db)=0A=
{=0A=
	if (db->type =3D=3D TYPE_DM9000E)=0A=
		schedule_delayed_work(&db->phy_poll, HZ * 2);=0A=
}=0A=
=0A=
static int dm9000_ioctl(struct net_device *dev, struct ifreq *req, int =
cmd)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
=0A=
	if (!netif_running(dev))=0A=
		return -EINVAL;=0A=
=0A=
	return generic_mii_ioctl(&dm->mii, if_mii(req), cmd, NULL);=0A=
}=0A=
=0A=
static unsigned int=0A=
dm9000_read_locked(board_info_t *db, int reg)=0A=
{=0A=
	unsigned long flags;=0A=
	unsigned int ret;=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
	ret =3D ior(db, reg);=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	return ret;=0A=
}=0A=
=0A=
static int dm9000_wait_eeprom(board_info_t *db)=0A=
{=0A=
	unsigned int status;=0A=
	int timeout =3D 8;	/* wait max 8msec */=0A=
=0A=
	/* The DM9000 data sheets say we should be able to=0A=
	 * poll the ERRE bit in EPCR to wait for the EEPROM=0A=
	 * operation. From testing several chips, this bit=0A=
	 * does not seem to work.=0A=
	 *=0A=
	 * We attempt to use the bit, but fall back to the=0A=
	 * timeout (which is why we do not return an error=0A=
	 * on expiry) to say that the EEPROM operation has=0A=
	 * completed.=0A=
	 */=0A=
=0A=
	while (1) {=0A=
		status =3D dm9000_read_locked(db, DM9000_EPCR);=0A=
=0A=
		if ((status & EPCR_ERRE) =3D=3D 0)=0A=
			break;=0A=
=0A=
		msleep(1);=0A=
=0A=
		if (timeout-- < 0) {=0A=
			dev_dbg(db->dev, "timeout waiting EEPROM\n");=0A=
			break;=0A=
		}=0A=
	}=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
/*=0A=
 *  Read a word data from EEPROM=0A=
 */=0A=
static void=0A=
dm9000_read_eeprom(board_info_t *db, int offset, u8 *to)=0A=
{=0A=
	unsigned long flags;=0A=
=0A=
	if (db->flags & DM9000_PLATF_NO_EEPROM) {=0A=
		to[0] =3D 0xff;=0A=
		to[1] =3D 0xff;=0A=
		return;=0A=
	}=0A=
=0A=
	mutex_lock(&db->addr_lock);=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
=0A=
	iow(db, DM9000_EPAR, offset);=0A=
	iow(db, DM9000_EPCR, EPCR_ERPRR);=0A=
=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	dm9000_wait_eeprom(db);=0A=
=0A=
	/* delay for at-least 150uS */=0A=
	msleep(1);=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
=0A=
	iow(db, DM9000_EPCR, 0x0);=0A=
=0A=
	to[0] =3D ior(db, DM9000_EPDRL);=0A=
	to[1] =3D ior(db, DM9000_EPDRH);=0A=
=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	mutex_unlock(&db->addr_lock);=0A=
}=0A=
=0A=
/*=0A=
 * Write a word data to SROM=0A=
 */=0A=
static void=0A=
dm9000_write_eeprom(board_info_t *db, int offset, u8 *data)=0A=
{=0A=
	unsigned long flags;=0A=
=0A=
	if (db->flags & DM9000_PLATF_NO_EEPROM)=0A=
		return;=0A=
=0A=
	mutex_lock(&db->addr_lock);=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
	iow(db, DM9000_EPAR, offset);=0A=
	iow(db, DM9000_EPDRH, data[1]);=0A=
	iow(db, DM9000_EPDRL, data[0]);=0A=
	iow(db, DM9000_EPCR, EPCR_WEP | EPCR_ERPRW);=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	dm9000_wait_eeprom(db);=0A=
=0A=
	mdelay(1);	/* wait at least 150uS to clear */=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
	iow(db, DM9000_EPCR, 0);=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	mutex_unlock(&db->addr_lock);=0A=
}=0A=
=0A=
/* ethtool ops */=0A=
=0A=
static void dm9000_get_drvinfo(struct net_device *dev,=0A=
			       struct ethtool_drvinfo *info)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
=0A=
	strcpy(info->driver, CARDNAME);=0A=
	strcpy(info->version, DRV_VERSION);=0A=
	strcpy(info->bus_info, to_platform_device(dm->dev)->name);=0A=
}=0A=
=0A=
static u32 dm9000_get_msglevel(struct net_device *dev)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
=0A=
	return dm->msg_enable;=0A=
}=0A=
=0A=
static void dm9000_set_msglevel(struct net_device *dev, u32 value)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
=0A=
	dm->msg_enable =3D value;=0A=
}=0A=
=0A=
static int dm9000_get_settings(struct net_device *dev, struct =
ethtool_cmd *cmd)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
=0A=
	mii_ethtool_gset(&dm->mii, cmd);=0A=
	return 0;=0A=
}=0A=
=0A=
static int dm9000_set_settings(struct net_device *dev, struct =
ethtool_cmd *cmd)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
=0A=
	return mii_ethtool_sset(&dm->mii, cmd);=0A=
}=0A=
=0A=
static int dm9000_nway_reset(struct net_device *dev)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
	return mii_nway_restart(&dm->mii);=0A=
}=0A=
=0A=
static u32 dm9000_get_link(struct net_device *dev)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
	u32 ret;=0A=
=0A=
	if (dm->flags & DM9000_PLATF_EXT_PHY)=0A=
		ret =3D mii_link_ok(&dm->mii);=0A=
	else=0A=
		ret =3D dm9000_read_locked(dm, DM9000_NSR) & NSR_LINKST ? 1 : 0;=0A=
=0A=
	return ret;=0A=
}=0A=
=0A=
#define DM_EEPROM_MAGIC		(0x444D394B)=0A=
=0A=
static int dm9000_get_eeprom_len(struct net_device *dev)=0A=
{=0A=
	return 128;=0A=
}=0A=
=0A=
static int dm9000_get_eeprom(struct net_device *dev,=0A=
			     struct ethtool_eeprom *ee, u8 *data)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
	int offset =3D ee->offset;=0A=
	int len =3D ee->len;=0A=
	int i;=0A=
=0A=
	/* EEPROM access is aligned to two bytes */=0A=
=0A=
	if ((len & 1) !=3D 0 || (offset & 1) !=3D 0)=0A=
		return -EINVAL;=0A=
=0A=
	if (dm->flags & DM9000_PLATF_NO_EEPROM)=0A=
		return -ENOENT;=0A=
=0A=
	ee->magic =3D DM_EEPROM_MAGIC;=0A=
=0A=
	for (i =3D 0; i < len; i +=3D 2)=0A=
		dm9000_read_eeprom(dm, (offset + i) / 2, data + i);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static int dm9000_set_eeprom(struct net_device *dev,=0A=
			     struct ethtool_eeprom *ee, u8 *data)=0A=
{=0A=
	board_info_t *dm =3D to_dm9000_board(dev);=0A=
	int offset =3D ee->offset;=0A=
	int len =3D ee->len;=0A=
	int i;=0A=
=0A=
	/* EEPROM access is aligned to two bytes */=0A=
=0A=
	if ((len & 1) !=3D 0 || (offset & 1) !=3D 0)=0A=
		return -EINVAL;=0A=
=0A=
	if (dm->flags & DM9000_PLATF_NO_EEPROM)=0A=
		return -ENOENT;=0A=
=0A=
	if (ee->magic !=3D DM_EEPROM_MAGIC)=0A=
		return -EINVAL;=0A=
=0A=
	for (i =3D 0; i < len; i +=3D 2)=0A=
		dm9000_write_eeprom(dm, (offset + i) / 2, data + i);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
static const struct ethtool_ops dm9000_ethtool_ops =3D {=0A=
	.get_drvinfo		=3D dm9000_get_drvinfo,=0A=
	.get_settings		=3D dm9000_get_settings,=0A=
	.set_settings		=3D dm9000_set_settings,=0A=
	.get_msglevel		=3D dm9000_get_msglevel,=0A=
	.set_msglevel		=3D dm9000_set_msglevel,=0A=
	.nway_reset		=3D dm9000_nway_reset,=0A=
	.get_link		=3D dm9000_get_link,=0A=
 	.get_eeprom_len		=3D dm9000_get_eeprom_len,=0A=
 	.get_eeprom		=3D dm9000_get_eeprom,=0A=
 	.set_eeprom		=3D dm9000_set_eeprom,=0A=
};=0A=
=0A=
static void dm9000_show_carrier(board_info_t *db,=0A=
				unsigned carrier, unsigned nsr)=0A=
{=0A=
	struct net_device *ndev =3D db->ndev;=0A=
	unsigned ncr =3D dm9000_read_locked(db, DM9000_NCR);=0A=
=0A=
	if (carrier)=0A=
		dev_info(db->dev, "%s: link up, %dMbps, %s-duplex, no LPA\n",=0A=
			 ndev->name, (nsr & NSR_SPEED) ? 10 : 100,=0A=
			 (ncr & NCR_FDX) ? "full" : "half");=0A=
	else=0A=
		dev_info(db->dev, "%s: link down\n", ndev->name);=0A=
}=0A=
=0A=
=0A=
static unsigned char dm9000_type_to_char(enum dm9000_type type)=0A=
{=0A=
	switch (type) {=0A=
	case TYPE_DM9000E: return 'e';=0A=
	case TYPE_DM9000A: return 'a';=0A=
	case TYPE_DM9000B: return 'b';=0A=
	}=0A=
=0A=
	return '?';=0A=
}=0A=
=0A=
static void=0A=
dm9000_poll_work(struct work_struct *w)=0A=
{=0A=
	struct delayed_work *dw =3D container_of(w, struct delayed_work, work);=0A=
	board_info_t *db =3D container_of(dw, board_info_t, phy_poll);=0A=
	struct net_device *ndev =3D db->ndev;=0A=
=0A=
//JJ2=0A=
//	if (db->flags & DM9000_PLATF_SIMPLE_PHY &&=0A=
//	    !(db->flags & DM9000_PLATF_EXT_PHY)) {=0A=
//  =3D=0A=
		if(1){						=0A=
		unsigned nsr =3D dm9000_read_locked(db, DM9000_NSR);=0A=
		unsigned old_carrier =3D netif_carrier_ok(ndev) ? 1 : 0;=0A=
		unsigned new_carrier;=0A=
=0A=
		new_carrier =3D (nsr & NSR_LINKST) ? 1 : 0;=0A=
=0A=
		if (old_carrier !=3D new_carrier) {=0A=
			=0A=
			if (new_carrier)=0A=
			  printk(KERN_INFO "[dm9000%c %s Ethernet Driver, V%s]: =
Link-Up!!\n",dm9000_type_to_char(db->type), CARDNAME, DRV_VERSION); //JJ2=0A=
			else=0A=
			  printk(KERN_INFO "[%s Ethernet Driver, V%s]: Link-Down!!\n", =
CARDNAME, DRV_VERSION); //JJ2=0A=
			=0A=
			if (netif_msg_link(db))=0A=
				dm9000_show_carrier(db, new_carrier, nsr);=0A=
=0A=
			if (!new_carrier)=0A=
				netif_carrier_off(ndev);=0A=
			else=0A=
				netif_carrier_on(ndev);=0A=
		}=0A=
	} else=0A=
		mii_check_media(&db->mii, netif_msg_link(db), 0);=0A=
	=0A=
	if (netif_running(ndev))=0A=
		dm9000_schedule_poll(db);=0A=
}=0A=
=0A=
/* dm9000_release_board=0A=
 *=0A=
 * release a board, and any mapped resources=0A=
 */=0A=
=0A=
static void=0A=
dm9000_release_board(struct platform_device *pdev, struct board_info *db)=0A=
{=0A=
	/* unmap our resources */=0A=
=0A=
	iounmap(db->io_addr);=0A=
	iounmap(db->io_data);=0A=
=0A=
	/* release the resources */=0A=
=0A=
	release_resource(db->data_req);=0A=
	kfree(db->data_req);=0A=
=0A=
	release_resource(db->addr_req);=0A=
	kfree(db->addr_req);=0A=
}=0A=
=0A=
=0A=
=0A=
/*=0A=
 *  Set DM9000 multicast address=0A=
 */=0A=
static void=0A=
dm9000_hash_table(struct net_device *dev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	struct dev_mc_list *mcptr =3D dev->mc_list;=0A=
	int mc_cnt =3D dev->mc_count;=0A=
	int i, oft;=0A=
	u32 hash_val;=0A=
	u16 hash_table[4];=0A=
	u8 rcr =3D RCR_DIS_LONG | RCR_DIS_CRC | RCR_RXEN;=0A=
	unsigned long flags;=0A=
=0A=
	dm9000_dbg(db, 1, "entering %s\n", __func__);=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
=0A=
	for (i =3D 0, oft =3D DM9000_PAR; i < 6; i++, oft++)=0A=
		iow(db, oft, dev->dev_addr[i]);=0A=
=0A=
	/* Clear Hash Table */=0A=
	for (i =3D 0; i < 4; i++)=0A=
		hash_table[i] =3D 0x0;=0A=
=0A=
	/* broadcast address */=0A=
	hash_table[3] =3D 0x8000;=0A=
=0A=
	if (dev->flags & IFF_PROMISC)=0A=
		rcr |=3D RCR_PRMSC;=0A=
=0A=
	if (dev->flags & IFF_ALLMULTI)=0A=
		rcr |=3D RCR_ALL;=0A=
=0A=
	/* the multicast address in Hash Table : 64 bits */=0A=
	for (i =3D 0; i < mc_cnt; i++, mcptr =3D mcptr->next) {=0A=
		hash_val =3D ether_crc_le(6, mcptr->dmi_addr) & 0x3f;=0A=
		hash_table[hash_val / 16] |=3D (u16) 1 << (hash_val % 16);=0A=
	}=0A=
=0A=
	/* Write the hash table to MAC MD table */=0A=
	for (i =3D 0, oft =3D DM9000_MAR; i < 4; i++) {=0A=
		iow(db, oft++, hash_table[i]);=0A=
		iow(db, oft++, hash_table[i] >> 8);=0A=
	}=0A=
=0A=
	iow(db, DM9000_RCR, rcr);=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
}=0A=
=0A=
/*=0A=
 * Initilize dm9000 board=0A=
 */=0A=
static void=0A=
dm9000_init_dm9000(struct net_device *dev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	unsigned int imr;=0A=
=0A=
	dm9000_dbg(db, 1, "entering %s\n", __func__);=0A=
=0A=
	/* I/O mode */=0A=
	db->io_mode =3D ior(db, DM9000_ISR) >> 6;	/* ISR bit7:6 keeps I/O mode =
*/=0A=
=0A=
	/* GPIO0 on pre-activate PHY */=0A=
//V_R1	iow(db, DM9000_GPR, 0);	/* REG_1F bit0 activate phyxcer */=0A=
	iow(db, DM9000_GPCR, GPCR_GEP_CNTL);	/* Let GPIO0 output */=0A=
	iow(db, DM9000_GPR, 0);	/* Enable PHY */=0A=
        mdelay(20);  //V_R2=0A=
=0A=
	dm9000_phy_write(dev, 0, 0, 0x8000); //V_R2 reset PHY=0A=
        mdelay (20);=0A=
=0A=
=0A=
//	if (db->flags & DM9000_PLATF_EXT_PHY)=0A=
//		iow(db, DM9000_NCR, NCR_EXT_PHY);=0A=
=0A=
	/* Program operating register */=0A=
	iow(db, DM9000_TCR, 0);	        /* TX Polling clear */=0A=
	iow(db, DM9000_BPTR, 0x3f);	/* Less 3Kb, 200us */=0A=
	iow(db, DM9000_FCR, 0xff);	/* Flow Control */=0A=
	iow(db, DM9000_SMCR, 0);        /* Special Mode */=0A=
	/* clear TX status */=0A=
	iow(db, DM9000_NSR, NSR_WAKEST | NSR_TX2END | NSR_TX1END);=0A=
	iow(db, DM9000_ISR, ISR_CLR_STATUS); /* Clear interrupt status */=0A=
=0A=
	/* Set address filter table */=0A=
	dm9000_hash_table(dev);=0A=
=0A=
	imr =3D IMR_PAR | IMR_PTM | IMR_PRM;=0A=
	if (db->type !=3D TYPE_DM9000E)=0A=
		imr |=3D IMR_LNKCHNG;=0A=
=0A=
	db->imr_all =3D imr;=0A=
=0A=
	/* Enable TX/RX interrupt mask */=0A=
	iow(db, DM9000_IMR, imr);=0A=
=0A=
	/* Init Driver variable */=0A=
	db->tx_pkt_cnt =3D 0;=0A=
	db->queue_pkt_len =3D 0;=0A=
	dev->trans_start =3D 0;=0A=
	=0A=
	dm9000_phy_write(dev, 0, 27, 0xE100); //V_R1=0A=
}=0A=
=0A=
/* Our watchdog timed out. Called by the networking layer */=0A=
static void dm9000_timeout(struct net_device *dev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	u8 reg_save;=0A=
	unsigned long flags;=0A=
=0A=
	/* Save previous register address */=0A=
	reg_save =3D readb(db->io_addr);=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
=0A=
	netif_stop_queue(dev);=0A=
	printk(KERN_INFO "[%s Ethernet Driver, V%s]: Timeout!!\n", CARDNAME, =
DRV_VERSION); //JJ1=0A=
	dm9000_reset(db);=0A=
	dm9000_init_dm9000(dev);=0A=
	/* We can accept TX packets again */=0A=
	dev->trans_start =3D jiffies;=0A=
	netif_wake_queue(dev);=0A=
=0A=
	/* Restore previous register address */=0A=
	writeb(reg_save, db->io_addr);=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
}=0A=
=0A=
/*=0A=
 *  Hardware start transmission.=0A=
 *  Send a packet to media from the upper layer.=0A=
 */=0A=
static int=0A=
dm9000_start_xmit(struct sk_buff *skb, struct net_device *dev)=0A=
{=0A=
	unsigned long flags;=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
=0A=
	dm9000_dbg(db, 3, "%s:\n", __func__);=0A=
=0A=
	if (db->tx_pkt_cnt > 1)=0A=
		return 1;=0A=
=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
=0A=
	/* Move data to DM9000 TX RAM */=0A=
	writeb(DM9000_MWCMD, db->io_addr);=0A=
=0A=
	(db->outblk)(db->io_data, skb->data, skb->len);=0A=
	dev->stats.tx_bytes +=3D skb->len;=0A=
=0A=
	db->tx_pkt_cnt++;=0A=
	/* TX control: First packet immediately send, second packet queue */=0A=
	if (db->tx_pkt_cnt =3D=3D 1) {=0A=
		/* Set TX length to DM9000 */=0A=
		iow(db, DM9000_TXPLL, skb->len);=0A=
		iow(db, DM9000_TXPLH, skb->len >> 8);=0A=
=0A=
		/* Issue TX polling command */=0A=
		iow(db, DM9000_TCR, TCR_TXREQ);	/* Cleared after TX complete */=0A=
=0A=
		dev->trans_start =3D jiffies;	/* save the time stamp */=0A=
	} else {=0A=
		/* Second packet */=0A=
		db->queue_pkt_len =3D skb->len;=0A=
		netif_stop_queue(dev);=0A=
	}=0A=
=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	/* free this SKB */=0A=
	dev_kfree_skb(skb);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
/*=0A=
 * DM9000 interrupt handler=0A=
 * receive the packet to upper layer, free the transmitted packet=0A=
 */=0A=
=0A=
static void dm9000_tx_done(struct net_device *dev, board_info_t *db)=0A=
{=0A=
	int tx_status =3D ior(db, DM9000_NSR);	/* Got TX status */=0A=
=0A=
	if (tx_status & (NSR_TX2END | NSR_TX1END)) {=0A=
		/* One packet sent complete */=0A=
		db->tx_pkt_cnt--;=0A=
		dev->stats.tx_packets++;=0A=
=0A=
		if (netif_msg_tx_done(db))=0A=
			dev_dbg(db->dev, "tx done, NSR %02x\n", tx_status);=0A=
=0A=
		/* Queue packet check & send */=0A=
		if (db->tx_pkt_cnt > 0) {=0A=
			iow(db, DM9000_TXPLL, db->queue_pkt_len);=0A=
			iow(db, DM9000_TXPLH, db->queue_pkt_len >> 8);=0A=
			iow(db, DM9000_TCR, TCR_TXREQ);=0A=
			dev->trans_start =3D jiffies;=0A=
		}=0A=
		netif_wake_queue(dev);=0A=
	}=0A=
}=0A=
=0A=
struct dm9000_rxhdr {=0A=
	u8	RxPktReady;=0A=
	u8	RxStatus;=0A=
	__le16	RxLen;=0A=
} __attribute__((__packed__));=0A=
=0A=
/*=0A=
 *  Received a packet and pass to upper layer=0A=
 */=0A=
static void=0A=
dm9000_rx(struct net_device *dev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	struct dm9000_rxhdr rxhdr;=0A=
	struct sk_buff *skb;=0A=
	u8 rxbyte, *rdptr;=0A=
	bool GoodPacket;=0A=
	int RxLen;=0A=
=0A=
	/* Check packet ready or not */=0A=
	do {=0A=
		ior(db, DM9000_MRCMDX);	/* Dummy read */=0A=
=0A=
		/* Get most updated data */=0A=
		rxbyte =3D readb(db->io_data);=0A=
=0A=
		/* Status check: this byte must be 0 or 1 */=0A=
		if (rxbyte > DM9000_PKT_RDY) {=0A=
			dev_warn(db->dev, "status check fail: %d\n", rxbyte);=0A=
			iow(db, DM9000_RCR, 0x00);	/* Stop Device */=0A=
			iow(db, DM9000_ISR, IMR_PAR);	/* Stop INT request */=0A=
			return;=0A=
		}=0A=
=0A=
		if (rxbyte !=3D DM9000_PKT_RDY)=0A=
			return;=0A=
=0A=
		/* A packet ready now  & Get status/length */=0A=
		GoodPacket =3D true;=0A=
		writeb(DM9000_MRCMD, db->io_addr);=0A=
=0A=
		(db->inblk)(db->io_data, &rxhdr, sizeof(rxhdr));=0A=
=0A=
		RxLen =3D le16_to_cpu(rxhdr.RxLen);=0A=
=0A=
		if (netif_msg_rx_status(db))=0A=
			dev_dbg(db->dev, "RX: status %02x, length %04x\n",=0A=
				rxhdr.RxStatus, RxLen);=0A=
=0A=
		/* Packet Status check */=0A=
		if (RxLen < 0x40) {=0A=
			GoodPacket =3D false;=0A=
			if (netif_msg_rx_err(db))=0A=
				dev_dbg(db->dev, "RX: Bad Packet (runt)\n");=0A=
		}=0A=
=0A=
		if (RxLen > DM9000_PKT_MAX) {=0A=
			dev_dbg(db->dev, "RST: RX Len:%x\n", RxLen);=0A=
		}=0A=
=0A=
		/* rxhdr.RxStatus is identical to RSR register. */=0A=
		if (rxhdr.RxStatus & (RSR_FOE | RSR_CE | RSR_AE |=0A=
				      RSR_PLE | RSR_RWTO |=0A=
				      RSR_LCS | RSR_RF)) {=0A=
			GoodPacket =3D false;=0A=
			if (rxhdr.RxStatus & RSR_FOE) {=0A=
				if (netif_msg_rx_err(db))=0A=
					dev_dbg(db->dev, "fifo error\n");=0A=
				dev->stats.rx_fifo_errors++;=0A=
				printk(KERN_INFO "[%s Ethernet Driver, V%s]: FIFO Over Flow!!\n", =
CARDNAME, DRV_VERSION); //JJ1=0A=
			}=0A=
			if (rxhdr.RxStatus & RSR_CE) {=0A=
				if (netif_msg_rx_err(db))=0A=
					dev_dbg(db->dev, "crc error\n");=0A=
				dev->stats.rx_crc_errors++;=0A=
			}=0A=
			if (rxhdr.RxStatus & RSR_RF) {=0A=
				if (netif_msg_rx_err(db))=0A=
					dev_dbg(db->dev, "length error\n");=0A=
				dev->stats.rx_length_errors++;=0A=
			}=0A=
		}=0A=
=0A=
		/* Move data from DM9000 */=0A=
		if (GoodPacket=0A=
		    && ((skb =3D dev_alloc_skb(RxLen + 4)) !=3D NULL)) {=0A=
			skb_reserve(skb, 2);=0A=
			rdptr =3D (u8 *) skb_put(skb, RxLen - 4);=0A=
=0A=
			/* Read received packet from RX SRAM */=0A=
=0A=
			(db->inblk)(db->io_data, rdptr, RxLen);=0A=
			dev->stats.rx_bytes +=3D RxLen;=0A=
=0A=
			/* Pass to upper layer */=0A=
			skb->protocol =3D eth_type_trans(skb, dev);=0A=
			netif_rx(skb);=0A=
			dev->stats.rx_packets++;=0A=
=0A=
		} else {=0A=
			/* need to dump the packet's data */=0A=
=0A=
			(db->dumpblk)(db->io_data, RxLen);=0A=
		}=0A=
	} while (rxbyte =3D=3D DM9000_PKT_RDY);=0A=
}=0A=
=0A=
static irqreturn_t dm9000_interrupt(int irq, void *dev_id)=0A=
{=0A=
	struct net_device *dev =3D dev_id;=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	int int_status;=0A=
	unsigned long flags;=0A=
	u8 reg_save;=0A=
=0A=
	dm9000_dbg(db, 3, "entering %s\n", __func__);=0A=
=0A=
	/* A real interrupt coming */=0A=
=0A=
	/* holders of db->lock must always block IRQs */=0A=
	spin_lock_irqsave(&db->lock, flags);=0A=
=0A=
	/* Save previous register address */=0A=
	reg_save =3D readb(db->io_addr);=0A=
=0A=
	/* Disable all interrupts */=0A=
	iow(db, DM9000_IMR, IMR_PAR);=0A=
=0A=
	/* Got DM9000 interrupt status */=0A=
	int_status =3D ior(db, DM9000_ISR);	/* Got ISR */=0A=
	iow(db, DM9000_ISR, int_status);	/* Clear ISR status */=0A=
=0A=
	if (netif_msg_intr(db))=0A=
		dev_dbg(db->dev, "interrupt status %02x\n", int_status);=0A=
=0A=
	/* Received the coming packet */=0A=
	if (int_status & ISR_PRS)=0A=
		dm9000_rx(dev);=0A=
=0A=
	/* Trnasmit Interrupt check */=0A=
	if (int_status & ISR_PTS)=0A=
		dm9000_tx_done(dev, db);=0A=
=0A=
	if (db->type !=3D TYPE_DM9000E) {=0A=
		if (int_status & ISR_LNKCHNG) {=0A=
			/* fire a link-change request */=0A=
			schedule_delayed_work(&db->phy_poll, 1);=0A=
		}=0A=
	}=0A=
=0A=
	/* Re-enable interrupt mask */=0A=
	iow(db, DM9000_IMR, db->imr_all);=0A=
=0A=
	/* Restore previous register address */=0A=
	writeb(reg_save, db->io_addr);=0A=
=0A=
	 spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	return IRQ_HANDLED;=0A=
}=0A=
=0A=
#ifdef CONFIG_NET_POLL_CONTROLLER=0A=
/*=0A=
 *Used by netconsole=0A=
 */=0A=
static void dm9000_poll_controller(struct net_device *dev)=0A=
{=0A=
	disable_irq(dev->irq);=0A=
	dm9000_interrupt(dev->irq, dev);=0A=
	enable_irq(dev->irq);=0A=
}=0A=
#endif=0A=
=0A=
/*=0A=
 *  Open the interface.=0A=
 *  The interface is opened whenever "ifconfig" actives it.=0A=
 */=0A=
static int=0A=
dm9000_open(struct net_device *dev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	unsigned long irqflags =3D db->irq_res->flags & IRQF_TRIGGER_MASK;=0A=
=0A=
	if (netif_msg_ifup(db))=0A=
		dev_dbg(db->dev, "enabling %s\n", dev->name);=0A=
=0A=
	/* If there is no IRQ type specified, default to something that=0A=
	 * may work, and tell the user that this is a problem */=0A=
=0A=
	if (irqflags =3D=3D IRQF_TRIGGER_NONE)=0A=
		dev_warn(db->dev, "WARNING: no IRQ resource flags set.\n");=0A=
=0A=
	irqflags |=3D IRQF_SHARED;=0A=
=0A=
	if (request_irq(dev->irq, &dm9000_interrupt, irqflags, dev->name, dev))=0A=
		return -EAGAIN;=0A=
=0A=
	/* Initialize DM9000 board */=0A=
	dm9000_reset(db);=0A=
	dm9000_init_dm9000(dev);=0A=
=0A=
	/* Init driver variable */=0A=
	db->dbug_cnt =3D 0;=0A=
=0A=
	mii_check_media(&db->mii, netif_msg_link(db), 1);=0A=
	netif_start_queue(dev);=0A=
	=0A=
	dm9000_schedule_poll(db);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
/*=0A=
 * Sleep, either by using msleep() or if we are suspending, then=0A=
 * use mdelay() to sleep.=0A=
 */=0A=
static void dm9000_msleep(board_info_t *db, unsigned int ms)=0A=
{=0A=
	if (db->in_suspend)=0A=
		mdelay(ms);=0A=
	else=0A=
		msleep(ms);=0A=
}=0A=
=0A=
/*=0A=
 *   Read a word from phyxcer=0A=
 */=0A=
static int=0A=
dm9000_phy_read(struct net_device *dev, int phy_reg_unused, int reg)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	unsigned long flags;=0A=
	unsigned int reg_save;=0A=
	int ret;=0A=
=0A=
	mutex_lock(&db->addr_lock);=0A=
=0A=
	spin_lock_irqsave(&db->lock,flags);=0A=
=0A=
	/* Save previous register address */=0A=
	reg_save =3D readb(db->io_addr);=0A=
=0A=
	/* Fill the phyxcer register into REG_0C */=0A=
	iow(db, DM9000_EPAR, DM9000_PHY | reg);=0A=
=0A=
	iow(db, DM9000_EPCR, EPCR_ERPRR | EPCR_EPOS);	/* Issue phyxcer read =
command */=0A=
=0A=
	writeb(reg_save, db->io_addr);=0A=
	spin_unlock_irqrestore(&db->lock,flags);=0A=
=0A=
	dm9000_msleep(db, 1);		/* Wait read complete */=0A=
=0A=
	spin_lock_irqsave(&db->lock,flags);=0A=
	reg_save =3D readb(db->io_addr);=0A=
=0A=
	iow(db, DM9000_EPCR, 0x0);	/* Clear phyxcer read command */=0A=
=0A=
	/* The read data keeps on REG_0D & REG_0E */=0A=
	ret =3D (ior(db, DM9000_EPDRH) << 8) | ior(db, DM9000_EPDRL);=0A=
=0A=
	/* restore the previous address */=0A=
	writeb(reg_save, db->io_addr);=0A=
	spin_unlock_irqrestore(&db->lock,flags);=0A=
=0A=
	mutex_unlock(&db->addr_lock);=0A=
=0A=
	dm9000_dbg(db, 5, "phy_read[%02x] -> %04x\n", reg, ret);=0A=
	return ret;=0A=
}=0A=
=0A=
/*=0A=
 *   Write a word to phyxcer=0A=
 */=0A=
static void=0A=
dm9000_phy_write(struct net_device *dev,=0A=
		 int phyaddr_unused, int reg, int value)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
	unsigned long flags;=0A=
	unsigned long reg_save;=0A=
=0A=
	dm9000_dbg(db, 5, "phy_write[%02x] =3D %04x\n", reg, value);=0A=
	mutex_lock(&db->addr_lock);=0A=
=0A=
	spin_lock_irqsave(&db->lock,flags);=0A=
=0A=
	/* Save previous register address */=0A=
	reg_save =3D readb(db->io_addr);=0A=
=0A=
	/* Fill the phyxcer register into REG_0C */=0A=
	iow(db, DM9000_EPAR, DM9000_PHY | reg);=0A=
=0A=
	/* Fill the written data into REG_0D & REG_0E */=0A=
	iow(db, DM9000_EPDRL, value);=0A=
	iow(db, DM9000_EPDRH, value >> 8);=0A=
=0A=
	iow(db, DM9000_EPCR, EPCR_EPOS | EPCR_ERPRW);	/* Issue phyxcer write =
command */=0A=
=0A=
	writeb(reg_save, db->io_addr);=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
=0A=
	dm9000_msleep(db, 1);		/* Wait write complete */=0A=
=0A=
	spin_lock_irqsave(&db->lock,flags);=0A=
	reg_save =3D readb(db->io_addr);=0A=
=0A=
	iow(db, DM9000_EPCR, 0x0);	/* Clear phyxcer write command */=0A=
=0A=
	/* restore the previous address */=0A=
	writeb(reg_save, db->io_addr);=0A=
=0A=
	spin_unlock_irqrestore(&db->lock, flags);=0A=
	mutex_unlock(&db->addr_lock);=0A=
}=0A=
=0A=
static void=0A=
dm9000_shutdown(struct net_device *dev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(dev);=0A=
=0A=
	/* RESET device */=0A=
	dm9000_phy_write(dev, 0, MII_BMCR, BMCR_RESET);	/* PHY RESET */=0A=
//V_R1	iow(db, DM9000_GPR, 0x01);	/* Power-Down PHY */=0A=
	iow(db, DM9000_IMR, IMR_PAR);	/* Disable all interrupt */=0A=
	iow(db, DM9000_RCR, 0x00);	/* Disable RX */=0A=
}=0A=
=0A=
/*=0A=
 * Stop the interface.=0A=
 * The interface is stopped when it is brought.=0A=
 */=0A=
static int=0A=
dm9000_stop(struct net_device *ndev)=0A=
{=0A=
	board_info_t *db =3D netdev_priv(ndev);=0A=
=0A=
	if (netif_msg_ifdown(db))=0A=
		dev_dbg(db->dev, "shutting down %s\n", ndev->name);=0A=
=0A=
	cancel_delayed_work_sync(&db->phy_poll);=0A=
=0A=
	netif_stop_queue(ndev);=0A=
	netif_carrier_off(ndev);=0A=
=0A=
	/* free interrupt */=0A=
	free_irq(ndev->irq, ndev);=0A=
=0A=
	dm9000_shutdown(ndev);=0A=
=0A=
	return 0;=0A=
}=0A=
=0A=
#define res_size(_r) (((_r)->end - (_r)->start) + 1)=0A=
=0A=
static const struct net_device_ops dm9000_netdev_ops =3D {=0A=
         .ndo_open =3D dm9000_open,=0A=
         .ndo_stop =3D dm9000_stop,=0A=
         .ndo_start_xmit =3D dm9000_start_xmit,=0A=
         .ndo_tx_timeout =3D dm9000_timeout,=0A=
         .ndo_set_multicast_list =3D dm9000_hash_table,=0A=
         .ndo_do_ioctl =3D dm9000_ioctl,=0A=
         .ndo_change_mtu =3D eth_change_mtu,=0A=
         .ndo_validate_addr =3D eth_validate_addr,=0A=
         .ndo_set_mac_address =3D eth_mac_addr,=0A=
    #ifdef CONFIG_NET_POLL_CONTROLLER=0A=
         .ndo_poll_controller =3D dm9000_poll_controller,=0A=
    #endif=0A=
};=0A=
=0A=
=0A=
/*=0A=
 * Search DM9000 board, allocate space and register it=0A=
 */=0A=
static int __devinit=0A=
dm9000_probe(struct platform_device *pdev)=0A=
{=0A=
	struct dm9000_plat_data *pdata =3D pdev->dev.platform_data;=0A=
	struct board_info *db;	/* Point a board information structure */=0A=
	struct net_device *ndev;=0A=
	const unsigned char *mac_src;=0A=
	int ret =3D 0;=0A=
	int iosize;=0A=
	int i;=0A=
	u32 id_val;=0A=
=0A=
	/* Init network device */=0A=
	ndev =3D alloc_etherdev(sizeof(struct board_info));=0A=
	if (!ndev) {=0A=
		dev_err(&pdev->dev, "could not allocate device.\n");=0A=
		return -ENOMEM;=0A=
	}=0A=
=0A=
	SET_NETDEV_DEV(ndev, &pdev->dev);=0A=
=0A=
	dev_dbg(&pdev->dev, "dm9000_probe()\n");=0A=
	 ndev->netdev_ops =3D &dm9000_netdev_ops;=0A=
	/* setup board info structure */=0A=
	db =3D netdev_priv(ndev);=0A=
	memset(db, 0, sizeof(*db));=0A=
=0A=
	db->dev =3D &pdev->dev;=0A=
	db->ndev =3D ndev;=0A=
=0A=
	spin_lock_init(&db->lock);=0A=
	mutex_init(&db->addr_lock);=0A=
=0A=
	INIT_DELAYED_WORK(&db->phy_poll, dm9000_poll_work);=0A=
=0A=
	db->addr_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);=0A=
	db->data_res =3D platform_get_resource(pdev, IORESOURCE_MEM, 1);=0A=
	db->irq_res  =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);=0A=
=0A=
	if (db->addr_res =3D=3D NULL || db->data_res =3D=3D NULL ||=0A=
	    db->irq_res =3D=3D NULL) {=0A=
		dev_err(db->dev, "insufficient resources\n");=0A=
		ret =3D -ENOENT;=0A=
		goto out;=0A=
	}=0A=
=0A=
	iosize =3D res_size(db->addr_res);=0A=
	db->addr_req =3D request_mem_region(db->addr_res->start, iosize,=0A=
					  pdev->name);=0A=
=0A=
	if (db->addr_req =3D=3D NULL) {=0A=
		dev_err(db->dev, "cannot claim address reg area\n");=0A=
		ret =3D -EIO;=0A=
		goto out;=0A=
	}=0A=
=0A=
	db->io_addr =3D ioremap(db->addr_res->start, iosize);=0A=
=0A=
	if (db->io_addr =3D=3D NULL) {=0A=
		dev_err(db->dev, "failed to ioremap address reg\n");=0A=
		ret =3D -EINVAL;=0A=
		goto out;=0A=
	}=0A=
=0A=
	iosize =3D res_size(db->data_res);=0A=
	db->data_req =3D request_mem_region(db->data_res->start, iosize,=0A=
					  pdev->name);=0A=
=0A=
	if (db->data_req =3D=3D NULL) {=0A=
		dev_err(db->dev, "cannot claim data reg area\n");=0A=
		ret =3D -EIO;=0A=
		goto out;=0A=
	}=0A=
=0A=
	db->io_data =3D ioremap(db->data_res->start, iosize);=0A=
=0A=
	if (db->io_data =3D=3D NULL) {=0A=
		dev_err(db->dev, "failed to ioremap data reg\n");=0A=
		ret =3D -EINVAL;=0A=
		goto out;=0A=
	}=0A=
=0A=
	/* fill in parameters for net-dev structure */=0A=
	ndev->base_addr =3D (unsigned long)db->io_addr;=0A=
	ndev->irq	=3D db->irq_res->start;=0A=
	//Stone add=0A=
	printk("[dm9] %s ndev->irq=3D%x \n",__func__,ndev->irq);=0A=
=0A=
	/* ensure at least we have a default set of IO routines */=0A=
	dm9000_set_io(db, iosize);=0A=
=0A=
	/* check to see if anything is being over-ridden */=0A=
	if (pdata !=3D NULL) {=0A=
		/* check to see if the driver wants to over-ride the=0A=
		 * default IO width */=0A=
=0A=
		if (pdata->flags & DM9000_PLATF_8BITONLY)=0A=
			dm9000_set_io(db, 1);=0A=
=0A=
		if (pdata->flags & DM9000_PLATF_16BITONLY)=0A=
			dm9000_set_io(db, 2);=0A=
=0A=
		if (pdata->flags & DM9000_PLATF_32BITONLY)=0A=
			dm9000_set_io(db, 4);=0A=
=0A=
		/* check to see if there are any IO routine=0A=
		 * over-rides */=0A=
=0A=
		if (pdata->inblk !=3D NULL)=0A=
			db->inblk =3D pdata->inblk;=0A=
=0A=
		if (pdata->outblk !=3D NULL)=0A=
			db->outblk =3D pdata->outblk;=0A=
=0A=
		if (pdata->dumpblk !=3D NULL)=0A=
			db->dumpblk =3D pdata->dumpblk;=0A=
=0A=
		db->flags =3D pdata->flags;=0A=
	}=0A=
=0A=
#ifdef CONFIG_DM9000_FORCE_SIMPLE_PHY_POLL=0A=
	db->flags |=3D DM9000_PLATF_SIMPLE_PHY;=0A=
#endif=0A=
=0A=
//Stone add=0A=
//	dm9000_reset(db);=0A=
  iow(db, DM9000_NCR, 0x03);=0A=
=0A=
	/* try multiple times, DM9000 sometimes gets the read wrong */=0A=
	for (i =3D 0; i < 8; i++) {=0A=
		id_val  =3D ior(db, DM9000_VIDL);=0A=
		id_val |=3D (u32)ior(db, DM9000_VIDH) << 8;=0A=
		id_val |=3D (u32)ior(db, DM9000_PIDL) << 16;=0A=
		id_val |=3D (u32)ior(db, DM9000_PIDH) << 24;=0A=
=0A=
		printk("[dm9].%d read id 0x%08x\n", i+1, id_val);=0A=
		=0A=
		if (id_val =3D=3D DM9000_ID)=0A=
			break;=0A=
		dev_err(db->dev, "read wrong id 0x%08x\n", id_val);=0A=
	}=0A=
	=0A=
	printk(KERN_INFO "[%s Ethernet Driver, V%s]: KV=3D %d.%d.%d !!\n", =
CARDNAME, DRV_VERSION,  //JJ1 =0A=
	                            (LINUX_VERSION_CODE>>16 & 0xff),=0A=
	                            (LINUX_VERSION_CODE>>8 & 0xff),=0A=
	                            (LINUX_VERSION_CODE & 0xff) ); //#define =
KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))=0A=
	printk(KERN_INFO "[%s Ethernet Driver, V%s]: ChipID=3D 0x%x !!\n", =
CARDNAME, DRV_VERSION, id_val ); // JJ1=0A=
=0A=
	if (id_val !=3D DM9000_ID) {=0A=
		dev_err(db->dev, "wrong id: 0x%08x\n", id_val);=0A=
		ret =3D -ENODEV;=0A=
		goto out;=0A=
	}=0A=
=0A=
	/* Identify what type of DM9000 we are working on */=0A=
=0A=
	id_val =3D ior(db, DM9000_CHIPR);=0A=
	dev_dbg(db->dev, "dm9000 revision 0x%02x\n", id_val);=0A=
	printk(KERN_INFO "[DM9000]dm9000 revision 0x%02x\n", id_val); //V_R1=0A=
=0A=
	switch (id_val) {=0A=
	case CHIPR_DM9000A:=0A=
		db->type =3D TYPE_DM9000A;=0A=
		break;=0A=
	case CHIPR_DM9000B:=0A=
		db->type =3D TYPE_DM9000B;=0A=
		break;=0A=
	default:=0A=
		dev_dbg(db->dev, "ID %02x =3D> defaulting to DM9000E\n", id_val);=0A=
		db->type =3D TYPE_DM9000E;=0A=
	}=0A=
=0A=
	/* from this point we assume that we have found a DM9000 */=0A=
=0A=
	/* driver system function */=0A=
	ether_setup(ndev);=0A=
	=0A=
#if LINUX_VERSION_CODE >=3D KERNEL_VERSION(2,6,31)=0A=
			ndev->netdev_ops =3D &dm9000_netdev_ops; // new kernel 2.6.31 =0A=
			ndev->watchdog_timeo	=3D msecs_to_jiffies(watchdog);	=0A=
	 		ndev->ethtool_ops	 =3D &dm9000_ethtool_ops;=0A=
#else=0A=
	ndev->open		 =3D &dm9000_open;=0A=
	ndev->hard_start_xmit    =3D &dm9000_start_xmit;=0A=
	ndev->tx_timeout         =3D &dm9000_timeout;=0A=
	ndev->watchdog_timeo =3D msecs_to_jiffies(watchdog);=0A=
	ndev->stop		 =3D &dm9000_stop;=0A=
	ndev->set_multicast_list =3D &dm9000_hash_table;=0A=
	ndev->ethtool_ops	 =3D &dm9000_ethtool_ops;=0A=
	ndev->do_ioctl		 =3D &dm9000_ioctl;=0A=
#endif=0A=
=0A=
=0A=
#ifdef CONFIG_NET_POLL_CONTROLLER=0A=
	ndev->poll_controller	 =3D &dm9000_poll_controller;=0A=
#endif=0A=
=0A=
	db->msg_enable       =3D NETIF_MSG_LINK;=0A=
	db->mii.phy_id_mask  =3D 0x1f;=0A=
	db->mii.reg_num_mask =3D 0x1f;=0A=
	db->mii.force_media  =3D 0;=0A=
	db->mii.full_duplex  =3D 0;=0A=
	db->mii.dev	     =3D ndev;=0A=
	db->mii.mdio_read    =3D dm9000_phy_read;=0A=
	db->mii.mdio_write   =3D dm9000_phy_write;=0A=
=0A=
	mac_src =3D "eeprom";=0A=
=0A=
	/* try reading the node address from the attached EEPROM */=0A=
	for (i =3D 0; i < 6; i +=3D 2)=0A=
		dm9000_read_eeprom(db, i / 2, ndev->dev_addr+i);=0A=
=0A=
	if (!is_valid_ether_addr(ndev->dev_addr) && pdata !=3D NULL) {=0A=
		mac_src =3D "platform data";=0A=
		memcpy(ndev->dev_addr, pdata->dev_addr, 6);=0A=
	}=0A=
=0A=
	if (!is_valid_ether_addr(ndev->dev_addr)) {=0A=
		/* try reading from mac */=0A=
		=0A=
		mac_src =3D "chip";=0A=
=0A=
		static unsigned char mac_addr[6] =3D {0x00,0x11,0x22,0x33,0x44,0x55};=0A=
		static unsigned char mac_tmp[6] =3D {0xff,0xff,0xff,0xff,0xff,0xff};=0A=
		for (i =3D 0; i < 6; i++)=0A=
			ndev->dev_addr[i] =3D ior(db, i+DM9000_PAR);=0A=
=0A=
		// Mark Chang 20100521=0A=
		// -------------------=0A=
		if (!memcmp(ndev->dev_addr, mac_tmp, 6))=0A=
			memcpy(ndev->dev_addr, mac_addr, 6);=0A=
	}=0A=
=0A=
	if (!is_valid_ether_addr(ndev->dev_addr))=0A=
		dev_warn(db->dev, "%s: Invalid ethernet MAC address. Please "=0A=
			 "set using ifconfig\n", ndev->name);=0A=
=0A=
	platform_set_drvdata(pdev, ndev);=0A=
	ret =3D register_netdev(ndev);=0A=
=0A=
	if (ret =3D=3D 0)=0A=
		printk(KERN_INFO "%s: dm9000%c at %p,%p IRQ %d MAC: %pM (%s)\n",=0A=
		       ndev->name, dm9000_type_to_char(db->type),=0A=
		       db->io_addr, db->io_data, ndev->irq,=0A=
		       ndev->dev_addr, mac_src);=0A=
	return 0;=0A=
=0A=
out:=0A=
	dev_err(db->dev, "not found (%d).\n", ret);=0A=
=0A=
	dm9000_release_board(pdev, db);=0A=
	free_netdev(ndev);=0A=
=0A=
	return ret;=0A=
}=0A=
=0A=
static int=0A=
dm9000_drv_suspend(struct platform_device *dev, pm_message_t state)=0A=
{=0A=
	struct net_device *ndev =3D platform_get_drvdata(dev);=0A=
	board_info_t *db;=0A=
=0A=
	if (ndev) {=0A=
		db =3D netdev_priv(ndev);=0A=
		db->in_suspend =3D 1;=0A=
=0A=
		if (netif_running(ndev)) {=0A=
			netif_device_detach(ndev);=0A=
			dm9000_shutdown(ndev);=0A=
		}=0A=
	}=0A=
	return 0;=0A=
}=0A=
=0A=
static int=0A=
dm9000_drv_resume(struct platform_device *dev)=0A=
{=0A=
	struct net_device *ndev =3D platform_get_drvdata(dev);=0A=
	board_info_t *db =3D netdev_priv(ndev);=0A=
=0A=
	if (ndev) {=0A=
=0A=
		if (netif_running(ndev)) {=0A=
			dm9000_reset(db);=0A=
			dm9000_init_dm9000(ndev);=0A=
=0A=
			netif_device_attach(ndev);=0A=
		}=0A=
=0A=
		db->in_suspend =3D 0;=0A=
	}=0A=
	return 0;=0A=
}=0A=
=0A=
static int __devexit=0A=
dm9000_drv_remove(struct platform_device *pdev)=0A=
{=0A=
	struct net_device *ndev =3D platform_get_drvdata(pdev);=0A=
=0A=
	platform_set_drvdata(pdev, NULL);=0A=
=0A=
	unregister_netdev(ndev);=0A=
	dm9000_release_board(pdev, (board_info_t *) netdev_priv(ndev));=0A=
	free_netdev(ndev);		/* free device structure */=0A=
=0A=
	dev_dbg(&pdev->dev, "released and freed device\n");=0A=
	return 0;=0A=
}=0A=
=0A=
static struct platform_driver dm9000_driver =3D {=0A=
	.driver	=3D {=0A=
		.name    =3D "dm9000",=0A=
		.owner	 =3D THIS_MODULE,=0A=
	},=0A=
	.probe   =3D dm9000_probe,=0A=
	.remove  =3D __devexit_p(dm9000_drv_remove),=0A=
	.suspend =3D dm9000_drv_suspend,=0A=
	.resume  =3D dm9000_drv_resume,=0A=
};=0A=
=0A=
static int __init=0A=
dm9000_init(void)=0A=
{=0A=
	printk(KERN_INFO "%s Ethernet Driver, V%s\n", CARDNAME, DRV_VERSION);=0A=
=0A=
	return platform_driver_register(&dm9000_driver);=0A=
}=0A=
=0A=
static void __exit=0A=
dm9000_cleanup(void)=0A=
{=0A=
	platform_driver_unregister(&dm9000_driver);=0A=
}=0A=
=0A=
module_init(dm9000_init);=0A=
module_exit(dm9000_cleanup);=0A=
=0A=
MODULE_AUTHOR("Sascha Hauer, Ben Dooks");=0A=
MODULE_DESCRIPTION("Davicom DM9000 network driver");=0A=
MODULE_LICENSE("GPL");=0A=
MODULE_ALIAS("platform:dm9000");=0A=

------=_NextPart_000_0011_01CD966E.CC5824B0
Content-Type: application/octet-stream;
	name="dm9000_KT2.6.31.h"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="dm9000_KT2.6.31.h"

/*=0A=
 * dm9000 Ethernet=0A=
 */=0A=
=0A=
#ifndef _DM9000X_H_=0A=
#define _DM9000X_H_=0A=
=0A=
#define DM9000_ID		0x90000A46=0A=
=0A=
/* although the registers are 16 bit, they are 32-bit aligned.=0A=
 */=0A=
=0A=
#define DM9000_NCR             0x00=0A=
#define DM9000_NSR             0x01=0A=
#define DM9000_TCR             0x02=0A=
#define DM9000_TSR1            0x03=0A=
#define DM9000_TSR2            0x04=0A=
#define DM9000_RCR             0x05=0A=
#define DM9000_RSR             0x06=0A=
#define DM9000_ROCR            0x07=0A=
#define DM9000_BPTR            0x08=0A=
#define DM9000_FCTR            0x09=0A=
#define DM9000_FCR             0x0A=0A=
#define DM9000_EPCR            0x0B=0A=
#define DM9000_EPAR            0x0C=0A=
#define DM9000_EPDRL           0x0D=0A=
#define DM9000_EPDRH           0x0E=0A=
#define DM9000_WCR             0x0F=0A=
=0A=
#define DM9000_PAR             0x10=0A=
#define DM9000_MAR             0x16=0A=
=0A=
#define DM9000_GPCR	       0x1e=0A=
#define DM9000_GPR             0x1f=0A=
#define DM9000_TRPAL           0x22=0A=
#define DM9000_TRPAH           0x23=0A=
#define DM9000_RWPAL           0x24=0A=
#define DM9000_RWPAH           0x25=0A=
=0A=
#define DM9000_VIDL            0x28=0A=
#define DM9000_VIDH            0x29=0A=
#define DM9000_PIDL            0x2A=0A=
#define DM9000_PIDH            0x2B=0A=
=0A=
#define DM9000_CHIPR           0x2C=0A=
#define DM9000_SMCR            0x2F=0A=
=0A=
#define CHIPR_DM9000A	       0x19=0A=
#define CHIPR_DM9000B	       0x1A  //V_R1 0x1B=0A=
=0A=
#define DM9000_MRCMDX          0xF0=0A=
#define DM9000_MRCMD           0xF2=0A=
#define DM9000_MRRL            0xF4=0A=
#define DM9000_MRRH            0xF5=0A=
#define DM9000_MWCMDX          0xF6=0A=
#define DM9000_MWCMD           0xF8=0A=
#define DM9000_MWRL            0xFA=0A=
#define DM9000_MWRH            0xFB=0A=
#define DM9000_TXPLL           0xFC=0A=
#define DM9000_TXPLH           0xFD=0A=
#define DM9000_ISR             0xFE=0A=
#define DM9000_IMR             0xFF=0A=
=0A=
#define NCR_EXT_PHY         (1<<7)=0A=
#define NCR_WAKEEN          (1<<6)=0A=
#define NCR_FCOL            (1<<4)=0A=
#define NCR_FDX             (1<<3)=0A=
#define NCR_LBK             (3<<1)=0A=
#define NCR_RST	            (1<<0)=0A=
=0A=
#define NSR_SPEED           (1<<7)=0A=
#define NSR_LINKST          (1<<6)=0A=
#define NSR_WAKEST          (1<<5)=0A=
#define NSR_TX2END          (1<<3)=0A=
#define NSR_TX1END          (1<<2)=0A=
#define NSR_RXOV            (1<<1)=0A=
=0A=
#define TCR_TJDIS           (1<<6)=0A=
#define TCR_EXCECM          (1<<5)=0A=
#define TCR_PAD_DIS2        (1<<4)=0A=
#define TCR_CRC_DIS2        (1<<3)=0A=
#define TCR_PAD_DIS1        (1<<2)=0A=
#define TCR_CRC_DIS1        (1<<1)=0A=
#define TCR_TXREQ           (1<<0)=0A=
=0A=
#define TSR_TJTO            (1<<7)=0A=
#define TSR_LC              (1<<6)=0A=
#define TSR_NC              (1<<5)=0A=
#define TSR_LCOL            (1<<4)=0A=
#define TSR_COL             (1<<3)=0A=
#define TSR_EC              (1<<2)=0A=
=0A=
#define RCR_WTDIS           (1<<6)=0A=
#define RCR_DIS_LONG        (1<<5)=0A=
#define RCR_DIS_CRC         (1<<4)=0A=
#define RCR_ALL	            (1<<3)=0A=
#define RCR_RUNT            (1<<2)=0A=
#define RCR_PRMSC           (1<<1)=0A=
#define RCR_RXEN            (1<<0)=0A=
=0A=
#define RSR_RF              (1<<7)=0A=
#define RSR_MF              (1<<6)=0A=
#define RSR_LCS             (1<<5)=0A=
#define RSR_RWTO            (1<<4)=0A=
#define RSR_PLE             (1<<3)=0A=
#define RSR_AE              (1<<2)=0A=
#define RSR_CE              (1<<1)=0A=
#define RSR_FOE             (1<<0)=0A=
=0A=
#define FCTR_HWOT(ot)	(( ot & 0xf ) << 4 )=0A=
#define FCTR_LWOT(ot)	( ot & 0xf )=0A=
=0A=
#define IMR_PAR             (1<<7)=0A=
#define IMR_ROOM            (1<<3)=0A=
#define IMR_ROM             (1<<2)=0A=
#define IMR_PTM             (1<<1)=0A=
#define IMR_PRM             (1<<0)=0A=
=0A=
#define ISR_ROOS            (1<<3)=0A=
#define ISR_ROS             (1<<2)=0A=
#define ISR_PTS             (1<<1)=0A=
#define ISR_PRS             (1<<0)=0A=
#define ISR_CLR_STATUS      (ISR_ROOS | ISR_ROS | ISR_PTS | ISR_PRS)=0A=
=0A=
#define EPCR_REEP           (1<<5)=0A=
#define EPCR_WEP            (1<<4)=0A=
#define EPCR_EPOS           (1<<3)=0A=
#define EPCR_ERPRR          (1<<2)=0A=
#define EPCR_ERPRW          (1<<1)=0A=
#define EPCR_ERRE           (1<<0)=0A=
=0A=
#define GPCR_GEP_CNTL       (1<<0)=0A=
=0A=
#define DM9000_PKT_RDY		0x01	/* Packet ready to receive */=0A=
#define DM9000_PKT_MAX		1536	/* Received packet max size */=0A=
=0A=
/* DM9000A / DM9000B definitions */=0A=
=0A=
#define IMR_LNKCHNG		(1<<5)=0A=
#define IMR_UNDERRUN		(1<<4)=0A=
=0A=
#define ISR_LNKCHNG		(1<<5)=0A=
#define ISR_UNDERRUN		(1<<4)=0A=
=0A=
#endif /* _DM9000X_H_ */=0A=
=0A=

------=_NextPart_000_0011_01CD966E.CC5824B0--

