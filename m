Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942Ab1E3Ncj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 09:32:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755882Ab1E3Nci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 09:32:38 -0400
Date: Mon, 30 May 2011 09:32:32 -0400
From: Kyle McMartin <kmcmartin@redhat.com>
To: jcm@jonmasters.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] fix depmod to handle passing 3.0 version numbers
Message-ID: <20110530133232.GB13573@ihatethathostname.lab.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

depmod with a 3.x version number passed in breaks since it's
testing for 3.x.y still, fix that.

(I can confirm it works and fixes modules.dep generation during fedora
 package builds.)

Signed-off-by: Kyle McMartin <kmcmartin@redhat.com>
---
diff --git a/depmod.c b/depmod.c
index abfb11e..853b52b 100644
--- a/depmod.c
+++ b/depmod.c
@@ -245,9 +245,16 @@ static const struct option options[] = { { "all", 0, NULL, 'a' },
 /* Version number or module name?  Don't assume extension. */
 static int is_version_number(const char *version)
 {
-	unsigned int dummy;
+	int ret;
+	unsigned int major, dummy;
 
-	return (sscanf(version, "%u.%u.%u", &dummy, &dummy, &dummy) == 3);
+	ret = sscanf(version, "%u.%u", &major, &dummy);
+	if ((major == 3) && (ret == 2))
+		return 1;
+
+	ret = sscanf(version, "%u.%u.%u", &dummy, &dummy, &dummy);
+
+	return (ret == 3);
 }
 
 static int old_module_version(const char *version)
