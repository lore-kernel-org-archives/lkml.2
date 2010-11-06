Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab0KFRrb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 13:47:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57768 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab0KFRr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 13:47:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=X439s5zE7xwOtMxMfimZCSQMahX7fQ/110luSL6iOTdRMMmvZJfWzi0JZxIKtIQ/2D
         fXgdnIAVgOjLlMprJ8F6YHDY8JjsGHbvEN+PnoFC69VFiYxWoPSmRigznosmHhdcL95R
         KCYiIA7qyCDYxo2/YU0I0R6FuWcL0nt6X9K90=
From: Alessio Igor Bogani <abogani@texware.it>
To: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 1/4] udf: Add missed protection for s_lvid_dirty
Date: Sat,  6 Nov 2010 18:47:08 +0100
Message-Id: <1289065631-2256-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported in udf_sb.h the udf_sb_infoi's structure member s_lvid_dirty should
be protected by s_alloc_mutex. Added that mutex on a couple of places where it
miss.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/super.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 4a5c7c6..c05834e 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1789,7 +1789,9 @@ static void udf_open_lvid(struct super_block *sb)
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
 	mark_buffer_dirty(bh);
+	mutex_lock(&sbi->s_alloc_mutex);
 	sbi->s_lvid_dirty = 0;
+	mutex_unlock(&sbi->s_alloc_mutex);
 }
 
 static void udf_close_lvid(struct super_block *sb)
@@ -1821,7 +1823,9 @@ static void udf_close_lvid(struct super_block *sb)
 
 	lvid->descTag.tagChecksum = udf_tag_checksum(&lvid->descTag);
 	mark_buffer_dirty(bh);
+	mutex_lock(&sbi->s_alloc_mutex);
 	sbi->s_lvid_dirty = 0;
+	mutex_unlock(&sbi->s_alloc_mutex);
 }
 
 static void udf_sb_free_bitmap(struct udf_bitmap *bitmap)
-- 
1.7.0.4

