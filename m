Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab1AEBQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 20:16:35 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44500 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab1AEBQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 20:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:message-id
         :mime-version;
        b=J1jN0Rk+Ape8qNODrWL8TIsgZuQMrr9s2Y5wS35Oz8P1/VPXmgcPnvBcawtiz6+3iT
         x2nBKTu8HI7xAJphbMj37wTCFRDjp2vquNarg7XexHjJAUm3FRktPFdw1nB9YiWkAf2S
         QT8yiWBOWJ9YZXgxdx4EuwuP7+fxlMdKIdk0M=
Subject: Re: [PATCH 08/32] drm/nouveau: use system_wq instead of dev_priv->wq
From: Ben Skeggs <skeggsb@gmail.com>
Reply-To: skeggsb@gmail.com
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Date: Wed, 05 Jan 2011 11:16:05 +1000
In-Reply-To: <1294189627.2276.0.camel@nisroch>
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	 <1294062595-30097-9-git-send-email-tj@kernel.org>
	 <1294189627.2276.0.camel@nisroch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 2.91.4 (2.91.4-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1294190172.2276.2.camel@nisroch>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-05 at 11:07 +1000, Ben Skeggs wrote:
> On Mon, 2011-01-03 at 14:49 +0100, Tejun Heo wrote:
> > With cmwq, there's no reason for nouveau to use a dedicated workqueue.
> > Drop dev_priv->wq and use system_wq instead.
> > 
> > Because nouveau_irq_uninstall() may be called from unsleepable
> > context, the work items can't be flushed from there.  Instead, init
> > and flush from nouveau_load/unload().
> Ehh, ok, why not!  I'll push this through the nouveau tree, and it'll
> get to Dave from there.
On second thoughts, this won't apply on top of current nouveau code
that's queued for 2.6.38.  Can you rebase on top of Dave's drm-next tree
please.

Ben.

> 
> Thanks!
> Ben.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: David Airlie <airlied@linux.ie>
> > Cc: dri-devel@lists.freedesktop.org
> > ---
> > Only compile tested.  Please feel free to take it into the subsystem
> > tree or simply ack - I'll route it through the wq tree.
> > 
> > Thanks.
> > 
> >  drivers/gpu/drm/nouveau/nouveau_drv.h   |    1 -
> >  drivers/gpu/drm/nouveau/nouveau_irq.c   |    9 ---------
> >  drivers/gpu/drm/nouveau/nouveau_state.c |   19 ++++++++++---------
> >  drivers/gpu/drm/nouveau/nv50_display.c  |    4 ++--
> >  4 files changed, 12 insertions(+), 21 deletions(-)
> > 
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
> > index 1c7db64..2ecf875 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_drv.h
> > +++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
> > @@ -580,7 +580,6 @@ struct drm_nouveau_private {
> >  
> >  	struct nouveau_bo *vga_ram;
> >  
> > -	struct workqueue_struct *wq;
> >  	struct work_struct irq_work;
> >  	struct work_struct hpd_work;
> >  
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
> > index 7bfd9e6..7d05a06 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_irq.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
> > @@ -52,17 +52,8 @@ static int nouveau_ratelimit(void)
> >  void
> >  nouveau_irq_preinstall(struct drm_device *dev)
> >  {
> > -	struct drm_nouveau_private *dev_priv = dev->dev_private;
> > -
> >  	/* Master disable */
> >  	nv_wr32(dev, NV03_PMC_INTR_EN_0, 0);
> > -
> > -	if (dev_priv->card_type >= NV_50) {
> > -		INIT_WORK(&dev_priv->irq_work, nv50_display_irq_handler_bh);
> > -		INIT_WORK(&dev_priv->hpd_work, nv50_display_irq_hotplug_bh);
> > -		spin_lock_init(&dev_priv->hpd_state.lock);
> > -		INIT_LIST_HEAD(&dev_priv->vbl_waiting);
> > -	}
> >  }
> >  
> >  int
> > diff --git a/drivers/gpu/drm/nouveau/nouveau_state.c b/drivers/gpu/drm/nouveau/nouveau_state.c
> > index 049f755..2eea6ea 100644
> > --- a/drivers/gpu/drm/nouveau/nouveau_state.c
> > +++ b/drivers/gpu/drm/nouveau/nouveau_state.c
> > @@ -839,17 +839,17 @@ int nouveau_load(struct drm_device *dev, unsigned long flags)
> >  	dev->dev_private = dev_priv;
> >  	dev_priv->dev = dev;
> >  
> > +	/* the followings are used only by >= NV_50 */
> > +	INIT_WORK(&dev_priv->irq_work, nv50_display_irq_handler_bh);
> > +	INIT_WORK(&dev_priv->hpd_work, nv50_display_irq_hotplug_bh);
> > +	spin_lock_init(&dev_priv->hpd_state.lock);
> > +	INIT_LIST_HEAD(&dev_priv->vbl_waiting);
> > +
> >  	dev_priv->flags = flags & NOUVEAU_FLAGS;
> >  
> >  	NV_DEBUG(dev, "vendor: 0x%X device: 0x%X class: 0x%X\n",
> >  		 dev->pci_vendor, dev->pci_device, dev->pdev->class);
> >  
> > -	dev_priv->wq = create_workqueue("nouveau");
> > -	if (!dev_priv->wq) {
> > -		ret = -EINVAL;
> > -		goto err_priv;
> > -	}
> > -
> >  	/* resource 0 is mmio regs */
> >  	/* resource 1 is linear FB */
> >  	/* resource 2 is RAMIN (mmio regs + 0x1000000) */
> > @@ -862,7 +862,7 @@ int nouveau_load(struct drm_device *dev, unsigned long flags)
> >  		NV_ERROR(dev, "Unable to initialize the mmio mapping. "
> >  			 "Please report your setup to " DRIVER_EMAIL "\n");
> >  		ret = -EINVAL;
> > -		goto err_wq;
> > +		goto err_priv;
> >  	}
> >  	NV_DEBUG(dev, "regs mapped ok at 0x%llx\n",
> >  					(unsigned long long)mmio_start_offs);
> > @@ -969,8 +969,6 @@ err_ramin:
> >  	iounmap(dev_priv->ramin);
> >  err_mmio:
> >  	iounmap(dev_priv->mmio);
> > -err_wq:
> > -	destroy_workqueue(dev_priv->wq);
> >  err_priv:
> >  	kfree(dev_priv);
> >  	dev->dev_private = NULL;
> > @@ -992,6 +990,9 @@ int nouveau_unload(struct drm_device *dev)
> >  	engine->display.destroy(dev);
> >  	nouveau_card_takedown(dev);
> >  
> > +	flush_work_sync(&dev_priv->irq_work);
> > +	flush_work_sync(&dev_priv->hpd_work);
> > +
> >  	iounmap(dev_priv->mmio);
> >  	iounmap(dev_priv->ramin);
> >  
> > diff --git a/drivers/gpu/drm/nouveau/nv50_display.c b/drivers/gpu/drm/nouveau/nv50_display.c
> > index f624c61..3d569da 100644
> > --- a/drivers/gpu/drm/nouveau/nv50_display.c
> > +++ b/drivers/gpu/drm/nouveau/nv50_display.c
> > @@ -1110,7 +1110,7 @@ nv50_display_irq_handler(struct drm_device *dev)
> >  		dev_priv->hpd_state.hpd1_bits |= hpd1_bits;
> >  		spin_unlock(&dev_priv->hpd_state.lock);
> >  
> > -		queue_work(dev_priv->wq, &dev_priv->hpd_work);
> > +		schedule_work(&dev_priv->hpd_work);
> >  	}
> >  
> >  	while (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_DISPLAY) {
> > @@ -1139,7 +1139,7 @@ nv50_display_irq_handler(struct drm_device *dev)
> >  		if (clock) {
> >  			nv_wr32(dev, NV03_PMC_INTR_EN_0, 0);
> >  			if (!work_pending(&dev_priv->irq_work))
> > -				queue_work(dev_priv->wq, &dev_priv->irq_work);
> > +				schedule_work(&dev_priv->irq_work);
> >  			delayed |= clock;
> >  			intr1 &= ~clock;
> >  		}
> 
> 


