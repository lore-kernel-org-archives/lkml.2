Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030368Ab2ERW0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 18:26:13 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60603 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030310Ab2ERW0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 18:26:07 -0400
Date: Fri, 18 May 2012 15:24:37 -0700
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
Subject: [PATCH 04/14] pstore/ram: Should zap persistent zone on unlink
Message-ID: <20120518222436.GD23089@lizard>
References: <20120518222314.GA9425@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120518222314.GA9425@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, unlinked file will reappear on the next boot.

Reported-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c            |    1 +
 fs/pstore/ram_core.c       |    6 ++++++
 include/linux/pstore_ram.h |    1 +
 3 files changed, 8 insertions(+)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 3a7724b..43d9727 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -186,6 +186,7 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
 		return -EINVAL;
 
 	persistent_ram_free_old(cxt->przs[id]);
+	persistent_ram_zap(cxt->przs[id]);
 
 	return 0;
 }
diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index dff5127..28b6d7f 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -336,6 +336,12 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz)
 	prz->old_log_size = 0;
 }
 
+void persistent_ram_zap(struct persistent_ram_zone *prz)
+{
+	atomic_set(&prz->buffer->size, 0);
+	persistent_ram_update_header_ecc(prz);
+}
+
 static void *persistent_ram_vmap(phys_addr_t start, size_t size)
 {
 	struct page **pages;
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index 07d59b7..085199e 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -69,6 +69,7 @@ struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
 						       size_t size,
 						       bool ecc);
 void persistent_ram_free(struct persistent_ram_zone *prz);
+void persistent_ram_zap(struct persistent_ram_zone *prz);
 struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
 		bool ecc);
 
-- 
1.7.9.2

