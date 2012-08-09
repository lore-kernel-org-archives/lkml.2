Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2HIN0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:26:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38322 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229Ab2HIN0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:26:54 -0400
Message-ID: <5023BAA0.1080304@canonical.com>
Date: Thu, 09 Aug 2012 15:26:56 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Thierry Reding <thierry.reding@avionic-design.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ALSA: hda - Deferred probing with request_firmware_nowait()
References: <1344494723-6827-1-git-send-email-thierry.reding@avionic-design.de> <s5hhascft86.wl%tiwai@suse.de> <20120809070813.GA6979@avionic-0098.mockup.avionic-design.de> <s5hd330frn1.wl%tiwai@suse.de> <20120809073642.GA24695@avionic-0098.mockup.avionic-design.de> <s5h7gt8fr47.wl%tiwai@suse.de> <20120809080713.GC24808@avionic-0098.mockup.avionic-design.de> <s5hzk64earo.wl%tiwai@suse.de> <20120809103430.GA1560@avionic-0098.mockup.avionic-design.de> <s5hobmk2ql5.wl%tiwai@suse.de> <s5hd3302ovw.wl%tiwai@suse.de> <s5ha9y42os2.wl%tiwai@suse.de>
In-Reply-To: <s5ha9y42os2.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 03:11 PM, Takashi Iwai wrote:

> @@ -3187,13 +3217,16 @@ static int __devinit azx_probe(struct pci_dev *pci,
>   	if (patch[dev] && *patch[dev]) {
>   		snd_printk(KERN_ERR SFX "Applying patch firmware '%s'\n",
>   			   patch[dev]);
> -		err = request_firmware(&chip->fw, patch[dev], &pci->dev);
> +		err = request_firmware_nowait(THIS_MODULE, true, patch[dev],
> +					      &pci->dev, GFP_KERNEL, card,
> +					      azx_firmware_cb);
>   		if (err < 0)
>   			goto out_free;
> +		chip->probe_deferred = 1;

I might be out on deep water here, but isn't this racy? Or is 
azx_firmware_cb somehow guaranteed not to execute before this function 
has exited?

>   	}
>   #endif /* CONFIG_SND_HDA_PATCH_LOADER */
>
> -	if (!chip->disabled) {
> +	if (!chip->disabled && !chip->probe_deferred) {
>   		err = azx_probe_continue(chip);
>   		if (err < 0)
>   			goto out_free;
>



-- 
David Henningsson, Canonical Ltd.
https://launchpad.net/~diwic
