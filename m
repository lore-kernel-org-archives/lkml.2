Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab0G3RDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:03:42 -0400
Received: from kroah.org ([198.145.64.141]:35525 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab0G3RDg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:03:36 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 09:59:54 2010
Message-Id: <20100730165954.539928245@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 09:57:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tim Gardner <tim.gardner@canonical.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [08/17] hostap: Protect against initialization interrupt
In-Reply-To: <20100730170054.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/net/wireless/hostap/hostap_cs.c   |   10 ++++++++++
 drivers/net/wireless/hostap/hostap_hw.c   |   13 +++++++++++++
 drivers/net/wireless/hostap/hostap_wlan.h |    2 +-
 3 files changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -557,6 +557,7 @@ static int prism2_config(struct pcmcia_d
 	config_info_t conf;
 	cistpl_cftable_entry_t dflt = { 0 };
 	struct hostap_cs_priv *hw_priv;
+	unsigned long flags;
 
 	PDEBUG(DEBUG_FLOW, "prism2_config()\n");
 
@@ -688,6 +689,12 @@ static int prism2_config(struct pcmcia_d
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
@@ -712,6 +719,8 @@ static int prism2_config(struct pcmcia_d
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
 
+	spin_unlock_irqrestore(&local->irq_init_lock, flags);
+
 	/* Finally, report what we've done */
 	printk(KERN_INFO "%s: index 0x%02x: ",
 	       dev_info, link->conf.ConfigIndex);
@@ -742,6 +751,7 @@ static int prism2_config(struct pcmcia_d
 	return ret;
 
  cs_failed:
+	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 	cs_error(link, last_fn, last_ret);
 
  failed:
--- a/drivers/net/wireless/hostap/hostap_hw.c
+++ b/drivers/net/wireless/hostap/hostap_hw.c
@@ -2631,6 +2631,18 @@ static irqreturn_t prism2_interrupt(int
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
@@ -3187,6 +3199,7 @@ prism2_init_local_data(struct prism2_hel
 	spin_lock_init(&local->cmdlock);
 	spin_lock_init(&local->baplock);
 	spin_lock_init(&local->lock);
+	spin_lock_init(&local->irq_init_lock);
 	mutex_init(&local->rid_bap_mtx);
 
 	if (card_idx < 0 || card_idx >= MAX_PARM_DEVICES)
--- a/drivers/net/wireless/hostap/hostap_wlan.h
+++ b/drivers/net/wireless/hostap/hostap_wlan.h
@@ -653,7 +653,7 @@ struct local_info {
 	rwlock_t iface_lock; /* hostap_interfaces read lock; use write lock
 			      * when removing entries from the list.
 			      * TX and RX paths can use read lock. */
-	spinlock_t cmdlock, baplock, lock;
+	spinlock_t cmdlock, baplock, lock, irq_init_lock;
 	struct mutex rid_bap_mtx;
 	u16 infofid; /* MAC buffer id for info frame */
 	/* txfid, intransmitfid, next_txtid, and next_alloc are protected by


