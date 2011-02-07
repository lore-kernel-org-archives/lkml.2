Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828Ab1BGVQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:16:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51521 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754524Ab1BGVQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:16:35 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] PM: Hide CONFIG_PM from users
Date: Mon, 7 Feb 2011 22:15:59 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc3+; KDE/4.4.4; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-embedded@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
References: <1297081335-13631-1-git-send-email-broonie@opensource.wolfsonmicro.com> <201102072046.48763.rjw@sisk.pl> <20110207201803.GU10564@opensource.wolfsonmicro.com>
In-Reply-To: <20110207201803.GU10564@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102072215.59921.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, February 07, 2011, Mark Brown wrote:
> On Mon, Feb 07, 2011 at 08:46:48PM +0100, Rafael J. Wysocki wrote:
> > On Monday, February 07, 2011, Mark Brown wrote:
> > > On Mon, Feb 07, 2011 at 08:14:03PM +0100, Rafael J. Wysocki wrote:
> 
> > > > I think it would be better to simply rename CONFIG_PM_OPS into CONFIG_PM.
> 
> > > That still leaves the IA64 emulator to worry about
> 
> > Why exactly?
> 
> Actually not so much the IA64 emulator (which does have the !PM
> dependency declared already - I expect that'd just be moved) as any
> other platforms with an undeclared dependency on !PM.

If they depend on !PM, they cannot set PM_SLEEP or PM_RUNTIME, right?
So, if PM is defined as PM_SLEEP || PM_RUNTIME, everything should be fine
in that respect I suppose.

> > > but I'm not fundamentally opposed to that, it achieves a similar effect.  The
> > > main thing I'm looking for here is to cut down on the configuration options
> > > we have to maintain.
> 
> > But I must say you chose a particularly bad time for that from my point of view.
> 
> This doesn't seem like it's a worse time than any other?

It is, because I'm working on some other changes right now that this interferes
with quite a bit.  Whatever.

> > > > However, there's a number of things that I'm afraid wouldn't build correctly
> > > > if none of CONFIG_PM_SLEEP and CONFIG_PM_RUNTIME were set in that case.
> 
> > > Actually CONFIG_PM_OPS probably also wants to be on independantly of
> > > those two sometimes for .poweroff() which I'd expect to run even if we
> > > can't suspend.
> 
> > If you worry about that, then add CONFIG_PM_POWEROFF and make CONFIG_PM(_OPS)
> > depend on it, but I don't think it really is worth it, because people
> > generally don't make the poweroff code depend on CONFIG_PM.
> 
> Yeah, but some people seem very keen on removing the pointers to the PM
> ops entirely when CONFIG_PM is disabled which means that you end up with
> varying idioms for what you do with the PM ops as stuff gets ifdefed
> out.  Then again I'm not sure anything would make those people any
> happier.

I really think we should do things that makes sense rather that worry about
who's going to like or dislike it (except for Linus maybe, but he tends to like
things that make sense anyway).  At this point I think the change I suggested
makes sense, because it (a) simplifies things and (b) follows the quite common
practice which is to make PM callbacks depend on CONFIG_PM.

Anyway, below is a proof-of-concept patch.  It builds for me with a few
different combinations of the relevant options, but YMMV.  It probably
should be split into two or three patches for merging, but I guess a single
patch is better for testing.  Please let me know if there are any problems
with it.

I'd appreciate it if people could review/test it and drop their comments.

Thanks,
Rafael

---
 arch/x86/xen/Kconfig               |    2 +-
 drivers/acpi/Kconfig               |    1 -
 drivers/acpi/bus.c                 |    4 +---
 drivers/acpi/internal.h            |    6 ++++++
 drivers/acpi/sleep.c               |   13 +++++++++++--
 drivers/base/power/Makefile        |    3 +--
 drivers/net/e1000e/netdev.c        |    8 ++++----
 drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
 drivers/pci/pci-driver.c           |    4 ++--
 drivers/scsi/Makefile              |    2 +-
 drivers/scsi/scsi_priv.h           |    2 +-
 drivers/scsi/scsi_sysfs.c          |    2 +-
 drivers/usb/core/hcd-pci.c         |    4 ++--
 include/acpi/acpi_bus.h            |    2 +-
 include/linux/pm.h                 |    2 +-
 kernel/power/Kconfig               |   29 +++--------------------------
 16 files changed, 37 insertions(+), 49 deletions(-)

