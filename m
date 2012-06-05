Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2FEXYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:24:53 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:39228 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab2FEXYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:24:52 -0400
Date: Wed, 6 Jun 2012 01:15:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: NOHZ: local_softirq_pending 08
Message-ID: <20120605231550.GA20981@electric-eye.fr.zoreil.com>
References: <20120530214809.GA19223@redhat.com> <alpine.LFD.2.02.1205310938080.3231@ionos> <20120601225754.GA25281@electric-eye.fr.zoreil.com> <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <CAB9dFdvWoc1onyWyy4BVmhpjeb5K2d10re0NcW-_NQCbfRC0hw@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Marc Dionne <marc.c.dionne@gmail.com> :
> If it helps, I've been seeing the same thing here on a system with an
> r8169.  The message appears consistently enough on network startup to
> be able to track it down to this specific commit:
>     98ddf986fca17840e46e070354b7e2cd2169da15: r8169: bh locking redux
> and task scheduling.
> 
> The softirq pending messages always come right after "link down"
> messages for the interface.

Let's see the traces.

I have added some code to trace the timing and values of the irq in
rtl8169_interrupt(). Patches against current git are attached.

This is the relevant part of kernel messages as seen through the serial
console:
[...]
[ 2441.972077] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[ 2441.977882] r8169 0000:01:00.0: enabling Mem-Wr-Inval
[ 2441.977939] r8169 0000:01:00.0: enabling bus mastering
[ 2441.978046] r8169 0000:01:00.0: irq 42 for MSI/MSI-X
[ 2441.979412] r8169 0000:01:00.0: eth0: RTL8168b/8111b at 0xffffc90000032000, 00:13:8f:ea:b1:5d, XID 18000000 IRQ 42
[ 2441.990081] r8169 0000:01:00.0: eth0: jumbo features [frames: 4080 bytes, tx checksumming: ko]
[...]
[ 2683.588223] r8169 0000:01:00.0: 8168b-lom: link down
[ 2683.593302] r8169 0000:01:00.0: 8168b-lom: link down
[ 2683.598341] NOHZ: local_softirq_pending 08
[ 2683.599356] IPv6: ADDRCONF(NETDEV_UP): 8168b-lom: link is not ready
[ 2685.779376] r8169 0000:01:00.0: 8168b-lom: link up
[ 2685.784824] IPv6: ADDRCONF(NETDEV_CHANGE): 8168b-lom: link becomes ready

Now the content of the IntrStatus register from rtl8169_interrupt() :

[35882] 0020 (LinkChg, see [ 2683.593302] r8169 ... 8168b-lom: link down)
[57792] 0020 (LinkChg, see [ 2685.779376] r8169 ... 8168b-lom: link up)
[57960] 0084
[64880] 0084
[74880] 0084
[06240] 0084
[14960] 0084
[55040] 0084


'ip link set dev 8168b-lom up' + 'cat /sys/kernel/debug/tracing/trace':

#                              _-----=> irqs-off
#                             / _----=> need-resched
#                            | / _---=> hardirq/softirq
#                            || / _--=> preempt-depth
#                            ||| /     delay
#           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
#              | |       |   ||||       |         |
[...]
          <idle>-0     [001] d..1  2681.581946: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
              ip-1437  [000] ...1  2681.582967: rtl8169_get_stats64 <-dev_get_stats
              ip-1437  [000] ...1  2681.582974: rtl8169_get_stats64 <-dev_get_stats
              ip-1437  [000] ...1  2681.582990: rtl8169_get_stats64 <-dev_get_stats
              ip-1437  [000] ...1  2681.582996: rtl8169_get_stats64 <-dev_get_stats
              ip-1437  [000] ...1  2681.583002: rtl8169_get_stats64 <-dev_get_stats
              ip-1437  [000] ....  2681.583146: rtl_device_event <-notifier_call_chain
              ip-1437  [000] ....  2681.583148: rtl_open <-__dev_open
              ip-1437  [000] ....  2681.583153: rtl8169_init_ring <-rtl_open
              ip-1437  [000] ....  2681.583155: rtl8169_alloc_rx_data <-rtl8169_init_ring
