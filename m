Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab2LMOIj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:08:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932615Ab2LMOIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:08:34 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jianpeng Ma <majianpeng@gmail.com>, NeilBrown <neilb@suse.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 122/241] md: Avoid write invalid address if read_seqretry returned true.
Date: Thu, 13 Dec 2012 11:58:07 -0200
Message-Id: <1355407206-17100-123-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
References: <1355407206-17100-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: majianpeng <majianpeng@gmail.com>

commit 35f9ac2dcec8f79d7059ce174fd7b7ee3290d620 upstream.

If read_seqretry returned true and bbp was changed, it will write
invalid address which can cause some serious problem.

This bug was introduced by commit v3.0-rc7-130-g2699b67.
So fix is suitable for 3.0.y thru 3.6.y.

Reported-by: zhuwenfeng@kedacom.com
Tested-by: zhuwenfeng@kedacom.com
Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/md/md.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e977874..97edf9e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1881,10 +1881,10 @@ retry:
 			memset(bbp, 0xff, PAGE_SIZE);
 
 			for (i = 0 ; i < bb->count ; i++) {
-				u64 internal_bb = *p++;
+				u64 internal_bb = p[i];
 				u64 store_bb = ((BB_OFFSET(internal_bb) << 10)
 						| BB_LEN(internal_bb));
-				*bbp++ = cpu_to_le64(store_bb);
+				bbp[i] = cpu_to_le64(store_bb);
 			}
 			bb->changed = 0;
 			if (read_seqretry(&bb->lock, seq))
-- 
1.7.9.5

