Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210Ab1JESZI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 14:25:08 -0400
Received: from smtp-out.google.com ([74.125.121.67]:50201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab1JESZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 14:25:07 -0400
Date: Wed, 5 Oct 2011 14:25:03 -0400
From: Thomas Tuttle <ttuttle@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Marco Stornelli <marco.stornelli@gmail.com>
Subject: [PATCH] ramoops: scripts/ramoops.c for extracting oopses
Message-ID: <20111005182503.GA6142@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a C program to extract oopses stored by ramoops.  Running with no
arguments will list all of the records; running with an argument number
will retrieve the oops from that record, if it is valid.

(In the long term, it'd be ideal to have some kernel interface to
ramoops records, but this script may be useful in the short term.)

BUG=chromium-os:21113
TEST=Adhoc, seems to work :)

Change-Id: I24edf4d09c96a5d89bb75859a83d5427502d4eb6
Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
---
 scripts/ramoops.c |  175 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 175 insertions(+), 0 deletions(-)
 create mode 100644 scripts/ramoops.c

diff --git a/scripts/ramoops.c b/scripts/ramoops.c
new file mode 100644
index 0000000..25cc7c5
--- /dev/null
+++ b/scripts/ramoops.c
@@ -0,0 +1,175 @@
+/*
+ * ramoops: Extract ramoops images from /dev/mem.
+ *
+ * Copyright (C) 2011 Thomas Tuttle <ttuttle@google.com>
+ *
+ * This file is subject to the terms and conditions of the GNU General Public
+ * License. See the file COPYING in the main directory of the Linux
+ * distribution for more details.
+ */
+
+#include <errno.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+static char *progn;
+
+static void read_long(char *name, unsigned long *out)
+{
+	FILE *f = fopen(name, "r");
+	if (!f) {
+		fprintf(stderr, "%s: %s: %s\n",
+			progn, name, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	if (fscanf(f, "%lu", out) < 1) {
+		fprintf(stderr, "%s: %s: couldn't read a number\n",
+			progn, name);
+		exit(EXIT_FAILURE);
+	}
+
+	fclose(f);
+}
+
+static const char *MEM_NAME = "/dev/mem";
+
+static FILE *open_mem(void)
+{
+	FILE *mem = fopen(MEM_NAME, "r");
+	if (!mem) {
+		fprintf(stderr, "%s: open %s: %s\n",
+			progn, MEM_NAME, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+	return mem;
+}
+
+static void seek_mem(FILE *mem, unsigned long off)
+{
+	if (fseek(mem, off, SEEK_SET) < 0) {
+		fprintf(stderr, "%s: seek %s: %s\n",
+			progn, MEM_NAME, strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void read_mem(FILE *mem, char *buf, unsigned long len)
+{
+	size_t res;
+
+	res = fread(buf, 1, len, mem);
+	if (res == 0 && ferror(mem)) {
+		fprintf(stderr, "%s: read %s: %s\n",
+			progn, MEM_NAME, strerror(errno));
+		exit(EXIT_FAILURE);
+	} else if (res < len) {
+		fprintf(stderr, "%s: read %s: short read\n",
+			progn, MEM_NAME);
+		exit(EXIT_FAILURE);
+	}
+}
+
+static void putsn(const char *s, size_t n)
+{
+	while (*s && n-- > 0)
+		putchar(*s++);
+}
+
+static int check_record(char *buf, char *time_out, size_t time_len)
+{
+	static const char *MAGIC = "====";
+	static const size_t MAGIC_LEN = 4;
+
+	char *s;
+
+	if (memcmp(buf, MAGIC, MAGIC_LEN))
+		return 0;
+
+	s = buf + MAGIC_LEN;
+	while (*s != '\n' && --time_len > 0)
+		*time_out++ = *s++;
+	*time_out = '\0';
+
+	return 1;
+}
+
+static const int REC_LIST = -1;
+
+#define RAMOOPS_PARAM "/sys/module/ramoops/parameters/"
+
+static int print_record(int record, int contents, FILE *mem,
+			unsigned long record_size, char *buf)
+{
+	static const size_t TIME_LEN = 64;
+
+	char time[TIME_LEN];
+
+	read_mem(mem, buf, record_size);
+	fprintf(stderr, "ramoops record %d: ", record);
+	if (check_record(buf, time, TIME_LEN)) {
+		fprintf(stderr, "valid, timestamp %s\n", time);
+		if (contents)
+			putsn(buf, record_size);
+		return 0;
+	} else {
+		fprintf(stderr, "invalid\n");
+		return 1;
+	}
+}
+
+static int print_records(int record)
+{
+	unsigned long mem_address, mem_size, record_size, num_records;
+	FILE *mem;
+	int i;
+	int ret = 0;
+
+	read_long(RAMOOPS_PARAM "mem_address", &mem_address);
+	read_long(RAMOOPS_PARAM "mem_size",    &mem_size);
+	read_long(RAMOOPS_PARAM "record_size", &record_size);
+	num_records = mem_size / record_size;
+
+	if (record != REC_LIST &&
+	    (record < 0 || (unsigned long)record >= num_records)) {
+		fprintf(stderr, "%s: record number %d out of range [0, %ld)\n",
+			progn, record, num_records);
+		return 1;
+	}
+
+	buf = malloc(record_size);
+	if (!buf) {
+		fprintf(stderr, "%s: failed to allocate record buffer\n",
+			progn);
+		return 1;
+	}
+
+	mem = open_mem();
+	if (record == REC_LIST) {
+		seek_mem(mem, mem_address);
+		for (i = 0; i < (int)num_records; i++)
+			print_record(i, 0, mem, record_size, buf);
+	} else {
+		seek_mem(mem, mem_address + record * record_size);
+		ret = print_record(record, 1, mem, record_size, buf);
+	}
+	fclose(mem);
+
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	progn = argv[0];
+
+	switch (argc) {
+	case 1:
+		return print_records(REC_LIST);
+	case 2:
+		return print_records(atoi(argv[1]));
+	default:
+		fprintf(stderr, "Usage: %s [record]\n", progn);
+		return 1;
+	}
+}
-- 
1.7.3.1

