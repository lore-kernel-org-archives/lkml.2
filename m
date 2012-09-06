Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759223Ab2IFQtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:49:31 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:37343 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759174Ab2IFQt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:49:28 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: Inki Dae <inki.dae@samsung.com>, Joonyoung Shim <jy0922.shim@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org,
        Paul Menzel <paulepanter@users.sourceforge.net>,
        =?UTF-8?q?St=C3=A9phane=20Marchesin?= <marcheu@chromium.org>,
        Pawel Osciak <posciak@google.com>
Cc: Mandeep Singh Baines <msb@chromium.org>
Subject: [PATCH] drm/exynos: fix double call of drm_prime_(init/destroy)_file_private
Date: Thu,  6 Sep 2012 09:49:23 -0700
Message-Id: <1346950163-17590-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <CAAQKjZPGefy9333AGTN1iwxWuCiPvi85raDE7ijDmRcm9PPWWw@mail.gmail.com>
References: <CAAQKjZPGefy9333AGTN1iwxWuCiPvi85raDE7ijDmRcm9PPWWw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The double invocations are incorrect but seem to be safe so I don't
think this will fix any bugs.

Before:

[    7.639366] drm_prime_init_file ee3675d0
[    7.639377] drm_prime_init_file ee3675d0
[    7.639507] drm_prime_destroy_file ee3675d0
[    7.639518] drm_prime_destroy_file ee3675d0
[    7.639802] drm_prime_init_file ee372390
[    7.639810] drm_prime_init_file ee372390
[    8.473316] drm_prime_init_file ee356390
[    8.473331] drm_prime_init_file ee356390

After:

[    6.363842] drm_prime_init_file edc2e5d0
[    6.363994] drm_prime_destroy_file edc2e5d0
[    6.364260] drm_prime_init_file edc2e750
[    8.004837] drm_prime_init_file ee36ded0

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Acked-by: Seung-Woo Kim <sw0312.kim@samsung.com>
---
 drivers/gpu/drm/exynos/exynos_drm_drv.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_drv.c b/drivers/gpu/drm/exynos/exynos_drm_drv.c
index ebacec6..a27b8ff 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_drv.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_drv.c
@@ -160,7 +160,6 @@ static int exynos_drm_open(struct drm_device *dev, struct drm_file *file)
 	if (!file_priv)
 		return -ENOMEM;
 
-	drm_prime_init_file_private(&file->prime);
 	file->driver_priv = file_priv;
 
 	return exynos_drm_subdrv_open(dev, file);
@@ -184,7 +183,6 @@ static void exynos_drm_preclose(struct drm_device *dev,
 			e->base.destroy(&e->base);
 		}
 	}
-	drm_prime_destroy_file_private(&file->prime);
 	spin_unlock_irqrestore(&dev->event_lock, flags);
 
 	exynos_drm_subdrv_close(dev, file);
-- 
1.7.7.3

