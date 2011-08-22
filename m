Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253Ab1HVOXc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:23:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753233Ab1HVOXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:23:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf, tool, record: Fix the header generation for pipe
Date: Mon, 22 Aug 2011 16:23:17 +0200
Message-Id: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The generation of the perf data file fails when using pipe
as the output file descriptor.

When record command generates the data header, several files are put
inside and the file size is stored ahead of the file contents itself.

The problem is that debugfs files cannot be stat-ed for size so we
need to read the whole file, count the size and update the file size
via seek&write (pwrite call).
This cannot be done for pipes, since it's not allowed to seek on it.

The attached patch changes current behaviour for pipes to get the
file size first and write correct data within the first pass.
For other than pipe files, the current behaviour stands.

This issue was caught when running the script command:

	# perf script  syscall-counts ls

since it connects record and report via pipe.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/trace-event-info.c |   81 +++++++++++++++++++++++++++++++-----
 1 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 3403f81..62ab9a2 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -59,6 +59,7 @@ unsigned int page_size;
 
 static const char *output_file = "trace.info";
 static int output_fd;
+static int output_is_pipe;
 
 struct event_list {
 	struct event_list *next;
@@ -183,20 +184,59 @@ int bigendian(void)
 	return *ptr == 0x01020304;
 }
 
+static off_t get_file_size(int fd)
+{
+	off_t size = 0;
+	char buf[BUFSIZ];
+	int r;
+
+	do {
+		r = read(fd, buf, BUFSIZ);
+		if (r > 0)
+			size += r;
+	} while (r > 0);
+
+	if (lseek(fd, 0, SEEK_SET))
+		die("seek failed");
+
+	return size;
+}
+
 /* unfortunately, you can not stat debugfs or proc files for size */
 static void record_file(const char *file, size_t hdr_sz)
 {
 	unsigned long long size = 0;
-	char buf[BUFSIZ], *sizep;
-	off_t hdr_pos = lseek(output_fd, 0, SEEK_CUR);
+	char buf[BUFSIZ], *sizep = (char *) &size;
+	off_t hdr_pos = -1;
 	int r, fd;
 
 	fd = open(file, O_RDONLY);
 	if (fd < 0)
 		die("Can't read '%s'", file);
 
-	/* put in zeros for file size, then fill true size later */
-	write_or_die(&size, hdr_sz);
+	/*
+	 * If the output_fd is pipe, we need to write the size
+	 * right away, because we cannot seek on pipe later.
+	 *
+	 * In case of regular/seekable file, we can go throught
+	 * only once and use pwrite to update the header value
+	 * afterwards.
+	 *
+	 * And finally the size does not need to be written at all
+	 * if we are in the calc mode - calc_data_size.
+	 */
+	if (!calc_data_size) {
+		if (output_is_pipe) {
+			size = get_file_size(fd);
+
+			/* ugh, handle big-endian hdr_size == 4 */
+			if (bigendian())
+				sizep += sizeof(u64) - hdr_sz;
+		} else
+			hdr_pos = lseek(output_fd, 0, SEEK_CUR);
+	}
+
+	write_or_die(sizep, hdr_sz);
 
 	do {
 		r = read(fd, buf, BUFSIZ);
@@ -205,15 +245,21 @@ static void record_file(const char *file, size_t hdr_sz)
 			write_or_die(buf, r);
 		}
 	} while (r > 0);
-	close(fd);
 
-	/* ugh, handle big-endian hdr_size == 4 */
-	sizep = (char*)&size;
-	if (bigendian())
-		sizep += sizeof(u64) - hdr_sz;
+	if (!output_is_pipe && !calc_data_size) {
+
+		if (hdr_pos == -1)
+			die("BUG: hdr_pos not initialized");
+
+		/* ugh, handle big-endian hdr_size == 4 */
+		if (bigendian())
+			sizep += sizeof(u64) - hdr_sz;
+
+		if (pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
+			die("writing to %s", output_file);
+	}
 
-	if (pwrite(output_fd, sizep, hdr_sz, hdr_pos) < 0)
-		die("writing to %s", output_file);
+	close(fd);
 }
 
 static void read_header_files(void)
@@ -439,6 +485,18 @@ bool have_tracepoints(struct list_head *pattrs)
 	return false;
 }
 
+static int is_fd_pipe(int fd)
+{
+	struct stat s;
+	int ret;
+
+	ret = fstat(fd, &s);
+	if (ret)
+		die("stat failed");
+
+	return ((s.st_mode & S_IFMT) == S_IFIFO);
+}
+
 int read_tracing_data(int fd, struct list_head *pattrs)
 {
 	char buf[BUFSIZ];
@@ -451,6 +509,7 @@ int read_tracing_data(int fd, struct list_head *pattrs)
 		return -1;
 
 	output_fd = fd;
+	output_is_pipe = is_fd_pipe(fd);
 
 	buf[0] = 23;
 	buf[1] = 8;
-- 
1.7.4

