Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1DUV5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 17:57:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43129 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752998Ab1DUV5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 17:57:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH] PM / Wakeup: Fix initialization of wakeup-related device sysfs files
Date: Thu, 21 Apr 2011 23:57:42 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tino Keitel <tino.keitel@tikei.de>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104212357.43052.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

It turns out that some PCI devices are only found to be
wakeup-capable during registration, in which case, when
device_set_wakeup_capable() is called, device_is_registered() already
returns 'true' for the given device, but dpm_sysfs_add() hasn't been
called for it yet.  This leads to situations in which the device's
power.can_wakeup flag is not set as requested because of failing
wakeup_sysfs_add() and its wakeup-related sysfs files are not
created, although they should be present.  This is a post-2.6.38
regression introduced by commit cb8f51bdadb7969139c2e39c2defd4cde98c1
(PM: Do not create wakeup sysfs files for devices that cannot wake
up).

To work around this problem initialize the device's power.entry
field to an empty list head and make device_set_wakeup_capable()
check if it is still empty before attempting to add the devices
wakeup-related sysfs files with wakeup_sysfs_add().  Namely, if
power.entry is still empty at this point, device_pm_add() hasn't been
called yet for the device and its wakeup-related files will be
created later, so device_set_wakeup_capable() doesn't have to create
them.

Reported-by: Tino Keitel <tino.keitel@tikei.de>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/base/power/main.c   |    1 +
 drivers/base/power/wakeup.c |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/base/power/main.c
===================================================================
--- linux-2.6.orig/drivers/base/power/main.c
+++ linux-2.6/drivers/base/power/main.c
@@ -63,6 +63,7 @@ void device_pm_init(struct device *dev)
 	dev->power.wakeup = NULL;
 	spin_lock_init(&dev->power.lock);
 	pm_runtime_init(dev);
+	INIT_LIST_HEAD(&dev->power.entry);
 }
 
 /**
Index: linux-2.6/drivers/base/power/wakeup.c
===================================================================
--- linux-2.6.orig/drivers/base/power/wakeup.c
+++ linux-2.6/drivers/base/power/wakeup.c
@@ -258,7 +258,7 @@ void device_set_wakeup_capable(struct de
 	if (!!dev->power.can_wakeup == !!capable)
 		return;
 
-	if (device_is_registered(dev)) {
+	if (device_is_registered(dev) && !list_empty(&dev->power.entry)) {
 		if (capable) {
 			if (wakeup_sysfs_add(dev))
 				return;
