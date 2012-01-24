Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab2AXWda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 17:33:30 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36544 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2AXWd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 17:33:27 -0500
Date: Tue, 24 Jan 2012 17:33:19 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Martin Nyhus <martin.nyhus@gmx.com>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [next] Null pointer dereference in nouveau_vm_map_sg
Message-ID: <20120124223319.GA10002@homer.localdomain>
References: <201201152231.08561.martin.nyhus@gmx.com>
 <20120116203059.GC4482@homer.localdomain>
 <201201170057.51404.martin.nyhus@gmx.com>
 <20120122183316.GA12594@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SUOF0GtieIMvvwua"
Content-Disposition: inline
In-Reply-To: <20120122183316.GA12594@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 22, 2012 at 01:33:16PM -0500, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 17, 2012 at 12:57:50AM +0100, Martin Nyhus wrote:
> > On Monday 16. January 2012 21:30:59 Jerome Glisse wrote:
> > > On Sun, Jan 15, 2012 at 10:31:08PM +0100, Martin Nyhus wrote:
> > > > In some cases mem will be null in nouveau_vm_map_sg, resulting in a crash
> > > > at drivers/gpu/drm/nouveau/nouveau_vm.c:84. It seems to be easy enough to
> > > > reproduce, so I can test patches if needed.
> > > How do you trigger this ?
> > 
> > Opening 10-15 high-res pictures in Firefox triggers it every time. Doing the 
> > same using Gimp does not, and neither does Firefox and lots of small images 
> > (eg. Google image search).
> 
> I seem to be able to trigger this by using both Chrome and Firefox and 
> seeing a YouTube video. I did at that time have a dual-head display, while
> in the past to reproduce this I had only one monitor and it took a bit of
> time before I hit it.

Can you please both test if attached patch fix it for you ?

Cheers,
Jerome

--SUOF0GtieIMvvwua
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-drm-nouveau-fix-move-notify-callback.patch"

>From 67d4836e3511db2691c4ff2d3a23bf8c0e950edb Mon Sep 17 00:00:00 2001
From: John Doe <glisse@dhcp-189-215.bos.redhat.com>
Date: Tue, 24 Jan 2012 22:55:26 -0500
Subject: [PATCH] drm/nouveau: fix move notify callback

On vram buffer eviction the ttm_bo_move_accel_cleanup will the
mm_node field of struct ttm_mem_reg of new_mem placement to NULL.
As move notify call back is now call after ttm_bo_move_accel_cleanup
it was using NULL ptr for mm_node.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 724b41a..3a9d978 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -814,13 +814,13 @@ nouveau_bo_move_ntfy(struct ttm_buffer_object *bo, struct ttm_mem_reg *new_mem)
 
 	list_for_each_entry(vma, &nvbo->vma_list, head) {
 		if (new_mem && new_mem->mem_type == TTM_PL_VRAM) {
-			nouveau_vm_map(vma, new_mem->mm_node);
+			nouveau_vm_map(vma, bo->mem.mm_node);
 		} else
 		if (new_mem && new_mem->mem_type == TTM_PL_TT &&
 		    nvbo->page_shift == vma->vm->spg_shift) {
 			nouveau_vm_map_sg(vma, 0, new_mem->
 					  num_pages << PAGE_SHIFT,
-					  new_mem->mm_node);
+					  bo->mem.mm_node);
 		} else {
 			nouveau_vm_unmap(vma);
 		}
-- 
1.7.7.6


--SUOF0GtieIMvvwua--
