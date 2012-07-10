Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab2GJAOi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 20:14:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62482 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab2GJANR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 20:13:17 -0400
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
Subject: [PATCH 5/8] pstore/ram: Convert to write_buf callback
Date: Mon,  9 Jul 2012 17:10:43 -0700
Message-Id: <1341879046-5197-5-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120710001004.GA22744@lizard>
References: <20120710001004.GA22744@lizard>
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
index b39aebb..74f4111 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -170,11 +170,12 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
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
@@ -183,7 +184,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	if (type == PSTORE_TYPE_CONSOLE) {
 		if (!cxt->cprz)
 			return -ENOMEM;
-		persistent_ram_write(cxt->cprz, cxt->pstore.buf, size);
+		persistent_ram_write(cxt->cprz, buf, size);
 		return 0;
 	}
 
@@ -212,7 +213,7 @@ static int ramoops_pstore_write(enum pstore_type_id type,
 	hlen = ramoops_write_kmsg_hdr(prz);
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
-	persistent_ram_write(prz, cxt->pstore.buf, size);
+	persistent_ram_write(prz, buf, size);
 
 	cxt->dump_write_cnt = (cxt->dump_write_cnt + 1) % cxt->max_dump_cnt;
 
@@ -250,7 +251,7 @@ static struct ramoops_context oops_cxt = {
 		.name	= "ramoops",
 		.open	= ramoops_pstore_open,
 		.read	= ramoops_pstore_read,
-		.write	= ramoops_pstore_write,
+		.write_buf	= ramoops_pstore_write_buf,
 		.erase	= ramoops_pstore_erase,
 	},
 };
-- 
1.7.10.4

