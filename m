Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab1H2Q2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 12:28:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34684 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab1H2Q2w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 12:28:52 -0400
MIME-Version: 1.0
In-Reply-To: <CADnq5_Mppeym2spCqsRGYALQxWDjQ_yNuta4SYRH6Oocy=UjSg@mail.gmail.com>
References: <CAG1a4rs53RwkSxBvRQ5MrUbm7KEnpuEjw2fhSnT_1vqVPQrqgA@mail.gmail.com>
 <1314435638.2321.12.camel@thor.local> <CAG1a4rukteF+NmmTEhYT5yOmUYfDcbZ5qsghai1wm3ndpeiesg@mail.gmail.com>
 <20110828053624.GC12851@liondog.tnic> <1314624021.2816.30.camel@twins>
 <20110829133808.GA2025@gere.osrc.amd.com> <CADnq5_Mppeym2spCqsRGYALQxWDjQ_yNuta4SYRH6Oocy=UjSg@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Mon, 29 Aug 2011 12:28:31 -0400
Message-ID: <CAGZ=bqKHvauaW8jdPR98d-X5dry_pADYHWH-OsJE_CXT9hdwVw@mail.gmail.com>
Subject: Re: Kernel almost hangs when CONFIG_DRM_RADEON=y
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Pavel Ivanov <paivanof@gmail.com>,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 29, 2011 at 09:48, Alex Deucher <alexdeucher@gmail.com> wrote:
> 2011/8/29 Borislav Petkov <bp@alien8.de>:
>> On Mon, Aug 29, 2011 at 03:20:21PM +0200, Peter Zijlstra wrote:
>>> On Sun, 2011-08-28 at 07:36 +0200, Borislav Petkov wrote:
>>> > > > With CONFIG_DRM_RADEON=y, the microcode is needed before it can be
>>> > > > loaded from userspace, so it needs to be built into the kernel as well.
>>> > >
>>> > > How should I do that? I've tried to set all "m"s to "y" in .config and
>>> > > still saw this issue. Should I set some special parameter?
>>> >
>>> > You need to add "radeon/CEDAR_pfp.bin" to CONFIG_EXTRA_FIRMWARE when you
>>> > configure your kernel and enable CONFIG_FIRMWARE_IN_KERNEL.
>>> >
>>> > The radeon/CEDAR_pfp.bin file (+ leading directory, mind you) should
>>> > most probably be located in /lib/firmware or to whatever you have set
>>> > CONFIG_EXTRA_FIRMWARE_DIR so that Kbuild can find it (if not, you'll get
>>> > a warning at the end of the kernel build). This way, it works for both
>>> > radeon being =m and =y.
>>>
>>> Should we make Kconfig pop up a dialog and ask for the whereabouts of
>>> these firmware thingies when you mark the driver =y?
>>>
>>> This all sounds like magic to me, having to know you need to add to
>>> EXTRA_FIRMWARE, having to know what file it needs etc.. For all intents
>>> and purposes =y just doesn't work and that's broken.
>>
>> Yep, you make a lot of sense. I had to fumble the build/reboot cycle a
>> couple of times and do some code staring even to figure this out. In
>> the end, I copied the whole radeon/ folder from David's firmware git
>> repo into /lib/firmware and made radeon.ko =m again so that I don't have
>> to add *.bin entries to CONFIG_EXTRA_FIRMWARE each time I'm building a
>> kernel on a different machine.
>>
>> Besides, there was this other issue on lkml today where
>> CONFIG_EXTRA_FIRMWARE can cause nconf to segfault when you overflow
>> its length of 256 by trying to include a bunch of firmware *bin files:
>> http://lkml.org/lkml/2011/8/29/86
>
> If you are going to build the ucode into your kernel you'll need to
> pick the ones you want to include or increase the limit regardless of
> whether it's radeon ucode or ucode for some other chip.  For a
> particular card you only need the ones for that card (e.g.,
> CEDAR_*.bin or REDWOOD_*.bin, etc.)

No, Linus pushed back really hard last time this issue came up with
something; a network driver if I recall correctly.

The issue is that this happens *EVEN FOR MODULAR DRIVERS* during
suspend/resume.  The firmware simply may not be available yet.

If the driver fundamentally cannot work without the firmware then it should
bind to the device and wait until the first userspace action before requesting
firmware.

Furthermore, the trend is generally to push the firmware OUT of the kernel
binary to avoid any chance of license issues.  Even if the code is built-in
it should not need built-in firmware.

The quickest fix is probably something like this:

config DRM_RADEON_FIRMWARE
        tristate
        default m if STANDALONE
        default y

config DRM_RADEON
        depends DRM_RADEON_FIRMWARE

That should prevent somebody from building the radeon driver into the
kernel unless they manually indicate that they have the extra firmware.

Long-term, the driver should support modular firmware even when it's
built-in to the kernel.

Cheers,
Kyle Moffett
