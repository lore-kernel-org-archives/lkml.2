Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965540Ab2EOC1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:27:04 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53555 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965525Ab2EOCST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:18:19 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 171/179] fuse: check size of FUSE_NOTIFY_INVAL_ENTRY message
Date: Mon, 14 May 2012 22:14:27 -0400
Message-ID: <1337048075-6132-172-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit c2183d1e9b3f313dd8ba2b1b0197c8d9fb86a7ae upstream.

FUSE_NOTIFY_INVAL_ENTRY didn't check the length of the write so the
message processing could overrun and result in a "kernel BUG at
fs/fuse/dev.c:629!"

Reported-by: Han-Wen Nienhuys <hanwenn@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/fuse/dev.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index c235afc..9897fe3 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -901,6 +901,10 @@ static int fuse_notify_inval_entry(struct fuse_conn *fc, unsigned int size,
 	if (outarg.namelen > FUSE_NAME_MAX)
 		goto err;
 
+	err = -EINVAL;
+	if (size != sizeof(outarg) + outarg.namelen + 1)
+		goto err;
+
 	name.name = buf;
 	name.len = outarg.namelen;
 	err = fuse_copy_one(cs, buf, outarg.namelen + 1);
-- 
1.7.9.6

