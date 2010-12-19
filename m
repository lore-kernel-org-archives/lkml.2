Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab0LSMzp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 07:55:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab0LSMzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 07:55:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=xQaE9Y3cN5eYmO4E2DuA7cV091elZTmmTBCzMKPtTqUoxfkcTePRitrHiLlKMCzqdS
         spLQPHfuFNElZz8j68eLvM3YMjr0p6+GSBVV7lCALn21cVP4zhnwNFMNFjI30qxxSg9W
         /nSh6pjdw26OuuSaZdDfX3RKwGVckaL7erKy0=
MIME-Version: 1.0
Date: Sun, 19 Dec 2010 12:55:43 +0000
Message-ID: <AANLkTinz5aj9MDXCxogYgLypF7x4BwscR6Ndu5R6ybcA@mail.gmail.com>
Subject: [2.6.37-rc6] led_trigger_unregister protection fault...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.37-rc6, when hot-removing the battery on my Studio 1557 i7
laptop with AC power, kworker/0:2 hit a protection fault in
led_trigger_unregister_oops [1].

Rebuilding with the same config and disassembling led-triggers.o and
power_supply_leds.o, we see that the first two triggers were removed
from the list successfully [2,3].

I don't see 'LED trigger ... failed to register' the kernel message,
so leg_trigger_register_simple had registered the three of them, so
list corruption?

Dan

--- [1]

wq_worker_sleeping+0x1a/0x90
schedule
? call_rcu_sched
? release_task
do_exit
oops_end
die
do_general_protection
general_protection
? led_trigger_unregister+0x44/0xd0
led_trigger_unregister_simple+0x1b/0x30
power_supply_remove_bat_triggers
power_supply_remove_triggers
power_supply_unregister
sysfs_remove_battery
acpi_battery_update
acpi_battery_get_property
power_supply_show_property
power_supply_uevent
dev_uevent
kobject_uevent_env
? default_spin_lock_flags
kobject_uevent
device_del
device_unregister
power_supply_unregister
sysfs_remove_battery
acpi_battery_update
acpi_battery_notify
acpi_device_notify
acpi_ev_notify_dispatch
acpi_os_execute_deferred
process_one_work
? acpi_os_execute_deferred
worker_thread
? worker_thread
kthread
kernel_thread_helper
? kthread
? kernel_thread_helper
RIP: kthread_data+0x10/0x20

--- [2]

void led_trigger_unregister(struct led_trigger *trigger)
{
	struct led_classdev *led_cdev;

	/* Remove from the list of led triggers */
	down_write(&triggers_list_lock);
	list_del(&trigger->next_trig);  <----
	up_write(&triggers_list_lock);
...

--- [3]

static void power_supply_remove_bat_triggers(struct power_supply *psy)
{
	led_trigger_unregister_simple(psy->charging_full_trig);
	led_trigger_unregister_simple(psy->charging_trig);
	led_trigger_unregister_simple(psy->full_trig);  <----
	kfree(psy->full_trig_name);
	kfree(psy->charging_trig_name);
	kfree(psy->charging_full_trig_name);
}
-- 
Daniel J Blueman
