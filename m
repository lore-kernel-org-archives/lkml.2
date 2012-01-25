Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756472Ab2AYRU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 12:20:27 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22048 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab2AYRU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 12:20:26 -0500
Date: Wed, 25 Jan 2012 18:20:24 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH/RFC] regulator: Reverse the disable sequence in
 regulator_bulk_disable()
In-reply-to: <20120125115705.GF3687@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, m.szyprowski@samsung.com,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Steve Glendinning <steve.glendinning@smsc.com>,
        Richard Purdie <rpurdie@rpsys.net>, Timur Tabi <timur@freescale.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <4F2039D8.2030706@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24)
 Gecko/20111108 Thunderbird/3.1.16
References: <1327491338-18817-1-git-send-email-s.nawrocki@samsung.com>
 <20120125115705.GF3687@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2012 12:57 PM, Mark Brown wrote:
> So, I've applied this since it shouldn't do any harm and probably is

Thank you!

> more what we meant to do but note that the bulk APIs don't make any
> guarantees about ordering - in particular when we do the enable we fire
> off a bunch of threads to bring the regulators up in parallel so the
> ordering really is going to be unreliable as it depends on the scheduler
> and the rates at which the various regulators ramp.  This is done so
> that we can enable faster as we don't have to wait for each regulator to
> ramp in series.

Yeah, I've noticed this API change recently.

> Whatever driver inspired you to submit this change is therefore probably
> buggy or fragile at the minute - is it something that's in mainline or
> next right now?

Yes, there are some drivers in mainline using the bulk API for which TRMs
recommend specific voltage supply enable/disable order, e.g.
drivers/media/video/s5k6aa.* or drivers/media/m5mols.

In fact I've had this patch for a quite long time hanging around in the
internal trees, long before the commit

 f21e0e81d81b649ad309cedc7226f1bed72982e0
 regulator: Do bulk enables of regulators in parallel

However it clearly indicates the order isn't guaranteed for the bulk APIs.

> At some point I'd like to enhance things further so we can coalesce
> register writes where multiple regulators have their enable bits in the
> same register but that's a relatively large amount of work for a small
> benefit unless we do something cute with regmap (and that is likely to
> be too cute).

Hmm, sounds like a good improvement which could also lead to lower power
consumption (since we reduce number of I2C/SPI transfers, etc.). But indeed
the benefits might hardly justify the amount of work needed :)

>> The alternatives to directly modifying regulator_bulk_disable() could be:
> 
>>  - re-implement it in modules that need the order reversed; it is not
>>    really helpful in practice since such code would have to be repeated
>>    in multiple modules;
> 
>>  - create new function, e.g. regulator_bulk_disable_reversed() with the
>>    order reversed - not sure if it is not an overkill though;
> 
> The third option is that where devices really care about the power
> sequencing they should explicitly write that in code and only use the
> bulk APIs where they don't care.  Typically this will mean either a few
> sets of bulk supplies or a single set of bulk supplies and then some
> number of individual supplies.  An awful lot of devices don't have any
> sequencing constraints at all, apparently including most of those using
> the API at present.

Yeah, I guess that's what I'm going to do - drop the bulk API usage to make
sure the order is right for drivers which really are sensitive.
Some of the devices I used to work with require explicit order of switching
all regulators, while some only care about timing relation of single supply
to a group of the remaining ones.

> BTW, your CC list here is *really* random - please think more about who
> you're CCing, it looks like you've done something with get_maintainer.

My apologies for that, especially to those not really involved..
Indeed, I've used get_maintainer on files which used the regulator API
calls in question. I'll try to do better job next time.


Regards,
--
Sylwester Nawrocki
Samsung Poland R&D Center
