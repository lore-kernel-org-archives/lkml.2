Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab0KIUyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 15:54:32 -0500
Received: from imr4.ericy.com ([198.24.6.8]:36919 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753911Ab0KIUyb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 15:54:31 -0500
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup
 table (rev2)
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4CD9A1DC.2000407@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
	 <1289315711-3011-5-git-send-email-rydberg@euromail.se>
	 <1289329469.22931.221.camel@groeck-laptop>  <4CD9A1DC.2000407@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 12:53:44 -0800
Message-ID: <1289336024.22931.243.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Tue, 2010-11-09 at 14:32 -0500, Henrik Rydberg wrote:
> Hi Guenter,
> 
> >> +/*
> 
> >> + * applesmc_init_smcreg_try - Try to initialize register cache. Idempotent.
> >> + */
> >> +static int applesmc_init_smcreg_try(void)
> >> +{
> >> +       struct applesmc_registers *s = &smcreg;
> >> +       int ret;
> >> +
> >> +       if (s->init_complete)
> >> +               return 0;
> >> +
> >> +       mutex_init(&s->mutex);
> >> +
> > I am a bit concerned that mutex_init() can be called multiple times. Are
> > you sure this is safe ?
> 
> 
> mutex_destroy() is defined as a nop, so I guess the question is whether anything
> could be holding the lock when entering a second init. There are no sysfs files
> created at that point, so I would say no. The mutex could be put back with a
> static initializer, if this is not satisfactory. The real reason to move it to
> the smcreg struct was to force a rename of the mutex itself.
> 

Alternatively, you could move the mutex initialization to the beginning
of applesmc_init_smcreg() and make it
	mutex_init(&smcreg.mutex);

> > 
> >> +       ret = read_register_count(&s->key_count);
> >> +       if (ret)
> >> +               return ret;
> >> +
> >> +       if (!s->cache)
> >> +               s->cache = kcalloc(s->key_count, sizeof(*s->cache), GFP_KERNEL);
> >> +       if (!s->cache)
> >> +               return -ENOMEM;
> >> +
> >> +       s->init_complete = true;
> >> +
> >> +       pr_info("key=%d\n", s->key_count);
> >> +
> > Hope that means more to macbook users than it does to me ;).
> 
> 
> It means a lot from a diagnostic point of view - a normal user does not really
> care about the dmesg output anyways. :-)
> 
Ok, guess I am not a normal user ;).

> >> +static int applesmc_init_smcreg(void)
> >> +{
> >> +       int ms, ret;
> >> +
> >> +       for (ms = 0; ms < INIT_TIMEOUT_MSECS; ms += INIT_WAIT_MSECS) {
> >> +               ret = applesmc_init_smcreg_try();
> >> +               if (!ret)
> >> +                       return 0;
> >> +               pr_warn("slow init, retrying\n");
> > 
> > INIT_WAIT_MS is 50ms, so you issue this warning every 50ms for up to
> > five seconds. Pretty noisy... sure that is what you want ? Also, does it
> > really make sense to retry if the error is ENOMEM ?
> 
> 
> With the empirical failure rate, it is extremely unlikely to get more than a
> couple of failures in a row - information which in itself could be very useful.

You would have alternative options, though, with less noise. For
example, something along the line of

	for (...) {
		...
		if (!ret) {
			if (ms)
				pr_info("smcreg initialization took %d ms\n", ms);
			return 0;
		}
	...
	}
	pr_err("smcreg initialization failed\n");

> A direct escape on ENOMEM makes sense, though.
> 
> Changing the place of the mutex will ripple through all patches, so I will
> resend from this one onwards. I suppose you have more comments on the following
> patches?

Maybe it won't be that bad if you initialize it as I suggested above.

Regarding additional comments - I don't know yet. I didn't have time to
look into the other patches yet. I'll try to do that by tonight.

Guenter


