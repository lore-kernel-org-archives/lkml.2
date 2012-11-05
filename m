Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab2KEP0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 10:26:41 -0500
Received: from mail-gg0-f174.google.com ([209.85.161.174]:58921 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab2KEPXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 10:23:15 -0500
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v9 29/34] vfs: convert do_filp_open to use retry_estale helper
Date: Mon,  5 Nov 2012 10:22:08 -0500
Message-Id: <1352128933-28526-30-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
References: <1352128933-28526-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 39adf1b..45a45d7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -3012,11 +3012,12 @@ struct file *do_filp_open(int dfd, struct filename *pathname,
 {
 	struct nameidata nd;
 	struct file *filp;
+	unsigned int try = 0;
 
 	filp = path_openat(dfd, pathname, &nd, op, flags | LOOKUP_RCU);
 	if (unlikely(filp == ERR_PTR(-ECHILD)))
 		filp = path_openat(dfd, pathname, &nd, op, flags);
-	if (unlikely(filp == ERR_PTR(-ESTALE)))
+	while (retry_estale(PTR_ERR(filp), try++))
 		filp = path_openat(dfd, pathname, &nd, op, flags | LOOKUP_REVAL);
 	return filp;
 }
-- 
1.7.11.7

