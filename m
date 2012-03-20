Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115Ab2CTV4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:56:03 -0400
Received: from mail1.windriver.com ([147.11.146.13]:47407 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755117Ab2CTV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:56:01 -0400
Message-ID: <4F68FCE3.5090403@windriver.com>
Date: Tue, 20 Mar 2012 16:55:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tim Bird <tim.bird@am.sony.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdb: Add message about CONFIG_DEBUG_RODATA on failure
 to install breakpoint
References: <4E7A4413.5000307@am.sony.com> <4F68CD32.3040202@windriver.com> <4F68F731.1040908@am.sony.com>
In-Reply-To: <4F68F731.1040908@am.sony.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 04:31 PM, Tim Bird wrote:
> On 03/20/2012 11:32 AM, Jason Wessel wrote:
>> On 09/21/2011 03:07 PM, Tim Bird wrote:
>>> On x86, if CONFIG_DEBUG_RODATA is set, one cannot set breakpoints
>>> via KDB.  Apparently this is a well-known problem, as at least one distribution
>>> now ships with both KDB enabled and CONFIG_DEBUG_RODATA=y for security reasons.
>>>
>>> This patch just adds an extra printk message to the breakpoint failure case,
>>> in order to provide some useful diagnostics to the user.
>>>
>> The patch is definitely the right idea.  I believe we should try and tell the whole story and only print the message for the type of breakpoint that fails.  It is absolutely the case that you can still use kdb/kdb without recompiling the kernel.
>>
>> I propose a slightly different implementation below.
> The new patch looks fine.

Thanks.  Because you posed the question a while back about potentially changing this such that it works, I thought I might re-open the discussion around further integration with kgdb/kdb and kprobes.   Back in 2008 I explained you can "hack it" so as to use copy on write patches, just for the debugger in order to use software breakpoints.

Something horrible like:

@@ -42,11 +43,24 @@ EXPORT_SYMBOL_GPL(probe_kernel_read);
 long probe_kernel_write(void *dst, void *src, size_t size)
 {
        long ret;
+#ifdef CONFIG_X86
+       unsigned int level;
+       pte_t *pte = lookup_address((unsigned long)dst, &level);
+       int unprotect = !pte_write(*pte);
+#endif
        mm_segment_t old_fs = get_fs();

[...clipped rest of original hack...]

Obviously we are not going to go down the horrible hack route, so I thought I might look at how the kprobe implementation works, because they do deal with read-only pages.   They created a function called text_poke() that is called from arch_arm_probe().

It might be possible to take a short cut and use the arch_arm_probe() directly.  Ultimately I would like to consider just using kprobes instead for things like single stepping etc..., but it still has a few problems with atomic reservations.  This work had been shelved in back 2010, in favor of merging kdb.  I am not sure if anyone wants to take a look at it, but I do think it might warrant some experimentation.

Jason.
