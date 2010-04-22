Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab0DVPfR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:35:17 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34185 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab0DVPfP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=DLWeGG9Lx/8rrcrvMb/ydhvwcT46kvBc7FLpdlNuVv1CUKtHYYVMyYseQsPwfyQdQA
         Zgbe/cGi6Dn/u2XXuuhWzvYQnDRniI6TsE+XCDLNrOUFBQy0d6qluhe+G4GoHaKtNLP1
         W4nDAduWLQLnONqwcdremEsmLmlquxTEwTMcU=
MIME-Version: 1.0
In-Reply-To: <x2j40ec3ea41004220618sd05bca74pea1180862e7b0907@mail.gmail.com>
References: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
	 <1271934490.1776.343.camel@laptop>
	 <x2j40ec3ea41004220618sd05bca74pea1180862e7b0907@mail.gmail.com>
Date: Thu, 22 Apr 2010 11:35:11 -0400
X-Google-Sender-Auth: 5dac976bfe1dcbcf
Message-ID: <u2l40ec3ea41004220835m25e0f6c8v7a8ea7fabe756dc@mail.gmail.com>
Subject: Re: [REGRESSION 2.6.30][PATCH v3] sched: update load count only once 
	per cpu in 10 tick update window
From: Chase Douglas <chase.douglas@canonical.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 9:18 AM, Chase Douglas
<chase.douglas@canonical.com> wrote:
> On Thu, Apr 22, 2010 at 7:08 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, 2010-04-13 at 16:19 -0700, Chase Douglas wrote:
>>>
>>> There's a period of 10 ticks where calc_load_tasks is updated by all the
>>> cpus for the load avg. Usually all the cpus do this during the first
>>> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
>>> However, if they wake up calc_load_tasks is not incremented. Thus, if
>>> cpus go idle during the 10 tick period, calc_load_tasks may be
>>> decremented to a non-representative value. This issue can lead to
>>> systems having a load avg of exactly 0, even though the real load avg
>>> could theoretically be up to NR_CPUS.
>>>
>>> This change defers calc_load_tasks accounting after each cpu updates the
>>> count until after the 10 tick update window.
>>>
>>> A few points:
>>>
>>> * A global atomic deferral counter, and not per-cpu vars, is needed
>>>   because a cpu may go NOHZ idle and not be able to update the global
>>>   calc_load_tasks variable for subsequent load calculations.
>>> * It is not enough to add calls to account for the load when a cpu is
>>>   awakened:
>>>   - Load avg calculation must be independent of cpu load.
>>>   - If a cpu is awakend by one tasks, but then has more scheduled before
>>>     the end of the update window, only the first task will be accounted.
>>>
>>
>> Ok, so delaying the whole ILB angle for now, the below is a similar
>> approach to yours but with a more explicit code flow.
>>
>> Does that work for you?
>
> This looks good. I'll run my test case to make sure it fixes the
> scenario we hit, and then I'll ack it when I've confirmed it works.

I've run my test case and it seems to push the load avg numbers as expected.

Acked-by: Chase Douglas <chase.douglas@canonical.com>

BTW, I noticed some trailing whitespace, so I ran it through checkpatch.pl:

ERROR: trailing whitespace
#44: FILE: kernel/sched.c:2936:
+       $

Thanks

-- Chase
