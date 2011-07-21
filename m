Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1GUKAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 06:00:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:57222 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab1GUKAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 06:00:39 -0400
Date: Thu, 21 Jul 2011 09:59:52 GMT
From: tip-bot for Sonny Rao <sonnyrao@chromium.org>
Message-ID: <tip-259032bfe379281bf7cba512b7705bdb4ce41db5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        rostedt@goodmis.org, tglx@linutronix.de, sonnyrao@chromium.org,
        mingo@elte.hu, mikey@neuling.org
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        acme@ghostprotocols.net, rostedt@goodmis.org, tglx@linutronix.de,
        sonnyrao@chromium.org, mingo@elte.hu, mikey@neuling.org
In-Reply-To: <10011.1310614483@neuling.org>
References: <10011.1310614483@neuling.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Robustify proc and debugfs file recording
Git-Commit-ID: 259032bfe379281bf7cba512b7705bdb4ce41db5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 21 Jul 2011 09:59:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  259032bfe379281bf7cba512b7705bdb4ce41db5
Gitweb:     http://git.kernel.org/tip/259032bfe379281bf7cba512b7705bdb4ce41db5
Author:     Sonny Rao <sonnyrao@chromium.org>
AuthorDate: Thu, 14 Jul 2011 13:34:43 +1000
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Thu, 14 Jul 2011 15:53:01 -0400

perf: Robustify proc and debugfs file recording

While attempting to create a timechart of boot up I found perf didn't
tolerate modules being loaded/unloaded.  This patch fixes this by
reading the file once and then writing the size read at the correct
point in the file.  It also simplifies the code somewhat.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Link: http://lkml.kernel.org/r/10011.1310614483@neuling.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/trace-event-info.c |  120 +++++++++---------------------------
 1 files changed, 29 insertions(+), 91 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 35729f4..3403f81 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -183,106 +183,59 @@ int bigendian(void)
 	return *ptr == 0x01020304;
 }
 
-static unsigned long long copy_file_fd(int fd)
+/* unfortunately, you can not stat debugfs or proc files for size */
+static void record_file(const char *file, size_t hdr_sz)
 {
 	unsigned long long size = 0;
-	char buf[BUFSIZ];
-	int r;
-
-	do {
-		r = read(fd, buf, BUFSIZ);
-		if (r > 0) {
-			size += r;
-			write_or_die(buf, r);
-		}
-	} while (r > 0);
-
-	return size;
-}
-
-static unsigned long long copy_file(const char *file)
-{
-	unsigned long long size = 0;
-	int fd;
+	char buf[BUFSIZ], *sizep;
+	off_t hdr_pos = lseek(output_fd, 0, SEEK_CUR);
+	int r, fd;
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
 		die("Can't read '%s'", file);
-	size = copy_file_fd(fd);
-	close(fd);
 
-	return size;
-}
-
-static unsigned long get_size_fd(int fd)
-{
-	unsigned long long size = 0;
-	char buf[BUFSIZ];
-	int r;
+	/* put in zeros for file size, then fill true size later */
+	write_or_die(&size, hdr_sz);
 
 	do {
 		r = read(fd, buf, BUFSIZ);
-		if (r > 0)
+		if (r > 0) {
 			size += r;
+			write_or_die(buf, r);
+		}
 	} while (r > 0);
-
-	lseek(fd, 0, SEEK_SET);
-
-	return size;
-}
-
-static unsigned long get_size(const char *file)
-{
-	unsigned long long size = 0;
-	int fd;
-
-	fd = open(file, O_RDONLY);
-	if (fd < 0)
-		die("Can't read '%s'", file);
-	size = get_size_fd(fd);
 	close(fd);
 
-	return size;
+	/* ugh, handle big-endian hdr_size == 4 */
+	sizep = (char*)&size;
+	if (bigendian())
+		sizep += sizeof(u64) - hdr_sz;
+
+	if (pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
+		die("writing to %s", output_file);
 }
 
 static void read_header_files(void)
 {
-	unsigned long long size, check_size;
 	char *path;
-	int fd;
+	struct stat st;
 
 	path = get_tracing_file("events/header_page");
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
+	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
-	/* unfortunately, you can not stat debugfs files for size */
-	size = get_size_fd(fd);
-
 	write_or_die("header_page", 12);
-	write_or_die(&size, 8);
-	check_size = copy_file_fd(fd);
-	close(fd);
-
-	if (size != check_size)
-		die("wrong size for '%s' size=%lld read=%lld",
-		    path, size, check_size);
+	record_file(path, 8);
 	put_tracing_file(path);
 
 	path = get_tracing_file("events/header_event");
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
+	if (stat(path, &st) < 0)
 		die("can't read '%s'", path);
 
-	size = get_size_fd(fd);
-
 	write_or_die("header_event", 13);
-	write_or_die(&size, 8);
-	check_size = copy_file_fd(fd);
-	if (size != check_size)
-		die("wrong size for '%s'", path);
+	record_file(path, 8);
 	put_tracing_file(path);
-	close(fd);
 }
 
 static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
@@ -298,7 +251,6 @@ static bool name_in_tp_list(char *sys, struct tracepoint_path *tps)
 
 static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
-	unsigned long long size, check_size;
 	struct dirent *dent;
 	struct stat st;
 	char *format;
@@ -338,14 +290,8 @@ static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 		sprintf(format, "%s/%s/format", sys, dent->d_name);
 		ret = stat(format, &st);
 
-		if (ret >= 0) {
-			/* unfortunately, you can not stat debugfs files for size */
-			size = get_size(format);
-			write_or_die(&size, 8);
-			check_size = copy_file(format);
-			if (size != check_size)
-				die("error in size of file '%s'", format);
-		}
+		if (ret >= 0)
+			record_file(format, 8);
 
 		free(format);
 	}
@@ -426,7 +372,7 @@ static void read_event_files(struct tracepoint_path *tps)
 
 static void read_proc_kallsyms(void)
 {
-	unsigned int size, check_size;
+	unsigned int size;
 	const char *path = "/proc/kallsyms";
 	struct stat st;
 	int ret;
@@ -438,17 +384,12 @@ static void read_proc_kallsyms(void)
 		write_or_die(&size, 4);
 		return;
 	}
-	size = get_size(path);
-	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
-
+	record_file(path, 4);
 }
 
 static void read_ftrace_printk(void)
 {
-	unsigned int size, check_size;
+	unsigned int size;
 	char *path;
 	struct stat st;
 	int ret;
@@ -461,11 +402,8 @@ static void read_ftrace_printk(void)
 		write_or_die(&size, 4);
 		goto out;
 	}
-	size = get_size(path);
-	write_or_die(&size, 4);
-	check_size = copy_file(path);
-	if (size != check_size)
-		die("error in size of file '%s'", path);
+	record_file(path, 4);
+
 out:
 	put_tracing_file(path);
 }
