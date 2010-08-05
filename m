Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760266Ab0HEMMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 08:12:47 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24600 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933222Ab0HEMMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 08:12:42 -0400
Subject: [PATCHv2] fixed resource leak in scripts/mod/modpost.c
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Trevor Keith <tsrk@tsrk.net>, Rusty Russell <rusty@rustcorp.com.au>,
        ext Andrew Morton <akpm@linux-foundation.org>
Content-Type: multipart/mixed; boundary="=-+MXSaejEr8qZw8Jv8jDa"
Date: Thu, 05 Aug 2010 15:09:11 +0300
Message-ID: <1281010151.2063.8.camel@alex-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
X-OriginalArrivalTime: 05 Aug 2010 12:09:59.0284 (UTC) FILETIME=[20105B40:01CB3497]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+MXSaejEr8qZw8Jv8jDa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Patch modified for released 2.6.35 kernel. 
sec2annotation returns malloc'ed buffer directly to printf as an
argument. Patch lets free this buffer after printing. 



--=-+MXSaejEr8qZw8Jv8jDa
Content-Disposition: attachment; filename="0002-fixed-resource-leak-in-scripts-mod-modpost.c.patch"
Content-Type: text/x-patch; name="0002-fixed-resource-leak-in-scripts-mod-modpost.c.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
Date: Thu, 05 Aug 2010 17:59:04 +0300
Subject: [PATCHv2] fixed resource leak in scripts/mod/modpost.c


Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
---
 scripts/mod/modpost.c |   55 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff -u -r linux-2.6.35/scripts/mod/modpost.c linux-2.6.35_b/scripts/mod/modpost.c
--- linux-2.6.35/scripts/mod/modpost.c	2010-08-02 01:11:14.000000000 +0300
+++ linux-2.6.35_b/scripts/mod/modpost.c	2010-08-05 13:25:58.856270161 +0300
@@ -1195,6 +1195,8 @@
 {
 	const char *from, *from_p;
 	const char *to, *to_p;
+	char *prl_from;
+	char *prl_to;
 
 	switch (from_is_func) {
 	case 0: from = "variable"; from_p = "";   break;
@@ -1218,16 +1221,21 @@
 
 	switch (mismatch->mismatch) {
 	case TEXT_TO_ANY_INIT:
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
 	case DATA_TO_ANY_INIT: {
+		prl_to = sec2annotation(tosec);
 		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1235,20 +1243,24 @@
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
 	case TEXT_TO_ANY_EXIT:
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The function %s() references a %s in an exit section.\n"
 		"Often the %s %s%s has valid usage outside the exit section\n"
 		"and the fix is to remove the %sannotation of %s.\n",
-		fromsym, to, to, tosym, to_p, sec2annotation(tosec), tosym);
+		fromsym, to, to, tosym, to_p, prl_to, tosym);
+		free(prl_to);
 		break;
 	case DATA_TO_ANY_EXIT: {
+		prl_to = sec2annotation(tosec);
 		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
@@ -1256,24 +1268,31 @@
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
 	case XXXINIT_TO_SOME_INIT:
 	case XXXEXIT_TO_SOME_EXIT:
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
 	case ANY_INIT_TO_ANY_EXIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1282,11 +1301,15 @@
 		"uses functionality in the exit path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an exit section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
 		sec2annotation(tosec), tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case ANY_EXIT_TO_ANY_INIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1295,16 +1318,20 @@
 		"uses functionality in the init path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an init section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
+		prl_to, tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case EXPORT_TO_INIT_EXIT:
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The symbol %s is exported and annotated %s\n"
 		"Fix this by removing the %sannotation of %s "
 		"or drop the export.\n",
-		tosym, sec2annotation(tosec), sec2annotation(tosec), tosym);
+		tosym, prl_to, prl_to, tosym);
+		free(prl_to);
 		break;
 	}
 	fprintf(stderr, "\n");

--=-+MXSaejEr8qZw8Jv8jDa--

