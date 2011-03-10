Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1CJJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 04:56:25 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:56918 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1CJJ4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 04:56:23 -0500
Message-ID: <4D78A0A6.2060009@cn.fujitsu.com>
Date: Thu, 10 Mar 2011 17:57:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] trace-cmd: correct cpu list parsing
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-10 17:55:08,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-10 17:55:08,
	Serialize complete at 2011-03-10 17:55:08
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old parsing code is incorrect, when we use execute
./trace-cmd report --cpu 1,2-4,6,9-13

the result of filter_cpus will be:
1,2,1,2,3,4,6,9,5,6,7,8,9,10,11,12,13

The correct filter_cpus should be:
1,2,3,4,6,9,10,11,12,13,

I can change about 10 existed lines to make it correct, but it will be
still bad readability, so I port the neat and good readability code:
linux_kernel_src/lib/bitmap.c:bitmap_parselist()
to here and replace the origin code

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 trace-read.c |   76 ++++++++++++++-------------------------------------------
 1 files changed, 19 insertions(+), 57 deletions(-)

diff --git a/trace-read.c b/trace-read.c
index 1cd9bd3..932f5aa 100644
--- a/trace-read.c
+++ b/trace-read.c
@@ -738,9 +738,8 @@ static void sig_end(int sig)
 	exit(0);
 }
 
-static const char *inc_and_test_char(const char *p, const char *cpu_str)
+static const char *skip_space_and_test_digit(const char *p, const char *cpu_str)
 {
-	p++;
 	while (isspace(*p))
 		p++;
 	if (!isdigit(*p))
@@ -754,64 +753,27 @@ static void __add_cpu(int cpu)
 	filter_cpus = tracecmd_add_id(filter_cpus, cpu, nr_filter_cpus++);
 }
 
-static int process_cpu_str(const char *cpu_str)
+static void parse_cpulist(const char *cpu_str)
 {
-	const char *p = cpu_str;
-	int cpu, ncpu, ret_cpu = 1;
+	unsigned a, b;
+	const char *s = cpu_str;
 
 	do {
-		while (isspace(*p))
-			p++;
-
-		cpu = atoi(p);
-		__add_cpu(cpu);
-
- again:
-		while (isdigit(*p))
-			p++;
-		while (isspace(*p))
-			p++;
-
-		if (*p) {
-			ret_cpu = 0;
-			switch (*p) {
-			case '-':
-				p = inc_and_test_char(p, cpu_str);
-				ncpu = atoi(p);
-				if (ncpu < cpu)
-					die("range of cpu numbers must be lower to greater");
-				for (; cpu <= ncpu; cpu++)
-					__add_cpu(cpu);
-				break;
-
-			case ',':
-			case ':':
-				p = inc_and_test_char(p, cpu_str);
-				ncpu = atoi(p);
-				__add_cpu(ncpu);
-				break;
-			default:
-				die("invalid character '%c' in cpu string '%s'",
-				    *p, cpu_str);
-			}
-			goto again;
+		s = skip_space_and_test_digit(s, cpu_str);
+		b = a = strtoul(s, (char **)&s, 10);
+		if (*s == '-') {
+			s = skip_space_and_test_digit(s + 1, cpu_str);
+			b = strtoul(s, (char **)&s, 10);
 		}
-	} while (*p);
-
-	if (ret_cpu)
-		return cpu;
-
-	/* Return -1 if we added more than one CPU */
-	return -1;
-}
-
-static void add_cpu(const char *cpu_str)
-{
-	int cpu;
-
-	cpu = process_cpu_str(cpu_str);
-	if (cpu >= 0)
-		__add_cpu(cpu);
+		if (!(a <= b))
+			die("range of cpu numbers must be lower to greater");
+		while (a <= b) {
+			__add_cpu(a);
+			a++;
+		}
+		if (*s == ',' || *s == ':')
+			s++;
+	} while (*s != '\0');
 }
 
 static void read_file_fd(int fd, char *dst, int len)
@@ -958,7 +920,7 @@ void trace_report (int argc, char **argv)
 		case 0:
 			switch(option_index) {
 			case 0: /* cpu */
-				add_cpu(optarg);
+				parse_cpulist(optarg);
 				break;
 			case 1: /* events */
 				print_events = 1;
-- 
1.7.4
