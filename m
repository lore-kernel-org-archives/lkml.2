Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756064Ab1HFQuJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 12:50:09 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:44877 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753619Ab1HFQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 12:50:06 -0400
Date: Sat, 6 Aug 2011 09:50:04 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Ondrej Zary <linux@rainbow-software.org>
Subject: Re: linux-next: Tree for Aug 5 (media/radio/radio-sf16fmr2)
Message-Id: <20110806095004.017f6771.rdunlap@xenotime.net>
In-Reply-To: <s5hy5z79bx8.wl%tiwai@suse.de>
References: <20110805143103.f9388ca143560d73caac60c1@canb.auug.org.au>
	<20110805165611.d2feaf32.rdunlap@xenotime.net>
	<s5hy5z79bx8.wl%tiwai@suse.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 06 Aug 2011 10:33:39 +0200 Takashi Iwai wrote:

> At Fri, 5 Aug 2011 16:56:11 -0700,
> Randy Dunlap wrote:
> > 
> > On Fri, 5 Aug 2011 14:31:03 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > [The kernel.org mirroring is running slowly today]
> > 
> > Is media/radio/radio-sf16fmr2 an ISA driver or a PCI driver?
> > ugh.  Or is it an I2C driver?
> > 
> > 
> > linux-next fails with (this is not a new failure):
> > 
> > ERROR: "snd_tea575x_init" [drivers/media/radio/radio-sf16fmr2.ko] undefined!
> > ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-sf16fmr2.ko] undefined!
> > 
> > The Kconfig entry for RADIO_SF16FMR2 is:
> > 
> > config RADIO_SF16FMR2
> > 	tristate "SF16FMR2 Radio"
> > 	depends on ISA && VIDEO_V4L2 && SND
> > 
> > and the Kconfig entry for SND_TEA575X is (not user visible):
> > 
> > config SND_TEA575X
> > 	tristate
> > 	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
> > 	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
> > 
> > This latter entry is in sound/pci/Kconfig and is under:
> > if SND_PCI
> > so it depends on PCI and SND_PCI.
> > 
> > This build fails when CONFIG_PCI is not enabled.
> 
> tea575x-tuner is an i2c component (not meaning Linux i2c-subsystem),
> thus should be independent from the board bus type.
> Does a patch like below work?
> 

Yes, it does.  Thanks.

Reported-by: Randy Dunlap <rdunlap@xenotime.net>
Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> 
> thanks,
> 
> Takashi
> 
> ---
> diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> index 50abf5b..8816804 100644
> --- a/sound/pci/Kconfig
> +++ b/sound/pci/Kconfig
> @@ -1,5 +1,10 @@
>  # ALSA PCI drivers
>  
> +config SND_TEA575X
> +	tristate
> +	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
> +	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
> +
>  menuconfig SND_PCI
>  	bool "PCI sound devices"
>  	depends on PCI
> @@ -563,11 +568,6 @@ config SND_FM801_TEA575X_BOOL
>  	  FM801 chip with a TEA5757 tuner (MediaForte SF256-PCS, SF256-PCP and
>  	  SF64-PCR) into the snd-fm801 driver.
>  
> -config SND_TEA575X
> -	tristate
> -	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2
> -	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2
> -
>  source "sound/pci/hda/Kconfig"
>  
>  config SND_HDSP
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
