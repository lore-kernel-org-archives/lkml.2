Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758523Ab0HDHo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 03:44:29 -0400
Received: from mail.lang.hm ([64.81.33.126]:52734 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756835Ab0HDHo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 03:44:27 -0400
Date: Wed, 4 Aug 2010 00:42:58 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>, "Ted Ts'o" <tytso@mit.edu>,
        linux-pm@lists.linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>, mjg59@srcf.ucam.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <AANLkTikyD94wqWZTWA23K=zvN3RpKB6dDRrvFSv9szMg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008040027140.25170@asgard.lang.hm>
References: <20100801210548.23f77ff6@infradead.org> <alpine.DEB.2.00.1008012153300.25170@asgard.lang.hm> <20100802140933.GB2405@linux.vnet.ibm.com> <alpine.DEB.2.00.1008021627290.29820@asgard.lang.hm> <AANLkTi=1kBuyPS_P+eNLcnRu1mJH6BzpzQW_sENZuL1L@mail.gmail.com>
 <alpine.DEB.2.00.1008022121430.6545@asgard.lang.hm> <AANLkTikhcYzNp8CPp8cqrV7Ey5CLMWu1sJTNxUtEi2as@mail.gmail.com> <alpine.DEB.2.00.1008022203470.6545@asgard.lang.hm> <AANLkTinFT5jq4nUhUpzS5S4TVDQGj0S7RtRgxNhsz2UF@mail.gmail.com>
 <alpine.DEB.2.00.1008031611100.6545@asgard.lang.hm> <20100804001015.GJ2407@linux.vnet.ibm.com> <alpine.DEB.2.00.1008031723530.6545@asgard.lang.hm> <AANLkTinjH0C0bSK=Y2wKASnbJFsR2BN303xBXkaHbmRC@mail.gmail.com> <alpine.DEB.2.00.1008032111350.25170@asgard.lang.hm>
 <AANLkTi=O++qfY7zz5rErqWQn0n4Tj7dfxQNcytjwiP4q@mail.gmail.com> <alpine.DEB.2.00.1008032312440.25170@asgard.lang.hm> <AANLkTikyD94wqWZTWA23K=zvN3RpKB6dDRrvFSv9szMg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-2146013949-1280907779=:25170"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-2146013949-1280907779=:25170
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT

On Wed, 4 Aug 2010, Arve Hj?nnev?g wrote:

> 2010/8/3  <david@lang.hm>:
>> On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:
>>
>>> 2010/8/3  <david@lang.hm>:
>>>>
>>>> On Tue, 3 Aug 2010, Arve Hj?nnev?g wrote:
>>>>
>>>> in this case, another reason you would consider using suspend over idle
>>>> is
>>>> that you can suspend until the next timer that your privilaged
>>>> applications
>>>> have set, and skip timers set by the non-privilaged applications,
>>>> resulting
>>>> in more time asleep.
>>>
>>> Without wakelock or suspend blockers this can still break since a
>>> privileged application may be waiting on a resource held by a
>>> non-privileged application.
>>
>> since the non-privilaged application is never frozen when a privilaged
>> application is running, I'm not sure how you would get this to happen that
>> wouldn't also be a problem with wakelocks.
>
> With wakelocks we annotate that we have important work to do, until
> that work is accomplished we do not suspend. If you modify the idle
> code ignore some processes' timers the system may get stuck in idle
> while waiting for a non-privileged application to release a resource.

if you don't have a wakelock the system could go into suspend under the 
exact same conditions. If the privilaged program wants to be sure of 
preventing this, all it needs to do is to set of timer to take action 
before the timeout.

>>
>> if you want to have a privilaged application keep the system awake while it
>> waits for a non-privilaged application, all it would need to do is to set a
>> timer near enough in the future that it's considered 'awake' all the time.
>> this will cost a context switch every timeout period (for the application to
>> check that it's still waiting and set the next timer), but that's pretty
>> cheap.
>
> No, this will kill your idle power.

you are only doing this every several seconds to prevent the system from 
suspending.

it's possible that I'm making false assumptions about how quickly you want 
to go into full suspend mode.

if a user is doing nothing that would warrent wakelocks, but has an 
unprivilaged application running (a dancing cows game), and is doing 
nothing other than occasionally hitting a button, how short is the timeout 
that you would set that would have the system go into suspend? (i.e. how 
frequently must the user do something to keep the system awake)

or let's use a better example, the user has an unprivilaged book-reader 
application, how quickly must they change pages to prevent the system from 
suspending?

I'm figuring that these times are in the 1-5 minute range.

therefor the timeout period I am mentioning above could easily be one 
wakeup every 40-50 seconds.

that is not going to kill your idle power.

is my assumption about the length of the timeout incorrect?

>>
>> one thing this would destroy is the stats currently built around the
>> wakelock, but since they would be replaced by stats of exactly the type of
>> thing that powertop was written to deal with, I don't see this as a problem
>> (powertop would just have to learn a mode where it ignores the
>> non-privilaged tasks).consolodating tools is a good thing.
>>
>>>>>>> There may well be others.
>>>>>>>
>>>>>>> Whether these distinctions are a good thing or a bad thing is one of
>>>>>>> the topics of this discussion. ?But the distinctions themselves are
>>>>>>> certainly very real, from what I can see.
>>>>>>>
>>>>>>> Or am I missing your point?
>>>>>>
>>>>>> these big distinction that I see as significant seem to be in the
>>>>>> decision
>>>>>> of when to go into the different states, and the difference between the
>>>>>> states ?themselves seem to be less significant (and either very close
>>>>>> to,
>>>>>> or
>>>>>> within the variation that already exists for power saving modes)
>>>>>>
>>>>>> If I'm right bout this, then it would seem to simplify the concept and
>>>>>> change it from some really foreign android-only thing into a special
>>>>>> case
>>>>>> variation of existing core concepts.
>>>>>
>>>>> Suspend is not an android only concept. The android extensions just
>>>>> allow us to aggressively use suspend without loosing (or delaying)
>>>>> wakeup events. On the hardware that we shipped we can enter the same
>>>>> power mode from idle as we do in suspend, but we still use suspend
>>>>> primarily because it stops the monotonic clock and all the timers that
>>>>> use it. Changing suspend to behave more like an idle mode, which seems
>>>>> to be what you are suggesting, would not buy us anything.
>>>>
>>>> Ok, If I am understanding you correctly I think this is an important
>>>> point.
>>>>
>>>> What Android calls suspend is not what other linux distros call suspend,
>>>> it's just a low-power mode with different wakeup rules.
>>>>
>>>> Is this correct?
>>>>
>>>
>>> No. Android suspend is Linux suspend. We just enter it more frequently.
>>
>> In Linux, a full suspend normally takes the system down to a mode that can't
>> be reached by the normal idle mechnism (including powering down
>> peripherals). It also takes significantly different actions to wake up. What
>> you are describing seems much milder than that.
>
> We use the normal suspend sequence. The shipping hardware we have just
> don't need to do lot
>
>>
>>>> If this is the case it seems even more so that the android suspend should
>>>> be
>>>> addressed by tieing into the power management/idle stuff rather than the
>>>> suspend/hibernate side of things
>>>>
>>>> is the reason you want to stop the onotonic clock and the timers because
>>>> the
>>>> applications need to be fooled into thinking no time has passed?
>>>>
>>>
>>> Yes, but this is not an Android extension, it is part of the normal
>>> Linux suspend sequence.
>>
>> no, as noted by others in this thread, normal linux suspend/resume modifies
>> the clock to show that time has passed since the suspend happened.
>>
>
> The monotonic clock always stops. There are a few different ways to
> maintain the realtime clock and we use one of them.
>
>>>> or is it to prevent extranious wakeups?
>>>>
>>> That too.
>>
>> as noted above, this sounds like it's configurable.
>>
>>>> or is it to save additional power?
>>>>
>>> No (assuming you are asking about the clock), the actual hardware
>>> clock (on msm) stops even in idle but it is resynchronized on wakeup
>>> with a clock that never stops when used from idle.
>>
>> so I'm left not understanding the huge desire to stop the monotonic clock.
>>
>
> If you ignore the timers and don't stop the clock they are based on,
> you break a lot of apps when you resume (watchdogs and timeouts
> trigger). If you don't ignore timers, you can't sleep very long with
> existing software.

if you can stop the clocks they are based on, you could also shift them 
into the future. but in any case, significant changes in time can cause 
problems for suspended apps (if nothing else, broken network connections 
because the machines elsewhere timed you out)

>>>>>> you have many different power saving modes, the daemon (or kernel code)
>>>>>> that
>>>>>> is determining which mode to go into would need different logic
>>>>>> (including,
>>>>>> but not limited to the ability to be able to ignore one or more cgroups
>>>>>> of
>>>>>> processes). different power saving modes have different trade-offs, and
>>>>>> some
>>>>>> of them power down different peripherals (which is always a platform
>>>>>> specific, if not system specific set of trade-offs)
>>>>>>
>>>>>
>>>>> The hardware specific idle hook can (and does) decide to go into any
>>>>> power state from idle that does not disrupt any active devices.
>>>>
>>>> This I know is an Andoid specific thing. On other platforms power states
>>>> very definantly can make user visible changes.
>>>
>>> How is this Android specific?
>>
>> you are stating that this must be suspend because low-power idle must be
>> transparent to the user.
>
> It must be transparent to the rest of the system.
>
>>
>> I am saying that on Linux, low-power idle commonly is not transparent to the
>> user, so the requirement for it to be transparent (therefor putting the
>> suspend into a different category) is an Android only requirement.
>>
>
> I'm am not talking about minor latencies. If you have a platform that
> for instance turns off you screen dma when entering idle, it is broken
> whether is running Android or not. If it does the same in suspend it
> is not a problem.

This isn't sounding quite right to me. I've seen too many discussions 
about things like idle and USB devices/hubs/drives/etc getting powered 
down for power savings modes to make me readily accept that everything 
must be as transparent as you imply. Just the case of drive spin-down 
shows that it's possible to do things that would be considered 
destructive, but you have to have a flag and wake-up path to recover 
within a 'reasonable' amount of time (I guess that this could be 
'transparent' if that only implies that things must work eventually, which 
isn't what I read into the statement)

David Lang
--680960-2146013949-1280907779=:25170--
