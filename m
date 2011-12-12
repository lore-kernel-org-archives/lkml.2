Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab1LLVdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 16:33:42 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49999 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753415Ab1LLVdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 16:33:40 -0500
MIME-Version: 1.0
In-Reply-To: <1323725243.2583.27.camel@edumazet-laptop>
References: <1323718578-1157-1-git-send-email-asharma@fb.com>
 <1323718578-1157-3-git-send-email-asharma@fb.com> <1323720791.2583.23.camel@edumazet-laptop>
 <4EE66FE9.1050202@fb.com> <1323725243.2583.27.camel@edumazet-laptop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Mon, 12 Dec 2011 13:33:18 -0800
X-Google-Sender-Auth: fyMFIeXQlkMUDos-iKDV0y7uE28
Message-ID: <CAObL_7GtAd+-JvohjvNZjPuGL0B9dX2vjwnQ2DZNwoqkq-qAzA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Add a thread cpu time implementation to vDSO
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Arun Sharma <asharma@fb.com>, linux-kernel@vger.kernel.org,
        Kumar Sundararajan <kumar@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        john stultz <johnstul@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 1:27 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le lundi 12 décembre 2011 à 13:19 -0800, Arun Sharma a écrit :
>> On 12/12/11 12:13 PM, Eric Dumazet wrote:
>>
>> >> +
>> >> +struct vcpu_data {
>> >> +  struct vpercpu_data vpercpu[NR_CPUS];
>> >> +  unsigned int tsc_khz;
>> >> +  unsigned int tsc_unstable;
>> >> +};
>> >
>> > Thats a showstopper.
>> >
>> > Try to compile the thing with NR_CPUS=4096 ?
>> >
>>
>> I get a link time error:
>>
>> ld: section .data..percpu [0000000001ac2000 -> 0000000001ad48ff]
>> overlaps section .vvar [0000000001ac0000 -> 0000000001b0083f]
>>
>> which I consider better than runtime memory corruption :)
>>
>> I could add a BUILD_BUG_ON() that tries to catch this earlier in the
>> compile process.
>>
>> Re: Fixing the build for NR_CPUS > 64
>>
>> How about something along the lines of the following:
>>
>> From: Arun Sharma <asharma@fb.com>
>> Date: Mon, 12 Dec 2011 13:13:43 -0800
>> Subject: [PATCH] Handle NR_CPUS > 64
>>
>> ---
>
> This only works if CONFIG_X86_L1_CACHE_SHIFT=6
>
> Some configurations have 128 bytes cache lines
>
> But really most modern distros have NR_CPUS > 64
>
>
>

I kind of like the idea of a per-cpu vvar page.

Pros:
- It could be used for very fast and simple userspace TLS.
- Things like gettid() could become vsyscalls.
- Thread time, process time, etc.
- I would use it for my nefarious asynchronous sysret idea.
- The kernel could use the same infrastructure to replace swapgs.
This might not be a win -- swapgs is probably very highly optimized on
modern cpus.
- Other than the core implementation, everything that uses it would be
very easy to understand.

Cons:
- Uses a page, a pte, and everything higher up the page table hierarchy per cpu.
- Takes up a tlb slot.
- Getting it to work with Xen might be interesting.

--Andy
