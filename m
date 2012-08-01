Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2HAQuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:50:11 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47823 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2HAQuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:50:09 -0400
Message-ID: <50195E20.90704@linaro.org>
Date: Wed, 01 Aug 2012 09:49:36 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prarit Bhargava <prarit@redhat.com>, Zhouping Liu <zliu@redhat.com>,
        CAI Qian <caiqian@redhat.com>
Subject: Re: [PATCH 1/2] [RFC] time: Fix problem with large timespecs & ktime_get_update_offsets
References: <1343716548-38742-1-git-send-email-john.stultz@linaro.org> <1343716548-38742-2-git-send-email-john.stultz@linaro.org> <alpine.LFD.2.02.1208010850510.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1208010850510.32033@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080116-2356-0000-0000-000000E588CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 11:52 PM, Thomas Gleixner wrote:
> On Tue, 31 Jul 2012, John Stultz wrote:
>> There's currently a slight difference in ktime_get_update_offsets()
>> vs ktime_get() which can result in boot time crashes when booting
>> with insane CMOS clock values larger then ~2264.
>>
>> ktime_get() does basically the following:
>>          return timespec_to_ktime(timespec_add(xtime, wall_to_monotonic))
>>
>> Where as ktime_get_update_offsets does approximately:
>>          return ktime_sub(timespec_to_ktime(xtime), realtime_offset);
>>
>> The problem is, at boot we set xtime = year 8200 and
>> wall_to_monotonic = year -8200,  ktime_get adds both values, mostly
>> nulling the difference out (leaving only how long the system has been
>> up), then converts that relatively small value to a ktime_t properly
>> without losing any information.
>>
>> ktime_get_update_offsets however, since it converts xtime (again set
>> to some value greater then year 8200), to a ktime, it gets clamped at
>> KTIME_MAX, then we subtract realtime_offset, which is _also_ clamped
>> at KTIME_MAX, resulting in us always returning almost[1] zero. This
>> causes us to stop expiring timers.
>>
>> Now, one of the reasons Thomas and I changed the logic was that using
>> the precalculated realtime_offset was slightly more efficient then
>> re-adding xtime and wall_to_monotonic's components separately. But
>> how valuable this unmeasured slight efficiency is vs extra
>> robustness for crazy time values is questionable.
>>
>> So switch back to the ktime_get implementation for
>> ktime_get_update_offsets
> NAK.
>
> You're papering over the real problem: Using crap values without
> sanity checking them in the first place.
>
> All your patch does is papering over the problem. Heck, year 8200 is
> obvious bullshit, so we can detect and reject it.

Ok, sounds good. I'll drop this one and just keep the sanity checking patch.

thanks
-john

