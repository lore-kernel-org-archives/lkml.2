Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab2CEHow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 02:44:52 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50823 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485Ab2CEHov convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 02:44:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of myungjoo.ham@gmail.com designates 10.50.10.198 as permitted sender) smtp.mail=myungjoo.ham@gmail.com; dkim=pass header.i=myungjoo.ham@gmail.com
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201202292359.05122.rjw@sisk.pl>
References: <1328858388-22384-1-git-send-email-myungjoo.ham@samsung.com>
	<201202292359.05122.rjw@sisk.pl>
Date: Mon, 5 Mar 2012 16:44:50 +0900
X-Google-Sender-Auth: 9RGXFqRSdAhCtjbdJYO2LIDu8FE
Message-ID: <CAJ0PZbQeRSpDexdEz9uEWCRArv39Rz=6_0zsGyd6zwcpvbKiYA@mail.gmail.com>
Subject: Re: [PATCH] PM / devfreq: add relation of recommended frequency.
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>, Mike Turquette <mturquette@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/1 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> Sorry, I seem to have overlooked this patch.
>
> On Friday, February 10, 2012, MyungJoo Ham wrote:
>> The semantics of "target frequency" given to devfreq driver from
>> devfreq framework has always been interpretted as "at least" or GLB
>> (greatest lower bound). However, the framework might want the
>> device driver to limit its max frequency (LUB: least upper bound),
>> especially if it is given by thermal framework (it's too hot).
>>
>> Thus, the target fuction should have another parameter to express
>> whether the framework wants GLB or LUB. And, the additional parameter,
>> "u32 options", does it.
>
> I'd call that "flags" (which usually is the case in the kernel for things
> handled with the help of bitwise operators).

Hmm.. I agree. "Flag" looks better.

[]
>> -     if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq)
>> +     if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
>>               freq = devfreq->qos_min_freq;
>> -     if (devfreq->max_freq && freq > devfreq->max_freq)
>> +             options &= ~(1 << 0);
>
> What exactly is the (1 << 0) for?
>
> Whatever the case is I'd just use one flag name, e.g.
> DEVFREQ_LEAST_UPPER_BOUND (equal to (1U << 0), and assume that the other
> option is to be chosen when this flag is not set.
>
>
>> +             options |= DEVFREQ_OPTION_FREQ_LUB;
>
> So the above would become:
>
> +       if (devfreq->qos_min_freq && freq < devfreq->qos_min_freq) {
>                freq = devfreq->qos_min_freq;
> -       if (devfreq->max_freq && freq > devfreq->max_freq)
> +               options |= DEVFREQ_LEAST_UPPER_BOUND;
> +       }
>
>> +     }
>> +     if (devfreq->max_freq && freq > devfreq->max_freq) {
>>               freq = devfreq->max_freq;
>> -     if (devfreq->min_freq && freq < devfreq->min_freq)
>> +             options &= ~(1 << 0);
>> +             options |= DEVFREQ_OPTION_FREQ_GLB;
>> +     }
>
> and this one would become:
>
> +       if (devfreq->max_freq && freq > devfreq->max_freq) {
>                freq = devfreq->max_freq;
> -       if (devfreq->min_freq && freq < devfreq->min_freq)
> +               options &= ~DEVFREQ_LEAST_UPPER_BOUND;
> +       }
>
> Then, the code would be much easier to follow.
>

Ok, I'll remove one of the two. It appears pretty without either one of the two.

>> @@ -771,14 +777,30 @@ module_exit(devfreq_exit);
>>   *                        freq value given to target callback.
>>   * @dev              The devfreq user device. (parent of devfreq)
>>   * @freq     The frequency given to target function
>> + * @floor    false: find LUB first and use GLB if LUB not available.
>> + *           true:  find GLB first and use LUB if GLB not available.
>> + *
>> + * LUB: least upper bound (at least this freq or above, but the least)
>> + * GLB: greatest lower bound (at most this freq or below, but the most)
>>   *
>>   */
>> -struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq)
>> +struct opp *devfreq_recommended_opp(struct device *dev, unsigned long *freq,
>> +                                 bool floor)
>
> Why don't you use "u32 flags" here too?
>

Reading this again, it doesn't matter. That'd use u32 flags, too.

>>  {
>> -     struct opp *opp = opp_find_freq_ceil(dev, freq);
>> +     struct opp *opp;
>>
>> -     if (opp == ERR_PTR(-ENODEV))
>> +     if (floor) {
>
> That would become
>
> +       if (options & DEVFREQ_LEAST_UPPER_BOUND) {
>
> which is a bit more meaningful IMO.
>

Yes.. I agree.

[]
>>
>> +/*
>> + * target callback, which is to provide additional information to the
>> + * devfreq driver.
>> + */
>> +
>> +/* The resulting frequency should be at least this. (least upper bound) */
>> +#define DEVFREQ_OPTION_FREQ_LUB      0x0
>> +/* The resulting frequency should be at most this. (greatest lower bound) */
>> +#define DEVFREQ_OPTION_FREQ_GLB 0x1
>
> As I said, I'd use one option name and call it DEVFREQ_LEAST_UPPER_BOUND.
> It is not necessary to give a name to the alternative. :-)

Yes. ;)



Thank you.



Cheers!
MyungJoo.


-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
