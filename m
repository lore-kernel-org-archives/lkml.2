Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756738Ab1GKM1h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 08:27:37 -0400
Received: from webbox1416.server-home.net ([77.236.96.61]:40424 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756480Ab1GKM1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 08:27:36 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Jul 2011 08:27:36 EDT
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Subject: gpiolib.c: possible circular locking dependency detected
Date: Mon, 11 Jul 2011 14:19:55 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-gentoo-r2; KDE/4.6.3; x86_64; ; )
Cc: Grant Likely <grant.likely@secretlab.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201107111419.55719.alexander.stein@systec-electronic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I used a shell script using /sys/class/gpio to export,set/unset and unexport 
GPIOs. Upon unexporting GPIOs I get the dmesg shown below. I didn't find any 
important change in gpiolib.c and fs/sysfs/dir.c between 2.6.39 and git master 
which would fix this.
Has somebody an idea about this?

Regards,
Alexander

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.39+ #5
-------------------------------------------------------
gpio.sh/765 is trying to acquire lock:
 (s_active#40){++++.+}, at: [<c10d566d>] sysfs_addrm_finish+0x27/0x4a
but task is already holding lock:
 (sysfs_lock){+.+.+.}, at: [<c11664a8>] gpio_unexport+0x27/0x77

which lock already depends on the new lock.
the existing dependency chain (in reverse order) is:
-> #1 (sysfs_lock){+.+.+.}:
       [<c104f517>] validate_chain.clone.14+0x425/0x518
       [<c10504d8>] __lock_acquire+0x653/0x6bb
       [<c1050945>] lock_acquire+0x63/0x7b
       [<c130b9e8>] mutex_lock_nested+0x45/0x291
       [<c1166261>] gpio_direction_store+0x20/0xab
       [<c11bf5e9>] dev_attr_store+0x22/0x27
       [<c10d4684>] sysfs_write_file+0xb6/0xe9
       [<c1094841>] vfs_write+0x91/0x10d
       [<c1094a69>] sys_write+0x3e/0x63
       [<c130da4c>] sysenter_do_call+0x12/0x32

-> #0 (s_active#40){++++.+}:
       [<c104ecea>] check_prev_add+0xd5/0x4dd
       [<c104f517>] validate_chain.clone.14+0x425/0x518
       [<c10504d8>] __lock_acquire+0x653/0x6bb
       [<c1050945>] lock_acquire+0x63/0x7b
       [<c10d509e>] sysfs_deactivate+0x85/0xba
       [<c10d566d>] sysfs_addrm_finish+0x27/0x4a
       [<c10d5ac2>] sysfs_remove_dir+0x5f/0x6d
       [<c115594d>] kobject_del+0xf/0x5e
       [<c11c01bd>] device_del+0x12e/0x13a
       [<c11c01d4>] device_unregister+0xb/0x15
       [<c11664e9>] gpio_unexport+0x68/0x77
       [<c1166514>] gpio_free+0x1c/0xa3
       [<c11665df>] unexport_store+0x44/0x49
       [<c11c29ec>] class_attr_store+0x25/0x2a
       [<c10d4684>] sysfs_write_file+0xb6/0xe9
       [<c1094841>] vfs_write+0x91/0x10d
       [<c1094a69>] sys_write+0x3e/0x63
       [<c130da4c>] sysenter_do_call+0x12/0x32

other info that might help us debug this:

3 locks held by gpio.sh/765:
 #0:  (&buffer->mutex){+.+.+.}, at: [<c10d45f3>] sysfs_write_file+0x25/0xe9
 #1:  (s_active#52){.+.+.+}, at: [<c10d4669>] sysfs_write_file+0x9b/0xe9
 #2:  (sysfs_lock){+.+.+.}, at: [<c11664a8>] gpio_unexport+0x27/0x77

stack backtrace:
Pid: 765, comm: gpio.sh Not tainted 2.6.39+ #5
Call Trace:
 [<c130a450>] ? printk+0x19/0x1b
 [<c104e2c6>] print_circular_bug+0x94/0x9d
 [<c104ecea>] check_prev_add+0xd5/0x4dd
 [<c104f517>] validate_chain.clone.14+0x425/0x518
 [<c104fc9c>] ? mark_lock+0x208/0x2d7
 [<c10504d8>] __lock_acquire+0x653/0x6bb
 [<c104d433>] ? lockdep_init_map+0x8a/0x3c3
 [<c1051079>] ? trace_hardirqs_on+0xb/0xd
 [<c1050945>] lock_acquire+0x63/0x7b
 [<c10d566d>] ? sysfs_addrm_finish+0x27/0x4a
 [<c10d509e>] sysfs_deactivate+0x85/0xba
 [<c10d566d>] ? sysfs_addrm_finish+0x27/0x4a
 [<c10d566d>] sysfs_addrm_finish+0x27/0x4a
 [<c10d5ac2>] sysfs_remove_dir+0x5f/0x6d
 [<c115594d>] kobject_del+0xf/0x5e
 [<c11c01bd>] device_del+0x12e/0x13a
 [<c11c01d4>] device_unregister+0xb/0x15
 [<c11664e9>] gpio_unexport+0x68/0x77
 [<c1165417>] ? gpio_set_value_cansleep+0x1c/0x1c
 [<c116659b>] ? gpio_free+0xa3/0xa3
 [<c1166514>] gpio_free+0x1c/0xa3
 [<c116659b>] ? gpio_free+0xa3/0xa3
 [<c11665df>] unexport_store+0x44/0x49
 [<c11c29ec>] class_attr_store+0x25/0x2a
 [<c10d4684>] sysfs_write_file+0xb6/0xe9
 [<c1094841>] vfs_write+0x91/0x10d
 [<c10d45ce>] ? sysfs_poll+0x72/0x72
 [<c1094a69>] sys_write+0x3e/0x63
 [<c130da4c>] sysenter_do_call+0x12/0x32
