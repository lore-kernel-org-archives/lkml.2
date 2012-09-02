Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2IBN3O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 09:29:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47850 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2IBN3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 09:29:13 -0400
MIME-Version: 1.0
Date: Sun, 2 Sep 2012 21:29:12 +0800
Message-ID: <CAPgLHd_oQLthvUff49aVnjbyXYNybECJn=1m8vFcDo3PLTSuTg@mail.gmail.com>
Subject: [PATCH] kdb: fix possible memory leak in kdb_defcmd2()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: jason.wessel@windriver.com
Cc: yongjun_wei@trendmicro.com.cn, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In the error handling case of kdb_defcmd2() s->command has
been set to NULL but the save_command remain no free, this will
cause memory leak.

spatch with a semantic match is used to found this problem.
(http://coccinelle.lip6.fr/)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 kernel/debug/kdb/kdb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/debug/kdb/kdb_main.c b/kernel/debug/kdb/kdb_main.c
index 31df170..0cbe79f 100644
--- a/kernel/debug/kdb/kdb_main.c
+++ b/kernel/debug/kdb/kdb_main.c
@@ -651,6 +651,7 @@ static int kdb_defcmd2(const char *cmdstr, const char *argv0)
 		kdb_printf("Could not allocate new kdb_defcmd table for %s\n",
 			   cmdstr);
 		s->usable = 0;
+		kfree(save_command);
 		return KDB_NOTIMP;
 	}
 	memcpy(s->command, save_command, s->count * sizeof(*(s->command)));


