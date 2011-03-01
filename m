Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1CAAM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 19:12:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37813 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab1CAAMY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 19:12:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH upstream build breakage] acpi: several drivers depend on NET
Date: Tue, 1 Mar 2011 01:12:19 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Len Brown <lenb@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Luming Yu <luming.yu@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <20101220200013.df8fbc88.sfr@canb.auug.org.au> <201102282342.59407.rjw@sisk.pl> <4D6C370F.1040104@oracle.com>
In-Reply-To: <4D6C370F.1040104@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103010112.19835.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 01, 2011, Randy Dunlap wrote:
> On 02/28/11 14:42, Rafael J. Wysocki wrote:
> > On Monday, February 28, 2011, Rafael J. Wysocki wrote:
> >> On Monday, February 28, 2011, Randy Dunlap wrote:
> >>> On Tue, 1 Feb 2011 13:03:23 +0100 Ingo Molnar wrote:
> >>>
> >>>> * Ingo Molnar <mingo@elte.hu> wrote:
> >>>>
> >>>>> * Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>>>>
> >>>>>> On Mon, 20 Dec 2010 20:00:13 +1100 Stephen Rothwell wrote:
> >>>>>>
> >>>>>>> Hi all,
> >>>>>>>
> >>>>>>> [The mirroring on kernel.org is running slowly]
> >>>>>>>
> >>>>>>> Changes since 20101217:
> >>>>>>
> >>>>>> ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
> >>>>>> ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!
> >>>>>
> >>>>> This bug has been reported two months ago, one month ago, it has been ignored twice 
> >>>>> and now the bug has been pushed upstream and it's triggering there as well.
> >>>>>
> >>>>> What's going on?
> >>>>
> >>>> *Tap*, *tap*, is this thing on? :)
> >>>>
> >>>> acpi-video is still build-broken upstream, as of .38-rc3:
> >>>>
> >>>>    MODPOST 651 modules
> >>>>  ERROR: "thermal_cooling_device_register" [drivers/acpi/video.ko] undefined!
> >>>>  ERROR: "thermal_cooling_device_unregister" [drivers/acpi/video.ko] undefined!
> >>>>  WARNING: modpost: Found 37 section mismatch(es).
> >>>>  To see full details build your kernel with:
> >>>>  'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> >>>>  make[1]: *** [__modpost] Error 1
> >>>>  make: *** [modules] Error 2
> >>>>
> >>>> Triggers in about 10% of all randconfig builds. Config attached.
> >>>
> >>>
> >>> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>>
> >>> Several ACPI drivers select THERMAL, but THERMAL depends on NET
> >>> (for netlink).  Fix build breakage by making the ACPI drivers
> >>> also depend on NET.
> >>
> >> Well, making ACPI_FAN depend on NET seems to be a kind of an overstretch to me.
> >> A proper fix would be to disable the netlink interface in THERMAL when
> >> NET is unset, I guess.  I'll see what can be done to that end (although I had
> >> hoped that the people who introduced the breakage would handle it).
> > 
> > OK, please check if the appended patch helps.  Admittedly, I only built it
> > with CONFIG_NET set, so caveat emptor.
> 
> Looks good, built both with NET=y and NET disabled.
> 
> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Great, thanks!  Below is the same patch with a changelog and sign-off.

Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: ACPI: Fix build for CONFIG_NET unset

Several ACPI drivers fail to build if CONFIG_NET is unset, because
they refer to things depending on CONFIG_THERMAL that in turn depends
on CONFIG_NET.  However, CONFIG_THERMAL doesn't really need to depend
on CONFIG_NET, because the only part of it requiring CONFIG_NET is
the netlink interface in thermal_sys.c.