[...]
              ip-1437  [000] ....  2681.583497: rtl8169_alloc_rx_data <-rtl8169_init_ring
              ip-1437  [000] ....  2681.583498: rtl_request_uncached_firmware <-rtl_open
              ip-1437  [000] ....  2681.583539: rtl8169_init_phy <-rtl_open
              ip-1437  [000] ....  2681.583540: rtl_hw_phy_config <-rtl8169_init_phy
              ip-1437  [000] ....  2681.583540: rtl_writephy_batch <-rtl_hw_phy_config
              ip-1437  [000] ....  2681.583541: rtl_writephy <-rtl_writephy_batch
              ip-1437  [000] ....  2681.583542: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.583669: rtl_writephy <-rtl_writephy_batch
              ip-1437  [000] ....  2681.583669: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.583795: rtl_writephy <-rtl_writephy_batch
              ip-1437  [000] ....  2681.583796: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.583924: rtl8169_xmii_reset_enable <-rtl8169_init_phy
              ip-1437  [000] ....  2681.583925: rtl_readphy <-rtl8169_xmii_reset_enable
              ip-1437  [000] ....  2681.583925: r8169_mdio_read <-rtl_readphy
              ip-1437  [000] ....  2681.584053: rtl_writephy <-rtl8169_xmii_reset_enable
              ip-1437  [000] ....  2681.584053: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.584180: rtl8169_xmii_reset_pending <-rtl8169_init_phy
              ip-1437  [000] ....  2681.584180: rtl_readphy <-rtl8169_xmii_reset_pending
              ip-1437  [000] ....  2681.584180: r8169_mdio_read <-rtl_readphy
              ip-1437  [000] ....  2681.584308: rtl8169_set_speed <-rtl8169_init_phy
              ip-1437  [000] ....  2681.584309: rtl8169_set_speed_xmii <-rtl8169_set_speed
              ip-1437  [000] ....  2681.584309: rtl_writephy <-rtl8169_set_speed_xmii
              ip-1437  [000] ....  2681.584309: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.584436: rtl_readphy <-rtl8169_set_speed_xmii
              ip-1437  [000] ....  2681.584436: r8169_mdio_read <-rtl_readphy
              ip-1437  [000] ....  2681.584564: rtl_readphy <-rtl8169_set_speed_xmii
              ip-1437  [000] ....  2681.584564: r8169_mdio_read <-rtl_readphy
              ip-1437  [000] ....  2681.584692: rtl_writephy <-rtl8169_set_speed_xmii
              ip-1437  [000] ....  2681.584692: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.584819: rtl_writephy <-rtl8169_set_speed_xmii
              ip-1437  [000] ....  2681.584819: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.584946: rtl_writephy <-rtl8169_set_speed_xmii
              ip-1437  [000] ....  2681.584946: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.585074: rtl_writephy <-r8168_pll_power_up
              ip-1437  [000] ....  2681.585075: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.585201: rtl_writephy <-r8168_pll_power_up
              ip-1437  [000] ....  2681.585201: r8169_mdio_write <-rtl_writephy
          <idle>-0     [001] d..2  2681.585306: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
              ip-1437  [000] ....  2681.585326: rtl_writephy <-r8168_pll_power_up
              ip-1437  [000] ....  2681.585327: r8169_mdio_write <-rtl_writephy
              ip-1437  [000] ....  2681.585453: rtl_hw_start_8168 <-rtl_open
              ip-1437  [000] ....  2681.585456: rtl_set_rx_tx_desc_registers <-rtl_hw_start_8168
              ip-1437  [000] ....  2681.585456: rtl_set_rx_mode <-rtl_hw_start_8168
              ip-1437  [000] ....  2681.585461: rtl_hw_start_8168bb <-rtl_hw_start_8168
              ip-1437  [000] ....  2681.585464: rtl_tx_performance_tweak <-rtl_hw_start_8168bb
              ip-1437  [000] ....  2681.585472: rtl8169_xmii_link_ok <-__rtl8169_check_link_status

[See first LinkChg event above]

              ip-1437  [000] d.h.  2681.585477: rtl8169_interrupt <-handle_irq_event_percpu
              ip-1437  [000] ..s1  2681.585481: rtl8169_poll <-net_rx_action

