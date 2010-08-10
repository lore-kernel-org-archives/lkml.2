Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0HJMCg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:02:36 -0400
Received: from smtp.nokia.com ([192.100.122.233]:33961 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab0HJMCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:02:32 -0400
Subject: [PATCHv4] fixed resource leak in scripts/mod/modpost.c
From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: ext Andy Shevchenko <andy.shevchenko@gmail.com>,
        Trevor Keith <tsrk@tsrk.net>, Rusty Russell <rusty@rustcorp.com.au>,
        ext Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=UfzGay5XQKMpPCZTSO5SJ1jDknqwayhrEZJO0@mail.gmail.com>
References: <1281010151.2063.8.camel@alex-desktop>
	 <AANLkTi=YessPd6cHhLdveyrSq_TcY1Vx1LxpCNLthEJG@mail.gmail.com>
	 <1281437552.2063.431.camel@alex-desktop>
	 <AANLkTi=UfzGay5XQKMpPCZTSO5SJ1jDknqwayhrEZJO0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Aug 2010 15:03:28 +0300
Message-ID: <1281441808.2063.498.camel@alex-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Aug 2010 12:01:39.0958 (UTC) FILETIME=[CA820160:01CB3883]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Fomenko <ext-alexey.fomenko@nokia.com>

sec2annotation() returns malloc'ed buffer directly to printf as an
argument. Patch lets free this buffer after printing. Preventing ops
while freeing the buffer by changing return const str to return 
strdup empty line.

Signed-off-by: Alexey Fomenko <ext-alexey.fomenko@nokia.com>
---
 scripts/mod/modpost.c |   62 ++++++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 19 deletions(-)

diff -ur linux-2.6.35/scripts/mod/modpost.c linux-2.6.35_b/scripts/mod/modpost.c
--- linux-2.6.35/scripts/mod/modpost.c	2010-08-10 12:11:03.854528620 +0300
+++ linux-2.6.35_b/scripts/mod/modpost.c	2010-08-10 14:45:00.294529178 +0300
@@ -1165,9 +1165,9 @@
 			strcat(p, "data ");
 		else
 			strcat(p, " ");
-		return r; /* we leak her but we do not care */
+		return r;
 	} else {
-		return "";
+		return strdup("");
 	}
 }
 
@@ -1195,6 +1195,8 @@
 {
 	const char *from, *from_p;
 	const char *to, *to_p;
+	char *prl_from;
+	char *prl_to;
 
 
 	switch (from_is_func) {
@@ -1219,16 +1221,21 @@
 
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
@@ -1236,20 +1243,24 @@
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
@@ -1257,24 +1268,31 @@
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
@@ -1283,11 +1301,15 @@
 		"uses functionality in the exit path.\n"
 		"The fix is often to remove the %sannotation of\n"
 		"%s%s so it may be used outside an exit section.\n",
-		from, sec2annotation(fromsec), fromsym, from_p,
-		to, sec2annotation(tosec), tosym, to_p,
-		sec2annotation(tosec), tosym, to_p);
+		from, prl_from, fromsym, from_p,
+		to, prl_to, tosym, to_p,
+		ptl_to, tosym, to_p);
+		free(prl_from);
+		free(prl_to);
 		break;
 	case ANY_EXIT_TO_ANY_INIT:
+		prl_from = sec2annotation(fromsec);
+		prl_to = sec2annotation(tosec);
 		fprintf(stderr,
 		"The %s %s%s%s references\n"
 		"a %s %s%s%s.\n"
@@ -1296,16 +1318,20 @@
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


