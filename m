Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514Ab2EZNlT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 09:41:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34850 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2EZNlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 09:41:16 -0400
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
Subject: [PATCH 2/5] pstore: Introduce write_buf backend callback
Date: Sat, 26 May 2012 06:39:06 -0700
Message-Id: <1338039549-24498-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120526133412.GA18001@lizard>
References: <20120526133412.GA18001@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For function tracing we need to stop using pstore.buf directly, since
in a tracing callback we can't use spinlocks, and thus we can't safely
use the global buffer.

With write_buf callback, backends no longer need to access pstore.buf
directly, and thus we can pass any buffers (e.g. allocated on stack).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/platform.c   |   10 ++++++++++
 include/linux/pstore.h |    4 ++++
 2 files changed, 14 insertions(+)

diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index be4614f..e7c0a52 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -198,6 +198,14 @@ static void pstore_register_console(void)
 static void pstore_register_console(void) {}
 #endif
 
+static int pstore_write_compat(enum pstore_type_id type,
+			       enum kmsg_dump_reason reason,
+			       u64 *id, unsigned int part,
+			       size_t size, struct pstore_info *psi)
+{
+	return psi->write_buf(type, reason, id, part, psinfo->buf, size, psi);
+}
+
 /*
  * platform specific persistent storage driver registers with
  * us here. If pstore is already mounted, call the platform
@@ -222,6 +230,8 @@ int pstore_register(struct pstore_info *psi)
 		return -EINVAL;
 	}
 
+	if (!psi->write)
+		psi->write = pstore_write_compat;
 	psinfo = psi;
 	mutex_init(&psinfo->read_mutex);
 	spin_unlock(&pstore_lock);
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 1bd014b..b107484 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -48,6 +48,10 @@ struct pstore_info {
 	int		(*write)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, size_t size, struct pstore_info *psi);
+	int		(*write_buf)(enum pstore_type_id type,
+			enum kmsg_dump_reason reason, u64 *id,
+			unsigned int part, const char *buf, size_t size,
+			struct pstore_info *psi);
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			struct pstore_info *psi);
 	void		*data;
-- 
1.7.9.2