[r8169 NAPI handler schedules some work for the link event...]

              ip-1437  [000] ..s1  2681.585483: rtl_schedule_task <-rtl8169_poll
          <idle>-0     [001] d..2  2681.589280: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
              ip-1437  [000] .Ns1  2681.590517: rtl_set_rx_mode <-__dev_set_rx_mode
              ip-1437  [000] .Ns1  2681.590523: rtl_set_rx_mode <-__dev_set_rx_mode
              ip-1437  [000] .N..  2681.590533: rtl8169_get_stats64 <-dev_get_stats
              ip-1437  [000] .Ns1  2681.590546: rtl_set_rx_mode <-__dev_set_rx_mode

[... and kworker kicks in]

     kworker/0:2-44    [000] ....  2681.590565: rtl_task <-process_one_work
     kworker/0:2-44    [000] ....  2681.590566: rtl_slow_event_work <-rtl_task

[Here comes the 'link down' message...]

     kworker/0:2-44    [000] ....  2681.590568: rtl8169_xmii_link_ok <-__rtl8169_check_link_status
          <idle>-0     [001] d..1  2681.590774: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
          <idle>-0     [001] d..2  2681.593285: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit

[... and the 'local_softirq_pending' message takes place ~5ms later]

          <idle>-0     [000] d..1  2681.595607: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
              ip-1437  [001] ....  2681.596629: rtl_device_event <-notifier_call_chain

[NAPI was scheduled from 'rtl_slow_event_work'. rtl8169_poll experiences a
 10 ms delay but I really don't care: there should not be much slow events
 and it avoids shared locking between the slow work thread and the NAPI
 handler]

          <idle>-0     [000] .Ns2  2681.606110: rtl8169_poll <-net_rx_action
          <idle>-0     [000] d..1  2681.606377: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
          <idle>-0     [001] d..1  2681.606506: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
          <idle>-0     [000] d..2  2681.606526: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [000] d..2  2681.607842: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [001] d..2  2681.609292: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [001] d..2  2681.613272: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [001] d..2  2681.617268: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [001] d..2  2681.621265: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [001] d..2  2681.625275: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
          <idle>-0     [001] d..2  2681.629262: tick_nohz_stop_sched_tick <-tick_nohz_irq_exit
[...]
          <idle>-0     [001] d..1  2683.551714: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
          <idle>-0     [001] d..1  2683.751544: tick_nohz_stop_sched_tick <-tick_nohz_idle_enter
          <idle>-0     [000] d.h1  2683.774846: rtl8169_interrupt <-handle_irq_event_percpu
          <idle>-0     [000] ..s2  2683.774850: rtl8169_poll <-net_rx_action
          <idle>-0     [000] ..s2  2683.774852: rtl_schedule_task <-rtl8169_poll
     kworker/0:2-44    [000] ....  2683.774860: rtl_task <-process_one_work
     kworker/0:2-44    [000] ....  2683.774861: rtl_slow_event_work <-rtl_task

[link up message, 2s after the 'link down' one]

     kworker/0:2-44    [000] ....  2683.774863: rtl8169_xmii_link_ok <-__rtl8169_check_link_status
     kworker/0:2-44    [000] ....  2683.774865: rtl_link_chg_patch <-__rtl8169_check_link_status

98ddf986fca17840e46e070354b7e2cd2169da15 removed bh locking, whence the
implicit do_softirq() called from _local_bh_enable_ip.

With my stupid driver maintainer hat on, I can only tell that
it works as designed.

It could be worth checking if Dave's traces look the same or not.

-- 
Ueimor

--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-r8169-debugfs-support.patch"

>From 269c60147b6e7e7ad46b36e7dd1c91bb0c1b0274 Mon Sep 17 00:00:00 2001
Message-Id: <269c60147b6e7e7ad46b36e7dd1c91bb0c1b0274.1338938527.git.romieu@fr.zoreil.com>
From: Francois Romieu <romieu@fr.zoreil.com>
Date: Fri, 25 May 2012 11:18:03 +0200
Subject: [PATCH 1/2] r8169: debugfs support.
X-Organisation: Land of Sunshine Inc.

