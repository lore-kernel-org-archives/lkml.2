Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab2LRBTs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 20:19:48 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35294 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2LRBTq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 20:19:46 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Garrett <mjg@redhat.com>, Jeremy Kerr <jeremy.kerr@canonical.com>,
        Matt Fleming <matt.fleming@intel.com>, <linux-kernel@vger.kernel.org>
Date: Mon, 17 Dec 2012 17:19:36 -0800
Message-ID: <87sj74f97b.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX19vh4888S37SXGF955lJVb+oHIgaZ/0PTM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH] efi: Fix the build with user namespaces enabled.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When compiling efivars.c the build fails with:

 CC      drivers/firmware/efivars.o
drivers/firmware/efivars.c: In function ‘efivarfs_get_inode’:
drivers/firmware/efivars.c:886:31: error: incompatible types when assigning to type ‘kgid_t’ from type ‘int’
make[2]: *** [drivers/firmware/efivars.o] Error 1
make[1]: *** [drivers/firmware/efivars.o] Error 2

Fix the build error by removing the duplicate initialization of i_uid and
i_gid inode_init_always has already initialized them to 0.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 drivers/firmware/efivars.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 52c5d89..7b1c374 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -883,7 +883,6 @@ static struct inode *efivarfs_get_inode(struct super_block *sb,
 
 	if (inode) {
 		inode->i_ino = get_next_ino();
-		inode->i_uid = inode->i_gid = 0;
 		inode->i_mode = mode;
 		inode->i_atime = inode->i_mtime = inode->i_ctime = CURRENT_TIME;
 		switch (mode & S_IFMT) {
-- 
1.7.5.4

