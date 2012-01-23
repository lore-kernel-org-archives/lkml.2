Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab2AWU1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:27:09 -0500
Received: from ip94-39-241-190.ct.co.cr ([190.241.39.94]:35784 "EHLO
	bruno.wildbear.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab2AWU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:27:07 -0500
Date: Mon, 23 Jan 2012 14:27:01 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: linux-kernel@vger.kernel.org
cc: Takashi Iwai <tiwai@suse.de>
Subject: Re: Sound broken in 3.2.0 and 3.2.1
In-Reply-To: <alpine.LNX.2.00.1201131241090.1239@bruno>
Message-ID: <alpine.LNX.2.00.1201230734100.5206@bruno>
References: <alpine.LNX.2.00.1201131241090.1239@bruno>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello again:

I have managed to find a work-around for this problem so that we are now
running 3.2.1 on our production system.  For that reason I can't run
also-info.sh on the 3.1.x system.  I do however have the results from
/proc/asound/Intel/codec#2 for both systems taken earlier.  See below.

To "fix" 3.2.1, I made the following changes to the system startup file:

I discovered that the PCM control, though absent in 3.2.1 on loading the
sound modules with

modprobe snd_hda_intel
modprobe snd_pcm_oss

appears after aplay is called on any sound file.  Also the main playback
volume control has been shifted from "PCM" to "Front" which can be set with:

/usr/bin/amixer sset "Front",0 64,64

I then found that if I rebuilt mplayer2 from git (with the 3.2.1 sound
module loaded) mplayer no longer installs its own volume control filter and
used the "PCM" control normally.  Because I neglected to try rebuilding with
the existing mplayer2 version before updating from git, this could be due to
a change in mplayer2.

In any event this makes the sound system usable for our purposes in 3.2.1
but is clearly a kludge around the regression reported above, particularly
the need to call aplay.

The contents of /proc/asound/Intel/codec#2 for 3.1.8 and 3.2.1 immediately
after the modules are loaded follows:

3.1.9:
Codec: Realtek ALC662 rev1
Address: 2
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0662
Subsystem Id: 0x1565821f
Revision Id: 0x100101
No Modem Function Group found
Default PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="PCM Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x00 0x00]
   Converter: stream=0, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x40 0x40]
   Converter: stream=0, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x04 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Headphone Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x00 0x00]
   Converter: stream=0, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
   Control: name="IEC958 Playback Con Mask", index=0, device=0
   Control: name="IEC958 Playback Pro Mask", index=0, device=0
   Control: name="IEC958 Playback Default", index=0, device=0
   Control: name="IEC958 Playback Switch", index=0, device=0
   Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
   Device: name="ALC662 rev1 Digital", type="SPDIF", device=1
   Converter: stream=0, channel=0
   Digital:
   Digital category: 0x0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Control: name="Capture Switch", index=0, device=0
   Control: name="Capture Volume", index=0, device=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=0
   Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Control: name="Capture Switch", index=1, device=0
   Control: name="Capture Volume", index=1, device=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=2
   Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x22
