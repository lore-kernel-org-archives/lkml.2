Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2EZNWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:22:30 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58205 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630Ab2EZNW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:22:26 -0400
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
Subject: [PATCH 04/11] pstore/ram: Factor ramoops_get_next_prz() out of ramoops_pstore_read()
Date: Sat, 26 May 2012 06:20:22 -0700
Message-Id: <1338038429-21945-4-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526131747.GA15054@lizard>
References: <20120526131747.GA15054@lizard>
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
 fs/pstore/ram.c |   41 ++++++++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 9 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 6b76767..d770d72 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -85,6 +85,33 @@ static int ramoops_pstore_open(struct pstore_info *psi)
 	return 0;
 }
 
+static struct persistent_ram_zone *
+ramoops_get_next_prz(struct persistent_ram_zone *przs[], uint *c, uint max,
+		     u64 *id,
+		     enum pstore_type_id *typep, enum pstore_type_id type,
+		     bool update)
+{
+	struct persistent_ram_zone *prz;
+	int i = (*c)++;
+
+	if (i >= max)
+		return NULL;
+
+	prz = przs[i];
+
+	if (update) {
+		/* Update old/shadowed buffer. */
+		persistent_ram_save_old(prz);
+		if (!persistent_ram_old_size(prz))
+			return NULL;
+	}
+
+	*typep = type;
+	*id = i;
+
+	return prz;
+}
+
 static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 				   struct timespec *time,
 				   char **buf,
@@ -94,20 +121,16 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	struct ramoops_context *cxt = psi->data;
 	struct persistent_ram_zone *prz;
 
-	if (cxt->dump_read_cnt >= cxt->max_dump_cnt)
-		return -EINVAL;
-
-	*id = cxt->dump_read_cnt++;
-	prz = cxt->przs[*id];
+	prz = ramoops_get_next_prz(cxt->przs, &cxt->dump_read_cnt,
+				   cxt->max_dump_cnt, id, type,
+				   PSTORE_TYPE_DMESG, 1);
+	if (!prz)
+		return 0;
 
-	/* Only supports dmesg output so far. */
-	*type = PSTORE_TYPE_DMESG;
 	/* TODO(kees): Bogus time for the moment. */
 	time->tv_sec = 0;
 	time->tv_nsec = 0;
 
-	/* Update old/shadowed buffer. */
-	persistent_ram_save_old(prz);
 	size = persistent_ram_old_size(prz);
 	*buf = kmalloc(size, GFP_KERNEL);
 	if (*buf == NULL)
-- 
1.7.9.2

