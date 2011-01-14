Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab1ANOFk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:05:40 -0500
Received: from nerdhammel.gnuher.de ([88.198.0.170]:46079 "EHLO
	nerdhammel.gnuher.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1ANOFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:05:34 -0500
Date: Fri, 14 Jan 2011 15:04:58 +0100
From: Matthias Merz <linux@merz-ka.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Brian Gerst <brgerst@gmail.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Christoph Hellwig <hch@lst.de>, Eric Dumazet <eric.dumazet@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Regression in linux 2.6.37: failure on remount / (ext4) rw
Message-ID: <20110114140458.GA7558@merz.inka.de>
References: <20110110223154.GA9739@merz.inka.de> <AANLkTi=hnWtpHgv-j0u3n5sG4T-GU0KG_vAMe4vevY05@mail.gmail.com> <20110111130959.GA19003@merz.inka.de> <AANLkTimViOqKP9aw28PVt0_2LcH_OuruS736fickb_jp@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimViOqKP9aw28PVt0_2LcH_OuruS736fickb_jp@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: 1.3
X-Spam-Report: No, score=1.3 required=5.5 autolearn=no
	* -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	*  0.8 SARE_BAYES_5x8 BODY: Bayes poison 5x8
	*  0.8 SARE_BAYES_6x8 BODY: Bayes poison 6x8
	*  1.0 SARE_BAYES_7x8 BODY: Bayes poison 7x8
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1976]
	* -0.5 AWL AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am Mi, 12.01.2011 09:03 schrieb Pekka Enberg
> On Tue, Jan 11, 2011 at 3:09 PM, Matthias Merz <linux@merz-ka.de> wrote:
> > Am Di, 11.01.2011 09:50 schrieb Pekka Enberg
> >> On Tue, Jan 11, 2011 at 12:31 AM, Matthias Merz <linux@merz-ka.de> wrote:
> >> > This morning I tried vanilla 2.6.37 on my Desktop system, which
> >> > failed to boot but continued displaying Debug-Messages too fast
> >> > to read. Using netconsole I was then able to capture them [see
> >> > below]. I was able to trigger this bug even with init=/bin/bash
> >> > by a simple call of "mount -o remount,rw /" with my / being an
> >> > ext4 filesystem.
> > [erroneous bisecting] I assume some "hardware state" influeces
> > triggering of this bug

> Would it be possible for you to try to bisect it again? The oops you
> report looks slightly obscure (at least to me) so it might be
> difficult to find someone to fix it.

Calling back after some time. Now I seem to have worked out a way to
tell which versions are bad: After having booted a "good" version, a
Power-down for a period of several minutes is needed (about 15 or so) or
every version will be "good". So I checked by first booting a "known
bad" 2.6.37. If that boot failed, I booted the version I wished to
check, which seems to have produced usable results. So I was/am pretty
convinced that something during "hardware setup" has changed which will
survive a normal reset due to capacitances not fully discharged or
something like that.


git bisect now told me "22d4cd4c4dce6d7b7d9a7e396aa4f87fe7a649b1 is the
first bad commit", which is titled: "x86-32: Allocate irq stacks
seperate from percpu area".

I reverted this change (and following 47f19a0814 due to #defines) and
waited over the night until this morning. That revert really seems to
fix my problem. So maybe in my special case something goes wrong with
the new method?


I did add CC to the people listed by get_maintainer.pl and tried to weed
out CC a bit from earlier posts.


Thanks for your effort,
Yours
Matthias Merz


Keeping the citation of the debug log in TOFU-style for inline reference:

> BUG: scheduling while atomic: swapper/0/0x10010000
> Modules linked in: i2c_viapro usbhid snd_via82xx via_ircc
> snd_mpu401_uart parport_pc sata_promise sata_sil tmscsim evdev
> snd_bt87x tda9887 snd_seq_dummy snd_seq_oss snd_seq_midi
> snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_ens1371
> snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm snd_timer
> snd snd_page_alloc parport irtty_sir actisys_sir sir_dev irda
> crc_ccitt tuner_simple tuner_types msp3400 ir_lirc_codec lirc_dev
> ir_sony_decoder bttv ir_jvc_decoder ir_rc6_decoder videobuf_dma_sg
> videobuf_core ir_rc5_decoder btcx_risc ir_nec_decoder ir_common
> ir_core tveeprom tuner v4l2_common videodev v4l1_compat analog
> gameport uhci_hcd ehci_hcd e100
> Modules linked in: i2c_viapro usbhid snd_via82xx via_ircc
> snd_mpu401_uart parport_pc sata_promise sata_sil tmscsim evdev
> snd_bt87x tda9887 snd_seq_dummy snd_seq_oss snd_seq_midi
> snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_ens1371
> snd_rawmidi snd_seq_device snd_ac97_codec ac97_bus snd_pcm snd_timer
> snd snd_page_alloc parport irtty_sir actisys_sir sir_dev irda
> crc_ccitt tuner_simple tuner_types msp3400 ir_lirc_codec lirc_dev
> ir_sony_decoder bttv ir_jvc_decoder ir_rc6_decoder videobuf_dma_sg
> videobuf_core ir_rc5_decoder btcx_risc ir_nec_decoder ir_common
> ir_core tveeprom tuner v4l2_common videodev v4l1_compat analog
> gameport uhci_hcd ehci_hcd e100
>
> Pid: 0, comm: swapper Not tainted 2.6.37-matthias #28 A7V8X/System Name
> EIP: 0060:[<c10088ba>] EFLAGS: 00000246 CPU: 0
> EIP is at default_idle+0x2a/0x40
> EAX: 00000000 EBX: c1596140 ECX: 00000000 EDX: 00000000
> ESI: 0008d800 EDI: c153d000 EBP: c153bfbc ESP: c153bfbc
>  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
> Process swapper (pid: 0, ti=f6004000 task=c1541300 task.ti=c153a000)
> Stack:
>  c153bfc4 c1001c7c c153bfcc c13e72a2 c153bfe4 c15706cd 000000a0 c15702b9
>  c1596140 00000000 c153bff8 c157006b 01606d60 00000000 c14b0e88 01827003
>  00000000
> Call Trace:
>  [<c1001c7c>] ? cpu_idle+0x2c/0x50
>  [<c13e72a2>] ? rest_init+0x52/0x60
>  [<c15706cd>] ? start_kernel+0x242/0x248
>  [<c15702b9>] ? unknown_bootoption+0x0/0x19c
>  [<c157006b>] ? i386_start_kernel+0x6b/0x6d
> Code: 00 55 8b 0d 18 67 5c c1 89 e5 85 c9 75 2b 80 3d 05 d5 56 c1 00
> 74 22 89 e0 25 00 e0 ff ff 83 60 0c fb 8b 40 08 a8 08 75 15 fb f4 <89>
> e0 25 00 e0 ff ff 83 48 0c 04 c9 c3 90 fb f3 90 c9 c3 fb eb
>
> Full log available here:
>
> http://www.spinics.net/lists/linux-mm/msg13451.html