Index: linux-2.6/kernel/power/Kconfig
===================================================================
--- linux-2.6.orig/kernel/power/Kconfig
+++ linux-2.6/kernel/power/Kconfig
@@ -1,24 +1,3 @@
-config PM
-	bool "Power Management support"
-	depends on !IA64_HP_SIM
-	---help---
-	  "Power Management" means that parts of your computer are shut
-	  off or put into a power conserving "sleep" mode if they are not
-	  being used.  There are two competing standards for doing this: APM
-	  and ACPI.  If you want to use either one, say Y here and then also
-	  to the requisite support below.
-
-	  Power Management is most important for battery powered laptop
-	  computers; if you have a laptop, check out the Linux Laptop home
-	  page on the WWW at <http://www.linux-on-laptops.com/> or
-	  Tuxmobil - Linux on Mobile Computers at <http://www.tuxmobil.org/>
-	  and the Battery Powered Linux mini-HOWTO, available from
-	  <http://www.tldp.org/docs.html#howto>.
-
-	  Note that, even if you say N here, Linux on the x86 architecture
-	  will issue the hlt instruction if nothing is to be done, thereby
-	  sending the processor to sleep and saving power.
-
 config PM_DEBUG
 	bool "Power Management Debug Support"
 	depends on PM
@@ -102,7 +81,7 @@ config PM_SLEEP_ADVANCED_DEBUG
 
 config SUSPEND
 	bool "Suspend to RAM and standby"
-	depends on PM && ARCH_SUSPEND_POSSIBLE
+	depends on ARCH_SUSPEND_POSSIBLE
 	default y
 	---help---
 	  Allow the system to enter sleep states in which main memory is
@@ -133,7 +112,7 @@ config SUSPEND_FREEZER
 
 config HIBERNATION
 	bool "Hibernation (aka 'suspend to disk')"
-	depends on PM && SWAP && ARCH_HIBERNATION_POSSIBLE
+	depends on SWAP && ARCH_HIBERNATION_POSSIBLE
 	select LZO_COMPRESS
 	select LZO_DECOMPRESS
 	---help---
@@ -224,7 +203,6 @@ config APM_EMULATION
 
 config PM_RUNTIME
 	bool "Run-time PM core functionality"
-	depends on PM
 	---help---
 	  Enable functionality allowing I/O devices to be put into energy-saving
 	  (low power) states at run time (or autosuspended) after a specified
@@ -236,7 +214,7 @@ config PM_RUNTIME
 	  responsible for the actual handling of the autosuspend requests and
 	  wake-up events.
 
-config PM_OPS
+config PM
 	bool
 	depends on PM_SLEEP || PM_RUNTIME
 	default y
@@ -246,7 +224,6 @@ config ARCH_HAS_OPP
 
 config PM_OPP
 	bool "Operating Performance Point (OPP) Layer library"
-	depends on PM
 	depends on ARCH_HAS_OPP
 	---help---
 	  SOCs have a standard set of tuples consisting of frequency and
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
Index: linux-2.6/arch/x86/xen/Kconfig
===================================================================
--- linux-2.6.orig/arch/x86/xen/Kconfig
+++ linux-2.6/arch/x86/xen/Kconfig
@@ -38,7 +38,7 @@ config XEN_MAX_DOMAIN_MEMORY
 
 config XEN_SAVE_RESTORE
        bool
-       depends on XEN && PM
+       depends on XEN
        default y
 
 config XEN_DEBUG_FS
