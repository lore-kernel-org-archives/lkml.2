Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab1GAP0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:26:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:42693 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756858Ab1GAP0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:26:38 -0400
Date: Fri, 1 Jul 2011 15:26:25 GMT
From: tip-bot for Tejun Heo <tj@kernel.org>
Message-ID: <tip-a26474e8649643e82d71e3a386d5c4bcc0b207ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        conny.seidel@amd.com, tj@kernel.org, cl@linux.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        conny.seidel@amd.com, tj@kernel.org, tglx@linutronix.de, cl@linux.com,
        mingo@elte.hu
In-Reply-To: <20110628094107.GB3386@htj.dyndns.org>
References: <20110628094107.GB3386@htj.dyndns.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-32, NUMA: Fix boot regression caused by NUMA init unification on highmem machines
Git-Commit-ID: a26474e8649643e82d71e3a386d5c4bcc0b207ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:26:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a26474e8649643e82d71e3a386d5c4bcc0b207ef
Gitweb:     http://git.kernel.org/tip/a26474e8649643e82d71e3a386d5c4bcc0b207ef
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Tue, 28 Jun 2011 11:41:07 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 13:38:51 +0200

x86-32, NUMA: Fix boot regression caused by NUMA init unification on highmem machines

During 32/64 NUMA init unification, commit 797390d855 ("x86-32,
NUMA: use sparse_memory_present_with_active_regions()") made
32bit mm init call memory_present() automatically from
active_regions instead of leaving it to each NUMA init path.

This commit description is inaccurate - memory_present() calls
aren't the same for flat and numaq.  After the commit,
memory_present() is only called for the intersection of e820 and
NUMA layout.  Before, on flatmem, memory_present() would be
called from 0 to max_pfn.  After, it would be called only on the
areas that e820 indicates to be populated.

This is how x86_64 works and should be okay as memmap is allowed
to contain holes; however, x86_32 DISCONTIGMEM is missing
early_pfn_valid(), which makes memmap_init_zone() assume that
memmap doesn't contain any hole.  This leads to the following
oops if e820 map contains holes as it often does on machine with
near or more 4GiB of memory by calling pfn_to_page() on a pfn
which isn't mapped to a NUMA node, a reported by Conny Seidel:

  BUG: unable to handle kernel paging request at 000012b0
  IP: [<c1aa13ce>] memmap_init_zone+0x6c/0xf2
  *pdpt =3D 0000000000000000 *pde =3D f000eef3f000ee00
  Oops: 0000 [#1] SMP
  last sysfs file:
  Modules linked in:

  Pid: 0, comm: swapper Not tainted 2.6.39-rc5-00164-g797390d #1 To Be Filled By O.E.M. To Be Filled By O.E.M./E350M1
  EIP: 0060:[<c1aa13ce>] EFLAGS: 00010012 CPU: 0
  EIP is at memmap_init_zone+0x6c/0xf2
  EAX: 00000000 EBX: 000a8000 ECX: 000a7fff EDX: f2c00b80
  ESI: 000a8000 EDI: f2c00800 EBP: c19ffe54 ESP: c19ffe34
   DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
  Process swapper (pid: 0, ti=3Dc19fe000 task=3Dc1a07f60 task.ti=3Dc19fe000)
  Stack:
   00000002 00000000 0023f000 00000000 10000000 00000a00 f2c00000 f2c00b58
   c19ffeb0 c1a80f24 000375fe 00000000 f2c00800 00000800 00000100 00000030
   c1abb768 0000003c 00000000 00000000 00000004 00207a02 f2c00800 000375fe
  Call Trace:
   [<c1a80f24>] free_area_init_node+0x358/0x385
   [<c1a81384>] free_area_init_nodes+0x420/0x487
   [<c1a79326>] paging_init+0x114/0x11b
   [<c1a6cb13>] setup_arch+0xb37/0xc0a
   [<c1a69554>] start_kernel+0x76/0x316
   [<c1a690a8>] i386_start_kernel+0xa8/0xb0

This patch fixes the bug by defining early_pfn_valid() to be the
same as pfn_valid() when DISCONTIGMEM.

Reported-bisected-and-tested-by: Conny Seidel <conny.seidel@amd.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: hans.rosenfeld@amd.com
Cc: Christoph Lameter <cl@linux.com>
Cc: Conny Seidel <conny.seidel@amd.com>
Link: http://lkml.kernel.org/r/20110628094107.GB3386@htj.dyndns.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mmzone_32.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 224e8c5..ffa037f 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -57,6 +57,8 @@ static inline int pfn_valid(int pfn)
 	return 0;
 }
 
+#define early_pfn_valid(pfn)	pfn_valid((pfn))
+
 #endif /* CONFIG_DISCONTIGMEM */
 
 #ifdef CONFIG_NEED_MULTIPLE_NODES
