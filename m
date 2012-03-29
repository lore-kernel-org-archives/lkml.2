Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573Ab2C2Qoi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 12:44:38 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:34821 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758958Ab2C2Qob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 12:44:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] ftrace: Remove a superfluous check
Date: Thu, 29 Mar 2012 18:44:23 +0200
Message-Id: <1333039463-24268-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

register_ftrace_function() checks ftrace_disabled and calls
__register_ftrace_function which does it again.

Drop the first check and add the unlikely hint to the second one.

No functional change.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 kernel/trace/ftrace.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 867bd1dd2dd0..f9212017406d 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -311,7 +311,7 @@ static int remove_ftrace_list_ops(struct ftrace_ops **list,
 
 static int __register_ftrace_function(struct ftrace_ops *ops)
 {
-	if (ftrace_disabled)
+	if (unlikely(ftrace_disabled))
 		return -ENODEV;
 
 	if (FTRACE_WARN_ON(ops == &global_ops))
@@ -4304,14 +4304,10 @@ int register_ftrace_function(struct ftrace_ops *ops)
 
 	mutex_lock(&ftrace_lock);
 
-	if (unlikely(ftrace_disabled))
-		goto out_unlock;
-
 	ret = __register_ftrace_function(ops);
 	if (!ret)
 		ret = ftrace_startup(ops, 0);
 
-
  out_unlock:
 	mutex_unlock(&ftrace_lock);
 	return ret;
-- 
1.7.9.3.362.g71319

