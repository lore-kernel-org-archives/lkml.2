Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab0HDXGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:06:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44180 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933100Ab0HDXGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:06:40 -0400
Message-ID: <4C59F24B.1010702@zytor.com>
Date: Wed, 04 Aug 2010 16:05:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
        conny.seidel@amd.com, joerg.roedel@amd.com, Bhavna.Sarathy@amd.com,
        greg@kroah.com, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD machines
References: <1280940316-7966-1-git-send-email-bp@amd64.org> <1280940316-7966-2-git-send-email-bp@amd64.org>
In-Reply-To: <1280940316-7966-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 09:45 AM, Borislav Petkov wrote:
> 
>         2. Do not use swapper_pg_dir to boot secondary CPUs like 64-bit
>         does.
> 
> This patch implements solution 2. It introduces a trampoline_pg_dir
> which has the same layout as swapper_pg_dir with low_mappings. This page
> table is used as the initial page table of the booting CPU. Later in the
> bringup process, it switches to swapper_pg_dir and does a global TLB
> flush. This fixes the crashes in our test cases.
> 

I would like to keep around a page directory with the low mappings
around -- and not use it for kernel threads -- at all times *anyway*.
This means we can remove any current hacks that we have to do around S3
entry and exit, for example.

--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
 /*
  * Enable paging
  */
-	movl $pa(swapper_pg_dir),%eax
+	movl pa(initial_page_table), %eax
 	movl %eax,%cr3		/* set the page table pointer.. */
 	movl %cr0,%eax
 	orl  $X86_CR0_PG,%eax
@@ -608,6 +608,8 @@ ignore_int:
 .align 4
 ENTRY(initial_code)
 	.long i386_start_kernel
+ENTRY(initial_page_table)
+	.long pa(swapper_pg_dir)

 /*
  * BSS section
@@ -623,6 +625,10 @@ ENTRY(swapper_pg_dir)
 #endif
 swapper_pg_fixmap:
 	.fill 1024,4,0
+#ifdef CONFIG_X86_TRAMPOLINE
+ENTRY(trampoline_pg_dir)
+	.fill 1024,4,0
+#endif

I don't really see why this makes sense, though.  It would make more
sense that the initial page table we set up becomes trampoline_pg_dir;
we can then set up and change to swapper_pg_dir almost immediately.

I realize this isn't how the 64-bit code works at the moment, but in a
lot of ways I think it would be better if it did.

	-hpa
