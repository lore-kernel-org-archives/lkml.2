Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752956Ab1F3Rnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 13:43:52 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50130 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab1F3Rnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:43:50 -0400
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Evgeniy Dushistov <dushistov@mail.ru>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [PATCH resend] ufs: Fix backtrace seen when mounting a bad ufs file system
Date: Thu, 30 Jun 2011 10:43:36 -0700
Message-ID: <1309455816-8945-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: git-send-email 1.7.3.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an attempt is made to mount a bad ufs file system, the following backtrace
may be seen.

Call Trace:
[<ffffffff81443d50>] mutex_lock+0x18/0x70
[<ffffffff8127d6cc>] ufs_sync_fs+0x2c/0x278
[<ffffffff8120d814>] __sync_filesystem+0x74/0xb8
[<ffffffff8120d934>] sync_filesystem+0x4c/0x80
[<ffffffff811e23dc>] generic_shutdown_super+0x34/0x110
[<ffffffff811e24dc>] kill_block_super+0x24/0x80
[<ffffffff811e2644>] deactivate_locked_super+0x6c/0x98
[<ffffffff811e32e0>] mount_bdev+0x218/0x220
[<ffffffff811e295c>] mount_fs+0xe4/0x220
[<ffffffff81201064>] vfs_kern_mount+0x64/0x110
[<ffffffff812014fc>] do_kern_mount+0x4c/0x138
[<ffffffff81202d58>] do_mount+0x440/0x898
[<ffffffff8122c870>] compat_sys_mount+0xd8/0x248

The backtrace occurs if ufs_read_cylinder_structures() reports an error.
The calling function ufs_fill_super() tries to clean up, but does not return
the error to the calling code. This ultimately causes the backtrace.

Fix problem by returning an error from ufs_fill_super() if
ufs_read_cylinder_structures() fails.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
---
Resend, this time copying the linux-fsdevel list.
If I should send it to some other list, please let me know.

 fs/ufs/super.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 3915ade..c398221 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -1174,8 +1174,12 @@ magic_found:
 	 * Read cylinder group structures
 	 */
 	if (!(sb->s_flags & MS_RDONLY))
-		if (!ufs_read_cylinder_structures(sb))
+		if (!ufs_read_cylinder_structures(sb)) {
+			dput(sb->s_root);
+			sb->s_root = NULL;
+			ret = -ENODEV;
 			goto failed;
+		}
 
 	UFSD("EXIT\n");
 	return 0;
-- 
1.7.3.1

