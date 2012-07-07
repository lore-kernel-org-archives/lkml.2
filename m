Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2GGXGx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:06:53 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:51677 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab2GGXG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:06:26 -0400
Date: Sun, 8 Jul 2012 00:06:18 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ezequiel Garcia <elezegarcia@gmail.com>
cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, Ralf Baechle <ralf@linux-mips.org>,
        Jaroslav Kysela <perex@perex.cz>, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH 2/3] swarm_cs4297: Rename AC97 registers to use
 sound/ac97_codec.h definitions
In-Reply-To: <CALF0-+Vbje9D44KpX+vP3XoZGMX-ipXPJp5mejOqP=EseyPYBg@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1207072320000.12288@eddie.linux-mips.org>
References: <1339444731-15678-1-git-send-email-elezegarcia@gmail.com>        <1339444731-15678-2-git-send-email-elezegarcia@gmail.com>        <s5h8vfkn2bb.wl%tiwai@suse.de>        <CALF0-+Ukw2+whn5zpA4R6PjN0BoLm5aUhQKUNQt0rpWM1vNXFA@mail.gmail.com>       
 <s5ha9zz97zw.wl%tiwai@suse.de>        <CALF0-+WxqMmoPMGjMZBBiKq2NR5qPESo6mA0B4MPhdyc_KUNsw@mail.gmail.com>        <s5h1ulbjwnr.wl%tiwai@suse.de> <CALF0-+Vbje9D44KpX+vP3XoZGMX-ipXPJp5mejOqP=EseyPYBg@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2012, Ezequiel Garcia wrote:

> >> >> >> This patch removes the last usage of linux/ac97_codec.h
> >> >> >> by renaming ac97 registers to use sound/ac97_codec.h definitions.
> >> >> >> This will enable us to remove linux/ac97_codec.h.
> >> >> >>
> >> >> >> Not even compilation tested.
> >> >> >>
> >> >> >> Cc: Ralf Baechle <ralf@linux-mips.org>
> >> >> >> Cc: Jaroslav Kysela <perex@perex.cz>
> >> >> >> Cc: Takashi Iwai <tiwai@suse.de>
> >> >> >> Cc: Clemens Ladisch <clemens@ladisch.de>
> >> >> >> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> >> >> >> ---
> >> >> >> Hi all,
> >> >> >>
> >> >> >> This patch is important so we can remove linux/ac97_codec.h usage.
> >> >> >> Since this driver is mips related, I can't test it until I install
> >> >> >> a mips toolchain.
> >> >> >> If someone can compile this for me, or even test it with real
> >> >> >> hardware I think it would be better.
> >> >> >> If not then I can install a mips toolchain and compile it myself,
> >> >> >> but I won't be able to test it on real hardware.
> >> >> >>
> >> >> >> This patch should be treated with carefully and be applied only
> >> >> >> if someone manages to test it.
> >> >> >
> >> >> > A slight concern by this change is that the driver includes
> >> >> > sound/ac97_codec.h although it's based on OSS framework.
> >> >> > sound/ac97_codec.h is the header for ALSA ac97 structs, and this can't
> >> >> > be mixed up with OSS.
> >> >> >
> >> >> > If the intention is only about AC97 register definition, we may split
> >> >> > ac97_codec.h into ac97_regs.h and ac97_codecs.h where the former
> >> >> > contains only the register definitions (thus framework-neutral) and
> >> >> > the latter includes the former.
> >> >> >
> >> >> >
> >> >>
> >> >> Yes, splitting sounds good to me. It could be useful for other ac97
> >> >> drivers (e.g. em28xx).
> >>
> >> On a second thought, I'm not sure splitting the header is the best way
> >> to proceed. Since swarm just uses some AC97 register definition
> >> maybe we could just duplicate those (less than ten) macros in swarm
> >> c file.
> >>
> >> It's a less intrusive aproach and it allows us to remove the unused
> >> linux/ac97_codec.h.
> >
> > I'm OK in both ways.
> >
> 
> Okey, consider this last two patches nacked and I'll prepare new ones.
> Still, I would like someone to *at least* compile swarm driver with the patch.

 I'll see what I can do sometime, but not very soon I am afraid, I'm 
overloaded.  Please ping me back if you have any new code.

 This board has an interesting setup in that it does not have a sound 
adapter, not at least a "proper" one.  The AC97 codec is wired to a 
generic serial port, one of a pair, both embedded in the SOC that 
comprises the heart of the system.  The two serial ports (USARTs) are 
identical, have external line drivers and corresponding DE-9 connectors 
and can be reconfigured independently for either asynchronous or 
synchronous operation -- for the latter the usual clocking modes are 
supported as for DTE or DCE and the clock lines are wired to the external 
connector too, for use as inputs or outputs as required.

 The port that is used for the AC97 is multiplexed between the codec and 
the line driver/external connector with an additional control circuit.  
For sound I/O (input is accepted too; two 3.5mm TRS sockets are available 
for input and output, respectively) the serial port has to be configured 
for synchronous operation and internal clocking at 48kHz; DMA is available 
via a general-purpose third-party data mover agent available within the 
SOC (it doesn't care whether it moves sound samples or other data for the 
serial port of course), one of four with no specific preassignment and 
the usual data needed/data available/underrun/overrun interrupt support.

 So all in all for actual operation what this needs is a generic AC97 
driver plus some infrastructure to configure the board logic in the right 
mode.  For years my plan has been to properly support the multiplexer as 
well and make it possible for the first user to grab the right driver and 
lock the USART as long as it needs -- i.e. when you open the sound device, 
then the USART is configured for synchronous operation as appropriate, the 
line multiplexer switched for the AC97 and any attempts to open the 
corresponding serial port return EBUSY.  Once the sound device is closed, 
the USART is disabled, the rest of the logic set to some sane state and 
both devices available for any one to be picked.  Likewise when the serial 
port device is opened, then the USART is configured as requested, the 
multiplexer switched for the serial line driver and any attempt to open 
the sound device returns EBUSY.

 Right now the configuration is selected via kernel build configuration, 
that is, ahem, a bit antiquated for today's standards.  Though, 
presumably, nobody has tried using the sound device for quite a while now.  
Even back when I first used it the driver had endianness issues that I had 
to correct (I reckon it didn't byte-swap the samples in the little-endian 
mode -- the board is bi-endian, but it was the big endianness that was 
considered the default).  And that was some nine years ago already IIRC.

  Maciej
