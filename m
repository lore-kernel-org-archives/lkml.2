Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141Ab2LMRnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 12:43:08 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45166 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab2LMRnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 12:43:07 -0500
Message-ID: <50CA137A.5010304@ti.com>
Date: Thu, 13 Dec 2012 11:42:18 -0600
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        Grant Erickson <marathon96@gmail.com>, <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: add pwm driver using dmtimers.
References: <20121212192430.50cea126@notabene.brown> <50C8ABFC.3080309@ti.com> <20121213140635.4eda5858@notabene.brown> <20121213153302.05120a6d@notabene.brown>
In-Reply-To: <20121213153302.05120a6d@notabene.brown>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 12/12/2012 10:33 PM, NeilBrown wrote:
> On Thu, 13 Dec 2012 14:06:35 +1100 NeilBrown <neilb@suse.de> wrote:
> 
>>>> +	omap_dm_timer_enable(omap->dm_timer);
>>>
>>> Do you need to call omap_dm_timer_enable here? _set_load and _set_match
>>> will enable the timer. So this should not be necessary.
>>
>> True.  That is what you get for copying someone else's code and not
>> understanding it fully.
> 
> However .... omap_dm_timer_write_counter *doesn't* enable the timer, and
> explicitly checks that it is already runtime-enabled.
> 
> Does that mean I don't need to call omap_dm_timer_write_counter here?  Or
> does it mean that I do need the enable/disable pair?

Typically, omap_dm_timer_write_counter() is used to update the counter
value while the counter is running and hence is enabled.

Looking at the code, some more I now see what they are trying to do. It
seems that they are trying to force an overflow to occur as soon as they
enable the timer. This will cause the timer to load the count value from
the timer load register into the timer counter register. So that does
make sense to me. However, this should not be necessary as
omap_dm_timer_set_load should do this for you. Therefore, I think that
you could accomplish the same thing by doing ...

omap_pwm_config
	--> omap_dm_timer_set_load()
	--> omap_dm_timer_set_match()
	--> omap_dm_timer_set_pwm()

omap_pwm_enable
	--> omap_dm_timer_start()

If we call _set_load in config then we don't need to call _load_start in
the enable, we can just call _start.

Can you try this and see if this is working ok?

Cheers
Jon
