Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753797Ab1FNHHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 03:07:39 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:64677 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1FNHHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 03:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HteYknD7UPahWzl18m1X6hHxPzqcbXUEel7eQcTtWgUvC/hEA0baO13QP5rxYBEhX8
         kGAXZMRkZjw+pWy5KuiaWBgkFbwLgU19n9Zi8IN9G/e5ud+bwrhqNeU8rv8yifPaMQk0
         pQnTRiesggMSB48s7Xa7AFvxWrTkTuIyHjqjY=
Date: Tue, 14 Jun 2011 10:07:32 +0300
From: Maxin B John <maxin.john@gmail.com>
To: akpm@linux-foundation.org
Cc: segooon@gmail.com, jkosina@suse.cz, tj@kernel.org, tglx@linutronix.de,
        eike-kernel@sf-tec.de, linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] devres: Fix possible use after free
Message-ID: <20110614070732.GA3355@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A freed pointer is passed as an argument to the function "devres_destroy()" in
"kernel/irq/devres.c" and "lib/devres.c". This patch fixes the possible use 
after free.

It's notabug at this time, but the code is dangerous.

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
 
