Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab0HEEom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 00:44:42 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:56536 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0HEEoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 00:44:39 -0400
Date: Thu, 05 Aug 2010 00:44:36 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH msr-tools] rdmsr, wrmsr: add '-a' parameter to operate on all
 processors
Message-id: <alpine.LFD.2.00.1008050042530.3178@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Now that even a laptop has multiple processors...
it is handy to have the option to simultaneously
read or write an MSR on all the processors
in the system.

We get the list of on-line processors from /proc/stat

Signed-off-by: Len Brown <len.brown@intel.com>
---
 rdmsr.c |   70 ++++++++++++++++++++++++++++++++++------
 wrmsr.c |  111 +++++++++++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 137 insertions(+), 44 deletions(-)

diff --git a/rdmsr.c b/rdmsr.c
index 5f173d7..f4be761 100644
--- a/rdmsr.c
+++ b/rdmsr.c
@@ -41,12 +41,15 @@ static const struct option long_options[] = {
 	{"zero-fill",		0, 0, '0'},
 	{"zero-pad",		0, 0, '0'},
 	{"raw",			0, 0, 'r'},
+	{"all",			0, 0, 'a'},
 	{"processor",		1, 0, 'p'},
 	{"cpu",			1, 0, 'p'},
 	{"bitfield",		1, 0, 'f'},
 	{0, 0, 0, 0}
 };
-static const char short_options[] = "hVxXdoruc0p:f:";
+static const char short_options[] = "hVxXdoruc0ap:f:";
+
+static const char *proc_stat = "/proc/stat";
 
 /* Number of decimal digits for a certain number of bits */
 /* (int) ceil(log(2^n)/log(10)) */
@@ -84,23 +87,53 @@ void usage(void)
 		"  --c-language   -c  Format output as a C language constant\n"
 		"  --zero-pad     -0  Output leading zeroes\n"
 		"  --raw          -r  Raw binary output\n"
+		"  --all	  -a  all processors\n"
 		"  --processor #  -p  Select processor number (default 0)\n"
 		"  --bitfield h:l -f  Output bits [h:l] only\n", program);
 }
 
