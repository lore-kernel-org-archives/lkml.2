Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2IMDNj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 23:13:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:54377 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752749Ab2IMDNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 23:13:37 -0400
Message-ID: <1347506017.2749.5.camel@joe2Laptop>
Subject: [PATCH 4/5] dev: Add dev_vprintk_emit and dev_printk_emit
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>, Jason Baron <jbaron@redhat.com>,
        Jim Cromie <jim.cromie@gmail.com>, Kay Sievers <kay@vrfy.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 12 Sep 2012 20:13:37 -0700
In-Reply-To: <cover.1345978012.git.joe@perches.com>
References: <cover.1345978012.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add utility functions to consolidate the use of
create_syslog_header and vprintk_emit.

This allows conversion of logging functions that
call create_syslog_header and then call vprintk_emit
or printk_emit to the dev_ equivalents.

Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: David S. Miller <davem@davemloft.net>
Tested-by: Jim Cromie <jim.cromie@gmail.com>
Acked-by: Jason Baron <jbaron@redhat.com>
---
 drivers/base/core.c    |   27 +++++++++++++++++++++++++++
 include/linux/device.h |   11 +++++++++++
 2 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index d46b635..ffccb64 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1909,6 +1909,33 @@ int create_syslog_header(const struct device *dev, char *hdr, size_t hdrlen)
 }
 EXPORT_SYMBOL(create_syslog_header);
 
+int dev_vprintk_emit(int level, const struct device *dev,
+		     const char *fmt, va_list args)
+{
+	char hdr[128];
+	size_t hdrlen;
+
+	hdrlen = create_syslog_header(dev, hdr, sizeof(hdr));
+
+	return vprintk_emit(0, level, hdrlen ? hdr : NULL, hdrlen, fmt, args);
+}
+EXPORT_SYMBOL(dev_vprintk_emit);
+
+int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
+{
+	va_list args;
+	int r;
+
+	va_start(args, fmt);
+
+	r = dev_vprintk_emit(level, dev, fmt, args);
+
+	va_end(args);
+
+	return r;
+}
+EXPORT_SYMBOL(dev_printk_emit);
+
 static int __dev_printk(const char *level, const struct device *dev,
 			struct va_format *vaf)
 {
diff --git a/include/linux/device.h b/include/linux/device.h
index 4800d73..0063d01 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -893,6 +893,10 @@ extern const char *dev_driver_string(const struct device *dev);
 
 extern int create_syslog_header(const struct device *dev,
 				char *hdr, size_t hdrlen);
+extern int dev_vprintk_emit(int level, const struct device *dev,
+			    const char *fmt, va_list args);
+extern __printf(3, 4)
+int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...);
 
 extern __printf(3, 4)
 int dev_printk(const char *level, const struct device *dev,
@@ -914,6 +918,13 @@ int _dev_info(const struct device *dev, const char *fmt, ...);
 
 #else
 
+static int dev_vprintk_emit(int level, const struct device *dev,
+			    const char *fmt, va_list args)
+{ return 0; }
+static inline __printf(3, 4)
+int dev_printk_emit(int level, const struct device *dev, const char *fmt, ...)
+{ return 0; }
+
 static inline int __dev_printk(const char *level, const struct device *dev,
 			       struct va_format *vaf)
 { return 0; }
-- 
1.7.8.111.gad25c.dirty


