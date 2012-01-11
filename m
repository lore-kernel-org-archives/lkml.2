Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2AKA2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 19:28:05 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50596 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757098Ab2AKA2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 19:28:02 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Jon Loeliger <jdl@jdl.com>, David Gibson <david@gibson.dropbear.id.au>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH V2] dtc: Implement -d option to write out a dependency file
Date: Tue, 10 Jan 2012 17:27:52 -0700
Message-Id: <1326241672-9168-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow callers to rebuild .dtb files when any of the /include/d
.dtsi files are modified, not just the top-level .dts file.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
Michal, this patch is a dependency for the kbuild changes that use it;
http://www.spinics.net/lists/linux-kbuild/msg05883.html
I think it makes sense to apply both this patch, and that patch, to the
kbuild tree. Do you agree?

v2: Replace fputs/fputc with fprintf

This patch has been blessed for application to upstream dtc. Here, I'm
simply applying the same thing to the code in the Linux kernel tree,
resolving some conflicts. See:
http://lists.ozlabs.org/pipermail/devicetree-discuss/2012-January/011172.html

 scripts/dtc/dtc.c    |   21 ++++++++++++++++++++-
 scripts/dtc/srcpos.c |    4 ++++
 scripts/dtc/srcpos.h |    1 +
 3 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index cbc0193..451c92d 100644
--- a/scripts/dtc/dtc.c
+++ b/scripts/dtc/dtc.c
@@ -71,6 +71,7 @@ static void  __attribute__ ((noreturn)) usage(void)
 	fprintf(stderr, "\t\t\tasm - assembler source\n");
 	fprintf(stderr, "\t-V <output version>\n");
 	fprintf(stderr, "\t\tBlob version to produce, defaults to %d (relevant for dtb\n\t\tand asm output only)\n", DEFAULT_FDT_VERSION);
+	fprintf(stderr, "\t-d <output dependency file>\n");
 	fprintf(stderr, "\t-R <number>\n");
 	fprintf(stderr, "\t\tMake space for <number> reserve map entries (relevant for \n\t\tdtb and asm output only)\n");
 	fprintf(stderr, "\t-S <bytes>\n");
@@ -99,6 +100,7 @@ int main(int argc, char *argv[])
 	const char *inform = "dts";
 	const char *outform = "dts";
 	const char *outname = "-";
+	const char *depname = NULL;
 	int force = 0, check = 0, sort = 0;
 	const char *arg;
 	int opt;
@@ -111,7 +113,8 @@ int main(int argc, char *argv[])
 	minsize    = 0;
 	padsize    = 0;
 
-	while ((opt = getopt(argc, argv, "hI:O:o:V:R:S:p:fcqb:vH:s")) != EOF) {
+	while ((opt = getopt(argc, argv, "hI:O:o:V:d:R:S:p:fcqb:vH:s"))
+			!= EOF) {
 		switch (opt) {
 		case 'I':
 			inform = optarg;
@@ -125,6 +128,9 @@ int main(int argc, char *argv[])
 		case 'V':
 			outversion = strtol(optarg, NULL, 0);
 			break;
+		case 'd':
+			depname = optarg;
+			break;
 		case 'R':
 			reservenum = strtol(optarg, NULL, 0);
 			break;
@@ -188,6 +194,14 @@ int main(int argc, char *argv[])
 	fprintf(stderr, "DTC: %s->%s  on file \"%s\"\n",
 		inform, outform, arg);
 
+	if (depname) {
+		depfile = fopen(depname, "w");
+		if (!depfile)
+			die("Couldn't open dependency file %s: %s\n", depname,
+			    strerror(errno));
+		fprintf(depfile, "%s:", outname);
+	}
+
 	if (streq(inform, "dts"))
 		bi = dt_from_source(arg);
 	else if (streq(inform, "fs"))
@@ -197,6 +211,11 @@ int main(int argc, char *argv[])
 	else
 		die("Unknown input format \"%s\"\n", inform);
 
+	if (depfile) {
+		fputc('\n', depfile);
+		fclose(depfile);
+	}
+
 	if (cmdline_boot_cpuid != -1)
 		bi->boot_cpuid_phys = cmdline_boot_cpuid;
 
diff --git a/scripts/dtc/srcpos.c b/scripts/dtc/srcpos.c
index 2dbc874..36a38e9 100644
--- a/scripts/dtc/srcpos.c
+++ b/scripts/dtc/srcpos.c
@@ -40,6 +40,7 @@ static char *dirname(const char *path)
 	return NULL;
 }
 
+FILE *depfile; /* = NULL */
 struct srcfile_state *current_srcfile; /* = NULL */
 
 /* Detect infinite include recursion. */
@@ -67,6 +68,9 @@ FILE *srcfile_relative_open(const char *fname, char **fullnamep)
 			    strerror(errno));
 	}
 
+	if (depfile)
+		fprintf(depfile, " %s", fullname);
+
 	if (fullnamep)
 		*fullnamep = fullname;
 	else
diff --git a/scripts/dtc/srcpos.h b/scripts/dtc/srcpos.h
index bd7966e..ce980ca 100644
--- a/scripts/dtc/srcpos.h
+++ b/scripts/dtc/srcpos.h
@@ -30,6 +30,7 @@ struct srcfile_state {
 	struct srcfile_state *prev;
 };
 
+extern FILE *depfile; /* = NULL */
 extern struct srcfile_state *current_srcfile; /* = NULL */
 
 FILE *srcfile_relative_open(const char *fname, char **fullnamep);
-- 
1.7.0.4

