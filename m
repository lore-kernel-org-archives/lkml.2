Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab1ARUYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 15:24:11 -0500
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:46011 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1ARUYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 15:24:09 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
From: Tony Finch <dot@dotat.at>
To: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
Date: Tue, 18 Jan 2011 20:12:49 +0000
Subject: [PATCH] unifdef: update to upstream version 2.5
Message-Id: <E1PfI64-00041z-0d@hermes-1.csi.cam.ac.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a long-standing cpp compatibility bug. The -DFOO argument
(without an explicit value) should define FOO to 1 not to the empty
string.

Add a -o option to support overwriting a file in place, and a -S
option to list the nesting depth of symbols. Include line numbers
in debugging output. Support CRLF newlines.

Signed-off-by: Tony Finch <dot@dotat.at>
---
 scripts/unifdef.c |  247 +++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 184 insertions(+), 63 deletions(-)

diff --git a/scripts/unifdef.c b/scripts/unifdef.c
index 44d3978..7493c0e 100644
--- a/scripts/unifdef.c
+++ b/scripts/unifdef.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2002 - 2009 Tony Finch <dot@dotat.at>
+ * Copyright (c) 2002 - 2011 Tony Finch <dot@dotat.at>
  *
  * Redistribution and use in source and binary forms, with or without
  * modification, are permitted provided that the following conditions
@@ -24,23 +24,14 @@
  */
 
 /*
+ * unifdef - remove ifdef'ed lines
+ *
  * This code was derived from software contributed to Berkeley by Dave Yost.
  * It was rewritten to support ANSI C by Tony Finch. The original version
  * of unifdef carried the 4-clause BSD copyright licence. None of its code
  * remains in this version (though some of the names remain) so it now
  * carries a more liberal licence.
  *
- * The latest version is available from http://dotat.at/prog/unifdef
- */
-
-static const char * const copyright[] = {
-    "@(#) Copyright (c) 2002 - 2009 Tony Finch <dot@dotat.at>\n",
-    "$dotat: unifdef/unifdef.c,v 1.190 2009/11/27 17:21:26 fanf2 Exp $",
-};
-
-/*
- * unifdef - remove ifdef'ed lines
- *
  *  Wishlist:
  *      provide an option which will append the name of the
  *        appropriate symbol after #else's and #endif's
@@ -48,12 +39,16 @@ static const char * const copyright[] = {
  *        #else's and #endif's to see that they match their
  *        corresponding #ifdef or #ifndef
  *
- *   The first two items above require better buffer handling, which would
- *     also make it possible to handle all "dodgy" directives correctly.
+ *   These require better buffer handling, which would also make
+ *   it possible to handle all "dodgy" directives correctly.
  */
 
+#include <sys/types.h>
+#include <sys/stat.h>
+
 #include <ctype.h>
 #include <err.h>
+#include <errno.h>
 #include <stdarg.h>
 #include <stdbool.h>
 #include <stdio.h>
