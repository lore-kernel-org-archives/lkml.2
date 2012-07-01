Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab2GAJHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:07:50 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42182 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784Ab2GAJHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:07:49 -0400
Message-ID: <4FF0135E.8080008@us.ibm.com>
Date: Sun, 01 Jul 2012 02:07:42 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ben Blum <bblum@andrew.cmu.edu>
CC: Jan Engelhardt <jengelh@inai.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        simon@fire.lp0.eu, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Leap second insertion causes futex to repeatedly timeout
References: <alpine.LNX.2.01.1207010247430.7313@frira.zrqbmnf.qr> <CANcMJZBcpWzJWCdV8XN6cOUsbykZ-0dre=FBP-zRDhHfi1MwrQ@mail.gmail.com> <20120701083605.GA2692@ghc17.ghc.andrew.cmu.edu>
In-Reply-To: <20120701083605.GA2692@ghc17.ghc.andrew.cmu.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12070109-5806-0000-0000-000016D8C161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2012 01:36 AM, Ben Blum wrote:
> On Sun, Jul 01, 2012 at 01:16:13AM -0700, john stultz wrote:
>> On Sat, Jun 30, 2012 at 5:57 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>>> This year's leap second insertion has had the strange effect on at least
>>> Linux versions 3.4.4 (my end) and 3.5-rc4 (Simon's box, Cc) that certain
>>> processes use up all CPU power, because of futexes repeatedly timing
>>> out. This seems to only affect certain processes.
>>>
>>> Simon observes - http://s85.org/owXfmLvt - that
>>> Firefox/Thunderbird/Chrome/Java are affected.
>>>
>>> As for me, it affects VirtualBox, mysqld and ksoftirqd. The processes
>>> continue to run and respond. Most weird: I can stop-start mysqld and the
>>> issue persists. (I would have expected it to go away because the leap
>>> second event would then be in the past that mysqld does not know about
>>> anymore.)
>>>
>>>
>>> Is this a kernel issue? glibc?
>> Some of the reports that the issue is resolved by calling:
>>         $ date -s "`date`"
>> suggests that it might be due to clock_was_set() not being called
>> after the leap second was added, causing some hrtimer confusion.
>>
>> Thomas: does that sound about right?
>>
>> I've got an initial patch to add the clock_was_set() calls where
>> needed, but so far have not been able to reproduce the issue (tried
>> firefox and some simpler futex tests).  I'll keep trying and hopefully
>> have something to send out tomorrow.
>>
>> Again, my apologies for the trouble.
> I can't vouch for whether this is the problem or not, but be very
> careful with clock_was_set()! See this commit:
>
> http://www.mail-archive.com/git-commits-head@vger.kernel.org/msg15039.html
>
> In short, clock_was_set() calls on_each_cpu() which is not allowed to be
> called in atomic context. Watch out for xtime_lock.

Quite right.  The fix is a little awkward due to the need to call it 
outside of holding xtime_lock/timekeeper.lock.

I've just reproduced the issue w/ Thunderbird, and my fix seems to avoid 
the issue. Working up a patch now.

thanks
-john


