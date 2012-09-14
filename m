Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab2INHM3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 03:12:29 -0400
Received: from ozlabs.org ([203.10.76.45]:38235 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870Ab2INHM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 03:12:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Jon Masters <jonathan@jonmasters.org>
Subject: module: test code for waiting.
In-Reply-To: <87obl9rsg2.fsf@rustcorp.com.au>
References: <87obl9rsg2.fsf@rustcorp.com.au>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 14 Sep 2012 16:42:17 +0930
Message-ID: <87ipbhrsby.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Subject: module: dummy module to test loading race.
---
 kernel/Makefile   |    1 +
 kernel/test-mod.c |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/kernel/Makefile b/kernel/Makefile
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -131,3 +131,4 @@ quiet_cmd_timeconst  = TIMEC   $@
 targets += timeconst.h
 $(obj)/timeconst.h: $(src)/timeconst.pl FORCE
 	$(call if_changed,timeconst)
+obj-m += test-mod.o
diff --git a/kernel/test-mod.c b/kernel/test-mod.c
new file mode 100644
--- /dev/null
+++ b/kernel/test-mod.c
@@ -0,0 +1,21 @@
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/delay.h>
+
+static bool fail;
+module_param(fail, bool, 0644);
+
+int init(void)
+{
+	printk("Module %p init start...\n", THIS_MODULE);
+	ssleep(10);
+	printk("...%p init %s\n", THIS_MODULE, fail ? "fail" : "succeed");
+	return fail ? -EINVAL : 0;
+}
+
+void fini(void)
+{
+}
+
+module_init(init);
+module_exit(fini);
