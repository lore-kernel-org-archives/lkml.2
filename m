Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab2E1Dnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:43:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52096 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753919Ab2E1D3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:33 -0400
Message-Id: <20120528031214.326681665@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:25 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kazuya Mio <k-mio@sx.jp.nec.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 083/117] wake up s_wait_unfrozen when ->freeze_fs fails
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kazuya Mio <k-mio@sx.jp.nec.com>

commit e1616300a20c80396109c1cf013ba9a36055a3da upstream.

dd slept infinitely when fsfeeze failed because of EIO.
To fix this problem, if ->freeze_fs fails, freeze_super() wakes up
the tasks waiting for the filesystem to become unfrozen.

When s_frozen isn't SB_UNFROZEN in __generic_file_aio_write(),
the function sleeps until FITHAW ioctl wakes up s_wait_unfrozen.

However, if ->freeze_fs fails, s_frozen is set to SB_UNFROZEN and then
freeze_super() returns an error number. In this case, FITHAW ioctl returns
EINVAL because s_frozen is already SB_UNFROZEN. There is no way to wake up
s_wait_unfrozen, so __generic_file_aio_write() sleeps infinitely.

Signed-off-by: Kazuya Mio <k-mio@sx.jp.nec.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/super.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index de41e1e..6015c02 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1186,6 +1186,8 @@ int freeze_super(struct super_block *sb)
 			printk(KERN_ERR
 				"VFS:Filesystem freeze failed\n");
 			sb->s_frozen = SB_UNFROZEN;
+			smp_wmb();
+			wake_up(&sb->s_wait_unfrozen);
 			deactivate_locked_super(sb);
 			return ret;
 		}


