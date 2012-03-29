Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760223Ab2C2Wt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 18:49:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:36781 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760219Ab2C2WtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 18:49:14 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <kgdb-bugreport@lists.sourceforge.net>
Subject: [PATCH 1/6] kdb: Fix smatch warning on dbg_io_ops->is_console
Date: Thu, 29 Mar 2012 17:48:57 -0500
Message-ID: <1333061342-10132-2-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.7.9.4
In-Reply-To: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
References: <1333061342-10132-1-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Smatch tool warned that the change from commit b8adde8dd
(kdb: Avoid using dbg_io_ops until it is initialized) should
add another null check later in the kdb_printf().

It is worth noting that the second use of dbg_io_ops->is_console
is protected by the KDB_PAGER state variable which would only
get set when kdb is fully active and initialized.  If we
ever encounter changes or defects in the KDB_PAGER state
we do not want to crash the kernel in a kdb_printf/printk.

CC: Tim Bird <tim.bird@am.sony.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/debug/kdb/kdb_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index 9b5f17d..bb9520f 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -743,7 +743,7 @@ kdb_printit:
 		kdb_input_flush();
 		c = console_drivers;
 
-		if (!dbg_io_ops->is_console) {
+		if (dbg_io_ops && !dbg_io_ops->is_console) {
 			len = strlen(moreprompt);
 			cp = moreprompt;
 			while (len--) {
-- 
1.7.9.4

