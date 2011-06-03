Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab1FCOus (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:50:48 -0400
Received: from twin.jikos.cz ([89.185.236.188]:49659 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1FCOuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:50:46 -0400
Date: Fri, 3 Jun 2011 16:50:14 +0200
From: David Sterba <dave@jikos.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        David Sterba <dave@jikos.cz>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>, linux-btrfs@vger.kernel.org
Subject: [PATCH] btrfs: fix uninitialized variable warning
Message-ID: <20110603145014.GU12709@twin.jikos.cz>
Reply-To: dave@jikos.cz
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
	David Sterba <dave@jikos.cz>, Tsutomu Itoh <t-itoh@jp.fujitsu.com>,
	Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
	linux-btrfs@vger.kernel.org
References: <20110603110011.77121203.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110603110011.77121203.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Sterba <dsterba@suse.cz>

With Linus' tree, today's linux-next build (powercp ppc64_defconfig)
produced this warning:

fs/btrfs/delayed-inode.c: In function 'btrfs_delayed_update_inode':
fs/btrfs/delayed-inode.c:1598:6: warning: 'ret' may be used
uninitialized in this function

Introduced by commit 16cdcec736cd ("btrfs: implement delayed inode items
operation").

This fixes a bug in btrfs_update_inode(): if the returned value from
btrfs_delayed_update_inode is a nonzero garbage, inode stat data are not
updated and several call paths may hit a BUG_ON or fail with strange
code.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: David Sterba <dsterba@suse.cz>
---

patch pushed to git://repo.or.cz/linux-2.6/btrfs-unstable.git #fixes

 fs/btrfs/delayed-inode.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index 01e2950..8cb012f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1595,7 +1595,7 @@ int btrfs_delayed_update_inode(struct btrfs_trans_handle *trans,
 			       struct btrfs_root *root, struct inode *inode)
 {
 	struct btrfs_delayed_node *delayed_node;
-	int ret;
+	int ret = 0;
 
 	delayed_node = btrfs_get_or_create_delayed_node(inode);
 	if (IS_ERR(delayed_node))
-- 
1.7.5.2.353.g5df3e

