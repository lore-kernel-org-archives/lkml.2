Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2EZNl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:41:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2EZNlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:41:24 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
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
Subject: [PATCH 4/5] pstore/ram: Convert to write_buf callback
Date: Sat, 26 May 2012 06:39:08 -0700
Message-Id: <1338039549-24498-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526133412.GA18001@lizard>
References: <20120526133412.GA18001@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use pstore.buf directly, instead convert the code to write_buf callback
which passes a pointer to a buffer as an argument.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index c7acf94..96dbd1e 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -168,11 +168,12 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
 	return len;
 }
 
-static int ramoops_pstore_write(enum pstore_type_id type,
-				enum kmsg_dump_reason reason,
-				u64 *id,
-				unsigned int part,
-				size_t size, struct pstore_info *psi)
+
+static int ramoops_pstore_write_buf(enum pstore_type_id type,
+				    enum kmsg_dump_reason reason,
+				    u64 *id, unsigned int part,
+				    const char *buf, size_t size,
+				    struct pstore_info *psi)
 {
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz = cxt->przs[cxt->dump_write_cnt];
@@ -181,7 +182,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	if (type == PSTORE_TYPE_CONSOLE) {
 		if (!cxt->cprz)
 			return -ENOMEM;
-		persistent_ram_write(cxt->cprz, cxt->pstore.buf, size);
+		persistent_ram_write(cxt->cprz, buf, size);
 		return 0;
 	}
 
@@ -210,7 +211,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	hlen = ramoops_write_kmsg_hdr(prz);
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
-	persistent_ram_write(prz, cxt->pstore.buf, size);
+	persistent_ram_write(prz, buf, size);
 
 	cxt->dump_write_cnt = (cxt->dump_write_cnt + 1) % cxt->max_dump_cnt;
 
@@ -248,7 +249,7 @@ static struct ramoops_context oops_cxt = {
 		.name	= "ramoops",
 		.open	= ramoops_pstore_open,
 		.read	= ramoops_pstore_read,
-		.write	= ramoops_pstore_write,
+		.write_buf	= ramoops_pstore_write_buf,
 		.erase	= ramoops_pstore_erase,
 	},
 };
-- 
1.7.9.2

