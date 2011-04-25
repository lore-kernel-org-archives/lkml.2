Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250Ab1DYUXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:41 -0400
Received: from 1wt.eu ([62.212.114.60]:33790 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755936Ab1DYUXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:39 -0400
Message-Id: <20110425200234.165561470@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 027/173] hostap_cs: fix sleeping function called from invalid context
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 4e5518ca53be29c1ec3c00089c97bef36bfed515 upstream.

pcmcia_request_irq() and pcmcia_enable_device() are intended
to be called from process context (first function allocate memory
with GFP_KERNEL, second take a mutex). We can not take spin lock
and call them.

It's safe to move spin lock after pcmcia_enable_device() as we
still hold off IRQ until dev->base_addr is 0 and driver will
not proceed with interrupts when is not ready.

Patch resolves:
https://bugzilla.redhat.com/show_bug.cgi?id=643758

Reported-and-tested-by: rbugz@biobind.com
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/wireless/hostap/hostap_cs.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -662,12 +662,6 @@ static int prism2_config(struct pcmcia_d
 	link->dev_node = &hw_priv->node;
 
 	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
-	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
-	/*
 	 * Allocate an interrupt line.  Note that this does not assign a
 	 * handler to the interrupt, unless the 'Handler' member of the
 	 * irq structure is initialized.
@@ -690,9 +684,10 @@ static int prism2_config(struct pcmcia_d
 	CS_CHECK(RequestConfiguration,
 		 pcmcia_request_configuration(link, &link->conf));
 
+	/* IRQ handler cannot proceed until at dev->base_addr is initialized */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	/* Finally, report what we've done */
@@ -724,7 +719,6 @@ static int prism2_config(struct pcmcia_d
 	return ret;
 
  cs_failed:
-	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 	cs_error(link, last_fn, last_ret);
 
  failed:


