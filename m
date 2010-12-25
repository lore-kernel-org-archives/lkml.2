Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0LYSKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 13:10:52 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14227 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab0LYSKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 13:10:51 -0500
Date: Sat, 25 Dec 2010 19:01:05 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: ceph-devel@vger.kernel.org
cc: linux-kernel@vger.kernel.org, Sage Weil <sage@newdream.net>
Subject: [PATCH] Ceph: Fix use-after-free in destroy_fs_client()
Message-ID: <alpine.LNX.2.00.1012251858190.10759@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In fs/ceph/super.c::destroy_fs_client() the pointer 'fsc' is freed by 
kfree() and subsequently used in a call to dout() - use after free bug.
Easily fixed by simply moving the kfree() call after the dout() call.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 super.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 08b460a..7373594 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -498,8 +498,8 @@ void destroy_fs_client(struct ceph_fs_client *fsc)
 
 	ceph_destroy_client(fsc->client);
 
-	kfree(fsc);
 	dout("destroy_fs_client %p done\n", fsc);
+	kfree(fsc);
 }
 
 /*


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

