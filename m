Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758539Ab1BPBvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:51:19 -0500
Received: from kroah.org ([198.145.64.141]:49085 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758415Ab1BPBuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:50:44 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:47:01 2011
Message-Id: <20110216014700.983345910@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [067/115] hostap_cs: fix sleeping function called from invalid context
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


