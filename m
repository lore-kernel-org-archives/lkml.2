Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2DRNSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:18:16 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:57670 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2DRNSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:18:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, "majianpeng" <majianpeng@gmail.com>
References: <20120418101231.GE1505@arm.com>
Date: Wed, 18 Apr 2012 06:22:09 -0700
In-Reply-To: <20120418101231.GE1505@arm.com> (Catalin Marinas's message of
	"Wed, 18 Apr 2012 11:12:31 +0100")
Message-ID: <m1wr5d18fy.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/UOv3t+W5/Q91rsgnLwZ6SZLoWUUyeFmo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Catalin Marinas <catalin.marinas@arm.com>
X-Spam-Relay-Country: 
Subject: Re: Possible memory leaks in proc_sysctl.c
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas <catalin.marinas@arm.com> writes:

> Hi Eric,
>
> Following your commit f728019bb (sysctl: register only tables of sysctl
> files), I get several kmemleak reports. They all seem to be header
> allocations with kzalloc() in __register_sysctl_table() and
> __register_sysctl_paths(). The patch isn't simple to quickly figure out
> what may be wrong.

Due to a change in the data structure places where we register the
sysctl permanently and ignore the result from the register_sysctl_...
family of functions now report this leak.

majianpeng has done a good of getting kmemleak_not_leak annotations into
the net tree, and I have one of his patches pending to put into my
sysctl tree (see below).

I don't know if the issue is serious enough to warrant putting the
changes into 3.4 but the patches are trivial.

The pending patch for kernel/sysctl.c

Eric


>From 349f2cf150ba9aabdcc24c174f7dab09d3da4508 Mon Sep 17 00:00:00 2001
From: majianpeng <majianpeng@gmail.com>
Date: Tue, 17 Apr 2012 13:45:52 +0800
Subject: [PATCH] sysctl:Remove memleak reports by kmemeleak_not_leak


