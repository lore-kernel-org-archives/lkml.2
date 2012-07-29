Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483Ab2G2UP0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 16:15:26 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40165 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2G2UPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 16:15:24 -0400
Date: Sun, 29 Jul 2012 22:15:32 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Ortwin =?utf-8?B?R2zDvGNr?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, bskeggs@redhat.com,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Subject: Re: drm/nouveau: crash regression in 3.5
Message-ID: <20120729201532.GA3566@joi.lan>
References: <500D916A.60703@odi.ch>
 <20120724170002.GA3129@joi.lan>
 <500ED9EC.5040309@odi.ch>
 <20120724205746.GA8707@joi.lan>
 <500FB279.1020904@odi.ch>
 <20120725184205.GA3119@joi.lan>
 <50113E76.9090706@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <50113E76.9090706@odi.ch>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 02:56:22PM +0200, Ortwin Glück wrote:
> On 25.07.2012 20:42, Marcin Slusarz wrote:
> > Good, below patch should fix this panic.
> >
> > Note that you can hit an oops in drm_handle_vblank because patch from
> > http://lists.freedesktop.org/archives/dri-devel/2012-May/023498.html
> > has not been applied (yet?).
> 
> After applying your patch, it still crashes, although with a slightly 
> different stack trace. I then also applied the second patch, but that 
> doesn't make any difference. New log attached.
> 
> Looks like interrupt occurs before nouveau_software_context_new() is 
> called? Shouldn't the initialization be done from 
> nouveau_irq_preinstall() so it is available when the irq occurs? Again, 
> I am not an expert here. Just guessing...

No, the real problem is: with "noaccel" we don't register "software engine",
but vblank ISR relies on its existance and happily derefences NULL pointer.

Now, this patch should fix it for real...

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] drm/nouveau: disable vblank interrupts before registering PDISPLAY ISR

Currently, we register vblank IRQ handler and later we disable vblank
interrupts. So, for the short amount of time, we rely on vblank ISR
to operate correctly, even if vblank interrupts are never going to be
used later.

In "noaccel" case, software engine - which is used by vblank ISR - is not
registered, so if vblank interrupt triggers in a wrong moment, we can hit
NULL pointer dereference in nouveau_software_vblank.

To fix it, disable vblank interrupts before registering PDISPLAY ISR.

Reported-by: Ortwin Glück <odi@odi.ch>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: stable@vger.kernel.org [3.5]
---
 drivers/gpu/drm/nouveau/nv04_crtc.c    |    1 +
 drivers/gpu/drm/nouveau/nv50_crtc.c    |    1 +
 drivers/gpu/drm/nouveau/nvd0_display.c |    2 ++
 3 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nv04_crtc.c b/drivers/gpu/drm/nouveau/nv04_crtc.c
index 4c31c63..38bfe8d 100644
--- a/drivers/gpu/drm/nouveau/nv04_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv04_crtc.c
@@ -1057,6 +1057,7 @@ nv04_crtc_create(struct drm_device *dev, int crtc_num)
 	}
 
 	nv04_cursor_init(nv_crtc);
+	nouveau_vblank_disable(dev, crtc_num);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/nouveau/nv50_crtc.c b/drivers/gpu/drm/nouveau/nv50_crtc.c
index 97a477b..7648f52 100644
--- a/drivers/gpu/drm/nouveau/nv50_crtc.c
+++ b/drivers/gpu/drm/nouveau/nv50_crtc.c
@@ -792,6 +792,7 @@ nv50_crtc_create(struct drm_device *dev, int index)
 		goto out;
 
 	nv50_cursor_init(nv_crtc);
+	nouveau_vblank_disable(dev, index);
 out:
 	if (ret)
 		nv50_crtc_destroy(&nv_crtc->base);
diff --git a/drivers/gpu/drm/nouveau/nvd0_display.c b/drivers/gpu/drm/nouveau/nvd0_display.c
index c486d3c..32f8a86 100644
--- a/drivers/gpu/drm/nouveau/nvd0_display.c
+++ b/drivers/gpu/drm/nouveau/nvd0_display.c
@@ -908,6 +908,8 @@ nvd0_crtc_create(struct drm_device *dev, int index)
 		goto out;
 
 	nvd0_crtc_lut_load(crtc);
+	/* uncomment once nvd0 vblank lands */
+	/* nouveau_vblank_disable(dev, index); */
 
 out:
 	if (ret)
-- 
