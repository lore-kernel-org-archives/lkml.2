Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832Ab0FMFay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 01:30:54 -0400
Received: from mail.perches.com ([173.55.12.10]:1103 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0FMFaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 01:30:52 -0400
Subject: Re: [PATCH] staging:comedi: Fixed coding convention issues.
From: Joe Perches <joe@perches.com>
To: Mark Rankilor <reodge@gmail.com>
Cc: devel@driverdev.osuosl.org,
       Henri =?ISO-8859-1?Q?H=E4kkinen?= <henuxd@gmail.com>, gregkh@suse.de,
       andrea.gelmini@gelma.net, linux-kernel@vger.kernel.org
In-Reply-To: <1276405626.1449.26.camel@Joe-Laptop.home>
References: <1276337681-4327-1-git-send-email-henuxd@gmail.com>
	 <AANLkTimUt_Lhk6lG9spM9qjRT8T6PhEDVyOhh745lJhW@mail.gmail.com>
	 <1276405626.1449.26.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 22:30:50 -0700
Message-ID: <1276407050.1449.28.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-12 at 22:07 -0700, Joe Perches wrote:
> 2: Create some comedi logging functions or macros like:
>    	comedi_<level>(fmt, arg...) (ie: comedi_info, comedi_err, etc)
>    where "comedi:" is always prefixed and an
>    optional #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>    could be used.

Maybe this is a start:

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/comedi/comedidev.h |   54 ++++++++++++++++++++++++++++++++++--
 1 files changed, 51 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 4eb2b77..6c2bdde 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -43,11 +43,59 @@
 
 #include "comedi.h"
 
-#define DPRINTK(format, args...)	do {		\
-	if (comedi_debug)				\
-		printk(KERN_DEBUG "comedi: " format , ## args);	\
+#define comedi_printk(level, fmt, args...)			\
+	printk(level "comedi: " pr_fmt(fmt), ##args)
+
+#define DPRINTK(format, args...)				\
+do {								\
+	if (comedi_debug)					\
+		comedi_printk(KERN_DEBUG, fmt, ##args);		\
 } while (0)
 
+#define comedi_emerg(fmt, ...)				\
+	comedi_printk(KERN_EMERG, fmt, ##__VA_ARGS__)
+#define comedi_alert(fmt, ...)				\
+	comedi_printk(KERN_ALERT, fmt, ##__VA_ARGS__)
+#define comedi_crit(fmt, ...)				\
+	comedi_printk(KERN_CRIT, fmt, ##__VA_ARGS__)
+#define comedi_err(fmt, ...)				\
+	comedi_printk(KERN_ERR, fmt, ##__VA_ARGS__)
+#define comedi_warn(fmt, ...)				\
+	comedi_printk(KERN_WARNING, fmt, ##__VA_ARGS__)
+#define comedi_notice(fmt, ...)				\
+	comedi_printk(KERN_NOTICE, fmt, ##__VA_ARGS__)
+#define comedi_info(fmt, ...)				\
+	comedi_printk(KERN_INFO, fmt, ##__VA_ARGS__)
+
+/* comedi_devel() should produce zero code unless DEBUG is defined */
+#ifdef DEBUG
+#define comedi_devel(fmt, ...)				\
+	comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__)
+#else
+#define comedi_devel(fmt, ...)					\
+({								\
+	if (0)							\
+		comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__);	\
+	0;							\
+})
+#endif
+
+#if defined(DEBUG)
+#define comedi_debug(fmt, ...)				\
+	comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__)
+#elif defined(CONFIG_DYNAMIC_DEBUG)
+/* dynamic_pr_debug() uses pr_fmt() internally so we don't need it here */
+#define comedi_debug(fmt, ...)				\
+	dynamic_pr_debug(fmt, ##__VA_ARGS__)
+#else
+#define comedi_debug(fmt, ...)					\
+({								\
+	if (0)							\
+		comedi_printk(KERN_DEBUG, fmt, ##__VA_ARGS__);	\
+	0;							\
+})
+#endif
+
 #define COMEDI_VERSION(a, b, c) (((a) << 16) + ((b) << 8) + (c))
 #define COMEDI_VERSION_CODE COMEDI_VERSION(COMEDI_MAJORVERSION, \
 	COMEDI_MINORVERSION, COMEDI_MICROVERSION)


