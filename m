Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab2IHHz2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 03:55:28 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:58782 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751917Ab2IHHz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 03:55:26 -0400
MIME-Version: 1.0
In-Reply-To: <87627pldkj.fsf@deeprootsystems.com>
References: <20120825214459.7333a376@notabene.brown> <CAMQu2gz0-U4GxEpZFfmJec+0FRs7ugy8EYS3HyYhb1jwbMBjug@mail.gmail.com>
 <20120827085312.75957354@notabene.brown> <CAMQu2gwH0O+NHV7H2aF375qmv0=TKb6RweOLohTHtB4UhQ-1gQ@mail.gmail.com>
 <CAMQu2gw2b8HHDPuSRuHXVYn3sJ5BYi_PuOT=snpa3zD5ert=QQ@mail.gmail.com>
 <20120906130510.32b0b877@notabene.brown> <CAMQu2gxGNJ+NW_rcRiXNE=OMTq8Hb81_1hDZnNen6mjc2cf6BQ@mail.gmail.com>
 <20120906170245.10e97bdd@notabene.brown> <87627pldkj.fsf@deeprootsystems.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Sat, 8 Sep 2012 13:25:03 +0530
Message-ID: <CAMQu2gwSCvw_4gVE-giD6MSzmRCNoNu4NoFBSao_dh9YnojfuA@mail.gmail.com>
Subject: Re: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tarun Kanti DebBarma <tarun.kanti@ti.com>,
        Tony Lindgren <tony@atomide.com>, Benoit <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>, Felipe Balbi <balbi@ti.com>,
        linux-omap@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Jon Hunter <jon-hunter@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 8, 2012 at 3:07 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Hi Neil,
>
> NeilBrown <neilb@suse.de> writes:
>
>> On Thu, 6 Sep 2012 11:18:09 +0530 "Shilimkar, Santosh"
>> <santosh.shilimkar@ti.com> wrote:
>>
>>> On Thu, Sep 6, 2012 at 8:35 AM, NeilBrown <neilb@suse.de> wrote:
>>> > On Mon, 3 Sep 2012 22:59:06 -0700 "Shilimkar, Santosh"
>>> > <santosh.shilimkar@ti.com> wrote:
>>
>>> >> After thinking bit more on this, the problem seems to be coming
>>> >> mainly because the gpio device is runtime suspended bit early than
>>> >> it should be. Similar issue seen with i2c driver as well. The i2c issue
>>> >> was discussed with Rafael at LPC last week. The idea is to move
>>> >> the pm_runtime_enable/disable() calls entirely up to the
>>> >> _late/_early stage of device suspend/resume.
>>> >> Will update this thread once I have further update.
>>> >
>>> > This won't be late enough.  IRQCHIP_MASK_ON_SUSPEND takes effect after all
>>> > the _late callbacks have been called.
>>> > I, too, spoke to Rafael about this in San Diego.  He seemed to agree with me
>>> > that the interrupt needs to be masked in the ->suspend callback.  any later
>>> > is too late.
>>> >
>>> Thanks for information about your discussion. Will wait for the patch then.
>>>
>>> Regards
>>> santosh
>>
>> I already sent a patch - that is what started this thread :-)
>>
>> I include it below.
>> You said "The patch doesn't seems to be correct" but didn't expand on why.
>> Do you still think it is not correct?  I wouldn't be surprised if there is
>> some case that it doesn't handle quite right, but it seems right to me.
>>
>> Thanks,
>> NeilBrown
>>
>>
>> From: NeilBrown <neilb@suse.de>
>> Subject: [PATCH] OMAP GPIO - don't wake from suspend unless requested.
>>
>> Current kernel will wake from suspend on an event on any active
>> GPIO even if enable_irq_wake() wasn't called.
>>
>> There are two reasons that the hardware wake-enable bit should be set:
>>
>> 1/ while non-suspended the CPU might go into a deep sleep (off_mode)
>>   in which the wake-enable bit is needed for an interrupt to be
>>   recognised.
>> 2/ while suspended the GPIO interrupt should wake from suspend if and
>>    only if irq_wake as been enabled.
>>
>> The code currently doesn't keep these two reasons separate so they get
>> confused and sometimes the wakeup flags is set incorrectly.
>>
>> This patch reverts:
>>  commit 9c4ed9e6c01e7a8bd9079da8267e1f03cb4761fc
>>     gpio/omap: remove suspend/resume callbacks
>> and
>>  commit 0aa2727399c0b78225021413022c164cb99fbc5e
>>     gpio/omap: remove suspend_wakeup field from struct gpio_bank
>>
>> and makes some minor changes so that we have separate flags for "GPIO
>> should wake from deep idle" and "GPIO should wake from suspend".
>>
>> With this patch, the GPIO from my touch screen doesn't wake my device
>> any more, which is what I want.
>
> I think the direction is right here.  We never should've separated the
> handling of idle vs suspend wakeups.  However, I have a few
> questions/doubts below...
>
I thought irq_set_wake() is suspend only wakeup functionality. In idle, the
driver IRQs are not disabled/masked so there no need of any special
wakeup calls for idle. More ever patch is adding the suspend hooks
for wakeups.

I have no objection on the subject patch, but the suspend wakeup
facility is easy enough to implement for IRQCHIPS and that is
what I was proposing it. Infact the mask on suspend patch almost
works and it fails only because the GPIO driver is suspended earlier
than the IRQ framework expect it to be.

Anyways I step back here since the proposed patch already fixes
the issue seen. Assuming the IRQCHIP mask on suspend doesn't
seems to work well with drivers as Neil mentioned, the $subject patch
seems to be the right option.

Regards,
Santosh
