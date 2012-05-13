Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710Ab2EMLI1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 07:08:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54293 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751945Ab2EMLIZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 07:08:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com>
References: <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com>
 <1336571457.30189.29.camel@joe2Laptop> <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
 <CAE9FiQUzsu8CFNLXxUyZnu53YobdNdJfQQmPQd8s8r5rgJpcNg@mail.gmail.com>
 <20120509230649.GA10695@kroah.com> <1336617045.25027.2.camel@mop>
 <CA+1xoqft4aM_qedn+TDx0z8creS_4mFf3S+4SUNjz0pe+=YHAg@mail.gmail.com>
 <20120511151944.GA6990@kroah.com> <CA+55aFz8-96rHLfqRrRSgFAzOFmyDaDKSB15WKkCoUssHq8R-A@mail.gmail.com>
 <CAPXgP11teuiH0cPRrhWdvKCW1jtq4_6wkH21wgRT6UpDF0G1gQ@mail.gmail.com>
 <CA+55aFyG2jQFURwWebMWw7bAt3=zbXRsHSOtZVYBw-frUXqiRg@mail.gmail.com>
 <CA+1xoqf5YbkOJgQJWOgck0NpqGzGtxtHHJASZKHvwVuBzkKK6A@mail.gmail.com> <CA+55aFyeXdUyj_OzccctFSj1f4su1G8DyxiQwD4W5sV9Dh0Zpg@mail.gmail.com>
From: Kay Sievers <kay@vrfy.org>
Date: Sun, 13 May 2012 13:08:04 +0200
Message-ID: <CAPXgP11xpPk3pZo7VbVsEtQvD7DrX1Jm6=tSLME2dMgWSn4oUg@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>, Yinghai Lu <yinghai@kernel.org>,
        Joe Perches <joe@perches.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 8:35 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, May 12, 2012 at 12:43 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>
>> So I got something like this:
>>
>> # sleep 61 ; echo foo > /dev/kmsg ; sleep 61 ; echo bar > /dev/kmsg ;
>> sleep 5 ; echo zoot > /dev/kmsg ; sleep 10 ; echo foo > /dev/kmsg ;
>> echo bar > /dev/kmsg ; sleep 61 ; echo zoot > /dev/kmsg ; echo foo >
>> /dev/kmsg
>>
>> [  673.222632] foo
>> [  734.315249] bar
>> [   +5.077527] zoot
>> [  +10.235225] foo
>> [   +0.002971] bar
>> [  810.883085] zoot
>> [   +0.003081] foo
>>
>> If that looks right, I can send a patch once this printf overhaul is
>> stable, unless Kay already plans on doing it as part of his work.
>
> So judging by my own use, I really think that
>
>  (a) the microseconds are *totally* useless for the absolute time. In
> fact, they are worse than useless: they take up space and are actively
> distracting.
>
>      If the last message was over a minute ago, *nobody* cares about
> the microsecond. The microseconds are useful when there are multiple
> messages and you see that "oh, those events happened within a couple
> of ms of each other", but for the absolute time they are just bad.
>
>     Even the *seconds* are probably not that interesting.
>
>  (b) The one thing I have often wanted is not "after how many seconds
> of boot", but "when". So it would actually be nice if the absolute
> time was converted into local time. The kernel can actually do that,
> so I suspect that the best format for the relative timestamps would
> really be something like
>
>   > [May12 11:27] foo
>   > [May12 11:28] bar
>   > [  +5.077527] zoot
>   > [ +10.235225] foo
>   > [  +0.002971] bar
>   > [May12 11:29] zoot
>   > [  +0.003081] foo
>
> because that would be really useful sometimes.
>
> (And no, never mind the year. If you log those things long-term, the
> year will be in the full log, so logging the year in the dmesg is just
> pointless.)
>
> I dunno. The above is what I would have liked to see quite often. I
> look at dmesg, and notice that I had an WARN_ON_ONCE in it, and I have
> no idea when it happened, because the "seconds since boot" is totally
> useless information for me, as I'm too lazy to try to use /proc/uptime
> to calculate what it is.

Yeah, that looks generally more useful.

"dmesg -T" tries to translate that to wall clock time too. At the
moment, it can't really do that reliable at the point of reading the
timestamps though, because the monotonic time used does not include
the time spent in suspend.

One other problem with the current logic is that the timestamp we get
at the moment is not guaranteed to monotonic, log lines from different
CPUs at the same time can jump forth and back, so the relative-time
calculation could, with the current code, show negative values.

Not sure what options we have to use a more better clock source, if
things are expected to work in NMIs and IRQs.

Kay
