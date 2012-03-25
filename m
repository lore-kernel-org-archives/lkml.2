Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2CYX1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 19:27:24 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61995 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab2CYX0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 19:26:32 -0400
From: jim.cromie@gmail.com
To: jbaron@redhat.com
Cc: linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 15/16] dynamic_debug: init with early_initcall, not arch_initcall
Date: Sun, 25 Mar 2012 17:25:53 -0600
Message-Id: <1332717954-5775-16-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
References: <1332717954-5775-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jim Cromie <jim.cromie@gmail.com>

1- Call dynamic_debug_init() from early_initcall, not arch_initcall.
2- Call dynamic_debug_init_debugfs() from fs_initcall, not module_init.

RFC: This works for me on a 64 bit desktop and a i586 SBC, but is
untested on other arches.  I presume there is or was a reason
original code used arch_initcall, maybe the constraints have changed.

This makes facility available as soon as possible.

2nd change has a downside when dynamic_debug.verbose=1; all the
vpr_info()s called in the proc-fs code are activated, causing
voluminous output from dmesg.  TBD: Im unsure of this explanation, but
the output is there.  This could be fixed by changing those callsites
to v2pr_info(if verbose > 1).

1st change is still not early enough to enable pr_debugs in
kernel/params, so parsing of boot-args isnt logged.  The reparse of
those args is however visible after params.dyndbg="+p" is processed.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 lib/dynamic_debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7eb7a55..f7ba216 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -1037,7 +1037,7 @@ out_err:
 	return 0;
 }
 /* Allow early initialization for boot messages via boot param */
-arch_initcall(dynamic_debug_init);
+early_initcall(dynamic_debug_init);
 
 /* Debugfs setup must be done later */
-module_init(dynamic_debug_init_debugfs);
+fs_initcall(dynamic_debug_init_debugfs);
-- 
1.7.7.6

