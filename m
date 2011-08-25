Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754986Ab1HYReb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:34:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754964Ab1HYRe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:34:27 -0400
Date: Thu, 25 Aug 2011 13:34:22 -0400
From: Jason Baron <jbaron@redhat.com>
To: gregkh@suse.de
Cc: joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        rdunlap@xenotime.net, linux-kernel@vger.kernel.org
Message-Id: <4a14fe356572d4ccb50d3cad6599a4f79ba0914e.1314291910.git.jbaron@redhat.com>
In-Reply-To: <cover.1314291909.git.jbaron@redhat.com>
References: <cover.1314291909.git.jbaron@redhat.com>
Subject: [PATCH 4/4] dynamic_debug: fix undefined reference to `__netdev_printk'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamic debug recently added a call to __netdev_printk(). However, when
CONFIG_NET is not set, we get the following error:

lib/built-in.o: In function `__dynamic_netdev_dbg':
(.text+0x9fda): undefined reference to `__netdev_printk'

Fix this by making the call to __netdev_printk() contingent upon
CONFIG_NET. We could have fixed this by defining __netdev_printk()
to a 'no-op' in the !CONFIG_NET case. However, this is not
consistent with how the networking layer uses netdev_printk().
For example, when CONFIG_NET is not set, netdev_printk() does not
have a 'no-op' definition defined.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>
---
 lib/dynamic_debug.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index 1f11978..bda4036 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -489,6 +489,8 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 }
 EXPORT_SYMBOL(__dynamic_dev_dbg);
 
+#ifdef CONFIG_NET
+
 int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		      const struct net_device *dev, const char *fmt, ...)
 {
@@ -510,6 +512,8 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
 
+#endif
+
 static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)
 {
-- 
1.7.5.4