@@ -61,6 +56,12 @@ static const char * const copyright[] = {
 #include <string.h>
 #include <unistd.h>
 
+const char copyright[] =
+    "@(#) $Version: unifdef-2.5 $\n"
+    "@(#) $Author: Tony Finch (dot@dotat.at) $\n"
+    "@(#) $URL: http://dotat.at/prog/unifdef $\n"
+;
+
 /* types of input lines: */
 typedef enum {
 	LT_TRUEI,		/* a true #if with ignore flag */
@@ -153,6 +154,11 @@ static char const * const linestate_name[] = {
 #define	EDITSLOP        10
 
 /*
+ * For temporary filenames
+ */
+#define TEMPLATE        "unifdef.XXXXXX"
+
+/*
  * Globals.
  */
 
@@ -165,6 +171,7 @@ static bool             strictlogic;		/* -K: keep ambiguous #ifs */
 static bool             killconsts;		/* -k: eval constant #ifs */
 static bool             lnnum;			/* -n: add #line directives */
 static bool             symlist;		/* -s: output symbol list */
+static bool             symdepth;		/* -S: output symbol depth */
 static bool             text;			/* -t: this is a text file */
 
 static const char      *symname[MAXSYMS];	/* symbol name */
@@ -175,10 +182,18 @@ static int              nsyms;			/* number of symbols */
 static FILE            *input;			/* input file pointer */
 static const char      *filename;		/* input file name */
 static int              linenum;		/* current line number */
+static FILE            *output;			/* output file pointer */
+static const char      *ofilename;		/* output file name */
+static bool             overwriting;		/* output overwrites input */
+static char             tempname[FILENAME_MAX];	/* used when overwriting */
 
 static char             tline[MAXLINE+EDITSLOP];/* input buffer plus space */
 static char            *keyword;		/* used for editing #elif's */
 
+static const char      *newline;		/* input file format */
+static const char       newline_unix[] = "\n";
+static const char       newline_crlf[] = "\r\n";
+
 static Comment_state    incomment;		/* comment parser state */
 static Line_state       linestate;		/* #if line parser state */
 static Ifstate          ifstate[MAXDEPTH];	/* #if processor state */
@@ -189,10 +204,13 @@ static int              delcount;		/* count of deleted lines */
 static unsigned         blankcount;		/* count of blank lines */
 static unsigned         blankmax;		/* maximum recent blankcount */
 static bool             constexpr;		/* constant #if expression */
+static bool             zerosyms = true;	/* to format symdepth output */
+static bool             firstsym;		/* ditto */
 
 static int              exitstat;		/* program exit status */
 
 static void             addsym(bool, bool, char *);
+static void             closeout(void);
 static void             debug(const char *, ...);
 static void             done(void);
 static void             error(const char *);
@@ -212,6 +230,7 @@ static void             state(Ifstate);
 static int              strlcmp(const char *, const char *, size_t);
 static void             unnest(void);
 static void             usage(void);
+static void             version(void);
 
 #define endsym(c) (!isalnum((unsigned char)c) && c != '_')
 
@@ -223,7 +242,7 @@ main(int argc, char *argv[])
 {
 	int opt;
 
-	while ((opt = getopt(argc, argv, "i:D:U:I:BbcdeKklnst")) != -1)
+	while ((opt = getopt(argc, argv, "i:D:U:I:o:bBcdeKklnsStV")) != -1)
 		switch (opt) {
 		case 'i': /* treat stuff controlled by these symbols as text */
 			/*
@@ -245,16 +264,15 @@ main(int argc, char *argv[])
 		case 'U': /* undef a symbol */
 			addsym(false, false, optarg);
 			break;
-		case 'I':
-			/* no-op for compatibility with cpp */
-			break;
-		case 'B': /* compress blank lines around removed section */
-			compblank = true;
+		case 'I': /* no-op for compatibility with cpp */
 			break;
 		case 'b': /* blank deleted lines instead of omitting them */
 		case 'l': /* backwards compatibility */
 			lnblank = true;
 			break;
+		case 'B': /* compress blank lines around removed section */
+			compblank = true;
+			break;
 		case 'c': /* treat -D as -U and vice versa */
 			complement = true;
 			break;
@@ -273,12 +291,20 @@ main(int argc, char *argv[])
 		case 'n': /* add #line directive after deleted lines */
 			lnnum = true;
 			break;
+		case 'o': /* output to a file */
+			ofilename = optarg;
+			break;
 		case 's': /* only output list of symbols that control #ifs */
 			symlist = true;
 			break;
+		case 'S': /* list symbols with their nesting depth */
+			symlist = symdepth = true;
+			break;
 		case 't': /* don't parse C comments */
 			text = true;
 			break;
+		case 'V': /* print version */
+			version();
 		default:
 			usage();
 		}
@@ -290,21 +316,68 @@ main(int argc, char *argv[])
 		errx(2, "can only do one file");
 	} else if (argc == 1 && strcmp(*argv, "-") != 0) {
 		filename = *argv;
-		input = fopen(filename, "r");
+		input = fopen(filename, "rb");
 		if (input == NULL)
 			err(2, "can't open %s", filename);
 	} else {
 		filename = "[stdin]";
 		input = stdin;
 	}
+	if (ofilename == NULL) {
+		ofilename = "[stdout]";
+		output = stdout;
+	} else {
+		struct stat ist, ost;
+		if (stat(ofilename, &ost) == 0 &&
+		    fstat(fileno(input), &ist) == 0)
+			overwriting = (ist.st_dev == ost.st_dev
+				    && ist.st_ino == ost.st_ino);
+		if (overwriting) {
+			const char *dirsep;
+			int ofd;
+
+			dirsep = strrchr(ofilename, '/');
+			if (dirsep != NULL)
+				snprintf(tempname, sizeof(tempname),
+				    "%.*s/" TEMPLATE,
+				    (int)(dirsep - ofilename), ofilename);
+			else
+				snprintf(tempname, sizeof(tempname),
+				    TEMPLATE);
+			ofd = mkstemp(tempname);
+			if (ofd != -1)
+				output = fdopen(ofd, "wb+");
+			if (output == NULL)
+				err(2, "can't create temporary file");
+			fchmod(ofd, ist.st_mode & (S_IRWXU|S_IRWXG|S_IRWXO));
+		} else {
+			output = fopen(ofilename, "wb");
+			if (output == NULL)
+				err(2, "can't open %s", ofilename);
+		}
+	}
 	process();
 	abort(); /* bug */
 }
 
 static void
+version(void)
+{
+	const char *c = copyright;
+	for (;;) {
+		while (*++c != '$')
+			if (*c == '\0')
+				exit(0);
+		while (*++c != '$')
+			putc(*c, stderr);
+		putc('\n', stderr);
+	}
+}
+
+static void
 usage(void)
 {
-	fprintf(stderr, "usage: unifdef [-BbcdeKknst] [-Ipath]"
+	fprintf(stderr, "usage: unifdef [-bBcdeKknsStV] [-Ipath]"
 	    " [-Dsym[=val]] [-Usym] [-iDsym[=val]] [-iUsym] ... [file]\n");
 	exit(2);
 }
@@ -322,7 +395,8 @@ usage(void)
  * When we have processed a group that starts off with a known-false
  * #if/#elif sequence (which has therefore been deleted) followed by a
  * #elif that we don't understand and therefore must keep, we edit the
- * latter into a #if to keep the nesting correct.
+ * latter into a #if to keep the nesting correct. We use strncpy() to
+ * overwrite the 4 byte token "elif" with "if  " without a '\0' byte.
  *
  * When we find a true #elif in a group, the following block will
  * always be kept and the rest of the sequence after the next #elif or
@@ -375,11 +449,11 @@ static void Oelif (void) { if (!iocccok) Eioccc(); Pelif(); }
 static void Idrop (void) { Fdrop();  ignoreon(); }
 static void Itrue (void) { Ftrue();  ignoreon(); }
 static void Ifalse(void) { Ffalse(); ignoreon(); }
-/* edit this line */
+/* modify this line */
 static void Mpass (void) { strncpy(keyword, "if  ", 4); Pelif(); }
-static void Mtrue (void) { keywordedit("else\n");  state(IS_TRUE_MIDDLE); }
-static void Melif (void) { keywordedit("endif\n"); state(IS_FALSE_TRAILER); }
-static void Melse (void) { keywordedit("endif\n"); state(IS_FALSE_ELSE); }
+static void Mtrue (void) { keywordedit("else");  state(IS_TRUE_MIDDLE); }
+static void Melif (void) { keywordedit("endif"); state(IS_FALSE_TRAILER); }
+static void Melse (void) { keywordedit("endif"); state(IS_FALSE_ELSE); }
 
 static state_fn * const trans_table[IS_COUNT][LT_COUNT] = {
 /* IS_OUTSIDE */
@@ -431,13 +505,6 @@ static state_fn * const trans_table[IS_COUNT][LT_COUNT] = {
  * State machine utility functions
  */
 static void
-done(void)
-{
-	if (incomment)
-		error("EOF in comment");
-	exit(exitstat);
-}
-static void
 ignoreoff(void)
 {
 	if (depth == 0)
@@ -452,14 +519,8 @@ ignoreon(void)
 static void
 keywordedit(const char *replacement)
 {
-	size_t size = tline + sizeof(tline) - keyword;
-	char *dst = keyword;
-	const char *src = replacement;
-	if (size != 0) {
-		while ((--size != 0) && (*src != '\0'))
-			*dst++ = *src++;
-		*dst = '\0';
-	}
+	snprintf(keyword, tline + sizeof(tline) - keyword,
+	    "%s%s", replacement, newline);
 	print();
 }
 static void
@@ -494,24 +555,26 @@ flushline(bool keep)
 	if (symlist)
 		return;
 	if (keep ^ complement) {
-		bool blankline = tline[strspn(tline, " \t\n")] == '\0';
+		bool blankline = tline[strspn(tline, " \t\r\n")] == '\0';
 		if (blankline && compblank && blankcount != blankmax) {
 			delcount += 1;
 			blankcount += 1;
 		} else {
 			if (lnnum && delcount > 0)
-				printf("#line %d\n", linenum);
-			fputs(tline, stdout);
+				printf("#line %d%s", linenum, newline);
+			fputs(tline, output);
 			delcount = 0;
 			blankmax = blankcount = blankline ? blankcount + 1 : 0;
 		}
 	} else {
 		if (lnblank)
-			putc('\n', stdout);
+			fputs(newline, output);
 		exitstat = 1;
 		delcount += 1;
 		blankcount = 0;
 	}
+	if (debugging)
+		fflush(output);
 }
 
 /*
@@ -520,22 +583,55 @@ flushline(bool keep)
 static void
 process(void)
 {
-	Linetype lineval;
-
 	/* When compressing blank lines, act as if the file
 	   is preceded by a large number of blank lines. */
 	blankmax = blankcount = 1000;
 	for (;;) {
-		linenum++;
-		lineval = parseline();
+		Linetype lineval = parseline();
 		trans_table[ifstate[depth]][lineval]();
-		debug("process %s -> %s depth %d",
-		    linetype_name[lineval],
+		debug("process line %d %s -> %s depth %d",
+		    linenum, linetype_name[lineval],
 		    ifstate_name[ifstate[depth]], depth);
 	}
 }
 
 /*
+ * Flush the output and handle errors.
+ */
+static void
+closeout(void)
+{
+	if (symdepth && !zerosyms)
+		printf("\n");
+	if (fclose(output) == EOF) {
+		warn("couldn't write to %s", ofilename);
+		if (overwriting) {
+			unlink(tempname);
+			errx(2, "%s unchanged", filename);
+		} else {
+			exit(2);
+		}
+	}
+}
+
+/*
+ * Clean up and exit.
+ */
+static void
+done(void)
+{
+	if (incomment)
+		error("EOF in comment");
+	closeout();
+	if (overwriting && rename(tempname, ofilename) == -1) {
+		warn("couldn't rename temporary file");
+		unlink(tempname);
+		errx(2, "%s unchanged", ofilename);
+	}
+	exit(exitstat);
+}
+
+/*
  * Parse a line and determine its type. We keep the preprocessor line
  * parser state between calls in the global variable linestate, with
  * help from skipcomment().
@@ -549,14 +645,22 @@ parseline(void)
 	Linetype retval;
 	Comment_state wascomment;
 
+	linenum++;
 	if (fgets(tline, MAXLINE, input) == NULL)
 		return (LT_EOF);
+	if (newline == NULL) {
+		if (strrchr(tline, '\n') == strrchr(tline, '\r') + 1)
+			newline = newline_crlf;
+		else
+			newline = newline_unix;
+	}
 	retval = LT_PLAIN;
 	wascomment = incomment;
 	cp = skipcomment(tline);
 	if (linestate == LS_START) {
 		if (*cp == '#') {
 			linestate = LS_HASH;
+			firstsym = true;
 			cp = skipcomment(cp + 1);
 		} else if (*cp != '\0')
 			linestate = LS_DIRTY;
@@ -566,7 +670,8 @@ parseline(void)
 		cp = skipsym(cp);
 		kwlen = cp - keyword;
 		/* no way can we deal with a continuation inside a keyword */
-		if (strncmp(cp, "\\\n", 2) == 0)
+		if (strncmp(cp, "\\\r\n", 3) == 0 ||
+		    strncmp(cp, "\\\n", 2) == 0)
 			Eioccc();
 		if (strlcmp("ifdef", keyword, kwlen) == 0 ||
 		    strlcmp("ifndef", keyword, kwlen) == 0) {
@@ -617,9 +722,8 @@ parseline(void)
 			size_t len = cp - tline;
 			if (fgets(tline + len, MAXLINE - len, input) == NULL) {
 				/* append the missing newline */
-				tline[len+0] = '\n';
-				tline[len+1] = '\0';
-				cp++;
+				strcpy(tline + len, newline);
+				cp += strlen(newline);
 				linestate = LS_START;
 			} else {
 				linestate = LS_DIRTY;
@@ -630,7 +734,7 @@ parseline(void)
 		while (*cp != '\0')
 			cp = skipcomment(cp + 1);
 	}
-	debug("parser %s comment %s line",
+	debug("parser line %d state %s comment %s line", linenum,
 	    comment_name[incomment], linestate_name[linestate]);
 	return (retval);
 }
@@ -875,11 +979,16 @@ skipcomment(const char *cp)
 	}
 	while (*cp != '\0')
 		/* don't reset to LS_START after a line continuation */
-		if (strncmp(cp, "\\\n", 2) == 0)
+		if (strncmp(cp, "\\\r\n", 3) == 0)
+			cp += 3;
+		else if (strncmp(cp, "\\\n", 2) == 0)
 			cp += 2;
 		else switch (incomment) {
 		case NO_COMMENT:
-			if (strncmp(cp, "/\\\n", 3) == 0) {
+			if (strncmp(cp, "/\\\r\n", 4) == 0) {
+				incomment = STARTING_COMMENT;
+				cp += 4;
+			} else if (strncmp(cp, "/\\\n", 3) == 0) {
 				incomment = STARTING_COMMENT;
 				cp += 3;
 			} else if (strncmp(cp, "/*", 2) == 0) {
@@ -899,7 +1008,7 @@ skipcomment(const char *cp)
 			} else if (strncmp(cp, "\n", 1) == 0) {
 				linestate = LS_START;
 				cp += 1;
-			} else if (strchr(" \t", *cp) != NULL) {
+			} else if (strchr(" \r\t", *cp) != NULL) {
 				cp += 1;
 			} else
 				return (cp);
@@ -931,7 +1040,10 @@ skipcomment(const char *cp)
 				cp += 1;
 			continue;
 		case C_COMMENT:
-			if (strncmp(cp, "*\\\n", 3) == 0) {
+			if (strncmp(cp, "*\\\r\n", 4) == 0) {
+				incomment = FINISHING_COMMENT;
+				cp += 4;
+			} else if (strncmp(cp, "*\\\n", 3) == 0) {
 				incomment = FINISHING_COMMENT;
 				cp += 3;
 			} else if (strncmp(cp, "*/", 2) == 0) {
@@ -1015,7 +1127,13 @@ findsym(const char *str)
 	if (cp == str)
 		return (-1);
 	if (symlist) {
-		printf("%.*s\n", (int)(cp-str), str);
+		if (symdepth && firstsym)
+			printf("%s%3d", zerosyms ? "" : "\n", depth);
+		firstsym = zerosyms = false;
+		printf("%s%.*s%s",
+		    symdepth ? " " : "",
+		    (int)(cp-str), str,
+		    symdepth ? "" : "\n");
 		/* we don't care about the value of the symbol */
 		return (0);
 	}
@@ -1052,7 +1170,7 @@ addsym(bool ignorethis, bool definethis, char *sym)
 			value[symind] = val+1;
 			*val = '\0';
 		} else if (*val == '\0')
-			value[symind] = "";
+			value[symind] = "1";
 		else
 			usage();
 	} else {
@@ -1060,6 +1178,8 @@ addsym(bool ignorethis, bool definethis, char *sym)
 			usage();
 		value[symind] = NULL;
 	}
+	debug("addsym %s=%s", symname[symind],
+	    value[symind] ? value[symind] : "undef");
 }
 
 /*
@@ -1100,5 +1220,6 @@ error(const char *msg)
 	else
 		warnx("%s: %d: %s (#if line %d depth %d)",
 		    filename, linenum, msg, stifline[depth], depth);
+	closeout();
 	errx(2, "output may be truncated");
 }
-- 
1.7.3.GIT

