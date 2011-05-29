Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1E2MqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 08:46:13 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57385 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1E2MqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 08:46:12 -0400
Date: Sun, 29 May 2011 13:46:08 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, sfrench@samba.org, dedekind1@gmail.com,
        yinghan@google.com
Subject: [PATCH] shrinker API change fallout
Message-ID: <20110529124608.GI11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 1495f230fa7750479c79e3656286b9183d662077 changed the API of ->shrink(),
but missed ubifs and cifs instances.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index f3c6fb9..aaa01b8 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -74,8 +74,9 @@ shrink_idmap_tree(struct rb_root *root, int nr_to_scan, int *nr_rem,
  * Run idmap cache shrinker.
  */
 static int
-cifs_idmap_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask)
+cifs_idmap_shrinker(struct shrinker *shrink, struct shrink_control *sc)
 {
+	int nr_to_scan = sc->nr_to_scan;
 	int nr_del = 0;
 	int nr_rem = 0;
 	struct rb_root *root;
diff --git a/fs/ubifs/shrinker.c b/fs/ubifs/shrinker.c
index 46961c0..ca953a9 100644
--- a/fs/ubifs/shrinker.c
+++ b/fs/ubifs/shrinker.c
@@ -277,8 +277,9 @@ static int kick_a_thread(void)
 	return 0;
 }
 
-int ubifs_shrinker(struct shrinker *shrink, int nr, gfp_t gfp_mask)
+int ubifs_shrinker(struct shrinker *shrink, struct shrink_control *sc)
 {
+	int nr = sc->nr_to_scan;
 	int freed, contention = 0;
 	long clean_zn_cnt = atomic_long_read(&ubifs_clean_zn_cnt);
 
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index 93d1412..a70d7b4 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1614,7 +1614,7 @@ int ubifs_tnc_start_commit(struct ubifs_info *c, struct ubifs_zbranch *zroot);
 int ubifs_tnc_end_commit(struct ubifs_info *c);
 
 /* shrinker.c */
-int ubifs_shrinker(struct shrinker *shrink, int nr_to_scan, gfp_t gfp_mask);
+int ubifs_shrinker(struct shrinker *shrink, struct shrink_control *sc);
 
 /* commit.c */
 int ubifs_bg_thread(void *info);