Signed-off-by: majianpeng <majianpeng@gmail.com>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 4ab1187..136ac3b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1551,7 +1551,7 @@ static struct ctl_table dev_table[] = {
 
 int __init sysctl_init(void)
 {
-	register_sysctl_table(sysctl_base_table);
+	kmemleak_not_leak(register_sysctl_table(sysctl_base_table));
 	return 0;
 }



> Tested on an ARM platform with 3.4-rc3.
>
> unreferenced object 0xbf86c380 (size 128):
>   comm "swapper/0", pid 0, jiffies 4294937306 (age 69938.200s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 2c eb 4c 80 00 00 00 00 00 00 00 00  ....,.L.........
>   backtrace:
>     [<800be064>] create_object+0xe8/0x224
>     [<800bb120>] __kmalloc+0x118/0x19c
>     [<801116b8>] __register_sysctl_paths+0x128/0x1d0
>     [<8048a248>] sysctl_init+0xc/0x18
>     [<80483810>] start_kernel+0x310/0x32c
>     [<60008044>] 0x60008044
>     [<ffffffff>] 0xffffffff
> unreferenced object 0xbf862380 (size 64):
>   comm "swapper/0", pid 0, jiffies 4294937306 (age 69938.200s)
>   hex dump (first 32 bytes):
>     84 bf 4e 80 00 00 00 00 01 00 00 00 01 00 00 00  ..N.............
>     00 00 00 00 00 00 00 00 28 31 4d 80 28 31 4d 80  ........(1M.(1M.
>   backtrace:
>     [<800be064>] create_object+0xe8/0x224
>     [<800bb120>] __kmalloc+0x118/0x19c
>     [<80110f5c>] __register_sysctl_table+0x4c/0x468
>     [<801114a4>] register_leaf_sysctl_tables+0x12c/0x200
>     [<8011151c>] register_leaf_sysctl_tables+0x1a4/0x200
>     [<801116e4>] __register_sysctl_paths+0x154/0x1d0
>     [<8048a248>] sysctl_init+0xc/0x18
>     [<80483810>] start_kernel+0x310/0x32c
>     [<60008044>] 0x60008044
>     [<ffffffff>] 0xffffffff
> unreferenced object 0xbf8623c0 (size 64):
>   comm "swapper/0", pid 0, jiffies 4294937306 (age 69938.200s)
>   hex dump (first 32 bytes):
>     a8 bf 4e 80 00 00 00 00 01 00 00 00 01 00 00 00  ..N.............
>     00 00 00 00 00 00 00 00 28 31 4d 80 28 31 4d 80  ........(1M.(1M.
>   backtrace:
>     [<800be064>] create_object+0xe8/0x224
>     [<800bb120>] __kmalloc+0x118/0x19c
>     [<80110f5c>] __register_sysctl_table+0x4c/0x468
>     [<801114a4>] register_leaf_sysctl_tables+0x12c/0x200
>     [<8011151c>] register_leaf_sysctl_tables+0x1a4/0x200
>     [<801116e4>] __register_sysctl_paths+0x154/0x1d0
>     [<8048a248>] sysctl_init+0xc/0x18
>     [<80483810>] start_kernel+0x310/0x32c
>     [<60008044>] 0x60008044
>     [<ffffffff>] 0xffffffff
> unreferenced object 0xbf973380 (size 64):
>   comm "swapper/0", pid 1, jiffies 4294937392 (age 69937.350s)
>   hex dump (first 32 bytes):
>     c0 06 50 80 00 00 00 00 01 00 00 00 01 00 00 00  ..P.............
>     00 00 00 00 c0 06 50 80 28 31 4d 80 28 31 4d 80  ......P.(1M.(1M.
>   backtrace:
>     [<800be064>] create_object+0xe8/0x224
>     [<800bb120>] __kmalloc+0x118/0x19c
>     [<80110f5c>] __register_sysctl_table+0x4c/0x468
>     [<80111754>] __register_sysctl_paths+0x1c4/0x1d0
>     [<8049aa54>] sysctl_core_init+0x1c/0x38
>     [<800086dc>] do_one_initcall+0x34/0x17c
>     [<804839a0>] kernel_init+0x174/0x21c
>     [<8000f978>] kernel_thread_exit+0x0/0x8
>     [<ffffffff>] 0xffffffff
> unreferenced object 0xbfa27280 (size 64):
>   comm "swapper/0", pid 1, jiffies 4294937393 (age 69937.340s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 80 33 4e 80 00 00 00 00 00 00 00 00  .....3N.........
>   backtrace:
>     [<800be064>] create_object+0xe8/0x224
>     [<800bb120>] __kmalloc+0x118/0x19c
>     [<801116b8>] __register_sysctl_paths+0x128/0x1d0
>     [<8049c810>] inet_init+0xa8/0x28c
>     [<800086dc>] do_one_initcall+0x34/0x17c
>     [<804839a0>] kernel_init+0x174/0x21c
>     [<8000f978>] kernel_thread_exit+0x0/0x8
>     [<ffffffff>] 0xffffffff
> unreferenced object 0xbfa27100 (size 64):
>   comm "swapper/0", pid 1, jiffies 4294937393 (age 69937.340s)
>   hex dump (first 32 bytes):
>     18 0d 50 80 00 00 00 00 01 00 00 00 01 00 00 00  ..P.............
>     00 00 00 00 00 00 00 00 28 31 4d 80 28 31 4d 80  ........(1M.(1M.
>   backtrace:
>     [<800be064>] create_object+0xe8/0x224
>     [<800bb120>] __kmalloc+0x118/0x19c
>     [<80110f5c>] __register_sysctl_table+0x4c/0x468
>     [<801114a4>] register_leaf_sysctl_tables+0x12c/0x200
>     [<8011151c>] register_leaf_sysctl_tables+0x1a4/0x200
>     [<801116e4>] __register_sysctl_paths+0x154/0x1d0
>     [<8049c810>] inet_init+0xa8/0x28c
>     [<800086dc>] do_one_initcall+0x34/0x17c
>     [<804839a0>] kernel_init+0x174/0x21c
>     [<8000f978>] kernel_thread_exit+0x0/0x8
>     [<ffffffff>] 0xffffffff
>
>
> Thanks.
