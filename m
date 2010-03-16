Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab0CPUTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 16:19:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754642Ab0CPUTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 16:19:40 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH] audit: make filetype matching consistent with other filters
To: linux-kernel@vger.kernel.org, linux-audit@redhat.com
Cc: viro@zeniv.linux.org.uk
Date: Tue, 16 Mar 2010 16:19:34 -0400
Message-ID: <20100316201934.11799.51242.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every other filter that matches part of the inodes list collected by audit
will match against any of the inodes on that list.  The filetype matching
however had a strange way of doing things.  It allowed userspace to
indicated if it should match on the first of the second name collected by
the kernel.  Name collection ordering seems like a kernel internal and
making userspace rules get that right just seems like a bad idea.  As it
turns out the userspace audit writers had no idea it was doing this and
thus never overloaded the value field.  The kernel always checked the first
name collected which for the tested rules was always correct.  Another
problem with this overloading interface is that the most interesting
event type where it might be needed, rename(), won't work.  The first
two names collected are both the parent directory, not either of the
inodes actually being renamed.

This patch just makes the filetype matching like the major, minor, inode,
and LSM rules in that it will match against any of the names collected.  It
also changes the rule validation to reject the old unused rule types.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 kernel/auditfilter.c |    4 ++--
 kernel/auditsc.c     |   19 +++++++++----------
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
index f5e4cae..5ed85aa 100644
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -384,7 +384,7 @@ static struct audit_entry *audit_rule_to_entry(struct audit_rule *rule)
 				goto exit_free;
 			break;
 		case AUDIT_FILETYPE:
-			if ((f->val & ~S_IFMT) > S_IFMT)
+			if (f->val & ~S_IFMT)
 				goto exit_free;
 			break;
 		case AUDIT_INODE:
@@ -535,7 +535,7 @@ static struct audit_entry *audit_data_to_entry(struct audit_rule_data *data,
 				goto exit_free;
 			break;
 		case AUDIT_FILETYPE:
-			if ((f->val & ~S_IFMT) > S_IFMT)
+			if (f->val & ~S_IFMT)
 				goto exit_free;
 			break;
 		default:
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f286982..92212c4 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -300,21 +300,20 @@ static int audit_match_perm(struct audit_context *ctx, int mask)
 	}
 }
 
-static int audit_match_filetype(struct audit_context *ctx, int which)
+static int audit_match_filetype(struct audit_context *ctx, int val)
 {
-	unsigned index = which & ~S_IFMT;
-	mode_t mode = which & S_IFMT;
+	int index;
+	mode_t mode = (mode_t)val;
 
 	if (unlikely(!ctx))
 		return 0;
 
-	if (index >= ctx->name_count)
-		return 0;
-	if (ctx->names[index].ino == -1)
-		return 0;
-	if ((ctx->names[index].mode ^ mode) & S_IFMT)
-		return 0;
-	return 1;
+	for (index = 0; index < ctx->name_count; index++) {
+		if ((ctx->names[index].ino != -1) &&
+		    ((ctx->names[index].mode & S_IFMT) == mode))
+			return 1;
+	}
+	return 0;
 }
 
 /*

