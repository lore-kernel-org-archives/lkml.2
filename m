Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab2LABzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 20:55:24 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36191 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab2LABzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 20:55:23 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 1/6] f2fs: fix the compiler warning for uninitialized use of variable
Date: Sat,  1 Dec 2012 10:55:12 +0900
Message-Id: <1354326912-6656-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

When CONFIG_CC_OPTIMIZE_FOR_SIZE is enabled in the kernel, -Os optimisation
flag is passed to gcc for compilation, and somehow while trying to optimize
the code, compiler is might not able to see the initialisation of variable
ne struct variable inside the get_node_info() function and results into
following warning:

fs/f2fs/node.c: In function 'get_node_info':
fs/f2fs/node.c:175:3: warning: 'ne.block_addr' may be used uninitialized in
this function [-Wuninitialized]
fs/f2fs/node.c:265:24: note: 'ne.block_addr' was declared here
fs/f2fs/node.c:176:3: warning: 'ne.ino' may be used uninitialized in this
function [-Wuninitialized]
fs/f2fs/node.c:265:24: note: 'ne.ino' was declared here
fs/f2fs/node.c:177:3: warning: 'ne.version' may be used uninitialized in
this function [-Wuninitialized]
fs/f2fs/node.c:265:24: note: 'ne.version' was declared here

Hence, lets initialise the ne struct variable to zero, which will remove
this warning and also doing this does not seems to making any impact on the
code behavior.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/node.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 25d3036..1987036 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -266,6 +266,7 @@ void get_node_info(struct f2fs_sb_info *sbi, nid_t nid, struct node_info *ni)
 	struct nat_entry *e;
 	int i;
 
+	memset(&ne, 0, sizeof(struct f2fs_nat_entry));
 	ni->nid = nid;
 
 	/* Check nat cache */
-- 
1.7.9.5

