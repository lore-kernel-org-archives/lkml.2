Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2AILaz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 06:30:55 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:53514 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab2AILax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 06:30:53 -0500
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Namhyung Kim <namhyung@gmail.com>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Subject: [PATCH v2][trace-cmd] blk plugin: replace BLK_TC_BARRIER with BLK_TC_FLUSH/BLK_TC_FUA
Date: Mon,  9 Jan 2012 11:30:39 +0000
Message-Id: <1326108639-13904-1-git-send-email-stefanha@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.3
x-cbid: 12010911-8372-0000-0000-0000014E2C1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BLK_TC_BARRIER flag was dropped in Linux commit c09c47caedc in
August 2011.  The blk plugin fails to build against recent kernel
headers.  Since no flag bits were left, the new BLK_TC_FLUSH flag reused
the BLK_TC_BARRIER bit.  The new BLK_TC_FUA flag was also added.

This patch updates fill_rwbs() to reflect the new
BLK_TC_FLUSH/BLK_TC_FUA flags.  This allows plugin_blk.c to build
successfully on recent kernels.  Most of the patch deals with detecting
old vs new kernel headers so we can build successfully on both.

Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
---
 Makefile     |   14 +++++++++++---
 plugin_blk.c |   11 +++++++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index c839653..edf3402 100644
--- a/Makefile
+++ b/Makefile
@@ -89,12 +89,20 @@ endif
 
 # $(call test-build, snippet, ret) -> ret if snippet compiles
 #                                  -> empty otherwise
-test-build = $(if $(shell $(CC) -o /dev/null -c -x c - > /dev/null 2>&1 \
-	                  <<<'$1' && echo y), $2)
+test-build = $(if $(shell sh -c 'echo "$(1)" | \
+	$(CC) -o /dev/null -c -x c - > /dev/null 2>&1 && echo y'), $2)
 
 # have udis86 disassembler library?
 udis86-flags := $(call test-build,\#include <udis86.h>,-DHAVE_UDIS86 -ludis86)
 
+define BLK_TC_FLUSH_SOURCE
+#include <linux/blktrace_api.h>
+int main(void) { return BLK_TC_FLUSH; }
+endef
+
+# have flush/fua block layer instead of barriers?
+blk-flags := $(call test-build,$(BLK_TC_FLUSH_SOURCE),-DHAVE_BLK_TC_FLUSH)
+
 ifeq ("$(origin O)", "command line")
   BUILD_OUTPUT := $(O)
 endif
@@ -223,7 +231,7 @@ endif
 
 # Append required CFLAGS
 override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
-override CFLAGS += $(udis86-flags)
+override CFLAGS += $(udis86-flags) $(blk-flags)
 
 ifeq ($(VERBOSE),1)
   Q =
diff --git a/plugin_blk.c b/plugin_blk.c
index 9327b17..c0ecef9 100644
--- a/plugin_blk.c
+++ b/plugin_blk.c
@@ -54,6 +54,11 @@ static void fill_rwbs(char *rwbs, int action, unsigned int bytes)
 		goto out;
 	}
 
+#if defined(HAVE_BLK_TC_FLUSH)
+	if (tc & BLK_TC_FLUSH)
+		rwbs[i++] = 'F';
+#endif
+
 	if (tc & BLK_TC_DISCARD)
 		rwbs[i++] = 'D';
 	else if (tc & BLK_TC_WRITE)
@@ -63,10 +68,16 @@ static void fill_rwbs(char *rwbs, int action, unsigned int bytes)
 	else
 		rwbs[i++] = 'N';
 
+#if defined(HAVE_BLK_TC_FLUSH)
+	if (tc & BLK_TC_FUA)
+		rwbs[i++] = 'F';
+#endif
 	if (tc & BLK_TC_AHEAD)
 		rwbs[i++] = 'A';
+#if !defined(HAVE_BLK_TC_FLUSH)
 	if (tc & BLK_TC_BARRIER)
 		rwbs[i++] = 'B';
+#endif
 	if (tc & BLK_TC_SYNC)
 		rwbs[i++] = 'S';
 	if (tc & BLK_TC_META)
-- 
1.7.7.3

