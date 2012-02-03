Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab2BCAtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:49:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52142 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab2BCAtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:49:07 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6608"; a="160149931"
Message-ID: <4F2B2F01.20601@codeaurora.org>
Date: Thu, 02 Feb 2012 16:49:05 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Nicolas Pitre <nico@fluxnic.net>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: cache-v7: Disable preemption when reading CCSIDR
References: <1328210686-15909-1-git-send-email-sboyd@codeaurora.org> <20120202204411.GB14129@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1202021632400.2759@xanadu.home> <4F2B1E11.1040000@codeaurora.org> <20120203003633.GD14129@n2100.arm.linux.org.uk>
In-Reply-To: <20120203003633.GD14129@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/12 16:36, Russell King - ARM Linux wrote:
> On Thu, Feb 02, 2012 at 03:36:49PM -0800, Stephen Boyd wrote:
>> On 02/02/12 13:38, Nicolas Pitre wrote:
>>> On Thu, 2 Feb 2012, Russell King - ARM Linux wrote
>>>> On Thu, Feb 02, 2012 at 11:24:46AM -0800, Stephen Boyd wrote:
>>>>> Should we move get_thread_info into assembler.h? It seems odd
>>>>> to include entry-header.S but I saw that vfp was doing the same.
>>>> Probably yes, and probably also have preempt_disable and preempt_enable
>>>> assembler macros.  That's going to get rather icky if we have to
>>>> explicitly call the scheduler though (to solve (1)).
>>> What about a pair of helpers written in C instead?
>>>
>>> v7_flush_dcache_all() could be renamed, and a wrapper function called 
>>> v7_flush_dcache_all() would call the preemption disable helper, call the 
>>> former v7_flush_dcache_all code, then call the preemption enable helper.
>>>
>>> Then __v7_setup() could still call the core cache flush code without 
>>> issues.
>> I tried to put the preemption disable/enable right around the place
>> where it was needed. With this approach we would disable preemption
>> during the entire cache flush. I'm not sure if we want to make this
>> function worse for performance, do we? It certainly sounds easier than
>> writing all the preempt macros in assembly though.
> Err, why do you think it's a big task?
>
> preempt disable is a case of incrementing the thread preempt count, while
> preempt enable is a case of decrementing it, testing for zero, if zero,
> then checking whether TIF_NEED_RESCHED is set and calling a function.
>
> If that's too much, then the simple method in assembly to quickly disable
> preemption over a very few set of instructions is using mrs/msr and cpsid i.
> That'll be far cheaper than fiddling about with preempt counters or
> messing about with veneers in C code.

I'll try the macros. So far it isn't bad, just the __v7_setup to resolve.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

