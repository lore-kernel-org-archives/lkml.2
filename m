Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2FSPvv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:51:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17395 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754808Ab2FSPua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:50:30 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 23/23] perf, tool: Add dso data caching tests
Date: Tue, 19 Jun 2012 17:48:14 +0200
Message-Id: <1340120894-9465-24-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated test for DSO data reading. Testing raw/cached
reads from different file/cache locations.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Makefile             |    1 +
 tools/perf/builtin-test.c       |    4 +
 tools/perf/util/dso-test-data.c |  154 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h        |    1 +
 4 files changed, 160 insertions(+), 0 deletions(-)
 create mode 100644 tools/perf/util/dso-test-data.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 92c3f8f..503ed03 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -362,6 +362,7 @@ LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
+LIB_OBJS += $(OUTPUT)util/dso-test-data.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 8d3ed01..16cbf1a 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1142,6 +1142,10 @@ static struct test {
 		.func = test__perf_pmu,
 	},
 	{
+		.desc = "Test dso data interface",
+		.func = dso__test_data,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/util/dso-test-data.c b/tools/perf/util/dso-test-data.c
new file mode 100644
index 0000000..ec62977
--- /dev/null
+++ b/tools/perf/util/dso-test-data.c
@@ -0,0 +1,154 @@
+
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+#include <string.h>
+
+#include "symbol.h"
+
+#define TEST_ASSERT_VAL(text, cond) \
+do { \
+	if (!(cond)) { \
+		pr_debug("FAILED %s:%d %s\n", __FILE__, __LINE__, text); \
+		return -1; \
+	} \
+} while (0)
+
+static char *test_file(int size)
+{
+	static char buf_templ[] = "/tmp/test-XXXXXX";
+	char *templ = buf_templ;
+	int fd, i;
+	unsigned char *buf;
+
+	fd = mkostemp(templ, O_CREAT|O_WRONLY|O_TRUNC);
+
+	buf = malloc(size);
+	if (!buf) {
+		close(fd);
+		return NULL;
+	}
+
+	for (i = 0; i < size; i++)
+		buf[i] = (unsigned char) ((int) i % 10);
+
+	if (size != write(fd, buf, size))
+		templ = NULL;
+
+	close(fd);
+	return templ;
+}
+
+#define TEST_FILE_SIZE (DSO__DATA_CACHE_SIZE * 20)
+
+struct test_data__offset {
+	off_t offset;
+	u8 data[10];
+	int size;
+};
+
+struct test_data__offset offsets[] = {
+	/* Fill first cache page. */
+	{
+		.offset = 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read first cache page. */
+	{
+		.offset = 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Fill cache boundary pages. */
+	{
+		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read cache boundary pages. */
+	{
+		.offset = DSO__DATA_CACHE_SIZE - DSO__DATA_CACHE_SIZE % 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Fill final cache page. */
+	{
+		.offset = TEST_FILE_SIZE - 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read final cache page. */
+	{
+		.offset = TEST_FILE_SIZE - 10,
+		.data   = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 },
+		.size   = 10,
+	},
+	/* Read final cache page. */
+	{
+		.offset = TEST_FILE_SIZE - 3,
+		.data   = { 7, 8, 9, 0, 0, 0, 0, 0, 0, 0 },
+		.size   = 3,
+	},
+};
+
+#define OFFSETS_CNT (sizeof(offsets) / sizeof(struct test_data__offset))
+
+int dso__test_data(void)
+{
+	struct machine machine;
+	struct dso *dso;
+	char *file = test_file(TEST_FILE_SIZE);
+	int i;
+
+	TEST_ASSERT_VAL("No test file", file);
+
+	memset(&machine, 0, sizeof(machine));
+
+	dso = dso__new((const char *)file);
+
+	/* Basic 10 bytes tests. */
+	for (i = 0; i < (int) OFFSETS_CNT; i++) {
+		struct test_data__offset *data = &offsets[i];
+		ssize_t size;
+		u8 buf[10];
+
+		memset(buf, 0, 10);
+		size = dso__data_read_offset(dso, &machine, data->offset,
+				     buf, 10);
+
+		TEST_ASSERT_VAL("Wrong size", size == data->size);
+		TEST_ASSERT_VAL("Wrong data", !memcmp(buf, data->data, 10));
+	}
+
+	/* Read cross multiple cache pages. */
+	{
+		ssize_t size;
+		int c;
+		u8 *buf;
+
+		buf = malloc(TEST_FILE_SIZE);
+		TEST_ASSERT_VAL("ENOMEM\n", buf);
+
+		/* First iteration to fill caches, second one to read them. */
+		for (c = 0; c < 2; c++) {
+			memset(buf, 0, TEST_FILE_SIZE);
+			size = dso__data_read_offset(dso, &machine, 10,
+						     buf, TEST_FILE_SIZE);
+
+			TEST_ASSERT_VAL("Wrong size",
+				size == (TEST_FILE_SIZE - 10));
+
+			for (i = 0; i < size; i++)
+				TEST_ASSERT_VAL("Wrong data",
+					buf[i] == (i % 10));
+		}
+
+		free(buf);
+	}
+
+	dso__delete(dso);
+	unlink(file);
+	return 0;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 67313f0..17a7e8f 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -324,4 +324,5 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
+int dso__test_data(void);
 #endif /* __PERF_SYMBOL */
-- 
1.7.7.6

