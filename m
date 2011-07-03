Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab1GCKev (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 06:34:51 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:24758 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755440Ab1GCKeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 06:34:50 -0400
Date: Sun, 3 Jul 2011 12:25:31 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: dri-devel@lists.freedesktop.org, Ben Skeggs <bskeggs@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Francisco Jerez <currojerez@riseup.net>
Subject: [PATCH] nouveau: Do not leak in nv20_graph_create
Message-ID: <alpine.LNX.2.00.1107031224030.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we return due to an unknown chipset in 
drivers/gpu/drm/nouveau/nv20_graph.c:nv20_graph_create() we'll leak the 
memory allocated to 'pgraph'.

This patch should fix the leak and it also disambiguates the "PGRAPH:
unknown chipset\n" error message - it's nice to be able to tell which
branch created the error which is impossible if the error messages are
100% identical.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/gpu/drm/nouveau/nv20_graph.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

  Don't have the hardware, so compile tested only.

diff --git a/drivers/gpu/drm/nouveau/nv20_graph.c b/drivers/gpu/drm/nouveau/nv20_graph.c
index affc7d7..059ad65 100644
--- a/drivers/gpu/drm/nouveau/nv20_graph.c
+++ b/drivers/gpu/drm/nouveau/nv20_graph.c
@@ -752,6 +752,7 @@ nv20_graph_create(struct drm_device *dev)
 			pgraph->grctx_user = 0x0000;
 			break;
 		default:
+			kfree(pgraph);
 			NV_ERROR(dev, "PGRAPH: unknown chipset\n");
 			return 0;
 		}
@@ -773,7 +774,8 @@ nv20_graph_create(struct drm_device *dev)
 			pgraph->grctx_size = NV35_36_GRCTX_SIZE;
 			break;
 		default:
-			NV_ERROR(dev, "PGRAPH: unknown chipset\n");
+			kfree(pgraph);
+			NV_ERROR(dev, "PGRAPH: unknown chipset.\n");
 			return 0;
 		}
 	}
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

