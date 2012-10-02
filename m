Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab2JBA2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:28:55 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38254 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2JBARQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:17:16 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: eparis@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com
Subject: [PATCH v7 08/49] audit: make audit_compare_dname_path use parent_len helper
Date: Mon,  1 Oct 2012 20:16:17 -0400
Message-Id: <1349137018-21948-9-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
References: <1349137018-21948-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/auditfilter.c | 27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f9c48d0..f47ba18 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -1232,32 +1232,19 @@ int parent_len(const char *path)
  * return of 0 indicates a match. */
 int audit_compare_dname_path(const char *dname, const char *path)
 {
-	int dlen, plen;
+	int dlen, pathlen, parentlen;
 	const char *p;
 
-	if (!dname || !path)
-		return 1;
-
 	dlen = strlen(dname);
-	plen = strlen(path);
-	if (plen < dlen)
+	pathlen = strlen(path);
+	if (pathlen < dlen)
 		return 1;
 
-	/* disregard trailing slashes */
-	p = path + plen - 1;
-	while ((*p == '/') && (p > path))
-		p--;
-
-	/* find last path component */
-	p = p - dlen + 1;
-	if (p < path)
+	parentlen = parent_len(path);
+	if (pathlen - parentlen != dlen)
 		return 1;
-	else if (p > path) {
-		if (*--p != '/')
-			return 1;
-		else
-			p++;
-	}
+
+	p = path + parentlen;
 
 	return strncmp(p, dname, dlen);
 }
-- 
1.7.11.4

