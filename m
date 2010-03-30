Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab0C3XqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:46:08 -0400
Received: from kroah.org ([198.145.64.141]:46066 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932532Ab0C3XUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:20:06 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:57 2010
Message-Id: <20100330224756.551833880@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:41:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ravikiran Thirumalai <kiran@scalex86.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [056/156] tmpfs: cleanup mpol_parse_str()
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit 926f2ae04f183098cf9a30521776fb2759c8afeb upstream.

mpol_parse_str() made lots 'err' variable related bug.  Because it is ugly
and reviewing unfriendly.

This patch simplifies it.

Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Acked-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/mempolicy.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2167,8 +2167,8 @@ int mpol_parse_str(char *str, struct mem
 			char *rest = nodelist;
 			while (isdigit(*rest))
 				rest++;
-			if (!*rest)
-				err = 0;
+			if (*rest)
+				goto out;
 		}
 		break;
 	case MPOL_INTERLEAVE:
@@ -2177,7 +2177,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (!nodelist)
 			nodes = node_states[N_HIGH_MEMORY];
-		err = 0;
 		break;
 	case MPOL_LOCAL:
 		/*
@@ -2186,7 +2185,6 @@ int mpol_parse_str(char *str, struct mem
 		if (nodelist)
 			goto out;
 		mode = MPOL_PREFERRED;
-		err = 0;
 		break;
 	case MPOL_DEFAULT:
 		/*
@@ -2201,7 +2199,6 @@ int mpol_parse_str(char *str, struct mem
 		 */
 		if (!nodelist)
 			goto out;
-		err = 0;
 	}
 
 	mode_flags = 0;
@@ -2215,13 +2212,14 @@ int mpol_parse_str(char *str, struct mem
 		else if (!strcmp(flags, "relative"))
 			mode_flags |= MPOL_F_RELATIVE_NODES;
 		else
-			err = 1;
+			goto out;
 	}
 
 	new = mpol_new(mode, mode_flags, &nodes);
 	if (IS_ERR(new))
-		err = 1;
-	else {
+		goto out;
+
+	{
 		int ret;
 		NODEMASK_SCRATCH(scratch);
 		if (scratch) {
@@ -2232,13 +2230,15 @@ int mpol_parse_str(char *str, struct mem
 			ret = -ENOMEM;
 		NODEMASK_SCRATCH_FREE(scratch);
 		if (ret) {
-			err = 1;
 			mpol_put(new);
-		} else if (no_context) {
-			/* save for contextualization */
-			new->w.user_nodemask = nodes;
+			goto out;
 		}
 	}
+	err = 0;
+	if (no_context) {
+		/* save for contextualization */
+		new->w.user_nodemask = nodes;
+	}
 
 out:
 	/* Restore string for error message */


