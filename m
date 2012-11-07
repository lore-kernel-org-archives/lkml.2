Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2KGLEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 06:04:47 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35927 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2KGLEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 06:04:45 -0500
Date: Wed, 7 Nov 2012 03:01:39 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com, linux-man@vger.kernel.org
Subject: [RFC 2/3] tools/testing: Add vmpressure-test utility
Message-ID: <20121107110139.GB30462@lizard>
References: <20121107105348.GA25549@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121107105348.GA25549@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a simple test/example utility for the vmpressure_fd(2) system call.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 tools/testing/vmpressure/.gitignore        |  1 +
 tools/testing/vmpressure/Makefile          | 30 ++++++++++
 tools/testing/vmpressure/vmpressure-test.c | 93 ++++++++++++++++++++++++++++++
 3 files changed, 124 insertions(+)
 create mode 100644 tools/testing/vmpressure/.gitignore
 create mode 100644 tools/testing/vmpressure/Makefile
 create mode 100644 tools/testing/vmpressure/vmpressure-test.c

diff --git a/tools/testing/vmpressure/.gitignore b/tools/testing/vmpressure/.gitignore
new file mode 100644
index 0000000..fe5e38c
--- /dev/null
+++ b/tools/testing/vmpressure/.gitignore
@@ -0,0 +1 @@
+vmpressure-test
diff --git a/tools/testing/vmpressure/Makefile b/tools/testing/vmpressure/Makefile
new file mode 100644
index 0000000..7545f3e
--- /dev/null
+++ b/tools/testing/vmpressure/Makefile
@@ -0,0 +1,30 @@
+WARNINGS := -Wcast-align
+WARNINGS += -Wformat
+WARNINGS += -Wformat-security
+WARNINGS += -Wformat-y2k
+WARNINGS += -Wshadow
+WARNINGS += -Winit-self
+WARNINGS += -Wpacked
+WARNINGS += -Wredundant-decls
+WARNINGS += -Wstrict-aliasing=3
+WARNINGS += -Wswitch-default
+WARNINGS += -Wno-system-headers
+WARNINGS += -Wundef
+WARNINGS += -Wwrite-strings
+WARNINGS += -Wbad-function-cast
+WARNINGS += -Wmissing-declarations
+WARNINGS += -Wmissing-prototypes
+WARNINGS += -Wnested-externs
+WARNINGS += -Wold-style-definition
+WARNINGS += -Wstrict-prototypes
+WARNINGS += -Wdeclaration-after-statement
+
+CFLAGS  = -O3 -g -std=gnu99 $(WARNINGS)
+
+PROGRAMS = vmpressure-test
+
+all: $(PROGRAMS)
+
+clean:
+	rm -f $(PROGRAMS) *.o
+.PHONY: clean
diff --git a/tools/testing/vmpressure/vmpressure-test.c b/tools/testing/vmpressure/vmpressure-test.c
new file mode 100644
index 0000000..1e448be
--- /dev/null
+++ b/tools/testing/vmpressure/vmpressure-test.c
@@ -0,0 +1,93 @@
+/*
+ * vmpressure_fd(2) test utility
+ *
+ * Copyright 2011-2012 Pekka Enberg <penberg@kernel.org>
+ * Copyright 2011-2012 Linaro Ltd.
+ *		       Anton Vorontsov <anton.vorontsov@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation.
+ */
+
+/* TODO: glibc wrappers */
+#include "../../../include/linux/vmpressure.h"
+
+#if defined(__x86_64__)
+#include "../../../arch/x86/include/generated/asm/unistd_64.h"
+#endif
+#if defined(__arm__)
+#include "../../../arch/arm/include/asm/unistd.h"
+#endif
+
+#include <stdint.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <stdio.h>
+#include <poll.h>
+
+#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+static void pexit(const char *str)
+{
+	perror(str);
+	exit(1);
+}
+
+static int vmpressure_fd(struct vmpressure_config *config)
+{
+	config->size = sizeof(*config);
+
+	return syscall(__NR_vmpressure_fd, config);
+}
+
+int main(int argc, char *argv[])
+{
+	struct vmpressure_config config[] = {
+		/*
+		 * We could just set the lowest priority, but we want to
+		 * actually test if the thresholds work.
+		 */
+		{ .threshold = VMPRESSURE_LOW },
+		{ .threshold = VMPRESSURE_MEDIUM },
+		{ .threshold = VMPRESSURE_OOM },
+	};
+	const size_t num = ARRAY_SIZE(config);
+	struct pollfd pfds[num];
+	int i;
+
+	for (i = 0; i < num; i++) {
+		pfds[i].fd = vmpressure_fd(&config[i]);
+		if (pfds[i].fd < 0)
+			pexit("vmpressure_fd failed");
+
+		pfds[i].events = POLLIN;
+	}
+
+	while (poll(pfds, num, -1) > 0) {
+		for (i = 0; i < num; i++) {
+			struct vmpressure_event event;
+
+			if (!pfds[i].revents)
+				continue;
+
+			if (read(pfds[i].fd, &event, sizeof(event)) < 0)
+				pexit("read failed");
+
+			printf("VM pressure: 0x%.8x (threshold 0x%.8x)\n",
+			       event.pressure, config[i].threshold);
+		}
+	}
+
+	perror("poll failed\n");
+
+	for (i = 0; i < num; i++) {
+		if (close(pfds[i].fd) < 0)
+			pexit("close failed");
+	}
+
+	exit(1);
+	return 0;
+}
-- 
1.8.0
