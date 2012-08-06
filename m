Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab2HFJDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:03:22 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64050 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab2HFJDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:03:20 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <alpine.LSU.2.00.1208052113530.1300@eggly.anvils>
References: <alpine.LSU.2.00.1208040936570.1161@eggly.anvils>
	<s5h3941ke2p.wl%tiwai@suse.de>
	<alpine.LSU.2.00.1208052113530.1300@eggly.anvils>
Date: Mon, 6 Aug 2012 11:03:19 +0200
Message-ID: <CAKMK7uHZ3F9neO6=ZX2MFLzYmincPeEF23udgZ-0YJ0R+WHEkg@mail.gmail.com>
Subject: Re: i915 regression on 3.6-rc1: lid blanks screen
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Hugh Dickins <hughd@google.com>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Giacomo Comes <comes@naic.edu>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 6:21 AM, Hugh Dickins <hughd@google.com> wrote:
> On Sun, 5 Aug 2012, Takashi Iwai wrote:
>> At Sat, 4 Aug 2012 10:01:13 -0700 (PDT),
>> Hugh Dickins wrote:
>> >
>> > Sorry to report that with 3.6-rc1, closing and opening the lid on
>> > this ThinkPad T420s leaves the screen blank, and I have to reboot.
>> >
>> > I understand there's also an nVidia graphics device in here,
>> > but I have that configured out, preferring to use the i915:
>> >
>> > 00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core Processor Family Integrated Graphics Controller (rev 09) (prog-if 00 [VGA controller])
>> >     Subsystem: Lenovo Device 21d3
>> >     Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>> >     Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>> >     Latency: 0
>> >     Interrupt: pin A routed to IRQ 41
>> >     Region 0: Memory at f1400000 (64-bit, non-prefetchable) [size=4M]
>> >     Region 2: Memory at e0000000 (64-bit, prefetchable) [size=256M]
>> >     Region 4: I/O ports at 5000 [size=64]
>> >     Expansion ROM at <unassigned> [disabled]
>> >     Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>> >             Address: fee0100c  Data: 41c2
>> >     Capabilities: [d0] Power Management version 2
>> >             Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
>> >             Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
>> >     Capabilities: [a4] PCI Advanced Features
>> >             AFCap: TP+ FLR+
>> >             AFCtrl: FLR-
>> >             AFStatus: TP-
>> >     Kernel driver in use: i915
>> >
>> > Bisection led to this commit, and reverting indeed gets my screen back:
>> >
>> > commit 520c41cf2fa029d1e8b923ac2026f96664f17c4b
>> > Author: Daniel Vetter <daniel.vetter@ffwll.ch>
>> > Date:   Wed Jul 11 16:27:52 2012 +0200
>> >
>> >     drm/i915/lvds: ditch ->prepare special case
> ...
>>
>> Hm, it's surprising.
>>
>> Could you check whether the counter-part intel_lvds_enable() is
>> called?  If the prepare callback affects, it must be from the mode
>> setting (drm_crtc_helper_set_mode()).
>
> Yes, I put a dump_stack() in both, and intel_lvds_enable() gets called
> about 0.28 seconds after the intel_lvds_disable() when I lift the lid;
> but with no video display until I revert that commit.

Can you please boot with drm.debug=0xe added to your kernel cmdline,
reproduce the issue (with the two dump_stack calls added) and then
attach the full dmesg?

Also a few other things to try: What happens if you do a modeset on
the LVDS while it's still working, e.g.

xrandr --outpu LVDS1 --auto --crtc 1

then switch back to crtc 0 with

xrandr --outpu LVDS1 --auto --crtc 0

Would also be interesting to know whether this can resurrect your machine.

Also, how blank is the screen? I.e. is only the backlight off, but you
can (dimly) see some screen contents, or is it completely off?

Thanks, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
