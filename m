Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778Ab2EVOW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:22:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33962 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758692Ab2EVOUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:20:37 -0400
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
Subject: [PATCH 09/16] pstore/ram: Factor ramoops_get_dump_prz() out of ramoops_pstore_read()
Date: Tue, 22 May 2012 07:17:52 -0700
Message-Id: <1337696279-8994-9-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120522141717.GA31574@lizard>
References: <20120522141717.GA31574@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will help make code clearer when we'll add support for other
message types.

The patch also changes return value from -EINVAL to 0 in case of
end-of-records. The exact value doesn't matter for pstore (it should
be just <= 0), but 0 feels more correct.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 9785c84..6dc9e96 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -86,6 +86,24 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 	return 0;
 }
 
+static struct persistent_ram_zone *
+ramoops_get_dump_prz(u64 id, enum pstore_type_id *type,
+		     struct ramoops_context *cxt)
+{
+	struct persistent_ram_zone *prz;
+
+	if (id > cxt->max_dump_count)
+		return NULL;
+
+	prz = cxt->przs[id];
+	if (!persistent_ram_old_size(prz))
+		return NULL;
+
+	*type = PSTORE_TYPE_DMESG;
+
+	return prz;
+}
+
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   struct timespec *time,
 				   char **buf,
@@ -95,14 +113,12 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
 
-	if (cxt->read_count >= cxt->max_dump_count)
-		return -EINVAL;
-
 	*id = cxt->read_count++;
-	prz = cxt->przs[*id];
 
-	/* Only supports dmesg output so far. */
-	*type = PSTORE_TYPE_DMESG;
+	prz = ramoops_get_dump_prz(*id, type, cxt);
+	if (!prz)
+		return 0;
+
 	/* TODO(kees): Bogus time for the moment. */
 	time->tv_sec = 0;
 	time->tv_nsec = 0;
-- 
1.7.9.2

