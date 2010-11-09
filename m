Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab0KITdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:33:39 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:34385 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671Ab0KITdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:33:38 -0500
Message-ID: <4CD9A1DC.2000407@euromail.se>
Date: Tue, 09 Nov 2010 20:32:44 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: guenter.roeck@ericsson.com
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup table
 (rev2)
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>	 <1289315711-3011-5-git-send-email-rydberg@euromail.se> <1289329469.22931.221.camel@groeck-laptop>
In-Reply-To: <1289329469.22931.221.camel@groeck-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFtvz-0004PM-8F.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PFtvz-0004PM-8F 9552764d810efd1a6066e9570f080152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

>> +/*

>> + * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
>> + */
>> +static int applesmc_init_smcreg_try(void)
>> +{
>> +       struct applesmc_registers *s = &smcreg;
>> +       int ret;
>> +
>> +       if (s->init_complete)
>> +               return 0;
>> +
>> +       mutex_init(&s->mutex);
>> +
> I am a bit concerned that mutex_init() can be called multiple times. Are
> you sure this is safe ?


mutex_destroy() is defined as a nop, so I guess the question is whether anything
could be holding the lock when entering a second init. There are no sysfs files
created at that point, so I would say no. The mutex could be put back with a
static initializer, if this is not satisfactory. The real reason to move it to
the smcreg struct was to force a rename of the mutex itself.

> 
>> +       ret = read_register_count(&s->key_count);
>> +       if (ret)
>> +               return ret;
>> +
>> +       if (!s->cache)
>> +               s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
>> +       if (!s->cache)
>> +               return -ENOMEM;
>> +
>> +       s->init_complete = true;
>> +
>> +       pr_info("key=%d\n", s->key_count);
>> +
> Hope that means more to macbook users than it does to me ;).


It means a lot from a diagnostic point of view - a normal user does not really
care about the dmesg output anyways. :-)

>> +static int applesmc_init_smcreg(void)
>> +{
>> +       int ms, ret;
>> +
>> +       for (ms = 0; ms < INIT_TIMEOUT_MSECS; ms += INIT_WAIT_MSECS) {
>> +               ret = applesmc_init_smcreg_try();
>> +               if (!ret)
>> +                       return 0;
>> +               pr_warn("slow init, retrying\n");
> 
> INIT_WAIT_MS is 50ms, so you issue this warning every 50ms for up to
> five seconds. Pretty noisy... sure that is what you want ? Also, does it
> really make sense to retry if the error is ENOMEM ?


With the empirical failure rate, it is extremely unlikely to get more than a
couple of failures in a row - information which in itself could be very useful.
A direct escape on ENOMEM makes sense, though.

Changing the place of the mutex will ripple through all patches, so I will
resend from this one onwards. I suppose you have more comments on the following
patches?

Thanks,
Henrik
