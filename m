Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab1EFMyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:54:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:54307 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753151Ab1EFMyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:54:22 -0400
Date: Fri, 6 May 2011 18:24:18 +0530
From: Prem Karat <prem.karat@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] fs/9p: Fix invalid mount options/args
Message-ID: <20110506125417.GD6759@d6fc318.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fs/9p: Fix invalid mount options/args

Without this fix, if any invalid mount options/args are passed while mouting the 9p fs,
no error (-EINVAL) is returned and default arg value is assigned.

This fix returns -EINVAL when an invalid arguement is found while parsing mount options.

Signed-off-by: Prem Karat <prem.karat@linux.vnet.ibm.com>
---
 fs/9p/v9fs.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 files changed, 34 insertions(+), 9 deletions(-)

diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index c82b017..033c23e 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -78,6 +78,25 @@ static const match_table_t tokens = {
 	{Opt_err, NULL}
 };
 
+/* Interpret mount options for cache mode */
+static int get_cache_mode(char *s)
+{
+	int version = -EINVAL;
+
+	if (!strcmp(s, "loose")) {
+		version = CACHE_LOOSE;
+		P9_DPRINTK(P9_DEBUG_9P, "Cache mode: loose\n");
+	} else if (!strcmp(s, "fscache")) {
+		version = CACHE_FSCACHE;
+		P9_DPRINTK(P9_DEBUG_9P, "Cache mode: fscache\n");
+	} else if (!strcmp(s, "none")) {
+		version = CACHE_NONE;
+		P9_DPRINTK(P9_DEBUG_9P, "Cache mode: none\n");
+	} else
+		printk(KERN_INFO "9p: Unknown Cache mode %s.\n", s);
+	return version;
+}
+
 /**
  * v9fs_parse_options - parse mount options into session structure
  * @v9ses: existing v9fs session information
@@ -97,7 +116,7 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 	/* setup defaults */
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
-	v9ses->cache = 0;
+	v9ses->cache = CACHE_NONE;
 #ifdef CONFIG_9P_FSCACHE
 	v9ses->cachetag = NULL;
 #endif
@@ -171,13 +190,13 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 				  "problem allocating copy of cache arg\n");
 				goto free_and_return;
 			}
+			ret = get_cache_mode(s);
+			if (ret == -EINVAL) {
+				kfree(s);
+				goto free_and_return;
+			}
 
-			if (strcmp(s, "loose") == 0)
-				v9ses->cache = CACHE_LOOSE;
-			else if (strcmp(s, "fscache") == 0)
-				v9ses->cache = CACHE_FSCACHE;
-			else
-				v9ses->cache = CACHE_NONE;
+			v9ses->cache = ret;
 			kfree(s);
 			break;
 
@@ -200,9 +219,15 @@ static int v9fs_parse_options(struct v9fs_session_info *v9ses, char *opts)
 			} else {
 				v9ses->flags |= V9FS_ACCESS_SINGLE;
 				v9ses->uid = simple_strtoul(s, &e, 10);
-				if (*e != '\0')
-					v9ses->uid = ~0;
+				if (*e != '\0') {
+					ret = -EINVAL;
+					printk(KERN_INFO "9p: Unknown access "
+							"argument %s.\n", s);
+					kfree(s);
+					goto free_and_return;
+				}
 			}
+
 			kfree(s);
 			break;
 
-- 
1.7.4

-- 
Cheers,
Prem
Linux Technology Center,
IBM Systems & Technology Labs
