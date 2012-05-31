Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab2EaPpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 11:45:53 -0400
Received: from slapinbuild.ihdev.net ([46.4.202.25]:55458 "EHLO
	build.ossfans.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932609Ab2EaPps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 11:45:48 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 May 2012 11:45:44 EDT
From: Sergey Lapin <slapin@ossfans.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, linux-x25@vger.kernel.org,
        Sergey Lapin <slapin@ossfans.org>
Subject: [PATCH 2/2] lapb-nl: Added driver
Date: Thu, 31 May 2012 11:31:18 -0400
Message-Id: <1338478278-24732-2-git-send-email-slapin@ossfans.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1338478278-24732-1-git-send-email-slapin@ossfans.org>
References: <1338478278-24732-1-git-send-email-slapin@ossfans.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds driver which allows transfers using LAPB
over serial lines.

The protocol is used in interconnection of transport
tracking devices with electronic payment system using
hard-wired cables and RS-232 interface, but might
be useful for anybody requiring simple protocol for reliable
(with delivery guarantee) data exchange.

Main way to use this driver is via NETLINK interface, but
UDP also can be used if appropriate config option is enabled.

Signed-off-by: Sergey Lapin <slapin@ossfans.org>
---
 drivers/net/wan/Kconfig          |   26 +++
 drivers/net/wan/Makefile         |    3 +
 drivers/net/wan/lapb-nl-ldisc.c  |  458 ++++++++++++++++++++++++++++++++++++++
 drivers/net/wan/lapb-nl-netdev.c |  415 ++++++++++++++++++++++++++++++++++
 drivers/net/wan/lapb-nl.c        |  326 +++++++++++++++++++++++++++
 drivers/net/wan/lapb-nl.h        |   81 +++++++
 include/linux/tty.h              |    1 +
 include/net/lapb.h               |    1 +
 8 files changed, 1311 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wan/lapb-nl-ldisc.c
 create mode 100644 drivers/net/wan/lapb-nl-netdev.c
 create mode 100644 drivers/net/wan/lapb-nl.c
 create mode 100644 drivers/net/wan/lapb-nl.h

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index d58431e..f94702d 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -442,6 +442,32 @@ config X25_ASY
 
 	  If unsure, say N.
 
+config LAPB_NL
+	tristate "Transfer IP UDP and NETLINK frames with LAPB encapsulation"
+	depends on LAPB
+	select CRC_ITU_T
+	---help---
+	  This driver allows UDP or NETLINK application to transfer data over
+	  serial port using LAPB for delivery guarantee. This allows use LAPB
+	  features without deploying full X.25 stack and use equipment, which
+	  implements LAPB, but not X.25 framing, using custom protocol on top
+	  of LAPB.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called mod-lapb-nl.
+
+	  If unsure, say N.
+
+config LAPB_NL_WANTS_UDP
+	bool "Use UDP among with NETLINK protocol to send/receive over UDP"
+	depends on LAPB_NL
+	---help---
+	  This allows using UDP among NETLINK to send and receive data over
+	  serial line using LAPB protocol. It uses fixed IP addresses
+	  and port numbers for that.
+
+	  If you don't need this, say N.
+
 config SBNI
 	tristate "Granch SBNI12 Leased Line adapter support"
 	depends on X86
diff --git a/drivers/net/wan/Makefile b/drivers/net/wan/Makefile
index eac709b..dcbb6c5 100644
--- a/drivers/net/wan/Makefile
+++ b/drivers/net/wan/Makefile
@@ -23,6 +23,9 @@ obj-$(CONFIG_COSA)		+= cosa.o
 obj-$(CONFIG_FARSYNC)		+= farsync.o
 obj-$(CONFIG_DSCC4)             += dscc4.o
 obj-$(CONFIG_X25_ASY)		+= x25_asy.o
+mod-lapb-nl-objs		:= lapb-nl-netdev.o lapb-nl-ldisc.o
+mod-lapb-nl-objs		+= lapb-nl.o
+obj-$(CONFIG_LAPB_NL)		+= mod-lapb-nl.o
 
 obj-$(CONFIG_LANMEDIA)		+= lmc/
 
diff --git a/drivers/net/wan/lapb-nl-ldisc.c b/drivers/net/wan/lapb-nl-ldisc.c
new file mode 100644
index 0000000..0d801fb
--- /dev/null
+++ b/drivers/net/wan/lapb-nl-ldisc.c
@@ -0,0 +1,458 @@
+#define DEBUG
+#include <linux/module.h>
+
+#include <asm/system.h>
+#include <linux/uaccess.h>
+#include <linux/bitops.h>
+#include <linux/string.h>
+#include <linux/mm.h>
+#include <linux/interrupt.h>
+#include <linux/in.h>
+#include <linux/tty.h>
+#include <linux/errno.h>
+#include <linux/netdevice.h>
+#include <linux/etherdevice.h>
+#include <linux/skbuff.h>
+#include <linux/if_arp.h>
+#include <linux/lapb.h>
+#include <linux/init.h>
+#include <linux/rtnetlink.h>
+#include <linux/compat.h>
+#include <linux/slab.h>
+#include <linux/crc-itu-t.h>
+#include <linux/kfifo.h>
+#include <linux/miscdevice.h>
+#include <linux/poll.h>
+#include <linux/wait.h>
+#include <net/lapb.h>
+
+/* X25 async protocol characters. */
+#define X25_END		0x7E	/* indicates end of frame	*/
+#define X25_ESC		0x7D	/* indicates byte stuffing	*/
+#define X25_ESCAPE(x)	((x)^0x20)
+#define X25_UNESCAPE(x)	((x)^0x20)
+
+struct lapb_nl_ldisc {
+	int magic;
+#define LAPB_LDISC_MAGIC	0x5511
+	struct net_device *netdev;
+	struct tty_struct *tty;
+	size_t rcount;
+	u8 *rbuff;
+	size_t buffsize;
+	unsigned long flags;
+	int xleft;
+	u8 *xhead;
+	unsigned char *xbuff;
+	spinlock_t lock;
+#define SLF_INUSE	0	/* Channel in use		*/
+#define SLF_ESCAPE	1	/* ESC received			*/
+#define SLF_ERROR	2	/* Parity, etc. error		*/
+#define SLF_OUTWAIT	4	/* Waiting for output		*/
+};
+
+static void lapb_unesc(struct lapb_nl_ldisc *sl, unsigned char s)
+{
+	BUG_ON(!sl);
+	switch (s) {
+	case X25_END:
+		if (!test_and_clear_bit(SLF_ERROR, &sl->flags) &&
+		    sl->rcount >= 4)
+			lapb_bump(sl->netdev, sl->rbuff, sl->rcount);
+		clear_bit(SLF_ESCAPE, &sl->flags);
+		sl->rcount = 0;
+		return;
+	case X25_ESC:
+		set_bit(SLF_ESCAPE, &sl->flags);
+		return;
+	case X25_ESCAPE(X25_ESC):
+	case X25_ESCAPE(X25_END):
+		if (test_and_clear_bit(SLF_ESCAPE, &sl->flags))
+			s = X25_UNESCAPE(s);
+		break;
+	}
+	if (!test_bit(SLF_ERROR, &sl->flags)) {
+		if (sl->rcount < sl->buffsize) {
+			sl->rbuff[sl->rcount++] = s;
+			return;
+		}
+		sl->netdev->stats.rx_over_errors++;
+		set_bit(SLF_ERROR, &sl->flags);
+	}
+}
+
+static void lapb_ldisc_write_wakeup(struct tty_struct *tty)
+{
+	int actual;
+	struct lapb_nl_ldisc *sl;
+	BUG_ON(!tty);
+	sl = tty->disc_data;
+	BUG_ON(!sl);
+
+	/* First make sure we're connected. */
+	if (!sl || sl->magic != LAPB_LDISC_MAGIC || !(sl->netdev))
+		return;
+
+	if (sl->xleft <= 0) {
+		sl->netdev->stats.tx_packets++;
+		clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
+		return;
+	}
+
+	actual = tty->ops->write(tty, sl->xhead, sl->xleft);
+	sl->xleft -= actual;
+	sl->xhead += actual;
+}
+
+static void lapb_ldisc_receive_buf(struct tty_struct *tty,
+				   const unsigned char *cp,
+				   char *fp, int count)
+{
+	struct lapb_nl_ldisc *sl;
+	BUG_ON(!tty);
+	sl = tty->disc_data;
+	BUG_ON(!sl);
+
+	BUG_ON(!sl || sl->magic != LAPB_LDISC_MAGIC || !(sl->netdev));
+	dev_info(&sl->netdev->dev, "rx\n");
+
+	print_hex_dump(KERN_INFO, "ldisc in:",
+			DUMP_PREFIX_OFFSET, 16, 2, cp,
+			count, 0);
+
+	while (count--) {
+		if (fp && *fp++) {
+			if (!test_and_set_bit(SLF_ERROR, &sl->flags))
+				sl->netdev->stats.rx_errors++;
+			cp++;
+			continue;
+		}
+		lapb_unesc(sl, *cp++);
+	}
+}
+
+/* X.25 CCITT X.25 asynchronous framing requires bit-rotated checksum */
+static u16 lapb_word_reverse(u16 word)
+{
+	word = (word & 0x5555) << 1 | (word & 0xAAAA) >> 1;
+	word = (word & 0x3333) << 2 | (word & 0xCCCC) >> 2;
+	word = (word & 0x0F0F) << 4 | (word & 0xF0F0) >> 4;
+	word = (word & 0x00FF) << 8 | (word & 0xFF00) >> 8;
+
+	return word;
+}
+
+static int lapb_esc(unsigned char *s, unsigned char *d, int len)
+{
+	unsigned char *ptr = d;
+	unsigned char c;
+	unsigned char crc1b = 0;
+	unsigned char crc2b = 0;
+	u16 crc;
+	BUG_ON(!d);
+
+	crc = crc_itu_t(0xFFFF, s, len);
+
+	crc = lapb_word_reverse(crc);
+	crc1b = (unsigned char) crc & 0x00FF;
+	crc2b = crc >> 8;
+
+	*ptr++ = X25_END;
+
+	while (len-- > 0) {
+		switch (c = *s++) {
+		case X25_END:
+			*ptr++ = X25_ESC;
+			*ptr++ = X25_ESCAPE(X25_END);
+			break;
+		case X25_ESC:
+			*ptr++ = X25_ESC;
+			*ptr++ = X25_ESCAPE(X25_ESC);
+			break;
+		default:
+			*ptr++ = c;
+			break;
+		}
+	}
+	if (crc1b == 0x7e || crc1b == 0x7d) {
+		*ptr++ = 0x7d;
+		*ptr++ = crc1b ^ 0x20;
+	} else {
+		*ptr++ = crc1b;
+	}
+
+	if (crc2b == 0x7e || crc2b == 0x7d) {
+		*ptr++ = 0x7d;
+		*ptr++ = crc2b ^ 0x20;
+	} else {
+		*ptr++ = crc2b;
+	}
+	*ptr++ = X25_END;
+	return ptr - d;
+}
+
+int lapb_nl_ldisc_transmit(struct net_device *dev, u8 *data, size_t len)
+{
+	struct lapb_nl_ldisc *sl;
+	int actual, count;
+	BUG_ON(!dev);
+	sl = get_lapb_data(dev);
+	BUG_ON(!sl);
+	spin_lock(&sl->lock);
+	if (sl->tty == NULL) {
+		spin_unlock(&sl->lock);
+		dev_err(&dev->dev, "lapb: tbusy drop\n");
+		return -ENOTTY;
+	}
+	count = lapb_esc(data, sl->xbuff, len);
+
+	/* Order of next two lines is *very* important.^S */
+	set_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	actual = sl->tty->ops->write(sl->tty, sl->xbuff, count);
+	dev_info(&sl->netdev->dev, "tx\n");
+
+	print_hex_dump(KERN_INFO, "ldisc out:",
+			DUMP_PREFIX_OFFSET, 16, 2, sl->xbuff,
+			count, 0);
+	sl->xleft = count - actual;
+	sl->xhead = sl->xbuff + actual;
+	/* VSV */
+	clear_bit(SLF_OUTWAIT, &sl->flags);	/* reset outfill flag */
+	spin_unlock(&sl->lock);
+	return 0;
+}
+
+int lapb_nl_ldisc_change_buffers(struct net_device *dev, int len)
+{
+	struct lapb_nl_ldisc *sl;
+	unsigned char *xbuff, *rbuff;
+	BUG_ON(!dev);
+	sl = get_lapb_data(dev);
+	BUG_ON(!sl);
+
+	xbuff = kmalloc(len + 4, GFP_ATOMIC);
+	rbuff = kmalloc(len + 4, GFP_ATOMIC);
+
+	if (xbuff == NULL || rbuff == NULL) {
+		printk(KERN_WARNING
+			"%s: unable to grow buffers, MTU change cancelled.\n",
+		       dev->name);
+		kfree(xbuff);
+		kfree(rbuff);
+		return -ENOMEM;
+	}
+
+	spin_lock_bh(&sl->lock);
+	xbuff	 = xchg(&sl->xbuff, xbuff);
+	if (sl->xleft)	{
+		if (sl->xleft <= len)  {
+			memcpy(sl->xbuff, sl->xhead, sl->xleft);
+		} else	{
+			sl->xleft = 0;
+			dev->stats.tx_dropped++;
+		}
+	}
+	sl->xhead = sl->xbuff;
+
+	rbuff	 = xchg(&sl->rbuff, rbuff);
+	if (sl->rcount)  {
+		if (sl->rcount <= len) {
+			memcpy(sl->rbuff, rbuff, sl->rcount);
+		} else	{
+			sl->rcount = 0;
+			dev->stats.rx_over_errors++;
+			set_bit(SLF_ERROR, &sl->flags);
+		}
+	}
+
+	sl->buffsize = len;
+
+	spin_unlock_bh(&sl->lock);
+
+	kfree(xbuff);
+	kfree(rbuff);
+	return 0;
+}
+
+int lapb_nl_ldisc_start(struct net_device *dev)
+{
+	struct lapb_nl_ldisc *sl;
+	unsigned long len;
+	BUG_ON(!dev);
+	sl = get_lapb_data(dev);
+	BUG_ON(!sl);
+	if (sl->tty == NULL)
+		return -ENODEV;
+	len = dev->mtu * 2;
+	sl->rbuff = kmalloc(len + 4, GFP_KERNEL);
+	if (sl->rbuff == NULL)
+		goto norbuff;
+	sl->xbuff = kmalloc(len + 4, GFP_KERNEL);
+	if (sl->xbuff == NULL)
+		goto noxbuff;
+
+	sl->buffsize = len;
+	sl->rcount   = 0;
+	sl->xleft    = 0;
+	sl->flags   &= (1 << SLF_INUSE);      /* Clear ESCAPE & ERROR flags */
+	return 0;
+noxbuff:
+	kfree(sl->rbuff);
+norbuff:
+	return -ENOMEM;
+}
+
+int lapb_nl_ldisc_stop(struct net_device *dev)
+{
+	struct lapb_nl_ldisc *sl;
+	BUG_ON(!dev);
+	sl = get_lapb_data(dev);
+	BUG_ON(!sl);
+	spin_lock(&sl->lock);
+	if (sl->tty)
+		clear_bit(TTY_DO_WRITE_WAKEUP, &sl->tty->flags);
+	sl->rcount = 0;
+	sl->xleft = 0;
+	spin_unlock(&sl->lock);
+	return 0;
+}
+
+static int lapb_ldisc_open(struct tty_struct *tty)
+{
+	struct net_device *netdev;
+	struct lapb_nl_ldisc *sl;
+	int ret;
+	BUG_ON(!tty);
+	sl = tty->disc_data;
+
+	pr_debug("LAPB ldisc open\n");
+	if (tty->ops->write == NULL) {
+		ret = -EOPNOTSUPP;
+		goto err;
+	}
+
+	/* First make sure we're not already connected. */
+	if (sl && sl->magic == LAPB_LDISC_MAGIC) {
+		ret = -EEXIST;
+		goto err;
+	}
+
+	netdev = lapb_netdev_alloc();
+
+	if (!netdev) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	sl = kzalloc(sizeof(struct lapb_nl_ldisc), GFP_KERNEL);
+	sl->tty = tty;
+	sl->netdev = netdev;
+	sl->magic = LAPB_LDISC_MAGIC;
+	tty->disc_data = sl;
+	tty->receive_room = 65536;
+	tty_driver_flush_buffer(tty);
+	tty_ldisc_flush(tty);
+	set_lapb_data(netdev, sl);
+	rtnl_lock();
+	register_netdevice(netdev);
+	rtnl_unlock();
+
+	return 0;
+err:
+	pr_debug("ldisc: error exit with ret = %d\n", ret);
+	return ret;
+}
+
+static void lapb_ldisc_close(struct tty_struct *tty)
+{
+	struct lapb_nl_ldisc *sl = tty->disc_data;
+	pr_debug("LAPB ldisc close\n");
+
+	/* First make sure we're connected. */
+	if (!sl || sl->magic != LAPB_LDISC_MAGIC)
+		return;
+
+	dev_dbg(&sl->netdev->dev, "shutting down net device\n");
+	lapb_netdev_finish(sl->netdev);
+	rtnl_lock();
+	dev_close(sl->netdev);
+	/* Wait */
+	tty->disc_data = NULL;
+	sl->tty = NULL;
+	unregister_netdevice(sl->netdev);
+	rtnl_unlock();
+	free_netdev(sl->netdev);
+	pr_debug("LAPB ldisc closed\n");
+}
+
+static int lapb_ldisc_ioctl(struct tty_struct *tty, struct file *file,
+			    unsigned int cmd, unsigned long arg)
+{
+	struct lapb_nl_ldisc *sl = tty->disc_data;
+	BUG_ON(!sl);
+	dev_dbg(&sl->netdev->dev, "LAPB ldisc ioctl %04x\n", cmd);
+
+	/* First make sure we're connected. */
+	if (!sl || sl->magic != LAPB_LDISC_MAGIC)
+		return -EINVAL;
+	if (!sl->netdev)
+		return -EBUSY;
+
+	switch (cmd) {
+	case SIOCGIFNAME:
+		if (copy_to_user((void __user *)arg,
+			(void *)(sl->netdev->name),
+			strlen(sl->netdev->name) + 1))
+				return -EFAULT;
+		return 0;
+
+	default:
+		return tty_mode_ioctl(tty, file, cmd, arg);
+	}
+}
+
+#ifdef CONFIG_COMPAT
+static long lapb_ldisc_compat_ioctl(struct tty_struct *tty, struct file *file,
+				    unsigned int cmd, unsigned long arg)
+{
+	switch (cmd) {
+	case SIOCGX25PARMS:
+	case SIOCSX25PARMS:
+		return lapb_ldisc_ioctl(tty, file, cmd,
+				       (unsigned long)compat_ptr(arg));
+	}
+
+	return -ENOIOCTLCMD;
+}
+#endif
+static struct tty_ldisc_ops lapb_ldisc = {
+	.owner = THIS_MODULE,
+	.magic = TTY_LDISC_MAGIC,
+	.name = "LAPB",
+	.open = lapb_ldisc_open,
+	.close = lapb_ldisc_close,
+	.ioctl = lapb_ldisc_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = lapb_ldisc_compat_ioctl,
+#endif
+	.receive_buf = lapb_ldisc_receive_buf,
+	.write_wakeup = lapb_ldisc_write_wakeup,
+};
+
+static int __init init_lapb_ldisc(void)
+{
+	lapb_nl_init();
+	return tty_register_ldisc(N_LAPB, &lapb_ldisc);
+}
+
+static void __exit exit_lapb_ldisc(void)
+{
+	lapb_nl_exit();
+	tty_unregister_ldisc(N_LAPB);
+}
+
+module_init(init_lapb_ldisc);
+module_exit(exit_lapb_ldisc);
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Sergey Lapin <slapin@ossfans.org");
+MODULE_ALIAS_LDISC(N_LAPB);
diff --git a/drivers/net/wan/lapb-nl-netdev.c b/drivers/net/wan/lapb-nl-netdev.c
new file mode 100644
index 0000000..dc0e8a9
--- /dev/null
+++ b/drivers/net/wan/lapb-nl-netdev.c
@@ -0,0 +1,415 @@
+#include <linux/netdevice.h>
+#include <linux/skbuff.h>
+#include <linux/etherdevice.h>
+#include <net/lapb.h>
+#include <linux/lapb.h>
+#include <linux/spinlock.h>
+#include <linux/if_arp.h>
+#include <linux/inetdevice.h>
+#include <linux/crc-itu-t.h>
+#include <net/tcp.h>
+#include <net/udp.h>
+#include <asm/unaligned.h>
+#include <linux/completion.h>
+#include "lapb-nl.h"
+
+struct lapb_netdevpriv {
+	void *priv;
+	struct net_device *dev;
+	spinlock_t lock;
+
+	u8 udpheader[32];
+	void *lapb_data;
+	int flow_enabled;
+	int closing;
+	struct completion closed;
+};
+
+int lapb_get_flow_status(struct net_device *dev)
+{
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	return priv->flow_enabled;
+}
+
+void lapb_set_flow_status(struct net_device *dev, int status)
+{
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	priv->flow_enabled = status;
+}
+
+void set_lapb_data(struct net_device *dev, void *ptr)
+{
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	priv->lapb_data = ptr;
+}
+
+void *get_lapb_data(struct net_device *dev)
+{
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	return priv->lapb_data;
+}
+
+/* X.25 CCITT X.25 asynchronous framing requires bit-rotated checksum */
+static u16 lapb_word_reverse(u16 word)
+{
+	word = (word & 0x5555) << 1 | (word & 0xAAAA) >> 1;
+	word = (word & 0x3333) << 2 | (word & 0xCCCC) >> 2;
+	word = (word & 0x0F0F) << 4 | (word & 0xF0F0) >> 4;
+	word = (word & 0x00FF) << 8 | (word & 0xFF00) >> 8;
+
+	return word;
+}
+
+void lapb_bump(struct net_device *dev, void *data, int size)
+{
+	struct sk_buff *skb;
+	int err;
+	u16 calculated_crc, received_crc;
+	int ip_len = sizeof(struct udphdr) + sizeof(struct iphdr);
+	print_hex_dump(KERN_DEBUG, "lapb in:",
+			DUMP_PREFIX_OFFSET, 16, 2, data,
+			size, 1);
+	if (!(dev->flags & IFF_UP))
+		return;
+	calculated_crc = crc_itu_t(0xFFFF, data, size - 2);
+	received_crc = *(unsigned char *)(data + size - 1);
+	received_crc <<= 8;
+	received_crc |= *(unsigned char *)(data + size - 2);
+	received_crc = lapb_word_reverse(received_crc);
+	dev_info(&dev->dev, "lapb in calccrc: %04x\n", calculated_crc);
+	dev_info(&dev->dev, "lapb in recvcrc: %04x\n", received_crc);
+	if (calculated_crc != received_crc) {
+		dev_info(&dev->dev, "crc error\n");
+		dev->stats.rx_dropped++;
+	}
+	skb = dev_alloc_skb(ip_len + size - 2);
+	skb->dev = dev;
+	skb->protocol = htons(ETH_P_IP);
+	skb_reserve(skb, ip_len);
+	skb_copy_to_linear_data(skb, data, size - 2);
+	skb->len += size - 2;
+	err = lapb_data_received(dev, skb);
+	if (err != LAPB_OK) {
+		kfree_skb(skb);
+		dev_err(&dev->dev, "data error %d\n", err);
+	}
+}
+
+#ifdef CONFIG_LAPB_NL_WANTS_UDP
+static int lapb_netdev_rx(struct net_device *dev, struct sk_buff *skb)
+{
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	int ret, err;
+	struct udphdr *udph;
+	struct iphdr *iph;
+	int ip_len, udp_len;
+	struct in_device *indev;
+	struct lapb_parms_struct params;
+	__be32 local_ip, remote_ip;
+	if (!netif_running(dev)) {
+		dev_err(&dev->dev, "busy rx drop\n");
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
+	lapb_getparms(dev, &params);
+	dev_dbg(&dev->dev, "got datagram n2 = %d, n2count = %d\n", params.n2,
+			params.n2count);
+	print_hex_dump(KERN_DEBUG, "data in:",
+			DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+			skb->len, 1);
+	udp_len = skb->len + sizeof(struct udphdr);
+	ip_len = udp_len + sizeof(struct iphdr);
+	rcu_read_lock();
+	indev = __in_dev_get_rcu(dev);
+	if (!indev || !indev->ifa_list) {
+		rcu_read_unlock();
+		dev_err(&dev->dev, "no IP address\n");
+		ret = -EDESTADDRREQ;
+		if (indev)
+			in_dev_put(indev);
+		goto out;
+	}
+	local_ip = indev->ifa_list->ifa_address;
+	remote_ip = indev->ifa_list->ifa_local;
+	rcu_read_unlock();
+	dev_dbg(&dev->dev,
+		"local IP %pI4, remote IP %pI4\n", &local_ip,
+		&remote_ip);
+
+	/* UDP */
+	dev_dbg(&dev->dev,
+		"adding UDP header %d space left\n",
+				skb_headroom(skb));
+	skb_push(skb, sizeof(struct udphdr));
+	skb_reset_transport_header(skb);
+	udph = udp_hdr(skb);
+	/* FIXME */
+	udph->source = htons(0x4000);
+	udph->dest = htons(0x4000);
+	udph->len = htons(udp_len);
+	udph->check = 0;
+	udph->check = csum_tcpudp_magic(local_ip,
+					remote_ip,
+					udp_len, IPPROTO_UDP,
+					csum_partial(udph, udp_len, 0));
+	if (udph->check == 0)
+		udph->check = CSUM_MANGLED_0;
+
+	/* IP */
+	dev_dbg(&dev->dev, "adding IP header %d\n",
+				skb_headroom(skb));
+	skb_push(skb, sizeof(*iph));
+	skb_reset_network_header(skb);
+	iph = ip_hdr(skb);
+
+	/* iph->version = 4; iph->ihl = 5; */
+	put_unaligned(0x45, (unsigned char *)iph);
+	iph->tos      = 0;
+	put_unaligned(htons(ip_len), &(iph->tot_len));
+	iph->id       = 0;
+	iph->frag_off = 0;
+	iph->ttl      = 64;
+	iph->protocol = IPPROTO_UDP;
+	iph->check    = 0;
+	put_unaligned(local_ip, &(iph->saddr));
+	put_unaligned(remote_ip, &(iph->daddr));
+	iph->check    = ip_fast_csum((unsigned char *)iph, iph->ihl);
+	/* FIXME!!! */
+	ret = netif_rx(skb);
+	dev->last_rx = jiffies;
+out:
+	return ret;
+}
+#endif
+
+DEFINE_MUTEX(lapb_send_mutex);
+int lapb_send_data(struct net_device *dev, struct sk_buff *skb)
+{
+	int err;
+	mutex_lock(&lapb_send_mutex);
+	print_hex_dump(KERN_INFO, "lapb_send_data out:",
+		DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+		skb->len, 1);
+	err = lapb_data_request(dev, skb);
+	mutex_unlock(&lapb_send_mutex);
+	return err;
+}
+
+#ifdef CONFIG_LAPB_NL_WANTS_UDP
+static netdev_tx_t lapb_start_transmit(struct sk_buff *skb,
+					struct net_device *dev)
+{
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	int err;
+	struct iphdr *iph;
+
+	if (!netif_running(dev)) {
+		dev_dbg(&dev->dev, "busy drop\n");
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+	print_hex_dump(KERN_DEBUG, "udp out:",
+			DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+			skb->len, 1);
+	iph = ip_hdr(skb);
+	if (iph->protocol == IPPROTO_UDP) {
+		print_hex_dump(KERN_INFO, "data out:",
+			DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+			skb->len, 1);
+		skb_pull(skb, iph->ihl * 4 + sizeof(struct udphdr));
+		err = lapb_send_data(dev, skb);
+	} else {
+		dev_err(&dev->dev,
+			"invalid IP protocol here: %d\n",
+			iph->protocol);
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+	if (err != LAPB_OK) {
+		dev_err(&dev->dev, "lapb_data_request error: %d\n", err);
+		kfree_skb(skb);
+		return NETDEV_TX_OK;
+	}
+	return NETDEV_TX_OK;
+}
+#else
+#define lapb_start_transmit	NULL
+#endif
+
+
+/* FIXME: do locking */
+static int lapb_netdev_change_mtu(struct net_device *dev, int newmtu)
+{
+	int ret;
+	ret = lapb_nl_ldisc_change_buffers(dev, 2 * newmtu);
+	if (ret < 0)
+		return ret;
+	dev->mtu = newmtu;
+	return 0;
+}
+
+static void lapb_netdev_connected(struct net_device *dev, int reason)
+{
+	BUG_ON(!dev);
+	dev_dbg(&dev->dev, "connected\n");
+	lapb_nl_connected(dev, reason);
+	lapb_set_flow_status(dev, 0);
+}
+
+static void lapb_netdev_disconnected(struct net_device *dev, int reason)
+{
+	struct lapb_netdevpriv *priv;
+	BUG_ON(!dev);
+	priv = netdev_priv(dev);
+	dev_dbg(&dev->dev, "disconnected\n");
+	lapb_nl_disconnected(dev, reason);
+	if ((dev->flags & IFF_UP) && priv->closing == 0)
+		lapb_connect_request(dev);
+	if (priv->closing) {
+		priv->closing = 0;
+		complete(&priv->closed);
+	}
+}
+
+static int lapb_netdev_have_data(struct net_device *dev,
+				 struct sk_buff *skb)
+{
+	int ret;
+	if (!lapb_get_flow_status(dev)) {
+		dev_dbg(&dev->dev, "dropping\n");
+		goto fail;
+	}
+	print_hex_dump(KERN_INFO, "have data:",
+		DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+		skb->len, 0);
+	ret = lapb_nl_data_indication(dev, skb);
+	if (ret < 0)
+		goto fail;
+	lapb_set_flow_status(dev, 0);
+#ifdef CONFIG_LAPB_NL_WANTS_UDP
+	return lapb_netdev_rx(dev, skb);
+#else
+	return NETDEV_TX_OK;
+#endif
+fail:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static void lapb_netdev_transmit_data(struct net_device *dev,
+				      struct sk_buff *skb)
+{
+	if (!netif_running(dev)) {
+		dev_err(&dev->dev, "device is not running\n");
+		kfree_skb(skb);
+		return;
+	}
+	dev_dbg(&dev->dev, "transmitting\n");
+	print_hex_dump(KERN_DEBUG, "lapb out:",
+			DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+			skb->len, 1);
+	lapb_nl_ldisc_transmit(dev, skb->data, skb->len);
+	dev_dbg(&dev->dev, "transmission complete\n");
+}
+
+static void lapb_netdev_data_delivered(struct net_device *dev,
+				       struct sk_buff *skb)
+{
+	pr_debug("lapb_char data delivered\n");
+	lapb_nl_data_delivered(dev, skb);
+}
+
+static struct lapb_register_struct lapb_callbacks = {
+	.connect_confirmation = lapb_netdev_connected,
+	.connect_indication = lapb_netdev_connected,
+	.disconnect_confirmation = lapb_netdev_disconnected,
+	.disconnect_indication = lapb_netdev_disconnected,
+	.data_indication = lapb_netdev_have_data,
+	.data_transmit = lapb_netdev_transmit_data,
+	.data_delivered = lapb_netdev_data_delivered,
+};
+
+static int lapb_netdev_open(struct net_device *dev)
+{
+	int err, ret;
+	if (lapb_register(dev, &lapb_callbacks) != LAPB_OK) {
+		pr_debug("Failed to register net_device\n");
+		return -ENODEV;
+	}
+	ret = lapb_nl_ldisc_start(dev);
+	if (ret < 0)
+		return ret;
+	netif_start_queue(dev);
+	err = lapb_connect_request(dev);
+	if (err != LAPB_OK) {
+		dev_err(&dev->dev, "lapb_connect_request error: %d\n", err);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+int lapb_netdev_finish(struct net_device *dev)
+{
+	int err;
+	struct lapb_netdevpriv *priv = netdev_priv(dev);
+	priv->closing = 1;
+	init_completion(&priv->closed);
+	err = lapb_disconnect_request(dev);
+	if (err != LAPB_OK || err != LAPB_NOTCONNECTED) {
+		dev_err(&dev->dev, "lapb_disconnect_request error: %d\n", err);
+		return err;
+	}
+	wait_for_completion_timeout(&priv->closed, HZ * 20);
+	priv->closing = 0;
+	return 0;
+}
+
+static int lapb_netdev_close(struct net_device *dev)
+{
+	netif_stop_queue(dev);
+	lapb_unregister(dev);
+	return lapb_nl_ldisc_stop(dev);
+}
+
+
+static struct net_device_ops lapb_netdevops = {
+	.ndo_open = lapb_netdev_open,
+	.ndo_stop = lapb_netdev_close,
+	.ndo_start_xmit = lapb_start_transmit,
+	.ndo_set_mac_address = eth_mac_addr,
+	.ndo_change_mtu = lapb_netdev_change_mtu,
+};
+
+static void lapb_netdev_setup(struct net_device *dev)
+{
+	struct lapb_netdevpriv *priv;
+	priv = netdev_priv(dev);
+	priv->dev = dev;
+	ether_setup(dev);
+	dev->type = ARPHRD_LAPB;
+	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
+	dev->netdev_ops = &lapb_netdevops;
+}
+
+struct net_device *lapb_netdev_alloc(void)
+{
+	int ret = 0;
+	struct net_device *dev =
+	    alloc_netdev(sizeof(struct lapb_netdevpriv), "lapb%d",
+			 lapb_netdev_setup);
+	if (!dev) {
+		pr_debug("Failed to alloc net_device\n");
+		goto fault2;
+	}
+	if (strchr(dev->name, '%')) {
+		ret = dev_alloc_name(dev, dev->name);
+		if (ret < 0)
+			goto fault;
+	}
+	lapb_set_flow_status(dev, 0);
+	return dev;
+fault:
+	free_netdev(dev);
+fault2:
+	return NULL;
+}
diff --git a/drivers/net/wan/lapb-nl.c b/drivers/net/wan/lapb-nl.c
new file mode 100644
index 0000000..6c259f5
--- /dev/null
+++ b/drivers/net/wan/lapb-nl.c
@@ -0,0 +1,326 @@
+/*
+ *
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+#define DEBUG
+
+#include <linux/module.h>
+#include <linux/gfp.h>
+#include <linux/kernel.h>
+#include <linux/if_arp.h>
+#include <linux/netdevice.h>
+#include <linux/lapb.h>
+#include <net/netlink.h>
+#include <net/genetlink.h>
+#include <net/sock.h>
+
+#include "lapb-nl.h"
+
+#undef LAPB_NL_DEBUG_TIMER
+
+MODULE_LICENSE("GPL");
+
+static unsigned int lapb_seq_num;
+static DEFINE_SPINLOCK(lapb_seq_lock);
+
+static int lapb_nl_xon(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net_device *dev;
+	char name[IFNAMSIZ + 1];
+	if (info->attrs[LAPB_NL_ATTR_DEV_NAME]) {
+		nla_strlcpy(name, info->attrs[LAPB_NL_ATTR_DEV_NAME],
+				sizeof(name));
+		dev = dev_get_by_name(&init_net, name);
+		if (dev) {
+			lapb_set_flow_status(dev, 1);
+			dev_put(dev);
+		} else
+			pr_debug("XON command received with NULL dev\n");
+	}
+	return 0;
+}
+
+static int lapb_nl_xoff(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net_device *dev;
+	char name[IFNAMSIZ + 1];
+	pr_debug("XOFF command received\n");
+	if (info->attrs[LAPB_NL_ATTR_DEV_NAME]) {
+		nla_strlcpy(name, info->attrs[LAPB_NL_ATTR_DEV_NAME],
+				sizeof(name));
+		dev = dev_get_by_name(&init_net, name);
+		if (dev) {
+			lapb_set_flow_status(dev, 0);
+			dev_put(dev);
+		}
+	}
+	return 0;
+}
+
+DEFINE_MUTEX(xmit_mutex);
+static int lapb_nl_xmit(struct sk_buff *skb, struct genl_info *info)
+{
+	struct net_device *dev;
+	struct sk_buff *skb2;
+	char name[IFNAMSIZ + 1];
+	int err = -ENOMEM;
+	mutex_lock(&xmit_mutex);
+	print_hex_dump(KERN_DEBUG, "xmit in:",
+			DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+			skb->len, 1);
+	if (info->attrs[LAPB_NL_ATTR_DEV_NAME]) {
+		nla_strlcpy(name, info->attrs[LAPB_NL_ATTR_DEV_NAME],
+				sizeof(name));
+		dev = dev_get_by_name(&init_net, name);
+		if (!dev)
+			goto nodev;
+		if (!netif_running(dev))
+			goto ifdown;
+		if (info->attrs[LAPB_NL_ATTR_DATA] &&
+			nla_len(info->attrs[LAPB_NL_ATTR_DATA]) > 0) {
+			int size = nla_len(info->attrs[LAPB_NL_ATTR_DATA]);
+			pr_debug("size: %d\n", size);
+			skb2 = alloc_skb(size + 2, GFP_KERNEL);
+			skb_reserve(skb2, 2);
+			skb_put(skb2, size);
+			if (!skb2)
+				goto ifdown;
+			memcpy(skb2->data,
+				nla_data(info->attrs[LAPB_NL_ATTR_DATA]),
+					size);
+			pr_debug("skb2: len = %d\n", skb2->len);
+			print_hex_dump(KERN_DEBUG, "xmit out:",
+				DUMP_PREFIX_OFFSET, 16, 2, skb2->data,
+				skb2->len, 1);
+			err = lapb_send_data(dev, skb2);
+			if (err == LAPB_OK)
+				err = 0;
+			else
+				err = -ENOBUFS;
+		}
+ifdown:
+		dev_put(dev);
+	}
+nodev:
+	mutex_unlock(&xmit_mutex);
+	return err;
+}
+
+static struct genl_ops lapb_nl_ops[] = {
+	{
+		.cmd = LAPB_CMD_XON,
+		.doit = lapb_nl_xon,
+	},
+	{
+		.cmd = LAPB_CMD_XOFF,
+		.doit = lapb_nl_xoff,
+	},
+	{
+		.cmd = LAPB_CMD_XMIT,
+		.doit = lapb_nl_xmit,
+	},
+};
+
+static struct genl_family lapb_nl_family = {
+	.id = GENL_ID_GENERATE,
+	.name = LAPB_NL_NAME,
+	.hdrsize = 0,
+	.version = LAPB_NL_VERSION,
+	.maxattr = __LAPB_NL_ATTR_MAX,
+};
+
+static struct genl_multicast_group lapb_nl_coord_mcgrp = {
+	.name = LAPB_NL_NAME,
+};
+
+/* Requests to userspace */
+static struct sk_buff *lapb_nl_create(int flags, u8 req)
+{
+	void *hdr;
+	struct sk_buff *msg = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
+	unsigned long f;
+
+	if (!msg)
+		return NULL;
+
+	spin_lock_irqsave(&lapb_seq_lock, f);
+	hdr = genlmsg_put(msg, 0, lapb_seq_num++,
+			&lapb_nl_family, flags, req);
+	spin_unlock_irqrestore(&lapb_seq_lock, f);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return NULL;
+	}
+
+	return msg;
+}
+
+static int lapb_nl_mcast(struct sk_buff *msg, unsigned int group)
+{
+	/* XXX: nlh is right at the start of msg */
+	void *hdr = genlmsg_data(NLMSG_DATA(msg->data));
+
+	if (genlmsg_end(msg, hdr) < 0)
+		goto out;
+
+	print_hex_dump(KERN_DEBUG, "nl pkt:",
+		DUMP_PREFIX_OFFSET, 16, 2, msg->data,
+		msg->len, 1);
+
+	return genlmsg_multicast(msg, 0, group, GFP_ATOMIC);
+out:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+static int lapb_nl_event(struct net_device *dev, u8 status,
+			 int reason, struct sk_buff *skb)
+{
+	struct sk_buff *msg;
+
+	pr_debug("%s\n", __func__);
+
+	msg = lapb_nl_create(0, LAPB_NL_COMMAND_INDIC);
+	if (!msg)
+		return -ENOBUFS;
+
+	NLA_PUT_STRING(msg, LAPB_NL_ATTR_DEV_NAME, dev->name);
+	NLA_PUT_U32(msg, LAPB_NL_ATTR_DEV_INDEX, dev->ifindex);
+
+	NLA_PUT_U32(msg, LAPB_NL_ATTR_REASON, reason);
+	NLA_PUT_U8(msg, LAPB_NL_ATTR_STATUS, status);
+
+	if (skb) {
+		pr_debug("NETLINK %d bytes\n", skb->len);
+		print_hex_dump(KERN_INFO, "netlink out:",
+			DUMP_PREFIX_OFFSET, 16, 2, skb->data,
+			skb->len, 0);
+		NLA_PUT(msg, LAPB_NL_ATTR_DATA, skb->len, skb->data);
+	}
+
+	return lapb_nl_mcast(msg, lapb_nl_coord_mcgrp.id);
+
+nla_put_failure:
+	nlmsg_free(msg);
+	return -ENOBUFS;
+}
+
+int lapb_nl_data_indication(struct net_device *dev, struct sk_buff *skb)
+{
+	return lapb_nl_event(dev, LAPB_NL_EVENT_DATAIN, LAPB_OK, skb);
+}
+
+int lapb_nl_data_delivered(struct net_device *dev, struct sk_buff *skb)
+{
+	/* put packet */
+	dev->stats.tx_packets++;
+	dev->stats.tx_bytes += skb->len;
+	return lapb_nl_event(dev, LAPB_NL_EVENT_DATAOUT, LAPB_OK, skb);
+}
+
+int lapb_nl_connected(struct net_device *dev, int reason)
+{
+	return lapb_nl_event(dev, LAPB_NL_EVENT_CONNECTED, reason, NULL);
+}
+
+int lapb_nl_disconnected(struct net_device *dev, int reason)
+{
+	return lapb_nl_event(dev, LAPB_NL_EVENT_DISCONNECTED, reason, NULL);
+}
+
+#ifdef LAPB_NL_DEBUG_TIMER
+struct timer_list test_timer;
+
+static void test_timer_expiry(unsigned long param)
+{
+	int rc;
+	struct sk_buff *msg;
+	printk(KERN_INFO "Timer. Send message\n");
+	test_timer.expires  = jiffies + 1000 * 2;
+	add_timer(&test_timer);
+	msg = lapb_nl_create(0, LAPB_NL_COMMAND_INDIC);
+	if (!msg)
+		return;
+
+	NLA_PUT_STRING(msg, LAPB_NL_ATTR_DEV_NAME, "It's just a test");
+
+	NLA_PUT_STRING(msg, LAPB_NL_ATTR_DATA, "It's just a data");
+
+	rc = lapb_nl_mcast(msg, lapb_nl_coord_mcgrp.id);
+	if (rc < 0)
+		printk(KERN_INFO "error %d\n", rc);
+
+	return;
+
+nla_put_failure:
+	printk(KERN_INFO "nla_put_failure\n");
+	return;
+}
+#endif
+
+int __init lapb_nl_init(void)
+{
+	int rc, i;
+
+	printk(KERN_INFO "LAPB_NL: version 0.01 ALPHA ");
+
+	rc = genl_register_family(&lapb_nl_family);
+	if (rc)
+		goto fail;
+
+	for (i = 0; i < ARRAY_SIZE(lapb_nl_ops); i++) {
+		rc = genl_register_ops(&lapb_nl_family,
+				&lapb_nl_ops[i]);
+		if (rc)
+			goto fail;
+	}
+
+	rc = genl_register_mc_group(&lapb_nl_family, &lapb_nl_coord_mcgrp);
+	if (rc)
+		goto fail;
+#ifdef LAPB_NL_DEBUG_TIMER
+	init_timer(&test_timer);
+
+	test_timer.data     = 0;
+	test_timer.function = &test_timer_expiry;
+	test_timer.expires  = jiffies + 1000 * 2;
+
+	add_timer(&test_timer);
+#endif
+
+/*
+	rc = nl802154_mac_register();
+	if (rc)
+		goto fail;
+
+	rc = nl802154_phy_register();
+	if (rc)
+		goto fail;
+*/
+	return 0;
+
+fail:
+	genl_unregister_family(&lapb_nl_family);
+	return rc;
+}
+
+void __exit lapb_nl_exit(void)
+{
+#ifdef LAPB_NL_DEBUG_TIMER
+	del_timer(&test_timer);
+#endif
+	genl_unregister_family(&lapb_nl_family);
+}
diff --git a/drivers/net/wan/lapb-nl.h b/drivers/net/wan/lapb-nl.h
new file mode 100644
index 0000000..66bb7e9
--- /dev/null
+++ b/drivers/net/wan/lapb-nl.h
@@ -0,0 +1,81 @@
+/*
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+#ifndef LAPB_NL_H
+#define LAPB_NL_H
+
+#define LAPB_NL_NAME		"lapb"
+#define LAPB_NL_VERSION		1
+
+enum {
+	__LAPB_NL_ATTR_INVALID,
+	LAPB_NL_ATTR_DEV_NAME,
+	LAPB_NL_ATTR_DEV_INDEX,
+	LAPB_NL_ATTR_STATUS,
+	LAPB_NL_ATTR_REASON,
+	LAPB_NL_ATTR_DATA,
+	__LAPB_NL_ATTR_MAX,
+};
+
+#define LAPB_NL_ATTR_MAX (__LAPB_NL_ATTR_MAX - 1)
+
+enum {
+	__LAPB_NL_EVENT_INVALID,
+	LAPB_NL_EVENT_CONNECTED,
+	LAPB_NL_EVENT_DISCONNECTED,
+	LAPB_NL_EVENT_DATAIN,
+	LAPB_NL_EVENT_DATAOUT,
+	__LAPB_NL_EVENT_MAX,
+};
+
+enum {
+	__LAPB_NL_COMMAND_INVALID,
+	LAPB_NL_COMMAND_INDIC,
+	__LAPB_NL_CMD_MAX,
+};
+
+#define LAPB_NL_CMD_MAX (__LAPB_NL_CMD_MAX - 1)
+
+enum {
+	LAPB_CMD_XON,
+	LAPB_CMD_XOFF,
+	LAPB_CMD_XMIT,
+};
+
+void lapb_set_flow_status(struct net_device *dev, int s);
+int lapb_send_data(struct net_device *dev, struct sk_buff *skb);
+int lapb_nl_ldisc_transmit(struct net_device *dev,
+			 u8 *data, size_t len);
+int lapb_nl_ldisc_change_buffers(struct net_device *dev, int len);
+int lapb_nl_ldisc_start(struct net_device *dev);
+int lapb_nl_ldisc_stop(struct net_device *dev);
+
+int lapb_nl_data_indication(struct net_device *dev,
+			    struct sk_buff *skb);
+int lapb_nl_data_delivered(struct net_device *dev,
+			   struct sk_buff *skb);
+int lapb_nl_connected(struct net_device *dev, int reason);
+int lapb_nl_disconnected(struct net_device *dev, int reason);
+int lapb_netdev_finish(struct net_device *dev);
+void lapb_bump(struct net_device *dev, u8 *rbuff, size_t count);
+struct net_device *lapb_netdev_alloc(void);
+void set_lapb_data(struct net_device *dev, void *ptr);
+void *get_lapb_data(struct net_device *dev);
+
+int __init lapb_nl_init(void);
+void __exit lapb_nl_exit(void);
+#endif
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4990ef2..aa0d8bd 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -34,6 +34,7 @@
 #define N_TI_WL		22	/* for TI's WL BT, FM, GPS combo chips */
 #define N_TRACESINK	23	/* Trace data routing for MIPI P1149.7 */
 #define N_TRACEROUTER	24	/* Trace data routing for MIPI P1149.7 */
+#define N_LAPB		25	/* Lapb-nl interface */
 
 #ifdef __KERNEL__
 #include <linux/fs.h>
diff --git a/include/net/lapb.h b/include/net/lapb.h
index df892a9..6e36db8 100644
--- a/include/net/lapb.h
+++ b/include/net/lapb.h
@@ -111,6 +111,7 @@ extern void lapb_disconnect_confirmation(struct lapb_cb *lapb, int);
 extern void lapb_disconnect_indication(struct lapb_cb *lapb, int);
 extern int  lapb_data_indication(struct lapb_cb *lapb, struct sk_buff *);
 extern int  lapb_data_transmit(struct lapb_cb *lapb, struct sk_buff *);
+extern void lapb_data_delivered(struct lapb_cb *lapb, struct sk_buff *);
 
 /* lapb_in.c */
 extern void lapb_data_input(struct lapb_cb *lapb, struct sk_buff *);
-- 
1.7.5.4

