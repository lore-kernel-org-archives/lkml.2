Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933966Ab2DKXQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:16:53 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63303 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933933Ab2DKXQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:16:45 -0400
Message-Id: <20120411231027.518643416@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Ball <cjb@laptop.org>
Subject: [ 54/78] mmc: sdio: Use empty system suspend/resume callbacks at the bus level
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rjw@sisk.pl>

commit e841a7c69b708eeaf784fd517978006e8319b03a upstream.

Neil Brown reports that commit 35cd133c

   PM: Run the driver callback directly if the subsystem one is not there

breaks suspend for his libertas wifi, because SDIO has a protocol
where the suspend method can return -ENOSYS and this means "There is
no point in suspending, just turn me off".  Moreover, the suspend
methods provided by SDIO drivers are not supposed to be called by
the PM core or bus-level suspend routines (which aren't presend for
SDIO).  Instead, when the SDIO core gets to suspend the device's
ancestor, it calls the device driver's suspend function, catches the
ENOSYS, and turns the device off.

The commit above breaks the SDIO core's assumption that the device
drivers' callbacks won't be executed if it doesn't provide any
bus-level callbacks.  If fact, however, this assumption has never
been really satisfied, because device class or device type suspend
might very well use the driver's callback even without that commit.

The simplest way to address this problem is to make the SDIO core
tell the PM core to ignore driver callbacks, for example by providing
no-operation suspend/resume callbacks at the bus level for it,
which is implemented by this change.

Reported-and-tested-by: Neil Brown <neilb@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/core/sdio_bus.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -192,9 +192,15 @@ static int sdio_bus_remove(struct device
 	return ret;
 }
 
-#ifdef CONFIG_PM_RUNTIME
+#ifdef CONFIG_PM
+
+static int pm_no_operation(struct device *dev)
+{
+	return 0;
+}
 
 static const struct dev_pm_ops sdio_bus_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_no_operation, pm_no_operation)
 	SET_RUNTIME_PM_OPS(
 		pm_generic_runtime_suspend,
 		pm_generic_runtime_resume,
@@ -204,11 +210,11 @@ static const struct dev_pm_ops sdio_bus_
 
 #define SDIO_PM_OPS_PTR	(&sdio_bus_pm_ops)
 
-#else /* !CONFIG_PM_RUNTIME */
+#else /* !CONFIG_PM */
 
 #define SDIO_PM_OPS_PTR	NULL
 
-#endif /* !CONFIG_PM_RUNTIME */
+#endif /* !CONFIG_PM */
 
 static struct bus_type sdio_bus_type = {
 	.name		= "sdio",


