Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab1FQQ5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 12:57:07 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:56034 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312Ab1FQQ47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 12:56:59 -0400
From: Pavel Shved <shved@ispras.ru>
Cc: Pavel Shved <shved@ispras.ru>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] hecubafb: add module_put on error path in hecubafb_probe()
Date: Fri, 17 Jun 2011 20:25:12 +0400
Message-Id: <1308327913-23220-3-git-send-email-shved@ispras.ru>
X-Mailer: git-send-email 1.7.0.2
In-Reply-To: <1308327913-23220-1-git-send-email-shved@ispras.ru>
References: <1308327913-23220-1-git-send-email-shved@ispras.ru>
To: Paul Mundt <lethal@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In hecubafb_probe(), after a successful try_module_get, vzalloc may
fail and make the hecubafb_probe return, but the module is not put on
this error path.

This patch adds an exit point that calls module_put in such situation.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Pavel Shved <shved@ispras.ru>
---
 drivers/video/hecubafb.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/hecubafb.c b/drivers/video/hecubafb.c
index fbef15f..614251a 100644
--- a/drivers/video/hecubafb.c
+++ b/drivers/video/hecubafb.c
@@ -233,7 +233,7 @@ static int __devinit hecubafb_probe(struct platform_device *dev)
 
 	videomemory = vzalloc(videomemorysize);
 	if (!videomemory)
-		return retval;
+		goto err_videomem_alloc;
 
 	info = framebuffer_alloc(sizeof(struct hecubafb_par), &dev->dev);
 	if (!info)
@@ -275,6 +275,7 @@ err_fbreg:
 	framebuffer_release(info);
 err_fballoc:
 	vfree(videomemory);
+err_videomem_alloc:
 	module_put(board->owner);
 	return retval;
 }
-- 
1.7.0.2

