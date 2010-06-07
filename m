Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0FGH2j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 03:28:39 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:34963 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756302Ab0FGH2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 03:28:38 -0400
Subject: [PATCH] Fix Oops in crash_shrink_memory
From: Pavan Naregundi <pavan@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-WY5vL459Y65+zuxmBxma"
Date: Mon, 07 Jun 2010 12:58:31 +0530
Message-ID: <1275895711.4365.18.camel@pavan.naregundi>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WY5vL459Y65+zuxmBxma
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

Hi Everyone,

Please add me to CC in your reply..

When crashkernel is not enabled, "echo 0 > /sys/kernel/kexec_crash_size"
will generate OOPS message in the kernel. Below is the OOPS message and
other details,

# cat /proc/cmdline 
ro  LANG=en_US.UTF-8 SYSFONT=latarcyrheb-sun16 KEYTABLE=us console=hvc0
rhgb root=UUID=eafd9874-010c-46f9-a0c6-ea8db7c61ac3
# uname -a
Linux XXXXXXXX 2.6.35-rc1 #1 SMP Mon Jun 7 18:04:53 IST 2010 ppc64 ppc64
ppc64 GNU/Linux
# cd /sys/kernel/
# ls
debug               kexec_loaded  profiling      uevent_seqnum
kexec_crash_loaded  mm            security       vmcoreinfo
kexec_crash_size    notes         uevent_helper
# cat kexec_crash_loaded
0
# cat kexec_loaded
0
# cat kexec_crash_size
1
# echo 0 > kexec_crash_size
Unable to handle kernel paging request for data at address 0x00000030
Faulting instruction address: 0xc0000000000930b4
Oops: Kernel access of bad area, sig: 11 [#1]
SMP NR_CPUS=1024 NUMA pSeries
last sysfs file: /sys/kernel/kexec_crash_size
Modules linked in: sunrpc ipv6 ext3 jbd dm_mirror dm_region_hash dm_log
dm_multipath dm_mod uinput sg ehea sr_mod ibmveth cdrom ext4 jbd2
mbcache sd_mod crc_t10dif ibmvscsic scsi_transport_srp scsi_tgt [last
unloaded: scsi_wait_scan]
NIP: c0000000000930b4 LR: c0000000000930ac CTR: c0000000000b7ce0
REGS: c0000000b7803750 TRAP: 0300   Not tainted  (2.6.35-rc1)
MSR: 8000000000009032 <EE,ME,IR,DR>  CR: 28242482  XER: 20000000
DAR: 0000000000000030, DSISR: 0000000040000000
TASK = c0000000b9cc3dc0[1381] 'bash' THREAD: c0000000b7800000 CPU: 12
GPR00: c0000000000930ac c0000000b78039d0 c000000000e885a8
c000000000f42950 
GPR04: c0000000b7803af0 0000000000000008 0000000000000002
c0000000005c6438 
GPR08: 0000000000000000 000000008000000c 0000000000000000
0000000000000000 
GPR12: 0000000040242448 c000000007441e00 00000000100f6210
0000000000000000 
GPR16: 00000000100f4a38 00000000100cfb98 00000000100f4bdc
00000000100f4b4c 
GPR20: 00000000103f4de8 0000000000000000 0000000000000000
00000000100f0000 
GPR24: c0000000005c65c0 0000000000000000 c000000000da83e0
c0000000bc67f780 
GPR28: c0000000bc684ae0 c000000000f42950 c000000000e1e3f8
c000000000da8408 
NIP [c0000000000930b4] .release_resource+0x34/0xe0
LR [c0000000000930ac] .release_resource+0x2c/0xe0
Call Trace:
[c0000000b78039d0] [c0000000000930ac] .release_resource+0x2c/0xe0
(unreliable)
[c0000000b7803a60] [c0000000000d4fc8] .crash_shrink_memory+0x1c8/0x1f0
[c0000000b7803b30] [c0000000000b7d38] .kexec_crash_size_store+0x58/0x90
[c0000000b7803bc0] [c0000000002b0bb4] .kobj_attr_store+0x34/0x50
[c0000000b7803c30] [c000000000226d5c] .sysfs_write_file+0xec/0x1f0
[c0000000b7803ce0] [c00000000019e0bc] .vfs_write+0xec/0x1f0
[c0000000b7803d80] [c00000000019e2e8] .SyS_write+0x58/0xb0
[c0000000b7803e30] [c00000000000852c] syscall_exit+0x0/0x40
Instruction dump:
fba1ffe8 fbc1fff0 fbe1fff8 ebc2b228 7c7f1b78 f8010010 f821ff71 ebbe8000 
7fa3eb78 484e35d9 60000000 e97f0020 <e92b0030> 2fa90000 419e002c
7fbf4800 
---[ end trace afbc780462c9bf4e ]---

When crashkernel is not enabled, crashk_res resource have not been
reserved. Hence crashk_res.parent will be NULL.

Attaching a simple patch to this problem. Patch is tested and resolves this bug.

Thanks..
Pavan

--=-WY5vL459Y65+zuxmBxma
Content-Disposition: attachment; filename="fix-crash_shrink_memory.patch"
Content-Type: text/x-patch; name="fix-crash_shrink_memory.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff -Naur a/kernel/kexec.c b/kernel/kexec.c
--- a/kernel/kexec.c	2010-06-07 18:45:55.050000000 +0530
+++ b/kernel/kexec.c	2010-06-07 18:50:28.070000004 +0530
@@ -1134,7 +1134,7 @@
 
 	free_reserved_phys_range(end, crashk_res.end);
 
-	if (start == end)
+	if ((start == end) && (crashk_res.parent != NULL))
 		release_resource(&crashk_res);
 	crashk_res.end = end - 1;
 

--=-WY5vL459Y65+zuxmBxma--

