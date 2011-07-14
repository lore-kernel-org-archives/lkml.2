Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1GNDeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 23:34:46 -0400
Received: from ozlabs.org ([203.10.76.45]:56317 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab1GNDep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 23:34:45 -0400
From: Michael Neuling <mikey@neuling.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Sonny Rao <sonnyrao@chromium.org>, acme@redhat.com, anton@samba.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [RFCv3] perf: robustify proc and debugfs file recording
In-reply-to: <1310612277.27864.5.camel@gandalf.stny.rr.com>
References: <28585.1310602685@neuling.org> <1310604019-10935-1-git-send-email-sonnyrao@chromium.org> <1310612277.27864.5.camel@gandalf.stny.rr.com>
Comments: In-reply-to Steven Rostedt <rostedt@goodmis.org>
   message dated "Wed, 13 Jul 2011 22:57:57 -0400."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Jul 2011 13:34:43 +1000
Message-ID: <10011.1310614483@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1310612277.27864.5.camel@gandalf.stny.rr.com> you wrote:
> On Wed, 2011-07-13 at 17:40 -0700, Sonny Rao wrote:
> > While attempting to create a timechart of boot up I found
> > perf didn't tolerate modules being loaded/unloaded.  This patch
> > fixes this by reading the file once and then writing the size
> > read at the correct point in the file.  It also simplifies the
> > code somewhat.
> > 
> 
> I get this:
> 
> cc1: warnings being treated as errors
> util/trace-event-info.c: In function ‘read_header_files’:
> util/trace-event-info.c:221: error: unused variable ‘size’
> util/trace-event-info.c: In function ‘copy_event_system’:
> util/trace-event-info.c:255: error: unused variable ‘size’
> make: *** [/tmp/build/util/trace-event-info.o] Error 1

Looks like sonny didn't pick up my changes correctly.  Here's the
working I tested with the sizep and warnings cleanups.

Mikey



From: Sonny Rao <sonnyrao@chromium.org>

[RFCv3] perf: robustify proc and debugfs file recording

While attempting to create a timechart of boot up I found perf didn't
tolerate modules being loaded/unloaded.  This patch fixes this by
reading the file once and then writing the size read at the correct
point in the file.  It also simplifies the code somewhat.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 tools/perf/util/trace-event-info.c |  120 ++++++++-----------------------------
 1 file changed, 29 insertions(+), 91 deletions(-)

Index: linux-ozlabs/tools/perf/util/trace-event-info.c
===================================================================
--- linux-ozlabs.orig/tools/perf/util/trace-event-info.c	2011-07-13 20:42:24.442945973 +1000
+++ linux-ozlabs/tools/perf/util/trace-event-info.c	2011-07-14 10:14:19.072946058 +1000
@@ -183,106 +183,59 @@
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
@@ -298,7 +251,6 @@
 
 static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
-	unsigned long long size, check_size;
 	struct dirent *dent;
 	struct stat st;
 	char *format;
@@ -338,14 +290,8 @@
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
@@ -426,7 +372,7 @@
 
 static void read_proc_kallsyms(void)
 {
-	unsigned int size, check_size;
+	unsigned int size;
 	const char *path = "/proc/kallsyms";
 	struct stat st;
 	int ret;
@@ -438,17 +384,12 @@
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
@@ -461,11 +402,8 @@
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
