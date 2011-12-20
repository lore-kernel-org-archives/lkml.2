Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1LTXlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:41:13 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40857 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1LTXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:41:11 -0500
From: Xi Wang <xi.wang@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, Xi Wang <xi.wang@gmail.com>
Subject: [PATCH RESEND] audit: fix signedness bug in audit_log_execve_info()
Date: Tue, 20 Dec 2011 18:39:41 -0500
Message-Id: <1324424381-7577-1-git-send-email-xi.wang@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the loop, a size_t "len" is used to hold the return value of
audit_log_single_execve_arg(), which returns -1 on error.  In that
case the error handling (len <= 0) will be bypassed since "len" is
unsigned, and the loop continues with (p += len) being wrapped.
Change the type of "len" to signed int to fix the error handling.

	size_t len;
	...
	for (...) {
		len = audit_log_single_execve_arg(...);
		if (len <= 0)
			break;
		p += len;
	}

Signed-off-by: Xi Wang <xi.wang@gmail.com>
---
 kernel/auditsc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 47b7fc1..5b118d8 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1166,8 +1166,8 @@ static void audit_log_execve_info(struct audit_context *context,
 				  struct audit_buffer **ab,
 				  struct audit_aux_data_execve *axi)
 {
-	int i;
-	size_t len, len_sent = 0;
+	int i, len;
+	size_t len_sent = 0;
 	const char __user *p;
 	char *buf;
 
-- 
1.7.5.4

