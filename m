Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757629Ab2CVL6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 07:58:10 -0400
Received: from mail.windriver.com ([147.11.1.11]:60559 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2CVL6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 07:58:05 -0400
Message-ID: <4F6B13BC.2070406@windriver.com>
Date: Thu, 22 Mar 2012 06:57:48 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
CC: <linux-kernel@vger.kernel.org>, <kgdb-bugreport@lists.sourceforge.net>,
        <tim.bird@am.sony.com>
Subject: Re: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation
 using kprobe breakpoints
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com> <1332352536-29186-3-git-send-email-jason.wessel@windriver.com> <4F6A9444.4050603@hitachi.com>
In-Reply-To: <4F6A9444.4050603@hitachi.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 09:53 PM, Masami Hiramatsu wrote:
> (2012/03/22 2:55), Jason Wessel wrote:
>> There has long been a limitation using software breakpoints with a
>> kernel compiled with CONFIG_DEBUG_RODATA.  The kprobe breakpoint code
>> has its own text_poke() function which accommodates writing a
>> breakpoint into a read-only page.  The debug_core can make use of the
>> text_poke() capabilities by using the kprobes API, specifically
>> arch_arm_kprobe() and arch_disarm_kprobe().  For now it is safe to use
>> a single statically allocated kprobe structure to call the kprobes API
>> because the debug_core breakpoint API is only used when the kernel is
>> in the debug state.
> 
> You might misunderstand it. arch_*_kprobe() are not open APIs.
> Those are kprobes internal APIs (which means that those functions
> should be used only by kprobes).
> 


I was looking for an interface that solved the problem, without having
to use text_poke directly which is arch specific.  Eventually I would
like to use the kprobes high level API, but it cannot not be used
without taking a mutex presently.  This is a separate problem to deal
with at a later time, because the generic use of kprobes would be
aimed at having robust single stepping.

> 
>> The debug_core will first attempt to use the traditional
>> probe_kernel_write(), and next try using a kprobe breakpoint.  The
>> kgdb test suite was updated to run all the software breakpoint tests
>> when using a kernel with built with CONFIG_DEBUG_RODATA.
>>
>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> 
> Nak.
> 
> No, please don't use kprobes internal function this way, because
> you can't ensure that the arch_arm_kprobe() has no side-effect.
> 
> Why don't you use text_poke()? I see that the text_poke()
> is only for x86, but you already have arch/x86/kernel/kgdb.c for
> making your own wrapper function.

I will use the arch specific provision to override the
kgdb_arch_set_breakpoint() and use the text_poke() directly.

Eventually I would like to use the same software breakpoint
reservation system as kprobes, and that would happen if kgdb ever
starts using kprobes for single stepping.  A few years back we solved
the problem for hardware breakpoints reservations where the kernel
debugger, perf, ptrace, and kprobes all play nice.


Thanks,
Jason.
