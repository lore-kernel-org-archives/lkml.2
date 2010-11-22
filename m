Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782Ab0KVNnk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:43:40 -0500
Received: from hera.kernel.org ([140.211.167.34]:43618 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755129Ab0KVNnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:43:37 -0500
Date: Mon, 22 Nov 2010 13:42:52 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: sliakh.lkml@gmail.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        jiang@cs.ncsu.edu, arjan@infradead.org, castet.matthieu@free.fr,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sliakh.lkml@gmail.com, andi@firstfloor.org, peterz@infradead.org,
        jiang@cs.ncsu.edu, arjan@infradead.org, castet.matthieu@free.fr,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1290410581.2405.24.camel@minggr.sh.intel.com>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/security] x86: Resume trampoline must be executable
Message-ID: <tip-691513f70d3957939a318da970987b876c720861@git.kernel.org>
Git-Commit-ID: 691513f70d3957939a318da970987b876c720861
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 22 Nov 2010 13:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  691513f70d3957939a318da970987b876c720861
Gitweb:     http://git.kernel.org/tip/691513f70d3957939a318da970987b876c720861
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Mon, 22 Nov 2010 14:03:28 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 22 Nov 2010 14:38:52 +0100

x86: Resume trampoline must be executable

commit 5bd5a452(x86: Add NX protection for kernel data) marked the
trampoline area NX - which unsurprisingly breaks resume and cpu
hotplug.

Revert the portion of that commit, which touches the trampoline.

Originally-from: Lin Ming <ming.m.lin@intel.com>
LKML-Reference: <1290410581.2405.24.camel@minggr.sh.intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>
Cc: Xuxian Jiang <jiang@cs.ncsu.edu>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>
Tested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/mm/init_64.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index ce59c05..71a5929 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -788,7 +788,6 @@ void mark_rodata_ro(void)
 	unsigned long rodata_start =
 		((unsigned long)__start_rodata + PAGE_SIZE - 1) & PAGE_MASK;
 	unsigned long end = (unsigned long) &__end_rodata_hpage_align;
-	unsigned long kernel_end = (((unsigned long)&__init_end + HPAGE_SIZE) & HPAGE_MASK);
 	unsigned long text_end = PAGE_ALIGN((unsigned long) &__stop___ex_table);
 	unsigned long rodata_end = PAGE_ALIGN((unsigned long) &__end_rodata);
 	unsigned long data_start = (unsigned long) &_sdata;
@@ -803,7 +802,7 @@ void mark_rodata_ro(void)
 	 * The rodata section (but not the kernel text!) should also be
 	 * not-executable.
 	 */
-	set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);
+	set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
 
 	rodata_test();
 
