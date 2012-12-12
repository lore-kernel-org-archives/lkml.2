Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab2LLQVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:21:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55882 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528Ab2LLQVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:21:20 -0500
Message-ID: <50C8AED2.4040204@ti.com>
Date: Wed, 12 Dec 2012 10:20:34 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: NeilBrown <neilb@suse.de>, Grant Erickson <marathon96@gmail.com>,
        <linux-omap@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
References: <20121212192430.50cea126@notabene.brown> <20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20121212113145.GA23598@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/12/2012 05:31 AM, Thierry Reding wrote:
> On Wed, Dec 12, 2012 at 07:24:30PM +1100, NeilBrown wrote:

[snip]

>> +static int omap_pwm_enable(struct pwm_chip *chip, struct pwm_device *pwm)
>> +{
>> +	struct omap_chip *omap = to_omap_chip(chip);
>> +	int status = 0;
>> +
>> +	/* Enable the counter--always--before attempting to write its
>> +	 * registers and then set the timer to its minimum load value to
>> +	 * ensure we get an overflow event right away once we start it.
>> +	 */
> 
> Block comments should be in the following format:
> 
> 	/*
> 	 * foo...
> 	 * bar...
> 	 */
> 
>> +
>> +	omap_dm_timer_enable(omap->dm_timer);
>> +	omap_dm_timer_write_counter(omap->dm_timer, DM_TIMER_LOAD_MIN);
>> +	omap_dm_timer_start(omap->dm_timer);
>> +	omap_dm_timer_disable(omap->dm_timer);
> 
> So omap_dm_timer_disable() doesn't actually stop the timer? It just
> disables the access to the registers?

I thought this looked odd too ;-)

So what is going on here is that omap_dm_timer_start() calls
omap_dm_timer_enable() but does not call omap_dm_timer_disable(). So the
last disable really just complements the first enable (ie. decrements
the use count), but the timer will not actually be disabled, because the
start has called an extra enable.

These four function calls can be replaced by one call to
omap_dm_timer_set_load_start() and I think that will be much clearer and
concise.

In general, it should not be necessary to call these
omap_dm_timer_enable/disable APIs directly. I am not sure what the
history is or if there is a use-case that really requires this. So in
the future may be I should make them static so they cannot be used
directly :-)

Cheers
Jon
