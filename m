Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751432Ab1ITNxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 09:53:31 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:46323 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1ITNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 09:53:30 -0400
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Sep 2011 09:53:30 EDT
Message-ID: <4E7898E1.5030000@sysgo.com>
Date: Tue, 20 Sep 2011 15:45:05 +0200
From: Alexander Sverdlin <asv@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: [PATCH] init: Carefuly handle loglevel option passed to kernel cmdline.
Content-Type: text/plain; charset=ISO-8859-1
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
+++ linux/init/main.c	2011-09-20 15:23:44.064930478 +0200
@@ -209,7 +209,18 @@ early_param("quiet", quiet_kernel);
 
 static int __init loglevel(char *str)
 {
-	get_option(&str, &console_loglevel);
+	int tmp_loglevel;
+
+	/*
+	 * Only update loglevel value when correct setting was passed,
+	 * to prevent blind crashes (when loglevel being set to 0) that
+	 * are quite hard to debug
+	 */
+	if (get_option(&str, &tmp_loglevel))
+		console_loglevel = tmp_loglevel;
+	else
+		return EINVAL;
+
 	return 0;
 }
 
