Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340Ab0FGR2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 13:28:50 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54617 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab0FGR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 13:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=jhj8YzaDbkQSo24wRCaAb+d4me456BxBM4WmNfr9VW9DxA1KiQ7l2U7N2mKIqTvl8i
         /aIErCxjuzxQrElWG4v14jFRC+zcrDh2R2WQDlR2ontG4cMsmFbWqNtwTQwxERPHLMo/
         z+8hgEsOf5uUFNW6yjXC9pjy61S8U4uuj6b38=
MIME-Version: 1.0
In-Reply-To: <AANLkTimbsgJ4BKIiwE-D1McBOIuxyQ14Qq-IUZR6aTmv@mail.gmail.com>
References: <alpine.LFD.2.00.1006052050100.3515@i5.linux-foundation.org>
	<AANLkTinpHAK3-qj26KSLLhMB5UUDT5I9aSkrxJeRRsSl@mail.gmail.com>
	<alpine.LFD.2.00.1006060710570.3515@i5.linux-foundation.org>
	<AANLkTilD2n0QQrdN814XKAjDl5a_AbaRIZ0LUAOhKksL@mail.gmail.com>
	<AANLkTimdQJGXt3_7B47FNB3_1cTq9NazWZxR4HdShogj@mail.gmail.com>
	<AANLkTil-1OgnnzgL7U0PNQi4G8B2QFDa6BEH4mWqdkhL@mail.gmail.com>
	<AANLkTimjxjINEtM3rIHVk_prI-_UTgkpIVhgbQ0V6rG4@mail.gmail.com>
	<AANLkTilJYxYHc7yBsCATQviYmfeAkmEk4LK-ZGJHpMsx@mail.gmail.com>
	<AANLkTimbsgJ4BKIiwE-D1McBOIuxyQ14Qq-IUZR6aTmv@mail.gmail.com>
Date: Mon, 7 Jun 2010 19:28:44 +0200
Message-ID: <AANLkTinpbb88EewGbQ9X5vX54ie04i6-G69cBnlBIiiN@mail.gmail.com>
Subject: Re: Linux 2.6.35-rc2
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 7, 2010 at 8:52 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Mon, Jun 7, 2010 at 4:32 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Mon, Jun 7, 2010 at 2:22 AM, Dave Airlie <airlied@gmail.com> wrote:
>>> On Mon, Jun 7, 2010 at 4:09 PM, Torsten Kaiser
>>> <just.for.lkml@googlemail.com> wrote:
>>>> The switchoff intervall is ~10 seconds, not 1..2 as I guessed in the first mail.
>>>> Any idea if there is something in the KMS code that triggers at this intervall?
>>>
>>> The new mode probing code happens every 10 seconds, though we
>>> shouldn't be turning anything on or off with it.
>>>
>>> So I suspect the DAC detection table might be doing bad things on your
>>> hardware, we have had a problem where the dac detect table on one DAC
>>> would turn the other one off which clearly wasn't what we wanted to
>>> see.
>>> ,
>>
>> The x300 is a non-atom card, so it uses the legacy load detection
>> routines which do mess with some of the crtc regs.
>>
>
> Okay I see it now, I'm amazed that I was seeing this issue last week
> and blaming it on something complete different and only seeing it on
> one card.
>
> I expect its the same problem I'll try and track down a proper fix for
> it tomorrow.

It really seems to be this polling code.
After the fix to drivers/char/vt.c the 2.6.35-rc2 kernel now works for
me without crashing.

I also changed #define DRM_OUTPUT_POLL_PERIOD (10*HZ) to
#define DRM_OUTPUT_POLL_PERIOD (3*HZ) and now the flickering before X
starts is at a three second interval. That should prove, that the
polling from drm_crtc_helper.c is the cause.

After X starts the LCD is stable, but the secondary CRT still flickers
every 3 seconds.

My hardware is an X300-PCIe card with a VGA-, a DVI-I- and a video output.
I have a 1280x1024 LCD attached to the DVI-I and an old CRT to the
VGA. The video output is unused.
The CRT is normally switched off, but its still detected correctly.

The kernel output from 2.6.34 and 2.6.35-rc2 is here:
http://lkml.org/lkml/2010/6/6/126

xrandr says:
Screen 0: minimum 320 x 200, current 2080 x 1024, maximum 4096 x 4096
DVI-0 connected 1280x1024+0+0 (normal left inverted right x axis y
axis) 338mm x 270mm
   1280x1024      60.0*+   75.0
   1280x960       60.0
   1152x864       75.0
   1024x768       75.1     70.1     60.0
   832x624        74.6
   800x600        72.2     75.0     60.3     56.2
   640x480        72.8     75.0     66.7     60.0
   720x400        70.1
   640x400        70.0
VGA-0 connected 800x600+1280+150 (normal left inverted right x axis y
axis) 280mm x 210mm
   800x600        72.2*+   75.0     60.3     56.2
   1280x1024      60.0
   1024x768       75.1     70.1     60.0
   640x480        72.8     75.0     60.0
   720x400        87.8     70.1
S-video disconnected (normal left inverted right x axis y axis)

If you have something for me to try, just send it. :-)

Torsten
