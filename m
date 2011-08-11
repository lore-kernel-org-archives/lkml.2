Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab1HKUxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 16:53:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753718Ab1HKUw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 16:52:59 -0400
Date: Thu, 11 Aug 2011 16:52:53 -0400
From: Jason Baron <jbaron@redhat.com>
To: Joe Perches <joe@perches.com>, gregkh@suse.de
Cc: jim.cromie@gmail.com, bvanassche@acm.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/11 re-post] dynamic_debug: consolidate repetitive
 struct _ddebug descriptor definitions
Message-ID: <20110811205253.GC6670@redhat.com>
References: <cover.1313085588.git.jbaron@redhat.com>
 <88ee1dfb582d4b2dbdcfa93eeaa61a2ad531bd1e.1313085588.git.jbaron@redhat.com>
 <1313089327.13877.11.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313089327.13877.11.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 12:02:06PM -0700, Joe Perches wrote:
> > From: Jason Baron <jbaron@redhat.com>
> > Replace the repetitive  struct _ddebug descriptor definitions with
> > a new DYNAMIC_DEBUG_META_DATA(fmt) macro.
> 
> Hey Jason.
> 
> I think some improvements can be made to this one.
> 
> > diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> []
> > @@ -54,33 +54,28 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
> >  			     const char *fmt, ...)
> >  	__attribute__ ((format (printf, 3, 4)));
> >  
> > +#define DYNAMIC_DEBUG_METADATA(fmt)				\
> > +	static struct _ddebug descriptor			\
> > +	__used							\
> > +	__attribute__((section("__verbose"), aligned(8))) =	\
> > +	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
> > +		_DPRINTK_FLAGS_DEFAULT };
> > +
> 
> I think this is unclear and should be:
> 
> #define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
> 	static struct _ddebug name				\
> 	__used							\
> 	__attribute__((section("__verbose"), aligned(8))) =	\
> 	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
> 		_DPRINTK_FLAGS_DEFAULT }
> 
> (extra semicolon at end removed)
> 
> so the uses become:
> 
> >  #define dynamic_dev_dbg(dev, fmt, ...) do {				\
> > -	static struct _ddebug descriptor				\
> > -	__used								\
> > -	__attribute__((section("__verbose"), aligned(8))) =		\
> > -	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
> > -		_DPRINTK_FLAGS_DEFAULT };				\
> > +	DYNAMIC_DEBUG_METADATA(fmt);					\
> 
> 	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);
> 
> >  	if (unlikely(descriptor.enabled))				\
> > -		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
> > +		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
> >  	} while (0)
> 
> so then there aren't any magic variable names.
> 
> cheers, Joe
> 

Ok, Thanks for the review. Here's a re-post of it:

From: Jason Baron <jbaron@redhat.com>

Replace the repetitive struct _ddebug descriptor definitions with
a new DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt) macro.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---

 include/linux/dynamic_debug.h |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)


diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
index feaac1e..d1a78b2 100644
--- a/include/linux/dynamic_debug.h
+++ b/include/linux/dynamic_debug.h
@@ -54,33 +54,28 @@ extern int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 			     const char *fmt, ...)
 	__attribute__ ((format (printf, 3, 4)));
 
+#define DECLARE_DYNAMIC_DEBUG_METADATA(name, fmt)		\
+	static struct _ddebug name				\
+	__used							\
+	__attribute__((section("__verbose"), aligned(8))) =	\
+	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,	\
+		_DPRINTK_FLAGS_DEFAULT }
+
 #define dynamic_pr_debug(fmt, ...) do {					\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
 	if (unlikely(descriptor.enabled))				\
-		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__); \
+		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
 	} while (0)
 
 #define dynamic_dev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		\
 	if (unlikely(descriptor.enabled))				\
-		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);	\
+		__dynamic_dev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
 	} while (0)
 
-#define dynamic_netdev_dbg(dev, fmt, ...) do {				\
-	static struct _ddebug descriptor				\
-	__used								\
-	__attribute__((section("__verbose"), aligned(8))) =		\
-	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
-		_DPRINTK_FLAGS_DEFAULT };				\
-	if (unlikely(descriptor.enabled))				\
+#define dynamic_netdev_dbg(dev, fmt, ...) do {				   \
+	DECLARE_DYNAMIC_DEBUG_METADATA(descriptor, fmt);		   \
+	if (unlikely(descriptor.enabled))				   \
 		__dynamic_netdev_dbg(&descriptor, dev, fmt, ##__VA_ARGS__);\
 	} while (0)
 
