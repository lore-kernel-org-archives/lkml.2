Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0EXOcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 10:32:46 -0400
Received: from mtoichi11.ns.itscom.net ([219.110.2.181]:53690 "EHLO
	mtoichi11.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab0EXOcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 10:32:45 -0400
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: amwang@redhat.com, opurdila@ixiacom.com, davem@davemloft.net
cc: linux-kernel@vger.kernel.org
Subject: proc_dointvec() and write
Date: Mon, 24 May 2010 23:32:19 +0900
Message-ID: <306.1274711539@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The commit 00b7c3395aec3df43de5bd02a3c5a099ca51169f
"sysctl: refactor integer handling proc code"
modified the behaviour of writing to /proc.

Before the commit, write("1\n") to /proc/sys/kernel/printk succeeded. But
now it returns EINVAL. Is this intended change? If not, how about this
patch?


J. R. Okajima

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4c93486..5058e12 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2262,6 +2272,8 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		if (write) {
 			left -= proc_skip_spaces(&kbuf);
 
+			if (!left)
+				break;
 			err = proc_get_long(&kbuf, &left, &lval, &neg,
 					     proc_wspace_sep,
 					     sizeof(proc_wspace_sep), NULL);
@@ -2288,7 +2306,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 
 	if (!write && !first && left && !err)
 		err = proc_put_char(&buffer, &left, '\n');
-	if (write && !err)
+	if (write && !err && left)
 		left -= proc_skip_spaces(&kbuf);
 free:
 	if (write) {

