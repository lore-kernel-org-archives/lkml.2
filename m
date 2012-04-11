Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab2DKGB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 02:01:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48331 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316Ab2DKGBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 02:01:25 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Vasiliy Kulikov <segoon@openwall.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH 4/6] proc: use mm_access() instead of ptrace_may_access()
Date: Wed, 11 Apr 2012 13:59:25 +0800
Message-Id: <1334123976-11681-4-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1334123976-11681-1-git-send-email-xiyou.wangcong@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mm_access() handles this much better, and avoids some race conditions.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
---
 fs/proc/base.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 8608a4d..f1d18fc 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2035,11 +2035,8 @@ static int map_files_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 	if (!task)
 		goto out_notask;
 
-	if (!ptrace_may_access(task, PTRACE_MODE_READ))
-		goto out;
-
-	mm = get_task_mm(task);
-	if (!mm)
+	mm = mm_access(task, PTRACE_MODE_READ);
+	if (IS_ERR_OR_NULL(mm))
 		goto out;
 
 	if (!dname_to_vma_addr(dentry, &vm_start, &vm_end)) {
-- 
1.7.7.6

