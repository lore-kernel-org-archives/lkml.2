Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1CKRGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:06:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50672 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751386Ab1CKRGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:06:01 -0500
Date: Fri, 11 Mar 2011 17:57:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Vagin <avagin@gmail.com>
Cc: Pavel Emelyanov <xemul@openvz.org>, Andrey Vagin <avagin@openvz.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: + x86-mm-handle-mm_fault_error-in-kernel-space.patch added to
	-mm tree
Message-ID: <20110311165700.GA30929@redhat.com>
References: <20110310142812.GA25224@redhat.com> <4D7926C9.9070206@parallels.com> <20110311111931.GA16052@redhat.com> <4D7A2FED.3060200@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7A2FED.3060200@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11, Andrew Vagin wrote:
>
> On 03/11/2011 02:19 PM, Oleg Nesterov wrote:
>>
>> Btw, this may be true, but this is irrelevant. If we shouldn't call
>> out_of_memory() in this case, then we shouldn't call it at all, even
>> if PF_USER.
>
> Yes. We shouldn't call it at all, even if PF_USER.

Then why did you send this patch? If we should not call it, then we
should kill pagefault_out_of_memory() and update the callers instead
of adding the special 'if (PF_USER)' checks.

Yes, the current pagefault_out_of_memory() logic looks a bit suspicious,
but this needs another discussion. Once again, I am arguing against making
it depend on PF_USER, this was my point from the very beginning.

>>> Now pls think what is the
>>> difference between these page faults?
>> The difference is that oom-killer should free the memory in between.
>> _OR_ it can decide to kill us, and _this_ case should be fixed.
>
> We wait memory in __alloc_pages_may_oom(). I think now handle_mm_fault()
> returns VM_FAULT_OOM only if OOM-killer killed current task.

I don't think so, but this doesn't matter.

Once again, if OOM-killer killed current task we do not retry. That is
why my patch checks fatal_signal_pending() to fix the bug. That is all.

The point is, if current was _NOT_ killed we should follow the current
pagefault_out_of_memory() logic or remove pagefault_out_of_memory()
completely.

>> Why do you think the current task should be killed? In this case we
>> do not need oom-killer at all, we could always kill the caller of
>> alloc_page/etc.
>
> You don't understand. alloc_page calls oom-killer himself, then try
> allocate memory again. Pls look at __alloc_pages_slowpath().
> __alloc_pages_slowpat may fail if order > 3 || gfp_mask & __GFP_NOFAIL
> || test_thread_flag(TIF_MEMDIE)

Andrew, please, I know this.

> Probaly you think that oom-killer is called from mm_fault_error() only.
> It's incorrect.

And this too ;)

If nothing else. alloc_page doesn't call oom-killer if it is already
in progress. At least in this case we should retry after it completes.


Either way, I believe this patch should be dropped.

Oleg.

