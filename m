Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab1AHURi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Jan 2011 15:17:38 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49711 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1AHUQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Jan 2011 15:16:49 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=z4NdwlQT954A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=e03UDvgexRQNvJOciaMA:9 a=FEj88m7m9Vaa9XmLWr4A:7 a=kCJlOY29veZ3OvawBynujdPbwT8A:4 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110108201646.319708666@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 08 Jan 2011 15:16:06 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, <stable@kernel.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jason Baron <jbaron@redhat.com>
Subject: [PATCH 7/7] dynamic debug: Fix build issue with older gcc
References: <20110108201559.130182944@goodmis.org>
Content-Disposition: inline; filename=0007-dynamic-debug-Fix-build-issue-with-older-gcc.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

On older gcc (3.3) dynamic debug fails to compile:

include/net/inet_connection_sock.h: In function `inet_csk_reset_xmit_timer':
include/net/inet_connection_sock.h:236: error: duplicate label declaration `do_printk'
include/net/inet_connection_sock.h:219: error: this is a previous declaration
include/net/inet_connection_sock.h:236: error: duplicate label declaration `out'
include/net/inet_connection_sock.h:219: error: this is a previous declaration
include/net/inet_connection_sock.h:236: error: duplicate label `do_printk'
include/net/inet_connection_sock.h:236: error: duplicate label `out'

Fix, by reverting the usage of JUMP_LABEL() in dynamic debug for now.

Cc: <stable@kernel.org>
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Tested-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Jason Baron <jbaron@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/dynamic_debug.h |   18 ++++--------------
 lib/dynamic_debug.c           |    9 ++++-----
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index a90b389..1c70028 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -44,34 +44,24 @@ int ddebug_add_module(struct _ddebug *tab, unsigned int n,
 extern int ddebug_remove_module(const char *mod_name);
 
 #define dynamic_pr_debug(fmt, ...) do {					\
-	__label__ do_printk;						\
-	__label__ out;							\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
 		_DPRINTK_FLAGS_DEFAULT };				\
-	JUMP_LABEL(&descriptor.enabled, do_printk);			\
-	goto out;							\
-do_printk:								\
-	printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);			\
-out:	;								\
+	if (unlikely(descriptor.enabled))				\
+		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
 	} while (0)
 
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	__label__ do_printk;						\
-	__label__ out;							\
 	static struct _ddebug descriptor				\
 	__used								\
 	__attribute__((section("__verbose"), aligned(8))) =		\
 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
 		_DPRINTK_FLAGS_DEFAULT };				\
-	JUMP_LABEL(&descriptor.enabled, do_printk);			\
-	goto out;							\
-do_printk:								\
-	dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);		\
-out:	;								\
+	if (unlikely(descriptor.enabled))				\
+		dev_printk(KERN_DEBUG, dev, fmt, ##__VA_ARGS__);	\
 	} while (0)
 
 #else
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 3094318..b335acb 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -141,11 +141,10 @@ static void ddebug_change(const struct ddebug_query *query,
 			else if (!dp->flags)
 				dt->num_enabled++;
 			dp->flags = newflags;
-			if (newflags) {
-				jump_label_enable(&dp->enabled);
-			} else {
-				jump_label_disable(&dp->enabled);
-			}
+			if (newflags)
+				dp->enabled = 1;
+			else
+				dp->enabled = 0;
 			if (verbose)
 				printk(KERN_INFO
 					"ddebug: changed %s:%d [%s]%s %s\n",
-- 
1.7.2.3


