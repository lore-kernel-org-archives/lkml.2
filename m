Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1HOUos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:44:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab1HOUoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:44:46 -0400
Date: Mon, 15 Aug 2011 16:44:38 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@suse.de, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11 re-post take #2] dynamic_debug: consolidate
 repetitive struct _ddebug descriptor definitions
Message-ID: <20110815204438.GA7157@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
 <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
 <1313089327.13877.11.camel@Joe-Laptop>
 <20110811205253.GC6670@redhat.com>
 <1313131164.27549.18.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313131164.27549.18.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Joe,

On Thu, Aug 11, 2011 at 11:39:24PM -0700, Joe Perches wrote:
> On Thu, 2011-08-11 at 16:52 -0400, Jason Baron wrote:
> > Replace the repetitive struct _ddebug descriptor definitions with
> > a new DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt) macro.
> []
> > diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> []
> > @@ -54,33 +54,28 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
> >  			     const char *fmt, ...)
> >  	__attribute__ ((format (printf, 3, 4)));
> >  
> > +#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> > +	static struct _ddebug name				\
> > +	__used							\
> > +	__attribute__((section("__verbose"), aligned(8))) =	\
> > +	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
> > +		_DPRINTK_FLAGS_DEFAULT }
> 
> Hey again Jason.
> 
> From a kernel coding style consistency POV, shouldn't
> this use c99 named initializers?

yes, that would be better than what we have now.

> 
> #define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)			\
> 	static struct _ddebug name = {					\
> 		.modname = KBUILD_MODNAME,				\
> 		.function = __func__,					\
> 		.filename = __FILE__,					\
> 		.format = fmt,						\
> 		.lineno = __LINE__,					\
> 		.flags =  _DPRINTK_FLAGS_DEFAULT,			\
> 		.enabled = false,					\
> 	} __used __aligned(8) __attribute__((section("__verbose")))
> 
> If the pr_debug/dynamic_debug inversion is done,
> the .enabled flag should be set on as well when
> -DDEBUG is set, correct?

right, but I'm leaving this to a subsequent patch.

> 
> >  #define dynamic_pr_debug(fmt, ...) do {					\
> > -	static struct _ddebug descriptor				\
> > -	__used								\
> > -	__attribute__((section("__verbose"), aligned(8))) =		\
> > -	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> > -		_DPRINTK_FLAGS_DEFAULT };				\
> > +	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
> >  	if (unlikely(descriptor.enabled))				\
> > -		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
> > +		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
> >  	} while (0)
> 
> Perhaps
> 
> #define dynamic_pr_debug(fmt, ...)					\
> do {									\
> 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
> 	if (unlikely(descriptor.enabled))				\
> 		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),		\
> 				   ##__VA_ARGS__);			\
> } while (0)

ok.

> 
> Lastly, are the unlikely()s really useful?
> 

I think the unlikely's make sense, since we don't expect these to be
enabled by default.

So, I've re-spun the patch, with the above comments (below). Thanks!

-Jason

Replace the repetitive  struct _ddebug descriptor definitions with
a new DECLARE_DYNAMIC_DEBUG_META_DATA(name, fmt) macro.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 include/linux/dynamic_debug.h |   64 ++++++++++++++++++++++------------------
 1 files changed, 35 insertions(+), 29 deletions(-)

diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index feaac1e..699f533 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -54,35 +54,41 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
-#define dynamic_pr_debug(fmt, ...) do {					\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
-	} while (0)
-
-#define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
-	} while (0)
-
-#define dynamic_netdev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
-		__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
-	} while (0)
+#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+	static struct _ddebug __used __aligned(8)		\
+	__attribute__((section("__verbose"))) name = {		\
+		.modname = KBUILD_MODNAME,			\
+		.function = __func__,				\
+		.filename = __FILE__,				\
+		.format = fmt,					\
+		.lineno = __LINE__,				\
+		.flags =  _DPRINTK_FLAGS_DEFAULT,		\
+		.enabled = false,				\
+	}
+
+#define dynamic_pr_debug(fmt, ...)				\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt),	\
+				   ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_dev_dbg(dev, fmt, ...)				\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_dev_dbg(&descriptor, dev, fmt,	\
+				  ##__VA_ARGS__);		\
+} while (0)
+
+#define dynamic_netdev_dbg(dev, fmt, ...)			\
+do {								\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);	\
+	if (unlikely(descriptor.enabled))			\
+		__dynamic_netdev_dbg(&descriptor, dev, fmt,	\
+				     ##__VA_ARGS__);		\
+} while (0)
 
 #else
 
-- 
1.7.5.4

