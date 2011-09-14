Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1INHKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 03:10:08 -0400
Received: from mail-vw0-f42.google.com ([209.85.212.42]:53390 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1INHKH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 03:10:07 -0400
X-Greylist: delayed 416 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 03:10:07 EDT
MIME-Version: 1.0
In-Reply-To: <s5hmxe8vntc.wl%tiwai@suse.de>
References: <CAC9WiBjoO50H5ZQEShbdZ=64ZXz6Q-OdD+VSD-YrBry3hvdJJQ@mail.gmail.com>
	<s5haaaa865l.wl%tiwai@suse.de>
	<CAC9WiBjDfTnNG+5HxEgLm-PLa=RMQu47L3Pa-oN_0sQ3rs4ssA@mail.gmail.com>
	<CAC9WiBhng3Aa9N+GM-ND100jqb+x22wAp+c9rTDEJ2riKtNZ7w@mail.gmail.com>
	<s5hmxe8vntc.wl%tiwai@suse.de>
Date: Wed, 14 Sep 2011 09:03:10 +0200
Message-ID: <CAC9WiBivf2HCVAe-d9ah+mpA50pwjH8ga6w5O4rAq9U2CTa8HA@mail.gmail.com>
Subject: Re: 3.1-rc5 is the worst
From: Francis Moreau <francis.moro@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Sep 13, 2011 at 10:39 AM, Takashi Iwai <tiwai@suse.de> wrote:
>
> The patch below should fix the problem.  Give it a try.
>

Yes it does, thanks !

>
> ---
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: hda - Terminate the recursive connection search properly
>
> The recursive search of widget connections in snd_hda_get_conn_index()
> must be terminated at the pin and the audio-out widgets.  Otherwise
> you'll get "too deep connection" warnings unnecessarily.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/hda_codec.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
> index 3e7850c..f3aefef 100644
> --- a/sound/pci/hda/hda_codec.c
> +++ b/sound/pci/hda/hda_codec.c
> @@ -579,9 +579,13 @@ int snd_hda_get_conn_index(struct hda_codec *codec, hda_nid_t mux,
>                return -1;
>        }
>        recursive++;
> -       for (i = 0; i < nums; i++)
> +       for (i = 0; i < nums; i++) {
> +               unsigned int type = get_wcaps_type(get_wcaps(codec, conn[i]));
> +               if (type == AC_WID_PIN || type == AC_WID_AUD_OUT)
> +                       continue;
>                if (snd_hda_get_conn_index(codec, conn[i], nid, recursive) >= 0)
>                        return i;
> +       }
>        return -1;
>  }
>  EXPORT_SYMBOL_HDA(snd_hda_get_conn_index);
> --
> 1.7.6.1
>
>



-- 
Francis
