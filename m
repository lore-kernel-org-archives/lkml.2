Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab0HRNJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 09:09:32 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:47862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0HRNJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 09:09:30 -0400
Subject: [RFC] Docbook: allow warning on unused documentation
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Aug 2010 15:09:27 +0200
Message-ID: <1282136967.13315.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When you don't use !E or !I but only !F, then
it's very easy to miss including some functions,
structs etc. in documentation. To help finding
which ones were missed, allow printing out the
unused ones as warnings.

For example, using this on mac80211 yields a
lot of warnings like this:

  Warning: didn't use docs for DOC: mac80211 workqueue
  Warning: didn't use docs for ieee80211_max_queues
  Warning: didn't use docs for ieee80211_bss_change
  Warning: didn't use docs for ieee80211_bss_conf

when generating the documentation for it.
---
 Documentation/kernel-doc-nano-HOWTO.txt |    5 +
 scripts/basic/docproc.c                 |  130 +++++++++++++++++++++++++++++++-
 scripts/kernel-doc                      |   52 ++++++++++++
 3 files changed, 184 insertions(+), 3 deletions(-)

--- wireless-testing.orig/Documentation/kernel-doc-nano-HOWTO.txt	2010-08-18 14:54:25.000000000 +0200
+++ wireless-testing/Documentation/kernel-doc-nano-HOWTO.txt	2010-08-18 14:57:12.000000000 +0200
@@ -345,5 +345,10 @@ documentation, in <filename>, for the fu
 section titled <section title> from <filename>.
 Spaces are allowed in <section title>; do not quote the <section title>.
 
+!A<filename> is replaced by nothing, but makes the tools verify that
+all DOC: sections and documented functions, symbols, etc. are used.
+This makes sense to use when you use !F/!P only and want to verify
+that all documentation is included.
+
 Tim.
 */ <twaugh@redhat.com>
--- wireless-testing.orig/scripts/basic/docproc.c	2010-08-18 14:54:26.000000000 +0200
+++ wireless-testing/scripts/basic/docproc.c	2010-08-18 14:56:27.000000000 +0200
@@ -34,12 +34,14 @@
  *
  */
 
+#define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <ctype.h>
 #include <unistd.h>
 #include <limits.h>
+#include <errno.h>
 #include <sys/types.h>
 #include <sys/wait.h>
 
@@ -54,6 +56,7 @@ typedef void FILEONLY(char * file);
 FILEONLY *internalfunctions;
 FILEONLY *externalfunctions;
 FILEONLY *symbolsonly;
+FILEONLY *findall;
 
 typedef void FILELINE(char * file, char * line);
 FILELINE * singlefunctions;
@@ -65,12 +68,30 @@ FILELINE * docsection;
 #define KERNELDOCPATH "scripts/"
 #define KERNELDOC     "kernel-doc"
 #define DOCBOOK       "-docbook"
+#define LIST          "-list"
 #define FUNCTION      "-function"
 #define NOFUNCTION    "-nofunction"
 #define NODOCSECTIONS "-no-doc-sections"
 
 static char *srctree, *kernsrctree;
 
+static char **all_list = NULL;
+static int all_list_len = 0;
+
+static void consume_symbol(const char *sym)
+{
+	int i;
+
+	for (i = 0; i < all_list_len; i++) {
+		if (!all_list[i])
+			continue;
+		if (strcmp(sym, all_list[i]))
+			continue;
+		all_list[i] = NULL;
+		break;
+	}
+}
+
 static void usage (void)
 {
 	fprintf(stderr, "Usage: docproc {doc|depend} file\n");
@@ -248,6 +269,7 @@ static void docfunctions(char * filename
 		struct symfile * sym = &symfilelist[i];
 		for (j=0; j < sym->symbolcnt; j++) {
 			vec[idx++]     = type;
+			consume_symbol(sym->symbollist[j].name);
 			vec[idx++] = sym->symbollist[j].name;
 		}
 	}
@@ -287,6 +309,11 @@ static void singfunc(char * filename, ch
                         vec[idx++] = &line[i];
                 }
         }
