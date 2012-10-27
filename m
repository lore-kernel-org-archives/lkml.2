Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab2J0Mf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:35:27 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64624 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab2J0Mem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:34:42 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v8 31/32] vfs: convert filename_lookup to use retry_estale helper
Date: Sat, 27 Oct 2012 08:33:38 -0400
Message-Id: <1351341219-17837-32-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
References: <1351341219-17837-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index c6173cc..6886630 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2020,10 +2020,11 @@ static int path_lookupat(int dfd, const char *name,
 static int filename_lookup(int dfd, struct filename *name,
 				unsigned int flags, struct nameidata *nd)
 {
+	unsigned int try = 0;
 	int retval = path_lookupat(dfd, name->name, flags | LOOKUP_RCU, nd);
 	if (unlikely(retval == -ECHILD))
 		retval = path_lookupat(dfd, name->name, flags, nd);
-	if (unlikely(retval == -ESTALE))
+	while (retry_estale(retval, try++))
 		retval = path_lookupat(dfd, name->name,
 						flags | LOOKUP_REVAL, nd);
 
-- 
1.7.11.7

