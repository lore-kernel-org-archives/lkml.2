Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab0GKHtK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 03:49:10 -0400
Received: from mail1.perex.cz ([212.20.107.53]:52862 "EHLO mail1.perex.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab0GKHtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 03:49:09 -0400
X-Greylist: delayed 2023 seconds by postgrey-1.27 at vger.kernel.org; Sun, 11 Jul 2010 03:49:08 EDT
Date: Sun, 11 Jul 2010 09:15:22 +0200 (CEST)
From: Jaroslav Kysela <perex@perex.cz>
To: Arnd Bergmann <arnd@arndb.de>
cc: LKML <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       ALSA development <alsa-devel@alsa-project.org>
Subject: Re: [PATCH 3/3] sound: push BKL into open functions
In-Reply-To: <1278798701-11171-4-git-send-email-arnd@arndb.de>
Message-ID: <alpine.LNX.2.00.1007110913120.16744@eeebox2.perex-int.cz>
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <1278798701-11171-4-git-send-email-arnd@arndb.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Jul 2010, Arnd Bergmann wrote:

> --- a/sound/core/hwdep.c
> +++ b/sound/core/hwdep.c
> @@ -94,13 +94,18 @@ static int snd_hwdep_open(struct inode *inode, struct file * file)
> 		hw = snd_lookup_oss_minor_data(iminor(inode),
> 					       SNDRV_OSS_DEVICE_TYPE_DMFM);
> #endif
> -	} else
> -		return -ENXIO;
> +	} else {
> +		err = -ENXIO;
> +		goto out;
> +	}
> +
> +	err = -ENODEV;
> 	if (hw == NULL)
> -		return -ENODEV;
> +		goto out;
>
> +	err = -EFAULT;
> 	if (!try_module_get(hw->card->module))
> -		return -EFAULT;
> +		goto out;
>
> 	init_waitqueue_entry(&wait, current);
> 	add_wait_queue(&hw->open_wait, &wait);
> @@ -147,6 +152,7 @@ static int snd_hwdep_open(struct inode *inode, struct file * file)
> 	mutex_unlock(&hw->open_mutex);
> 	if (err < 0)
> 		module_put(hw->card->module);
> +out:
> 	return err;
> }
>
> diff --git a/sound/core/oss/mixer_oss.c b/sound/core/oss/mixer_oss.c
> index f50ebf2..c30b1f3 100644
> --- a/sound/core/oss/mixer_oss.c
> +++ b/sound/core/oss/mixer_oss.c
> @@ -49,17 +49,19 @@ static int snd_mixer_oss_open(struct inode *inode, struct file *file)
>
> 	card = snd_lookup_oss_minor_data(iminor(inode),
> 					 SNDRV_OSS_DEVICE_TYPE_MIXER);
> -	if (card == NULL)
> -		return -ENODEV;
> -	if (card->mixer_oss == NULL)
> -		return -ENODEV;
> +	err = -ENODEV;
> +	if (card == NULL || card->mixer_oss == NULL)
> +		goto out;
> +
> 	err = snd_card_file_add(card, file);
> 	if (err < 0)
> -		return err;
> +		goto out;
> +
> 	fmixer = kzalloc(sizeof(*fmixer), GFP_KERNEL);
> 	if (fmixer == NULL) {
> 		snd_card_file_remove(card, file);
> -		return -ENOMEM;
> +		err = -ENOMEM;
> +		goto out;
> 	}
> 	fmixer->card = card;
> 	fmixer->mixer = card->mixer_oss;
> @@ -67,9 +69,10 @@ static int snd_mixer_oss_open(struct inode *inode, struct file *file)
> 	if (!try_module_get(card->module)) {
> 		kfree(fmixer);
> 		snd_card_file_remove(card, file);
> -		return -EFAULT;
> +		err = -EFAULT;
> 	}
> -	return 0;
> +out:
> +	return err;
> }
>

I don't see any reason (benefit) to add gotos to these two functions.

 						Jaroslav

-----
Jaroslav Kysela <perex@perex.cz>
Linux Kernel Sound Maintainer
ALSA Project; Red Hat, Inc.
