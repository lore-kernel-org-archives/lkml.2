Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab0J1LjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:39:09 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63214 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab0J1LjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hCVylNvymuCA3THPTuK4rbJQE8nJFJc7PcC058JZ8tDyxjXeXCCRAyxKroulEWLZm3
         7hITAp9vrJBNIMvut9AYvF+ObggxBHubO63UlPynh5d4gUMnXwotyJIxJPv3gAcWDKfc
         eETKjgXH9AUgMOG3sDAj0Wecc5X0PnZZsI5hY=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <ian.campbell@citrix.com>, xen-devel@lists.xen.org,
        virtualization@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xen: xenfs: privcmd: check put_user() return code
Date: Thu, 28 Oct 2010 15:39:02 +0400
Message-Id: <1288265942-12581-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_user() may fail.  In this case propagate error code from
privcmd_ioctl_mmap_batch().

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 drivers/xen/xenfs/privcmd.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/xen/xenfs/privcmd.c b/drivers/xen/xenfs/privcmd.c
index f80be7f..2eb04c8 100644
--- a/drivers/xen/xenfs/privcmd.c
+++ b/drivers/xen/xenfs/privcmd.c
@@ -266,9 +266,7 @@ static int mmap_return_errors(void *data, void *state)
 	xen_pfn_t *mfnp = data;
 	struct mmap_batch_state *st = state;
 
-	put_user(*mfnp, st->user++);
-
-	return 0;
+	return put_user(*mfnp, st->user++);
 }
 
 static struct vm_operations_struct privcmd_vm_ops;
@@ -323,10 +321,8 @@ static long privcmd_ioctl_mmap_batch(void __user *udata)
 	up_write(&mm->mmap_sem);
 
 	if (state.err > 0) {
-		ret = 0;
-
 		state.user = m.arr;
-		traverse_pages(m.num, sizeof(xen_pfn_t),
+		ret = traverse_pages(m.num, sizeof(xen_pfn_t),
 			       &pagelist,
 			       mmap_return_errors, &state);
 	}
-- 
1.7.0.4