Index: linux-2.6/drivers/net/e1000e/netdev.c
===================================================================
--- linux-2.6.orig/drivers/net/e1000e/netdev.c
+++ linux-2.6/drivers/net/e1000e/netdev.c
@@ -5307,7 +5307,7 @@ void e1000e_disable_aspm(struct pci_dev
 	__e1000e_disable_aspm(pdev, state);
 }
 
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 static bool e1000e_pm_ready(struct e1000_adapter *adapter)
 {
 	return !!adapter->tx_ring->buffer_info;
@@ -5458,7 +5458,7 @@ static int e1000_runtime_resume(struct d
 	return __e1000_resume(pdev);
 }
 #endif /* CONFIG_PM_RUNTIME */
-#endif /* CONFIG_PM_OPS */
+#endif /* CONFIG_PM */
 
 static void e1000_shutdown(struct pci_dev *pdev)
 {
@@ -6164,7 +6164,7 @@ static DEFINE_PCI_DEVICE_TABLE(e1000_pci
 };
 MODULE_DEVICE_TABLE(pci, e1000_pci_tbl);
 
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 static const struct dev_pm_ops e1000_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(e1000_suspend, e1000_resume)
 	SET_RUNTIME_PM_OPS(e1000_runtime_suspend,
@@ -6178,7 +6178,7 @@ static struct pci_driver e1000_driver =
 	.id_table = e1000_pci_tbl,
 	.probe    = e1000_probe,
 	.remove   = __devexit_p(e1000_remove),
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 	.driver.pm = &e1000_pm_ops,
 #endif
 	.shutdown = e1000_shutdown,
Index: linux-2.6/drivers/acpi/sleep.c
===================================================================
--- linux-2.6.orig/drivers/acpi/sleep.c
+++ linux-2.6/drivers/acpi/sleep.c
@@ -567,7 +567,7 @@ int acpi_suspend(u32 acpi_state)
 	return -EINVAL;
 }
 
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 /**
  *	acpi_pm_device_sleep_state - return preferred power state of ACPI device
  *		in the system sleep state given by %acpi_target_sleep_state
@@ -653,9 +653,18 @@ int acpi_pm_device_sleep_state(struct de
 		*d_min_p = d_min;
 	return d_max;
 }
-#endif /* CONFIG_PM_OPS */
+#endif /* CONFIG_PM */
 
 #ifdef CONFIG_PM_SLEEP
+bool acpi_set_pm_flag(void)
+{
+	if (!(pm_flags & PM_APM)) {
+		pm_flags |= PM_ACPI;
+		return true;
+	}
+	return false;
+}
+
 /**
  *	acpi_pm_device_sleep_wake - enable or disable the system wake-up
  *                                  capability of given device
Index: linux-2.6/drivers/base/power/Makefile
===================================================================
--- linux-2.6.orig/drivers/base/power/Makefile
+++ linux-2.6/drivers/base/power/Makefile
@@ -1,7 +1,6 @@
-obj-$(CONFIG_PM)	+= sysfs.o
+obj-$(CONFIG_PM)	+= sysfs.o generic_ops.o
 obj-$(CONFIG_PM_SLEEP)	+= main.o wakeup.o
 obj-$(CONFIG_PM_RUNTIME)	+= runtime.o
-obj-$(CONFIG_PM_OPS)	+= generic_ops.o
 obj-$(CONFIG_PM_TRACE_RTC)	+= trace.o
 obj-$(CONFIG_PM_OPP)	+= opp.o
 
Index: linux-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_priv.h
+++ linux-2.6/drivers/scsi/scsi_priv.h
@@ -146,7 +146,7 @@ static inline void scsi_netlink_exit(voi
 #endif
 
 /* scsi_pm.c */
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 extern const struct dev_pm_ops scsi_bus_pm_ops;
 #endif
 #ifdef CONFIG_PM_RUNTIME
Index: linux-2.6/drivers/scsi/Makefile
===================================================================
--- linux-2.6.orig/drivers/scsi/Makefile
+++ linux-2.6/drivers/scsi/Makefile
@@ -165,7 +165,7 @@ scsi_mod-$(CONFIG_SCSI_NETLINK)	+= scsi_
 scsi_mod-$(CONFIG_SYSCTL)	+= scsi_sysctl.o
 scsi_mod-$(CONFIG_SCSI_PROC_FS)	+= scsi_proc.o
 scsi_mod-y			+= scsi_trace.o
-scsi_mod-$(CONFIG_PM_OPS)	+= scsi_pm.o
+scsi_mod-$(CONFIG_PM)		+= scsi_pm.o
 
 scsi_tgt-y			+= scsi_tgt_lib.o scsi_tgt_if.o
 
Index: linux-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- linux-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ linux-2.6/drivers/scsi/scsi_sysfs.c
@@ -383,7 +383,7 @@ struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 	.pm		= &scsi_bus_pm_ops,
 #endif
 };
Index: linux-2.6/drivers/usb/core/hcd-pci.c
===================================================================
--- linux-2.6.orig/drivers/usb/core/hcd-pci.c
+++ linux-2.6/drivers/usb/core/hcd-pci.c
@@ -335,7 +335,7 @@ void usb_hcd_pci_shutdown(struct pci_dev
 }
 EXPORT_SYMBOL_GPL(usb_hcd_pci_shutdown);
 
-#ifdef	CONFIG_PM_OPS
+#ifdef	CONFIG_PM
 
 #ifdef	CONFIG_PPC_PMAC
 static void powermac_set_asic(struct pci_dev *pci_dev, int enable)
@@ -580,4 +580,4 @@ const struct dev_pm_ops usb_hcd_pci_pm_o
 };
 EXPORT_SYMBOL_GPL(usb_hcd_pci_pm_ops);
 
