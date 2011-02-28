Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754845Ab1B1PZi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:25:38 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:62501 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab1B1PZg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:25:36 -0500
From: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Andreas=20Bie=C3=9Fmann?= <biessmann@corscience.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] fs-writeback: fix NULL pointer dereference in __mark_inode_dirty
Date: Mon, 28 Feb 2011 16:25:33 +0100
Message-Id: <1298906733-31427-1-git-send-email-biessmann@corscience.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:IDXiObyK2FhwQm7uLq+sSzGWapJnfG9zqSvZ7GptvJt
 YxcKR2Q3sKLG1Ux0nHEkKK2TZrlB+d7fJm+GiEwwaM6Nozrgij
 TPtLJ+fcSX332Irlen4UUaUOZYcE2Kjgh3UCi75o3e1/ZBGWtz
 wwBvB8ZHXqnA1kQaOWRdSQvCEI456dWhjSIDQcC4LM8o5ZhbPV
 qAZ3f7nRktPRewFOfjCtw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a kernel NULL pointer dereference as mentioned in this log:

---8<---
[   43.044000] mmc0: card c556 removed
[   43.059000] mmcblk0: error -123 sending status comand
[   43.064000] mmcblk0: error -123 sending read/write command, response 0x0, card status 0x0
[   43.089000] mmcblk0: error -123 requesting status
[   43.096000] end_request: I/O error, dev mmcblk0, sector 1667989
<snip repeated error>
[   43.830000] end_request: I/O error, dev mmcblk0, sector 1667988
[   44.679000] Unable to handle kernel NULL pointer dereference at virtual address 00000010
[   44.688000] ptbr = 93ec0000 pgd = 93ebf000
[   44.692000] Oops: Kernel access of bad area, sig: 11 [#1]
[   44.692000] FRAME_POINTER chip: 0x01f:0x1e82 rev 2
[   44.692000] Modules linked in:
[   44.692000] PC is at __mark_inode_dirty+0x8a/0x11c
[   44.692000] LR is at __mark_inode_dirty+0x7c/0x11c
<snip stack trace>
[   44.692000] Call trace:
[   44.692000]  [<900780a4>] file_update_time+0x96/0xaa
[   44.692000]  [<9005439a>] __generic_file_aio_write+0x212/0x330
[   44.692000]  [<900544f4>] generic_file_aio_write+0x3c/0x74
[   44.692000]  [<9006b82c>] do_sync_readv_writev+0x68/0x90
[   44.692000]  [<9006b8c0>] do_readv_writev+0x6c/0x108
[   44.692000]  [<9006b98a>] vfs_writev+0x2e/0x34
[   44.692000]  [<9006be60>] sys_writev+0x2c/0x4c
[   44.692000]  [<90023132>] syscall_return+0x0/0x12
[   44.692000]
--->8---

The reference to sb->s_bdi may be deleted from mmc_blk_remove() ->
del_gendisk() -> unlink_gendisk() -> bdi_unregister() -> bdi_prune_sb() while
another instance try to write some data to the device.

Signed-off-by: Andreas Bießmann <biessmann@corscience.de>
---
 fs/fs-writeback.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cdbf7ac..96b4b25 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1047,6 +1047,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		if (!was_dirty) {
 			bdi = inode_to_bdi(inode);
 
+			if (!bdi)
+				goto out;
+
 			if (bdi_cap_writeback_dirty(bdi)) {
 				WARN(!test_bit(BDI_registered, &bdi->state),
 				     "bdi-%s not registered\n", bdi->name);
-- 
1.7.2.3

