Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229Ab1FOROa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 13:14:30 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55071 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1FORO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 13:14:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CjznJi6pWAmjA4Ely4VhwjMI49Qs75gVpbQkHXI6lcZtihENyhf+ByVcPykzNrpFRX
         C5TRuF0nPmBsM4AHgTPcCNlheO6EL8bT1Rl3CEKRC6zD+ruuviw5M+ZYjkj684tPRGhu
         ZxMOXEXahSXJ7up10HeKTI1qOyGZCkWTkVHIs=
Date: Wed, 15 Jun 2011 20:14:19 +0300
From: Maxin B John <maxin.john@gmail.com>
To: akpm@linux-foundation.org
Cc: tj@kernel.org, eike-kernel@sf-tec.de, segooon@gmail.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org, jkosina@suse.cz
Subject: Re: [PATCH] [RESEND] devres: Fix possible use after free
Message-ID: <20110615171419.GA2794@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devres uses the pointer value as key after it's freed, which is safe but 
triggers spurious use-after-free warnings on some static analysis tools. 
Rearrange code to avoid such warnings.

Signed-off-by: Maxin B. John <maxin.john@gmail.com>
Reviewed-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Acked-by: Tejun Heo <tj@kernel.org>
---
diff --git a/kernel/irq/devres.c b/kernel/irq/devres.c
index 1ef4ffc..bd8e788 100644
--- a/kernel/irq/devres.c
+++ b/kernel/irq/devres.c
@@ -87,8 +87,8 @@ void devm_free_irq(struct device *dev, unsigned int irq, void *dev_id)
 {
 	struct irq_devres match_data = { irq, dev_id };
 
-	free_irq(irq, dev_id);
 	WARN_ON(devres_destroy(dev, devm_irq_release, devm_irq_match,
 			       &match_data));
+	free_irq(irq, dev_id);
 }
 EXPORT_SYMBOL(devm_free_irq);
diff --git a/lib/devres.c b/lib/devres.c
index 6efddf5..7c0e953 100644
--- a/lib/devres.c
+++ b/lib/devres.c
@@ -79,9 +79,9 @@ EXPORT_SYMBOL(devm_ioremap_nocache);
  */
 void devm_iounmap(struct device *dev, void __iomem *addr)
 {
-	iounmap(addr);
 	WARN_ON(devres_destroy(dev, devm_ioremap_release, devm_ioremap_match,
 			       (void *)addr));
+	iounmap(addr);
 }
 EXPORT_SYMBOL(devm_iounmap);
 
diff --git a/mm/dmapool.c b/mm/dmapool.c
index 03bf3bb..fbb58e3 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -500,7 +500,7 @@ void dmam_pool_destroy(struct dma_pool *pool)
 {
 	struct device *dev = pool->dev;
 
-	dma_pool_destroy(pool);
 	WARN_ON(devres_destroy(dev, dmam_pool_release, dmam_pool_match, pool));
+	dma_pool_destroy(pool);
 }
 EXPORT_SYMBOL(dmam_pool_destroy);
