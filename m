Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1H0Oz6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:55:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905Ab1H0Ozv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:55:51 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:01:21 2011
Message-Id: <20110826220121.342820140@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 14:58:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [17/19] drm/ttm: fix ttm_bo_add_ttm(user) failure path
In-Reply-To: <20110826220137.GA14059@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 7c4c3960dff109bc5db4c35da481c212dadb5eb5 upstream.

ttm_tt_destroy kfrees passed object, so we need to nullify
a reference to it.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/ttm/ttm_bo.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -281,8 +281,10 @@ static int ttm_bo_add_ttm(struct ttm_buf
 
 		ret = ttm_tt_set_user(bo->ttm, current,
 				      bo->buffer_start, bo->num_pages);
-		if (unlikely(ret != 0))
+		if (unlikely(ret != 0)) {
 			ttm_tt_destroy(bo->ttm);
+			bo->ttm = NULL;
+		}
 		break;
 	default:
 		printk(KERN_ERR TTM_PFX "Illegal buffer object type\n");


