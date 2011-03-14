Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755162Ab1CNIL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:11:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50986 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754599Ab1CNILz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:11:55 -0400
Date: Mon, 14 Mar 2011 19:11:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Richard Cochran <richard.cochran@omicron.at>
Subject: linux-next: manual merge of the tip tree with the vfs tree
Message-Id: <20110314191147.28939ece.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/ia32/ia32entry.S, arch/x86/include/asm/unistd_32.h,
arch/x86/include/asm/unistd_64.h and arch/x86/kernel/syscall_table_32.S
between commits 349f36689b3c ("x86: Add new syscalls for x86_32") and
204a06adf8cb ("x86: Add new syscalls for x86_64") from the vfs tree and
commit ce26efdefa5e ("x86: Add clock_adjtime for x86") from the tip tree.

Just overlapping additions of syscalls.  I fixed it up (see below) and
can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/x86/ia32/ia32entry.S
index 98d353e,9dc128f..0000000
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@@ -851,6 -844,5 +844,7 @@@ ia32_sys_call_table
  	.quad sys_fanotify_init
  	.quad sys32_fanotify_mark
  	.quad sys_prlimit64		/* 340 */
 +	.quad sys_name_to_handle_at
 +	.quad compat_sys_open_by_handle_at
+ 	.quad compat_sys_clock_adjtime
  ia32_syscall_end:
diff --cc arch/x86/include/asm/unistd_32.h
index f4c4973,b6f73f1..0000000
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@@ -346,12 -346,11 +346,13 @@@
  #define __NR_fanotify_init	338
  #define __NR_fanotify_mark	339
  #define __NR_prlimit64		340
 -#define __NR_clock_adjtime	341
 +#define __NR_name_to_handle_at	341
 +#define __NR_open_by_handle_at  342
++#define __NR_clock_adjtime	343
  
  #ifdef __KERNEL__
  
- #define NR_syscalls 343
 -#define NR_syscalls 342
++#define NR_syscalls 344
  
  #define __ARCH_WANT_IPC_PARSE_VERSION
  #define __ARCH_WANT_OLD_READDIR
diff --cc arch/x86/include/asm/unistd_64.h
index 81a3d5b,5ee3085..0000000
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@@ -669,10 -669,8 +669,12 @@@ __SYSCALL(__NR_fanotify_init, sys_fanot
  __SYSCALL(__NR_fanotify_mark, sys_fanotify_mark)
  #define __NR_prlimit64				302
  __SYSCALL(__NR_prlimit64, sys_prlimit64)
 -#define __NR_clock_adjtime			303
 +#define __NR_name_to_handle_at			303
 +__SYSCALL(__NR_name_to_handle_at, sys_name_to_handle_at)
 +#define __NR_open_by_handle_at			304
 +__SYSCALL(__NR_open_by_handle_at, sys_open_by_handle_at)
++#define __NR_clock_adjtime			305
+ __SYSCALL(__NR_clock_adjtime, sys_clock_adjtime)
  
  #ifndef __NO_STUBS
  #define __ARCH_WANT_OLD_READDIR
diff --cc arch/x86/kernel/syscall_table_32.S
index c314b21,68c7b9a..0000000
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@@ -340,5 -340,4 +340,6 @@@ ENTRY(sys_call_table
  	.long sys_fanotify_init
  	.long sys_fanotify_mark
  	.long sys_prlimit64		/* 340 */
 +	.long sys_name_to_handle_at
 +	.long sys_open_by_handle_at
+ 	.long sys_clock_adjtime
