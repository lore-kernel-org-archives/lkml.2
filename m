Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab2BJDJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 22:09:47 -0500
Received: from mail-qw0-f53.google.com ([209.85.216.53]:43397 "EHLO
	mail-qw0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825Ab2BJDJp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 22:09:45 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
References: <20120206215451.GD21292@google.com>
	<4F30C96F.1000905@kernel.dk>
	<20120207162253.GG21292@google.com>
	<4F315113.5010804@kernel.dk>
	<CA+55aFxcjE4FsUVoarc+8OTi4OkqtgBmHq500=qaCeTqqWnqoA@mail.gmail.com>
	<20120207164735.GH21292@google.com>
	<CANejiEXUZpPzyrTmD-P-MWD-XDmvDoB9UAjDbnrzTEiAw6nsgQ@mail.gmail.com>
	<CANejiEXqLxJ=mhDYA04g4ZHo3CiXctCUVnHu1--yp0GYgPxOKQ@mail.gmail.com>
	<20120208162925.GA19392@google.com>
	<CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
	<20120209175948.GE19392@google.com>
	<CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
Date: Fri, 10 Feb 2012 11:09:44 +0800
X-Google-Sender-Auth: wZ45RCJnoFuTToPxegDpL177SEE
Message-ID: <CANejiEXzeo6D5YYpK=7X=cTnWLoBqLjQKRt2h1rissxeFFaFwQ@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
From: Shaohua Li <shaohua.li@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/10 Linus Torvalds <torvalds@linux-foundation.org>:
> On Thu, Feb 9, 2012 at 9:59 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> * What exactly is the test and what do you measure?  What does "12%
>>  regression" mean?  Is it wallclock time or CPU time?  If it's CPU
>>  time, does systime increase dominate the regression?
>
> Shaohua, it might be interesting to see a profile of the bad case.
>
> Now, quite often these kinds of things don't show anything at all -
> it's just due to cache issues and there's no obvious "we hold spinlock
> X for 15 seconds total". But if it's actual lock contention rather
> than just "more scheduling of worker threads", it should show up in
> the profile quite clearly.
>
> That said, I do think the RCU approach is the right one. The whole
> delayed deallocation (and the replacement patch with rwlocks) really
> smells like "badly done RCU-like behavior" to me.
Appears not a lock contention issue. The system is quite idle, about
20% busy. And top shows no cpu is very busy. Before test runs, the
system has about 2G free memory (from vmstat)

system and user time isn't changed. only real time becomes longer.
This suggests IO is slower or there is more IO. But vmstat and iostat
data doesn't show significant difference between the good and bad
cases. There might be some access pattern changed which makes
swap no efficient or working set is wrongly swaped out.
