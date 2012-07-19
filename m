Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab2GSTrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 15:47:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:54567 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2GSTqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:46:46 -0400
From: Jim Cromie <jim.cromie@gmail.com>
To: jbaron@redhat.com, linux-kernel@vger.kernel.org
Cc: kay@vrfy.com, joe@perches.com, greg@kroah.com,
        Jim Cromie <jim.cromie@gmail.com>
Subject: [PATCH 1/3] drivers-core: make structured logging play nice with dynamic-debug
Date: Thu, 19 Jul 2012 13:46:20 -0600
Message-Id: <1342727183-4520-2-git-send-email-jim.cromie@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
References: <1342727183-4520-1-git-send-email-jim.cromie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c4e00daaa96d3a0786f1f4fe6456281c60ef9a16 changed __dev_printk
in a way that broke dynamic-debug's ability to control the dynamic
prefix of dev_dbg(dev,..), but not dev_dbg(NULL,..) or pr_debug(..),
which is why it wasnt noticed sooner.

When dev==NULL, __dev_printk() just calls printk(), which just works.
But otherwise, it assumed that level was always a string like "<L>"
and just plucked out the 'L', ignoring the rest.  However,
dynamic_emit_prefix() adds "[tid] module:func:line:" to the string,
those additions all got lost.

Signed-off-by: Jim Cromie <jim.cromie@gmail.com>
---
 drivers/base/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 346be8b..ebdb7c5 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1848,6 +1848,7 @@ int __dev_printk(const char *level, const struct device *dev,
 		 struct va_format *vaf)
 {
 	char dict[128];
+	const char *level_extra = "";
 	size_t dictlen = 0;
 	const char *subsys;
 
@@ -1894,10 +1895,14 @@ int __dev_printk(const char *level, const struct device *dev,
 				    "DEVICE=+%s:%s", subsys, dev_name(dev));
 	}
 skip:
+	if (level[3])
+		level_extra = &level[3]; /* skip past "<L>" */
+
 	return printk_emit(0, level[1] - '0',
 			   dictlen ? dict : NULL, dictlen,
-			   "%s %s: %pV",
-			   dev_driver_string(dev), dev_name(dev), vaf);
+			   "%s %s: %s%pV", 
+			   dev_driver_string(dev), dev_name(dev),
+			   level_extra, vaf);
 }
 EXPORT_SYMBOL(__dev_printk);
 
-- 
1.7.10.4

