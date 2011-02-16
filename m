Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab1BPAY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:24:28 -0500
Received: from kroah.org ([198.145.64.141]:49612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932274Ab1BPAYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:24:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:46 2011
Message-Id: <20110216001446.526890755@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [214/272] hostap_cs: fix sleeping function called from invalid context
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

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
 drivers/net/wireless/hostap/hostap_cs.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -518,22 +518,21 @@ static int prism2_config(struct pcmcia_d
 	hw_priv->link = link;
 
 	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
+	 * We enable IRQ here, but IRQ handler will not proceed
+	 * until dev->base_addr is set below. This protect us from
+	 * receive interrupts when driver is not initialized.
 	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
 	ret = pcmcia_request_irq(link, prism2_interrupt);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
 	ret = pcmcia_enable_device(link);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq;
 	dev->base_addr = link->resource[0]->start;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	local->shutdown = 0;
@@ -546,8 +545,6 @@ static int prism2_config(struct pcmcia_d
 
 	return ret;
 
- failed_unlock:
-	spin_unlock_irqrestore(&local->irq_init_lock, flags);
  failed:
 	kfree(hw_priv);
 	prism2_release((u_long)link);


