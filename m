Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab2IIOQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 10:16:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64500 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab2IIOQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 10:16:41 -0400
From: Sasha Levin <levinsasha928@gmail.com>
To: ccaulfie@redhat.com, teigland@redhat.com
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org, davej@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [PATCH] dlm: check the maximum size of a request from user
Date: Sun,  9 Sep 2012 16:16:58 +0200
Message-Id: <1347200218-3697-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_write only checks whether the request size is big enough, but it doesn't
check if the size is too big.

At that point, it also tries to allocate as much memory as the user has requested
even if it's too much. This can lead to OOM killer kicking in, or memory corruption
if (count + 1) overflows.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
---
 fs/dlm/user.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index eb4ed9b..7ff4985 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -503,6 +503,13 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 #endif
 		return -EINVAL;
 
+#ifdef CONFIG_COMPAT
+	if (count > sizeof(struct dlm_write_request32) + DLM_RESNAME_MAXLEN)
+#else
+	if (count > sizeof(struct dlm_write_request) + DLM_RESNAME_MAXLEN)
+#endif
+		return -EINVAL;
+
 	kbuf = kzalloc(count + 1, GFP_NOFS);
 	if (!kbuf)
 		return -ENOMEM;
-- 
1.7.12

