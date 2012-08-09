Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030375Ab2HIOTg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:19:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932419Ab2HIOTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:19:35 -0400
Message-ID: <5023C6F9.3040009@canonical.com>
Date: Thu, 09 Aug 2012 16:19:37 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] ALSA: hda - Deferred probing with request_firmware_nowait()
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de> <s5hhascft86.wl%tiwai@suse.de> <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de> <s5hd330frn1.wl%tiwai@suse.de> <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de> <s5h7gt8fr47.wl%tiwai@suse.de> <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de> <s5hzk64earo.wl%tiwai@suse.de> <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de> <s5hobmk2ql5.wl%tiwai@suse.de> <s5hd3302ovw.wl%tiwai@suse.de> <s5ha9y42os2.wl%tiwai@suse.de> <5023BAA0.1080304@canonical.com> <s5h4noc2ntn.wl%tiwai@suse.de> <s5h1ujg2nm7.wl%tiwai@suse.de> <5023C0FC.2030207@canonical.com> <s5hsjbw17r0.wl%tiwai@suse.de> <s5hpq7017gw.wl%tiwai@suse.de>
In-Reply-To: <s5hpq7017gw.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 04:10 PM, Takashi Iwai wrote:
> For processing the firmware handling properly for built-in kernels,
> implement an asynchronous firmware loading with
> request_firmware_nowait().  This means that the codec probing is
> deferred when the patch option is specified.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>

Looks better now!

Reviewed-by: David Henningsson <david.henningsson@canonical.com>

> ---
> v1->v2: drop superfluous chip->probe_deferred field
> v2->v3: fix missing chip->fw; renamed the variable to "probe_now"
>
>   sound/pci/hda/hda_codec.c |  2 +-
>   sound/pci/hda/hda_intel.c | 42 ++++++++++++++++++++++++++++++++++++++----
>   2 files changed, 39 insertions(+), 5 deletions(-)
>
> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 88a9c20..408babc 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -4184,7 +4184,7 @@ int snd_hda_codec_build_pcms(struct hda_codec *codec)
>    *
>    * This function returns 0 if successful, or a negative error code.
>    */
> -int __devinit snd_hda_build_pcms(struct hda_bus *bus)
> +int snd_hda_build_pcms(struct hda_bus *bus)
>   {
>   	struct hda_codec *codec;
>
> diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
> index b25d539..3de3a5c 100644
> --- a/sound/pci/hda/hda_intel.c
> +++ b/sound/pci/hda/hda_intel.c
> @@ -564,13 +564,17 @@ enum {
>    * VGA-switcher support
>    */
>   #ifdef SUPPORT_VGA_SWITCHEROO
> +#define use_vga_switcheroo(chip)	((chip)->use_vga_switcheroo)
> +#else
> +#define use_vga_switcheroo(chip)	0
> +#endif
> +
> +#if defined(SUPPORT_VGA_SWITCHEROO) || defined(CONFIG_SND_HDA_PATCH_LOADER)
>   #define DELAYED_INIT_MARK
>   #define DELAYED_INITDATA_MARK
> -#define use_vga_switcheroo(chip)	((chip)->use_vga_switcheroo)
>   #else
>   #define DELAYED_INIT_MARK	__devinit
>   #define DELAYED_INITDATA_MARK	__devinitdata
> -#define use_vga_switcheroo(chip)	0
>   #endif
>
>   static char *driver_short_names[] DELAYED_INITDATA_MARK = {
> @@ -3155,12 +3159,38 @@ static void power_down_all_codecs(struct azx *chip)
>   #endif
>   }
>
> +/* callback from request_firmware_nowait() */
> +static void azx_firmware_cb(const struct firmware *fw, void *context)
> +{
> +	struct snd_card *card = context;
> +	struct azx *chip = card->private_data;
> +	struct pci_dev *pci = chip->pci;
> +
> +	if (!fw) {
> +		snd_printk(KERN_ERR SFX "Cannot load firmware, aborting\n");
> +		goto error;
> +	}
> +
> +	chip->fw = fw;
> +	if (!chip->disabled) {
> +		/* continue probing */
> +		if (azx_probe_continue(chip))
> +			goto error;
> +	}
> +	return; /* OK */
> +
> + error:
> +	snd_card_free(card);
> +	pci_set_drvdata(pci, NULL);
> +}
> +
>   static int __devinit azx_probe(struct pci_dev *pci,
>   			       const struct pci_device_id *pci_id)
>   {
>   	static int dev;
>   	struct snd_card *card;
>   	struct azx *chip;
> +	bool probe_now;
>   	int err;
>
>   	if (dev >= SNDRV_CARDS)
> @@ -3182,18 +3212,22 @@ static int __devinit azx_probe(struct pci_dev *pci,
>   	if (err < 0)
>   		goto out_free;
>   	card->private_data = chip;
> +	probe_now = !chip->disabled;
>
>   #ifdef CONFIG_SND_HDA_PATCH_LOADER
>   	if (patch[dev] && *patch[dev]) {
>   		snd_printk(KERN_ERR SFX "Applying patch firmware '%s'\n",
>   			   patch[dev]);
> -		err = request_firmware(&chip->fw, patch[dev], &pci->dev);
> +		err = request_firmware_nowait(THIS_MODULE, true, patch[dev],
> +					      &pci->dev, GFP_KERNEL, card,
> +					      azx_firmware_cb);
>   		if (err < 0)
>   			goto out_free;
> +		probe_now = false; /* continued in azx_firmware_cb() */
>   	}
>   #endif /* CONFIG_SND_HDA_PATCH_LOADER */
>
> -	if (!chip->disabled) {
> +	if (probe_now) {
>   		err = azx_probe_continue(chip);
>   		if (err < 0)
>   			goto out_free;
>



-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
