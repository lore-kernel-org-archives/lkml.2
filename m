Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0C3SH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 14:07:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360Ab0C3SH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 14:07:56 -0400
Message-ID: <4BB23D64.70502@redhat.com>
Date: Tue, 30 Mar 2010 14:05:24 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, avi@redhat.com, aarcange@redhat.com,
       akpm@linux-foundation.org, Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>
Subject: Re: [PATCH] increase PREEMPT_BITS to 12 to avoid overflow when starting
 KVM
References: <20100330133634.2f1bf3d6@cuia.bos.redhat.com> <1269971802.5258.524.camel@laptop>
In-Reply-To: <1269971802.5258.524.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2010 01:56 PM, Peter Zijlstra wrote:
> On Tue, 2010-03-30 at 13:36 -0400, Rik van Riel wrote:
>> Increase the PREEMPT_BITS to 12, to deal with a larger number
>> of locks that can be taken in mm_take_all_locks or other places
>> where many instances of the same type of lock can be taken.
>>
>> The overflow of PREEMPT_BITS should be harmless, since it simply
>> increments the counter into the SOFTIRQ_BITS, and the counter
>> will be decremented again later.
>>
>> However, the overflow does lead to backtraces with CONFIG_PREEMPT_DEBUG
>> enabled.
>>
>> Signed-off-by: Rik van Riel<riel@redhat.com>
>> Reported-by: Kent Overstreet<kent.overstreet@gmail.com>
>>
>> ---
>> Kent, does this patch fix the issue you saw?
>>
>> Peter, I know you do not like this approach. However, I could not
>> think of a way around mm_take_all_locks. We need to take those locks
>> and want to track that fact for lock debugging...
>
> Does this even boot? It tramples all over PREEMPT_ACTIVE for x86.

Awww nuts.  I thought PREEMPT_ACTIVE used the same scheme of
adding shifts, but now I see it is hard coded on x86. Doh!

I'm guessing the best thing to do would be to remove the
PREEMPT_ACTIVE #define on x86 and use the one from hardirq.h?

> Also, you'll need to convince mingo and tglx too.. taking that many
> spinlocks is utter suckage..

No argument there.  I can't think of an alternative to mm_take_all_locks
though.  Andrea?
