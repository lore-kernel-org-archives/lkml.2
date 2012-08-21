Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753787Ab2HUHCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:02:13 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2609 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2HUHCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:02:11 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 21 Aug 2012 00:02:10 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "crope@iki.fi" <crope@iki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "htl10@users.sourceforge.net" <htl10@users.sourceforge.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "joe@perches.com" <joe@perches.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Tue, 21 Aug 2012 09:02:04 +0200
Subject: Re: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited() without
 DEBUG
Thread-Topic: [PATCH 1/1] driver-core: Shut up dev_dbg_reatelimited()
 without DEBUG
Thread-Index: Ac1/auAQk2KAMex3QGmTPb7APmHUYA==
Message-ID: <20120821.100204.446226016699627525.hdoyu@nvidia.com>
References: <502EDDCC.200@iki.fi><20120820.141454.449841061737873578.hdoyu@nvidia.com><5032AC3E.5080402@iki.fi>
In-Reply-To: <5032AC3E.5080402@iki.fi>
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

Antti Palosaari <crope@iki.fi> wrote @ Mon, 20 Aug 2012 23:29:34 +0200:

> On 08/20/2012 02:14 PM, Hiroshi Doyu wrote:
> > Hi Antti,
> >
> > Antti Palosaari <crope@iki.fi> wrote @ Sat, 18 Aug 2012 02:11:56 +0200:
> >
> >> On 08/17/2012 09:04 AM, Hiroshi Doyu wrote:
> >>> dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
> >>> suppressed". This shouldn't print anything without DEBUG.
> >>>
> >>> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> >>> Reported-by: Antti Palosaari <crope@iki.fi>
> >>> ---
> >>>    include/linux/device.h |    6 +++++-
> >>>    1 files changed, 5 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/include/linux/device.h b/include/linux/device.h
> >>> index eb945e1..d4dc26e 100644
> >>> --- a/include/linux/device.h
> >>> +++ b/include/linux/device.h
> >>> @@ -962,9 +962,13 @@ do {									\
> >>>    	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
> >>>    #define dev_info_ratelimited(dev, fmt, ...)				\
> >>>    	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
> >>> +#if defined(DEBUG)
> >>>    #define dev_dbg_ratelimited(dev, fmt, ...)				\
> >>>    	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
> >>> -
> >>> +#else
> >>> +#define dev_dbg_ratelimited(dev, fmt, ...)			\
> >>> +	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
> >>> +#endif
> >>>    /*
> >>>     * Stupid hackaround for existing uses of non-printk uses dev_info
> >>>     *
> >>>
> >>
> >> NACK. I don't think that's correct behavior. After that patch it kills
> >> all output of dev_dbg_ratelimited(). If I use dynamic debugs and order
> >> debugs, I expect to see debugs as earlier.
> >
> > You are right. I attached the update patch, just moving *_ratelimited
> > functions after dev_dbg() definitions.
> >
> > With DEBUG defined/undefined in your "test.ko", it works fine. With
> > CONFIG_DYNAMIC_DEBUG, it works with "+p", but with "-p", still
> > "..callbacks suppressed" is printed.
> 
> I am using dynamic debugs and behavior is now just same as it was when 
> reported that bug. OK, likely for static debug it is now correct.

The following patch can also refrain "..callbacks suppressed" with
"-p". I think that it's ok for all cases.

>From b4c6aa9160f03b61ed17975c73db36c983a48927 Mon Sep 17 00:00:00 2001
From: Hiroshi Doyu <hdoyu@nvidia.com>
Date: Mon, 20 Aug 2012 13:49:19 +0300
Subject: [v3 1/1] driver-core: Shut up dev_dbg_reatelimited() without DEBUG

dev_dbg_reatelimited() without DEBUG printed "217078 callbacks
suppressed". This shouldn't print anything without DEBUG.

With CONFIG_DYNAMIC_DEBUG, the print should be configured as expected.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
Reported-by: Antti Palosaari <crope@iki.fi>
---
 include/linux/device.h |   62 +++++++++++++++++++++++++++++------------------
 1 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/include/linux/device.h b/include/linux/device.h
index 9648331..bb6ffcb 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -932,6 +932,32 @@ int _dev_info(const struct device *dev, const char *fmt, ...)
 
 #endif
 
+/*
+ * Stupid hackaround for existing uses of non-printk uses dev_info
+ *
+ * Note that the definition of dev_info below is actually _dev_info
+ * and a macro is used to avoid redefining dev_info
+ */
+
+#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
+
+#if defined(CONFIG_DYNAMIC_DEBUG)
+#define dev_dbg(dev, format, ...)		     \
+do {						     \
+	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
+} while (0)
+#elif defined(DEBUG)
+#define dev_dbg(dev, format, arg...)		\
+	dev_printk(KERN_DEBUG, dev, format, ##arg)
+#else
+#define dev_dbg(dev, format, arg...)				\
+({								\
+	if (0)							\
+		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
+	0;							\
+})
+#endif
+
 #define dev_level_ratelimited(dev_level, dev, fmt, ...)			\
 do {									\
 	static DEFINE_RATELIMIT_STATE(_rs,				\
@@ -955,33 +981,21 @@ do {									\
 	dev_level_ratelimited(dev_notice, dev, fmt, ##__VA_ARGS__)
 #define dev_info_ratelimited(dev, fmt, ...)				\
 	dev_level_ratelimited(dev_info, dev, fmt, ##__VA_ARGS__)
+#if defined(CONFIG_DYNAMIC_DEBUG) || defined(DEBUG)
 #define dev_dbg_ratelimited(dev, fmt, ...)				\
-	dev_level_ratelimited(dev_dbg, dev, fmt, ##__VA_ARGS__)
-
-/*
- * Stupid hackaround for existing uses of non-printk uses dev_info
- *
- * Note that the definition of dev_info below is actually _dev_info
- * and a macro is used to avoid redefining dev_info
- */
-
-#define dev_info(dev, fmt, arg...) _dev_info(dev, fmt, ##arg)
-
-#if defined(CONFIG_DYNAMIC_DEBUG)
-#define dev_dbg(dev, format, ...)		     \
-do {						     \
-	dynamic_dev_dbg(dev, format, ##__VA_ARGS__); \
+do {									\
+	static DEFINE_RATELIMIT_STATE(_rs,				\
+				      DEFAULT_RATELIMIT_INTERVAL,	\
+				      DEFAULT_RATELIMIT_BURST);		\
+	DEFINE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);			\
+	if (unlikely(descriptor.flags & _DPRINTK_FLAGS_PRINT) &&	\
+	    __ratelimit(&_rs))						\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
+				   ##__VA_ARGS__);			\
 } while (0)
-#elif defined(DEBUG)
-#define dev_dbg(dev, format, arg...)		\
-	dev_printk(KERN_DEBUG, dev, format, ##arg)
 #else
-#define dev_dbg(dev, format, arg...)				\
-({								\
-	if (0)							\
-		dev_printk(KERN_DEBUG, dev, format, ##arg);	\
-	0;							\
-})
+#define dev_dbg_ratelimited(dev, fmt, ...)			\
+	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
 #ifdef VERBOSE_DEBUG
-- 
1.7.5.4
