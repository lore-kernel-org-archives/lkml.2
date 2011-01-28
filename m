Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589Ab1A1CYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 21:24:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42555 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1A1CYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 21:24:31 -0500
Message-ID: <4D4228CE.5090601@zytor.com>
Date: Thu, 27 Jan 2011 18:24:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Kees Cook <kees.cook@canonical.com>
CC: matthieu castet <castet.matthieu@free.fr>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] broken ebba638ae723d8a8fc2f7abce5ec18b688b791d7
References: <4D41E86D.8060205@free.fr> <20110127230013.GO4981@outflux.net>
In-Reply-To: <20110127230013.GO4981@outflux.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2011 03:00 PM, Kees Cook wrote:
>
> Yikes, good catch.
>
> arch/x86/kernel/trampoline_64.S uses:
>          movw    $(trampoline_stack_end - r_base), %sp
>
> arch/x86/boot/compressed/head_64.S uses:
>          movl    $boot_stack_end, %eax
>          addl    %ebp, %eax
>          movl    %eax, %esp
>
> what would be safe for arch/x86/kernel/head_32.S ? It uses "stack_start",
> but later after paging set-up. Is the following sane to solve this?
>

To run it before paging is set up, you can't use stack, start; you have 
to use a pointer based on physical address.  You have two problems with 
using stack_start: you're using a linear address to access stack_start, 
and stack_start itself contains a linear address.

It's not entirely clear to me why we don't initialize %ss to __BOOT_DS 
with the other segment registers, but it would make most sense to me:

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index fc293dc..c10f9ba 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -99,7 +99,12 @@ ENTRY(startup_32)
         movl %eax,%es
         movl %eax,%fs
         movl %eax,%gs
+       movl %eax,%ss
  2:
+/*
+ * Set up an initial stack
+ */
+       movl $pa(init_thread_union+THREAD_SIZE), %esp

  /*
   * Clear BSS first so that there are no surprises...

	-hpa
