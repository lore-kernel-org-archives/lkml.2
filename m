Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1FBOW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 10:22:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45059 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1FBOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 10:22:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=FzUUWcOkVbdUOCaB3ogxEh3UoOhnFVEzkXBZsGkjfQWzlo9C17/GTtFZHiDumvoYQq
         0dKMYGjRU5ZZKZWhn2zW1lGG6tdV0uLD2MjZBVkqq1IqZfvjeRyHJXY7MEnaDO23yEHx
         8VOelG0ETboqYCIYElXsBWjC/cv9cKiQp1LIo=
Date: Thu, 2 Jun 2011 17:22:42 +0300
From: Maxin B John <maxin.john@gmail.com>
To: eike-kernel@sf-tec.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, dima@android.com, willy@linux.intel.com,
        segooon@gmail.com, tj@kernel.org, jkosina@suse.cz, tglx@linutronix.de
Subject: Re: [PATCH] mm: dmapool: fix possible use after free in
 dmam_pool_destroy()
Message-ID: <20110602142242.GA4115@maxin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 12:47 PM, Rolf Eike Beer <eike-kernel@sf-tec.de> wrote:
> Maxin B John wrote:
>> "dma_pool_destroy(pool)" calls "kfree(pool)". The freed pointer
>> "pool" is again passed as an argument to the function "devres_destroy()".
>> This patch fixes the possible use after free.
>
> The pool itself is not used there, only the address where the pool
> has been.This will only lead to any trouble if something else is allocated to
> the same place and inserted into the devres list of the same device between
> the dma_pool_destroy() and devres_destroy().

Thank you very much for explaining it in detail. 

> But I agree that this is bad style. But if you are going to change
> this please also have a look at devm_iounmap() in lib/devres.c. Maybe also the
> devm_*irq* functions need the same changes.

As per your suggestion, I have made similar modifications for lib/devres.c and
kernel/irq/devres.c

CCed the maintainers of the respective files.
 
Signed-off-by: Maxin B. John <maxin.john@gmail.com>
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
 
