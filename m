Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323Ab1I0KDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:03:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61114 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095Ab1I0KDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:03:44 -0400
MIME-Version: 1.0
In-Reply-To: <1316261666-28555-1-git-send-email-kth3321@gmail.com>
References: <1316261666-28555-1-git-send-email-kth3321@gmail.com>
Date: Tue, 27 Sep 2011 19:03:42 +0900
Message-ID: <CAOkfWjcHxh60D9KvxLfgL0tw9XdPyDN9xr7q+9V+nM6B6g8tDA@mail.gmail.com>
Subject: Re: [PATCH] w5300: add WIZnet W5300 Ethernet driver
From: Taehun Kim <kth3321@gmail.com>
To: netdev <netdev@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/17 Taehun Kim <kth3321@gmail.com>:
> WIZnet W5300 is a network chip into which 10/100 Ethernet controller, MAC, and TCP/IP are integrated.
> This driver supports just Ethernet function in W5300.
>
> Signed-off-by: Taehun Kim <kth3321@gmail.com>
> ---
>  drivers/net/Kconfig  |    5 +
>  drivers/net/Makefile |    1 +
>  drivers/net/w5300.c  |  669 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/w5300.h  |  350 ++++++++++++++++++++++++++
>  4 files changed, 1025 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/w5300.c
>  create mode 100644 drivers/net/w5300.h
>
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index 8d0314d..4a8a100 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2016,6 +2016,11 @@ config LANTIQ_ETOP
>        help
>          Support for the MII0 inside the Lantiq SoC
>
> +config W5300
> +       tristate "WIZnet W5300 ethernet driver"
> +       depends on ARM
> +       help
> +         This is driver for WIZnet W5300 network chip.
>
>  source "drivers/net/fs_enet/Kconfig"
>
> diff --git a/drivers/net/Makefile b/drivers/net/Makefile
> index e1eca2a..288fce1 100644
> --- a/drivers/net/Makefile
> +++ b/drivers/net/Makefile
> @@ -266,6 +266,7 @@ obj-$(CONFIG_XTENSA_XT2000_SONIC) += xtsonic.o
>  obj-$(CONFIG_DNET) += dnet.o
>  obj-$(CONFIG_MACB) += macb.o
>  obj-$(CONFIG_S6GMAC) += s6gmac.o
> +obj-$(CONFIG_W5300) += w5300.o
>
>  obj-$(CONFIG_ARM) += arm/
>  obj-$(CONFIG_DEV_APPLETALK) += appletalk/
> diff --git a/drivers/net/w5300.c b/drivers/net/w5300.c
> new file mode 100644
> index 0000000..fcc2579
> --- /dev/null
> +++ b/drivers/net/w5300.c
> @@ -0,0 +1,669 @@
> +/* w5300.c: A Linux Ethernet driver for the WIZnet W5300 chip. */
> +/*
> +  Copyright (C) 2011 Taehun Kim <kth3321@gmail.com>
> +
> +  This software may be used and distributed according to the terms of
> +  the GNU General Public License (GPL), incorporated herein by reference.
> +  Drivers based on or derived from this code fall under the GPL and must
> +  retain the authorship, copyright and license notice.  This file is not
> +  a complete program and may only be used when the entire operating
> +  system is licensed under the GPL.
> +*/
> +
> +#include <linux/init.h>
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/sched.h>
> +#include <linux/delay.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/errno.h>
> +
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/skbuff.h>
> +
> +#include <linux/device.h>
> +#include <linux/platform_device.h>
> +#include <linux/ioport.h>
> +#include <linux/io.h>
> +
> +#include "w5300.h"
> +
> +#define DEV_NAME    "w5300"
> +#define DRV_VERSION "1.0"
> +#define DRV_RELDATE "Sept 17, 2011"
> +
> +static const char driver_info[] =
> +       KERN_INFO DEV_NAME ": Ethernet driver v" DRV_VERSION "("
> +       DRV_RELDATE ")\n";
> +
> +MODULE_AUTHOR("Taehun Kim <kth3321@gmail.com>");
> +MODULE_DESCRIPTION("WIZnet W5300 Ethernet driver");
> +MODULE_VERSION(DRV_VERSION);
> +MODULE_LICENSE("GPL");
> +
> +/* Transmit timeout, default 5 seconds. */
> +static int watchdog = 5000;
> +module_param(watchdog, int, 0400);
> +MODULE_PARM_DESC(watchdog, "transmit timeout in milliseconds");
> +
> +/*
> + * This is W5300 information structure.
> + * Additional information is included in struct net_device.
> + */
> +struct wiz_private {
> +       void __iomem *base;
> +       struct net_device *dev;
> +       u8 rxbuf_conf[MAX_SOCK_NUM];
> +       u8 txbuf_conf[MAX_SOCK_NUM];
> +       struct net_device_stats stats;
> +       struct napi_struct napi;
> +       spinlock_t lock;
> +};
> +
> +/* Default MAC address. */
> +static const u8 w5300_defmac[6] = {0x00, 0x08, 0xDC, 0xA0, 0x00, 0x01};
> +
> +/* Default RX/TX buffer size(KByte). */
> +static const u8 w5300_rxbuf_conf[MAX_SOCK_NUM] = { 64, 0, 0, 0, 0, 0, 0, 0 };
> +static const u8 w5300_txbuf_conf[MAX_SOCK_NUM] = { 64, 0, 0, 0, 0, 0, 0, 0 };
> +
> +/* Notifying packet size in the RX FIFO */
> +static int
> +w5300_get_rxsize(struct wiz_private *wp, int s)
> +{
> +       u32 val;
> +
> +       val = w5300_read(wp, Sn_RX_RSR(s));
> +       val = (val << 16) + w5300_read(wp, Sn_RX_RSR2(s));
> +       return val;
> +}
> +
> +/* Packet Receive Function. It reads received packet from the Rx FIFO. */
> +static int
> +w5300_recv_data(struct wiz_private *wp, int s,
> +               u8 *buf, ssize_t len, int swap_enable)
> +{
> +       int i;
> +       u16 recv_data;
> +
> +       if (unlikely(len <= 0))
> +               return 0;
> +
> +       if (swap_enable) {
> +               /* read from RX FIFO */
> +               for (i = 0; i < len; i += 2) {
> +                       recv_data = w5300_read(wp, Sn_RX_FIFO(s));
> +                       buf[i] = (u8) ((recv_data & 0xFF00) >> 8);
> +                       buf[i + 1] = (u8) (recv_data & 0x00FF);
> +               }
> +       } else {
> +               for (i = 0; i < len; i += 2) {
> +                       recv_data = w5300_read(wp, Sn_RX_FIFO(s));
> +                       buf[i] = (u8) (recv_data & 0x00FF);
> +                       buf[i + 1] = (u8) ((recv_data & 0xFF00) >> 8);
> +               }
> +       }
> +       return len;
> +}
> +
> +/* Setting MAC address of W5300 */
> +static void
> +w5300_set_macaddr(struct wiz_private *wp, u8 * addr)
> +{
> +       w5300_write(wp, SHAR, (u16) (addr[0] << 8) | (u16) addr[1]);
> +       w5300_write(wp, SHAR2, (u16) (addr[2] << 8) | (u16) addr[3]);
> +       w5300_write(wp, SHAR4, (u16) (addr[4] << 8) | (u16) addr[5]);
> +}
> +
> +/* Opening channels of W5300 */
> +static int
> +w5300_open(struct wiz_private *wp, u32 type)
> +{
> +       /* Which type will be used for open? */
> +       switch (type) {
> +       case Sn_MR_MACRAW:
> +       case Sn_MR_MACRAW_MF:
> +               w5300_write(wp, Sn_MR(0), type);
> +               break;
> +       default:
> +               printk(KERN_ERR "%s: Unknown socket type (%d)\n",
> +                      DEV_NAME, type);
> +               return -EFAULT;
> +       }
> +       w5300_write(wp, Sn_PORTR(0), 5300);
> +
> +       w5300_write(wp, Sn_CR(0), Sn_CR_OPEN);
> +       while (w5300_read(wp, Sn_CR(0)))
> +               udelay(1);
> +
> +       return 0;
> +}
> +
> +/* Activating the interrupt of related channel */
> +static void
> +w5300_interrupt_enable(struct wiz_private *wp, int s)
> +{
> +       u16 mask;
> +       mask = w5300_read(wp, IMR);
> +       mask |= (0x01 << s);
> +       w5300_write(wp, IMR, mask);
> +}
> +
> +/* De-activating the interrupt of related channel */
> +static void
> +w5300_interrupt_disable(struct wiz_private *wp, int s)
> +{
> +       u16 mask;
> +       mask = w5300_read(wp, IMR);
> +       mask &= ~(0x01 << s);
> +       w5300_write(wp, IMR, mask);
> +}
> +
> +/* W5300 initialization function */
> +static int
> +w5300_reset(struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +       u32 txbuf_total = 0, i;
> +       u16 mem_cfg = 0;
> +
> +       DPRINTK("%s: w5300 chip reset\n", __func__);
> +
> +       /* W5300 is initialized by sending RESET command. */
> +       w5300_write(wp, MR, MR_RST);
> +       mdelay(5);
> +
> +       /* Mode Register Setting
> +        * Ping uses S/W stack of the Linux kernel. Set the Ping Block.*/
> +       w5300_write(wp, MR, MR_WDF(1) | MR_PB);
> +
> +       /* Setting MAC address */
> +       w5300_set_macaddr(wp, dev->dev_addr);
> +
> +       /* Setting the size of Rx/Tx FIFO */
> +       for (i = 0; i < MAX_SOCK_NUM; ++i) {
> +               if (wp->rxbuf_conf[i] > 64) {
> +                       printk(KERN_ERR "%s: Illegal Channel(%d) RX memory size.\n",
> +                              DEV_NAME, i);
> +                       return -EINVAL;
> +               }
> +               if (wp->txbuf_conf[i] > 64) {
> +                       printk(KERN_ERR "%s: Illegal Channel(%d) TX memory size.\n",
> +                              DEV_NAME, i);
> +                       return -EINVAL;
> +               }
> +               txbuf_total += wp->txbuf_conf[i];
> +       }
> +
> +       if (txbuf_total % 8) {
> +               printk(KERN_ERR "%s: Illegal memory size register setting.\n",
> +                      DEV_NAME);
> +               return -EINVAL;
> +       }
> +       w5300_write(wp, RMSR0,
> +                   (u16) (wp->rxbuf_conf[0] << 8) | (u16) wp->rxbuf_conf[1]);
> +       w5300_write(wp, RMSR2,
> +                   (u16) (wp->rxbuf_conf[2] << 8) | (u16) wp->rxbuf_conf[3]);
> +       w5300_write(wp, RMSR4,
> +                   (u16) (wp->rxbuf_conf[4] << 8) | (u16) wp->rxbuf_conf[5]);
> +       w5300_write(wp, RMSR6,
> +                   (u16) (wp->rxbuf_conf[6] << 8) | (u16) wp->rxbuf_conf[7]);
> +       w5300_write(wp, TMSR0,
> +                   (u16) (wp->txbuf_conf[0] << 8) | (u16) wp->txbuf_conf[1]);
> +       w5300_write(wp, TMSR2,
> +                   (u16) (wp->txbuf_conf[2] << 8) | (u16) wp->txbuf_conf[3]);
> +       w5300_write(wp, TMSR4,
> +                   (u16) (wp->txbuf_conf[4] << 8) | (u16) wp->txbuf_conf[5]);
> +       w5300_write(wp, TMSR6,
> +                   (u16) (wp->txbuf_conf[6] << 8) | (u16) wp->txbuf_conf[7]);
> +
> +       /* Setting FIFO Memory Type (TX&RX) */
> +       for (i = 0; i < txbuf_total / 8; ++i) {
> +               mem_cfg <<= 1;
> +               mem_cfg |= 1;
> +       }
> +       w5300_write(wp, MTYPER, mem_cfg);
> +
> +       /* Masking all interrupts */
> +       w5300_write(wp, IMR, 0x0000);
> +
> +       return 0;
> +}
> +
> +/* Interrupt Handler(ISR) */
> +static irqreturn_t
> +wiz_interrupt(int irq, void *dev_instance)
> +{
> +       struct net_device *dev = dev_instance;
> +       struct wiz_private *wp = netdev_priv(dev);
> +       unsigned long isr, ssr;
> +       int s;
> +
> +       isr = w5300_read(wp, IR);
> +
> +       /* Completing all interrupts at a time. */
> +       while (isr) {
> +               w5300_write(wp, IR, isr);
> +
> +               /* Finding the channel to create the interrupt */
> +               s = find_first_bit(&isr, sizeof(u16));
> +               ssr = w5300_read(wp, Sn_IR(s));
> +               /* socket interrupt is cleared. */
> +               w5300_write(wp, Sn_IR(s), ssr);
> +               DPRINTK("%s: ISR = %X, SSR = %X, s = %X\n",
> +                       __func__, isr, ssr, s);
> +               if (likely(!s)) {
> +                       if (ssr & Sn_IR_RECV) {
> +                               /* De-activation of interrupt */
> +                               w5300_interrupt_disable(wp, 0);
> +                               /* Receiving by polling method */
> +                               napi_schedule(&wp->napi);
> +                       }
> +               }
> +
> +               /* Is there any interrupt to be processed? */
> +               isr = w5300_read(wp, IR);
> +       }
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static int
> +wiz_open(struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +       int ret;
> +
> +       napi_enable(&wp->napi);
> +
> +       ret = request_irq(dev->irq, wiz_interrupt,
> +                         IRQF_IRQPOLL, dev->name, dev);
> +       if (ret < 0) {
> +               printk(KERN_ERR "%s: request_irq() error!\n", DEV_NAME);
> +               return ret;
> +       }
> +
> +       /* Activating the interrupt of channel 0 that is used for MACRAW. */
> +       w5300_interrupt_enable(wp, 0);
> +
> +       /* Sending OPEN command to use channel 0 as MACRAW mode. */
> +       w5300_open(wp, Sn_MR_MACRAW_MF);
> +
> +       netif_start_queue(dev);
> +
> +       return 0;
> +}
> +
> +static int
> +wiz_close(struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +
> +       DPRINTK("%s\n", __func__);
> +
> +       napi_disable(&wp->napi);
> +
> +       /* Interrupt masking of all channels */
> +       w5300_write(wp, IMR, 0x0000);
> +       netif_stop_queue(dev);
> +       w5300_write(wp, Sn_CR(0), Sn_CR_CLOSE);
> +       free_irq(dev->irq, dev);
> +
> +       return 0;
> +}
> +
> +static int
> +w5300_send_data(struct wiz_private *wp, u8 * buf, ssize_t len)
> +{
> +       int i;
> +       u16 send_data;
> +
> +       /* Writing packets in to Tx FIFO */
> +       for (i = 0; i < len; i += 2) {
> +               send_data = (buf[i] << 8) | buf[i+1];
> +               w5300_write(wp, Sn_TX_FIFO(0), send_data);
> +       }
> +
> +       w5300_write(wp, Sn_TX_WRSR(0), (u16)(len >> 16));
> +       w5300_write(wp, Sn_TX_WRSR2(0), (u16)len);
> +       w5300_write(wp, Sn_CR(0), Sn_CR_SEND);
> +       while (w5300_read(wp, Sn_CR(0)))
> +               udelay(1);
> +
> +       return len;
> +}
> +
> +/* Function to transmit data at the MACRAW mode */
> +static int
> +wiz_start_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +       int ret;
> +
> +       DPRINTK("%s: MAC_RAW SEND packet size = %d\n", __func__, skb->len);
> +
> +       ret = w5300_send_data(wp, skb->data, skb->len);
> +
> +       /* Statistical Process */
> +       if (ret < 0) {
> +               wp->stats.tx_dropped++;
> +       } else {
> +               wp->stats.tx_bytes += skb->len;
> +               wp->stats.tx_packets++;
> +               dev->trans_start = jiffies;
> +       }
> +       dev_kfree_skb(skb);
> +
> +       return 0;
> +}
> +
> +static struct net_device_stats *
> +wiz_get_stats(struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +       DPRINTK("%s: get status\n", __func__);
> +       return &wp->stats;
> +}
> +
> +/* It is called when multi-cast list or flag is changed. */
> +static void
> +wiz_set_multicast(struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +
> +       DPRINTK("%s: multicast\n", __func__);
> +       if (dev->flags & IFF_PROMISC)
> +               w5300_open(wp, Sn_MR_MACRAW);
> +       else
> +               w5300_open(wp, Sn_MR_MACRAW_MF);
> +}
> +
> +static int
> +wiz_set_mac_address(struct net_device *dev, void *addr)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +       struct sockaddr *sock_addr = addr;
> +
> +       DPRINTK("%s: set mac address\n", __func__);
> +
> +       spin_lock(&wp->lock);
> +       /* Changing MAC address of W5300 */
> +       w5300_set_macaddr(wp, sock_addr->sa_data);
> +       /* Changing MAC address of material structure to manage W5300 */
> +       memcpy(dev->dev_addr, sock_addr->sa_data, dev->addr_len);
> +       spin_unlock(&wp->lock);
> +
> +       return 0;
> +}
> +
> +static void
> +wiz_tx_timeout(struct net_device *dev)
> +{
> +       struct wiz_private *wp = netdev_priv(dev);
> +       unsigned long flags;
> +
> +       printk(KERN_WARNING "%s: Transmit timeout\n", dev->name);
> +
> +       spin_lock_irqsave(&wp->lock, flags);
> +       /* Initializing W5300 chip. */
> +       w5300_reset(dev);
> +       /* Waking up network interface */
> +       netif_wake_queue(dev);
> +       spin_unlock_irqrestore(&wp->lock, flags);
> +}
> +
> +/*
> + * Polling Function to process only receiving at the MACRAW mode.
> + * De-activating the interrupt when recv interrupt occurs,
> + * and processing the RECEIVE with this Function
> + * Activating the interrupt after completing RECEIVE process
> + * As recv interrupt often occurs at short intervals,
> + * there will system load in case that interrupt handler process the RECEIVE.
> + */
> +static int
> +wiz_rx_poll(struct napi_struct *napi, int budget)
> +{
> +       struct sk_buff *skb;
> +       struct wiz_private *wp = container_of(napi, struct wiz_private, napi);
> +       struct net_device *dev = wp->dev;
> +       u16 rxbuf_len, pktlen;
> +       u32 crc;
> +       int npackets = 0;
> +
> +       /* Processing the RECEIVE during Rx FIFO is containing any packet */
> +       while (w5300_get_rxsize(wp, 0) > 0) {
> +
> +               /* The first 2byte is the information about packet lenth. */
> +               w5300_recv_data(wp, 0, (u8 *)&pktlen, 2, 0);
> +               DPRINTK("%s: pktlen = %d\n", __func__, pktlen);
> +
> +               /*
> +                * Allotting the socket buffer in which packet will be contained
> +                * Ethernet packet is of 14byte.
> +                * In order to make it multiplied by 2, the buffer allocation
> +                * should be 2bytes bigger than the packet.
> +                */
> +               skb = dev_alloc_skb(pktlen + 2);
> +               if (!skb) {
> +                       u8 *temp;
> +                       printk(KERN_ERR "%s: Memory squeeze, dropping packet.\n",
> +                              dev->name);
> +                       temp = kmalloc(pktlen + 4, GFP_KERNEL);
> +                       wp->stats.rx_dropped++;
> +                       w5300_recv_data(wp, 0, temp, pktlen + 4, 1);
> +                       kfree(temp);
> +                       return -ENOMEM;
> +               }
> +
> +               /* Initializing the socket buffer */
> +               skb->dev = dev;
> +               skb_reserve(skb, 2);
> +               skb_put(skb, pktlen);
> +
> +               /* Reading packets from W5300 Rx FIFO into socket buffer. */
> +               w5300_recv_data(wp, 0, (u8 *)skb->data, pktlen, 1);
> +
> +               /* Reading and discarding 4byte CRC. */
> +               w5300_recv_data(wp, 0, (u8 *)&crc, 4, 0);
> +
> +               /* The packet type is Ethernet. */
> +               skb->protocol = eth_type_trans(skb, dev);
> +
> +               /* Passing packets to uppder stack (kernel). */
> +               netif_receive_skb(skb);
> +
> +               /* Processing statistical information */
> +               wp->stats.rx_packets++;
> +               wp->stats.rx_bytes += pktlen;
> +               wp->dev->last_rx = jiffies;
> +               rxbuf_len -= pktlen;
> +               npackets++;
> +
> +               if (npackets >= budget)
> +                       break;
> +       }
> +
> +       /* If packet number is smaller than budget when getting out of loopback,
> +        * the RECEIVE process is completed. */
> +       if (npackets < budget) {
> +               unsigned long flags;
> +               spin_lock_irqsave(&wp->lock, flags);
> +               w5300_interrupt_enable(wp, 0);
> +               __napi_complete(napi);
> +               spin_unlock_irqrestore(&wp->lock, flags);
> +       }
> +       return npackets;
> +}
> +
> +static const struct net_device_ops wiz_netdev_ops = {
> +       .ndo_open       = wiz_open,
> +       .ndo_stop       = wiz_close,
> +       .ndo_validate_addr      = eth_validate_addr,
> +       .ndo_set_mac_address    = wiz_set_mac_address,
> +       .ndo_set_multicast_list = wiz_set_multicast,
> +       .ndo_get_stats      = wiz_get_stats,
> +       .ndo_start_xmit     = wiz_start_xmit,
> +       .ndo_tx_timeout     = wiz_tx_timeout,
> +};
> +
> +/* Initialize W5300 driver. */
> +static int __devinit
> +w5300_drv_probe(struct platform_device *pdev)
> +{
> +       struct net_device *dev;
> +       struct wiz_private *wp;
> +       struct resource *res;
> +       void __iomem *addr;
> +       int ret;
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (!res) {
> +               ret  = -ENODEV;
> +               goto out;
> +       }
> +
> +       /* Request the chip register regions. */
> +       if (!request_mem_region(res->start, SZ_1M, DEV_NAME)) {
> +               ret = -EBUSY;
> +               goto out;
> +       }
> +
> +       /* Allocatting struct net_device structure which is managing W5300 */
> +       dev = alloc_etherdev(sizeof(struct wiz_private));
> +       if (!dev) {
> +               ret = -ENOMEM;
> +               goto release_region;
> +       }
> +
> +       dev->dma = (unsigned char)-1;
> +       dev->irq = platform_get_irq(pdev, 0);
> +       wp = netdev_priv(dev);
> +       wp->dev = dev;
> +       addr = ioremap(res->start, SZ_1M);
> +       if (!addr) {
> +               ret = -ENOMEM;
> +               goto release_both;
> +       }
> +
> +       platform_set_drvdata(pdev, dev);
> +       wp->base = addr;
> +
> +       spin_lock_init(&wp->lock);
> +
> +       /* Initialization of Rx/Tx FIFO size */
> +       memcpy(wp->rxbuf_conf, w5300_rxbuf_conf, MAX_SOCK_NUM * sizeof(u8));
> +       memcpy(wp->txbuf_conf, w5300_txbuf_conf, MAX_SOCK_NUM * sizeof(u8));
> +
> +       dev->base_addr = res->start;
> +       dev->addr_len = 6;      /* MAC address length. */
> +       memcpy(dev->dev_addr, w5300_defmac, dev->addr_len);
> +
> +       ether_setup(dev);
> +       dev->netdev_ops = &wiz_netdev_ops;
> +       /* Setting napi. Enabling to process max 16 packets at a time. */
> +       netif_napi_add(dev, &wp->napi, wiz_rx_poll, 16);
> +
> +       dev->watchdog_timeo = msecs_to_jiffies(watchdog);
> +
> +       strcpy(dev->name, "eth%d");
> +
> +       w5300_reset(dev);
> +
> +       ret = register_netdev(dev);
> +       if (ret != 0) {
> +               platform_set_drvdata(pdev, NULL);
> +               iounmap(addr);
> +release_both:
> +               free_netdev(dev);
> +release_region:
> +               release_resource(res);
> +       }
> +out:
> +       return ret;
> +}
> +
> +static int __devexit
> +w5300_drv_remove(struct platform_device *pdev)
> +{
> +       struct net_device *dev = platform_get_drvdata(pdev);
> +       struct wiz_private *wp = netdev_priv(dev);
> +       struct resource *res;
> +
> +       platform_set_drvdata(pdev, NULL);
> +       unregister_netdev(dev);
> +
> +       if (wp->base != NULL)
> +               iounmap(wp->base);
> +
> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +       if (res != NULL)
> +               release_resource(res);
> +
> +       free_netdev(dev);
> +
> +       return 0;
> +}
> +
> +static int
> +w5300_drv_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +       struct net_device *dev = platform_get_drvdata(pdev);
> +
> +       if (dev) {
> +               struct wiz_private *wp = netdev_priv(dev);
> +
> +               if (netif_running(dev)) {
> +                       netif_device_detach(dev);
> +                       w5300_write(wp, IMR, 0x0000);
> +                       w5300_write(wp, Sn_CR(0), Sn_CR_CLOSE);
> +               }
> +       }
> +       return 0;
> +}
> +
> +static int
> +w5300_drv_resume(struct platform_device *pdev)
> +{
> +       struct net_device *dev = platform_get_drvdata(pdev);
> +
> +       if (dev) {
> +               struct wiz_private *wp = netdev_priv(dev);
> +
> +               if (netif_running(dev)) {
> +                       w5300_reset(dev);
> +                       w5300_interrupt_enable(wp, 0);
> +                       w5300_open(wp, Sn_MR_MACRAW_MF);
> +                       netif_device_attach(dev);
> +               }
> +       }
> +
> +       return 0;
> +}
> +
> +static struct platform_driver w5300_driver = {
> +       .probe  = w5300_drv_probe,
> +       .remove = __devexit_p(w5300_drv_remove),
> +       .suspend         = w5300_drv_suspend,
> +       .resume  = w5300_drv_resume,
> +       .driver  = {
> +               .name    = DEV_NAME,
> +               .owner  = THIS_MODULE,
> +       },
> +};
> +
> +static int __init
> +wiz_module_init(void)
> +{
> +       return platform_driver_register(&w5300_driver);
> +}
> +
> +static void __exit
> +wiz_module_exit(void)
> +{
> +       platform_driver_unregister(&w5300_driver);
> +}
> +
> +module_init(wiz_module_init);
> +module_exit(wiz_module_exit);
> diff --git a/drivers/net/w5300.h b/drivers/net/w5300.h
> new file mode 100644
> index 0000000..d8583be
> --- /dev/null
> +++ b/drivers/net/w5300.h
> @@ -0,0 +1,350 @@
> +#ifndef        _W5300_H_
> +#define        _W5300_H_
> +
> +/* Maximum socket number. W5300 supports max 8 channels. */
> +#define MAX_SOCK_NUM 8
> +#ifdef W5300_DEBUG
> +#define DPRINTK(format, args...) printk(format, ##args)
> +#else
> +#define DPRINTK(format, args...)
> +#endif
> +
> +/* socket register */
> +#define CH_BASE                (0x200)
> +
> +/* size of each channel register map */
> +#define CH_SIZE                0x40
> +
> +/* Mode Register address */
> +#define MR             (0)
> +#define MR1            (MR + 1)
> +
> +#define IDM_AR         (0x02)
> +#define IDM_AR1                (IDM_AR + 1)
> +
> +#define IDM_DR         (0x04)
> +#define IDM_DR1                (IDM_DR + 1)
> +
> +/* Interrupt Register */
> +#define IR             (0x02)
> +#define IR1            (IR + 1);
> +
> +/*  Interrupt mask register */
> +#define IMR            (0x04)
> +#define IMR1   (IMR + 1)
> +
> +/* Interrupt mask register */
> +#define STAR           (0x06)
> +#define STAR1          (STAR + 1)
> +
> +/*  Source MAC Register address */
> +#define SHAR           (0x08)
> +#define SHAR1          (SHAR + 1)
> +#define SHAR2          (SHAR + 2)
> +#define SHAR3          (SHAR + 3)
> +#define SHAR4          (SHAR + 4)
> +#define SHAR5          (SHAR + 5)
> +
> +/* Gateway IP Register address */
> +#define GAR            (0x10)
> +#define GAR1           (GAR + 1)
> +#define GAR2           (GAR + 2)
> +#define GAR3           (GAR + 3)
> +
> +/* Subnet mask Register address */
> +#define SUBR           (0x14)
> +#define SUBR1          (SUBR + 1)
> +#define SUBR2          (SUBR + 2)
> +#define SUBR3          (SUBR + 3)
> +
> +/* Source IP Register address */
> +#define SIPR           (0x18)
> +#define SIPR1          (SIPR + 1)
> +#define SIPR2          (SIPR + 2)
> +#define SIPR3          (SIPR + 3)
> +
> +/* Timeout register address(1 is 100us) */
> +#define RTR            (0x1C)
> +#define RTR1           (RTR + 1)
> +
> +/* Retry count reigster */
> +#define RCR            (0x1E)
> +#define RCR1           (RCR + 1)
> +
> +/* Transmit memory size reigster */
> +#define TMSR0          (0x20)
> +#define TMSR1          (TMSR0 + 1)
> +#define TMSR2          (TMSR0 + 2)
> +#define TMSR3          (TMSR0 + 3)
> +#define TMSR4          (TMSR0 + 4)
> +#define TMSR5          (TMSR0 + 5)
> +#define TMSR6          (TMSR0 + 6)
> +#define TMSR7          (TMSR0 + 7)
> +
> +#define TMSR_01                (0x20)
> +#define TMSR_23                (TMSR_01 + 2)
> +#define TMSR_45                (TMSR_01 + 4)
> +#define TMSR_67                (TMSR_01 + 6)
> +
> +/* Receive memory size reigster */
> +#define RMSR0          (0x28)
> +#define RMSR1          (RMSR0 + 1)
> +#define RMSR2          (RMSR0 + 2)
> +#define RMSR3          (RMSR0 + 3)
> +#define RMSR4          (RMSR0 + 4)
> +#define RMSR5          (RMSR0 + 5)
> +#define RMSR6          (RMSR0 + 6)
> +#define RMSR7          (RMSR0 + 7)
> +
> +#define RMSR_01                (0x28)
> +#define RMSR_23                (RMSR_01 + 2)
> +#define RMSR_45                (RMSR_01 + 4)
> +#define RMSR_67                (RMSR_01 + 6)
> +
> +/* Memory Type Register
> + * '1' - TX memory
> + * '0' - RX memory */
> +#define MTYPER         (0x30)
> +#define MYYPER1                (MTYPER + 1)
> +
> +/* Authentication type register address in PPPoE mode */
> +#define PATR           (0x32)
> +#define PATR1          (PATR + 1)
> +
> +#define PTIMER         (0x36)
> +#define PTIMER1                (PTIMER + 1)
> +
> +#define PMAGIC         (0x38)
> +#define PMAGIC1                (PMAGIC + 1)
> +
> +/* PPPoE session ID register */
> +#define PSIDR           (0x3C)
> +#define PSIDR1          (PSIDR + 1)
> +
> +/* PPPoE destination hardware address register */
> +#define PDHAR           (0x40)
> +#define PDHAR0          PDHAR
> +#define PDHAR1          (PDHAR + 1)
> +#define PDHAR2          (PDHAR + 2)
> +#define PDHAR3          (PDHAR + 3)
> +#define PDHAR4          (PDHAR + 4)
> +#define PDHAR5          (PDHAR + 5)
> +
> +/* Unreachable IP register address in UDP mode */
> +#define UIPR           (0x48)
> +#define UIPR1          (UIPR + 1)
> +#define UIPR2          (UIPR + 2)
> +#define UIPR3          (UIPR + 3)
> +
> +/* Unreachable Port register address in UDP mode */
> +#define UPORT          (0x4C)
> +#define UPORT1         (UPORT + 1)
> +
> +/* Fragment register */
> +#define FMTUR          (0x4E)
> +#define FMTUR1         (FMTUR + 1)
> +
> +/* PIN 'BRDYn' configure register */
> +#define Pn_BRDYR(n)     (0x60 + n*4)
> +#define Pn_BRDYR1(n)    (Pn_BRDYR(n) + 1)
> +
> +/* PIN 'BRDYn' buffer depth register */
> +#define Pn_BDPTHR(n)    (0x62 + n*4)
> +#define Pn_BDPTHR1(n)   (Pn_BDPTHR(n) + 1)
> +
> +/* Chip ID register(=0x5300) */
> +#define IDR            (0xFE)
> +#define IDR1           (IDR + 1)
> +
> +/* socket Mode register */
> +#define Sn_MR(ch)      (CH_BASE + ch * CH_SIZE + 0x00)
> +#define Sn_MR1(ch)     (Sn_MR(ch)+1)
> +
> +/* socket command register */
> +#define Sn_CR(ch)      (CH_BASE + ch * CH_SIZE + 0x02)
> +#define Sn_CR1(ch)     (Sn_CR(ch)+1);
> +
> +/* socket interrupt mask register */
> +#define Sn_IMR(ch)     (CH_BASE + ch * CH_SIZE + 0x04)
> +#define Sn_IMR1(ch)    (Sn_IMR(ch)+1)
> +
> +/* socket interrupt register */
> +#define Sn_IR(ch)      (CH_BASE + ch * CH_SIZE + 0x06)
> +#define Sn_IR1(ch)     (Sn_IR(ch)+1)
> +
> +/* socket status register */
> +#define Sn_SSR(ch)     (CH_BASE + ch * CH_SIZE + 0x08)
> +#define Sn_SSR1(ch)    (Sn_SSR(ch)+1);
> +
> +/* source port register */
> +#define Sn_PORTR(ch)   (CH_BASE + ch * CH_SIZE + 0x0A)
> +#define Sn_PORTR1(ch)  (Sn_PORTR(ch)+1)
> +
> +/* Peer MAC register address */
> +#define Sn_DHAR(ch)    (CH_BASE + ch * CH_SIZE + 0x0C)
> +#define Sn_DHAR1(ch)   (Sn_DHAR(ch)+1)
> +#define Sn_DHAR2(ch)   (Sn_DHAR(ch)+2)
> +#define Sn_DHAR3(ch)   (Sn_DHAR(ch)+3)
> +#define Sn_DHAR4(ch)   (Sn_DHAR(ch)+4)
> +#define Sn_DHAR5(ch)   (Sn_DHAR(ch)+5)
> +
> +/* Peer port register address */
> +#define Sn_DPORTR(ch)  (CH_BASE + ch * CH_SIZE + 0x12)
> +#define Sn_DPORTR1(ch) (Sn_DPORTR(ch)+1)
> +
> +/* Peer IP register address */
> +#define Sn_DIPR(ch)    (CH_BASE + ch * CH_SIZE + 0x14)
> +#define Sn_DIPR1(ch)   (Sn_DIPR(ch)+1)
> +#define Sn_DIPR2(ch)   (Sn_DIPR(ch)+2)
> +#define Sn_DIPR3(ch)   (Sn_DIPR(ch)+3)
> +
> +/* Maximum Segment Size(Sn_MSSR0) register address */
> +#define Sn_MSSR(ch)    (CH_BASE + ch * CH_SIZE + 0x18)
> +#define Sn_MSSR1(ch)   (Sn_MSSR(ch)+1)
> +
> +/* Protocol of IP Header field register in IP raw mode */
> +#define Sn_PROTOR(ch)  (CH_BASE + ch * CH_SIZE + 0x1A)
> +#define Sn_PROTOR1(ch) (Sn_PROTOR(ch)+1)
> +
> +/* Socket keep alive timer register */
> +#define Sn_KPALVTR(ch)  Sn_PROTOR(ch)
> +
> +/* IP Type of Service(TOS) Register */
> +#define Sn_TOSR(ch)    (CH_BASE + ch * CH_SIZE + 0x1C)
> +#define Sn_TOSR1(ch)   (Sn_TOSR(ch)+1)
> +
> +/* IP Time to live(TTL) Register */
> +#define Sn_TTLR(ch)    (CH_BASE + ch * CH_SIZE + 0x1E)
> +#define Sn_TTLR1(ch)   (Sn_TTLR(ch)+1)
> +
> +/* Transmit Size Register (Byte count) */
> +#define Sn_TX_WRSR(ch) (CH_BASE + ch * CH_SIZE + 0x20)
> +#define Sn_TX_WRSR1(ch)        (Sn_TX_WRSR(ch) + 1)
> +#define Sn_TX_WRSR2(ch)        (Sn_TX_WRSR(ch) + 2)
> +#define Sn_TX_WRSR3(ch)        (Sn_TX_WRSR(ch) + 3)
> +
> +/* Transmit free memory size register (Byte count) */
> +#define Sn_TX_FSR(ch)  (CH_BASE + ch * CH_SIZE + 0x24)
> +#define Sn_TX_FSR1(ch) (Sn_TX_FSR(ch) + 1)
> +#define Sn_TX_FSR2(ch) (Sn_TX_FSR(ch) + 2)
> +#define Sn_TX_FSR3(ch) (Sn_TX_FSR(ch) + 3)
> +
> +/* Received data size register (Byte count) */
> +#define Sn_RX_RSR(ch)  (CH_BASE + ch * CH_SIZE + 0x28)
> +#define Sn_RX_RSR1(ch) (Sn_RX_RSR(ch) + 1)
> +#define Sn_RX_RSR2(ch) (Sn_RX_RSR(ch) + 2)
> +#define Sn_RX_RSR3(ch) (Sn_RX_RSR(ch) + 3)
> +
> +/* Socket fragment register */
> +#define Sn_FRAGR(ch)    (CH_BASE + ch * CH_SIZE + 0x2C)
> +#define Sn_FRAGR1(ch)   (Sn_FRAGR(ch) + 1)
> +
> +/* FIFO register for Transmit */
> +#define Sn_TX_FIFO(ch) (CH_BASE + ch * CH_SIZE + 0x2E)
> +#define Sn_TX_FIFO1(ch)        (Sn_TX_FIFO(ch) + 1)
> +
> +/* FIFO register for Receive */
> +#define Sn_RX_FIFO(ch) (CH_BASE + ch * CH_SIZE + 0x30)
> +#define Sn_RX_FIFO1(ch)        (Sn_RX_FIFO(ch) + 1)
> +
> +/* MODE register values */
> +#define MR_DBW    (1 << 15) /**< Data bus width bit of MR. */
> +#define MR_MPF    (1 << 14) /**< Mac layer pause frame bit of MR. */
> +#define MR_WDF(x) ((x & 0x07) << 11) /**< Write data fetch time bit of  MR. */
> +#define MR_RDH    (1 << 10) /**< Read data hold time bit of MR. */
> +#define MR_FS     (1 << 8)  /**< FIFO swap bit of MR. */
> +#define MR_RST    (1 << 7)  /**< S/W reset bit of MR. */
> +#define MR_MT     (1 << 5)  /**< Memory test bit of MR. */
> +#define MR_PB     (1 << 4)  /**< Ping block bit of MR. */
> +#define MR_PPPoE  (1 << 3)  /**< PPPoE bit of MR. */
> +#define MR_DBS    (1 << 2)  /**< Data bus swap of MR. */
> +#define MR_IND    (1 << 0)  /**< Indirect mode bit of MR. */
> +
> +/* IR register values */
> +#define IR_IPCF     (1 << 7)   /**< IP conflict bit of IR. */
> +#define IR_DPUR     (1 << 6)   /**< Destination port unreachable bit of IR. */
> +#define IR_PPPT     (1 << 5)   /**< PPPoE terminate bit of IR. */
> +#define IR_FMTU     (1 << 4)   /**< Fragment MTU bit of IR. */
> +#define IR_SnINT(n) (0x01 << n)        /**< SOCKETn interrupt occurrence bit of IR. */
> +
> +/* Pn_BRDYR values */
> +#define Pn_PEN      (1 << 7)   /**< PIN 'BRDYn' enable bit of Pn_BRDYR. */
> +#define Pn_MT       (1 << 6)   /**< PIN memory type bit of Pn_BRDYR. */
> +#define Pn_PPL      (1 << 5)   /**< PIN Polarity bit of Pn_BRDYR. */
> +#define Pn_SN(n)    ((n & 0x07) << 0)  /**< PIN Polarity bit of Pn_BRDYR. */
> +
> +/* Sn_MR values */
> +#define Sn_MR_ALIGN     (1 << 8)  /**< Alignment bit of Sn_MR. */
> +#define Sn_MR_MULTI     (1 << 7)  /**< Multicasting bit of Sn_MR. */
> +#define Sn_MR_MF        (1 << 6)  /**< MAC filter bit of Sn_MR. */
> +#define Sn_MR_IGMPv     (1 << 5)  /**< IGMP version bit of Sn_MR. */
> +#define Sn_MR_ND        (1 << 5)  /**< No delayed ack bit of Sn_MR. */
> +#define Sn_MR_CLOSE     0x00     /**< Protocol bits of Sn_MR. */
> +#define Sn_MR_TCP       0x01     /**< Protocol bits of Sn_MR. */
> +#define Sn_MR_UDP       0x02     /**< Protocol bits of Sn_MR. */
> +#define Sn_MR_IPRAW     0x03     /**< Protocol bits of Sn_MR. */
> +#define Sn_MR_MACRAW    0x04     /**< Protocol bits of Sn_MR. */
> +#define Sn_MR_MACRAW_MF 0x44     /**< Protocol bits of Sn_MR  */
> +#define Sn_MR_PPPoE     0x05     /**< Protocol bits of Sn_MR. */
> +
> +/* Sn_CR values */
> +#define Sn_CR_OPEN      0x01   /**< OPEN command value of Sn_CR. */
> +#define Sn_CR_LISTEN    0x02   /**< LISTEN command value of Sn_CR. */
> +#define Sn_CR_CONNECT   0x04   /**< CONNECT command value of Sn_CR. */
> +#define Sn_CR_DISCON    0x08   /**< DISCONNECT command value of Sn_CR. */
> +#define Sn_CR_CLOSE     0x10   /**< CLOSE command value of Sn_CR. */
> +#define Sn_CR_SEND      0x20   /**< SEND command value of Sn_CR. */
> +#define Sn_CR_SEND_MAC  0x21   /**< SEND_MAC command value of Sn_CR. */
> +#define Sn_CR_SEND_KEEP 0x22   /**< SEND_KEEP command value of Sn_CR */
> +#define Sn_CR_RECV      0x40   /**< RECV command value of Sn_CR */
> +#define Sn_CR_PCON      0x23   /**< PCON command value of Sn_CR */
> +#define Sn_CR_PDISCON   0x24   /**< PDISCON command value of Sn_CR */
> +#define Sn_CR_PCR       0x25   /**< PCR command value of Sn_CR */
> +#define Sn_CR_PCN       0x26   /**< PCN command value of Sn_CR */
> +#define Sn_CR_PCJ       0x27   /**< PCJ command value of Sn_CR */
> +
> +/* Sn_IR values */
> +#define Sn_IR_PRECV     0x80   /**< PPP receive bit of Sn_IR */
> +#define Sn_IR_PFAIL     0x40   /**< PPP fail bit of Sn_IR */
> +#define Sn_IR_PNEXT     0x20   /**< PPP next phase bit of Sn_IR */
> +#define Sn_IR_SENDOK    0x10   /**< Send OK bit of Sn_IR */
> +#define Sn_IR_TIMEOUT   0x08   /**< Timout bit of Sn_IR */
> +#define Sn_IR_RECV      0x04   /**< Receive bit of Sn_IR */
> +#define Sn_IR_DISCON    0x02   /**< Disconnect bit of Sn_IR */
> +#define Sn_IR_CON       0x01   /**< Connect bit of Sn_IR */
> +
> +/* Sn_SSR values */
> +#define SOCK_CLOSED      0x00  /**< SOCKETn is released */
> +#define SOCK_ARP         0x01  /**< ARP-request is transmitted in order to acquire destination hardware address. */
> +#define SOCK_INIT        0x13  /**< SOCKETn is open as TCP mode. */
> +#define SOCK_LISTEN      0x14  /**< SOCKETn operates as "TCP SERVER" and waits for connection-request (SYN packet) from "TCP CLIENT". */
> +#define SOCK_SYNSENT     0x15  /**< Connect-request(SYN packet) is transmitted to "TCP SERVER". */
> +#define SOCK_SYNRECV     0x16  /**< Connect-request(SYN packet) is received from "TCP CLIENT". */
> +#define SOCK_ESTABLISHED 0x17  /**< TCP connection is established. */
> +#define SOCK_FIN_WAIT    0x18  /**< SOCKETn is closing. */
> +#define SOCK_CLOSING     0x1A  /**< SOCKETn is closing. */
> +#define SOCK_TIME_WAIT   0x1B  /**< SOCKETn is closing. */
> +#define SOCK_CLOSE_WAIT  0x1C  /**< Disconnect-request(FIN packet) is received from the peer. */
> +#define SOCK_LAST_ACK    0x1D  /**< SOCKETn is closing. */
> +#define SOCK_UDP         0x22  /**< SOCKETn is open as UDP mode. */
> +#define SOCK_IPRAW       0x32  /**< SOCKETn is open as IPRAW mode. */
> +#define SOCK_MACRAW      0x42  /**< SOCKET0 is open as MACRAW mode. */
> +#define SOCK_PPPoE       0x5F  /**< SOCKET0 is open as PPPoE mode. */
> +
> +/* IP PROTOCOL */
> +#define IPPROTO_IP     0       /* Dummy for IP */
> +#define IPPROTO_ICMP   1       /* Control message protocol */
> +#define IPPROTO_IGMP   2       /* Internet group management protocol */
> +#define IPPROTO_GGP    3       /* Gateway^2 (deprecated) */
> +#define IPPROTO_TCP    6       /* TCP */
> +#define IPPROTO_PUP    12      /* PUP */
> +#define IPPROTO_UDP    17      /* UDP */
> +#define IPPROTO_IDP    22      /* XNS idp */
> +#define IPPROTO_ND     77      /* UNOFFICIAL net disk protocol */
> +#define IPPROTO_RAW    255     /* Raw IP packet */
> +
> +/* W5300 Register READ/WRITE funtions(Just 16 bit interface). */
> +#define w5300_write(wp, addr, val) writew(val, (wp->base + addr))
> +#define w5300_read(wp, addr) readw((wp->base + addr))
> +
> +#endif /* _W5300_H_ */
> --
> 1.7.1
>
>

Hi.

Please check this patch. Not only it had been finished testing, but
also confirmed by WIZnet(http://wiznet.co.kr).

If any problems, please let me know.

Best Regards,

Taehun Kim.
