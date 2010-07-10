Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256Ab0GJOl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 10:41:29 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:43328 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab0GJOl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 10:41:28 -0400
Message-ID: <4C388692.4090105@us.ibm.com>
Date: Sat, 10 Jul 2010 07:41:22 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100528 Thunderbird/3.0.5
MIME-Version: 1.0
To: rostedt@goodmis.org
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>, John Kacur <jkacur@redhat.com>,
       Mike Galbraith <efault@gmx.de>, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH 3/4 V2] futex: free_pi_state outside of hb->lock sections
References: <1278714780-788-1-git-send-email-dvhltc@us.ibm.com> <1278714780-788-4-git-send-email-dvhltc@us.ibm.com> <4C37A8FA.2020607@us.ibm.com> <1278721965.1537.173.camel@gandalf.stny.rr.com>
In-Reply-To: <1278721965.1537.173.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2010 05:32 PM, Steven Rostedt wrote:
> On Fri, 2010-07-09 at 15:55 -0700, Darren Hart wrote:
>> Apologies, mangled a rebase and this patch had bits of 4/4 in it.
>> Corrected below:
>>
>>
>> > From f40b8e684df6ed2b1ba9167cad3922ab43f4a717 Mon Sep 17 00:00:00 2001
>> From: Darren Hart<dvhltc@us.ibm.com>
>> Date: Fri, 9 Jul 2010 17:07:10 -0400
>> Subject: [PATCH 3/4 V2] futex: free_pi_state outside of hb->lock sections
>>
>> free_pi_state() calls kfree() and might sleep. To prepare for raw hb->locks,
>> get the calls to free_pi_state() out of the hb->lock() sections.
>>
>> Signed-off-by: Darren Hart<dvhltc@us.ibm.com>
>> Cc: Thomas Gleixner<tglx@linutronix.de>
>> Cc: Peter Zijlstra<peterz@infradead.org>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Eric Dumazet<eric.dumazet@gmail.com>
>> Cc: John Kacur<jkacur@redhat.com>
>> Cc: Steven Rostedt<rostedt@goodmis.org>
>> Cc: Mike Galbraith<efault@gmx.de>
>> ---
>>   kernel/futex.c |    8 +++++---
>>   1 files changed, 5 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/futex.c b/kernel/futex.c
>> index a6cec32..2cd58a2 100644
>> --- a/kernel/futex.c
>> +++ b/kernel/futex.c
>> @@ -1339,7 +1339,6 @@ retry_private:
>
> This is why I always add a space before labels. I have no idea what
> function this was in.
>
>>   			} else if (ret) {
>>   				/* -EDEADLK */
>>   				this->pi_state = NULL;
>> -				free_pi_state(pi_state);
>
> Where do we free the pi state here?

Near the end after goto out_unlock which falls through to the out: 
label. In this case I didn't move it, it just wasn't necessary.

out:
	if (pi_state != NULL)
		free_pi_state(pi_state);


--
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
