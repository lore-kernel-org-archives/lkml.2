Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab2ENVph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 17:45:37 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:63679 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab2ENVpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 17:45:34 -0400
MIME-Version: 1.0
In-Reply-To: <201205142107.51335.arnd@arndb.de>
References: <20120514105424.8596.38355.sendpatchset@w520>
	<20120514123034.GD10453@n2100.arm.linux.org.uk>
	<CANqRtoTYWGhto7Zf=C=WHrT5fjc1p=6GE0cnozYLUuqbz=+LhA@mail.gmail.com>
	<201205142107.51335.arnd@arndb.de>
Date: Tue, 15 May 2012 06:45:33 +0900
Message-ID: <CANqRtoSts80a-Pgas23Um8FFtnSeeu2oZKNehdfymLWoTOSspA@mail.gmail.com>
Subject: Re: [PATCH 03/03] ARM: Undelete KZM9D mach-type
From: Magnus Damm <magnus.damm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        lethal@linux-sh.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        horms@verge.net.au, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 6:07 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 14 May 2012, Magnus Damm wrote:
>> On Mon, May 14, 2012 at 9:30 PM, Russell King - ARM Linux
>> <linux@arm.linux.org.uk> wrote:
>> > On Mon, May 14, 2012 at 07:54:51PM +0900, Magnus Damm wrote:
>> >> From: Magnus Damm <damm@opensource.se>
>> >>
>> >> Undelete the KZM9D mach-type to allow build of board
>> >> for EMEV2 SoC support.
>> >
>> > If you've converted to use DT for KZM9D, do you still need this?
>>
>> Good question. I guess it depends on how we want to make use of DT on
>> that piece of hardware. I do intend to convert the KZM9D board (not to
>> be mistaken for KZM9G!) to DT (and drop the generic EMEV2 SoC DT
>> unless someone really wants it at this timing), but I'm still not sure
>> if the SMP code in V2 is the way we want to do it. I suspect that
>> there is no way to support SMP without static entity mappings, so
>> perhaps I should rework that part and redo a V3? Or perhaps I should
>> interpret the EMEV2 silence as a good thing. =)
>
> I don't understand why you want to have a KZM9D board file at all,
> since it from looking at it, I can find nothing that is truely
> board specific and doesn't already have bindings. This is different
> from the other boards that you just converted to DT_MACHINE_START
> but still left using individual board files because some bindings
> are missing.
>
> The only board specific device you add for KZM9D is smsc911x, and
> that has bindings, all the other devices can just be hardcoded
> for the soc because they are always the same, until we have bindings
> for all of them. Am I missing something?

Right, I understand your observation. Let me try to explain the reason
behind the board code - please excuse me not doing that in the first
place already.

So yes, in the EMEV2 case the serial port and timers have DT bindings.
Same for the already existing bindings for the SMSC chip. And I'm
working on a EMEV2 GPIO V2 and DT for that GPIO driver. So those are
moving along nicely.

Hardware that doesn't have any DT bindings at this point are: pinmux,
clocks and SMP.

Perhaps my view of DT support is somewhat odd, but I'm rather hesitant
to commit to DT for a SoC when I don't use DT for _all_ the hardware
blocks. As you can see in the EMEV2 SoC DT V2 patch I have
intentionally left out the clock setup dependency and there board code
is in the sad state that it assumes that the boot loader has done all
the work already. There is no SMP bindings in place either. So with
the clock portion missing the kernel is not really that useful as-is,
but I prefer that over locking ourselves into something we don't know
fully yet. On a SoC level that is.

The reason why I don't want to tie in the clock and the pinmux in a
static fashion on a SoC and release DT support is that I don't know to
migrate from that state to all-DT and still remain backwards
compatible. I'd be very happy to hear suggestions how to do that. If
this is possible without causing too much pain for the user then I
will of course go that way.

I am very comfortable doing things on a board level, like in the KZM9G
/ Armadillo EVA 800 cases. Perhaps I can adjust the EMEV2 KZM9D board
to follow that style? As for EMEV2 SoC DT, I prefer either keeping the
EMEV2 SoC DT V2 as-is with no clock, pinmux and SMP, or ditching the
EMEV2 SoC DT portion all together and go KZM9D DT board only.

What is your preference?

>> Unfortunately the KZM9D board only takes uImages, but good news is
>> that it actually feeds us the correct mach-type. This seems to be a
>> pretty common thing around here these days. I'm trying to get people
>> to actually store the DTB in the boot loader and pass it along, but
>> that seems rather far away at this point.
>
> The preferred way would be to store the dtb on the same medium that
> contains the kernel, so you can update them together if necessary,
> even though we try to keep dtb files compatible across kernel versions.
> I would not want to rely on a hardcoded dtb file in the boot loader.

Right, I agree. Relying on a fixed DTB in an unreliable boot loader is
the last thing I want to do.

So if your boot loader can't pass DTB to the kernel, and you want to
have a single kernel supporting multiple boards, then do you see
anything wrong with based on mach-type do a run time decision (in
arch/arm/boot/compressed/) to override the ATAG from the boot loader
with a compiled-in per-board DTB?

The alternative is to have a raw zImage and a set of DTB files and
force the user to manually append the DTB to the zImage depending on
board type. Seems a bit too manual process for my liking, so as you
probably are tired of hearing now - I prefer extending the boot code
to switch on something we already have - the mach-type - and then
based on that feed one of the compiled-in DTBs to the kernel.

I'll try to cook something up unless there are any objections.

Thanks for your help!

Cheers,

/ magnus
