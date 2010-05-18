Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756264Ab0ERGpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:45:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39143 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753035Ab0ERGpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:45:22 -0400
Date: Tue, 18 May 2010 16:45:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20100518164520.7e9652b1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/sysfs/mount.c: In function 'sysfs_exit_ns':
fs/sysfs/mount.c:160: error: 'S_BIAS' undeclared (first use in this function)

Caused by commit c80e63f000aa7cf73a430b2cb57dbbb91554a847 ("sysfs:
Implement sysfs tagged directory support") from the driver-core tree
interacting with commit f3ffc7acb6a6ebec0a9e660d9211ed048d7e90f5 ("get
rid of S_BIAS") from the vfs tree.

I don't know how to fix this, so I just commented the code out for now
(see below). Please someone supply a correct fix.

[Al, I notice that the "get rid of S_BIAS" patch has an author date of
March 22 - it would have been nice if it had been in linux-next during
the last two months so that we could have had a fix for this some time
ago.]
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 18 May 2010 16:36:22 +1000
Subject: [PATCH] sysfs: fix for S_BIAS going away

Not a real fix, but it lets the code build.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 fs/sysfs/mount.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
index 1afa32b..49258e1 100644
--- a/fs/sysfs/mount.c
+++ b/fs/sysfs/mount.c
@@ -150,22 +150,22 @@ static struct file_system_type sysfs_fs_type = {
 
 void sysfs_exit_ns(enum kobj_ns_type type, const void *ns)
 {
 	struct super_block *sb;
 
 	mutex_lock(&sysfs_mutex);
 	spin_lock(&sb_lock);
 	list_for_each_entry(sb, &sysfs_fs_type.fs_supers, s_instances) {
 		struct sysfs_super_info *info = sysfs_info(sb);
 		/* Ignore superblocks that are in the process of unmounting */
-		if (sb->s_count <= S_BIAS)
-			continue;
+//		if (sb->s_count <= S_BIAS)
+//			continue;
 		/* Ignore superblocks with the wrong ns */
 		if (info->ns[type] != ns)
 			continue;
 		info->ns[type] = NULL;
 	}
 	spin_unlock(&sb_lock);
 	mutex_unlock(&sysfs_mutex);
 }
 
 int __init sysfs_init(void)
-- 
1.7.1

