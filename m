Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602Ab1DNR4I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:56:08 -0400
Received: from mail.windriver.com ([147.11.1.11]:38342 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933259Ab1DNRqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Francisco Jerez <currojerez@riseup.net>,
        Dave Airlie <airlied@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 067/209] drm/ttm: Clear the ghost cpu_writers flag on ttm_buffer_object_transfer.
Date: Thu, 14 Apr 2011 13:41:37 -0400
Message-Id: <1302803039-9400-68-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francisco Jerez <currojerez@riseup.net>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/gpu/drm/ttm/ttm_bo_util.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index d764e82..fe04f8c 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -327,6 +327,7 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	INIT_LIST_HEAD(&fbo->lru);
 	INIT_LIST_HEAD(&fbo->swap);
 	fbo->vm_node = NULL;
+	atomic_set(&fbo->cpu_writers, 0);
 
 	fbo->sync_obj = driver->sync_obj_ref(bo->sync_obj);
 	if (fbo->mem.mm_node)
-- 
1.7.4.4

