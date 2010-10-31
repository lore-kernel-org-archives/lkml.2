Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab0JaR1f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 13:27:35 -0400
Received: from kuber.nabble.com ([216.139.236.158]:57399 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab0JaR1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 13:27:33 -0400
Message-ID: <30099327.post@talk.nabble.com>
Date: Sun, 31 Oct 2010 10:27:32 -0700 (PDT)
From: _angelo <angelo70@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: help, BUG: spinlock recursion on CPU#0, httpd/29
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: angelo70@gmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hi all,
i don't know if this is the right forum, but i don't see other appropriate
kernel forums actually  

starting from a main line kernel 2.6.36-rc3, i am trying to interface a
coldfire mcf5307 to a dm9000 ethernet chip in a little custom board. I did
some small changes to the dm9000.c driver, since it was for little-endian
cpus. Now it is mostly working, icmp ping and telnet are working fine.
The only issue happen when i use http, through a browser i try to read the
board html testpage: first load (GET) works, then refreshing 2 or 3 times,
kernel goes into following error:

# BUG: recent printk recursion!
<7>dm9000 dm9000: entering dm9000_interrupt
BUG: spinlock recursion on CPU#0, httpd/29
 lock: 00177648, .magic: dead4ead, .owner: httpd/29, .owner_cpu: 0
Stack from 00e559b4:
        0014f790 000a7d6c 00169918 00177648 dead4ead 00e26594 0000001d
00000000
        00177648 000288d4 0014f79e 000a7f2e 00177648 0016997e 00177648
00e55acc
        0000001f 00000000 0000010a 0017760c 000288d4 0014f79e 00029d90
0014f7a8
        00177648 000289ec 00177648 0000001f 00e55acc 0000001f 0017760c
000288d4
        0014f79e 00029d90 0014f790 00000b96 0000001f 00177648 00dbe5b0
000032e2
        0000001f 00e55a5c 00000001 00177648 00dbe5b0 0000001f 00000000
00e55000
Call Trace with CONFIG_FRAME_POINTER disabled:
 [0014f790]  [000a7d6c]  [00169918]  [000288d4]  [0014f79e]
 [000a7f2e]  [0016997e]  [000288d4]  [0014f79e]  [00029d90]
 [0014f7a8]  [000289ec]  [000288d4]  [0014f79e]  [00029d90]
 [0014f790]  [00000b96]  [000032e2]  [00028a6a]  [0014f790]
 [0014f79e]  [00000b96]  [000032e2]  [0014f790]  [000a7fda]
 [0014f790]  [0014f79e]  [0014f7a8]  [00109d94]  [000fceb0]
 [00103a2c]  [000a4510]  [00117300]  [00117a40]  [00004000]
 [0011757e]  [00118538]  [000005a8]  [00001ad0]  [0014ce8e]
 [0012ce2a]  [00007f67]  [00001ad0]  [0012dd82]  [0012923c]
 [000005a8]  [000005a8]  [00002d80]  [00030200]  [0012a4b8]
 [0014f790]  [00008b06]  [00004124]  [00128a4e]  [0012abae]
 [000005a8]  [00128048]  [000005a8]  [0014de4a]  [00004124]
 [0012dca8]  [0014de4a]  [00004124]  [0016fae3]  [0014f79e]
 [000ee208]  [0011f72a]  [00002860]  [000005a8]  [000005a8]
 [00002860]  [000005a8]  [0013aad2]  [00002860]  [000eb4e4]
 [00002860]  [0004260a]  [00002860]  [0004293c]  [00042df6]
 [0001ffff]  [00002860]  [00002860]  [000125fa]  [00002860]
 [00042a10]  [00002860]  [00042e36]  [00002860]  [0000318c]
 [00002860]
BUG: spinlock lockup on CPU#0, httpd/29, 00177648
...

Actually, from some debugging, the issue seems triggered from the
dm9000_interrupt routine:

static irqreturn_t dm9000_interrupt(int irq, void *dev_id)
{
	struct net_device *dev = dev_id;
	board_info_t *db = netdev_priv(dev);
	int int_status;
	unsigned long flags;
	u8 reg_save;

	/* A real interrupt coming */
	
	/* holders of db->lock must always block IRQs */
	spin_lock_irqsave(&db->lock, flags);
	
	dm9000_dbg(db, 3, "entering %s\n", __func__);

	/* Save previous register address */
#ifdef BE_STRAIGHT_WIRED
   reg_save = (u8)readl(db->io_addr);
#else
   reg_save = readb(db->io_addr);
#endif

	/* Disable all interrupts */
	iow(db, DM9000_IMR, IMR_PAR);

	/* Got DM9000 interrupt status */
	int_status = ior(db, DM9000_ISR);	/* Got ISR */
	iow(db, DM9000_ISR, int_status);	/* Clear ISR status */

	if (netif_msg_intr(db))
		dev_dbg(db->dev, "interrupt status %02x\n", int_status);

	/* Received the coming packet */
	if (int_status & ISR_PRS)
		dm9000_rx(dev);
		
	/* Trnasmit Interrupt check */
	if (int_status & ISR_PTS)
		dm9000_tx_done(dev, db);

	if (db->type != TYPE_DM9000E) {
		if (int_status & ISR_LNKCHNG) {
			/* fire a link-change request */
			schedule_delayed_work(&db->phy_poll, 1);
		}
	}

	/* Re-enable interrupt mask */
	iow(db, DM9000_IMR, db->imr_all);

	/* Restore previous register address */
#ifdef BE_STRAIGHT_WIRED
   writel(reg_save, db->io_addr);
#else
   writeb(reg_save, db->io_addr);
#endif

	spin_unlock_irqrestore(&db->lock, flags);
	
	return IRQ_HANDLED;
}


I really don't have the kernel experience to get out of this issue, so i
hope in some help or suggestion

many thanks
regards,
angelo


-- 
View this message in context: http://old.nabble.com/help%2C-BUG%3A-spinlock-recursion-on-CPU-0%2C-httpd-29-tp30099327p30099327.html
Sent from the linux-kernel mailing list archive at Nabble.com.

