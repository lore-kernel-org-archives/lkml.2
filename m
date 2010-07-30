Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab0G3SvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:51:17 -0400
Received: from kroah.org ([198.145.64.141]:35644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759372Ab0G3ReZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:25 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:06 2010
Message-Id: <20100730173106.083133483@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:30:02 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Gardner <tim.gardner@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [037/140] hostap: Protect against initialization interrupt
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tim Gardner <tim.gardner@canonical.com>

commit d6a574ff6bfb842bdb98065da053881ff527be46 upstream.

Use an irq spinlock to hold off the IRQ handler until
enough early card init is complete such that the handler
can run without faulting.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/hostap/hostap_cs.c   |   15 +++++++++++++--
 drivers/net/wireless/hostap/hostap_hw.c   |   13 +++++++++++++
 drivers/net/wireless/hostap/hostap_wlan.h |    2 +-
 3 files changed, 27 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -602,6 +602,7 @@ static int prism2_config(struct pcmcia_d
 	local_info_t *local;
 	int ret = 1;
 	struct hostap_cs_priv *hw_priv;
+	unsigned long flags;
 
 	PDEBUG(DEBUG_FLOW, "prism2_config()\n");
 
@@ -636,6 +637,12 @@ static int prism2_config(struct pcmcia_d
 	link->dev_node = &hw_priv->node;
 
 	/*
+	 * Make sure the IRQ handler cannot proceed until at least
+	 * dev->base_addr is initialized.
+	 */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
+
+	/*
 	 * Allocate an interrupt line.  Note that this does not assign a
 	 * handler to the interrupt, unless the 'Handler' member of the
 	 * irq structure is initialized.
@@ -645,7 +652,7 @@ static int prism2_config(struct pcmcia_d
 		link->irq.Handler = prism2_interrupt;
 		ret = pcmcia_request_irq(link, &link->irq);
 		if (ret)
-			goto failed;
+			goto failed_unlock;
 	}
 
 	/*
@@ -655,11 +662,13 @@ static int prism2_config(struct pcmcia_d
 	 */
 	ret = pcmcia_request_configuration(link, &link->conf);
 	if (ret)
-		goto failed;
+		goto failed_unlock;
 
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
 
+	spin_unlock_irqrestore(&local->irq_init_lock, flags);
+
 	/* Finally, report what we've done */
 	printk(KERN_INFO "%s: index 0x%02x: ",
 	       dev_info, link->conf.ConfigIndex);
@@ -688,6 +697,8 @@ static int prism2_config(struct pcmcia_d
 	}
 	return ret;
 
+ failed_unlock:
+	 spin_unlock_irqrestore(&local->irq_init_lock, flags);
  failed:
 	kfree(hw_priv);
 	prism2_release((u_long)link);
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2621,6 +2621,18 @@ static irqreturn_t prism2_interrupt(int
 	iface = netdev_priv(dev);
 	local = iface->local;
 
+	/* Detect early interrupt before driver is fully configued */
+	spin_lock(&local->irq_init_lock);
+	if (!dev->base_addr) {
+		if (net_ratelimit()) {
+			printk(KERN_DEBUG "%s: Interrupt, but dev not configured\n",
+			       dev->name);
+		}
+		spin_unlock(&local->irq_init_lock);
+		return IRQ_HANDLED;
+	}
+	spin_unlock(&local->irq_init_lock);
+
 	prism2_io_debug_add(dev, PRISM2_IO_DEBUG_CMD_INTERRUPT, 0, 0);
 
 	if (local->func->card_present && !local->func->card_present(local)) {
@@ -3138,6 +3150,7 @@ prism2_init_local_data(struct prism2_hel
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
+	spin_lock_init(&local->irq_init_lock);
 	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -654,7 +654,7 @@ struct local_info {
 	rwlock_t iface_lock; /* hostap_interfaces read lock; use write lock
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
-	spinlock_t cmdlock, baplock, lock;
+	spinlock_t cmdlock, baplock, lock, irq_init_lock;
 	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by


