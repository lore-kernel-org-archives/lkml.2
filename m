Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0JWLiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:38:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41490 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab0JWLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:37:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=X0w6IcAwfVIFS7oPPRUflvSI7uVMLU6yTVdm3nqsRvu8TLk9BM3ESQAGaShBah2rpn
         h8pH5r8nh0iYCSh5zdohzWTpfZh/5N3hyRK8fd3jZ1/onL2XRIEjA5+vc8hYp08AJlOn
         y3j1w+y6EVZvgCGa5BlqDa8KZTRxRDXHMeULc=
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 2/6] udf: Remove BKL
Date: Sat, 23 Oct 2010 13:37:29 +0200
Message-Id: <1287833853-4175-2-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1287833853-4175-1-git-send-email-abogani@texware.it>
References: <1287833853-4175-1-git-send-email-abogani@texware.it>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The readdir function seems already enough protected by i_mutex held
by VFS invoking call.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/dir.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 51552bf..eb8bfe2 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -30,7 +30,6 @@
 #include <linux/errno.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
-#include <linux/smp_lock.h>
 #include <linux/buffer_head.h>
 
 #include "udf_i.h"
@@ -190,18 +189,14 @@ static int udf_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct inode *dir = filp->f_path.dentry->d_inode;
 	int result;
 
-	lock_kernel();
-
 	if (filp->f_pos == 0) {
 		if (filldir(dirent, ".", 1, filp->f_pos, dir->i_ino, DT_DIR) < 0) {
-			unlock_kernel();
 			return 0;
 		}
 		filp->f_pos++;
 	}
 
 	result = do_udf_readdir(dir, filp, filldir, dirent);
-	unlock_kernel();
  	return result;
 }
 
-- 
1.7.0.4

