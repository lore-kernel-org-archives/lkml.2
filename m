Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174Ab2GQSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:16:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37013 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2GQSQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:16:20 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH] pstore: Headers should include all stuff they use
Date: Tue, 17 Jul 2012 11:13:59 -0700
Message-Id: <1342548840-22404-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120717180918.GA18671@lizard>
References: <20120717180918.GA18671@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Headers should really include all the needed prototypes, types, defines
etc. to be self-contained. This is a long-standing issue, but apparently
the new tracing code unearthed it (SMP=n is also a prerequisite):

In file included from fs/pstore/internal.h:4:0,
                 from fs/pstore/ftrace.c:21:
include/linux/pstore.h:43:15: error: field ‘read_mutex’ has incomplete type

While at it, I also added the following:

linux/types.h -> size_t, phys_addr_t, uXX and friends
linux/spinlock.h -> spinlock_t
linux/errno.h -> Exxxx
linux/time.h -> struct timespec (struct passed by value)
struct module and rs_control forward declaration (passed via pointers).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/internal.h       |    2 ++
 include/linux/pstore.h     |    6 ++++++
 include/linux/pstore_ram.h |    1 +
 3 files changed, 9 insertions(+)

diff --git a/fs/pstore/internal.h b/fs/pstore/internal.h
index 958c48d..0d0d3b7 100644
--- a/fs/pstore/internal.h
+++ b/fs/pstore/internal.h
@@ -1,6 +1,8 @@
 #ifndef __PSTORE_INTERNAL_H__
 #define __PSTORE_INTERNAL_H__
 
+#include <linux/types.h>
+#include <linux/time.h>
 #include <linux/pstore.h>
 
 #if NR_CPUS <= 2 && defined(CONFIG_ARM_THUMB)
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 120443b..c892587 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -24,6 +24,10 @@
 
 #include <linux/time.h>
 #include <linux/kmsg_dump.h>
+#include <linux/mutex.h>
+#include <linux/types.h>
+#include <linux/spinlock.h>
+#include <linux/errno.h>
 
 /* types */
 enum pstore_type_id {
@@ -34,6 +38,8 @@ enum pstore_type_id {
 	PSTORE_TYPE_UNKNOWN	= 255
 };
 
+struct module;
+
 struct pstore_info {
 	struct module	*owner;
 	char		*name;
diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
index af848e1..ba2b211 100644
--- a/include/linux/pstore_ram.h
+++ b/include/linux/pstore_ram.h
@@ -24,6 +24,7 @@
 #include <linux/init.h>
 
 struct persistent_ram_buffer;
+struct rs_control;
 
 struct persistent_ram_zone {
 	phys_addr_t paddr;
-- 
1.7.10.4

