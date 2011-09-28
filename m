Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303Ab1I1Wkv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:40:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275Ab1I1Wks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:40:48 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:33 2011
Message-Id: <20110928220133.207497459@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [075/244] drm/nouveau: properly handle allocation failure in nouveau_sgdma_populate
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 17c8b960930da3599e47801a54ac0ea1070545d2 upstream.

Not cleaning after alloc failure would result in crash on destroy,
because nouveau_sgdma_clear assumes "ttm_alloced" to be not null when
"pages" is not null.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/nouveau_sgdma.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nouveau_sgdma.c
+++ b/drivers/gpu/drm/nouveau/nouveau_sgdma.c
@@ -37,8 +37,11 @@ nouveau_sgdma_populate(struct ttm_backen
 		return -ENOMEM;
 
 	nvbe->ttm_alloced = kmalloc(sizeof(bool) * num_pages, GFP_KERNEL);
-	if (!nvbe->ttm_alloced)
+	if (!nvbe->ttm_alloced) {
+		kfree(nvbe->pages);
+		nvbe->pages = NULL;
 		return -ENOMEM;
+	}
 
 	nvbe->nr_pages = 0;
 	while (num_pages--) {


