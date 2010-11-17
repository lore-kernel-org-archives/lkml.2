Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935205Ab0KQSAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:00:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933795Ab0KQSAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:00:35 -0500
From: Josef Bacik <josef@redhat.com>
To: linux-fsdevel@vger.kernel.org, eparis@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: call security_d_instantiate in d_obtain_alias
Date: Wed, 17 Nov 2010 12:51:03 -0500
Message-Id: <1290016263-1637-1-git-send-email-josef@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While trying to track down some NFS problems with BTRFS, I kept noticing I was
getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
figure out that it was SELinux that was giving me grief, with the following
denial

type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:unlabeled_t:s0 tclass=file

Turns out this is because in d_obtain_alias if we can't find an alias we create
one and do all the normal instantiation stuff, but we don't do the
security_d_instantiate.  With this patch I'm no longer seeing these errant
-EACCESS return values.  Thanks,

Signed-off-by: Josef Bacik <josef@redhat.com>
---
 fs/dcache.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 23702a9..890a59e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1201,6 +1201,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
 	spin_unlock(&tmp->d_lock);
 
 	spin_unlock(&dcache_lock);
+	security_d_instantiate(tmp, inode);
 	return tmp;
 
  out_iput:
-- 
1.6.6.1

