Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0GMVzo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 17:55:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756362Ab0GMVzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 17:55:42 -0400
Date: Tue, 13 Jul 2010 17:55:29 -0400
From: Jason Baron <jbaron@redhat.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] introduce a default off mode for kmemleak
Message-ID: <20100713215528.GB25784@redhat.com>
References: <20100713203116.GA25784@redhat.com> <1279054932.16438.3.camel@e102109-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279054932.16438.3.camel@e102109-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 10:02:12PM +0100, Catalin Marinas wrote:
> Hi Jason,
> 
> On Tue, 2010-07-13 at 21:31 +0100, Jason Baron wrote:
> > Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
> > kmemleak to be disabled by default, but enabled on the command line via:
> > kmemleak=on. Although a reboot is required to turn it on, its still
> > useful to not require a re-compile.
> > 
> > Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> The patch makes sense. I have a few comments below.
> 
> > diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> > index 2c0d032..1006267 100644
> > --- a/mm/kmemleak.c
> > +++ b/mm/kmemleak.c
> > @@ -211,6 +211,11 @@ static signed long jiffies_scan_wait;
> >  static int kmemleak_stack_scan = 1;
> >  /* protects the memory scanning, parameters and debug/kmemleak file access */
> >  static DEFINE_MUTEX(scan_mutex);
> > +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> > +/* setting kmemleak=on, will set this var, skipping the disable */
> > +static int kmemleak_skip_disable;
> > +#endif
> 
> Can we have kmemleak_skip_disable always and remove the #ifdef?
> 
> > @@ -1600,10 +1605,22 @@ static int kmemleak_boot_config(char *str)
> >  {
> >         if (!str)
> >                 return -EINVAL;
> > +
> >         if (strcmp(str, "off") == 0)
> > +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> > +               return -EINVAL;
> > +#else
> >                 kmemleak_disable();
> > -       else if (strcmp(str, "on") != 0)
> > +#endif
> > +       else if (strcmp(str, "on") == 0)
> > +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> > +               kmemleak_skip_disable = 1;
> > +#else
> > +               return -EINVAL;
> > +#endif
> > +       else
> >                 return -EINVAL;
> > +
> >         return 0;
> >  }
> 
> Here I would remove all these #ifdef's. It doesn't really matter if you
> pass kmemleak=off/on on the command line and kmemleak was already
> disable/enabled. If we remove the #ifdef for the kmemleak_skip_disable,
> we can always set the variable here.
> 
> > @@ -1616,6 +1633,13 @@ void __init kmemleak_init(void)
> >         int i;
> >         unsigned long flags;
> > 
> > +#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
> > +       if (!kmemleak_skip_disable) {
> > +               kmemleak_disable();
> > +               return;
> > +       }
> > +#endif
> 
> That's the only place where we could keep the #ifdef.
> 
> Thanks.
> 
> -- 
> Catalin
> 

Ok. re-vised patch is below.

thanks,

-Jason

Introduce a new DEBUG_KMEMLEAK_DEFAULT_OFF config parameter that allows
kmemleak to be disabled by default, but enabled on the command line
via: kmemleak=on. Although a reboot is required to turn it on, its still
useful to not require a re-compile.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 lib/Kconfig.debug |    7 +++++++
 mm/kmemleak.c     |   14 +++++++++++++-
 2 files changed, 20 insertions(+), 1 deletions(-)

diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index e722e9d..95ab402 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -400,6 +400,13 @@ config DEBUG_KMEMLEAK_TEST
 
 	  If unsure, say N.
 
+config DEBUG_KMEMLEAK_DEFAULT_OFF
+	bool "Default kmemleak to off"
+	depends on DEBUG_KMEMLEAK
+	help
+	  Say Y here to disable kmemleak by default. It can then be enabled
+	  on the command line via kmemleak=on.
+
 config DEBUG_PREEMPT
 	bool "Debug preemptible kernel"
 	depends on DEBUG_KERNEL && PREEMPT && TRACE_IRQFLAGS_SUPPORT
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 2c0d032..c7ff733 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -211,6 +211,9 @@ static signed long jiffies_scan_wait;
 static int kmemleak_stack_scan = 1;
 /* protects the memory scanning, parameters and debug/kmemleak file access */
 static DEFINE_MUTEX(scan_mutex);
+/* setting kmemleak=on, will set this var, skipping the disable */
+static int kmemleak_skip_disable;
+
 
 /*
  * Early object allocation/freeing logging. Kmemleak is initialized after the
@@ -1602,7 +1605,9 @@ static int kmemleak_boot_config(char *str)
 		return -EINVAL;
 	if (strcmp(str, "off") == 0)
 		kmemleak_disable();
-	else if (strcmp(str, "on") != 0)
+	else if (strcmp(str, "on") == 0)
+		kmemleak_skip_disable = 1;
+	else
 		return -EINVAL;
 	return 0;
 }
@@ -1616,6 +1621,13 @@ void __init kmemleak_init(void)
 	int i;
 	unsigned long flags;
 
+#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
+	if (!kmemleak_skip_disable) {
+		kmemleak_disable();
+		return;
+	}
+#endif
+
 	jiffies_min_age = msecs_to_jiffies(MSECS_MIN_AGE);
 	jiffies_scan_wait = msecs_to_jiffies(SECS_SCAN_WAIT * 1000);
 
-- 
1.7.1

