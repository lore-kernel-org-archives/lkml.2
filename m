Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab1DTXu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 19:50:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39949 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1DTXuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 19:50:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tino Keitel <tino.keitel@tikei.de>
Subject: Re: [linux-pm] /proc/acpi/wakeup regression in 2.6.39-rc3
Date: Thu, 21 Apr 2011 01:50:45 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201104150053.37037.rjw@sisk.pl> <20110415145457.GA27650@eazy.amigager.de> <20110419202212.GA15438@mac.home>
In-Reply-To: <20110419202212.GA15438@mac.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104210150.45988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 19, 2011, Tino Keitel wrote:
> Hi,
> 
> I reverted some wakeup and ACPI related commits. When I reverted commit
> 7fa69baf29de8c77a6b32c054df2abb8f11f8aa4, wakeup using the keyboard
> worked again and /proc/acpi/wakeup behaved as expected.
> 
> So check this, I reverted the following commits to avoid conflicts and
> build failures:
> 
> c19f9a84ec807da57fd75bbd9a3f2b8269611f79
> 5190726765b40774c069e187a958e10ccd970e65
> 2a5d24286e8bdafdc272b37ec5bdd9e977b3767c
> f2b56bc808addb908a5bf435d9b942c02af9a7c4
> 7fa69baf29de8c77a6b32c054df2abb8f11f8aa4

In fact, the problem is somewhere else.

It turns out that device_is_registered() may return true before
the device's "power" directory in sysfs is created, which causes
device_set_wakeup_capable() not to set dev->power.can_wakeup and
that's why the /proc/acpi/wakeup interface doesn't work for
some devices.

Please try the patch below, it should help.

Thanks,
Rafael

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
