Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2GRHsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:48:39 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:34698 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab2GRHsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:48:33 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, John Stultz <john.stultz@linaro.org>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com
Subject: [PATCH] pstore/ram: Mark ramoops_pstore_write_buf() as notrace
Date: Wed, 18 Jul 2012 00:46:18 -0700
Message-Id: <1342597578-31227-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_buf() should be marked as notrace, otherwise it is prone to
recursion.

Though, yet the issue is never triggered in real life, because we run
inside the function tracer, where ftrace does its own recurse protection.

But it's still no good, plus soon we might switch to our own tracer ops,
and then the issue will be fatal. So, let's fix it.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 0b311bc..b86b2b7 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -32,6 +32,7 @@
 #include <linux/ioport.h>
 #include <linux/platform_device.h>
 #include <linux/slab.h>
+#include <linux/compiler.h>
 #include <linux/pstore_ram.h>
 
 #define RAMOOPS_KERNMSG_HDR "===="
@@ -181,12 +182,11 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 	return len;
 }
 
-
-static int ramoops_pstore_write_buf(enum pstore_type_id type,
-				    enum kmsg_dump_reason reason,
-				    u64 *id, unsigned int part,
-				    const char *buf, size_t size,
-				    struct pstore_info *psi)
+static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
+					    enum kmsg_dump_reason reason,
+					    u64 *id, unsigned int part,
+					    const char *buf, size_t size,
+					    struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz = cxt->przs[cxt->dump_write_cnt];
-- 
1.7.10.4

