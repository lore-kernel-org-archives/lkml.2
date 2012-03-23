Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab2CWOIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:08:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:36760 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab2CWOIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:08:14 -0400
X-AuditID: b753bd60-99794ba000007b1b-24-4f6c83cb9d42
X-AuditID: b753bd60-99794ba000007b1b-24-4f6c83cb9d42
Message-ID: <4F6C83C1.9050704@hitachi.com>
Date: Fri, 23 Mar 2012 23:08:01 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        tim.bird@am.sony.com
Subject: Re: [PATCH 2/2] kgdb,debug_core,kgdbts: End DEBUG_RODATA limitation
 using kprobe breakpoints
References: <1332352536-29186-1-git-send-email-jason.wessel@windriver.com> <1332352536-29186-3-git-send-email-jason.wessel@windriver.com> <4F6A9444.4050603@hitachi.com> <4F6B13BC.2070406@windriver.com>
In-Reply-To: <4F6B13BC.2070406@windriver.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/22 20:57), Jason Wessel wrote:
> On 03/21/2012 09:53 PM, Masami Hiramatsu wrote:
>> (2012/03/22 2:55), Jason Wessel wrote:
>>> There has long been a limitation using software breakpoints with a
>>> kernel compiled with CONFIG_DEBUG_RODATA.  The kprobe breakpoint code
>>> has its own text_poke() function which accommodates writing a
>>> breakpoint into a read-only page.  The debug_core can make use of the
>>> text_poke() capabilities by using the kprobes API, specifically
>>> arch_arm_kprobe() and arch_disarm_kprobe().  For now it is safe to use
>>> a single statically allocated kprobe structure to call the kprobes API
>>> because the debug_core breakpoint API is only used when the kernel is
>>> in the debug state.
>>
>> You might misunderstand it. arch_*_kprobe() are not open APIs.
>> Those are kprobes internal APIs (which means that those functions
>> should be used only by kprobes).
>>
>
>
> I was looking for an interface that solved the problem, without having
> to use text_poke directly which is arch specific.  Eventually I would
> like to use the kprobes high level API, but it cannot not be used
> without taking a mutex presently.  This is a separate problem to deal
> with at a later time, because the generic use of kprobes would be
> aimed at having robust single stepping.

I see.

>>> The debug_core will first attempt to use the traditional
>>> probe_kernel_write(), and next try using a kprobe breakpoint.  The
>>> kgdb test suite was updated to run all the software breakpoint tests
>>> when using a kernel with built with CONFIG_DEBUG_RODATA.
>>>
>>> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
>>
>> Nak.
>>
>> No, please don't use kprobes internal function this way, because
>> you can't ensure that the arch_arm_kprobe() has no side-effect.
>>
>> Why don't you use text_poke()? I see that the text_poke()
>> is only for x86, but you already have arch/x86/kernel/kgdb.c for
>> making your own wrapper function.
>
> I will use the arch specific provision to override the
> kgdb_arch_set_breakpoint() and use the text_poke() directly.

Thanks! that's what I meant. You can use __weak attribute.

> Eventually I would like to use the same software breakpoint
> reservation system as kprobes, and that would happen if kgdb ever
> starts using kprobes for single stepping.

Yeah, as far as I can see, current kprobes design assumes that
there is no other part uses sw breakpoint in kernel. But there
is kgdb now.
I think kprobes can share the sw breakpoint instrumentation and
single stepping with kgdb.

Thank you,



-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
