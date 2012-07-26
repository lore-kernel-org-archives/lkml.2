Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2GZLWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 07:22:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63779 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab2GZLV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 07:21:29 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/9] audit: make audit_compare_dname_path use parent_len helper
Date: Thu, 26 Jul 2012 07:21:11 -0400
Message-Id: <1343301673-10642-8-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1343301673-10642-1-git-send-email-jlayton@redhat.com>
References: <1343301673-10642-1-git-send-email-jlayton@redhat.com>
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
1.7.11.2

