Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1H3S3B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 14:29:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755974Ab1H3S27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 14:28:59 -0400
Date: Tue, 30 Aug 2011 14:28:54 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Message-Id: <bb1973868f9af8673cffdb5c77c590396d17554e.1314725877.git.jbaron@redhat.com>
In-Reply-To: <cover.1314725877.git.jbaron@redhat.com>
References: <cover.1314725877.git.jbaron@redhat.com>
Subject: [PATCH 4/4] dynamic_debug: fix undefined reference to `__netdev_printk'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic debug recently added support for netdev_printk. It uses
__netdev_printk() to support this functionality. However, when
CONFIG_NET is not set, we get the following error:

lib/built-in.o: In function `__dynamic_netdev_dbg':
(.text+0x9fda): undefined reference to `__netdev_printk'

Fix this by making the call to netdev_printk() contingent upon
CONFIG_NET. We could have fixed this by defining netdev_printk()
to a 'no-op' in the !CONFIG_NET case. However, this is not
consistent with how the networking layer uses netdev_printk.
For example, CONFIG_NET is not set, netdev_printk() does not
have a 'no-op' definition defined.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
---
 lib/dynamic_debug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 7314e5e..4138574 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -495,6 +495,8 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 }
 EXPORT_SYMBOL(__dynamic_dev_dbg);
 
+#ifdef CONFIG_NET
+
 int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		      const struct net_device *dev, const char *fmt, ...)
 {
@@ -516,6 +518,8 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
+#endif
+
 static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
-- 
1.7.5.4

