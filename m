Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab1C3VGx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:06:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:4889 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804Ab1C3VGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="673447346"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: sgruszka@redhat.com, linville@tuxdriver.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [69/275] hostap_cs: fix sleeping function called from invalid context
Message-Id: <20110330210506.522BA3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>


---
 drivers/net/wireless/hostap/hostap_cs.c |   15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

Index: linux-2.6.35.y/drivers/net/wireless/hostap/hostap_cs.c
===================================================================
--- linux-2.6.35.y.orig/drivers/net/wireless/hostap/hostap_cs.c	2011-03-29 22:51:42.422637681 -0700
+++ linux-2.6.35.y/drivers/net/wireless/hostap/hostap_cs.c	2011-03-29 23:02:59.610310141 -0700
@@ -626,15 +626,9 @@
 	local->hw_priv = hw_priv;
 	hw_priv->link = link;
 
-	/*
-	 * Make sure the IRQ handler cannot proceed until at least
-	 * dev->base_addr is initialized.
-	 */
-	spin_lock_irqsave(&local->irq_init_lock, flags);
-
 	ret = pcmcia_request_irq(link, prism2_interrupt);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
 	/*
 	 * This actually configures the PCMCIA socket -- setting up
@@ -643,11 +637,12 @@
 	 */
 	ret = pcmcia_request_configuration(link, &link->conf);
 	if (ret)
-		goto failed_unlock;
+		goto failed;
 
+	/* IRQ handler cannot proceed until at dev->base_addr is initialized */
+	spin_lock_irqsave(&local->irq_init_lock, flags);
 	dev->irq = link->irq;
 	dev->base_addr = link->io.BasePort1;
-
 	spin_unlock_irqrestore(&local->irq_init_lock, flags);
 
 	/* Finally, report what we've done */
@@ -676,8 +671,6 @@
 
 	return ret;
 
- failed_unlock:
-	 spin_unlock_irqrestore(&local->irq_init_lock, flags);
  failed:
 	kfree(hw_priv);
 	prism2_release((u_long)link);