Mostly copied from Stephen Hemminger's sky2.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/ethernet/realtek/Kconfig |    9 ++
 drivers/net/ethernet/realtek/r8169.c |  186 ++++++++++++++++++++++++++++++++++
 2 files changed, 195 insertions(+)

diff --git a/drivers/net/ethernet/realtek/Kconfig b/drivers/net/ethernet/realtek/Kconfig
index 5821966..4f7930c 100644
--- a/drivers/net/ethernet/realtek/Kconfig
+++ b/drivers/net/ethernet/realtek/Kconfig
@@ -115,4 +115,13 @@ config R8169
 	  To compile this driver as a module, choose M here: the module
 	  will be called r8169.  This is recommended.
 
+config R8169_DEBUGFS
+	bool "Realtek 8169 gigabit ethernet debugfs support"
+	depends on R8169 && DEBUG_FS
+	---help---
+	  This option adds the ability to dump driver state for debugging.
+	  Debug data is available in the /sys/kernel/debug/r8169/ethX file.
+
+	  If unsure, say N.
+
 endif # NET_VENDOR_REALTEK
diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 9757ce3..abb028a 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -28,6 +28,7 @@
 #include <linux/firmware.h>
 #include <linux/pci-aspm.h>
 #include <linux/prefetch.h>
+#include <linux/debugfs.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
@@ -60,6 +61,10 @@
 #define dprintk(fmt, args...)	do {} while (0)
 #endif /* RTL8169_DEBUG */
 
+#ifdef CONFIG_R8169_DEBUGFS
+static struct dentry *rtl_debug;
+#endif
+
 #define R8169_MSG_DEFAULT \
 	(NETIF_MSG_DRV | NETIF_MSG_PROBE | NETIF_MSG_IFUP | NETIF_MSG_IFDOWN)
 
@@ -774,6 +779,10 @@ struct rtl8169_private {
 		} phy_action;
 	} *rtl_fw;
 #define RTL_FIRMWARE_UNKNOWN	ERR_PTR(-EAGAIN)
+
+#ifdef CONFIG_R8169_DEBUGFS
+	struct dentry *debugfs;
+#endif
 };
 
 MODULE_AUTHOR("Realtek and the Linux r8169 crew <netdev@vger.kernel.org>");
@@ -6692,14 +6701,191 @@ static struct pci_driver rtl8169_pci_driver = {
 	.driver.pm	= RTL8169_PM_OPS,
 };
 
