Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619Ab1J1MSO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:18:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43585 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443Ab1J1MNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:13:48 -0400
From: Miklos Szeredi <miklos@szeredi.hu>
To: hch@infradead.org
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: [PATCH 01/13] vfs: ignore error on forced remount
Date: Fri, 28 Oct 2011 14:13:20 +0200
Message-Id: <1319804012-16346-2-git-send-email-miklos@szeredi.hu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
References: <1319804012-16346-1-git-send-email-miklos@szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

On emergency remount we want to force MS_RDONLY on the super block
even if ->remount_fs() failed for some reason.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---
 fs/super.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 3f56a26..14948d6 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -727,8 +727,13 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 
 	if (sb->s_op->remount_fs) {
 		retval = sb->s_op->remount_fs(sb, &flags, data);
-		if (retval)
-			return retval;
+		if (retval) {
+			if (!force)
+				return retval;
+			/* If forced remount, go ahead despite any errors */
+			WARN(1, "forced remount of a %s fs returned %i\n",
+			     sb->s_type->name, retval);
+		}
 	}
 	sb->s_flags = (sb->s_flags & ~MS_RMT_MASK) | (flags & MS_RMT_MASK);
 
-- 
1.7.3.4

