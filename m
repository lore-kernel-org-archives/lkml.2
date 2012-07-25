Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab2GYT34 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 15:29:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58465 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab2GYT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 15:29:54 -0400
Date: Wed, 25 Jul 2012 12:28:17 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-f7add556534529ab18501ced98d7f3f2fc7f0621@git.kernel.org>
Cc: acme@redhat.com, eranian@google.com, mingo@kernel.org, gorcunov@openvz.org,
        a.p.zijlstra@chello.nl, benjamin.redelings@nescent.org,
        jolsa@redhat.com, drepper@gmail.com, robert.richter@amd.com,
        fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        asharma@fb.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        fche@redhat.com, paulus@samba.org, tzanussi@gmail.com,
        masami.hiramatsu.pt@hitachi.com
Reply-To: mingo@kernel.org, eranian@google.com, acme@redhat.com,
        gorcunov@openvz.org, a.p.zijlstra@chello.nl,
        benjamin.redelings@nescent.org, jolsa@redhat.com, fweisbec@gmail.com,
        robert.richter@amd.com, drepper@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, asharma@fb.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, hpa@zytor.com, fche@redhat.com,
        tzanussi@gmail.com, masami.hiramatsu.pt@hitachi.com
In-Reply-To: <1342959280-5361-18-git-send-email-jolsa@redhat.com>
References: <1342959280-5361-18-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: Add dso data caching tests
Git-Commit-ID: f7add556534529ab18501ced98d7f3f2fc7f0621
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Jul 2012 12:28:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f7add556534529ab18501ced98d7f3f2fc7f0621
Gitweb:     http://git.kernel.org/tip/f7add556534529ab18501ced98d7f3f2fc7f0621
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sun, 22 Jul 2012 14:14:40 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 25 Jul 2012 11:33:17 -0300

perf test: Add dso data caching tests

Adding automated test for DSO data reading. Testing raw/cached reads
from different file/cache locations.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Benjamin Redelings <benjamin.redelings@nescent.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Ulrich Drepper <drepper@gmail.com>
Link: http://lkml.kernel.org/r/1342959280-5361-18-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |    1 +
 tools/perf/builtin-test.c       |    4 +
 tools/perf/util/dso-test-data.c |  153 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h        |    1 +
 4 files changed, 159 insertions(+), 0 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 75d74e5..e8f0579 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -354,6 +354,7 @@ LIB_OBJS += $(OUTPUT)util/usage.o
 LIB_OBJS += $(OUTPUT)util/wrapper.o
 LIB_OBJS += $(OUTPUT)util/sigchain.o
 LIB_OBJS += $(OUTPUT)util/symbol.o
+LIB_OBJS += $(OUTPUT)util/dso-test-data.o
 LIB_OBJS += $(OUTPUT)util/color.o
 LIB_OBJS += $(OUTPUT)util/pager.o
 LIB_OBJS += $(OUTPUT)util/header.o
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5ce3030..d909eb7 100644
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
index 0000000..541cdc7
--- /dev/null
+++ b/tools/perf/util/dso-test-data.c
@@ -0,0 +1,153 @@
+#include "util.h"
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
+struct test_data_offset {
+	off_t offset;
+	u8 data[10];
+	int size;
+};
+
+struct test_data_offset offsets[] = {
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
+int dso__test_data(void)
+{
+	struct machine machine;
+	struct dso *dso;
+	char *file = test_file(TEST_FILE_SIZE);
+	size_t i;
+
+	TEST_ASSERT_VAL("No test file", file);
+
+	memset(&machine, 0, sizeof(machine));
+
+	dso = dso__new((const char *)file);
+
+	/* Basic 10 bytes tests. */
+	for (i = 0; i < ARRAY_SIZE(offsets); i++) {
+		struct test_data_offset *data = &offsets[i];
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
+			for (i = 0; i < (size_t)size; i++)
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
index 980d5f5..1fe733a 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -325,4 +325,5 @@ ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
 ssize_t dso__data_read_addr(struct dso *dso, struct map *map,
 			    struct machine *machine, u64 addr,
 			    u8 *data, ssize_t size);
+int dso__test_data(void);
 #endif /* __PERF_SYMBOL */
