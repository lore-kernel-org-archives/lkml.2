Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab2GDCAQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 22:00:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:47843 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2GDCAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 22:00:13 -0400
From: Guo Chao <yan@linux.vnet.ibm.com>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Trig a BUG when kern_path see LOOKUP_ROOT in flag
Date: Wed,  4 Jul 2012 10:00:05 +0800
Message-Id: <1341367205-29571-1-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
x-cbid: 12070315-5490-0000-0000-000001B7A028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kern_path does not prepare for LOOKUP_ROOT, if this flag is passed down,
path_init will reference uninitialized nameidata. When things go wrong, it will 
not be as obvious as dereferencing a null pointer. Kindly trig a bug here.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 fs/namei.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/namei.c b/fs/namei.c
index 1b64746..2b8c226 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1888,6 +1888,9 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
 	struct nameidata nd;
+
+	BUG_ON(flags & LOOKUP_ROOT);
+
 	int res = do_path_lookup(AT_FDCWD, name, flags, &nd);
 	if (!res)
 		*path = nd.path;
-- 
1.7.9.5

