Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab0FHEWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 00:22:34 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56058 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab0FHEWc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 00:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NznHHYB3LUU+MbEQY9tZUiAbEFIg3xTenVB/qc0yudBWY1P4Ud7ABxkPeWjyx6FSRw
         dUeS51Ue1KI/ZepR6FVmmkvWb2rI9BvgqfLk58YngPjhmw2KNNMBp9rcSc7ld/AANeA7
         a1KqKgk/RgYsJHrKjo5O7kEAh5Tf7AevcIPac=
MIME-Version: 1.0
In-Reply-To: <AANLkTinvrzcSrjoGCZHUGLq0-qt-1mDM0494j5mES5tX@mail.gmail.com>
References: <AANLkTikEGSZUBy8VZOIUhA8iAPa5p7r9vmN47hiEwSB8@mail.gmail.com>
	<AANLkTinUe_IF7riVYpCFpciM6-ngudDR8UZ6FiaJBkk3@mail.gmail.com>
	<AANLkTinvrzcSrjoGCZHUGLq0-qt-1mDM0494j5mES5tX@mail.gmail.com>
Date: Tue, 8 Jun 2010 06:22:30 +0200
Message-ID: <AANLkTin0xcY9qZ4OdINKdUzo3zPfG9tNxQ3UZtLSDpzi@mail.gmail.com>
Subject: Re: radeon blink during probe regression (was Re: Linux 2.6.35-rc2)
From: Torsten Kaiser <just.for.lkml@googlemail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 8, 2010 at 5:09 AM, Dave Airlie <airlied@gmail.com> wrote:
> On Tue, Jun 8, 2010 at 11:50 AM, Alex Deucher <alexdeucher@gmail.com> wrote:
>> On Mon, Jun 7, 2010 at 8:49 PM, Dave Airlie <airlied@gmail.com> wrote:
>>> (changing subject
>>>
>>> On Tue, Jun 8, 2010 at 3:28 AM, Torsten Kaiser
>>> <just.for.lkml@googlemail.com> wrote:
>>>> On Mon, Jun 7, 2010 at 8:52 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>>> On Mon, Jun 7, 2010 at 4:32 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
>>>>>> On Mon, Jun 7, 2010 at 2:22 AM, Dave Airlie <airlied@gmail.com> wrote:
>>>>>>> On Mon, Jun 7, 2010 at 4:09 PM, Torsten Kaiser
>>>>>>> <just.for.lkml@googlemail.com> wrote:
>>>>>>>> The switchoff intervall is ~10 seconds, not 1..2 as I guessed in the first mail.
>>>>>>>> Any idea if there is something in the KMS code that triggers at this intervall?
>>>>>>>
>>>>>>> The new mode probing code happens every 10 seconds, though we
>>>>>>> shouldn't be turning anything on or off with it.
>>>>>>>
>>>>>>> So I suspect the DAC detection table might be doing bad things on your
>>>>>>> hardware, we have had a problem where the dac detect table on one DAC
>>>>>>> would turn the other one off which clearly wasn't what we wanted to
>>>>>>> see.
>>>>>>> ,
>>>>>>
>>>>>> The x300 is a non-atom card, so it uses the legacy load detection
>>>>>> routines which do mess with some of the crtc regs.
>>>>>>
>>>>>
>>>>> Okay I see it now, I'm amazed that I was seeing this issue last week
>>>>> and blaming it on something complete different and only seeing it on
>>>>> one card.
>>>>>
>>>>> I expect its the same problem I'll try and track down a proper fix for
>>>>> it tomorrow.
>>>>
>>>> It really seems to be this polling code.
>>>> After the fix to drivers/char/vt.c the 2.6.35-rc2 kernel now works for
>>>> me without crashing.
>>>>
>>>> I also changed #define DRM_OUTPUT_POLL_PERIOD (10*HZ) to
>>>> #define DRM_OUTPUT_POLL_PERIOD (3*HZ) and now the flickering before X
>>>> starts is at a three second interval. That should prove, that the
>>>> polling from drm_crtc_helper.c is the cause.
>>>>
>>>> After X starts the LCD is stable, but the secondary CRT still flickers
>>>> every 3 seconds.
>>>>
>>>> My hardware is an X300-PCIe card with a VGA-, a DVI-I- and a video output.
>>>> I have a 1280x1024 LCD attached to the DVI-I and an old CRT to the
>>>> VGA. The video output is unused.
>>>> The CRT is normally switched off, but its still detected correctly.
>>>>
>>>> The kernel output from 2.6.34 and 2.6.35-rc2 is here:
>>>> http://lkml.org/lkml/2010/6/6/126
>>>>
>>>> xrandr says:
>>>> Screen 0: minimum 320 x 200, current 2080 x 1024, maximum 4096 x 4096
>>>> DVI-0 connected 1280x1024+0+0 (normal left inverted right x axis y
>>>> axis) 338mm x 270mm
>>>>   1280x1024      60.0*+   75.0
>>>>   1280x960       60.0
>>>>   1152x864       75.0
>>>>   1024x768       75.1     70.1     60.0
>>>>   832x624        74.6
>>>>   800x600        72.2     75.0     60.3     56.2
>>>>   640x480        72.8     75.0     66.7     60.0
>>>>   720x400        70.1
>>>>   640x400        70.0
>>>> VGA-0 connected 800x600+1280+150 (normal left inverted right x axis y
>>>> axis) 280mm x 210mm
>>>>   800x600        72.2*+   75.0     60.3     56.2
>>>>   1280x1024      60.0
>>>>   1024x768       75.1     70.1     60.0
>>>>   640x480        72.8     75.0     60.0
>>>>   720x400        87.8     70.1
>>>> S-video disconnected (normal left inverted right x axis y axis)
>>>>
>>>> If you have something for me to try, just send it. :-)
>>>>
>>>> Torsten
>>>>
>>>
>>> Okay here is a patch that seems to work on my test system, but I want
>>> to give it a bit more playing around with before I sent it onwards.
>>>
>>> Alex, seem sane to you?
>>
>> Seems sane.
>>
>
> While discussing this with Alex we realised this code should never
> have been reached so it showed a bug higher up.
>
> Looks like we were defining i2c lines for tv-out which doesn't have
> any, the attached patch makes sure the tv-out on legacy radeon hw
> doesn't get an i2c line attach so doesn't trigger the polling on it.
>
> Torsten can you test this patch instead of the previous one, though I
> think I'll send both to Linus for safety sakes.

I just applied it and the card now works fine. No more flickering.

Thanks!

Do you want me to test the other patch
(0001-drm-radeon-don-t-poll-tv-dac-if-crtc2-is-in-use.patch) too?

Torsten
