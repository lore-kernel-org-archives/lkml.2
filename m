Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751090Ab2GYSl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:41:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45006 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2GYSl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:41:56 -0400
Date: Wed, 25 Jul 2012 20:42:05 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120725184205.GA3119@joi.lan>
References: <500D916A.60703@odi.ch>
 <20120724170002.GA3129@joi.lan>
 <500ED9EC.5040309@odi.ch>
 <20120724205746.GA8707@joi.lan>
 <500FB279.1020904@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <500FB279.1020904@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 10:46:49AM +0200, Ortwin Glück wrote:
> > Does it work if you boot without X and modprobe nouveau manually? If it does,
> > can you disable page flipping in xorg.conf (Option "PageFlip" "0" in nouveau
> > device section) and recheck with X?
> 
> It happens long before X, when the nouveau module is loaded.
> 
> > Does it work if you disable acceleration (nouveau.noaccel=1 in kernel command
> > line)?
> 
> nouveau.noaccel=1 is already on my cmdline as running X with accel 
> enabled never worked anyway.
> 
>  > Is there anything saved in /var/log/ from previous boot? Can you ssh
> > into and check dmesg? Can you use netconsole and catch full log?
> 
> Thanks for the netconsole tip. I have attached the log.
> 

Good, below patch should fix this panic.

Note that you can hit an oops in drm_handle_vblank because patch from
http://lists.freedesktop.org/archives/dri-devel/2012-May/023498.html
has not been applied (yet?).

--
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Date: Wed, 25 Jul 2012 20:07:22 +0200
Subject: [PATCH] drm/nouveau: init vblank requests list

Fixes kernel panic when vblank interrupt triggers before first sync to vblank
request.

(Besides init, remove some relevant leftovers from vblank rework)

Reported-by: Ortwin Glück <odi@odi.ch>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: stable@vger.kernel.org [3.5]
---
 drivers/gpu/drm/nouveau/nouveau_drv.h      |    2 --
 drivers/gpu/drm/nouveau/nouveau_irq.c      |    4 ----
 drivers/gpu/drm/nouveau/nouveau_software.h |    1 +
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_drv.h b/drivers/gpu/drm/nouveau/nouveau_drv.h
index 8613cb2..b863a3a 100644
--- a/drivers/gpu/drm/nouveau/nouveau_drv.h
+++ b/drivers/gpu/drm/nouveau/nouveau_drv.h
@@ -689,8 +689,6 @@ struct drm_nouveau_private {
 	void (*irq_handler[32])(struct drm_device *);
 	bool msi_enabled;
 
-	struct list_head vbl_waiting;
-
 	struct {
 		struct drm_global_reference mem_global_ref;
 		struct ttm_bo_global_ref bo_global_ref;
diff --git a/drivers/gpu/drm/nouveau/nouveau_irq.c b/drivers/gpu/drm/nouveau/nouveau_irq.c
index 868c7fd..b2c2937 100644
--- a/drivers/gpu/drm/nouveau/nouveau_irq.c
+++ b/drivers/gpu/drm/nouveau/nouveau_irq.c
@@ -41,12 +41,8 @@
 void
 nouveau_irq_preinstall(struct drm_device *dev)
 {
-	struct drm_nouveau_private *dev_priv = dev->dev_private;
-
 	/* Master disable */
 	nv_wr32(dev, NV03_PMC_INTR_EN_0, 0);
-
-	INIT_LIST_HEAD(&dev_priv->vbl_waiting);
 }
 
 int
diff --git a/drivers/gpu/drm/nouveau/nouveau_software.h b/drivers/gpu/drm/nouveau/nouveau_software.h
index e60bc6c..b507a92 100644
--- a/drivers/gpu/drm/nouveau/nouveau_software.h
+++ b/drivers/gpu/drm/nouveau/nouveau_software.h
@@ -38,6 +38,7 @@ static inline void
 nouveau_software_context_new(struct nouveau_software_chan *pch)
 {
 	INIT_LIST_HEAD(&pch->flip);
+	INIT_LIST_HEAD(&pch->vblank.list);
 }
 
 static inline void
-- 
