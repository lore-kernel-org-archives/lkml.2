Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab0DEUQo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 16:16:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17109 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756458Ab0DEUQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 16:16:38 -0400
From: Eric Paris <eparis@redhat.com>
To: torvalds@linux-foundation.org
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-audit@redhat.com
Subject: [PATCH] audit: preface audit printk with audit
Date: Mon,  5 Apr 2010 16:16:26 -0400
Message-Id: <1270498586-24226-1-git-send-email-eparis@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There have been a number of reports of people seeing the message:
"name_count maxed, losing inode data: dev=00:05, inode=3185"
in dmesg.  These usually lead to people reporting problems to the filesystem
group who are in turn clueless what they mean.  Eventually someone finds me
and I explain what is going on and that these come from the audit system.
The basics of the problem is that the audit subsystem never expects a single
syscall to 'interact' (for some wish washy meaning of interact)  with more
than 20 inodes.  But in fact some operations like loading kernel modules can
cause changes to lots of inodes in debugfs.  There are a couple real fixes
being bandied about including removing the fixed compile time limit of 20 or
not auditing changes in debugfs (or both) but neither are small and obvious
so I am not sending them for immediate inclusion (I hope Al forwards a real
solution next devel window).  In the meantime this patch simply adds 'audit'
to the beginning of the crap message so if a user sees it, they come
blame me first and we can talk about what it means and make sure we understand
all of the reasons it can happen and make sure this gets solved correctly
in the long run.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index f3a461c..d6de684 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1893,7 +1893,7 @@ static int audit_inc_name_count(struct audit_context *context,
 {
 	if (context->name_count >= AUDIT_NAMES) {
 		if (inode)
-			printk(KERN_DEBUG "name_count maxed, losing inode data: "
+			printk(KERN_DEBUG "audit: name_count maxed, losing inode data: "
 			       "dev=%02x:%02x, inode=%lu\n",
 			       MAJOR(inode->i_sb->s_dev),
 			       MINOR(inode->i_sb->s_dev),
-- 
1.6.5.3

