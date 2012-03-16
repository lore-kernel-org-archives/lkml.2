Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946076Ab2CPXiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:38:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39045 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945988Ab2CPXh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:37:57 -0400
Message-Id: <20120316233447.994935619@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:34:55 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Kostyantyn Shlyakhovoy <x0155534@ti.com>
Subject: [ 08/38] PM / Driver core: leave runtime PM enabled during system shutdown
In-Reply-To: <20120316233422.GA5461@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit fe6b91f47080eb17d21cbf2a39311877d57f6938 upstream.

Disabling all runtime PM during system shutdown turns out not to be a
good idea, because some devices may need to be woken up from a
low-power state at that time.

The whole point of disabling runtime PM for system shutdown was to
prevent untimely runtime-suspend method calls.  This patch (as1504)
accomplishes the same result by incrementing the usage count for each
device and waiting for ongoing runtime-PM callbacks to finish.  This
is what we already do during system suspend and hibernation, which
makes sense since the shutdown method is pretty much a legacy analog
of the pm->poweroff method.

This fixes a recent regression on some OMAP systems introduced by
commit af8db1508f2c9f3b6e633e2d2d906c6557c617f9 (PM / driver core:
disable device's runtime PM during shutdown).

Reported-and-tested-by: NeilBrown <neilb@suse.de>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Kostyantyn Shlyakhovoy <x0155534@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1743,8 +1743,10 @@ void device_shutdown(void)
 		 */
 		list_del_init(&dev->kobj.entry);
 		spin_unlock(&devices_kset->list_lock);
-		/* Disable all device's runtime power management */
-		pm_runtime_disable(dev);
+
+		/* Don't allow any more runtime suspends */
+		pm_runtime_get_noresume(dev);
+		pm_runtime_barrier(dev);
 
 		if (dev->bus && dev->bus->shutdown) {
 			dev_dbg(dev, "shutdown\n");


