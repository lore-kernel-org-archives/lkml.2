Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab1JHU1J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 16:27:09 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:45565 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753888Ab1JHU1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 16:27:07 -0400
Date: Sat, 8 Oct 2011 16:27:04 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Fabrice Jouhaud <yargil@free.fr>
Cc: linux-ext4@vger.kernel.org, adilger.kernel@dilger.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [SIGNED-OFF] ext4: don't work without procfs
Message-ID: <20111008202704.GK7948@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Fabrice Jouhaud <yargil@free.fr>, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, linux-kernel@vger.kernel.org
References: <1317920054-2860-1-git-send-email-yargil@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317920054-2860-1-git-send-email-yargil@free.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 06:54:14PM +0200, Fabrice Jouhaud wrote:
> Regression from commit dd68314ccf3fb918c1fb6471817edbc60ece4b52
> The problem come from the test of the return value of proc_mkdir
> that is always false without procfs and abort the init of ext4.
> 
> Signed-off-by: Fabrice Jouhaud <yargil@free.fr>

Thanks, here's the patch that I ultimately checked in.

commit d44651d0f922b7aaeddd9fc04f2f5700a65983dd
Author: Fabrice Jouhaud <yargil@free.fr>
Date:   Sat Oct 8 16:26:03 2011 -0400

    ext4: fix ext4 so it works without CONFIG_PROC_FS
    
    This fixes a bug which was introduced in dd68314ccf3fb.  The problem
    came from the test of the return value of proc_mkdir which is always
    false without procfs, and this would initialization of ext4.
    
    Signed-off-by: Fabrice Jouhaud <yargil@free.fr>
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 42f76c6..dcc4605 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3540,10 +3540,8 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-#ifdef CONFIG_PROC_FS
 	if (ext4_proc_root)
 		sbi->s_proc = proc_mkdir(sb->s_id, ext4_proc_root);
-#endif
 
 	bgl_lock_init(sbi->s_blockgroup_lock);
 
@@ -5070,13 +5068,11 @@ static int __init ext4_init_fs(void)
 		return err;
 	err = ext4_init_system_zone();
 	if (err)
-		goto out7;
+		goto out6;
 	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
 	if (!ext4_kset)
-		goto out6;
-	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
-	if (!ext4_proc_root)
 		goto out5;
+	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
 
 	err = ext4_init_feat_adverts();
 	if (err)
@@ -5112,12 +5108,12 @@ out2:
 out3:
 	ext4_exit_feat_adverts();
 out4:
-	remove_proc_entry("fs/ext4", NULL);
-out5:
+	if (ext4_proc_root)
+		remove_proc_entry("fs/ext4", NULL);
 	kset_unregister(ext4_kset);
-out6:
+out5:
 	ext4_exit_system_zone();
-out7:
+out6:
 	ext4_exit_pageio();
 	return err;
 }