+void rdmsr_on_cpu(uint32_t reg, int cpu);
+
+void rdmsr_on_all_cpus(uint32_t reg)
+{
+	FILE *fp;
+	int retval;
+
+	fp = fopen(proc_stat, "r");
+	if (fp == NULL) {
+		perror(proc_stat);
+		exit(-1);
+	}
+
+	retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
+	if (retval != 0) {
+		perror("/proc/stat format");
+		exit(-1);
+	}
+
+	for (;;) {
+		int cpu;
+
+		retval = fscanf(fp, "cpu%u %*d %*d %*d %*d %*d %*d %*d %*d %*d"
+			" %*d\n", &cpu);
+		if (retval != 1)
+			return;
+
+		rdmsr_on_cpu(reg, cpu);
+	}
+	fclose(fp);
+}
+
+unsigned int highbit = 63, lowbit = 0, bits;
+int mode = mo_hex;
+
 int main(int argc, char *argv[])
 {
 	uint32_t reg;
-	uint64_t data;
-	int c, fd;
-	int mode = mo_hex;
+	int c;
 	int cpu = 0;
-	unsigned int highbit = 63, lowbit = 0, bits;
 	unsigned long arg;
 	char *endarg;
-	char *pat;
-	int width;
-	char msr_file_name[64];
 
 	program = argv[0];
 
@@ -139,6 +172,9 @@ int main(int argc, char *argv[])
 		case '0':
 			mode |= mo_fill;
 			break;
+		case 'a':
+			cpu = -1;
+			break;
 		case 'p':
 			arg = strtoul(optarg, &endarg, 0);
 			if (*endarg || arg > 255) {
@@ -168,6 +204,21 @@ int main(int argc, char *argv[])
 
 	reg = strtoul(argv[optind], NULL, 0);
 
+	if (cpu == -1)
+		rdmsr_on_all_cpus(reg);
+	else
+		rdmsr_on_cpu(reg, cpu);
+	exit(0);
+}
+void rdmsr_on_cpu(uint32_t reg, int cpu)
+{
+	uint64_t data;
+	int fd;
+	int mode = mo_hex;
+	char *pat;
+	int width;
+	char msr_file_name[64];
+
 	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
 	fd = open(msr_file_name, O_RDONLY);
 	if (fd < 0) {
@@ -308,6 +359,5 @@ int main(int argc, char *argv[])
 
 	if (pat)
 		printf(pat, width, data);
-
-	exit(0);
+	return;
 }
diff --git a/wrmsr.c b/wrmsr.c
index ab87921..a1a5eb6 100644
--- a/wrmsr.c
+++ b/wrmsr.c
@@ -31,12 +31,14 @@
 static const struct option long_options[] = {
 	{"help",	0, 0, 'h'},
 	{"version",	0, 0, 'V'},
+	{"all",		0, 0, 'a'},
 	{"processor",	1, 0, 'p'},
 	{"cpu",		1, 0, 'p'},
 	{0, 0, 0, 0}
 };
-static const char short_options[] = "hVp:";
+static const char short_options[] = "hVap:";
 
+static const char *proc_stat = "/proc/stat";
 const char *program;
 
 void usage(void)
@@ -44,20 +46,85 @@ void usage(void)
 	fprintf(stderr, "Usage: %s [options] regno value...\n"
 		"  --help         -h  Print this help\n"
 		"  --version      -V  Print current version\n"
+		"  --all          -a  all processors\n"
 		"  --processor #  -p  Select processor number (default 0)\n",
 		program);
 }
 
+void wrmsr_on_cpu(uint32_t reg, uint64_t data, int cpu)
+{
+	int fd;
+	char msr_file_name[64];
+
+	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
+	fd = open(msr_file_name, O_WRONLY);
+	if (fd < 0) {
+		if (errno == ENXIO) {
+			fprintf(stderr, "wrmsr: No CPU %d\n", cpu);
+			exit(2);
+		} else if (errno == EIO) {
+			fprintf(stderr, "wrmsr: CPU %d doesn't support MSRs\n",
+				cpu);
+			exit(3);
+		} else {
+			perror("wrmsr: open");
+			exit(127);
+		}
+	}
+	if (pwrite(fd, &data, sizeof data, reg) != sizeof data) {
+		if (errno == EIO) {
+			fprintf(stderr,
+				"wrmsr: CPU %d cannot set MSR "
+				"0x%08"PRIx32" to 0x%016"PRIx64"\n",
+				cpu, reg, data);
+			exit(4);
+		} else {
+			perror("wrmsr: pwrite");
+			exit(127);
+		}
+	}
+	close(fd);
+}
+
+
+void wrmsr_on_all_cpus(uint32_t reg, uint64_t data)
+{
+	FILE *fp;
+	int retval;
+
+	fp = fopen(proc_stat, "r");
+	if (fp == NULL) {
+		perror(proc_stat);
+		exit(-1);
+	}
+
+	retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
+	if (retval != 0) {
+		perror("/proc/stat format");
+		exit(-1);
+	}
+
+	for (;;) {
+		int cpu;
+
+		retval = fscanf(fp, "cpu%u %*d %*d %*d %*d %*d %*d %*d %*d "
+			"%*d %*d\n", &cpu);
+		if (retval != 1)
+			return;
+
+		wrmsr_on_cpu(reg, data, cpu);
+	}
+	fclose(fp);
+}
+
 int main(int argc, char *argv[])
 {
 	uint32_t reg;
 	uint64_t data;
-	int fd;
 	int c;
 	int cpu = 0;
 	unsigned long arg;
 	char *endarg;
-	char msr_file_name[64];
 
 	program = argv[0];
 
@@ -71,6 +138,9 @@ int main(int argc, char *argv[])
 			fprintf(stderr, "%s: version %s\n", program,
 				VERSION_STRING);
 			exit(0);
+		case 'a':
+			cpu = -1;
+			break;
 		case 'p':
 			arg = strtoul(optarg, &endarg, 0);
 			if (*endarg || arg > 255) {
@@ -93,39 +163,12 @@ int main(int argc, char *argv[])
 
 	reg = strtoul(argv[optind++], NULL, 0);
 
-	sprintf(msr_file_name, "/dev/cpu/%d/msr", cpu);
-	fd = open(msr_file_name, O_WRONLY);
-	if (fd < 0) {
-		if (errno == ENXIO) {
-			fprintf(stderr, "wrmsr: No CPU %d\n", cpu);
-			exit(2);
-		} else if (errno == EIO) {
-			fprintf(stderr, "wrmsr: CPU %d doesn't support MSRs\n",
-				cpu);
-			exit(3);
-		} else {
-			perror("wrmsr: open");
-			exit(127);
-		}
-	}
-
 	while (optind < argc) {
 		data = strtoull(argv[optind++], NULL, 0);
-		if (pwrite(fd, &data, sizeof data, reg) != sizeof data) {
-			if (errno == EIO) {
-				fprintf(stderr,
-					"wrmsr: CPU %d cannot set MSR "
-					"0x%08"PRIx32" to 0x%016"PRIx64"\n",
-					cpu, reg, data);
-				exit(4);
-			} else {
-				perror("wrmsr: pwrite");
-				exit(127);
-			}
-		}
+		if (cpu == -1)
+			wrmsr_on_all_cpus(reg, data);
+		else
+			wrmsr_on_cpu(reg, data, cpu);
 	}
-
-	close(fd);
-
 	exit(0);
 }
-- 
1.7.2.1.6.g61bf12

