Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908Ab1EIVUt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 17:20:49 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58647 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab1EIVUr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 17:20:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=l5KrNkcC3TLPAJX96GLwSQ8gmhL07kFGe12QeAQqXf3ASD4Dpc62AH9F8+ef5LiqmX
         fOs4k1SdrZLMASYJePuB1ryah552m0hDvOqtS8ClAxmKNifNOjFDt1vBGRDogWTQJL47
         7J3m4MsZ0bZFhK2ybEbcUmn3j4Iafr3GfEDak=
MIME-Version: 1.0
In-Reply-To: <201105091504.54868.thomas@fjellstrom.ca>
References: <201105071815.03318.thomas@fjellstrom.ca>
	<BANLkTik1NUc8Jaa4i_awNSbBHaMhW9FgqA@mail.gmail.com>
	<201105091446.22781.thomas@fjellstrom.ca>
	<201105091504.54868.thomas@fjellstrom.ca>
Date: Mon, 9 May 2011 17:20:47 -0400
Message-ID: <BANLkTi=iV7Mg_4Lx_+Z6c7C2qzMxsf0Aew@mail.gmail.com>
Subject: Re: long delay when using HMDI output on RS780
From: Alex Deucher <alexdeucher@gmail.com>
To: thomas@fjellstrom.ca
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 5:04 PM, Thomas Fjellstrom <thomas@fjellstrom.ca> wrote:
> On May 9, 2011, Thomas Fjellstrom wrote:
>> On May 9, 2011, Jerome Glisse wrote:
>> > On Mon, May 9, 2011 at 3:50 PM, Thomas Fjellstrom <thomas@fjellstrom.ca>
>>
>> wrote:
>> > > On May 7, 2011, Thomas Fjellstrom wrote:
>> > >> I just switched to using HDMI with my media center, and its causing a
>> > >> 30+ second delay in the screen turning on, as well as a 7 second delay
>> > >> in the X startup when it tries to fetch the EDID information.
>> > >> Basically I don't get any picture at all once KMS initializes until
>> > >> after X has been up a few seconds.
>> > >>
>> > >> The odd thing is the monitor seems to think something is going on,
>> > >> since it doesn't go to sleep or display its "No Signal" OSD, but just
>> > >> after X starts up, it pops up the "Input detected/switched" OSD, and
>> > >> the picture appears.
>> > >>
>> > >> The bios, grub2 (in both text mode and graphics mode), and the initial
>> > >> linux kernel messages all display fine and immediately. Its only once
>> > >> KMS and radeondrmfb initializes that there's a problem (at least till
>> > >> X starts up).
>> > >>
>> > >> I've just built with a vanila 2.6.38.4 kernel from the stable git
>> > >> repo, and have played with some EDID settings, trying to disable edid
>> > >> where I could thinking thats what caused the problem. That doesn't
>> > >> seem to be the case though. I also tried playing with the video=
>> > >> kernel option, trying to force disable VGA-1, and set a static mode
>> > >> for HDMI-A-1, but if I try, it seems to force disable HDMI-A-1
>> > >> instead of force the mode.
>> > >>
>> > >> With a DVI-D cable instead, the problem goes away.
>> > >>
>> > >> Attached are the dmesg and xorg.log files for the latest boot with
>> > >> HDMI (no video= parameter, and EDID enabled, most settings at
>> > >> defaults).
>> > >>
>> > >> What exactly would cause this, and is there a way I can fix it?
>> > >
>> > > I've been playing around with it more, and got it to not blank the
>> > > screen after KMS init, /once/. So far no luck repeating that success.
>> > >
>> > > I've tried late, and early kms init, and currently have the radeon
>> > > module and firmware compiled into the kernel. Boot times at least are
>> > > fairly decent, about 8-10s till X starts, but about 25-35s till
>> > > anything shows up.
>> > >
>> > > Some strangeness, I have the kernel set to force the hdmi output to on,
>> > > with a very specific mode, that X tends to like, the vga port is forced
>> > > disabled. X is set to ignore EDID, and also set to that specific mode
>> > > that it tends to auto set itself. Regardless X still wants to pause for
>> > > 7s 2-3 times while processing EDID info.
>> > >
>> > > I've attached the new dmesg and xorg logs from the latest attempts.
>> > >
>> > > Note, this only happens with KMS, with HDMI. disabling KMS, or using
>> > > DVI makes the problem go away. Even grub's own graphical mode works
>> > > fine, its only once KMS inits that things go bad, and its not till
>> > > after X is up for a few seconds that something displays on my screen.
>> > >
>> > > --
>> > > Thomas Fjellstrom
>> > > thomas@fjellstrom.ca
>> >
>> > Please boot with drm.debug=4 and attach dmesg it should be more
>> > verbose. You might also want to try booting with radeon.audio=0
>>
>> Hi, attached both one with just drm.debug=4, and one with that and
>> radeon.audio=0.
>>
>> Now, I'm guessing its a bug in my monitor claiming it can do HDMI audio? As
>> setting radeon.audio=0 seems to have fixed the blanking problem. And the
>> dmesg logs seem to claim that radeon thinks it can do HDMI audio.

Most likely the driver is sending the wrong packets for hdmi audio.
Until that gets fixed up, it's probably best to disable hdmi audio if
it's not working for you.

Alex


>>
>> It also seems to be ignoring the mode I've requested via the video= param.
>> It at least sees that I want it forced enabled, but claims its 0x0? Or at
>> least it seems its picking the preferred mode.
>>
>> Still have X blocking for up to 14s though.
>>
>> Theres also a bunch of repeated log messages from drm now, every second
>> about it seems to spam the following lines: (the last one is repeated a
>> bunch of times, with FB:44 or FB:42)
>>
>> [   31.330033] [drm:output_poll_execute], [CONNECTOR:13:VGA-1] status
>> updated from 2 to 2
>> [   31.435455] [drm:radeon_atombios_connected_scratch_regs], DFP1 connected
>> [   31.435463] [drm:output_poll_execute], [CONNECTOR:15:HDMI-A-1] status
>> updated from 1 to 1
>> [   31.437391] [drm:drm_mode_addfb], [FB:42]
>>
>> > Cheers,
>> > Jerome
>
> Ok, a bit more news. My monitor does indeed support audio, at least it has
> volume buttons, so I assume it has speakers, and should support HDMI audio (I
> have never used it though).
>
> --
> Thomas Fjellstrom
> thomas@fjellstrom.ca
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
