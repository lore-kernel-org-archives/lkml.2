Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759513Ab0ENT3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:29:43 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:54856 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759380Ab0ENT3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:29:35 -0400
Date: Fri, 14 May 2010 21:29:28 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 4/10] fs/reiserfs: Use kstrdup
Message-ID: <Pine.LNX.4.64.1005142129040.28935@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kstrdup when the goal of an allocation is copy a string into the
allocated region.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression from,to;
expression flag,E1,E2;
statement S;
@@

-  to = kmalloc(strlen(from) + 1,flag);
+  to = kstrdup(from, flag);
   ... when != \(from = E1 \| to = E1 \)
   if (to==NULL || ...) S
   ... when != \(from = E2 \| to = E2 \)
-  strcpy(to, from);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 fs/reiserfs/super.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -u -p a/fs/reiserfs/super.c b/fs/reiserfs/super.c
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1009,8 +1009,7 @@ static int reiserfs_parse_options(struct
 							 "on filesystem root.");
 					return 0;
 				}
-				qf_names[qtype] =
-				    kmalloc(strlen(arg) + 1, GFP_KERNEL);
+				qf_names[qtype] = kstrdup(arg, GFP_KERNEL);
 				if (!qf_names[qtype]) {
 					reiserfs_warning(s, "reiserfs-2502",
 							 "not enough memory "
@@ -1018,7 +1017,6 @@ static int reiserfs_parse_options(struct
 							 "quotafile name.");
 					return 0;
 				}
-				strcpy(qf_names[qtype], arg);
 				*mount_options |= 1 << REISERFS_QUOTA;
 			} else {
 				if (qf_names[qtype] !=
