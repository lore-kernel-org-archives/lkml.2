Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2HEVH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 17:07:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42763 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab2HEVH4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 17:07:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Heiko =?utf-8?q?St=C3=BCbner?= <heiko@sntech.de>
Subject: Re: [PATCH] PM / Domains: Only check for errors when calling dev_pm_get_subsys_data
Date: Sun, 5 Aug 2012 23:13:46 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201208052225.09503.heiko@sntech.de>
In-Reply-To: <201208052225.09503.heiko@sntech.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201208052313.47024.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 05, 2012, Heiko Stübner wrote:
> Commit 1d5fcfec22 (PM / Domains: Add device domain data reference counter)
> added a check for the return value of dev_pm_get_subsys_data.
> 
> But this function does not only return error codes but also "1" when a
> new object has been created.
> 
> So, change the check to only catch real errors.
> 
> Signed-off-by: Heiko Stuebner <heiko@sntech.de>

Good catch!

Applied to the linux-next branch of the linux-pm.git tree.  I'm going to
push it as a fix for v3.6.

However, there's one more analogous fix necessary, for which I'm going to
apply the appended patch.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Domains: Fix one more dev_pm_get_subsys_data() return value check

The check agains the return value of dev_pm_get_subsys_data()
in pm_genpd_add_callbacks() should be modified so that non-negative
values are not regarded as errors, because dev_pm_get_subsys_data()
returns 1 if it successfully creates a new object.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/domain.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/base/power/domain.c
===================================================================
--- linux.orig/drivers/base/power/domain.c
+++ linux/drivers/base/power/domain.c
@@ -1691,7 +1691,7 @@ int pm_genpd_add_callbacks(struct device
 	device_pm_lock();
 
 	ret = dev_pm_get_subsys_data(dev);
-	if (ret)
+	if (ret < 0)
 		goto out;
 
 	spin_lock_irq(&dev->power.lock);
