Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1I1XWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:22:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932336Ab1I1WlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:41:25 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:34 2011
Message-Id: <20110928220134.254059804@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:00:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Prem Karat <prem.karat@linux.vnet.ibm.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: [085/244] fs/9p: Fix invalid mount options/args
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Prem Karat <prem.karat@linux.vnet.ibm.com>

commit a2dd43bb0d7b9ce28f8a39254c25840c0730498e upstream.

Without this fix, if any invalid mount options/args are passed while mouting
the 9p fs, no error (-EINVAL) is returned and default arg value is assigned.

This fix returns -EINVAL when an invalid arguement is found while parsing
mount options.

Signed-off-by: Prem Karat <prem.karat@linux.vnet.ibm.com>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/9p/v9fs.c |   43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

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
@@ -97,7 +116,7 @@ static int v9fs_parse_options(struct v9f
 	/* setup defaults */
 	v9ses->afid = ~0;
 	v9ses->debug = 0;
-	v9ses->cache = 0;
+	v9ses->cache = CACHE_NONE;
 #ifdef CONFIG_9P_FSCACHE
 	v9ses->cachetag = NULL;
 #endif
@@ -171,13 +190,13 @@ static int v9fs_parse_options(struct v9f
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
 
@@ -200,9 +219,15 @@ static int v9fs_parse_options(struct v9f
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
 


