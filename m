Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2LBNoE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 08:44:04 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:37763 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2LBNoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 08:44:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>, Chris Ball <cjb@laptop.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: [PATCH] SDIO / PM: Add empty bus-level suspend/resume callbacks
Date: Sun, 02 Dec 2012 14:48:50 +0100
Message-ID: <2147450.LFoExqrKEF@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc7; KDE/4.9.3; x86_64; ; )
In-Reply-To: <20121202194625.5d66e239@notabene.brown>
References: <20120325203849.7a908e32@notabene.brown> <201203260029.24826.rjw@sisk.pl> <20121202194625.5d66e239@notabene.brown>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, December 02, 2012 07:46:25 PM NeilBrown wrote:
> On Mon, 26 Mar 2012 00:29:24 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> 
> > Thanks for the confirmation.
> > 
> > Below it goes again with a changelog and tags.
> > 
> > I don't really think that SDIO does the right thing here overall, but that's
> > all I can do to address the problem timely.
> > 
> > Thanks,
> > Rafael
> 
> Hi Rafael,
>  I just discovered that this patch has since been reverted - with an 'ack'
>  from you:
> ----------
> commit d8e2ac330f65bcf47e8894fe5331a7e8ee019c06
> Author: Thierry Reding <thierry.reding@avionic-design.de>
> Date:   Thu Aug 9 09:32:21 2012 +0000
> 
>     mmc: sdio: Fix PM_SLEEP related build warnings
>     
>     Power management callbacks defined by SIMPLE_DEV_PM_OPS are only used if
>     the PM_SLEEP Kconfig symbol has been defined. If not, the compiler will
>     complain about them being unused. However, since the callback for this
>     driver doesn't do anything it can just as well be dropped.
>     
>     Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>     Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
>     Signed-off-by: Chris Ball <cjb@laptop.org>
> -----------
> 
> Unsurprisingly the problem which your patch fixed has come back.
> 
> Do you think we could get the patch back in again.  This time maybe we should
> put some comments in there pointing out that having a function which does
> nothing is very different from not having any function at all?

Well, I agree.  I didn't remember that the callback had been added for
a purpose and hence my "ack" for that patch.

What about applying the appended patch (hopefully, the build warnings should
be fixed properly this time)?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: SDIO / PM: Add empty bus-level suspend/resume callbacks

Suspend methods provided by SDIO drivers are not supposed to be
called by the PM core.  Instead, when the SDIO core gets to suspend
a device's ancestor, it calls the device driver's suspend routine.
However, the PM core executes suspend callback routines directly for
device drivers whose bus types don't provide suspend callbacks.
In consequece, because the SDIO bus type doesn't provide a suspend
callback, the SDIO drivers' suspend routines will be executed by the
PM core (which shouldn't happen).

To prevent this from happening, add empty system suspend/resume
callbacks for the SDIO bus type.

An analogous change had been made already by commit (e841a7c mmc:
sdio: Use empty system suspend/resume callbacks at the bus level),
but then it was reverted inadvertently by commit (d8e2ac3 mmc: sdio:
Fix PM_SLEEP related build warnings) that attempted to fix build
warnings introduced by commit e841a7c.

Reported-by: NeilBrown <neilb@suse.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/mmc/core/sdio_bus.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux/drivers/mmc/core/sdio_bus.c
===================================================================
--- linux.orig/drivers/mmc/core/sdio_bus.c
+++ linux/drivers/mmc/core/sdio_bus.c
@@ -193,7 +193,21 @@ static int sdio_bus_remove(struct device
 }
 
 #ifdef CONFIG_PM
+
+#ifdef CONFIG_PM_SLEEP
+static int pm_no_operation(struct device *dev)
+{
+	/*
+	 * Prevent the PM core from calling SDIO device drivers' suspend
+	 * callback routines, which it is not supposed to do, by using this
+	 * empty function as the bus type suspend callaback for SDIO.
+	 */
+	return 0;
+}
+#endif
+
 static const struct dev_pm_ops sdio_bus_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
 	SET_RUNTIME_PM_OPS(
 		pm_generic_runtime_suspend,
 		pm_generic_runtime_resume,


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
