Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab1BPAWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:22:01 -0500
Received: from kroah.org ([198.145.64.141]:39405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757363Ab1BPAVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:52 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:38 2011
Message-Id: <20110216001438.309687561@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:13:10 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>, "Theodore Tso" <tytso@mit.edu>
Subject: [133/272] ext4: unregister features interface on module unload
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 8f021222c1e2756ea4c9dde93b23e1d2a0a4ec37 upstream.

Ext4 features interface was not properly unregistered which led to
problems while unloading/reloading ext4 module. This commit fixes that by
adding proper kobject unregistration code into ext4_exit_fs() as well as
fail-path of ext4_init_fs()

Reported-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4757,7 +4757,7 @@ static struct file_system_type ext4_fs_t
 	.fs_flags	= FS_REQUIRES_DEV,
 };
 
-int __init ext4_init_feat_adverts(void)
+static int __init ext4_init_feat_adverts(void)
 {
 	struct ext4_features *ef;
 	int ret = -ENOMEM;
@@ -4781,6 +4781,13 @@ out:
 	return ret;
 }
 
+static void ext4_exit_feat_adverts(void)
+{
+	kobject_put(&ext4_feat->f_kobj);
+	wait_for_completion(&ext4_feat->f_kobj_unregister);
+	kfree(ext4_feat);
+}
+
 static int __init ext4_init_fs(void)
 {
 	int err;
@@ -4827,7 +4834,7 @@ out1:
 out2:
 	ext4_exit_mballoc();
 out3:
-	kfree(ext4_feat);
+	ext4_exit_feat_adverts();
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
 out4:
@@ -4846,6 +4853,7 @@ static void __exit ext4_exit_fs(void)
 	destroy_inodecache();
 	ext4_exit_xattr();
 	ext4_exit_mballoc();
+	ext4_exit_feat_adverts();
 	remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
 	ext4_exit_system_zone();


