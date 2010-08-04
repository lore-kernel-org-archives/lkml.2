Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab0HDMhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:37:11 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:50576 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932654Ab0HDMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:37:08 -0400
Subject: [PATCH] fixed resource leak in scripts/mod/modpost.c
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: Trevor Keith <tsrk@tsrk.net>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-H34k/rxQ04+FwIaeczlr"
Date: Wed, 04 Aug 2010 15:38:43 +0300
Message-ID: <1280925523.4449.158.camel@alex-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-H34k/rxQ04+FwIaeczlr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

sec2annotation returns malloc'ed buffer directly to printf as an
argument. Patch lets free this buffer after printing. 

--=-H34k/rxQ04+FwIaeczlr
Content-Disposition: attachment; filename="0001-fixed-resource-leak-in-scripts-mod-modpost.c.patch"
Content-Type: text/x-patch; name="0001-fixed-resource-leak-in-scripts-mod-modpost.c.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

>From 57bde7f335730f95eac75bcec5a27fb6686df25a Mon Sep 17 00:00:00 2001
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Date: Tue, 27 Jul 2010 17:59:04 +0300
Subject: [PATCH] fixed resource leak in scripts/mod/modpost.c


Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
---
 scripts/mod/modpost.c |   59 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 44 insertions(+), 15 deletions(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 801a16a..1466691 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1158,6 +1158,9 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 {
 	const char *from, *from_p;
 	const char *to, *to_p;
+	char *prl_from;
+	char *prl_to;
+
 
 	switch (from_is_func) {
 	case 0: from = "variable"; from_p = "";   break;
@@ -1181,16 +1184,21 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 
 	switch (mismatch) {
 	case TEXT_TO_INIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The function %s%s() references\n"
 		"the %s %s%s%s.\n"
 		"This is often because %s lacks a %s\n"
 		"annotation or the annotation of %s is wrong.\n",
-		sec2annotation(fromsec), fromsym,
-		to, sec2annotation(tosec), tosym, to_p,
-		fromsym, sec2annotation(tosec), tosym);
+		prl_from, fromsym,
+		to, prl_to, tosym, to_p,
+		fromsym, prl_to, tosym);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case DATA_TO_INIT: {
+		prl_to = sec2annotation(tosec);
 		const char **s = symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1198,20 +1206,24 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		"If the reference is valid then annotate the\n"
 		"variable with __init* or __refdata (see linux/init.h) "
 		"or name the variable:\n",
-		fromsym, to, sec2annotation(tosec), tosym, to_p);
+		fromsym, to, prl_to, tosym, to_p);
 		while (*s)
 			fprintf(stderr, "%s, ", *s++);
 		fprintf(stderr, "\n");
+		free(prl_to);
 		break;
 	}
 	case TEXT_TO_EXIT:
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The function %s() references a %s in an exit section.\n"
 		"Often the %s %s%s has valid usage outside the exit section\n"
 		"and the fix is to remove the %sannotation of %s.\n",
-		fromsym, to, to, tosym, to_p, sec2annotation(tosec), tosym);
+		fromsym, to, to, tosym, to_p, prl_to, tosym);
+		free(prl_to);
 		break;
 	case DATA_TO_EXIT: {
+		prl_to = sec2annotation(tosec);
 		const char **s = symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1219,24 +1231,31 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		"If the reference is valid then annotate the\n"
 		"variable with __exit* (see linux/init.h) or "
 		"name the variable:\n",
-		fromsym, to, sec2annotation(tosec), tosym, to_p);
+		fromsym, to, prl_to, tosym, to_p);
 		while (*s)
 			fprintf(stderr, "%s, ", *s++);
 		fprintf(stderr, "\n");
+		free(prl_to);
 		break;
 	}
 	case XXXINIT_TO_INIT:
 	case XXXEXIT_TO_EXIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
 		"If %s is only used by %s then\n"
 		"annotate %s with a matching annotation.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
 		tosym, fromsym, tosym);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case INIT_TO_EXIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1245,11 +1264,15 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		"uses functionality in the exit path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an exit section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
+		prl_to, tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case EXIT_TO_INIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1258,16 +1281,22 @@ static void report_sec_mismatch(const char *modname, enum mismatch mismatch,
 		"uses functionality in the init path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an init section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
+		to, tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case EXPORT_TO_INIT_EXIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The symbol %s is exported and annotated %s\n"
 		"Fix this by removing the %sannotation of %s "
 		"or drop the export.\n",
-		tosym, sec2annotation(tosec), sec2annotation(tosec), tosym);
+		tosym, prl_to, prl_to, tosym);
+		free(prl_from);
+		free(prl_to);
 	case NO_MISMATCH:
 		/* To get warnings on missing members */
 		break;
-- 
1.6.3.3


--=-H34k/rxQ04+FwIaeczlr--

