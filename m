Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933734Ab1D2TH7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:07:59 -0400
Received: from kroah.org ([198.145.64.141]:50239 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab1D2S6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:18 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:54 2011
Message-Id: <20110429185654.140264014@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Pekka Paalanen <pq@iki.fi>
Subject: [16/55] drm/nouveau: fix notifier memory corruption bug
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit a18d89ca026140eb8ac4459bf70a01c571dd9a32 upstream.

nouveau_bo_wr32 expects offset to be in words, but we pass value in bytes,
so after commit 73412c3854c877e5f37ad944ee8977addde4d35a ("drm/nouveau: allocate
kernel's notifier object at end of block") we started to overwrite some memory
after notifier buffer object (previously m2mf_ntfy was always 0, so it didn't
matter it was a value in bytes).

Reported-by: Dominik Brodowski <linux@dominikbrodowski.net>
Reported-by: Nigel Cunningham <lkml@nigelcunningham.com.au>
Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Ben Skeggs <bskeggs@redhat.com>
Cc: Pekka Paalanen <pq@iki.fi>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/nouveau_fbcon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fbcon.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fbcon.c
@@ -181,13 +181,13 @@ nouveau_fbcon_sync(struct fb_info *info)
 		OUT_RING  (chan, 0);
 	}
 
-	nouveau_bo_wr32(chan->notifier_bo, chan->m2mf_ntfy + 3, 0xffffffff);
+	nouveau_bo_wr32(chan->notifier_bo, chan->m2mf_ntfy/4 + 3, 0xffffffff);
 	FIRE_RING(chan);
 	mutex_unlock(&chan->mutex);
 
 	ret = -EBUSY;
 	for (i = 0; i < 100000; i++) {
-		if (!nouveau_bo_rd32(chan->notifier_bo, chan->m2mf_ntfy + 3)) {
+		if (!nouveau_bo_rd32(chan->notifier_bo, chan->m2mf_ntfy/4 + 3)) {
 			ret = 0;
 			break;
 		}


