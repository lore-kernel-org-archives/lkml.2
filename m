Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161371Ab1FAIJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:09:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42656 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161348Ab1FAIJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:09:13 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:02:59 2011
Message-Id: <20110601080259.292931213@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 16:59:29 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [033/146] ext4: fix possible use-after-free in
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------
 ext4_remove_li_request()

From: Lukas Czerner <lczerner@redhat.com>

commit 1bb933fb1fa8e4cb337a0d5dfd2ff4c0dc2073e8 upstream.

We need to take reference to the s_li_request after we take a mutex,
because it might be freed since then, hence result in accessing old
already freed memory. Also we should protect the whole
ext4_remove_li_request() because ext4_li_info might be in the process of
being freed in ext4_lazyinit_thread().

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2716,14 +2716,16 @@ static void ext4_remove_li_request(struc
 
 static void ext4_unregister_li_request(struct super_block *sb)
 {
-	struct ext4_li_request *elr = EXT4_SB(sb)->s_li_request;
-
-	if (!ext4_li_info)
+	mutex_lock(&ext4_li_mtx);
+	if (!ext4_li_info) {
+		mutex_unlock(&ext4_li_mtx);
 		return;
+	}
 
 	mutex_lock(&ext4_li_info->li_list_mtx);
-	ext4_remove_li_request(elr);
+	ext4_remove_li_request(EXT4_SB(sb)->s_li_request);
 	mutex_unlock(&ext4_li_info->li_list_mtx);
+	mutex_unlock(&ext4_li_mtx);
 }
 
 static struct task_struct *ext4_lazyinit_task;