Node 0x0a [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Rear Mic Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Control: name="Rear Mic Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Control: name="Front Mic Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=1, ofs=0
   Control: name="Front Mic Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=1, ofs=0
   Control: name="Line Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=2, ofs=0
   Control: name="Line Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=2, ofs=0
   Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 9
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16
Node 0x0c [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Connection: 2
      0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80]
   Connection: 2
      0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Connection: 2
      0x04 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Control: name="PCM Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0001003c: IN OUT HP EAPD Detect
   EAPD 0x2: EAPD
   Pin Default 0x01014410: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0x0
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0c
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00010034: IN OUT EAPD Detect
   EAPD 0x2: EAPD
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x16 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00000034: IN OUT Detect
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Rear Mic Boost Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00001734: IN OUT Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x01a19c30: [Jack] Mic at Ext Rear
     Conn = 1/8, Color = Pink
     DefAssociation = 0x3, Sequence = 0x0
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Front Mic Boost Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x0000173c: IN OUT HP Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02a19c31: [Jack] Mic at Ext Front
     Conn = 1/8, Color = Pink
     DefAssociation = 0x3, Sequence = 0x1
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 2
      0x0c* 0x0e
Node 0x1a [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00000034: IN OUT Detect
   Pin Default 0x0181343f: [Jack] Line In at Ext Rear
     Conn = 1/8, Color = Blue
     DefAssociation = 0x3, Sequence = 0xf
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Headphone Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0000173c: IN OUT HP Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02214c1f: [Jack] HP Out at Ext Front
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0xf
   Pin-ctls: 0xc0: OUT HP VREF_HIZ
   Unsolicited: tag=04, enabled=1
   Connection: 2
      0x0c 0x0e*
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x00000020: IN
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
   Pincap 0x00000020: IN
   Pin Default 0x4004c601: [N/A] Line Out at Ext N/A
     Conn = RCA, Color = UNKNOWN
     DefAssociation = 0x0, Sequence = 0x1
   Pin-ctls: 0x20: IN
Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
   Pincap 0x00000010: OUT
   Pin Default 0x01441120: [Jack] SPDIF Out at Ext Rear
     Conn = RCA, Color = Black
     DefAssociation = 0x2, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x40: OUT
   Connection: 1
      0x06
Node 0x1f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
   Processing caps: benign=0, ncoeff=12
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Input Source", index=1, device=0
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Input Source", index=0, device=0
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x25 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x26 [Vendor Defined Widget] wcaps 0xf00000: Mono

3.2.1:
Codec: Realtek ALC662 rev1
Address: 2
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0662
Subsystem Id: 0x1565821f
Revision Id: 0x100101
No Modem Function Group found
Default PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Front Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x00 0x00]
   Converter: stream=8, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Surround Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x40 0x40]
   Converter: stream=8, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x04 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Center Playback Volume", index=0, device=0
     ControlAmp: chs=1, dir=Out, idx=0, ofs=0
   Control: name="LFE Playback Volume", index=0, device=0
     ControlAmp: chs=2, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x40 0x40]
   Converter: stream=8, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
   Control: name="IEC958 Playback Con Mask", index=0, device=0
   Control: name="IEC958 Playback Pro Mask", index=0, device=0
   Control: name="IEC958 Playback Default", index=0, device=0
   Control: name="IEC958 Playback Switch", index=0, device=0
   Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
   Device: name="ALC662 rev1 Digital", type="SPDIF", device=1
   Converter: stream=8, channel=0
   Digital:
   Digital category: 0x0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Control: name="Capture Switch", index=0, device=0
   Control: name="Capture Volume", index=0, device=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=0
   Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Control: name="Capture Switch", index=1, device=0
   Control: name="Capture Volume", index=1, device=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=2
   Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x22
Node 0x0a [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Rear Mic Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Control: name="Rear Mic Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Control: name="Front Mic Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=1, ofs=0
   Control: name="Front Mic Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=1, ofs=0
   Control: name="Line Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=2, ofs=0
   Control: name="Line Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=2, ofs=0
   Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 9
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16
Node 0x0c [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Connection: 2
      0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80]
   Connection: 2
      0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80]
   Connection: 2
      0x04 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Control: name="Front Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0001003c: IN OUT HP EAPD Detect
   EAPD 0x2: EAPD
   Pin Default 0x01014410: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0x0
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0c
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00010034: IN OUT EAPD Detect
   EAPD 0x2: EAPD
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x16 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00000034: IN OUT Detect
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Center Playback Switch", index=0, device=0
     ControlAmp: chs=1, dir=Out, idx=0, ofs=0
   Control: name="LFE Playback Switch", index=0, device=0
     ControlAmp: chs=2, dir=Out, idx=0, ofs=0
   Control: name="Rear Mic Boost Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00001734: IN OUT Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x01a19c30: [Jack] Mic at Ext Rear
     Conn = 1/8, Color = Pink
     DefAssociation = 0x3, Sequence = 0x0
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Front Mic Boost Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x0000173c: IN OUT HP Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02a19c31: [Jack] Mic at Ext Front
     Conn = 1/8, Color = Pink
     DefAssociation = 0x3, Sequence = 0x1
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 2
      0x0c* 0x0e
