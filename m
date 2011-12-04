Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab1LDWFU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 17:05:20 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:41191 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755563Ab1LDWFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 17:05:18 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH] PM / sh7372: Make domain stay_on bit only affect system suspend
Date: Sun, 4 Dec 2011 23:08:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112042308.14255.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

SH7372 uses two independent mechanisms for ensuring that power
domains will never be turned off: the stay_on flag and the "always
on" domain governor.  However, the "always on" governor is only taken
into accout by runtime PM code paths, while the stay_on flag affects
all attempts to turn the given domain off.  This is a problem for
domains that only need to stay in the "power on" state during system
sleep, but may be turned off by runtime PM if specific conditions are
satisfied.  For this reason, make SH7372 register a PM notifier that
will enable the checking of the domain stay_on flag on during system
suspend and disable it during system resume.  This way, the stay_on
flag will only affect system sleep states, while the "always on"
governor will only affect runtime PM.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---

This patch is on top of linux-pm/pm-domains.

Thanks,
Rafael

---
 arch/arm/mach-shmobile/pm-sh7372.c |   20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

Index: linux/arch/arm/mach-shmobile/pm-sh7372.c
===================================================================
--- linux.orig/arch/arm/mach-shmobile/pm-sh7372.c
+++ linux/arch/arm/mach-shmobile/pm-sh7372.c
@@ -77,6 +77,8 @@
 
 #ifdef CONFIG_PM
 
+static bool system_pm_transition;
+
 static int pd_power_down(struct generic_pm_domain *genpd)
 {
 	struct sh7372_pm_domain *sh7372_pd = to_sh7372_pd(genpd);
@@ -85,7 +87,7 @@ static int pd_power_down(struct generic_
 	if (sh7372_pd->suspend)
 		sh7372_pd->suspend();
 
-	if (sh7372_pd->stay_on)
+	if (system_pm_transition && sh7372_pd->stay_on)
 		return 0;
 
 	if (__raw_readl(PSTR) & mask) {
@@ -286,6 +288,21 @@ struct sh7372_pm_domain sh7372_a3sg = {
 	.bit_shift = 13,
 };
 
+static int sh7372_pm_notifier_fn(struct notifier_block *notifier,
+				 unsigned long pm_event, void *unused)
+{
+	switch (pm_event) {
+	case PM_SUSPEND_PREPARE:
+		system_pm_transition = true;
+		break;
+	case PM_POST_SUSPEND:
+		system_pm_transition = false;
+		break;
+	}
+
+	return NOTIFY_DONE;
+}
+
 #else /* !CONFIG_PM */
 
 static inline void sh7372_a3sp_init(void) {}
@@ -509,6 +526,7 @@ static int sh7372_enter_suspend(suspend_
 static void sh7372_suspend_init(void)
 {
 	shmobile_suspend_ops.enter = sh7372_enter_suspend;
+	pm_notifier(sh7372_pm_notifier_fn, 0);
 }
 #else
 static void sh7372_suspend_init(void) {}
