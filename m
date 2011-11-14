Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1KNMDx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 07:03:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43239 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413Ab1KNMDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 07:03:52 -0500
Message-ID: <4EC103A2.7080704@gmail.com>
Date: Mon, 14 Nov 2011 13:03:46 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        jbarnes@virtuousgeek.org, harald@redhat.com,
        Keith Packard <keithp@keithp.com>, linux-kernel@vger.kernel.org
Subject: Re: Strange effect with i915 backlight controller
References: <4EB3F860.6010408@gmail.com> <4EB87E6A.3060403@gmail.com> <4EBBE9A1.8020501@gmail.com> <s5hmxc49ec0.wl%tiwai@suse.de> <4EBFEF29.9050005@gmail.com> <s5h1utb6l9s.wl%tiwai@suse.de>
In-Reply-To: <s5h1utb6l9s.wl%tiwai@suse.de>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 11:39 AM, Takashi Iwai wrote:
> [Added Chris to Cc]
> 
> At Sun, 13 Nov 2011 17:24:09 +0100,
> Daniel Mack wrote:
>>
>> Hi Takashi,
>>
>> On 11/10/2011 04:39 PM, Takashi Iwai wrote:
>>> At Thu, 10 Nov 2011 16:11:29 +0100,
>>> Daniel Mack wrote:
>>>>
>>>> On 11/08/2011 01:57 AM, Daniel Mack wrote:
>>>>> Didn't get any response yet, hence copying LKML for a broader audience.
>>>>
>>>> Nobody, really?
>>>>
>>>> This is a rather annoying regression, as touching the brightness keys
>>>> appearantly switches off the whole machine. I'm sure this is trivial to
>>>> fix, I just don't have the insight of this driver and the chipset.
>>>
>>> I vaguely remember that the bit 0 is invalid on some old chips.
>>> Maybe 915GM is one of them, as it's gen3?  If so, the patch like below
>>> may work.
>>
>> Thank you for looking into this.
>>
>>> ---
>>> diff --git a/drivers/gpu/drm/i915/intel_panel.c b/drivers/gpu/drm/i915/intel_panel.c
>>> index 499d4c0..be952d1 100644
>>> --- a/drivers/gpu/drm/i915/intel_panel.c
>>> +++ b/drivers/gpu/drm/i915/intel_panel.c
>>> @@ -249,8 +249,11 @@ static void intel_panel_actually_set_backlight(struct drm_device *dev, u32 level
>>>  	if (IS_PINEVIEW(dev)) {
>>>  		tmp &= ~(BACKLIGHT_DUTY_CYCLE_MASK - 1);
>>>  		level <<= 1;
>>> -	} else
>>> +	} else {
>>>  		tmp &= ~BACKLIGHT_DUTY_CYCLE_MASK;
>>> +		if (INTEL_INFO(dev)->gen < 4)
>>> +			tmp &= ~1;
>>> +	}
>>>  	I915_WRITE(BLC_PWM_CTL, tmp | level);
>>>  }
>>>  
>>
>> This seems to be the right intention, but the value you want to modify
>> under this condition is 'level', not 'tmp'.
> 
> Ah, of course.  Sorry for that.
> 
>> With this amendment of your
>> patch, things work perfectly fine here.
> 
> OK, then perhaps a better fix is to change the check to be equivalent
> with pineview, as you mentioned in the original post.  The handling of
> bit 0 for old chips was lost during the refactoring of backlight code
> since 2.6.37.
> 
> Does the patch below work for you?

Will test, but I only have occasional access to the machine, so this
will have to wait for some days.

> The only concern by this fix is that it changes the max value.  If
> apps expect some certain (e.g. recorded) value, it may screw up.  But
> I don't expect this would happen with sane apps.

I don't think so either.


Thanks,
Daniel
