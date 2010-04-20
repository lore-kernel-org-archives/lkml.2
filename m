Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0DTDt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 23:49:56 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63574 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab0DTDtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 23:49:55 -0400
Message-ID: <4BCD246F.4090005@cn.fujitsu.com>
Date: Tue, 20 Apr 2010 11:50:07 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <xiyou.wangcong@gmail.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [BUG] sysfs: don't use allocated key for lockdep
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>

The commit 6992f5334995af474c2b58d010d08bc597f0f2fe
does wrong thing that use allocated key for lockdep_map.

Lockdep requires keys that are static:

lockdep_init_map() {
......
	/*
	 * Sanity check, the lock-class key must be persistent:
	 */
	if (!static_obj(key)) {
		printk("BUG: key %p not in .data!\n", key);
		DEBUG_LOCKS_WARN_ON(1);
		return;
	}
	lock->key = key;
......
}

Could you please fix it.

----------------
One other comment (not relate to this bug, but relate to the commit):
It is not a very good idea that use one lockdep class per sysfs attribute.

First: we don't have too much lockdep class resource.
Second: lockdep validator is O(N*N) algorithm.
        (N is the number of used lockdep class)

So it is recommended that use only one class for a group of locks.

For some nesting requirement, you can use
lock_acquire(...,subclass,...nest_lock,...)

Or change the design.
--------------------

BUG: key ffff880042c68220 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0xe6/0x4fb()
Hardware name: Lenovo WQ T168/T468 G6
Modules linked in: mptsas(+) mptscsih mptbase scsi_transport_sas ext4 jbd2 crc16 uhci_hcd ohci_hcd ehci_hcd
Pid: 1329, comm: modprobe Not tainted 2.6.34-rc3-22949-gbc8a97a-dirty #1
Call Trace:
 [<ffffffff8103ec2c>] warn_slowpath_common+0x7c/0x94
 [<ffffffff8103ec58>] warn_slowpath_null+0x14/0x16
 [<ffffffff8106a5e7>] lockdep_init_map+0xe6/0x4fb
 [<ffffffff8113a87d>] ? sysfs_new_dirent+0x8f/0x104
 [<ffffffff81139e64>] sysfs_add_file_mode+0x66/0xae
 [<ffffffff81250917>] ? transport_add_class_device+0x0/0x39
 [<ffffffff81139ebd>] sysfs_add_file+0x11/0x13
 [<ffffffff81139f7c>] sysfs_create_file+0x2a/0x2c
 [<ffffffff8124aaa0>] device_create_file+0x19/0x1b
 [<ffffffff8125025f>] attribute_container_add_attrs+0x53/0x71
 [<ffffffff8125029f>] attribute_container_add_class_device+0x22/0x27
 [<ffffffff81250931>] transport_add_class_device+0x1a/0x39
 [<ffffffff8125039c>] attribute_container_device_trigger+0x79/0xb9
 [<ffffffff812508bc>] transport_add_device+0x15/0x17
 [<ffffffffa00b41a9>] sas_phy_add+0x25/0x37 [scsi_transport_sas]
 [<ffffffffa00e7ec2>] mptsas_probe_one_phy+0x175/0x711 [mptsas]
[...]
BUG: key ffff880042c68258 not in .data!
BUG: key ffff880042c68290 not in .data!
BUG: key ffff880042c682c8 not in .data!
BUG: key ffff880042c68300 not in .data!
BUG: key ffff880042c68338 not in .data!
BUG: key ffff880042c68370 not in .data!
BUG: key ffff880042c683a8 not in .data!
BUG: key ffff880042c683e0 not in .data!
BUG: key ffff880042c68418 not in .data!
BUG: key ffff880042c68450 not in .data!
BUG: key ffff880042c68488 not in .data!
BUG: key ffff880042c684c0 not in .data!
BUG: key ffff880042c684f8 not in .data!
BUG: key ffff880042c68530 not in .data!
BUG: key ffff880042c68568 not in .data!
BUG: key ffff880042c685a0 not in .data!
BUG: key ffff880042c68220 not in .data!
BUG: key ffff880042c68258 not in .data!
BUG: key ffff880042c68290 not in .data!
BUG: key ffff880042c682c8 not in .data!
BUG: key ffff880042c68300 not in .data!
BUG: key ffff880042c68338 not in .data!
BUG: key ffff880042c68370 not in .data!
BUG: key ffff880042c683a8 not in .data!
BUG: key ffff880042c683e0 not in .data!
BUG: key ffff880042c68418 not in .data!
BUG: key ffff880042c68450 not in .data!
BUG: key ffff880042c68488 not in .data!
BUG: key ffff880042c684c0 not in .data!
BUG: key ffff880042c684f8 not in .data!
BUG: key ffff880042c68530 not in .data!
BUG: key ffff880042c68568 not in .data!
BUG: key ffff880042c685a0 not in .data!
BUG: key ffff880042c68220 not in .data!
BUG: key ffff880042c68258 not in .data!
BUG: key ffff880042c68290 not in .data!
BUG: key ffff880042c682c8 not in .data!
BUG: key ffff880042c68300 not in .data!
BUG: key ffff880042c68338 not in .data!
BUG: key ffff880042c68370 not in .data!
BUG: key ffff880042c683a8 not in .data!
BUG: key ffff880042c683e0 not in .data!
BUG: key ffff880042c68418 not in .data!
BUG: key ffff880042c68450 not in .data!
BUG: key ffff880042c68488 not in .data!
BUG: key ffff880042c684c0 not in .data!
BUG: key ffff880042c684f8 not in .data!
BUG: key ffff880042c68530 not in .data!
BUG: key ffff880042c68568 not in .data!
[...]