Put the netlink interface in thermal_sys.c under #ifdef CONFIG_NET
and remove the dependency of CONFIG_THERMAL on CONFIG_NET from
drivers/thermal/Kconfig.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/thermal/Kconfig       |    1 -
 drivers/thermal/thermal_sys.c |   40 +++++++++++++++++++++-------------------
 include/linux/thermal.h       |    8 ++++++++
 3 files changed, 29 insertions(+), 20 deletions(-)

Index: linux-2.6/drivers/thermal/thermal_sys.c
===================================================================
--- linux-2.6.orig/drivers/thermal/thermal_sys.c
+++ linux-2.6/drivers/thermal/thermal_sys.c
@@ -62,20 +62,6 @@ static DEFINE_MUTEX(thermal_list_lock);
 
 static unsigned int thermal_event_seqnum;
 
-static struct genl_family thermal_event_genl_family = {
-	.id = GENL_ID_GENERATE,
-	.name = THERMAL_GENL_FAMILY_NAME,
-	.version = THERMAL_GENL_VERSION,
-	.maxattr = THERMAL_GENL_ATTR_MAX,
-};
-
-static struct genl_multicast_group thermal_event_mcgrp = {
-	.name = THERMAL_GENL_MCAST_GROUP_NAME,
-};
-
-static int genetlink_init(void);
-static void genetlink_exit(void);
-
 static int get_idr(struct idr *idr, struct mutex *lock, int *id)
 {
 	int err;
@@ -1225,6 +1211,18 @@ void thermal_zone_device_unregister(stru
 
 EXPORT_SYMBOL(thermal_zone_device_unregister);
 
+#ifdef CONFIG_NET
+static struct genl_family thermal_event_genl_family = {
+	.id = GENL_ID_GENERATE,
+	.name = THERMAL_GENL_FAMILY_NAME,
+	.version = THERMAL_GENL_VERSION,
+	.maxattr = THERMAL_GENL_ATTR_MAX,
+};
+
+static struct genl_multicast_group thermal_event_mcgrp = {
+	.name = THERMAL_GENL_MCAST_GROUP_NAME,
+};
+
 int generate_netlink_event(u32 orig, enum events event)
 {
 	struct sk_buff *skb;
@@ -1301,6 +1299,15 @@ static int genetlink_init(void)
 	return result;
 }
 
+static void genetlink_exit(void)
+{
+	genl_unregister_family(&thermal_event_genl_family);
+}
+#else /* !CONFIG_NET */
+static inline int genetlink_init(void) { return 0; }
+static inline void genetlink_exit(void) {}
+#endif /* !CONFIG_NET */
+
 static int __init thermal_init(void)
 {
 	int result = 0;
@@ -1316,11 +1323,6 @@ static int __init thermal_init(void)
 	return result;
 }
 
-static void genetlink_exit(void)
-{
-	genl_unregister_family(&thermal_event_genl_family);
-}
-
 static void __exit thermal_exit(void)
 {
 	class_unregister(&thermal_class);
Index: linux-2.6/include/linux/thermal.h
===================================================================
--- linux-2.6.orig/include/linux/thermal.h
+++ linux-2.6/include/linux/thermal.h
@@ -172,6 +172,14 @@ void thermal_zone_device_update(struct t
 struct thermal_cooling_device *thermal_cooling_device_register(char *, void *,
 		const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
+
+#ifdef CONFIG_NET
 extern int generate_netlink_event(u32 orig, enum events event);
+#else
+static inline int generate_netlink_event(u32 orig, enum events event)
+{
+	return 0;
+}
+#endif
 
 #endif /* __THERMAL_H__ */
Index: linux-2.6/drivers/thermal/Kconfig
===================================================================
--- linux-2.6.orig/drivers/thermal/Kconfig
+++ linux-2.6/drivers/thermal/Kconfig
@@ -4,7 +4,6 @@
 
 menuconfig THERMAL
 	tristate "Generic Thermal sysfs driver"
-	depends on NET
 	help
 	  Generic Thermal Sysfs driver offers a generic mechanism for
 	  thermal management. Usually it's made up of one or more thermal
