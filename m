Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab2BSXSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:18:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56831 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab2BSXSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:18:31 -0500
Message-ID: <4F41833B.9010905@kernel.org>
Date: Sun, 19 Feb 2012 15:18:19 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120131 Thunderbird/10.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] i387: support lazy restore of FPU state
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202191423270.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202191426460.3898@i5.linux-foundation.org> <4F417B4F.3040406@zytor.com>
In-Reply-To: <4F417B4F.3040406@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2012 02:44 PM, H. Peter Anvin wrote:
> On 02/19/2012 02:37 PM, Linus Torvalds wrote:
>>
>>  - on *every* task switch from task A, we write A->thread.fpu.last_cpu, 
>>    whether we owned the FPU or not. And we only write a real CPU number in 
>>    the case where we owned it, and the FPU save left the state untouched 
>>    in the FPU.
>>
>>  - so when we switch into task A next time, comparing the current CPU 
>>    number with that 'last_cpu' field inarguably says "when I last switched 
>>    out, I really saved it on this CPU"
>>
>>    That, together with verifying that the per-cpu "fpu_owner_task" matches 
>>    "task A", guarantees that the state is really valid. Because we will 
>>    clear (or set to another task) fpu_owner_task if it ever gets 
>>    switched to anything else.
>>
>> But somebody should really validate this. Think through all the 
>> kernel_fpu_begin() etc cases. I think it looks pretty obvious, and it 
>> really does seem to work and improve task switching, but...
>>
> 
> I think your logic is correct but suboptimal.
> 
> What would make more sense to me is that we write last_cpu when we
> *load* the state.  After all, if you didn't load the state you couldn't
> have modified it.  In kernel_fpu_begin, *if* we end up flushing the
> state, we should set last_cpu to -1 indicating that *no* CPU currently
> owns the state -- after all, even on this CPU we would now have to
> reload the state from memory.
> 

This is obviously wrong for kernel_fpu_begin... what we should do there
is to just set fpu_owner_task to NULL as we no longer have any task's
content in the fpu; no need to much with last_cpu though.

	-hpa

