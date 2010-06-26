Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0FZTOB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 15:14:01 -0400
Received: from ozlabs.org ([203.10.76.45]:49281 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab0FZTOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 15:14:00 -0400
Date: Sun, 27 Jun 2010 05:10:59 +1000
From: Anton Blanchard <anton@samba.org>
To: akpm@linux-foundation.org, mingo@elte.hu, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Make lib/bug.c WARN implementation match the
 kernel/panic.c one
Message-ID: <20100626191059.GA2345@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are a few issues with the exception based WARN implementation in
lib/bug.c:

- Inconsistent printk flags. The "cut here" line is printed at KERN_EMERG, so
  the console and all logged in users see the single line:

------------[ cut here ]------------

  for each WARN. Fix this so we print everything at KERN_WARNING to match the
  kernel/panic.c version.

- The lib/bug.c WARN would print "Badness at". Change it to match the
  kernel/panic.c version which prints "WARNING: at". 

- Print the list of modules, similar to kernel/panic.c of modules, similar to
  kernel/panic.c

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6/lib/bug.c
===================================================================
--- linux-2.6.orig/lib/bug.c	2010-06-26 06:09:59.000000000 +1000
+++ linux-2.6/lib/bug.c	2010-06-26 06:24:28.000000000 +1000
@@ -136,8 +136,6 @@ enum bug_trap_type report_bug(unsigned l
 
 	bug = find_bug(bugaddr);
 
-	printk(KERN_EMERG "------------[ cut here ]------------\n");
-
 	file = NULL;
 	line = 0;
 	warning = 0;
@@ -156,19 +154,24 @@ enum bug_trap_type report_bug(unsigned l
 
 	if (warning) {
 		/* this is a WARN_ON rather than BUG/BUG_ON */
+		printk(KERN_WARNING "------------[ cut here ]------------\n");
+
 		if (file)
-			printk(KERN_ERR "Badness at %s:%u\n",
+			printk(KERN_WARNING "WARNING: at %s:%u\n",
 			       file, line);
 		else
-			printk(KERN_ERR "Badness at %p "
+			printk(KERN_WARNING "WARNING: at %p "
 			       "[verbose debug info unavailable]\n",
 			       (void *)bugaddr);
 
+        	print_modules();
 		show_regs(regs);
 		add_taint(BUG_GET_TAINT(bug));
 		return BUG_TRAP_TYPE_WARN;
 	}
 
+	printk(KERN_EMERG "------------[ cut here ]------------\n");
+
 	if (file)
 		printk(KERN_CRIT "kernel BUG at %s:%u!\n",
 		       file, line);
