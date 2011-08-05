Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756806Ab1HEWfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 18:35:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:53941 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752230Ab1HEWfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 18:35:18 -0400
Date: Sat, 6 Aug 2011 01:34:08 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>
Cc: Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Battery: sysfs_remove_battery(): possible circular locking
Message-ID: <20110805223408.GA3363@swordfish.minsk.epam.com>
References: <20110805003322.GA8311@swordfish>
 <1312521008.2096.173.camel@lantianyu-ws>
 <20110805163944.GA3132@swordfish.minsk.epam.com>
 <625BA99ED14B2D499DC4E29D8138F15062C4514167@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <625BA99ED14B2D499DC4E29D8138F15062C4514167@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9c921c22a7f33397a6774d7fa076db9b6a0fd669
Author: Lan Tianyu <tianyu.lan@intel.com>

    ACPI / Battery: Resolve the race condition in the sysfs_remove_battery()

fixed BUG https://bugzilla.kernel.org/show_bug.cgi?id=35642 , but as a side
effect made lockdep unhappy with sysfs_remove_battery():

[14818.477168] 
[14818.477170] =======================================================
[14818.477200] [ INFO: possible circular locking dependency detected ]
[14818.477221] 3.1.0-dbg-07865-g1280ea8-dirty #668
[14818.477236] -------------------------------------------------------
[14818.477257] s2ram/1599 is trying to acquire lock:
[14818.477276]  (s_active#8){++++.+}, at: [<ffffffff81169147>] sysfs_addrm_finish+0x31/0x5a
[14818.477323] 
[14818.477325] but task is already holding lock:
[14818.477350]  (&battery->lock){+.+.+.}, at: [<ffffffffa0047278>] sysfs_remove_battery+0x10/0x4b [battery]
[14818.477395] 
[14818.477397] which lock already depends on the new lock.
[14818.477399] 
[..]
[14818.479121] stack backtrace:
[14818.479148] Pid: 1599, comm: s2ram Not tainted 3.1.0-dbg-07865-g1280ea8-dirty #668
[14818.479175] Call Trace:
[14818.479198]  [<ffffffff814828c3>] print_circular_bug+0x293/0x2a4
[14818.479228]  [<ffffffff81070cb5>] __lock_acquire+0xfe4/0x164b
[14818.479260]  [<ffffffff81169147>] ? sysfs_addrm_finish+0x31/0x5a
[14818.479288]  [<ffffffff810718d2>] lock_acquire+0x138/0x1ac
[14818.479316]  [<ffffffff81169147>] ? sysfs_addrm_finish+0x31/0x5a
[14818.479345]  [<ffffffff81168a79>] sysfs_deactivate+0x9b/0xec
[14818.479373]  [<ffffffff81169147>] ? sysfs_addrm_finish+0x31/0x5a
[14818.479405]  [<ffffffff81169147>] sysfs_addrm_finish+0x31/0x5a
[14818.479433]  [<ffffffff81167bc5>] sysfs_hash_and_remove+0x54/0x77
[14818.479461]  [<ffffffff811681b9>] sysfs_remove_file+0x12/0x14
[14818.479488]  [<ffffffff81385bf8>] device_remove_file+0x12/0x14
[14818.479516]  [<ffffffff81386504>] device_del+0x119/0x17c
[14818.479542]  [<ffffffff81386575>] device_unregister+0xe/0x1a
[14818.479570]  [<ffffffff813c6ef9>] power_supply_unregister+0x23/0x27
[14818.479601]  [<ffffffffa004729c>] sysfs_remove_battery+0x34/0x4b [battery]
[14818.479632]  [<ffffffffa004778f>] battery_notify+0x2c/0x3a [battery]
[14818.479662]  [<ffffffff8148fe82>] notifier_call_chain+0x74/0xa1
[14818.479692]  [<ffffffff810624b4>] __blocking_notifier_call_chain+0x6c/0x89
[14818.479722]  [<ffffffff810624e0>] blocking_notifier_call_chain+0xf/0x11
[14818.479751]  [<ffffffff8107e40e>] pm_notifier_call_chain+0x15/0x27
[14818.479770]  [<ffffffff8107ee1a>] enter_state+0xa7/0xd5
[14818.479782]  [<ffffffff8107e341>] state_store+0xaa/0xc0
[14818.479795]  [<ffffffff8107e297>] ? pm_async_store+0x45/0x45
[14818.479807]  [<ffffffff81248837>] kobj_attr_store+0x17/0x19
[14818.479820]  [<ffffffff81167e27>] sysfs_write_file+0x103/0x13f
[14818.479834]  [<ffffffff81109037>] vfs_write+0xad/0x13d
[14818.479847]  [<ffffffff811092b2>] sys_write+0x45/0x6c
[14818.479860]  [<ffffffff81492f92>] system_call_fastpath+0x16/0x1b

This patch introduces separate lock to struct acpi_battery to 
grab in sysfs_remove_battery() instead of battery->lock.
So fix by Lan Tianyu is still there, we just grab independent lock.


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/acpi/battery.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 87c0a8d..7711d94 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -99,6 +99,7 @@ enum {
 
 struct acpi_battery {
 	struct mutex lock;
+	struct mutex sysfs_lock;
 	struct power_supply bat;
 	struct acpi_device *device;
 	struct notifier_block pm_nb;
@@ -573,16 +574,16 @@ static int sysfs_add_battery(struct acpi_battery *battery)
 
 static void sysfs_remove_battery(struct acpi_battery *battery)
 {
-	mutex_lock(&battery->lock);
+	mutex_lock(&battery->sysfs_lock);
 	if (!battery->bat.dev) {
-		mutex_unlock(&battery->lock);
+		mutex_unlock(&battery->sysfs_lock);
 		return;
 	}
 
 	device_remove_file(battery->bat.dev, &alarm_attr);
 	power_supply_unregister(&battery->bat);
 	battery->bat.dev = NULL;
-	mutex_unlock(&battery->lock);
+	mutex_unlock(&battery->sysfs_lock);
 }
 
 /*
@@ -982,6 +983,7 @@ static int acpi_battery_add(struct acpi_device *device)
 	strcpy(acpi_device_class(device), ACPI_BATTERY_CLASS);
 	device->driver_data = battery;
 	mutex_init(&battery->lock);
+	mutex_init(&battery->sysfs_lock);
 	if (ACPI_SUCCESS(acpi_get_handle(battery->device->handle,
 			"_BIX", &handle)))
 		set_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags);
@@ -1010,6 +1012,7 @@ static int acpi_battery_add(struct acpi_device *device)
 fail:
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
+	mutex_destroy(&battery->sysfs_lock);
 	kfree(battery);
 	return result;
 }
@@ -1027,6 +1030,7 @@ static int acpi_battery_remove(struct acpi_device *device, int type)
 #endif
 	sysfs_remove_battery(battery);
 	mutex_destroy(&battery->lock);
+	mutex_destroy(&battery->sysfs_lock);
 	kfree(battery);
 	return 0;
 }

