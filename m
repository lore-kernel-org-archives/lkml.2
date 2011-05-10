Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1EJDW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 23:22:59 -0400
Received: from mail.tomasu.net ([64.85.170.232]:51728 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1EJDW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 23:22:58 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: Alex Deucher <alexdeucher@gmail.com>
Subject: Re: long delay when using HMDI output on RS780
Date: Mon, 9 May 2011 21:22:32 -0600
User-Agent: KMail/1.13.7 (Linux/2.6.38-2-amd64; KDE/4.6.2; x86_64; ; )
Cc: Jerome Glisse <j.glisse@gmail.com>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
References: <201105071815.03318.thomas@fjellstrom.ca> <BANLkTi=iV7Mg_4Lx_+Z6c7C2qzMxsf0Aew@mail.gmail.com> <201105091532.48331.thomas@fjellstrom.ca>
In-Reply-To: <201105091532.48331.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105092122.32284.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 9, 2011, Thomas Fjellstrom wrote:
> On May 9, 2011, Alex Deucher wrote:
> > On Mon, May 9, 2011 at 5:04 PM, Thomas Fjellstrom <thomas@fjellstrom.ca>
> 
> wrote:
> > > On May 9, 2011, Thomas Fjellstrom wrote:
> > >> On May 9, 2011, Jerome Glisse wrote:
> > >> > On Mon, May 9, 2011 at 3:50 PM, Thomas Fjellstrom
> > >> > <thomas@fjellstrom.ca>
> > >> 
> > >> wrote:
> > >> > > On May 7, 2011, Thomas Fjellstrom wrote:
> > >> > >> I just switched to using HDMI with my media center, and its
> > >> > >> causing a 30+ second delay in the screen turning on, as well as
> > >> > >> a 7 second delay in the X startup when it tries to fetch the
> > >> > >> EDID
> > >> > >> information. Basically I don't get any picture at all once KMS
> > >> > >> initializes until after X has been up a few seconds.
> > >> > >> 
> > >> > >> The odd thing is the monitor seems to think something is going
> > >> > >> on, since it doesn't go to sleep or display its "No Signal" OSD,
> > >> > >> but just after X starts up, it pops up the "Input
> > >> > >> detected/switched" OSD, and the picture appears.
> > >> > >> 
> > >> > >> The bios, grub2 (in both text mode and graphics mode), and the
> > >> > >> initial linux kernel messages all display fine and immediately.
> > >> > >> Its only once KMS and radeondrmfb initializes that there's a
> > >> > >> problem (at least till X starts up).
> > >> > >> 
> > >> > >> I've just built with a vanila 2.6.38.4 kernel from the stable git
> > >> > >> repo, and have played with some EDID settings, trying to disable
> > >> > >> edid where I could thinking thats what caused the problem. That
> > >> > >> doesn't seem to be the case though. I also tried playing with the
> > >> > >> video= kernel option, trying to force disable VGA-1, and set a
> > >> > >> static mode for HDMI-A-1, but if I try, it seems to force disable
> > >> > >> HDMI-A-1 instead of force the mode.
> > >> > >> 
> > >> > >> With a DVI-D cable instead, the problem goes away.
> > >> > >> 
> > >> > >> Attached are the dmesg and xorg.log files for the latest boot
> > >> > >> with HDMI (no video= parameter, and EDID enabled, most settings
> > >> > >> at defaults).
> > >> > >> 
> > >> > >> What exactly would cause this, and is there a way I can fix it?
> > >> > > 
> > >> > > I've been playing around with it more, and got it to not blank the
> > >> > > screen after KMS init, /once/. So far no luck repeating that
> > >> > > success.
> > >> > > 
> > >> > > I've tried late, and early kms init, and currently have the radeon
> > >> > > module and firmware compiled into the kernel. Boot times at least
> > >> > > are fairly decent, about 8-10s till X starts, but about 25-35s
> > >> > > till anything shows up.
> > >> > > 
> > >> > > Some strangeness, I have the kernel set to force the hdmi output
> > >> > > to on, with a very specific mode, that X tends to like, the vga
> > >> > > port is forced disabled. X is set to ignore EDID, and also set to
> > >> > > that specific mode that it tends to auto set itself. Regardless X
> > >> > > still wants to pause for 7s 2-3 times while processing EDID info.
> > >> > > 
> > >> > > I've attached the new dmesg and xorg logs from the latest
> > >> > > attempts.
> > >> > > 
> > >> > > Note, this only happens with KMS, with HDMI. disabling KMS, or
> > >> > > using DVI makes the problem go away. Even grub's own graphical
> > >> > > mode works fine, its only once KMS inits that things go bad, and
> > >> > > its not till after X is up for a few seconds that something
> > >> > > displays on my screen.
> > >> > > 
> > >> > > --
> > >> > > Thomas Fjellstrom
> > >> > > thomas@fjellstrom.ca
> > >> > 
> > >> > Please boot with drm.debug=4 and attach dmesg it should be more
> > >> > verbose. You might also want to try booting with radeon.audio=0
> > >> 
> > >> Hi, attached both one with just drm.debug=4, and one with that and
> > >> radeon.audio=0.
> > >> 
> > >> Now, I'm guessing its a bug in my monitor claiming it can do HDMI
> > >> audio? As setting radeon.audio=0 seems to have fixed the blanking
> > >> problem. And the dmesg logs seem to claim that radeon thinks it can
> > >> do HDMI audio.
> > 
> > Most likely the driver is sending the wrong packets for hdmi audio.
> > Until that gets fixed up, it's probably best to disable hdmi audio if
> > it's not working for you.
> 
> Ok. I'll do that for now, since I have no need for HDMI audio atm. My
> receiver is only capable of Dolby Pro Logic input, so eh.
> 
> Would be nice to fix the xorg pauses. And whatever is causing the massive
> amounts of drm log spam (yes, I could disable drm.debug, but that would
> just hide the issue, as whatever it is, will keep doing whatever it is
> doing regardless).

Any hints on where to look to fix the stalls when the xorg radeon driver starts 
up?

> > Alex
> > 
> > >> It also seems to be ignoring the mode I've requested via the video=
> > >> param. It at least sees that I want it forced enabled, but claims its
> > >> 0x0? Or at least it seems its picking the preferred mode.
> > >> 
> > >> Still have X blocking for up to 14s though.
> > >> 
> > >> Theres also a bunch of repeated log messages from drm now, every
> > >> second about it seems to spam the following lines: (the last one is
> > >> repeated a bunch of times, with FB:44 or FB:42)
> > >> 
> > >> [   31.330033] [drm:output_poll_execute], [CONNECTOR:13:VGA-1] status
> > >> updated from 2 to 2
> > >> [   31.435455] [drm:radeon_atombios_connected_scratch_regs], DFP1
> > >> connected [   31.435463] [drm:output_poll_execute],
> > >> [CONNECTOR:15:HDMI-A-1] status updated from 1 to 1
> > >> [   31.437391] [drm:drm_mode_addfb], [FB:42]
> > >> 
> > >> > Cheers,
> > >> > Jerome
> > > 
> > > Ok, a bit more news. My monitor does indeed support audio, at least it
> > > has volume buttons, so I assume it has speakers, and should support
> > > HDMI audio (I have never used it though).
> > > 
> > > --
> > > Thomas Fjellstrom
> > > thomas@fjellstrom.ca
> > > _______________________________________________
> > > dri-devel mailing list
> > > dri-devel@lists.freedesktop.org
> > > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
