Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099Ab1D3BHn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 21:07:43 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58473 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757532Ab1D3BHm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 21:07:42 -0400
MIME-Version: 1.0
In-Reply-To: <1304123061.30215.38.camel@work-vm>
References: <tip-304529b1b6f8612ccbb4582e997051b48b94f4a4@git.kernel.org>
	<BANLkTin12hcs1Q=4E4REdF_-zn08EJXzvw@mail.gmail.com>
	<1304123061.30215.38.camel@work-vm>
Date: Fri, 29 Apr 2011 18:07:40 -0700
Message-ID: <BANLkTimyu3C4o+=S7uhi3D-OmUko-xO6Kg@mail.gmail.com>
Subject: Re: [tip:timers/core] time: Add timekeeping_inject_sleeptime
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/29 John Stultz <john.stultz@linaro.org>:
> On Fri, 2011-04-29 at 16:28 -0700, Arve Hjønnevåg wrote:
>> On Fri, Apr 29, 2011 at 10:31 AM, tip-bot for John Stultz
>> > @@ -85,15 +82,13 @@ static int rtc_resume(struct device *dev)
>> >                        pr_debug("%s:  time travel!\n", dev_name(&rtc->dev));
>> >                return 0;
>> >        }
>> > +       /* calculate the RTC time delta */
>> > +       set_normalized_timespec(&time, newtime - oldtime, 0);
>> >
>> > -       /* restore wall clock using delta against this RTC;
>> > -        * adjust again for avg 1/2 second RTC sampling error
>> > -        */
>> > -       set_normalized_timespec(&time,
>> > -                               newtime + delta.tv_sec,
>> > -                               (NSEC_PER_SEC >> 1) + delta.tv_nsec);
>> > -       do_settimeofday(&time);
>> > +       /* subtract kernel time between rtc_suspend to rtc_resume */
>> > +       time = timespec_sub(time, timespec_sub(newts, oldts));
>>
>> The delta you got from the rtc can be almost a second to long or
>> short. Do you do anything to prevent these errors from accumulating?
>
> Indeed. Right now we don't do anything.
>
> I'm hoping to extend the RTC interface to provide finer resolution where
> possible, but that won't help on hardware that really only gives us
> seconds.
>
> We could maybe not only track the suspend time but the RTC time deltas
> for when the system is running as well and utilize those values to avoid
> accumulating the error long term. But then there can be other
> complications between the NTP corrected system time and the uncorrected
> RTC time.
>
> Other ideas? I know you've got a patch in the Android tree to try to
> address this, should I try to adapt it for use here?
>

Unless you can make the generic code handle this (in case
read_persistent_clock has the same problem), then I would recommend
adapting that patch to your new rtc code. We have not noticed the
problem after applying that patch.

-- 
Arve Hjønnevåg
