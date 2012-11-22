Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2KVTbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:31:25 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:47167 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab2KVTbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:31:21 -0500
Date: Wed, 21 Nov 2012 19:11:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
Message-ID: <20121122031117.GE25470@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
 <1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
 <CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
 <20121121204324.21126.99677@nucleus>
 <20121121205424.GA25470@core.coreip.homeip.net>
 <20121121223859.GQ3290@n2100.arm.linux.org.uk>
 <20121122021750.GD25470@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122021750.GD25470@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 06:17:50PM -0800, Dmitry Torokhov wrote:
> On Wed, Nov 21, 2012 at 10:38:59PM +0000, Russell King - ARM Linux wrote:
> > On Wed, Nov 21, 2012 at 12:54:24PM -0800, Dmitry Torokhov wrote:
> > > On Wed, Nov 21, 2012 at 12:43:24PM -0800, Mike Turquette wrote:
> > > > Quoting Viresh Kumar (2012-11-20 02:13:55)
> > > > > On 20 November 2012 14:52, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> > > > > > We'll need to invoke clk_unprepare() via a pointer in our devm_*
> > > > > > conversion so let's uninline the pair.
> > > > > 
> > > > > Sorry, but you aren't doing this :(
> > > > > This routine is already uninlined as it is in clk.c
> > > > > 
> > > > > Instead you are just moving clk_prepare(), etc calls within
> > > > > #ifdef CONFIG_HAVE_CLK
> > > > > #else
> > > > > #endif
> > > > > 
> > > > > I doubt why they have been added under #ifdef CONFIG_HAVE_CLK_PREPARE
> > > > > earlier. Can they exist without CONFIG_HAVE_CLK
> > > > > 
> > > > > @Mike: ?
> > > > > 
> > > > 
> > > > HAVE_CLK logically wraps HAVE_CLK_PREPARE.  There is no point in
> > > > selecting HAVE_CLK_PREPARE without HAVE_CLK.
> > > > 
> > > > Looking through the code I see that this used to be the case.  Commit
> > > > 93abe8e "clk: add non CONFIG_HAVE_CLK routines" moved the
> > > > clk_(un)prepare declarations outside of #ifdef CONFIG_HAVE_CLK.  That
> > > > commit was authored by you.  Can you elaborate on why that aspect of the
> > > > patch was needed?
> > > > 
> > > 
> > > BTW, it looks like the only place where we select HAVE_CLK_PREPARE is
> > > IMX platform and it also selects COMMON_CLK so I think HAVE_CLK_PREPARE
> > > can be removed now.
> > 
> > You've checked non-ARM architectures too?
> 
> Yes:
> 
> [dtor@dtor-d630 linux-next]$ grep -r HAVE_CLK_PREPARE .
> ./arch/arm/Kconfig:     select HAVE_CLK_PREPARE
> Binary file ./.git/objects/pack/pack-7dad5ee164f601f1327dc78648fa317772c2d872.pack matches
> ./include/linux/clk.h:#ifdef CONFIG_HAVE_CLK_PREPARE
> ./include/linux/clk.h:#ifdef CONFIG_HAVE_CLK_PREPARE
> ./drivers/clk/Kconfig:config HAVE_CLK_PREPARE
> ./drivers/clk/Kconfig:  select HAVE_CLK_PREPARE
> 
> Thanks.
> 

So how about the one blow?

-- 
Dmitry

CLK: get rid of HAVE_CLK_PREPARE

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

HAVE_CLK_PREPARE is automatically selected by COMMON_CLK and the only
platform that explicitly selects HAVE_CLK_PREPARE is MXS which has been
switched to common clk framework, so we can delete this option now.

As part of this change we move declarations of clk_prepare() and
clk_unprepare() under HAVE_CLK and provide stubs if this option is not
enabled.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/clk/Kconfig |    4 ---
 include/linux/clk.h |   68 ++++++++++++++++++++++++---------------------------
 2 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index bace9e9..639ee9d 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -3,15 +3,11 @@ config CLKDEV_LOOKUP
 	bool
 	select HAVE_CLK
 
-config HAVE_CLK_PREPARE
-	bool
-
 config HAVE_MACH_CLKDEV
 	bool
 
 config COMMON_CLK
 	bool
-	select HAVE_CLK_PREPARE
 	select CLKDEV_LOOKUP
 	---help---
 	  The common clock framework is a single definition of struct
diff --git a/include/linux/clk.h b/include/linux/clk.h
index b3ac22d..f8204c3 100644
--- a/include/linux/clk.h
+++ b/include/linux/clk.h
@@ -84,42 +84,6 @@ int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
 
 #endif
 
-/**
- * clk_prepare - prepare a clock source
- * @clk: clock source
- *
- * This prepares the clock source for use.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-int clk_prepare(struct clk *clk);
-#else
-static inline int clk_prepare(struct clk *clk)
-{
-	might_sleep();
-	return 0;
-}
-#endif
-
-/**
- * clk_unprepare - undo preparation of a clock source
- * @clk: clock source
- *
- * This undoes a previously prepared clock.  The caller must balance
- * the number of prepare and unprepare calls.
- *
- * Must not be called from within atomic context.
- */
-#ifdef CONFIG_HAVE_CLK_PREPARE
-void clk_unprepare(struct clk *clk);
-#else
-static inline void clk_unprepare(struct clk *clk)
-{
-	might_sleep();
-}
-#endif
-
 #ifdef CONFIG_HAVE_CLK
 /**
  * clk_get - lookup and obtain a reference to a clock producer.
@@ -159,6 +123,27 @@ struct clk *clk_get(struct device *dev, const char *id);
 struct clk *devm_clk_get(struct device *dev, const char *id);
 
 /**
+ * clk_prepare - prepare a clock source
+ * @clk: clock source
+ *
+ * This prepares the clock source for use.
+ *
+ * Must not be called from within atomic context.
+ */
+int clk_prepare(struct clk *clk);
+
+/**
+ * clk_unprepare - undo preparation of a clock source
+ * @clk: clock source
+ *
+ * This undoes a previously prepared clock.  The caller must balance
+ * the number of prepare and unprepare calls.
+ *
+ * Must not be called from within atomic context.
+ */
+void clk_unprepare(struct clk *clk);
+
+/**
  * clk_enable - inform the system when the clock source should be running.
  * @clk: clock source
  *
@@ -292,6 +277,17 @@ static inline void clk_put(struct clk *clk) {}
 
 static inline void devm_clk_put(struct device *dev, struct clk *clk) {}
 
+static inline int clk_prepare(struct clk *clk)
+{
+	might_sleep();
+	return 0;
+}
+
+static inline void clk_unprepare(struct clk *clk)
+{
+	might_sleep();
+}
+
 static inline int clk_enable(struct clk *clk)
 {
 	return 0;
