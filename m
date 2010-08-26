Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0HZQel (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:34:41 -0400
Received: from mx.ij.cx ([212.13.201.15]:57266 "EHLO wes.ijneb.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754183Ab0HZQei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:34:38 -0400
X-Greylist: delayed 2558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Aug 2010 12:34:38 EDT
Date: Thu, 26 Aug 2010 16:51:55 +0100 (BST)
From: Mark Hills <mark@pogo.org.uk>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-kernel@vger.kernel.org
Subject: cgroup: rmdir() does not complete
Message-ID: <alpine.NEB.2.01.1008261415240.8857@jrf.vwaro.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mark@pogo.org.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am experiencing hung tasks when trying to rmdir() on a cgroup. One task 
spins, others queue up behind it with the following:

  INFO: task soaked-cgroup:27257 blocked for more than 120 seconds.
  "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
  soaked-cgrou D ffff8800058157c0     0 27257  29411 0x00000000
  ffff88004ffffdd8 0000000000000086 ffff88004ffffda8 ffff88004ffffeb8
  0000000000000010 ffff880119813780 ffff88004ffffd48 ffff88004fffffd8
  ffff88004fffffd8 000000000000f9b0 00000000000157c0 ffff880137693268
  Call Trace:
  [<ffffffff81115edb>] ? mntput_no_expire+0x24/0xe7
  [<ffffffff81427acd>] __mutex_lock_common+0x14d/0x1b4
  [<ffffffff81108a7c>] ? path_put+0x1d/0x22
  [<ffffffff81427b48>] __mutex_lock_slowpath+0x14/0x16
  [<ffffffff81427c4f>] mutex_lock+0x31/0x4b
  [<ffffffff8110bdf8>] do_rmdir+0x74/0x102
  [<ffffffff8110bebd>] sys_rmdir+0x11/0x13
  [<ffffffff81009b02>] system_call_fastpath+0x16/0x1b

Kernel is from Fedora, 2.6.33.6. In all cases the cgroup contains no 
tasks.

Commit ec64f5 ("fix frequent -EBUSY at rmdir") adds a busy wait loop to 
the rmdir. It looks like what I am seeing here and indicates that some 
cgroup subsystem is busy, indefinitely.

I have not worked out how to reproduce it quickly. My only way is to 
complete a 'dd' command in the cgroup, but then the problem is so rare it 
is slow progress.

Documentation/cgroup.memory.txt describes how force_empty can be required 
in some cases. Does this mean that with the patch above, these cases will 
now spin on rmdir(), instead of returning -EBUSY? How can produce a 
reliable test case requiring memory.force_empty to be used, to test this?

Or is it likely to be some other cause, and how best to find it?

Thanks

-- 
Mark
