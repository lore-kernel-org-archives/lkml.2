Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933175Ab1FWRfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:35:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:34160 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab1FWRfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:35:45 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 065/247] hostap_cs: fix sleeping function called from invalid context
Date: Thu, 23 Jun 2011 13:32:13 -0400
Message-Id: <1308850515-15242-6-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <sgruszka@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/net/wireless/hostap/hostap_cs.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/hostap/hostap_cs.c b/drivers/net/wireless/hostap/hostap_cs.c
index f33e18e..e436aca 100644
--- a/drivers/net/wireless/hostap/hostap_cs.c
+++ b/drivers/net/wireless/hostap/hostap_cs.c
@@ -638,11 +638,10 @@ static int prism2_config(struct pcmcia_device *link)
 	link->dev_node = &hw_priv->node;
 
 	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
+	 * We enable IRQ here, but IRQ handler will not proceed
+	 * until dev->base_addr is set below. This protect us from
+	 * receive interrupts when driver is not initialized.
 	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
 	/*
 	 * Allocate an interrupt line.  Note that this does not assign a
 	 * handler to the interrupt, unless the 'Handler' member of the
@@ -653,7 +652,7 @@ static int prism2_config(struct pcmcia_device *link)
 		link->irq.Handler = prism2_interrupt;
 		ret = pcmcia_request_irq(link, &link->irq);
 		if (ret)
-			goto failed_unlock;
+			goto failed;
 	}
 
 	/*
@@ -663,11 +662,11 @@ static int prism2_config(struct pcmcia_device *link)
 	 */
 	ret = pcmcia_request_configuration(link, &link->conf);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq.AssignedIRQ;
 	dev->base_addr = link->io.BasePort1;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	/* Finally, report what we've done */
@@ -698,8 +697,6 @@ static int prism2_config(struct pcmcia_device *link)
 	}
 	return ret;
 
- failed_unlock:
-	 spin_unlock_irqrestore(&local->irq_init_lock, flags);
  failed:
 	kfree(hw_priv);
 	prism2_release((u_long)link);
-- 
1.7.4.4

