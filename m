Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab2AISio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 13:38:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab2AISin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 13:38:43 -0500
From: Stephen Warren <swarren@nvidia.com>
To: Michal Marek <mmarek@suse.cz>, Jon Loeliger <jdl@jdl.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc: Russell King <linux@arm.linux.org.uk>, Mark Salter <msalter@redhat.com>,
        Aurelien Jacquiot <a-jacquiot@ti.com>, Michal Simek <monstr@monstr.eu>,
        Jonas Bonn <jonas@southpole.se>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-c6x-dev@linux-c6x.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net,
        linuxppc-dev@lists.ozlabs.org,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: [PATCH 1/2] dtc: Implement -d option to write out a dependency file
Date: Mon,  9 Jan 2012 11:38:14 -0700
Message-Id: <1326134295-15547-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will allow callers to rebuild .dtb files when any of the /include/d
.dtsi files are modified, not just the top-level .dts file.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
This patch is against the Linux kernel's copy of dtc, but it applies to
upstream dtc with a couple of trivial conflicts. I can post a version for
upstream dtc as well if desired.

I have only tested this series for ARM.

 scripts/dtc/dtc.c    |   22 +++++++++++++++++++++-
 scripts/dtc/srcpos.c |    6 ++++++
 scripts/dtc/srcpos.h |    1 +
 3 files changed, 28 insertions(+), 1 deletions(-)

diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
index cbc0193..27ecf06 100644
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
@@ -188,6 +194,15 @@ int main(int argc, char *argv[])
 	fprintf(stderr, "DTC: %s->%s  on file \"%s\"\n",
 		inform, outform, arg);
 
+	if (depname) {
+		depfile = fopen(depname, "w");
+		if (!depfile)
+			die("Couldn't open dependency file %s: %s\n", depname,
+			    strerror(errno));
+		fputs(outname, depfile);
+		fputc(':', depfile);
+	}
+
 	if (streq(inform, "dts"))
 		bi = dt_from_source(arg);
 	else if (streq(inform, "fs"))
@@ -197,6 +212,11 @@ int main(int argc, char *argv[])
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
index 2dbc874..93b3533 100644
--- a/scripts/dtc/srcpos.c
+++ b/scripts/dtc/srcpos.c
@@ -40,6 +40,7 @@ static char *dirname(const char *path)
 	return NULL;
 }
 
+FILE *depfile; /* = NULL */
 struct srcfile_state *current_srcfile; /* = NULL */
 
 /* Detect infinite include recursion. */
@@ -67,6 +68,11 @@ FILE *srcfile_relative_open(const char *fname, char **fullnamep)
 			    strerror(errno));
 	}
 
+	if (depfile) {
+		fputc(' ', depfile);
+		fputs(fullname, depfile);
+	}
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

