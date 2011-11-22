Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab1KVBUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 20:20:32 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:39540 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752017Ab1KVBUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 20:20:31 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18xr9JCIGgxbzBwJb7UfQ/Z4C2Pm1O5uLXxBpGwLx
	RRgyaJcwSbCvqB
Message-ID: <4ECAF8DB.4020909@gmx.de>
Date: Tue, 22 Nov 2011 01:20:27 +0000
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: Joonyoung Shim <jy0922.shim@samsung.com>
CC: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] video: Fix return value of fb_notifier_call_chain
References: <1321858524-19368-1-git-send-email-jy0922.shim@samsung.com> <4ECAD9F0.9050508@gmx.de> <4ECAF3C6.4010507@samsung.com>
In-Reply-To: <4ECAF3C6.4010507@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 12:58 AM, Joonyoung Shim wrote:
> 11/22/2011 08:08 AM, Florian Tobias Schandinat 쓴 글:
>> On 11/21/2011 06:55 AM, Joonyoung Shim wrote:
>>> The return value of blocking_notifier_call_chain isn't errno value, it
>>> is just notify return value. The ret of fb_notifier_call_chain should is
>>> restored to error value from notify return value using
>>> notifier_to_errno().
>> If I'm not wrong this patch would rather break things than fix them. As I
>> understand the notifier_calls would be required to encode the return
>> value with
>> notifier_from_errno. This does not happen at the moment for fb
>> clients, for
>> example fbcon_event_notify in drivers/video/console/fbcon.c, so this
>> patch would
>> screw up the return values, I think.
> 
> OK, but it is wrong to return error value than notify value many
> callback of fb notify clients and some fb notify clients returns notify
> value, please see sh_mobile_lcdc_notify() and sh_hdmi_notify().
> 
> We should use only one, notify value or error value, i think it's right
> to use notify value.

I agree. But all fb clients need to be checked and fixed up if needed at the
same time you do the change you proposed, otherwise things are likely to break.

$ grep -r fb_register_client .
./include/linux/fb.h:extern int fb_register_client(struct notifier_block *nb);
./arch/arm/mach-pxa/am200epd.c: fb_register_client(&am200_fb_notif);
./drivers/leds/ledtrig-backlight.c:     ret = fb_register_client(&n->notifier);
./drivers/video/sh_mobile_hdmi.c:       fb_register_client(&hdmi->notifier);
./drivers/video/fb_notify.c: *  fb_register_client - register a client notifier
./drivers/video/fb_notify.c:int fb_register_client(struct notifier_block *nb)
./drivers/video/fb_notify.c:EXPORT_SYMBOL(fb_register_client);
./drivers/video/console/fbcon.c:        fb_register_client(&fbcon_event_notifier);
./drivers/video/sh_mobile_lcdcfb.c:     fb_register_client(&priv->notifier);
./drivers/video/omap/omapfb_main.c:int omapfb_register_client(struct
omapfb_notifier_block *omapfb_nb,
./drivers/video/omap/omapfb_main.c:EXPORT_SYMBOL(omapfb_register_client);
./drivers/video/omap/omapfb.h:extern int  omapfb_register_client(struct
omapfb_notifier_block *nb,
./drivers/video/backlight/backlight.c:  return fb_register_client(&bd->fb_notif);
./drivers/video/backlight/lcd.c:        return fb_register_client(&ld->fb_notif);
./drivers/staging/olpc_dcon/olpc_dcon.c:
fb_register_client(&dcon->fbevent_nb);


Best regards,

Florian Tobias Schandinat

> 
> Thanks.
> 
>>
>> Best regards,
>>
>> Florian Tobias Schandinat
>>
>>> Signed-off-by: Joonyoung Shim<jy0922.shim@samsung.com>
>>> ---
>>>   drivers/video/fb_notify.c |    4 +++-
>>>   1 files changed, 3 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/video/fb_notify.c b/drivers/video/fb_notify.c
>>> index 74c2da5..49a64a3 100644
>>> --- a/drivers/video/fb_notify.c
>>> +++ b/drivers/video/fb_notify.c
>>> @@ -42,6 +42,8 @@ EXPORT_SYMBOL(fb_unregister_client);
>>>    */
>>>   int fb_notifier_call_chain(unsigned long val, void *v)
>>>   {
>>> -    return blocking_notifier_call_chain(&fb_notifier_list, val, v);
>>> +    int ret = blocking_notifier_call_chain(&fb_notifier_list, val, v);
>>> +
>>> +    return notifier_to_errno(ret);
>>>   }
>>>   EXPORT_SYMBOL_GPL(fb_notifier_call_chain);
>>
> 
> 

