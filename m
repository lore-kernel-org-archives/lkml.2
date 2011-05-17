Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab1EQKMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 06:12:25 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47463 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1EQKMY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 06:12:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m2jIJDBIGqZsx8vVcQd8OHaL//nFMnQJpjnKFozFD0zlQJHzIzib+5COjwUidrr874
         lPfTSvphleCMtsR4x35uMQwQXTBZoCXQjpn5OzNt63e+jlspPQFJHFnog5HOdGyhR5Bn
         iK/qu42bXjsYOEpEJwDBXyQz0RJ4wKjkL3/GE=
MIME-Version: 1.0
In-Reply-To: <201105171058.21652@rk-nord.at>
References: <BANLkTimXkXCAKQGK2ysTRNN-xa4ZChxcHA@mail.gmail.com>
	<201105161421.52451@rk-nord.at>
	<BANLkTikuBj0uCuyPRiDLD_iWypFN2MoTHQ@mail.gmail.com>
	<201105171058.21652@rk-nord.at>
Date: Tue, 17 May 2011 18:12:23 +0800
X-Google-Sender-Auth: d9rPqCW-NdpbEV_DXfGdKHWRQgw
Message-ID: <BANLkTi=60vWASESnJ-_wdc-XEpzb-k9F1Q@mail.gmail.com>
Subject: Re: i915/kms/backlight-combo mode problem
From: Michael Chang <mchang@novell.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        Joey Lee <jlee@novell.com>, chris@chris-wilson.co.uk,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Melchior,

I want to double check with you. If you change brightness from lowest
to highest, the LPBC value changes this way

Highest                  Lowest
0x10 ,   0x19 ......   0xe5

And vice versa, from Lowest to Highest

Lowest                          Highest
0xe5 ,   ......         0x19  0x10

If above is true, then you have a very particular notebook that
reverse the sense of the LPBC values ....  I don't know who ever came
across such device. wow.

Regarding that your brightness control key,  due to that it is
controlled by acer_wmi and likely that BIOS aware this, it would do
brightness in a reversed way. I think Joey would check DSDT and see
any clue or evidence for this. OTOH the i915 driver didn't aware of
this and operates as usual sense that means falling into the trap.

PS. I see your log always reverse the sense of this LPBC value, now I
know why. :)

Regards,
Michael Chang

2011/5/17 Melchior FRANZ <melchior.franz@gmail.com>:
> * Michael Chang -- Tuesday 17 May 2011:
> [LBPC]
>> You can know your LPBC value by:
>>   $ lspci -xxx -s 00:02.0 | awk '/^f0:/ {print $6}'
>>
>> And alter it's value via setpci (assuming set it to max)
>>   $ setpci -s 00:02.0 F4.B=ff
>>
>> I assume you've tried this .. as you report setpci works for you. :)
>
> Ahh, yes, indeed. This lspci line (almost) always shows a value that
> corresponds with the actual backlight brightness, and both lines work
> with and without acpi_osi=Linux. (Whereas adjustment via keys only works
> *with* acpi_osi=Linux.)  (Tested with 2.6.39-rc7/bd1a643e10)
>
>
>
>> Could you help to get the LPBC value in the initial dark condition? If
>> it's not corresponds to 255, maybe something sneaks and changes it but
>> not logged.
>
> Initially (with acpi_osi=Linux) LPBC=0xff. After "brightness down"
> it's 0x19, and after then pressing "brightness up" it's 0x01. The lowest
> value I can achieve after pressing "brightness down" a few times is 0xe5,
> the highest is 0x01. Neither 0xff nor 0x00 can be reached via keys, but
> can (most of the time -- see below!) be set with the setpci line and give
> the expected results, backlight off and fully on. ("display toggle" has
> no effect on LBPC, btw.)
>
> Setting 0xFF doesn't always turn the backlight off, though! If LBPC is
> at the (key) maximum 0x01, then setting 0xFF via setpci changes only the
> LBPC value as shown by lspci, but the backlight isn't actually turned off!
> If I then press "backlight darker" once (LBPC=0x19), then setting 0xFF
> via setpci works again.
>
>
>
>>  1. $ dmesg -c
>>  2. Close the lid
>>  3. Open the lid
>>  4. $ dmesg > dmesg.lid
>
> The results are:
>
> [  188.571040] [drm:intel_panel_set_backlight], set backlight PWM = 736950
> [  188.571048] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
> [  188.571054] [drm:is_backlight_combination_mode], BLM_COMBINATION_MODE = 1073741824
> [  188.571059] [drm:intel_panel_get_max_backlight], max backlight PWM = 736950
> [  188.571064] [drm:intel_panel_set_backlight], set backlight max = 736950
> [  188.571069] [drm:intel_panel_set_backlight], set backlight lbpc = 255
> [  188.571075] [drm:intel_panel_set_backlight], set backlight tmp(1) = 189399040
> [  188.571080] [drm:intel_panel_set_backlight], set backlight tmp(2) = 189399040
> [  188.571084] [drm:intel_panel_set_backlight],
> [  188.571088] [drm:intel_opregion_asle_intr], non asle set request??
> [  188.571093] set backlight level = 2890
>
> The backlight is off now, as always after closing/reopening the lid,
> and LPBC=0xff.
>
> m.
>
>
>
> PS: I'd be willing to join an irc.freenode.net channel in case you or
>    anyone else wants quicker ("live") responses to such queries.
>
