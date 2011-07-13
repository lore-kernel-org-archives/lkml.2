Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965316Ab1GMKww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 06:52:52 -0400
Received: from ozlabs.org ([203.10.76.45]:53686 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965255Ab1GMKwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 06:52:51 -0400
From: Michael Neuling <mikey@neuling.org>
To: Sonny Rao <sonnyrao@chromium.org>
cc: acme@redhat.com, anton@samba.org, rostedt@goodmis.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] perf: robustify proc and debugfs file recording
In-reply-to: <29926.1310553581@neuling.org>
References: <1310505348-20163-1-git-send-email-sonnyrao@chromium.org> <29926.1310553581@neuling.org>
Comments: In-reply-to Michael Neuling <mikey@neuling.org>
   message dated "Wed, 13 Jul 2011 20:39:41 +1000."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.2.1
Date: Wed, 13 Jul 2011 20:52:49 +1000
Message-ID: <30671.1310554369@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <29926.1310553581@neuling.org> you wrote:
> Sonny,
> 
> 
> > While attempting to create a timechart of boot up I found
> > perf didn't tolerate modules being loaded/unloaded.  This patch
> > fixes this by reading the file once and then writing the size
> > read at the correct point in the file.  It also simplifies the
> > code somewhat.
> 
> I'm getting a bunch of unused variables warnings when I compile this.
> Care to clean them up?
> 
>     CC util/trace-event-info.o
> util/trace-event-info.c: In function =E2=80=98read_header_files=E2=80=99:
> util/trace-event-info.c:221:27: error: unused variable =E2=80=98check_size=
> =E2=80=99 [-Werror=3Dunused-variable]
> util/trace-event-info.c:221:21: error: unused variable =E2=80=98size=E2=80=
> =99 [-Werror=3Dunused-variable]
> util/trace-event-info.c: In function =E2=80=98copy_event_system=E2=80=99:
> util/trace-event-info.c:255:27: error: unused variable =E2=80=98check_size=
> =E2=80=99 [-Werror=3Dunused-variable]
> util/trace-event-info.c:255:21: error: unused variable =E2=80=98size=E2=80=
> =99 [-Werror=3Dunused-variable]
> util/trace-event-info.c: In function =E2=80=98read_proc_kallsyms=E2=80=99:
> util/trace-event-info.c:377:21: error: unused variable =E2=80=98check_size=
> =E2=80=99 [-Werror=3Dunused-variable]
> util/trace-event-info.c: In function =E2=80=98read_ftrace_printk=E2=80=99:
> util/trace-event-info.c:394:21: error: unused variable =E2=80=98check_size=
> =E2=80=99 [-Werror=3Dunused-variable]
> cc1: all warnings being treated as errors

Actually, here's an updated patch to fix these..

FYI perf record/annotate/report works fine on my powerpc box here with
this.  I don't have modules handy so I've not tested that aspect.

Mikey



From: Sonny Rao <sonnyrao@chromium.org>

While attempting to create a timechart of boot up I found
perf didn't tolerate modules being loaded/unloaded.  This patch
fixes this by reading the file once and then writing the size
read at the correct point in the file.  It also simplifies the
code somewhat.

Signed-off-by: Sonny Rao <sonnyrao@chromium.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 tools/perf/util/trace-event-info.c |  120 ++++++++-----------------------------
 1 file changed, 29 insertions(+), 91 deletions(-)

Index: linux-ozlabs/tools/perf/util/trace-event-info.c
===================================================================
--- linux-ozlabs.orig/tools/perf/util/trace-event-info.c
+++ linux-ozlabs/tools/perf/util/trace-event-info.c
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
+	if (pwrite(output_fd, &size, hdr_sz, hdr_pos) < 0)
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
@@ -298,7 +251,6 @@ static bool name_in_tp_list(char *sys, s
 
 static void copy_event_system(const char *sys, struct tracepoint_path *tps)
 {
-	unsigned long long size, check_size;
 	struct dirent *dent;
 	struct stat st;
 	char *format;
@@ -338,14 +290,8 @@ static void copy_event_system(const char
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
@@ -426,7 +372,7 @@ static void read_event_files(struct trac
 
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
