Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab0LHArY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:24 -0500
Received: from kroah.org ([198.145.64.141]:58373 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756094Ab0LHArW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:22 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:30 2010
Message-Id: <20101208004430.103698335@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:44:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Francisco Jerez <currojerez@riseup.net>,
        Dave Airlie <airlied@redhat.com>
Subject: [058/127] drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Francisco Jerez <currojerez@riseup.net>

commit 0fbecd400dd0a82d465b3086f209681e8c54cb0f upstream.

It makes sense for a BO to move after a process has requested
exclusive RW access on it (e.g. because the BO used to be located in
unmappable VRAM and we intercepted the CPU access from the fault
handler).

If we let the ghost object inherit cpu_writers from the original
object, ttm_bo_release_list() will raise a kernel BUG when the ghost
object is destroyed. This can be reproduced with the nouveau driver on
nv5x.

Reported-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Tested-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -330,6 +330,7 @@ static int ttm_buffer_object_transfer(st
 	INIT_LIST_HEAD(&fbo->lru);
 	INIT_LIST_HEAD(&fbo->swap);
 	fbo->vm_node = NULL;
+	atomic_set(&fbo->cpu_writers, 0);
 
 	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
 	if (fbo->mem.mm_node)


