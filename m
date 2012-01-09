Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2AIWLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 17:11:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54784 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755101Ab2AIWK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 17:10:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: Build error at drivers/base/power/domain_governor.c when PM_RUNTIME is not set
Date: Mon, 9 Jan 2012 23:14:20 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        linux-samsung-soc@vger.kernel.org
References: <018a01ccce67$a6eee850$f4ccb8f0$%kim@samsung.com>
In-Reply-To: <018a01ccce67$a6eee850$f4ccb8f0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201092314.20561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, January 09, 2012, Kukjin Kim wrote:
> Hi Rafael,
> 
> This is just reporting of build error.
> 
> Current mainline happens build error at drivers/base/power/domain_governor.c
> file like following when CONFIG_PM_RUNTIME is not set. For example, it
> happens with s3c6400_defconfig now.
> 
> drivers/base/power/domain_governor.c: In function 'default_stop_ok':
> drivers/base/power/domain_governor.c:25: error: 'struct dev_pm_info' has no
> member named 'max_time_suspended_ns'
> drivers/base/power/domain_governor.c:29: error: 'struct dev_pm_info' has no
> member named 'max_time_suspended_ns'
> drivers/base/power/domain_governor.c: In function 'default_power_down_ok':
> drivers/base/power/domain_governor.c:94: error: 'struct dev_pm_info' has no
> member named 'max_time_suspended_ns'
> drivers/base/power/domain_governor.c:98: error: 'struct dev_pm_info' has no
> member named 'max_time_suspended_ns'
> drivers/base/power/domain_governor.c:100: error: 'struct dev_pm_info' has no
> member named 'suspend_time'

The appended patch fixes the problem for me, can you please test it?

Rafael

---
 drivers/base/power/domain_governor.c |   24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

Index: linux/drivers/base/power/domain_governor.c
===================================================================
--- linux.orig/drivers/base/power/domain_governor.c
+++ linux/drivers/base/power/domain_governor.c
@@ -12,6 +12,8 @@
 #include <linux/pm_qos.h>
 #include <linux/hrtimer.h>
 
+#ifdef CONFIG_PM_RUNTIME
+
 /**
  * default_stop_ok - Default PM domain governor routine for stopping devices.
  * @dev: Device to check.
@@ -137,16 +139,28 @@ static bool default_power_down_ok(struct
 	return true;
 }
 
-struct dev_power_governor simple_qos_governor = {
-	.stop_ok = default_stop_ok,
-	.power_down_ok = default_power_down_ok,
-};
-
 static bool always_on_power_down_ok(struct dev_pm_domain *domain)
 {
 	return false;
 }
 
+#else /* !CONFIG_PM_RUNTIME */
+
+bool default_stop_ok(struct device *dev)
+{
+	return false;
+}
+
+#define default_power_down_ok	NULL
+#define always_on_power_down_ok	NULL
+
+#endif /* !CONFIG_PM_RUNTIME */
+
+struct dev_power_governor simple_qos_governor = {
+	.stop_ok = default_stop_ok,
+	.power_down_ok = default_power_down_ok,
+};
+
 /**
  * pm_genpd_gov_always_on - A governor implementing an always-on policy
  */
