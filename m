Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1BIAiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 19:38:24 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55351 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab1BIAiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 19:38:22 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/5] ACPI / PM: Move references to pm_flags into sleep.c
Date: Wed, 9 Feb 2011 01:37:52 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Len Brown <len.brown@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102082220.25240.rjw@sisk.pl> <AANLkTinAZphXC=7FParFnxDPQvpB1ic=FwTe7u4Txy5o@mail.gmail.com>
In-Reply-To: <AANLkTinAZphXC=7FParFnxDPQvpB1ic=FwTe7u4Txy5o@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102090137.52697.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 09, 2011, Linus Torvalds wrote:
> On Tue, Feb 8, 2011 at 1:20 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > If direct references to pm_flags are moved from bus.c to sleep.c,
> > CONFIG_ACPI will not need to depend on CONFIG_PM any more.
> 
> The patch may _work_, but I really hate it. That function naming is insane:
> 
> >  #ifdef CONFIG_ACPI_SLEEP
> >  #else
> > +static inline bool acpi_pm_enabled(void) { return true; }
> 
> acpi_pm_enabled() returns true if ACPI_SLEEP is _not_ enabled? That's
> just crazy.
> 
> ... followed by more crazy:
> 
> > +bool acpi_pm_enabled(void)
> > +{
> > +       if (!(pm_flags & PM_APM)) {
> > +               pm_flags |= PM_ACPI;
> > +               return true;
> > +       }
> > +       return false;
> > +}
> 
> IOW, that function doesn't do anything _remotely_ like what the naming
> indicates.
> 
> Any sane person would expect that a function called
> 'acpi_pm_enabled()' would return true if ACPI PM was enabled, and
> false otherwise. But it's not what it does at all. Instead, what it
> does is to say "if APM isn't enabled, let's enable ACPI and return
> true". Except then for the non-ACPI sleep case, we just return true
> regardless, which still looks damn odd, wouldn't you say?
> 
> That isn't good. Maybe it all does what you want it to do, but from a
> code readability standpoint, it's just one honking big "WTF?". Please
> don't do that. Call it something else. Make the naming actually follow
> what the semantics are. Appropriate naming should also make it
> sensible to return "true" when ACPI_SLEEP is disabled, and should make
> the caller look sane.
> 
> Now, I don't know what that particular naming might be,

I had the same problem and I must admit I'm not good at inventing function
names.

> but maybe it would be about APM being enabled. Which is what the caller
> actually seems to care about and talks about for the failure case. Maybe
> you need separate functions for the "is APM enabled" case for the naming
> to make sense. Hmm?

That sounds like a good idea.  What about the following patch?

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / ACPI: Remove references to pm_flags from bus.c

If direct references to pm_flags are removed from drivers/acpi/bus.c,
CONFIG_ACPI will not need to depend on CONFIG_PM any more.  Make that
happen.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/acpi/Kconfig    |    1 -
 drivers/acpi/bus.c      |    7 ++++---
 include/linux/suspend.h |    6 ++++++
 kernel/power/main.c     |   12 +++++++++++-
 4 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -40,6 +40,7 @@
 #include <acpi/acpi_bus.h>
 #include <acpi/acpi_drivers.h>
 #include <linux/dmi.h>
+#include <linux/suspend.h>
 
 #include "internal.h"
 
@@ -1025,13 +1026,13 @@ static int __init acpi_init(void)
 
 	if (!result) {
 		pci_mmcfg_late_init();
-		if (!(pm_flags & PM_APM))
-			pm_flags |= PM_ACPI;
-		else {
+		if (pm_apm_enabled()) {
 			printk(KERN_INFO PREFIX
 			       "APM is already active, exiting\n");
 			disable_acpi();
 			result = -ENODEV;
+		} else {
+			pm_set_acpi_flag();
 		}
 	} else
 		disable_acpi();
Index: linux-2.6/drivers/acpi/Kconfig
===================================================================
--- linux-2.6.orig/drivers/acpi/Kconfig
+++ linux-2.6/drivers/acpi/Kconfig
@@ -7,7 +7,6 @@ menuconfig ACPI
 	depends on !IA64_HP_SIM
 	depends on IA64 || X86
 	depends on PCI
-	depends on PM
 	select PNP
 	default y
 	help
Index: linux-2.6/include/linux/suspend.h
===================================================================
--- linux-2.6.orig/include/linux/suspend.h
+++ linux-2.6/include/linux/suspend.h
@@ -272,6 +272,9 @@ extern int unregister_pm_notifier(struct
 	register_pm_notifier(&fn##_nb);			\
 }
 
+extern bool pm_apm_enabled(void);
+extern void pm_set_acpi_flag(void);
+
 /* drivers/base/power/wakeup.c */
 extern bool events_check_enabled;
 
@@ -292,6 +295,9 @@ static inline int unregister_pm_notifier
 
 #define pm_notifier(fn, pri)	do { (void)(fn); } while (0)
 
+static inline bool pm_apm_enabled(void) { return false; }
+static inline void pm_set_acpi_flag(void) {}
+
 static inline bool pm_wakeup_pending(void) { return false; }
 #endif /* !CONFIG_PM_SLEEP */
 
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -17,10 +17,20 @@
 
 DEFINE_MUTEX(pm_mutex);
 
+#ifdef CONFIG_PM_SLEEP
+
 unsigned int pm_flags;
 EXPORT_SYMBOL(pm_flags);
 
-#ifdef CONFIG_PM_SLEEP
+bool pm_apm_enabled(void)
+{
+	return !!(pm_flags & PM_APM);
+}
+
+void pm_set_acpi_flag(void)
+{
+	pm_flags |= PM_ACPI;
+}
 
 /* Routines for PM-transition notifications */
 

