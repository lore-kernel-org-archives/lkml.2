Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752740Ab2GIJcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 05:32:33 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61578 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab2GIJcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 05:32:32 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: tytso@mit.edu, Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH] ext4: fix double quota opts show
Date: Mon,  9 Jul 2012 13:32:21 +0400
Message-Id: <1341826341-32083-1-git-send-email-dmonakhov@openvz.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently quota options showed twice, first time in _ext4_show_options()
(inside main loop), and second time inside ext4_show_quota_options().
In my case it looks like follows:
/dev/sdc /mnt ext4 rw,relatime,quota,usrquota,grpquota,data=ordered,usrquota,grpquota 0 0
Let's do not show quota's opts inside main loop, and let ext4_show_quota_options()
does it primary job.

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/ext4/super.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index eb7aa3e..84c7ba4 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1404,13 +1404,13 @@ static int clear_qf_name(struct super_block *sb, int qtype)
 #define MOPT_CLEAR_ERR	0x0010
 #define MOPT_GTE0	0x0020
 #ifdef CONFIG_QUOTA
-#define MOPT_Q		0
-#define MOPT_QFMT	0x0040
+#define MOPT_Q		0x0040
+#define MOPT_QFMT	0x0080
 #else
 #define MOPT_Q		MOPT_NOSUPPORT
 #define MOPT_QFMT	MOPT_NOSUPPORT
 #endif
-#define MOPT_DATAJ	0x0080
+#define MOPT_DATAJ	0x0100
 
 static const struct mount_opts {
 	int	token;
@@ -1786,6 +1786,8 @@ static int _ext4_show_options(struct seq_file *seq, struct super_block *sb,
 		     (sbi->s_mount_opt & m->mount_opt) != m->mount_opt) ||
 		    (!want_set && (sbi->s_mount_opt & m->mount_opt)))
 			continue; /* select Opt_noFoo vs Opt_Foo */
+		if (m->flags & (MOPT_Q | MOPT_QFMT))
+			continue; /* will be handled in show_quota_options */
 		SEQ_OPTS_PRINT("%s", token2str(m->token));
 	}
 
-- 
1.7.1

