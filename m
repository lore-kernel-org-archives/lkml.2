Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758600Ab2EQIn4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 04:43:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47753 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758367Ab2EQImM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 04:42:12 -0400
Date: Thu, 17 May 2012 01:40:43 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 2/6] pstore/ram: Add console messages handling
Message-ID: <20120517084042.GB31753@lizard>
References: <20120517083740.GA25627@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120517083740.GA25627@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is all straightforward: we just use the last region for
console logging. If there's just one region, we fall-back to
the old behaviour: just a oops/dumps logging.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   40 +++++++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 9123cce..5d6d53e 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -63,6 +63,7 @@ MODULE_PARM_DESC(ramoops_ecc,
 
 struct ramoops_context {
 	struct persistent_ram_zone **przs;
+	struct persistent_ram_zone *cprz;
 	phys_addr_t phys_addr;
 	unsigned long size;
 	size_t record_size;
@@ -70,6 +71,7 @@ struct ramoops_context {
 	bool ecc;
 	unsigned int count;
 	unsigned int max_count;
+	unsigned int max_dump_count;
 	unsigned int read_count;
 	struct pstore_info pstore;
 };
@@ -92,16 +94,20 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 {
 	ssize_t size;
 	struct ramoops_context *cxt = psi->data;
-	struct persistent_ram_zone *prz;
-
-	if (cxt->read_count >= cxt->max_count)
-		return -EINVAL;
+	struct persistent_ram_zone *prz = cxt->przs[cxt->read_count];
 
 	*id = cxt->read_count++;
-	prz = cxt->przs[*id];
 
-	/* Only supports dmesg output so far. */
-	*type = PSTORE_TYPE_DMESG;
+	if (*id < cxt->max_dump_count && persistent_ram_old_size(prz)) {
+		*type = PSTORE_TYPE_DMESG;
+	} else if (*id < cxt->max_count) {
+		*type = PSTORE_TYPE_CONSOLE;
+		prz = cxt->cprz;
+		cxt->read_count = cxt->max_count;
+	} else {
+		return 0;
+	}
+
 	/* TODO(kees): Bogus time for the moment. */
 	time->tv_sec = 0;
 	time->tv_nsec = 0;
@@ -142,7 +148,13 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	struct persistent_ram_zone *prz = cxt->przs[cxt->count];
 	size_t hlen;
 
-	/* Currently ramoops is designed to only store dmesg dumps. */
+	if (type == PSTORE_TYPE_CONSOLE) {
+		if (!cxt->cprz)
+			return -ENOMEM;
+		persistent_ram_write(cxt->cprz, cxt->pstore.buf, size);
+		return 0;
+	}
+
 	if (type != PSTORE_TYPE_DMESG)
 		return -EINVAL;
 
@@ -170,7 +182,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 		size = prz->buffer_size - hlen;
 	persistent_ram_write(prz, cxt->pstore.buf, size);
 
-	cxt->count = (cxt->count + 1) % cxt->max_count;
+	cxt->count = (cxt->count + 1) % cxt->max_dump_count;
 
 	return 0;
 }
@@ -264,6 +276,16 @@ static int __init ramoops_probe(struct platform_device *pdev)
 		}
 	}
 
+	/*
+	 * The last zone is for TYPE_CONSOLE, unless we have only
+	 * one, in which case we use it for oops/panic logging.
+	 */
+	cxt->max_dump_count = cxt->max_count;
+	if (cxt->max_count > 1) {
+		cxt->max_dump_count--;
+		cxt->cprz = cxt->przs[cxt->max_count - 1];
+	}
+
 	cxt->pstore.data = cxt;
 	cxt->pstore.bufsize = cxt->przs[0]->buffer_size;
 	cxt->pstore.buf = kmalloc(cxt->pstore.bufsize, GFP_KERNEL);
-- 
1.7.9.2

