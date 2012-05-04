Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2EDCnl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 22:43:41 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:43505 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755481Ab2EDCnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 22:43:40 -0400
Message-ID: <4FA34244.4000405@linux.vnet.ibm.com>
Date: Fri, 04 May 2012 10:43:16 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        kvm@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        yoshikawa.takuya@oss.ntt.co.jp
Subject: Re: [RFC] sched: make callers check lock contention for cond_resched_lock()
References: <20120503171244.2debdd80931ccf35f387c5fe@gmail.com> <1336034127.13683.197.camel@twins> <20120503212244.6abbfa8bc3f46a7f7a932bb7@gmail.com> <1336048150.22523.17.camel@twins> <20120503220050.e91938418f882b4075526e08@gmail.com>
In-Reply-To: <20120503220050.e91938418f882b4075526e08@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12050316-0260-0000-0000-000000FC555D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2012 09:00 PM, Takuya Yoshikawa wrote:

> On Thu, 03 May 2012 14:29:10 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Thu, 2012-05-03 at 21:22 +0900, Takuya Yoshikawa wrote:
>>> Although the real use case is out of this RFC patch, we are now discussing
>>> a case in which we may hold a spin_lock for long time, ms order, depending
>>> on workload;  and in that case, other threads -- VCPU threads -- should be
>>> given higher priority for that problematic lock. 
>>
>> Firstly, if you can hold a lock that long, it shouldn't be a spinlock,
> 
> I agree with you in principle, but isn't cond_resched_lock() there for that?
> 
>> secondly why isn't TIF_RESCHED being set if its running that long? That
>> should still make cond_resched_lock() break.
> 
> I see.
> 
> I did some tests using spin_is_contended() and need_resched() and saw
> that need_resched() was called as often as spin_is_contended(), so
> experimentally I understand your point.
> 
> But as I could not see why spin_needbreak() was differently implemented
> depending on CONFIG_PREEMPT, I wanted to understand the meaning.


I think enable CONFIG_PREEMPT means allow preemption in kernel, so if
disabled, we can't reschedule a task if it is running in kernel not the
user space at a given time.

As the cond_resched_lock() was invoked in kernel, and looks like
cpu_relax() will give up cpu(I'm not sure whether this will invoke
schedule on some arch, just because that name...), so we can't do break
if CONFIG_PREEMPT disabled, because that will cause kernel preemption
while not allowed.

May be that's the reason why we need to consider CONFIG_PREEMPT in
spin_needbreak().

Regards,
Michael Wang

> 
> Thanks,
> 	Takuya
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


