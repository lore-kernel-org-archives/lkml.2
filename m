Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397Ab2EZNKU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:10:20 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41366 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858Ab2EZNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:10:17 -0400
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
Subject: [PATCH 1/5] pstore/ram: Should update old dmesg buffer before reading
Date: Sat, 26 May 2012 06:07:49 -0700
Message-Id: <1338037673-19909-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526130650.GA6242@lizard>
References: <20120526130650.GA6242@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without the update, we'll only see the new dmesg buffer after the
reboot, but previously we could see it right away. Making an oops
visible in pstore filesystem before reboot is a somewhat dubious
feature, but removing it wasn't an intentional change, so let's
restore it.

For this we have to make persistent_ram_save_old() safe for calling
multiple times, and also extern it.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
Acked-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ram.c            |    2 ++
 fs/pstore/ram_core.c       |   15 ++++++++-------
 include/linux/pstore_ram.h |    1 +
 3 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 9123cce..16ff733 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -106,6 +106,8 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
 	time->tv_sec = 0;
 	time->tv_nsec = 0;
 
+	/* Update old/shadowed buffer. */
+	persistent_ram_save_old(prz);
 	size = persistent_ram_old_size(prz);
 	*buf = kmalloc(size, GFP_KERNEL);
 	if (*buf == NULL)
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 31f8d18..235513c 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -250,23 +250,24 @@ static void notrace persistent_ram_update(struct persistent_ram_zone *prz,
 	persistent_ram_update_ecc(prz, start, count);
 }
 
-static void __init
-persistent_ram_save_old(struct persistent_ram_zone *prz)
+void persistent_ram_save_old(struct persistent_ram_zone *prz)
 {
 	struct persistent_ram_buffer *buffer = prz->buffer;
 	size_t size = buffer_size(prz);
 	size_t start = buffer_start(prz);
-	char *dest;
 
-	persistent_ram_ecc_old(prz);
+	if (!size)
+		return;
 
-	dest = kmalloc(size, GFP_KERNEL);
-	if (dest == NULL) {
+	if (!prz->old_log) {
+		persistent_ram_ecc_old(prz);
+		prz->old_log = kmalloc(size, GFP_KERNEL);
+	}
+	if (!prz->old_log) {
 		pr_err("persistent_ram: failed to allocate buffer\n");
 		return;
 	}
 
-	prz->old_log = dest;
 	prz->old_log_size = size;
 	memcpy(prz->old_log, &buffer->data[start], size - start);
 	memcpy(prz->old_log + size - start, &buffer->data[0], start);
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 7ed7fd4..4491e8f 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -75,6 +75,7 @@ struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
 int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
 	unsigned int count);
 
+void persistent_ram_save_old(struct persistent_ram_zone *prz);
 size_t persistent_ram_old_size(struct persistent_ram_zone *prz);
 void *persistent_ram_old(struct persistent_ram_zone *prz);
 void persistent_ram_free_old(struct persistent_ram_zone *prz);
-- 
1.7.9.2

