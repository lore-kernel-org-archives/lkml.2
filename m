Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751125Ab0LYGDd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 01:03:33 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47502 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0LYGDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 01:03:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=PS1l/QaIYblUanv7n5gykCTCrF0f9rWRoFH66FpAk2mlzbjXY+2EKA6LKz3Aqty5aG
         hJLHyJRLTi75Qz7qRXkzgBV9VokZdq4LhIKeRIvje4qQSD2mYKi9vvyOzA9aJOr+nrxr
         NZQqXo5fi8rntqfx1JPdhVD1dLrpYYX14oxxE=
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Jeremy Kerr <jk@ozlabs.org>,
        linuxppc-dev@lists.ozlabs.org, cbe-oss-dev@lists.ozlabs.org
Subject: [PATCH] spufs: use simple_write_to_buffer
Date: Sat, 25 Dec 2010 15:03:56 +0900
Message-Id: <1293257039-2580-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <n>
References: <n>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify several write fileoperations for spufs by using
simple_write_to_buffer().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jeremy Kerr <jk@ozlabs.org>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: cbe-oss-dev@lists.ozlabs.org
---
 arch/powerpc/platforms/cell/spufs/file.c |   27 +++++++--------------------
 1 files changed, 7 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
index 02f7b11..3c7c3f8 100644
--- a/arch/powerpc/platforms/cell/spufs/file.c
+++ b/arch/powerpc/platforms/cell/spufs/file.c
@@ -219,24 +219,17 @@ spufs_mem_write(struct file *file, const char __user *buffer,
 	loff_t pos = *ppos;
 	int ret;
 
-	if (pos < 0)
-		return -EINVAL;
 	if (pos > LS_SIZE)
 		return -EFBIG;
-	if (size > LS_SIZE - pos)
-		size = LS_SIZE - pos;
 
 	ret = spu_acquire(ctx);
 	if (ret)
 		return ret;
 
 	local_store = ctx->ops->get_ls(ctx);
-	ret = copy_from_user(local_store + pos, buffer, size);
+	size = simple_write_to_buffer(local_store, LS_SIZE, ppos, buffer, size);
 	spu_release(ctx);
 
-	if (ret)
-		return -EFAULT;
-	*ppos = pos + size;
 	return size;
 }
 
@@ -574,18 +567,15 @@ spufs_regs_write(struct file *file, const char __user *buffer,
 	if (*pos >= sizeof(lscsa->gprs))
 		return -EFBIG;
 
-	size = min_t(ssize_t, sizeof(lscsa->gprs) - *pos, size);
-	*pos += size;
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
 
-	ret = copy_from_user((char *)lscsa->gprs + *pos - size,
-			     buffer, size) ? -EFAULT : size;
+	size = simple_write_to_buffer(lscsa->gprs, sizeof(lscsa->gprs), pos,
+					buffer, size);
 
 	spu_release_saved(ctx);
-	return ret;
+	return size;
 }
 
 static const struct file_operations spufs_regs_fops = {
@@ -630,18 +620,15 @@ spufs_fpcr_write(struct file *file, const char __user * buffer,
 	if (*pos >= sizeof(lscsa->fpcr))
 		return -EFBIG;
 
-	size = min_t(ssize_t, sizeof(lscsa->fpcr) - *pos, size);
-
 	ret = spu_acquire_saved(ctx);
 	if (ret)
 		return ret;
 
-	*pos += size;
-	ret = copy_from_user((char *)&lscsa->fpcr + *pos - size,
-			     buffer, size) ? -EFAULT : size;
+	size = simple_write_to_buffer(&lscsa->fpcr, sizeof(lscsa->fpcr), pos,
+					buffer, size);
 
 	spu_release_saved(ctx);
-	return ret;
+	return size;
 }
 
 static const struct file_operations spufs_fpcr_fops = {
-- 
1.7.3.4

