Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933213Ab2IGLZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 07:25:21 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63388 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760440Ab2IGLYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 07:24:06 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, bfields@fieldses.org
Subject: [PATCH v6 08/10] audit: make audit_compare_dname_path use parent_len helper
Date: Fri,  7 Sep 2012 07:23:45 -0400
Message-Id: <1347017027-17167-9-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
References: <1347017027-17167-1-git-send-email-jlayton@redhat.com>
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

