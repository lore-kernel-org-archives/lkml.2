Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1IUHwH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 03:52:07 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:49104 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752409Ab1IUHwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 03:52:05 -0400
Subject: [PATCH] init: Carefuly handle loglevel option passed to kernel
 cmdline
From: Alexander Sverdlin <asv@sysgo.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 09:51:40 +0200
Message-ID: <1316591500.14570.7.camel@alex-vb>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Sverdlin <alexander.sverdlin@sysgo.com>

Carefuly handle loglevel option passed to kernel cmdline.

When malformed loglevel value (for example "${abc}") passed to kernel
cmdline, the loglevel itself is being set to 0. This suppresses all
following messages, including all the errors and crashes caused by
other malformed cmdline options. This could make debugging process
quite tricky. Provided modifications leaves previous value of loglevel
if the new value is incorrect and report error code in this case.

Signed-off-by: Alexander Sverdlin <alexander.sverdlin@sysgo.com>
---
--- linux.old/init/main.c	2011-09-20 15:23:05.038279428 +0200
+++ linux/init/main.c	2011-09-21 09:39:24.266516051 +0200
@@ -209,8 +209,19 @@ early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
-	get_option(&str, &console_loglevel);
-	return 0;
+	int tmp_loglevel;
+
+	/*
+	 * Only update loglevel value when correct setting was passed,
+	 * to prevent blind crashes (when loglevel being set to 0) that
+	 * are quite hard to debug
+	 */
+	if (get_option(&str, &tmp_loglevel)) {
+		console_loglevel = tmp_loglevel;
+		return 0;
+	}
+
+	return -EINVAL;
 }
 
 early_param("loglevel", loglevel);



