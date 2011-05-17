Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308Ab1EQIwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:52:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:14678 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab1EQIwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:52:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="643689308"
Message-ID: <4DD23750.3030606@intel.com>
Date: Tue, 17 May 2011 16:52:32 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110402 Iceowl/1.0b2 Icedove/3.1.9
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 5/9] HWPoison: add memory_failure_queue()
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com> <1305619719-7480-6-git-send-email-ying.huang@intel.com> <20110517084622.GE22093@elte.hu>
In-Reply-To: <20110517084622.GE22093@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 04:46 PM, Ingo Molnar wrote:
> 
> * Huang Ying <ying.huang@intel.com> wrote:
> 
>> memory_failure() is the entry point for HWPoison memory error
>> recovery.  It must be called in process context.  But commonly
>> hardware memory errors are notified via MCE or NMI, so some delayed
>> execution mechanism must be used.  In MCE handler, a work queue + ring
>> buffer mechanism is used.
>>
>> In addition to MCE, now APEI (ACPI Platform Error Interface) GHES
>> (Generic Hardware Error Source) can be used to report memory errors
>> too.  To add support to APEI GHES memory recovery, a mechanism similar
>> to that of MCE is implemented.  memory_failure_queue() is the new
>> entry point that can be called in IRQ context.  The next step is to
>> make MCE handler uses this interface too.
>>
>> Signed-off-by: Huang Ying <ying.huang@intel.com>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Wu Fengguang <fengguang.wu@intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>  include/linux/mm.h  |    1 
>>  mm/memory-failure.c |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 93 insertions(+)
> 
> I have to say i disagree with how this is designed and how this is exposed to 
> user-space - and i pointed this out before.
> 
> It's up to Len whether you muck up drivers/acpi/ but here you are patching mm/ 
> again ...
> 
> I just had a quick look into the current affairs of mm/memory-inject.c and it 
> has become an *even* nastier collection of hacks since the last time i 
> commented on its uglies.
> 
> Special hack upon special hack, totally disorganized code, special-purpose, 
> partly ioctl driven opaque information extraction to user-space using the 
> erst-dbg device interface. We have all the maintenance overhead and little of 
> the gains from hw error event features...

Like the name suggested, erst-dbg is only for debugging.  It is not a
user space interface.  The user space interface used by APEI now is printk.

> In this patch you add:
> 
> +struct memory_failure_entry {
> +       unsigned long pfn;
> +       int trapno;
> +       int flags;
> +};
> 
> Instead of exposing this event to other users who might be interested in these 
> events - such as the RAS daemon under development by Boris.
> 
> We have a proper framework (ring-buffer, NMI execution, etc.) for reporting 
> events, why are you not using (and extending) it instead of creating this nasty 
> looking, isolated, ACPI specific low level feature?

This patch has nothing to do with hardware error event reporting.  It is
just about hardware error recovering.

Best Regards,
Huang Ying
