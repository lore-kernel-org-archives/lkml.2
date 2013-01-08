Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892Ab3AHXYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:24:43 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49835 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753114Ab3AHXYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:24:41 -0500
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Cody P Schafer <jmesmon@gmail.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 2/2] tools: add gfp mask decoder
Date: Tue,  8 Jan 2013 15:24:15 -0800
Message-Id: <1357687455-13234-3-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1357687455-13234-1-git-send-email-cody@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010823-7606-0000-0000-000007426B39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <jmesmon@gmail.com>

Allows decoding of gfp_masks printed, for example, when the oom-killer
is invoked.

Example usage:

	[    6.464753] kthreadd invoked oom-killer: gfp_mask=0x1000d0, order=1, oom_score_adj=0

	$ ./gfp-decode 0x1000d0
	GFP_KERNEL|GFP_KMEMCG

Internally, it reuses some of the ftrace structure for decoding the
gfp_mask.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 tools/gfp-decode/.gitignore   |  1 +
 tools/gfp-decode/Makefile     | 11 ++++++
 tools/gfp-decode/gfp-decode.c | 89 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 101 insertions(+)
 create mode 100644 tools/gfp-decode/.gitignore
 create mode 100644 tools/gfp-decode/Makefile
 create mode 100644 tools/gfp-decode/gfp-decode.c

diff --git a/tools/gfp-decode/.gitignore b/tools/gfp-decode/.gitignore
new file mode 100644
index 0000000..eca2466
--- /dev/null
+++ b/tools/gfp-decode/.gitignore
@@ -0,0 +1 @@
+/gfp-decode
diff --git a/tools/gfp-decode/Makefile b/tools/gfp-decode/Makefile
new file mode 100644
index 0000000..51f375a
--- /dev/null
+++ b/tools/gfp-decode/Makefile
@@ -0,0 +1,11 @@
+include ../scripts/Makefile.include
+
+all: $(OUTPUT)gfp-decode
+
+CC = $(CROSS_COMPILE)gcc
+ALL_CFLAGS = $(CFLAGS) $(EXTRA_WARNINGS) -Wall -Wextra -I../../include
+
+$(OUTPUT)gfp-decode: gfp-decode.c
+	$(QUIET_CC)$(CC) -o $@ $(ALL_CFLAGS) $(LDFLAGS) $<
+clean:
+	$(RM) $(OUTPUT)gfp-decode
diff --git a/tools/gfp-decode/gfp-decode.c b/tools/gfp-decode/gfp-decode.c
new file mode 100644
index 0000000..4997f22
--- /dev/null
+++ b/tools/gfp-decode/gfp-decode.c
@@ -0,0 +1,89 @@
+
+#include <stdio.h>
+#include <stdlib.h>
+#include "../../include/trace/events/gfpflags.h"
+
+typedef unsigned gfp_t; /* from linux/types.h */
+#define __force
+#include "../../include/linux/gfp-flags.h"
+
+/* taken from linux/ftrace_event.h */
+struct trace_print_flags {
+	unsigned long		mask;
+	const char		*name;
+};
+
+/*
+ * taken from include/trace/ftrace.h
+ * modified to not pass 'p' to ftrace_print_flags_seq().
+ */
+#define __print_flags(flag, delim, flag_array...)			\
+	({								\
+		static const struct trace_print_flags __flags[] =	\
+			{ flag_array, { -1, NULL } };			\
+		ftrace_print_flags_seq(delim, flag, __flags);	\
+	})
+
+/*
+ * taken from kernel/trace/trace_output.c
+ * modified to use standard puts,putc, and printf and remove use of the buffer.
+ */
+static void
+ftrace_print_flags_seq(const char *delim,
+		       unsigned long flags,
+		       const struct trace_print_flags *flag_array)
+{
+	unsigned long mask;
+	const char *str;
+	int i, first = 1;
+
+	for (i = 0;  flag_array[i].name && flags; i++) {
+
+		mask = flag_array[i].mask;
+		if ((flags & mask) != mask)
+			continue;
+
+		str = flag_array[i].name;
+		flags &= ~mask;
+		if (!first && delim)
+			fputs(delim, stdout);
+		else
+			first = 0;
+		fputs(str, stdout);
+	}
+
+	/* check for left over flags */
+	if (flags) {
+		if (!first && delim)
+			fputs(delim, stdout);
+		printf("0x%lx", flags);
+	}
+	putchar('\n');
+}
+
+int main(int argc, char **argv)
+{
+	int i;
+
+	if (argc < 2) {
+		printf("usage: %s <gfp hex mask>..\n", argv[0]);
+		return 1;
+	}
+
+	for (i = 1; i < argc; i++) {
+		char *cur = argv[i];
+		char *r;
+		unsigned long flags;
+		if (cur[0] == '0' && cur[1] == 'x')
+			cur = &cur[2];
+		flags = strtoul(cur, &r, 16);
+		if (*r != '\0') {
+			fprintf(stderr, "skipping arg %d\n", i-1);
+			continue;
+		}
+
+		show_gfp_flags(flags);
+	}
+
+	return 0;
+}
-- 
1.8.0.3

