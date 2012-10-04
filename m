Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab2JDX5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 19:57:43 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:20728 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab2JDX5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 19:57:42 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: viro@zeniv.linux.org.uk, keescook@chromium.org
Cc: levinsasha928@gmail.com, davej@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH] fs: handle failed audit_log_start properly
Date: Thu,  4 Oct 2012 19:57:31 -0400
Message-Id: <1349395051-12145-1-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.7.12
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

audit_log_start() may return NULL, this is unchecked by the caller in
audit_log_link_denied() and could cause a NULL ptr deref.

Introduced by commit a51d9eaa ("fs: add link restriction audit reporting").

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 kernel/audit.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/audit.c b/kernel/audit.c
index 4d0ceed..40414e9 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1440,6 +1440,8 @@ void audit_log_link_denied(const char *operation, struct path *link)
 
 	ab = audit_log_start(current->audit_context, GFP_KERNEL,
 			     AUDIT_ANOM_LINK);
+	if (!ab)
+		return;
 	audit_log_format(ab, "op=%s action=denied", operation);
 	audit_log_format(ab, " pid=%d comm=", current->pid);
 	audit_log_untrustedstring(ab, current->comm);
-- 
1.7.12

