Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab2DYS6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:58:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50780 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757446Ab2DYS63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:58:29 -0400
Date: Wed, 25 Apr 2012 14:58:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Lockdep false positive in sysfs
Message-ID: <Pine.LNX.4.44L0.1204251436140.1206-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter and Tejun:

Here's my problem, which affects several sysfs attribute methods in the 
USB subsystem:

Sysfs attribute A is attached to a USB device D.  When the user writes
to A, the corresponding store method unregisters D's children (it does
not unregister D, though).

Now, some of these children may also be USB devices (i.e., if D is a
hub), and therefore may have the same set of sysfs attributes.  As a
result, A's store method for D will end up removing the A attribute for
device E, where E is a child of D.

This causes lockdep to complain.  When A's method is called, sysfs
tells lockdep that it holds a readlock for the s_active "rwsem"
associated with the A attribute for D.  However the sysfs routine that
removes attributes tells lockdep that it is going to get a writelock
for the s_active associated with the A attribute for E, which is in the
same lockdep class since it belongs to the same attribute.

The resulting splat looks like this:

[ 1004.679564] =============================================
[ 1004.680053] [ INFO: possible recursive locking detected ]
[ 1004.680053] 3.4.0-rc4+ #17 Tainted: G           O
[ 1004.680053] ---------------------------------------------
[ 1004.680053] bash/1256 is trying to acquire lock:
[ 1004.680053]  (s_active#73){++++.+}, at: [<c10c9c2b>] sysfs_hash_and_remove+0x60/0x71
[ 1004.680053] 
[ 1004.680053] but task is already holding lock:
[ 1004.680053]  (s_active#73){++++.+}, at: [<c10c9fce>] sysfs_write_file+0xa7/0xea
[ 1004.680053] 
[ 1004.680053] other info that might help us debug this:
[ 1004.680053]  Possible unsafe locking scenario:
[ 1004.680053] 
[ 1004.680053]        CPU0
[ 1004.680053]        ----
[ 1004.680053]   lock(s_active#73);
[ 1004.680053]   lock(s_active#73);
[ 1004.680053] 
[ 1004.680053]  *** DEADLOCK ***
[ 1004.680053] 
[ 1004.680053]  May be due to missing lock nesting notation
[ 1004.680053] 
[ 1004.680053] 4 locks held by bash/1256:
[ 1004.680053]  #0:  (&buffer->mutex){+.+.+.}, at: [<c10c9f4c>] sysfs_write_file+0x25/0xea
[ 1004.680053]  #1:  (s_active#73){++++.+}, at: [<c10c9fce>] sysfs_write_file+0xa7/0xea
[ 1004.680053]  #2:  (&__lockdep_no_validate__){......}, at: [<f002c376>] usb_deauthorize_device+0x16/0xb2 [usbcore]
[ 1004.680053]  #3:  (&__lockdep_no_validate__){......}, at: [<c1185767>] device_release_driver+0x13/0x25
[ 1004.680053] 
[ 1004.680053] stack backtrace:
[ 1004.680053] Pid: 1256, comm: bash Tainted: G           O 3.4.0-rc4+ #17
[ 1004.680053] Call Trace:
[ 1004.680053]  [<c101ea89>] ? console_unlock+0x1ad/0x1d3
[ 1004.680053]  [<c104f712>] __lock_acquire+0x82f/0xb8a
[ 1004.680053]  [<c104df6d>] ? mark_lock+0x26/0x21f
[ 1004.680053]  [<c104e47a>] ? debug_check_no_locks_freed+0x112/0x11c
[ 1004.680053]  [<c104e31c>] ? trace_hardirqs_on_caller+0x13f/0x17e
[ 1004.680053]  [<c104e366>] ? trace_hardirqs_on+0xb/0xd
[ 1004.680053]  [<c104fde5>] lock_acquire+0x5e/0x75
[ 1004.680053]  [<c10c9c2b>] ? sysfs_hash_and_remove+0x60/0x71
[ 1004.680053]  [<c10caf8c>] sysfs_addrm_finish+0x86/0xd2
[ 1004.680053]  [<c10c9c2b>] ? sysfs_hash_and_remove+0x60/0x71
[ 1004.680053]  [<c10c0000>] ? m_next+0x4c/0x56
[ 1004.680053]  [<c10c0000>] ? m_next+0x4c/0x56
[ 1004.680053]  [<c10c9c2b>] sysfs_hash_and_remove+0x60/0x71
[ 1004.680053]  [<c10cc329>] sysfs_remove_group+0x56/0x77
[ 1004.680053]  [<c118331e>] device_remove_groups+0x17/0x25
[ 1004.680053]  [<c11834b5>] device_remove_attrs+0x1c/0x47
[ 1004.680053]  [<c11835c6>] device_del+0xe6/0x135
[ 1004.680053]  [<f002b658>] usb_disconnect+0x9a/0xd4 [usbcore]
[ 1004.680053]  [<f002b6d6>] hub_quiesce+0x44/0x83 [usbcore]
[ 1004.680053]  [<f002b86c>] hub_disconnect+0x6b/0xdb [usbcore]
[ 1004.680053]  [<f0032f1d>] usb_unbind_interface+0x42/0xf9 [usbcore]
[ 1004.680053]  [<c1185719>] __device_release_driver+0x66/0xa1
[ 1004.680053]  [<c118576e>] device_release_driver+0x1a/0x25
[ 1004.680053]  [<c1185398>] bus_remove_device+0xa3/0xb0
[ 1004.680053]  [<c11835cd>] device_del+0xed/0x135
[ 1004.680053]  [<f00316fb>] usb_disable_device+0x79/0x19b [usbcore]
[ 1004.680053]  [<f0031e1d>] usb_set_configuration+0x18e/0x513 [usbcore]
[ 1004.680053]  [<f002c397>] usb_deauthorize_device+0x37/0xb2 [usbcore]
[ 1004.680053]  [<f0035204>] usb_dev_authorized_store+0x31/0x43 [usbcore]
[ 1004.680053]  [<f00351d3>] ? set_persist+0x67/0x67 [usbcore]
[ 1004.680053]  [<c1182f83>] dev_attr_store+0x1b/0x23
[ 1004.680053]  [<c10c9fe5>] sysfs_write_file+0xbe/0xea
[ 1004.680053]  [<c10c9f27>] ? sysfs_open_file+0x1c6/0x1c6
[ 1004.680053]  [<c108ebc0>] vfs_write+0x74/0xa0
[ 1004.680053]  [<c108ed21>] sys_write+0x3b/0x5d
[ 1004.680053]  [<c1221210>] sysenter_do_call+0x12/0x36

Normally one solves this sort of problem by annotating one of the locks
as a nested call.  But there doesn't appear to be any reasonable way of
doing this for sysfs attributes.

I could work around the problem by having the method do everything in a 
workqueue, but I would prefer not to -- the actions taken by these 
attributes really ought to be synchronous.

Do you guys have any suggestions for better solutions?

Alan Stern

