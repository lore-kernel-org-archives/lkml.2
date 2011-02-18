Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700Ab1BRWyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 17:54:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45433 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1BRWyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 17:54:11 -0500
Date: Fri, 18 Feb 2011 23:54:07 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Deadlock in gpiolib
Message-ID: <20110218225407.GL22310@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just by doing

	echo $gpio > /sys/class/gpio/export
	echo in > /sys/class/gpio/gpio$gpio/direction
	echo $gpio > /sys/class/gpio/unexport

I hit the following lockdep warning:

[   46.300000] =======================================================
[   46.300000] [ INFO: possible circular locking dependency detected ]
[   46.300000] 2.6.38-rc5-00308-g92942b4 #325
[   46.300000] -------------------------------------------------------
[   46.300000] sh/88 is trying to acquire lock:
[   46.300000]  (sysfs_lock){+.+.+.}, at: [<c0197e6c>] gpio_direction_store+0x20/0xf0
[   46.300000] 
[   46.300000] but task is already holding lock:
[   46.300000]  (s_active#7){++++.+}, at: [<c0120c00>] sysfs_write_file+0xe4/0x140
[   46.300000] 
[   46.300000] which lock already depends on the new lock.
[   46.300000] 
[   46.300000] 
[   46.300000] the existing dependency chain (in reverse order) is:
[   46.300000] 
[   46.300000] -> #1 (s_active#7){++++.+}:
[   46.300000]        [<c00706b0>] validate_chain+0x520/0x698
[   46.300000]        [<c007104c>] __lock_acquire+0x824/0x900
[   46.300000]        [<c0071200>] lock_acquire+0xd8/0xf8
[   46.300000]        [<c01218d8>] sysfs_deactivate+0xbc/0x110
[   46.300000]        [<c01224b4>] sysfs_addrm_finish+0x28/0x70
[   46.300000]        [<c01225a8>] sysfs_remove_dir+0x70/0x84
[   46.300000]        [<c0189640>] kobject_del+0x10/0x38
[   46.300000]        [<c01b8f44>] device_del+0x188/0x1a0
[   46.300000]        [<c01b8f68>] device_unregister+0xc/0x18
[   46.300000]        [<c01974e0>] gpio_unexport+0x98/0xdc
[   46.300000]        [<c0197568>] gpio_free+0x44/0x15c
[   46.300000]        [<c01976e8>] unexport_store+0x68/0x9c
[   46.300000]        [<c01bbdd0>] class_attr_store+0x20/0x28
[   46.300000]        [<c0120c24>] sysfs_write_file+0x108/0x140
[   46.300000]        [<c00d3d68>] vfs_write+0xac/0x188
[   46.300000]        [<c00d3efc>] sys_write+0x40/0x6c
[   46.300000]        [<c00289a0>] ret_fast_syscall+0x0/0x38
[   46.300000] 
[   46.300000] -> #0 (sysfs_lock){+.+.+.}:
[   46.300000]        [<c006fc18>] check_prev_add+0x118/0x690
[   46.300000]        [<c00706b0>] validate_chain+0x520/0x698
[   46.300000]        [<c007104c>] __lock_acquire+0x824/0x900
[   46.300000]        [<c0071200>] lock_acquire+0xd8/0xf8
[   46.300000]        [<c026b69c>] mutex_lock_nested+0x58/0x2a8
[   46.300000]        [<c0197e6c>] gpio_direction_store+0x20/0xf0
[   46.300000]        [<c01b7bc4>] dev_attr_store+0x20/0x28
[   46.300000]        [<c0120c24>] sysfs_write_file+0x108/0x140
[   46.300000]        [<c00d3d68>] vfs_write+0xac/0x188
[   46.300000]        [<c00d3efc>] sys_write+0x40/0x6c
[   46.300000]        [<c00289a0>] ret_fast_syscall+0x0/0x38
[   46.300000] 
[   46.300000] other info that might help us debug this:
[   46.300000] 
[   46.300000] 2 locks held by sh/88:
[   46.300000]  #0:  (&buffer->mutex){+.+.+.}, at: [<c0120b44>] sysfs_write_file+0x28/0x140
[   46.300000]  #1:  (s_active#7){++++.+}, at: [<c0120c00>] sysfs_write_file+0xe4/0x140
[   46.300000] 
[   46.300000] stack backtrace:
[   46.300000] [<c002e2e4>] (unwind_backtrace+0x0/0xec) from [<c006f55c>] (print_circular_bug+0xcc/0xe8)
[   46.300000] [<c006f55c>] (print_circular_bug+0xcc/0xe8) from [<c006fc18>] (check_prev_add+0x118/0x690)
[   46.300000] [<c006fc18>] (check_prev_add+0x118/0x690) from [<c00706b0>] (validate_chain+0x520/0x698)
[   46.300000] [<c00706b0>] (validate_chain+0x520/0x698) from [<c007104c>] (__lock_acquire+0x824/0x900)
[   46.300000] [<c007104c>] (__lock_acquire+0x824/0x900) from [<c0071200>] (lock_acquire+0xd8/0xf8)
[   46.300000] [<c0071200>] (lock_acquire+0xd8/0xf8) from [<c026b69c>] (mutex_lock_nested+0x58/0x2a8)
[   46.300000] [<c026b69c>] (mutex_lock_nested+0x58/0x2a8) from [<c0197e6c>] (gpio_direction_store+0x20/0xf0)
[   46.300000] [<c0197e6c>] (gpio_direction_store+0x20/0xf0) from [<c01b7bc4>] (dev_attr_store+0x20/0x28)
[   46.300000] [<c01b7bc4>] (dev_attr_store+0x20/0x28) from [<c0120c24>] (sysfs_write_file+0x108/0x140)
[   46.300000] [<c0120c24>] (sysfs_write_file+0x108/0x140) from [<c00d3d68>] (vfs_write+0xac/0x188)
[   46.300000] [<c00d3d68>] (vfs_write+0xac/0x188) from [<c00d3efc>] (sys_write+0x40/0x6c)
[   46.300000] [<c00d3efc>] (sys_write+0x40/0x6c) from [<c00289a0>] (ret_fast_syscall+0x0/0x38)

I tried to wrap my head around all that sysfs stuff and the implied
locking, but I failed.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