+#ifdef CONFIG_R8169_DEBUGFS
+
+static struct dentry *rtl_debug;
+
+struct Desc {
+	__le32 opts1;
+	__le32 opts2;
+	__le64 addr;
+};
+
+union rtl_ring {
+	struct RxDesc	*rx;
+	struct TxDesc	*tx;
+	struct Desc	*anon;
+};
+
+static void rtl_debug_show_ring(struct seq_file *seq, union rtl_ring u, int n)
+{
+	struct Desc *desc = u.anon;
+	int i;
+
+	for (i = 0; i < n; i++) {
+		seq_printf(seq, "[%03d] %08x %08x %0llx\n", i, desc->opts1,
+			   desc->opts2, (u64)desc->addr);
+		desc++;
+	}
+}
+
+#define DECLARE_RTL_DEBUG_FOPS(name) \
+static const struct file_operations rtl_debug_fops_##name = { \
+	.owner		= THIS_MODULE, \
+	.open		= rtl_debug_open_##name, \
+	.read		= seq_read, \
+	.llseek		= seq_lseek, \
+	.release	= single_release, \
+}
+
+static int rtl_debug_show_rx(struct seq_file *seq, void *v)
+{
+	struct rtl8169_private *tp = seq->private;
+	union rtl_ring u = { .rx = tp->RxDescArray };
+
+	seq_printf(seq, "Rx: dirty=%08x current=%08x\n", tp->dirty_rx,
+		   tp->cur_rx);
+	rtl_debug_show_ring(seq, u, NUM_RX_DESC);
+
+	return 0;
+}
+
+static int rtl_debug_open_rx(struct inode *inode, struct file *file)
+{
+	return single_open(file, rtl_debug_show_rx, inode->i_private);
+}
+
+DECLARE_RTL_DEBUG_FOPS(rx);
+
+static int rtl_debug_show_tx(struct seq_file *seq, void *v)
+{
+	struct rtl8169_private *tp = seq->private;
+	union rtl_ring u = { .tx = tp->TxDescArray };
+
+	seq_printf(seq, "Tx: dirty=%08x current=%08x queue:%s\n", tp->dirty_tx,
+		   tp->cur_tx, netif_queue_stopped(tp->dev) ? "off" : "on");
+	rtl_debug_show_ring(seq, u, NUM_TX_DESC);
+
+	return 0;
+}
+
+static int rtl_debug_open_tx(struct inode *inode, struct file *file)
+{
+	return single_open(file, rtl_debug_show_tx, inode->i_private);
+}
+
+DECLARE_RTL_DEBUG_FOPS(tx);
+
+static void rtl_debug_create_tree(struct net_device *dev)
+{
+	struct rtl8169_private *tp = netdev_priv(dev);
+	struct dentry *parent;
+	static const struct rtl_debug_ent {
+		const struct file_operations *fops;
+		const char *name;
+	} ent[] = {
+		{ &rtl_debug_fops_rx,	"rx" },
+		{ &rtl_debug_fops_tx,	"tx" },
+		{ NULL, }
+	};
+	int i;
+
+	parent = debugfs_create_dir(dev->name, rtl_debug);
+	if (IS_ERR(parent))
+		goto err;
+
+	for (i = 0; i < ARRAY_SIZE(ent) - 1; i++) {
+		const struct rtl_debug_ent *e = ent + i;
+		struct dentry *d;
+
+		d = debugfs_create_file(e->name, S_IRUGO, parent, tp, e->fops);
+		if (!d)
+			goto err_remove;
+	}
+
+	tp->debugfs = parent;
+	return;
+
+err_remove:
+	debugfs_remove_recursive(parent);
+err:
+	netif_err(tp, drv, dev, "failed to create debugfs tree.\n");
+	return;
+}
+
+
+static int rtl_device_event(struct notifier_block *unused, unsigned long event,
+			    void *ptr)
+{
+	struct net_device *dev = ptr;
+	struct rtl8169_private *tp = netdev_priv(dev);
+
+	if (dev->netdev_ops->ndo_open != rtl_open || !rtl_debug)
+		return NOTIFY_DONE;
+
+	switch (event) {
+	case NETDEV_CHANGENAME:
+		if (tp->debugfs) {
+			tp->debugfs = debugfs_rename(rtl_debug, tp->debugfs,
+						     rtl_debug, dev->name);
+		}
+		break;
+
+	case NETDEV_GOING_DOWN:
+		if (tp->debugfs) {
+			netdev_printk(KERN_DEBUG, dev, "remove debugfs\n");
+			debugfs_remove_recursive(tp->debugfs);
+			tp->debugfs = NULL;
+		}
+		break;
+
+	case NETDEV_UP:
+		rtl_debug_create_tree(dev);
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block rtl_debug_notifier = {
+	.notifier_call = rtl_device_event,
+};
+
+static __init void rtl_debug_init(void)
+{
+	struct dentry *ent;
+
+	ent = debugfs_create_dir(MODULENAME, NULL);
+	if (ent && !IS_ERR(ent)) {
+		rtl_debug = ent;
+		register_netdevice_notifier(&rtl_debug_notifier);
+	}
+}
+
+static __exit void rtl_debug_cleanup(void)
+{
+	if (rtl_debug) {
+		unregister_netdevice_notifier(&rtl_debug_notifier);
+		debugfs_remove(rtl_debug);
+		rtl_debug = NULL;
+	}
+}
+
+#else
+#define rtl_debug_init()
+#define rtl_debug_cleanup()
+#endif
+
 static int __init rtl8169_init_module(void)
 {
+	rtl_debug_init();
 	return pci_register_driver(&rtl8169_pci_driver);
 }
 
 static void __exit rtl8169_cleanup_module(void)
 {
 	pci_unregister_driver(&rtl8169_pci_driver);
+	rtl_debug_cleanup();
 }
 
 module_init(rtl8169_init_module);
-- 
1.7.10.2


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0002-r8169-irq-debug-stuff.patch"

>From fb5fdae345e4099a8e543401ba36e7588c7c8e4c Mon Sep 17 00:00:00 2001
Message-Id: <fb5fdae345e4099a8e543401ba36e7588c7c8e4c.1338938527.git.romieu@fr.zoreil.com>
In-Reply-To: <269c60147b6e7e7ad46b36e7dd1c91bb0c1b0274.1338938527.git.romieu@fr.zoreil.com>
References: <269c60147b6e7e7ad46b36e7dd1c91bb0c1b0274.1338938527.git.romieu@fr.zoreil.com>
From: Francois Romieu <romieu@fr.zoreil.com>
Date: Sat, 2 Jun 2012 11:21:58 +0200
Subject: [PATCH 2/2] r8169: irq debug stuff.
X-Organisation: Land of Sunshine Inc.

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
---
 drivers/net/ethernet/realtek/r8169.c |   59 ++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index abb028a..4a05b68 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -782,6 +782,15 @@ struct rtl8169_private {
 
 #ifdef CONFIG_R8169_DEBUGFS
 	struct dentry *debugfs;
+
+#define RTL_DEBUG_EVENT_RING_SIZE	1024
+	struct rtl_event_ring {
+		struct rtl_event {
+			u16 ts;
+			u16 evt;
+		} evts[RTL_DEBUG_EVENT_RING_SIZE];
+		int used;
+	} event_ring;
 #endif
 };
 
@@ -5849,6 +5858,31 @@ process_pkt:
 	return count;
 }
 
+#ifdef CONFIG_R8169_DEBUGFS
+static void rtl_trace_event(struct rtl8169_private *tp, u16 status)
+{
+	struct rtl_event_ring *evr = &tp->event_ring;
+	int used = evr->used;
+	struct rtl_event *e = evr->evts + used;
+
+	if (used >= RTL_DEBUG_EVENT_RING_SIZE) {
+		if (net_ratelimit())
+			netif_err(tp, drv, tp->dev, "event ring full.\n");
+		return;
+	}
+
+	/* ms. Well, almost. */
+	e->ts = ((local_clock() / 100000) % 100000) >> 1;
+	e->evt = status;
+	evr->used = used + 1;
+}
+
+#else /* !CONFIG_R8169_DEBUGFS */
+
+#define rtl_trace_event(tp, status)	do { } while (0)
+
+#endif /* !CONFIG_R8169_DEBUGFS */
+
 static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
@@ -5858,6 +5892,8 @@ static irqreturn_t rtl8169_interrupt(int irq, void *dev_instance)
 
 	status = rtl_get_events(tp);
 	if (status && status != 0xffff) {
+		rtl_trace_event(tp, status);
+
 		status &= RTL_EVENT_NAPI | tp->event_slow;
 		if (status) {
 			handled = 1;
@@ -6776,6 +6812,28 @@ static int rtl_debug_open_tx(struct inode *inode, struct file *file)
 
 DECLARE_RTL_DEBUG_FOPS(tx);
 
+static int rtl_debug_show_irq(struct seq_file *seq, void *v)
+{
+	struct rtl8169_private *tp = seq->private;
+	struct rtl_event_ring *evr = &tp->event_ring;
+	int i;
+
+	for (i = 0; i < min(evr->used, RTL_DEBUG_EVENT_RING_SIZE); i++) {
+		struct rtl_event *e = evr->evts + i;
+
+		seq_printf(seq, "[%05d] %04x\n", e->ts << 1, e->evt);
+	}
+
+	return 0;
+}
+
+static int rtl_debug_open_irq(struct inode *inode, struct file *file)
+{
+	return single_open(file, rtl_debug_show_irq, inode->i_private);
+}
+
+DECLARE_RTL_DEBUG_FOPS(irq);
+
 static void rtl_debug_create_tree(struct net_device *dev)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -6786,6 +6844,7 @@ static void rtl_debug_create_tree(struct net_device *dev)
 	} ent[] = {
 		{ &rtl_debug_fops_rx,	"rx" },
 		{ &rtl_debug_fops_tx,	"tx" },
+		{ &rtl_debug_fops_irq,	"irq" },
 		{ NULL, }
 	};
 	int i;
-- 
1.7.10.2


--x+6KMIRAuhnl3hBn--
