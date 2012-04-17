Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab2DQTan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 15:30:43 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:50765 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab2DQTaR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 15:30:17 -0400
From: Jim Meyering <jim@meyering.net>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] drm/nouveau/pm: don't read/write beyond end of stack buffer
Date: Tue, 17 Apr 2012 21:27:54 +0200
Message-ID: <87d37640qt.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NUL-terminate after strncpy.

If the parameter "profile" has length 16 or more, then strncpy
leaves "string" with no NUL terminator, so the following search
for '\n' may read beyond the end of that 16-byte buffer.
If it finds a newline there, then it will also write beyond the
end of that stack buffer.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_pm.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_pm.c b/drivers/gpu/drm/nouveau/nouveau_pm.c
index 34d591b..da3e7c3 100644
--- a/drivers/gpu/drm/nouveau/nouveau_pm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_pm.c
@@ -225,26 +225,27 @@ profile_find(struct drm_device *dev, const char *string)
 static int
 nouveau_pm_profile_set(struct drm_device *dev, const char *profile)
 {
 	struct drm_nouveau_private *dev_priv = dev->dev_private;
 	struct nouveau_pm_engine *pm = &dev_priv->engine.pm;
 	struct nouveau_pm_profile *ac = NULL, *dc = NULL;
 	char string[16], *cur = string, *ptr;

 	/* safety precaution, for now */
 	if (nouveau_perflvl_wr != 7777)
 		return -EPERM;

 	strncpy(string, profile, sizeof(string));
+	string[sizeof(string) - 1] = 0;
 	if ((ptr = strchr(string, '\n')))
 		*ptr = '\0';

 	ptr = strsep(&cur, ",");
 	if (ptr)
 		ac = profile_find(dev, ptr);

 	ptr = strsep(&cur, ",");
 	if (ptr)
 		dc = profile_find(dev, ptr);
 	else
 		dc = ac;

--
1.7.10.208.gb4267
