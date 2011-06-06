Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab1FFQpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 12:45:32 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:55553 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab1FFQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 12:45:31 -0400
X-RZG-AUTH: :IGUXYVOIf/Z0yAghYbpIhzghmj8icP68r1arC3zTx2B9G7/X5zri/u5Y1+fsZ6BmRA==
X-RZG-CLASS-ID: mo00
Message-ID: <4DED0423.4050904@die-jansens.de>
Date: Mon, 06 Jun 2011 18:45:23 +0200
From: Arne Jansen <lists@die-jansens.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        npiggin@kernel.dk, akpm@linux-foundation.org, frank.rowand@am.sony.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [debug patch] printk: Add a printk killswitch to robustify NMI
 watchdog messages
References: <4DEB933C.1070900@die-jansens.de> <20110605151323.GA30590@elte.hu> <1307349530.2353.7374.camel@twins> <20110606145827.GD30348@elte.hu> <1307372989.2322.136.camel@twins> <1307375227.2322.161.camel@twins> <20110606155236.GA7374@elte.hu> <1307376039.2322.164.camel@twins> <20110606160810.GA16636@elte.hu> <1307376771.2322.168.camel@twins> <20110606161749.GA22157@elte.hu> <4DED0292.1040605@die-jansens.de>
In-Reply-To: <4DED0292.1040605@die-jansens.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.06.2011 18:38, Arne Jansen wrote:
> On 06.06.2011 18:17, Ingo Molnar wrote:
>>
>> * Peter Zijlstra<peterz@infradead.org> wrote:
>>
>>> On Mon, 2011-06-06 at 18:08 +0200, Ingo Molnar wrote:
>>>> * Peter Zijlstra<peterz@infradead.org> wrote:
>>>>
>>>>> On Mon, 2011-06-06 at 17:52 +0200, Ingo Molnar wrote:
>>>>>> * Peter Zijlstra<peterz@infradead.org> wrote:
>>>>>>
>>>>>>> Needs more staring at, preferably by someone who actually
>>>>>>> understands that horrid mess :/ Also, this all still doesn't make
>>>>>>> printk() work reliably while holding rq->lock.
>>>>>>
>>>>>> So, what about my suggestion to just *remove* the wakeup from there
>>>>>> and use the deferred wakeup mechanism that klogd uses.
>>>>>>
>>>>>> That would make printk() *visibly* more robust in practice.
>>>>>
>>>>> That's currently done from the jiffy tick, do you want to effectively
>>>>> delay releasing the console_sem for the better part of a jiffy?
>>>>
>>>> Yes, and we already do it in some other circumstances.
>>>
>>> We do?
>>
>> Yes, see the whole printk_pending logic, it delays:
>>
>> wake_up_interruptible(&log_wait);
>>
>> to the next jiffies tick.
>>
>>>> Can you see
>>>> any problem with that? klogd is an utter slowpath anyway.
>>>
>>> but console_sem isn't klogd. We delay klogd and that's perfectly
>>> fine, but afaict we don't delay console_sem.
>>
>> But console_sem is really a similar special case as klogd. See, it's
>> about a *printk*. That's rare by definition.
>>
>> If someone on the console sees it he'll be startled by at least 10
>> msecs ;-) So delaying the wakeup to the next jiffy really fits into
>> the same approach as we already do with&log_wait, hm?
>
> As long as it doesn't scramble the order of the messages, the delay
> imho doesn't matter even in very printk-heavy debugging sessions.

And, as important, doesn't reduce the throughput of printk. Having only
100 wakeups/s sounds like the throughput is limited to 100xsizeof(ring 
buffer).

>
>>
>> This would solve a real nightmare that has plagued us ever since
>> printk() has done wakeups directly - i.e. like forever.
>>
>> Thanks,
>>
>> Ingo
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/

