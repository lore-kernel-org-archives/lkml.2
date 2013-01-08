Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab3AHOOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:14:18 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:59664 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187Ab3AHOOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:14:17 -0500
Message-ID: <1357654434.3979.8.camel@lamella>
Subject: Re: [3.6.9 -> 3.7.1 regression] sound: snd_hda_intel codec probing
 issue?
From: Vincent Blut <vincent.debian@free.fr>
To: Takashi Iwai <tiwai@suse.de>
Cc: Maurizio Avogadro <mavoga@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jan 2013 15:13:54 +0100
In-Reply-To: <s5hehhvq1dm.wl%tiwai@suse.de>
References: <1356704740.3953.26.camel@lamella>
	 <s5hvcber5cz.wl%tiwai@suse.de> <1357421043.3912.13.camel@lamella>
	 <s5h38ydpf45.wl%tiwai@suse.de> <1357648135.3849.7.camel@lamella>
	 <s5hehhvq1dm.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 08 janvier 2013 à 13:56 +0100, Takashi Iwai a écrit :
> At Tue, 08 Jan 2013 13:28:55 +0100,
> Vincent Blut wrote:
> > 
> > Le lundi 07 janvier 2013 à 09:32 +0100, Takashi Iwai a écrit :
> > > At Sat, 05 Jan 2013 22:24:03 +0100,
> > > 
> > > One more thing to test is whether azx_runtime_resume() is properly
> > > called before this error happens.  Could you put a debug print and
> > > check it?  If it's not called, it implies that the refcount or
> > > something else got broken.  If it's called but the device doesn't
> > > respond, it's a hardware-specific issue, and the likely solution is to
> > > add a device-specific quirk.
> > > 
> > 
> > Ok, I added a debug printk() which is called:
> > 
> > $ dmesg | grep -i debug
> > [ 5330.371523] [debug] Probably needs a device-specific quirk!
> > 
> > As usual, when it is called the sound become very choppy.
> 
> OK.  So it's not the driver code but really a problem in the deeper
> level.

Sad, by the way I'm puzzled due to the fact that nobody hit this issue,
those audio controllers are quite common, no?

> 
> > I'll test with enable_msi=0 later.
> 
> Thanks.

There isn't any positive effect with this parameter.

> 
> FWIW, below is a patch I'm considering to merge (after testing, of
> course).  Could you buys check it?

I'll give it a try.

> 
> 
> Takashi
> 
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Disable runtime D3 for Intel CPT & co
> 
> We've got a few bug reports that the runtime D3 results in the dead
> HD-audio controller.  It seems that the problem is in a deeper level
> than the sound driver itself, so as a temporal solution, disable the
> feature for these controllers again.
> 
> Reported-by: Vincent Blut <vincent.debian@free.fr>
> Reported-by: Maurizio Avogadro <mavoga@gmail.com>
> Cc: <stable@vger.kernel.org> [v3.7]
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/hda_intel.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index cca8727..0b6aeba 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -573,9 +573,12 @@ enum {
>  #define AZX_DCAPS_PM_RUNTIME	(1 << 26)	/* runtime PM support */
>  
>  /* quirks for Intel PCH */
> -#define AZX_DCAPS_INTEL_PCH \
> +#define AZX_DCAPS_INTEL_PCH_NOPM \
>  	(AZX_DCAPS_SCH_SNOOP | AZX_DCAPS_BUFSIZE | \
> -	 AZX_DCAPS_COUNT_LPIB_DELAY | AZX_DCAPS_PM_RUNTIME)
> +	 AZX_DCAPS_COUNT_LPIB_DELAY)
> +
> +#define AZX_DCAPS_INTEL_PCH \
> +	(AZX_DCAPS_INTEL_PCH_NOPM | AZX_DCAPS_PM_RUNTIME)
>  
>  /* quirks for ATI SB / AMD Hudson */
>  #define AZX_DCAPS_PRESET_ATI_SB \
> @@ -3586,13 +3589,13 @@ static void azx_remove(struct pci_dev *pci)
>  static DEFINE_PCI_DEVICE_TABLE(azx_ids) = {
>  	/* CPT */
>  	{ PCI_DEVICE(0x8086, 0x1c20),
> -	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
> +	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
>  	/* PBG */
>  	{ PCI_DEVICE(0x8086, 0x1d20),
> -	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
> +	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
>  	/* Panther Point */
>  	{ PCI_DEVICE(0x8086, 0x1e20),
> -	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },
> +	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH_NOPM },
>  	/* Lynx Point */
>  	{ PCI_DEVICE(0x8086, 0x8c20),
>  	  .driver_data = AZX_DRIVER_PCH | AZX_DCAPS_INTEL_PCH },



