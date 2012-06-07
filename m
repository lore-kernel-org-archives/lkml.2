Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab2FGNUb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 09:20:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62036 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999Ab2FGNU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 09:20:29 -0400
Message-ID: <1339075302.3279.14.camel@lappy>
Subject: lp: hung task in lp_open
From: Sasha Levin <levinsasha928@gmail.com>
To: Greg KH <greg@kroah.com>, arnd@arndb.de
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Date: Thu, 07 Jun 2012 15:21:42 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've observed the following hung_test error while fuzzing with trinity inside a KVM guest:

[2966799.413925] INFO: task trinity:7230 blocked for more than 120 seconds.
[2966799.413925] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[2966799.413948] trinity         D ffff88035d9534c8  4576  7230   7227 0x00000000
[2966799.413948]  ffff8808295fbab8 0000000000000046 0000000000000000 ffff880829c6b000
[2966799.413948]  ffff8808295fa000 ffff8808295fa010 ffff8808295fbfd8 ffff8808295fa000
[2966799.414281]  ffff8808295fa010 ffff8808295fbfd8 ffff8808299eb000 ffff880829c6b000
[2966799.414281] Call Trace:
[2966799.414304]  [<ffffffff837cfc25>] ? __mutex_lock_common+0x345/0x590
[2966799.414353]  [<ffffffff837d1535>] schedule+0x55/0x60
[2966799.414366]  [<ffffffff837d18b3>] schedule_preempt_disabled+0x13/0x20
[2966799.414398]  [<ffffffff837cfc65>] __mutex_lock_common+0x385/0x590
[2966799.414474]  [<ffffffff81b99366>] ? lp_open+0x36/0x280
[2966799.414602]  [<ffffffff8106f5ed>] ? sched_clock+0x1d/0x30
[2966799.414616]  [<ffffffff81b99366>] ? lp_open+0x36/0x280
[2966799.414638]  [<ffffffff837cffa0>] mutex_lock_nested+0x40/0x50
[2966799.414638]  [<ffffffff81b99366>] lp_open+0x36/0x280
[2966799.414638]  [<ffffffff81985790>] ? do_raw_spin_unlock+0xd0/0xe0
[2966799.414640]  [<ffffffff8123eddf>] chrdev_open+0x10f/0x160
[2966799.414654]  [<ffffffff8123ecd0>] ? cdev_put+0x10/0x10
[2966799.414691]  [<ffffffff81238449>] do_dentry_open+0x229/0x320
[2966799.414722]  [<ffffffff8123862e>] nameidata_to_filp+0x6e/0x100
[2966799.414748]  [<ffffffff812490fc>] do_last+0x6cc/0x950
[2966799.414770]  [<ffffffff8124bb88>] path_openat+0xd8/0x4d0
[2966799.414806]  [<ffffffff8106f5ed>] ? sched_clock+0x1d/0x30
[2966799.414896]  [<ffffffff811222b7>] ? sched_clock_cpu+0x67/0x120
[2966799.414927]  [<ffffffff8124c094>] do_filp_open+0x44/0xa0
[2966799.414973]  [<ffffffff837d2f20>] ? _raw_spin_unlock+0x30/0x60
[2966799.415062]  [<ffffffff81259dcd>] ? alloc_fd+0x1ed/0x200
[2966799.415081]  [<ffffffff81239925>] do_sys_open+0x125/0x1c0
[2966799.415096]  [<ffffffff812399fc>] sys_open+0x1c/0x20
[2966799.415108]  [<ffffffff837d3f39>] system_call_fastpath+0x16/0x1b
[2966799.415108] 1 lock held by trinity/7230:
[2966799.415117]  #0:  (lp_mutex){+.+.+.}, at: [<ffffffff81b99366>] lp_open+0x36/0x280

This appears to be happening since we can block on port open, which is done within the mutex lock, so that any further lp_open calls with appear to be "hung" on that mutex.

That mutex was added there as part of BKL cleanup.

I'm not sure whether the solution here is to get the lock just on the parts which need locking, or add it as an exception to the hung task monitor.

