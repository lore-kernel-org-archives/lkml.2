Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2EALXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 07:23:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43981 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2EALXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 07:23:46 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jim Cromie <jim.cromie@gmail.com>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, Roland Dreier <roland@purestorage.com>,
        Jason Baron <jbaron@redhat.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] dynamic_debug: use printk(KERN_WARNING..) in stub function
Date: Tue,  1 May 2012 05:23:12 -0600
Message-Id: <1335871392-2222-1-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/infiniband/ulp/srp/ib_srp.c #defines pr_fmt() PFX fmt, but PFX
is not #defined until after <linux/*> headers are included.

This results in a bad expansion of the pr_warn() in the stub function.

2084c2084
<   printk("<4>" PFX "dyndbg supported only in " "CONFIG_DYNAMIC_DEBUG builds\n")
---
>   printk("<4>" "guano" "dyndbg supported only in " "CONFIG_DYNAMIC_DEBUG builds\n")
(END)

While that use-case is less than ideal, it will probably happen again,
and its easy to avoid by using raw printk().

To: Bart Van Assche bvanassche@acm.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Greg KH <greg@kroah.com>
CC: linux-next@vger.kernel.org
CC: Roland Dreier <roland@purestorage.com>
CC: Jason Baron <jbaron@redhat.com>
CC: Joe Perches <joe@perches.com>
Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 include/linux/dynamic_debug.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index 4697e4b..c18257b 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -109,7 +109,8 @@ static inline int ddebug_dyndbg_module_param_cb(char *param, char *val,
 						const char *modname)
 {
 	if (strstr(param, "dyndbg")) {
-		pr_warn("dyndbg supported only in "
+		/* avoid pr_warn(), which wants pr_fmt() fully defined */
+		printk(KERN_WARNING "dyndbg param is supported only in "
 			"CONFIG_DYNAMIC_DEBUG builds\n");
 		return 0; /* allow and ignore */
 	}
-- 
1.7.7.6

