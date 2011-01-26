Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab1AZQtZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:49:25 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54051 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab1AZQtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:49:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=c2aWlRugQ/ZBeqz17SsVk64CMPHZj6q7If7+Z7dfqGL5/mvTyhm20MVxtPr8IWntVp
         gKSOOythEUr5EWmQIKuz05ht0AIKRwuxdNt9/eyEzJv3T3clAL28kAD/MhDRrA+QT2zp
         uIezxb+CpRaHQGjjNL24ywdN05iKccg10fJlE=
Date: Wed, 26 Jan 2011 17:49:18 +0100
From: Tejun Heo <tj@kernel.org>
To: Ben Skeggs <skeggsb@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH UPDATED 08/32] drm/nouveau: use system_wq instead of
 dev_priv->wq
Message-ID: <20110126164918.GQ12520@htj.dyndns.org>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
 <1294062595-30097-9-git-send-email-tj@kernel.org>
 <1294189627.2276.0.camel@nisroch>
 <1294190172.2276.2.camel@nisroch>
 <20110106172922.GA29580@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110106172922.GA29580@mtj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With cmwq, there's no reason for nouveau to use a dedicated workqueue.
Drop dev_priv->wq and use system_wq instead.  Each work item is sync
flushed when the containing structure is unregistered/destroyed.

Note that this change also makes sure that nv50_gpio_handler is not
freed while the contained work item is still running.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David Airlie <airlied@linux.ie>
Cc: dri-devel@lists.freedesktop.org
---
Here's a patch on top of the current linus#master.  It's much simpler
than before.  The only concern is that it adds flush_work_sync() call
which might sleep to unregistration paths.  AFAICS, this seems safe,
right?  If this looks okay to you, please feel free to route it
through the drm tree.

Thank you.

 drivers/gpu/drm/nouveau/nouveau_drv.h   |    1 -
 drivers/gpu/drm/nouveau/nouveau_state.c |   10 +---------
 drivers/gpu/drm/nouveau/nv50_display.c  |    5 ++++-
 drivers/gpu/drm/nouveau/nv50_gpio.c     |   11 ++++++++---
 4 files changed, 13 insertions(+), 14 deletions(-)

Index: work/drivers/gpu/drm/nouveau/nouveau_drv.h
===================================================================
--- work.orig/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ work/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -652,7 +652,6 @@ struct drm_nouveau_private {
 	/* interrupt handling */
 	void (*irq_handler[32])(struct drm_device *);
 	bool msi_enabled;
-	struct workqueue_struct *wq;
 	struct work_struct irq_work;
 
 	struct list_head vbl_waiting;
Index: work/drivers/gpu/drm/nouveau/nouveau_state.c
===================================================================
--- work.orig/drivers/gpu/drm/nouveau/nouveau_state.c
+++ work/drivers/gpu/drm/nouveau/nouveau_state.c
@@ -929,12 +929,6 @@ int nouveau_load(struct drm_device *dev,
 	NV_DEBUG(dev, "vendor: 0x%X device: 0x%X class: 0x%X\n",
 		 dev->pci_vendor, dev->pci_device, dev->pdev->class);
 
-	dev_priv->wq = create_workqueue("nouveau");
-	if (!dev_priv->wq) {
-		ret = -EINVAL;
-		goto err_priv;
-	}
-
 	/* resource 0 is mmio regs */
 	/* resource 1 is linear FB */
 	/* resource 2 is RAMIN (mmio regs + 0x1000000) */
@@ -947,7 +941,7 @@ int nouveau_load(struct drm_device *dev,
 		NV_ERROR(dev, "Unable to initialize the mmio mapping. "
 			 "Please report your setup to " DRIVER_EMAIL "\n");
 		ret = -EINVAL;
-		goto err_wq;
+		goto err_priv;
 	}
 	NV_DEBUG(dev, "regs mapped ok at 0x%llx\n",
 					(unsigned long long)mmio_start_offs);
@@ -1054,8 +1048,6 @@ err_ramin:
 	iounmap(dev_priv->ramin);
 err_mmio:
 	iounmap(dev_priv->mmio);
-err_wq:
-	destroy_workqueue(dev_priv->wq);
 err_priv:
 	kfree(dev_priv);
 	dev->dev_private = NULL;
Index: work/drivers/gpu/drm/nouveau/nv50_display.c
===================================================================
--- work.orig/drivers/gpu/drm/nouveau/nv50_display.c
+++ work/drivers/gpu/drm/nouveau/nv50_display.c
@@ -345,12 +345,15 @@ int nv50_display_create(struct drm_devic
 void
 nv50_display_destroy(struct drm_device *dev)
 {
+	struct drm_nouveau_private *dev_priv = dev->dev_private;
+
 	NV_DEBUG_KMS(dev, "\n");
 
 	drm_mode_config_cleanup(dev);
 
 	nv50_display_disable(dev);
 	nouveau_irq_unregister(dev, 26);
+	flush_work_sync(&dev_priv->irq_work);
 }
 
 static u16
@@ -836,7 +839,7 @@ nv50_display_isr(struct drm_device *dev)
 		if (clock) {
 			nv_wr32(dev, NV03_PMC_INTR_EN_0, 0);
 			if (!work_pending(&dev_priv->irq_work))
-				queue_work(dev_priv->wq, &dev_priv->irq_work);
+				schedule_work(&dev_priv->irq_work);
 			delayed |= clock;
 			intr1 &= ~clock;
 		}
Index: work/drivers/gpu/drm/nouveau/nv50_gpio.c
===================================================================
--- work.orig/drivers/gpu/drm/nouveau/nv50_gpio.c
+++ work/drivers/gpu/drm/nouveau/nv50_gpio.c
@@ -137,6 +137,7 @@ nv50_gpio_irq_unregister(struct drm_devi
 	struct nv50_gpio_priv *priv = pgpio->priv;
 	struct nv50_gpio_handler *gpioh, *tmp;
 	struct dcb_gpio_entry *gpio;
+	LIST_HEAD(tofree);
 	unsigned long flags;
 
 	gpio = nouveau_bios_gpio_entry(dev, tag);
@@ -149,10 +150,14 @@ nv50_gpio_irq_unregister(struct drm_devi
 		    gpioh->handler != handler ||
 		    gpioh->data != data)
 			continue;
-		list_del(&gpioh->head);
-		kfree(gpioh);
+		list_move(&gpioh->head, &tofree);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
+
+	list_for_each_entry_safe(gpioh, tmp, &tofree, head) {
+		flush_work_sync(&gpioh->work);
+		kfree(gpioh);
+	}
 }
 
 bool
@@ -293,7 +298,7 @@ nv50_gpio_isr(struct drm_device *dev)
 			continue;
 		gpioh->inhibit = true;
 
-		queue_work(dev_priv->wq, &gpioh->work);
+		schedule_work(&gpioh->work);
 	}
 	spin_unlock(&priv->lock);
 }