+	for (i = 0; i < idx; i++) {
+        	if (strcmp(vec[i], FUNCTION))
+        		continue;
+		consume_symbol(vec[i + 1]);
+	}
 	vec[idx++] = filename;
 	vec[idx] = NULL;
 	exec_kernel_doc(vec);
@@ -306,6 +333,10 @@ static void docsect(char *filename, char
 		if (*s == '\n')
 			*s = '\0';
 
+	asprintf(&s, "DOC: %s", line);
+	consume_symbol(s);
+	free(s);
+
 	vec[0] = KERNELDOC;
 	vec[1] = DOCBOOK;
 	vec[2] = FUNCTION;
@@ -315,6 +346,85 @@ static void docsect(char *filename, char
 	exec_kernel_doc(vec);
 }
 
+static void find_all_symbols(char *filename)
+{
+	char *vec[4]; /* kerneldoc -docbook -function "section" file NULL */
+	pid_t pid;
+	int ret, i, count, start;
+	char real_filename[PATH_MAX + 1];
+	int pipefd[2];
+	char *data, *str;
+	size_t data_len = 0;
+
+	vec[0] = KERNELDOC;
+	vec[1] = LIST;
+	vec[2] = filename;
+	vec[3] = NULL;
+
+	if (pipe(pipefd)) {
+		perror("pipe");
+		exit(1);
+	}
+
+	switch (pid=fork()) {
+		case -1:
+			perror("fork");
+			exit(1);
+		case  0:
+			close(pipefd[0]);
+			dup2(pipefd[1], 1);
+			memset(real_filename, 0, sizeof(real_filename));
+			strncat(real_filename, kernsrctree, PATH_MAX);
+			strncat(real_filename, "/" KERNELDOCPATH KERNELDOC,
+					PATH_MAX - strlen(real_filename));
+			execvp(real_filename, vec);
+			fprintf(stderr, "exec ");
+			perror(real_filename);
+			exit(1);
+		default:
+			close(pipefd[1]);
+			data = malloc(4096);
+			do {
+				while ((ret = read(pipefd[0],
+						   data + data_len,
+						   4096)) > 0) {
+					data_len += ret;
+					data = realloc(data, data_len + 4096);
+				}
+			} while (ret == -EAGAIN);
+			if (ret != 0) {
+				perror("read");
+				exit(1);
+			}
+			waitpid(pid, &ret ,0);
+	}
+	if (WIFEXITED(ret))
+		exitstatus |= WEXITSTATUS(ret);
+	else
+		exitstatus = 0xff;
+
+	count = 0;
+	/* poor man's strtok, but with counting */
+	for (i = 0; i < data_len; i++) {
+		if (data[i] == '\n') {
+			count++;
+			data[i] = '\0';
+		}
+	}
+	fflush(stderr);
+	start = all_list_len;
+	all_list_len += count;
+	all_list = realloc(all_list, sizeof(char *) * all_list_len);
+	str = data;
+	for (i = 0; i < data_len && start != all_list_len; i++) {
+		if (data[i] == '\0') {
+			all_list[start] = str;
+			str = data + i + 1;
+			start++;
+		}
+	}
+}
+
 /*
  * Parse file, calling action specific functions for:
  * 1) Lines containing !E
@@ -322,7 +432,8 @@ static void docsect(char *filename, char
  * 3) Lines containing !D
  * 4) Lines containing !F
  * 5) Lines containing !P
- * 6) Default lines - lines not matching the above
+ * 6) Lines containing !A
+ * 7) Default lines - lines not matching the above
  */
 static void parse_file(FILE *infile)
 {
@@ -365,6 +476,12 @@ static void parse_file(FILE *infile)
 						s++;
 					docsection(line + 2, s);
 					break;
+				case 'A':
+					while (*s && !isspace(*s)) s++;
+					*s = '\0';
+					if (findall)
+						findall(line+2);
+					break;
 				default:
 					defaultline(line);
 			}
@@ -380,6 +497,7 @@ static void parse_file(FILE *infile)
 int main(int argc, char *argv[])
 {
 	FILE * infile;
+	int i;
 
 	srctree = getenv("SRCTREE");
 	if (!srctree)
@@ -415,6 +533,7 @@ int main(int argc, char *argv[])
 		symbolsonly       = find_export_symbols;
 		singlefunctions   = noaction2;
 		docsection        = noaction2;
+		findall           = find_all_symbols;
 		parse_file(infile);
 
 		/* Rewind to start from beginning of file again */
@@ -425,8 +544,16 @@ int main(int argc, char *argv[])
 		symbolsonly       = printline;
 		singlefunctions   = singfunc;
 		docsection        = docsect;
+		findall           = NULL;
 
 		parse_file(infile);
+
+		for (i = 0; i < all_list_len; i++) {
+			if (!all_list[i])
+				continue;
+			fprintf(stderr, "Warning: didn't use docs for %s\n",
+				all_list[i]);
+		}
 	}
 	else if (strcmp("depend", argv[1]) == 0)
 	{
@@ -439,6 +566,7 @@ int main(int argc, char *argv[])
 		symbolsonly       = adddep;
 		singlefunctions   = adddep2;
 		docsection        = adddep2;
+		findall           = adddep;
 		parse_file(infile);
 		printf("\n");
 	}
--- wireless-testing.orig/scripts/kernel-doc	2010-08-18 14:54:25.000000000 +0200
+++ wireless-testing/scripts/kernel-doc	2010-08-18 14:56:27.000000000 +0200
@@ -44,12 +44,13 @@ use strict;
 # Note: This only supports 'c'.
 
 # usage:
-# kernel-doc [ -docbook | -html | -text | -man ] [ -no-doc-sections ]
+# kernel-doc [ -docbook | -html | -text | -man | -list ] [ -no-doc-sections ]
 #           [ -function funcname [ -function funcname ...] ] c file(s)s > outputfile
 # or
 #           [ -nofunction funcname [ -function funcname ...] ] c file(s)s > outputfile
 #
 #  Set output format using one of -docbook -html -text or -man.  Default is man.
+#  The -list format is for internal use by docproc.
 #
 #  -no-doc-sections
 #	Do not output DOC: sections
@@ -210,9 +211,16 @@ my %highlights_text = ( $type_constant,
 			$type_param, "\$1" );
 my $blankline_text = "";
 
+# list mode
+my %highlights_list = ( $type_constant, "\$1",
+			$type_func, "\$1",
+			$type_struct, "\$1",
+			$type_param, "\$1" );
+my $blankline_list = "";
 
 sub usage {
-    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man ] [ -no-doc-sections ]\n";
+    print "Usage: $0 [ -v ] [ -docbook | -html | -text | -man | -list ]\n";
+    print "         [ -no-doc-sections ]\n";
     print "         [ -function funcname [ -function funcname ...] ]\n";
     print "         [ -nofunction funcname [ -nofunction funcname ...] ]\n";
     print "         c source file(s) > outputfile\n";
@@ -318,6 +326,10 @@ while ($ARGV[0] =~ m/^-(.*)/) {
 	$output_mode = "xml";
 	%highlights = %highlights_xml;
 	$blankline = $blankline_xml;
+    } elsif ($cmd eq "-list") {
+	$output_mode = "list";
+	%highlights = %highlights_list;
+	$blankline = $blankline_list;
     } elsif ($cmd eq "-gnome") {
 	$output_mode = "gnome";
 	%highlights = %highlights_gnome;
@@ -1361,6 +1373,42 @@ sub output_blockhead_text(%) {
     }
 }
 
+## list mode output functions
+
+sub output_function_list(%) {
+    my %args = %{$_[0]};
+
+    print $args{'function'} . "\n";
+}
+
+# output enum in list
+sub output_enum_list(%) {
+    my %args = %{$_[0]};
+    print $args{'enum'} . "\n";
+}
+
+# output typedef in list
+sub output_typedef_list(%) {
+    my %args = %{$_[0]};
+    print $args{'typedef'} . "\n";
+}
+
+# output struct as list
+sub output_struct_list(%) {
+    my %args = %{$_[0]};
+
+    print $args{'struct'} . "\n";
+}
+
+sub output_blockhead_list(%) {
+    my %args = %{$_[0]};
+    my ($parameter, $section);
+
+    foreach $section (@{$args{'sectionlist'}}) {
+	print "DOC: $section\n";
+    }
+}
+
 ##
 # generic output function for all types (function, struct/union, typedef, enum);
 # calls the generated, variable output_ function name based on


