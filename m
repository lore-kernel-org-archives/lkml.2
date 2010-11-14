Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab0KNNdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 08:33:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:62175 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0KNNda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 08:33:30 -0500
Message-ID: <4CDFE516.3050006@windriver.com>
Date: Sun, 14 Nov 2010 07:33:10 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] perf,hw_breakpoint: Initialize hardware api earlier
References: <1289684273-26770-1-git-send-regression-fweisbec@gmail.com> <1289684273-26770-3-git-send-regression-fweisbec@gmail.com> <1289684766.2109.326.camel@laptop>
In-Reply-To: <1289684766.2109.326.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Nov 2010 13:33:11.0548 (UTC) FILETIME=[7B6823C0:01CB8400]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2010 03:46 PM, Peter Zijlstra wrote:
> On Sat, 2010-11-13 at 22:37 +0100, Frederic Weisbecker wrote:
>   
>> From: Jason Wessel <jason.wessel@windriver.com>
>>
>> When using early debugging, the kernel does not initialize the
>> hw_breakpoint API early enough and causes the late initialization of
>> the kernel debugger to fail. The boot arguments are:
>>
>>     earlyprintk=vga ekgdboc=kbd kgdbwait
>>
>> Then simply type "go" at the kdb prompt and boot. The kernel will
>> later emit the message:
>>
>>     kgdb: Could not allocate hwbreakpoints
>>
>> And at that point the kernel debugger will cease to work correctly.
>>
>> The solution is to initialize the hw_breakpoint at the same time that
>> all the other perf call backs are initialized instead of using a
>> core_initcall() initialization which happens well after the kernel
>> debugger can make use of hardware breakpoints.
>>     
>
> How early is it needed? 

The HW breakpoint callback needs to be registered at the same time the
rest of the perf callbacks are registered.  More specifically, the
infrastructure setup needs to be completed before the debugger calls
"register_wide_hw_breakpoint(&attr, NULL)" in arch/x86/kernel/kgdb.c.  
After the debugger calls the registration function, from that point on
perf owns the reservation system for all hw break point registers.

> I've got a patch converting the x86 (still need
> to do the other hardware pmus) to early_initcall() instead of random
> places in the arch bringup (notably before the perf core init).
>
>   

This sounds to me like it would be early enough.  I could certainly run
the simple test case in the patch to make sure it still works, if you
point me to your patch(es).  I imagine I should also test the hand off
procedure where the debugger uses the registers directly up until the
point that perf is capable of handling reservations for the hw
breakpoint slots.

Thanks,
Jason.
