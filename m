Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0LJOe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 09:34:28 -0500
Received: from adelie.canonical.com ([91.189.90.139]:38295 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0LJOe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 09:34:27 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Francisco Jerez <currojerez@riseup.net>
Cc: Dave Airlie <airlied@redhat.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [stable] Patch "drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer." has been added to 2.6.32+drm33-stable
Date: Fri, 10 Dec 2010 15:34:22 +0100
Message-Id: <1291991662-8240-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.0.4
To: Francisco Jerez <currojerez@riseup.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

to the drm-next branch of the 2.6.32+drm33-stable tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-stable tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 5e353d5fd91c564849790c39ef790b66400c24bc Mon Sep 17 00:00:00 2001
From: Francisco Jerez <currojerez@riseup.net>
Date: Tue, 21 Sep 2010 02:15:15 +0200
Subject: [PATCH] drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.

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
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index c70927e..8cb88e7 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -330,6 +330,7 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	INIT_LIST_HEAD(&fbo->lru);
 	INIT_LIST_HEAD(&fbo->swap);
 	fbo->vm_node = NULL;
+	atomic_set(&fbo->cpu_writers, 0);

 	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
 	if (fbo->mem.mm_node)
--
1.7.0.4


Disclaimer: Despite what Greg says, this is a stable tree. It just 
happens to have an unusual starting point of 2.6.33 for all the DRM 
and 2.6.32 for all the rest.
