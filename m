Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2ELKwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 06:52:34 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14667 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2ELKwc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 06:52:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sat, 12 May 2012 03:52:32 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Sat, 12 May 2012 12:52:27 +0200
Subject: [RFC 1/1] driver core: Add dev_*_ratelimited() family
Thread-Topic: [RFC 1/1] driver core: Add dev_*_ratelimited() family
Thread-Index: Ac0wLVNYgKik/WKuQXKu7tOhSigTIA==
Message-ID: <20120512.135227.1196366807162247040.hdoyu@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

An unclosed "if" statement in the MACRO seems a bit risky, but I don't
have any better/simple solution for this, ATM. Is there any alternative?


From: Hiroshi DOYU <hdoyu@nvidia.com>

Add dev_*_ratelimited() family, dev_* version of pr_*_ratelimited().

Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
---
 include/linux/device.h |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 8b9d03a..9d976df 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -23,6 +23,7 @@
 #include <linux/mutex.h>
 #include <linux/pm.h>
 #include <linux/atomic.h>
+#include <linux/ratelimit.h>
 #include <asm/device.h>
 
 struct device;
@@ -937,6 +938,27 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
 
 #endif
 
+#define IF_DEV_RATELIMITED						\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	if (__ratelimit(&_rs))
+
+#define dev_emerg_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_EMERG, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dev_alert_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_ALERT, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dev_crit_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_CRIT, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dev_err_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_ERR, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dev_warn_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_WARNING, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dev_notice_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_NOTICE, dev, fmt, ##__VA_ARGS__); } while (0)
+#define dev_info_ratelimited(dev, fmt, ...)				\
+	do { IF_DEV_RATELIMITED dev_printk(KERN_INFO, dev, fmt, ##__VA_ARGS__); } while (0)
+
 /*
  * Stupid hackaround for existing uses of non-printk uses dev_info
  *
-- 
1.7.5.4
