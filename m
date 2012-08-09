Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964814Ab2HINyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:54:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38482 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2HINyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:54:01 -0400
Message-ID: <5023C0FC.2030207@canonical.com>
Date: Thu, 09 Aug 2012 15:54:04 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] ALSA: hda - Deferred probing with request_firmware_nowait()
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de> <s5hhascft86.wl%tiwai@suse.de> <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de> <s5hd330frn1.wl%tiwai@suse.de> <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de> <s5h7gt8fr47.wl%tiwai@suse.de> <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de> <s5hzk64earo.wl%tiwai@suse.de> <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de> <s5hobmk2ql5.wl%tiwai@suse.de> <s5hd3302ovw.wl%tiwai@suse.de> <s5ha9y42os2.wl%tiwai@suse.de> <5023BAA0.1080304@canonical.com> <s5h4noc2ntn.wl%tiwai@suse.de> <s5h1ujg2nm7.wl%tiwai@suse.de>
In-Reply-To: <s5h1ujg2nm7.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:36 PM, Takashi Iwai wrote:
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

Another thing, aren't you missing a

chip->fw = fw;

here?

> +
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
> +	bool probe_deferred;
>   	int err;
>
>   	if (dev >= SNDRV_CARDS)
> @@ -3182,18 +3211,22 @@ static int __devinit azx_probe(struct pci_dev *pci,
>   	if (err < 0)
>   		goto out_free;
>   	card->private_data = chip;

Right, this patch has the race removed, as the variable is no longer set 
in azx_firmware_cb. To be picky, it's slightly confusing that 
probe_deferred is also used for signalling a disabled chip. Maybe 
"probe_now" (inverted) would have been even better, like this:

> +	probe_deferred = chip->disabled;

probe_now = !chip->disabled;

>
>   #ifdef CONFIG_SND_HDA_PATCH_LOADER
>   	if (patch[dev] && *patch[dev]) {

(maybe we should not ask for firmware for a disabled chip either)

>   		snd_printk(KERN_ERR SFX "Applying patch firmware '%s'\n",
>   			   patch[dev]);
> -		err = request_firmware(&chip->fw, patch[dev], &pci->dev);
> +		err = request_firmware_nowait(THIS_MODULE, true, patch[dev],
> +					      &pci->dev, GFP_KERNEL, card,
> +					      azx_firmware_cb);
>   		if (err < 0)
>   			goto out_free;
> +		probe_deferred = true;

probe_now = false;

>   	}
>   #endif /* CONFIG_SND_HDA_PATCH_LOADER */
>
> -	if (!chip->disabled) {
> +	if (!probe_deferred) {

if (probe_now) {

>   		err = azx_probe_continue(chip);
>   		if (err < 0)
>   			goto out_free;
>

-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
