Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab1H0O5G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 10:57:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46615 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753792Ab1H0O5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 10:57:00 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug 26 15:04:20 2011
Message-Id: <20110826220420.656333466@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 26 Aug 2011 15:03:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [18/20] drm/ttm: fix ttm_bo_add_ttm(user) failure path
In-Reply-To: <20110826220431.GA15382@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -343,8 +343,10 @@ static int ttm_bo_add_ttm(struct ttm_buf
 
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


