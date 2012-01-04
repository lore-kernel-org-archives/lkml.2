Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2ADMZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:25:26 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:56315 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091Ab2ADMZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:25:22 -0500
Message-ID: <4F04452C.7020209@canonical.com>
Date: Wed, 04 Jan 2012 13:25:16 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: NeilBrown <neilb@suse.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>, rjw@sisk.pl,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Regression: ONE CPU fails bootup at Re: [3.2.0-RC7] BUG: unable
 to handle kernel NULL pointer dereference at 0000000000000598  1.478005]
 IP: [<ffffffff8107a6c4>] queue_work_on+0x4/0x30
References: <1599287628.20120103171351@eikelenboom.it>  <20120103190754.GA27651@phenom.dumpdata.com>  <1325632188.3037.59.camel@work-vm> <20120104113155.27bf6e46@notabene.brown> <1325638380.3037.69.camel@work-vm> <4F040B25.1080405@canonical.com>
In-Reply-To: <4F040B25.1080405@canonical.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.01.2012 09:17, Stefan Bader wrote:
> On 04.01.2012 01:53, John Stultz wrote:
>> On Wed, 2012-01-04 at 11:31 +1100, NeilBrown wrote:
>>> On Tue, 03 Jan 2012 15:09:48 -0800 John Stultz <john.stultz@linaro.org> wrote:
>>>> >From the stack trace, we've kicked off a rtc_timer_do_work, probably
>>>> from the rtc_initialize_alarm() schedule_work call added in Neil's
>>>> patch.  From there, we call __rtc_set_alarm -> cmos_set_alarm ->
>>>> cmos_rq_disable -> cmos_checkintr -> rtc_update_irq -> schedule_work.
> 
> Sorry, I was off for the evening a while after sending this out. And I just
> started, so a few thing I will be doing later but have not yet had time.
> 
> Over night I had still be thinking on this and maybe one important fact I had
> been ignoring. This really has only been observed on paravirt guests on Xen as
> far as I know. And one thing that I should have pointed out is that
> 
> [    0.792634] rtc_cmos rtc_cmos: rtc core: registered rtc_cmos as rtc0
> [    0.792725] rtc_cmos: probe of rtc_cmos failed with error -38
> 
> So first the registration is done and the first line is the last thing printed
> in the registration function. Then, and that line always comes after, the probe,
> which looks like being done asynchronously, detects that the rtc is not
> implemented. I would assume that this causes the rtc to be unregistered again
> and that is probably the point where, under the right circumstances, the worker
> triggered by the initialize alarm is trying to set another alarm. Probably while
> some of the elements of the structure started to be torn down. I need to check
> on that code path, yet. So right now its more a guess.
> 
>>>>
>>>> So, what it looks to me is that in cmos_checkintr, we grab the cmos->rtc
>>>> and pass that along. Unfortunately, since the cmos->rtc value isn't set
>>>> until after rtc_device_register() returns its null at that point. So
>>>> your patch isn't really fixing the issue, but just reducing the race
>>>> window for the second cpu to schedule the work.
>>>>
>>>> Sigh. I'd guess dropping the schedule_work call from
>>>> rtc_initialize_alarm() is the right approach (see below). When reviewing
>>>> Neil's patch it seemed like a good idea there, but it seems off to me
>>>> now.
>>>>
>>>> Neil, any thoughts on the following? Can you expand on the condition you
>>>> were worried about in around that call?
>>>
>>> If you set an alarm in the future, then shutdown and boot again after that
>>> time, then you will end up with a timer_queue node which is in the past.
>>
>> Thanks for explaining this again.
>>
>> Hrm. It seems the easy answer is to simply not add alarms that are in
>> the past.  Further, I'm a bit perplexed, as if they are in the past, the
>> enabled flag shouldn't be set.   __rtc_read_alarm() does check the
>> current time, so maybe we can make sure we don't return old values? I
>> guess I assumed __rtc_read_alarm() avoided returning stale values, but
>> apparently not.
>>
>>> When this happens the queue gets stuck.  That entry-in-the-past won't get
>>> removed until and interrupt happens and an interrupt won't happen because the
>>> RTC only triggers an interrupt when the alarm is "now".
>>>
>>> So you'll find that e.g. "hwclock" will always tell you that 'select' timed
>>> out.
>>>
>>> So we force the interrupt work to happen at the start just in case.
>>
>> Unfortunately its too early. 
>>
>>> Did you see my proposed patch which converted those calls to do the work
>>> in-process rather than passing it to a worker-thread?  I think that is a
>>> clean fix.
>>
>> I don't think I saw it today. Was it from before the holidays?
>>
> 
> I fear I caused a bit of confusion there. Neil responded to my initial mail
> which was done as a reply to the mail announcing this patch for stable (which
> just was the first thread I could get hold of).
> I will try Neil's patch as well. And in parallel try to see whether the theory I
> had this night makes sense. If it does, then it is only indirectly that the work
> is scheduled too early. In that case just the teardown needs to make sure that
> no work is being run while removal. Well, maybe the question is whether there
> should be a delay in running the irq work until the device really, really is
> completely set up... But that sounds a bit more complicated.

By now I tried Neil's proposed patch and unfortunately that makes things rather
worse. I also played around with the idea of the unregistration race. Maybe
there also is one (that cancel_work_sync should be called before unregistering
the device) but definitely it is not what happens at least in the one CPU case.
I added some more printk's and the crash happens before even the rtc core class
has been fully registered. And no unregister is call has been made either.

Which may point to execution of the irq worker (including a schedule_work)
before the rtc-cmos parts are finished... Would explain why moving the
initialize call further down does at least narrow the window for it to happen...
The only thing I do not understand then is why that seems only to happen on Xen
guests...

-Stefan

>> Even so, at this point, I don't know if we have enough time for testing,
>> so I'm thinking we either just drop the problematic sched_work call or
>> revert the whole thing and try again for 3.3
> 
> That was the reason I was in a bit of hurry to get this back to you. Especially
> since this patch had been marked as stable material and sooner or later will or
> would be added to all the stable releases it applies to.
> 
> Thanks,
> Stefan
> 
>> thanks
>> -john
>>
>>
> 

