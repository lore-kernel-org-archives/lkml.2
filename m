Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587Ab0I2Nu6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:50:58 -0400
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:64060 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab0I2Nu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:50:57 -0400
X-Authority-Analysis: v=1.1 cv=/wPbbLlNx4yf8SUm0NWu5W7XZrQwS6yDV9JD17FB+as= c=1 sm=0 a=a2eR-iwVXoQA:10 a=ld/erqUjW76FpBUqCqkKeA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=RW-AWHYDIFcDzE9YRTgA:9 a=7Q8Y-J1wJtzBmwdj_PxKDRX6V7QA:4 a=LI9Vle30uBYA:10 a=jEp0ucaQiEUA:10 a=ld/erqUjW76FpBUqCqkKeA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 71.70.153.3
From: Jeff Layton <jlayton@redhat.com>
To: smfrench@gmail.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-cifs@vger.kernel.org, stable@kernel.org
Subject: [PATCH] cifs: set backing_dev_info on new S_ISREG inodes
Date: Wed, 29 Sep 2010 09:49:54 -0400
Message-Id: <1285768194-29595-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Testing on very recent kernel (2.6.36-rc6) made this warning pop:

    WARNING: at fs/fs-writeback.c:87 inode_to_bdi+0x65/0x70()
    Hardware name:
    Dirtiable inode bdi default != sb bdi cifs

...the following patch fixes it and seems to be the obviously correct
thing to do for cifs.

Cc: stable@kernel.org
Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/cifs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 2256124..d6db805 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -853,6 +853,8 @@ retry_iget5_locked:
 			inode->i_flags |= S_NOATIME | S_NOCMTIME;
 		if (inode->i_state & I_NEW) {
 			inode->i_ino = hash;
+			if (S_ISREG(inode->i_mode))
+				inode->i_data.backing_dev_info = sb->s_bdi;
 #ifdef CONFIG_CIFS_FSCACHE
 			/* initialize per-inode cache cookie pointer */
 			CIFS_I(inode)->fscache = NULL;
-- 
1.7.2.3

