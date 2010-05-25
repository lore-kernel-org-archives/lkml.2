Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab0EYGvJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:51:09 -0400
Received: from mtoichi13.ns.itscom.net ([219.110.2.183]:45930 "EHLO
	mtoichi13.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199Ab0EYGvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:51:07 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: amwang@redhat.com
Cc: opurdila@ixiacom.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [PATCH] proc_dointvec, write a single value
Date: Tue, 25 May 2010 15:49:44 +0900
Message-Id: <1274770184-12611-1-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <4BFB6197.5030206@redhat.com>
References: <4BFB6197.5030206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 00b7c3395aec3df43de5bd02a3c5a099ca51169f
"sysctl: refactor integer handling proc code"
modified the behaviour of writing to /proc.
Before the commit, write("1\n") to /proc/sys/kernel/printk succeeded. But
now it returns EINVAL.

This commit supports writing a single value to a multi-valued entry.

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 kernel/sysctl.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4c93486..78ac3fb 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2262,6 +2262,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		if (write) {
 			left -= proc_skip_spaces(&kbuf);
 
+			if (!left)
+				break;
 			err = proc_get_long(&kbuf, &left, &lval, &neg,
 					     proc_wspace_sep,
 					     sizeof(proc_wspace_sep), NULL);
@@ -2288,7 +2290,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 
 	if (!write && !first && left && !err)
 		err = proc_put_char(&buffer, &left, '\n');
-	if (write && !err)
+	if (write && !err && left)
 		left -= proc_skip_spaces(&kbuf);
 free:
 	if (write) {
-- 
1.6.6.1

