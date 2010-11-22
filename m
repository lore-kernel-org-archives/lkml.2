Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0KVNDY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 08:03:24 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52574 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab0KVNDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 08:03:22 -0500
Subject: Re: -tip tree resume fail, bisect to 5bd5a45(x86: Add NX
 protection for kernel data)
From: Peter Zijlstra <peterz@infradead.org>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, lkml <linux-kernel@vger.kernel.org>,
        tglx <tglx@linutronix.de>
In-Reply-To: <1290410581.2405.24.camel@minggr.sh.intel.com>
References: <1290410581.2405.24.camel@minggr.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 22 Nov 2010 14:03:28 +0100
Message-ID: <1290431008.2072.119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 15:23 +0800, Lin Ming wrote:
> Hi, all
> 
> Current -tip tree(92c883a) fail to resume after suspend to mem.
> Bisect to commit 5bd5a45(x86: Add NX protection for kernel data).

Drad, if only I'd looked at LKML before I did the bisection myself..

> commit 5bd5a452662bc37c54fb6828db1a3faf87e6511c
> Author: Matthieu Castet <castet.matthieu@free.fr>
> Date:   Tue Nov 16 22:31:26 2010 +0100
> 
>     x86: Add NX protection for kernel data
> 
> 
> I did some debug and found the regression is caused by below line.
> 
> -       set_memory_nx(rodata_start, (end - rodata_start) >> PAGE_SHIFT);
> +       set_memory_nx(rodata_start, (kernel_end - rodata_start) >> PAGE_SHIFT);


Confirmed, with that hunk reverted my machine works again..

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
 