-#endif	/* CONFIG_PM_OPS */
+#endif	/* CONFIG_PM */
Index: linux-2.6/drivers/pci/pci-driver.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-driver.c
+++ linux-2.6/drivers/pci/pci-driver.c
@@ -431,7 +431,7 @@ static void pci_device_shutdown(struct d
 	pci_msix_shutdown(pci_dev);
 }
 
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 
 /* Auxiliary functions used for system resume and run-time resume. */
 
@@ -1059,7 +1059,7 @@ static int pci_pm_runtime_idle(struct de
 
 #endif /* !CONFIG_PM_RUNTIME */
 
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 
 const struct dev_pm_ops pci_dev_pm_ops = {
 	.prepare = pci_pm_prepare,
Index: linux-2.6/include/acpi/acpi_bus.h
===================================================================
--- linux-2.6.orig/include/acpi/acpi_bus.h
+++ linux-2.6/include/acpi/acpi_bus.h
@@ -380,7 +380,7 @@ struct acpi_pci_root *acpi_pci_find_root
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int state);
 int acpi_disable_wakeup_device_power(struct acpi_device *dev);
 
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 int acpi_pm_device_sleep_state(struct device *, int *);
 #else
 static inline int acpi_pm_device_sleep_state(struct device *d, int *p)
Index: linux-2.6/include/linux/pm.h
===================================================================
--- linux-2.6.orig/include/linux/pm.h
+++ linux-2.6/include/linux/pm.h
@@ -267,7 +267,7 @@ const struct dev_pm_ops name = { \
  * callbacks provided by device drivers supporting both the system sleep PM and
  * runtime PM, make the pm member point to generic_subsys_pm_ops.
  */
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 extern struct dev_pm_ops generic_subsys_pm_ops;
 #define GENERIC_SUBSYS_PM_OPS	(&generic_subsys_pm_ops)
 #else
Index: linux-2.6/drivers/acpi/bus.c
===================================================================
--- linux-2.6.orig/drivers/acpi/bus.c
+++ linux-2.6/drivers/acpi/bus.c
@@ -1025,9 +1025,7 @@ static int __init acpi_init(void)
 
 	if (!result) {
 		pci_mmcfg_late_init();
-		if (!(pm_flags & PM_APM))
-			pm_flags |= PM_ACPI;
-		else {
+		if (!acpi_set_pm_flag()) {
 			printk(KERN_INFO PREFIX
 			       "APM is already active, exiting\n");
 			disable_acpi();
Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -82,12 +82,18 @@ void acpi_ec_unblock_transactions_early(
 extern int acpi_sleep_init(void);
 
 #ifdef CONFIG_ACPI_SLEEP
+/* drivers/acpi/sleep.c */
+bool acpi_set_pm_flag(void);
+
+/* drivers/acpi/nvs.c */
 int acpi_sleep_proc_init(void);
 int suspend_nvs_alloc(void);
 void suspend_nvs_free(void);
 int suspend_nvs_save(void);
 void suspend_nvs_restore(void);
 #else
+static inline bool acpi_set_pm_flag(void) { return true; }
+
 static inline int acpi_sleep_proc_init(void) { return 0; }
 static inline int suspend_nvs_alloc(void) { return 0; }
 static inline void suspend_nvs_free(void) {}
Index: linux-2.6/drivers/net/pch_gbe/pch_gbe_main.c
===================================================================
--- linux-2.6.orig/drivers/net/pch_gbe/pch_gbe_main.c
+++ linux-2.6/drivers/net/pch_gbe/pch_gbe_main.c
@@ -2430,7 +2430,7 @@ static struct pci_driver pch_gbe_pcidev
 	.id_table = pch_gbe_pcidev_id,
 	.probe = pch_gbe_probe,
 	.remove = pch_gbe_remove,
-#ifdef CONFIG_PM_OPS
+#ifdef CONFIG_PM
 	.driver.pm = &pch_gbe_pm_ops,
 #endif
 	.shutdown = pch_gbe_shutdown,
