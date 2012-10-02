Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121Ab2JBAVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:21:01 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42765 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab2JBASB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:18:01 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 39/49] vfs: convert do_filp_open to use retry_estale helper
Date: Mon,  1 Oct 2012 20:16:48 -0400
Message-Id: <1349137018-21948-40-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index dfdcd47..8e39510 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3015,11 +3015,12 @@ struct file *do_filp_open(int dfd, struct getname_info *ginfo,
 {
 	struct nameidata nd;
 	struct file *filp;
+	unsigned int try = 0;
 
 	filp = path_openat(dfd, ginfo, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
 		filp = path_openat(dfd, ginfo, &nd, op, flags);
-	if (unlikely(filp == ERR_PTR(-ESTALE)))
+	while (retry_estale(PTR_ERR(filp), try++))
 		filp = path_openat(dfd, ginfo, &nd, op, flags | LOOKUP_REVAL);
 	return filp;
 }
-- 
1.7.11.4

