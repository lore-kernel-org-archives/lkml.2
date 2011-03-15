Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab1COVN4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 17:13:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46305 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1COVNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 17:13:54 -0400
Date: Tue, 15 Mar 2011 14:13:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kbuild@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, Michal Marek <mmarek@suse.cz>
Subject: [PATCH] modpost: fix trailing comma
Message-Id: <20110315141347.d4ee75d3.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D7FD68E.00DF,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Consolidate locations that print a section whitelist into
calls to print_section_list().

Fix print_section_list() so that it does not print a trailing
comma & space:

If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console, 

becomes:
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 scripts/mod/modpost.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

--- linux-next-20110315.orig/scripts/mod/modpost.c
+++ linux-next-20110315/scripts/mod/modpost.c
@@ -1248,6 +1248,19 @@ static int is_function(Elf_Sym *sym)
 		return -1;
 }
 
+static void print_section_list(const char * const list[20])
+{
+	const char *const *s = list;
+
+	while (*s) {
+		fprintf(stderr, "%s", *s);
+		s++;
+		if (*s)
+			fprintf(stderr, ", ");
+	}
+	fprintf(stderr, "\n");
+}
+
 /*
  * Print a warning about a section mismatch.
  * Try to find symbols near it so user can find it.
@@ -1304,7 +1317,6 @@ static void report_sec_mismatch(const ch
 		break;
 	case DATA_TO_ANY_INIT: {
 		prl_to = sec2annotation(tosec);
-		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
 		"the %s %s%s%s\n"
@@ -1312,9 +1324,7 @@ static void report_sec_mismatch(const ch
 		"variable with __init* or __refdata (see linux/init.h) "
 		"or name the variable:\n",
 		fromsym, to, prl_to, tosym, to_p);
-		while (*s)
-			fprintf(stderr, "%s, ", *s++);
-		fprintf(stderr, "\n");
+		print_section_list(mismatch->symbol_white_list);
 		free(prl_to);
 		break;
 	}
@@ -1329,7 +1339,6 @@ static void report_sec_mismatch(const ch
 		break;
 	case DATA_TO_ANY_EXIT: {
 		prl_to = sec2annotation(tosec);
-		const char *const *s = mismatch->symbol_white_list;
 		fprintf(stderr,
 		"The variable %s references\n"
 		"the %s %s%s%s\n"
@@ -1337,9 +1346,7 @@ static void report_sec_mismatch(const ch
 		"variable with __exit* (see linux/init.h) or "
 		"name the variable:\n",
 		fromsym, to, prl_to, tosym, to_p);
-		while (*s)
-			fprintf(stderr, "%s, ", *s++);
-		fprintf(stderr, "\n");
+		print_section_list(mismatch->symbol_white_list);
 		free(prl_to);
 		break;
 	}
