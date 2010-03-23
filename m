Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760Ab0CWIyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 04:54:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50292 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325Ab0CWIyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 04:54:41 -0400
From: Neil Brown <neilb@suse.de>
To: Mark Fasheh <mfasheh@suse.com>, Joel Becker <joel.becker@oracle.com>
Date: Tue, 23 Mar 2010 19:54:33 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19368.33225.516492.542519@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Cc: Sachin Prabhu <sprabhu@redhat.com>
Subject: [PATCH] ocfs2: Skip check for mandatory locks when unlocking
X-Mailer: VM 8.0.13 under 22.3.1 (x86_64-pc-linux-gnu)
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The nfs bug fixed by 0800c5f7a499a8961c3868e95cc4cf1715166457
and the 9p bug fixed by f78233dd44a110c574fe760ad6f9c1e8741a0d00
and the gfs2 bug fixed by 720e7749279bde0d08684b1bb4e7a2eedeec6394

also needs to be fixed for ocfs2.  This patch does that.

Hopefully this is the last filesystem with this bug :-)

Signed-off-by: NeilBrown <neilb@suse.de>
Cc: stable@kernel.org

diff --git a/fs/ocfs2/locks.c b/fs/ocfs2/locks.c
index 544ac62..923d3d8 100644
--- a/fs/ocfs2/locks.c
+++ b/fs/ocfs2/locks.c
@@ -113,7 +113,8 @@ int ocfs2_flock(struct file *file, int cmd, struct file_lock *fl)
 
 	if (!(fl->fl_flags & FL_FLOCK))
 		return -ENOLCK;
-	if (__mandatory_lock(inode))
+	if (__mandatory_lock(inode) &&
+	    fl->fl_type != F_UNLCK)
 		return -ENOLCK;
 
 	if ((osb->s_mount_opt & OCFS2_MOUNT_LOCALFLOCKS) ||
