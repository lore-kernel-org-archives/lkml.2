Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954Ab2DRKMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:12:44 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:44350 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752308Ab2DRKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:12:43 -0400
Date: Wed, 18 Apr 2012 11:12:31 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Subject: Possible memory leaks in proc_sysctl.c
Message-ID: <20120418101231.GE1505@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

Following your commit f728019bb (sysctl: register only tables of sysctl
files), I get several kmemleak reports. They all seem to be header
allocations with kzalloc() in __register_sysctl_table() and
__register_sysctl_paths(). The patch isn't simple to quickly figure out
what may be wrong.

Tested on an ARM platform with 3.4-rc3.

unreferenced object 0xbf86c380 (size 128):
  comm "swapper/0", pid 0, jiffies 4294937306 (age 69938.200s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 2c eb 4c 80 00 00 00 00 00 00 00 00  ....,.L.........
  backtrace:
    [<800be064>] create_object+0xe8/0x224
    [<800bb120>] __kmalloc+0x118/0x19c
    [<801116b8>] __register_sysctl_paths+0x128/0x1d0
    [<8048a248>] sysctl_init+0xc/0x18
    [<80483810>] start_kernel+0x310/0x32c
    [<60008044>] 0x60008044
    [<ffffffff>] 0xffffffff
unreferenced object 0xbf862380 (size 64):
  comm "swapper/0", pid 0, jiffies 4294937306 (age 69938.200s)
  hex dump (first 32 bytes):
    84 bf 4e 80 00 00 00 00 01 00 00 00 01 00 00 00  ..N.............
    00 00 00 00 00 00 00 00 28 31 4d 80 28 31 4d 80  ........(1M.(1M.
  backtrace:
    [<800be064>] create_object+0xe8/0x224
    [<800bb120>] __kmalloc+0x118/0x19c
    [<80110f5c>] __register_sysctl_table+0x4c/0x468
    [<801114a4>] register_leaf_sysctl_tables+0x12c/0x200
    [<8011151c>] register_leaf_sysctl_tables+0x1a4/0x200
    [<801116e4>] __register_sysctl_paths+0x154/0x1d0
    [<8048a248>] sysctl_init+0xc/0x18
    [<80483810>] start_kernel+0x310/0x32c
    [<60008044>] 0x60008044
    [<ffffffff>] 0xffffffff
unreferenced object 0xbf8623c0 (size 64):
  comm "swapper/0", pid 0, jiffies 4294937306 (age 69938.200s)
  hex dump (first 32 bytes):
    a8 bf 4e 80 00 00 00 00 01 00 00 00 01 00 00 00  ..N.............
    00 00 00 00 00 00 00 00 28 31 4d 80 28 31 4d 80  ........(1M.(1M.
  backtrace:
    [<800be064>] create_object+0xe8/0x224
    [<800bb120>] __kmalloc+0x118/0x19c
    [<80110f5c>] __register_sysctl_table+0x4c/0x468
    [<801114a4>] register_leaf_sysctl_tables+0x12c/0x200
    [<8011151c>] register_leaf_sysctl_tables+0x1a4/0x200
    [<801116e4>] __register_sysctl_paths+0x154/0x1d0
    [<8048a248>] sysctl_init+0xc/0x18
    [<80483810>] start_kernel+0x310/0x32c
    [<60008044>] 0x60008044
    [<ffffffff>] 0xffffffff
unreferenced object 0xbf973380 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937392 (age 69937.350s)
  hex dump (first 32 bytes):
    c0 06 50 80 00 00 00 00 01 00 00 00 01 00 00 00  ..P.............
    00 00 00 00 c0 06 50 80 28 31 4d 80 28 31 4d 80  ......P.(1M.(1M.
  backtrace:
    [<800be064>] create_object+0xe8/0x224
    [<800bb120>] __kmalloc+0x118/0x19c
    [<80110f5c>] __register_sysctl_table+0x4c/0x468
    [<80111754>] __register_sysctl_paths+0x1c4/0x1d0
    [<8049aa54>] sysctl_core_init+0x1c/0x38
    [<800086dc>] do_one_initcall+0x34/0x17c
    [<804839a0>] kernel_init+0x174/0x21c
    [<8000f978>] kernel_thread_exit+0x0/0x8
    [<ffffffff>] 0xffffffff
unreferenced object 0xbfa27280 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937393 (age 69937.340s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 80 33 4e 80 00 00 00 00 00 00 00 00  .....3N.........
  backtrace:
    [<800be064>] create_object+0xe8/0x224
    [<800bb120>] __kmalloc+0x118/0x19c
    [<801116b8>] __register_sysctl_paths+0x128/0x1d0
    [<8049c810>] inet_init+0xa8/0x28c
    [<800086dc>] do_one_initcall+0x34/0x17c
    [<804839a0>] kernel_init+0x174/0x21c
    [<8000f978>] kernel_thread_exit+0x0/0x8
    [<ffffffff>] 0xffffffff
unreferenced object 0xbfa27100 (size 64):
  comm "swapper/0", pid 1, jiffies 4294937393 (age 69937.340s)
  hex dump (first 32 bytes):
    18 0d 50 80 00 00 00 00 01 00 00 00 01 00 00 00  ..P.............
    00 00 00 00 00 00 00 00 28 31 4d 80 28 31 4d 80  ........(1M.(1M.
  backtrace:
    [<800be064>] create_object+0xe8/0x224
    [<800bb120>] __kmalloc+0x118/0x19c
    [<80110f5c>] __register_sysctl_table+0x4c/0x468
    [<801114a4>] register_leaf_sysctl_tables+0x12c/0x200
    [<8011151c>] register_leaf_sysctl_tables+0x1a4/0x200
    [<801116e4>] __register_sysctl_paths+0x154/0x1d0
    [<8049c810>] inet_init+0xa8/0x28c
    [<800086dc>] do_one_initcall+0x34/0x17c
    [<804839a0>] kernel_init+0x174/0x21c
    [<8000f978>] kernel_thread_exit+0x0/0x8
    [<ffffffff>] 0xffffffff


Thanks.

-- 
Catalin
