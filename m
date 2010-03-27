Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab0C0MWH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 08:22:07 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:49806 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752926Ab0C0MWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 08:22:05 -0400
To: linux-kernel@vger.kernel.org
Subject: [2.6.31 and later] "struct pid" leak.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 27 Mar 2010 21:21:57 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got below report with 2.6.33.1 .

unreferenced object 0xde144600 (size 64):
  comm "init", pid 1, jiffies 4294678101 (age 291.508s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 04 76 ae de d1 76 43 c0 d6 08 00 00  .....v...vC.....
  backtrace:
    [<c0481704>] create_object+0x121/0x1ef
    [<c05f546b>] kmemleak_alloc+0x25/0x42
    [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
    [<c047e36e>] kmem_cache_alloc+0x42/0x68
    [<c0437701>] alloc_pid+0x19/0x288
    [<c0428acc>] copy_process+0x95a/0xdac
    [<c04290d8>] do_fork+0x129/0x261
    [<c0407de5>] sys_clone+0x1f/0x24
    [<c040292d>] ptregs_clone+0x15/0x28
    [<ffffffff>] 0xffffffff
unreferenced object 0xdfa96a40 (size 64):
  comm "login", pid 2259, jiffies 4294719437 (age 250.179s)
  hex dump (first 32 bytes):
    02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 60 39 ae de d1 76 43 c0 bb 09 00 00  ....`9...vC.....
  backtrace:
    [<c0481704>] create_object+0x121/0x1ef
    [<c05f546b>] kmemleak_alloc+0x25/0x42
    [<c047e326>] kmemleak_alloc_recursive+0x1c/0x22
    [<c047e36e>] kmem_cache_alloc+0x42/0x68
    [<c0437701>] alloc_pid+0x19/0x288
    [<c0428acc>] copy_process+0x95a/0xdac
    [<c04290d8>] do_fork+0x129/0x261
    [<c0407de5>] sys_clone+0x1f/0x24
    [<c040292d>] ptregs_clone+0x15/0x28
    [<ffffffff>] 0xffffffff

This report is generated whenever /sbin/mingetty (invoked by SysVinit's
/sbin/init in accordance with /etc/inittab) is terminated.

Steps to reproduce.

(1) Go to console.
(2) Try to login. /sbin/mingetty will invoke /bin/login . Terminate /bin/login
    process by either "successful login and logout" or "login failure".
    /sbin/mingetty process will be respawned by /sbin/init after /bin/login
    terminates.
(3) Login as root.
(4) Run "echo scan > /sys/kernel/debug/kmemleak".
(5) Wait for a while.
(6) Run "cat /sys/kernel/debug/kmemleak".

I can find this report with 2.6.31.11 (by manually increasing
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE to 10000).

unreferenced object 0xdeee2200 (size 64):
  comm "init", pid 1, jiffies 4294789063
  backtrace:
    [<c0487114>] create_object+0x135/0x202
    [<c0487206>] kmemleak_alloc+0x25/0x49
    [<c048433b>] kmemleak_alloc_recursive+0x1c/0x22
    [<c0484386>] kmem_cache_alloc+0x45/0xb2
    [<c043826d>] alloc_pid+0x19/0x28c
    [<c04286e4>] copy_process+0x929/0xe62
    [<c04291cb>] do_fork+0x124/0x295
    [<c040177b>] sys_clone+0x24/0x2b
    [<c0402a44>] sysenter_do_call+0x12/0x22
    [<ffffffff>] 0xffffffff

I can't use "git bisect" to find the origin because kmemleak is available for
2.6.31 and later.

/sbin/init calls syscalls such as setsid() which will manipulate "struct pid"
between fork() and execve(). But I haven't succeeded to create test program.

Regards.