Node 0x1a [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Control: name="Surround Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00000034: IN OUT Detect
   Pin Default 0x0181343f: [Jack] Line In at Ext Rear
     Conn = 1/8, Color = Blue
     DefAssociation = 0x3, Sequence = 0xf
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Headphone Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0000173c: IN OUT HP Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02214c1f: [Jack] HP Out at Ext Front
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0xf
   Pin-ctls: 0xc0: OUT HP VREF_HIZ
   Unsolicited: tag=04, enabled=1
   Connection: 2
      0x0c* 0x0e
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x00000020: IN
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
   Pincap 0x00000020: IN
   Pin Default 0x4004c601: [N/A] Line Out at Ext N/A
     Conn = RCA, Color = UNKNOWN
     DefAssociation = 0x0, Sequence = 0x1
   Pin-ctls: 0x20: IN
Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
   Pincap 0x00000010: OUT
   Pin Default 0x01441120: [Jack] SPDIF Out at Ext Rear
     Conn = RCA, Color = Black
     DefAssociation = 0x2, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x40: OUT
   Connection: 1
      0x06
Node 0x1f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
   Processing caps: benign=0, ncoeff=12
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Input Source", index=1, device=0
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Input Source", index=0, device=0
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x25 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x26 [Vendor Defined Widget] wcaps 0xf00000: Mono


These results were obtained after rebuilding (in this order) alsalibs,
alsautils, gamix, aumix, and sox in linux-3.2.1 with the sound modules for
3.2.1 installed.

Both the PCM and Front sound controls now show in alsamixer and amixer, and
work normally.

The PCM slider now shows in gamix and moving it does affect the setting, but
it does not track the PCM setting from other sources.  The Front slider also
now appears in gamix and works normally.

Neither the PCM nor Front control shows in aumix.


The output from /proc/asound/Intel/codec#2 for 3.2.1 after the kludges above
in the startup file follows.  Note that the only change is due to the Front
volume being set with amixer.  In particular the PCM control is still
missing here but now shows and works normallly in amixer and alsamixer, and
it controls the sound output normally in aplay, play, and mplayer2.

Codec: Realtek ALC662 rev1
Address: 2
AFG Function Id: 0x1 (unsol 1)
Vendor Id: 0x10ec0662
Subsystem Id: 0x1565821f
Revision Id: 0x100101
No Modem Function Group found
Default PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Default Amp-In caps: N/A
Default Amp-Out caps: N/A
GPIO: io=2, o=0, i=0, unsolicited=1, wake=0
   IO[0]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
   IO[1]: enable=0, dir=0, wake=0, sticky=0, data=0, unsol=0
Node 0x02 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Front Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x40 0x40]
   Converter: stream=8, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x03 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Surround Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x40 0x40]
   Converter: stream=8, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x04 [Audio Output] wcaps 0x1d: Stereo Amp-Out
   Control: name="Center Playback Volume", index=0, device=0
     ControlAmp: chs=1, dir=Out, idx=0, ofs=0
   Control: name="LFE Playback Volume", index=0, device=0
     ControlAmp: chs=2, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x40, nsteps=0x40, stepsize=0x03, mute=0
   Amp-Out vals:  [0x40 0x40]
   Converter: stream=8, channel=0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0xe]: 16 20 24
     formats [0x1]: PCM
Node 0x05 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x06 [Audio Output] wcaps 0x211: Stereo Digital
   Control: name="IEC958 Playback Con Mask", index=0, device=0
   Control: name="IEC958 Playback Pro Mask", index=0, device=0
   Control: name="IEC958 Playback Default", index=0, device=0
   Control: name="IEC958 Playback Switch", index=0, device=0
   Control: name="IEC958 Default PCM Playback Switch", index=0, device=0
   Device: name="ALC662 rev1 Digital", type="SPDIF", device=1
   Converter: stream=8, channel=0
   Digital:
   Digital category: 0x0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x1e]: 16 20 24 32
     formats [0x1]: PCM
Node 0x07 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x08 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Control: name="Capture Switch", index=0, device=0
   Control: name="Capture Volume", index=0, device=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=0
   Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x23
Node 0x09 [Audio Input] wcaps 0x10011b: Stereo Amp-In
   Control: name="Capture Switch", index=1, device=0
   Control: name="Capture Volume", index=1, device=0
   Device: name="ALC662 rev1 Analog", type="Audio", device=2
   Amp-In caps: ofs=0x09, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80]
   Converter: stream=0, channel=0
   SDI-Select: 0
   PCM:
     rates [0x160]: 44100 48000 96000
     bits [0x6]: 16 20
     formats [0x1]: PCM
   Connection: 1
      0x22
