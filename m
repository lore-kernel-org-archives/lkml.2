Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab0CVDSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:18:09 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60890 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714Ab0CVDSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:18:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wporFiai2L28PFqXf8bFp8s02cnuEWWTmEwcK5T//Khyl5vIwChre8UHsmJIud5cR9
         3pHr6B4TLO1y+B6oLfXrnlIpk77/Kj3MnI5yur34Q+PoWCQ6u5UWP8uXUegSxnYehDUW
         OTAssKwRbQE1zThFzkwYDHF61p4e1GDPUJJTs=
MIME-Version: 1.0
In-Reply-To: <1269004294.4292.18.camel@rex>
References: <90b950fc1003182136n73d54c2di4be84f16e4c3534f@mail.gmail.com>
	 <1269004294.4292.18.camel@rex>
Date: Mon, 22 Mar 2010 12:18:05 +0900
Message-ID: <90b950fc1003212018h69bb0fa0t9dd62815b08eb7b3@mail.gmail.com>
Subject: Re: [PATCH] fixed sparkling issue on lcd panel when fb_blank mode is 
	changed.
From: InKi Dae <daeinki@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       Kyungmin Park <kmpark@infradead.org>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

yes, you are right.

when fb_blank mode is changed to FB_BLANK_NORMAL or
FB_BLANK_UNBLANK(power down -> power up)
it has a possibility that we would encounter same issue.

I'd try to modify my patch to be considered with your opinion and will
send it again.
Thank you for your answer.

Best Regards,
InKi Dae.

2010/3/19 Richard Purdie <rpurdie@rpsys.net>:
> Hi,
>
> On Fri, 2010-03-19 at 13:36 +0900, InKi Dae wrote:
>> This issue is a problem that lcd panel is spakled when fb_blank mode is changed
>> From FB_BLANK_UNBLANK to FB_BLANK_POWER or FB_BLANK_POWER to FB_BLANK_UNBLANK.
>>
>> In case of FB_BLANK_UNBLANK, screen = on, vsync = on, hsync = on and
>> For FB_BLANK_POWERDOWN screen = blanked, vsync = off, hsync = off
>> So like this when fb_blank mode becomes FB_BLANK_POWERDOWN,
>> Display controller and lcd panel should become off to reduce power consumption.
>>
>> Let's see fb_blank function of fbmem.c file.
>>
>> fb_blank()
>> {
>>     if (info->fbops->fb_blank)
>>             ret = info->fbops->fb_blank(blank, info(
>>     if (!ret)
>>             fb_notifier_call_chain(FB_EVENT_BLANK, &event);
>> }
>>
>> This problem is because this code calls fb_blank (fb_blank of device
>> specific framebuffer driver)
>> Earlier then fb_notifier_call_chain.
>>
>> For example,
>> Device specific fb_blank function is registered to generic framebuffer
>> driver through register_framebuffer function
>> And fb_notifier_call_chain calls any callback function registered to
>> lcd class(lcd.c) through fb_notifier_callback function.
>> So if fb_blank mode is changed to FB_BLANK_POWERDOWN then display
>> controller would become off(clock disable)
>> On the other hand, lcd panel would still be on. at this time, some
>> situation on lcd panel occers like sparkling
>> Because video clock to be delivered to ldi module of lcd panel is disabled also.
>>
>> This patch get fb_notifier_call_chain to be called earlier then fb_blank.
>> Please, review this patch.
>
> So to summarise the problem more succinctly the LCD and the display
> controllers power off in the wrong order causing visual defects
> (sparkling) on the display.
>
> I was a bit worried about event order and loops with this change so I
> checked and there are three consumers of these events in the kernel:
> consoles, LCD and backlight. None of them have a problem with this
> change of order for power down so from that point of view I'm ok with
> the change.
>
> However this function also covers powerup from a screen blank to an
> active screen. When powering up it makes sense to power up the video
> device first, then the LCD, backlight and console as per the current
> code, otherwise I can imagine "sparkling" upon powerup.
>
> So it looks like we need to change order only on powerdown, not upon
> resume, otherwise we'll get further regression reports on poweron?
>
> Cheers,
>
> Richard
>
>
>
>
>
