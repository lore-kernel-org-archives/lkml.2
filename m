Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752057Ab2GSXqK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 19:46:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34179 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GSXqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 19:46:08 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com
Subject: [PATCH] pstore/ram: Fix possible NULL dereference
Date: Thu, 19 Jul 2012 16:43:41 -0700
Message-Id: <1342741421-17956-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120719142856.GA25184@elgon.mountain>
References: <20120719142856.GA25184@elgon.mountain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can dereference 'cxt->cprz' if console and dump logging are disabled
(which is unlikely, but still possible to do). This patch fixes the issue
by changing the code so that we don't dereference przs at all, we can
just calculate bufsize from console_size and record_size values.

Plus, while at it, the patch improves the buffer size calculation.

After Kay's printk rework, we know the optimal buffer size for console
logging -- it is LOG_LINE_MAX (defined privately in printk.c). Previously,
if only console logging was enabled, we would allocate unnecessary large
buffer in pstore, while we only need LOG_LINE_MAX. (Pstore console logging
is still capable of handling buffers > LOG_LINE_MAX, it will just do
multiple calls to psinfo->write).

Note that I don't export the constant, since we will do even a better
thing soon: we will switch console logging to a new write_buf API, which
will eliminate the need for the additional buffer; and so we won't need
the constant.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index b86b2b7..c34fccf 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -414,13 +414,14 @@ static int __devinit ramoops_probe(struct platform_device *pdev)
 
 	cxt->pstore.data = cxt;
 	/*
-	 * Console can handle any buffer size, so prefer dumps buffer
-	 * size since usually it is smaller.
+	 * Console can handle any buffer size, so prefer LOG_LINE_MAX. If we
+	 * have to handle dumps, we must have at least record_size buffer. And
+	 * for ftrace, bufsize is irrelevant (if bufsize is 0, buf will be
+	 * ZERO_SIZE_PTR).
 	 */
-	if (cxt->przs)
-		cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
-	else
-		cxt->pstore.bufsize = cxt->cprz->buffer_size;
+	if (cxt->console_size)
+		cxt->pstore.bufsize = 1024; /* LOG_LINE_MAX */
+	cxt->pstore.bufsize = max(cxt->record_size, cxt->pstore.bufsize);
 	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
 	spin_lock_init(&cxt->pstore.buf_lock);
 	if (!cxt->pstore.buf) {
-- 
1.7.10.4