Node 0x0a [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x0b [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Rear Mic Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Control: name="Rear Mic Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Control: name="Front Mic Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=1, ofs=0
   Control: name="Front Mic Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=1, ofs=0
   Control: name="Line Playback Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=2, ofs=0
   Control: name="Line Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=2, ofs=0
   Amp-In caps: ofs=0x17, nsteps=0x1f, stepsize=0x05, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 9
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16
Node 0x0c [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x00 0x00]
   Connection: 2
      0x02 0x0b
Node 0x0d [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80]
   Connection: 2
      0x03 0x0b
Node 0x0e [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80]
   Connection: 2
      0x04 0x0b
Node 0x0f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x10 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x11 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x12 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x13 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x14 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Control: name="Front Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0001003c: IN OUT HP EAPD Detect
   EAPD 0x2: EAPD
   Pin Default 0x01014410: [Jack] Line Out at Ext Rear
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0x0
   Pin-ctls: 0x40: OUT
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0c
Node 0x15 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00010034: IN OUT EAPD Detect
   EAPD 0x2: EAPD
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x16 [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00000034: IN OUT Detect
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x17 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x18 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Center Playback Switch", index=0, device=0
     ControlAmp: chs=1, dir=Out, idx=0, ofs=0
   Control: name="LFE Playback Switch", index=0, device=0
     ControlAmp: chs=2, dir=Out, idx=0, ofs=0
   Control: name="Rear Mic Boost Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00001734: IN OUT Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x01a19c30: [Jack] Mic at Ext Rear
     Conn = 1/8, Color = Pink
     DefAssociation = 0x3, Sequence = 0x0
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0e
Node 0x19 [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Front Mic Boost Volume", index=0, device=0
     ControlAmp: chs=3, dir=In, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x0000173c: IN OUT HP Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02a19c31: [Jack] Mic at Ext Front
     Conn = 1/8, Color = Pink
     DefAssociation = 0x3, Sequence = 0x1
   Pin-ctls: 0x24: IN VREF_80
   Unsolicited: tag=00, enabled=0
   Connection: 2
      0x0c* 0x0e
Node 0x1a [Pin Complex] wcaps 0x40018d: Stereo Amp-Out
   Control: name="Surround Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x80 0x80]
   Pincap 0x00000034: IN OUT Detect
   Pin Default 0x0181343f: [Jack] Line In at Ext Rear
     Conn = 1/8, Color = Blue
     DefAssociation = 0x3, Sequence = 0xf
   Pin-ctls: 0x20: IN
   Unsolicited: tag=00, enabled=0
   Connection: 1
      0x0d
Node 0x1b [Pin Complex] wcaps 0x40018f: Stereo Amp-In Amp-Out
   Control: name="Headphone Playback Switch", index=0, device=0
     ControlAmp: chs=3, dir=Out, idx=0, ofs=0
   Amp-In caps: ofs=0x00, nsteps=0x03, stepsize=0x27, mute=0
   Amp-In vals:  [0x00 0x00]
   Amp-Out caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-Out vals:  [0x00 0x00]
   Pincap 0x0000173c: IN OUT HP Detect
     Vref caps: HIZ 50 GRD 80
   Pin Default 0x02214c1f: [Jack] HP Out at Ext Front
     Conn = 1/8, Color = Green
     DefAssociation = 0x1, Sequence = 0xf
   Pin-ctls: 0xc0: OUT HP VREF_HIZ
   Unsolicited: tag=04, enabled=1
   Connection: 2
      0x0c* 0x0e
Node 0x1c [Pin Complex] wcaps 0x400001: Stereo
   Pincap 0x00000020: IN
   Pin Default 0x411111f0: [N/A] Speaker at Ext Rear
     Conn = 1/8, Color = Black
     DefAssociation = 0xf, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x20: IN
Node 0x1d [Pin Complex] wcaps 0x400000: Mono
   Pincap 0x00000020: IN
   Pin Default 0x4004c601: [N/A] Line Out at Ext N/A
     Conn = RCA, Color = UNKNOWN
     DefAssociation = 0x0, Sequence = 0x1
   Pin-ctls: 0x20: IN
Node 0x1e [Pin Complex] wcaps 0x400300: Mono Digital
   Pincap 0x00000010: OUT
   Pin Default 0x01441120: [Jack] SPDIF Out at Ext Rear
     Conn = RCA, Color = Black
     DefAssociation = 0x2, Sequence = 0x0
     Misc = NO_PRESENCE
   Pin-ctls: 0x40: OUT
   Connection: 1
      0x06
Node 0x1f [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x20 [Vendor Defined Widget] wcaps 0xf00040: Mono
   Processing caps: benign=0, ncoeff=12
Node 0x21 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x22 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Input Source", index=1, device=0
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x23 [Audio Mixer] wcaps 0x20010b: Stereo Amp-In
   Control: name="Input Source", index=0, device=0
   Amp-In caps: ofs=0x00, nsteps=0x00, stepsize=0x00, mute=1
   Amp-In vals:  [0x00 0x00] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80] [0x80 0x80]
   Connection: 10
      0x18 0x19 0x1a 0x1b 0x1c 0x1d 0x14 0x15 0x16 0x0b
Node 0x24 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x25 [Vendor Defined Widget] wcaps 0xf00000: Mono
Node 0x26 [Vendor Defined Widget] wcaps 0xf00000: Mono


If you need additional information, please contact me and I will try to
provide it.


Yours,
Joseph Parmelee
