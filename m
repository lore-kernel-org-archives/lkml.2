Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960Ab0DARLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:11:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814Ab0DARLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:11:47 -0400
Message-ID: <4BB4BDB3.5030400@redhat.com>
Date: Thu, 01 Apr 2010 18:37:23 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in mmu_take_all_locks()
References: <1270117906.1653.139.camel@laptop> <alpine.LFD.2.00.1004011300550.32352@localhost.localdomain> <20100401153205.GO5825@random.random>
In-Reply-To: <20100401153205.GO5825@random.random>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2010 06:32 PM, Andrea Arcangeli wrote:
>
>> I'm not sure whether this is a real well done April 1st joke or if there
>> is someone trying to secure the "bad taste patch of the month" price.
>>
>> Anyway, I don't see a reason why we can't convert those locks to
>> mutexes and get rid of the whole preempt disabled region.
>>      
> Converting those locks to mutexes will also allow to cleanly handle
> XPMEM schedule-in-mmu-notifier-handler requirement the right way.
>    

It would also allow kvm not to take a spinlock over potentially long 
operations (iterating over rmaps) as it does now.

> For now getting rid of the warning is enough though. Changing the
> locking would be possible but it'd slowdown the whole kernel all the
> time even if nobody would ever load the kvm or gru kernel modules.
>
> Let's be practical, this isn't even a syscall, this is only called by
> device driver ioctl and it's about losing 1msec or so in latency, to
> keep the whole kernel as fast as if mmu notifier didn't exist. I don't
> think we should have 1 single wide lock to take in
> mmu_notifier_register and then slowdown the kernel when nobody uses
> mmu notifier at all. Losing 1msec when a VM starts isn't a big deal
> really. If this wasn't the case it wouldn't have been merged in the
> first place I think. Besides with -rt these locks aren't going to hurt
> latency AFIK.
>    

Well, with my patch applied they sure will.

-- 
error compiling committee.c: too many arguments to function

