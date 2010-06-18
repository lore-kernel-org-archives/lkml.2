Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245Ab0FRK33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 06:29:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52933 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759218Ab0FRK31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 06:29:27 -0400
Subject: Re: [PATCH] ASoC: Fix overflow bug in SOC_DOUBLE_R_SX_TLV
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Stuart Longland <redhatter@gentoo.org>
Cc: ALSA Development List <alsa-devel@alsa-project.org>,
       Takashi Iwai <tiwai@suse.de>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1276829770-31557-1-git-send-email-redhatter@gentoo.org>
References: <20100618023810.GS7759@www.longlandclan.yi.org>
	 <1276829770-31557-1-git-send-email-redhatter@gentoo.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Jun 2010 11:29:24 +0100
Message-ID: <1276856964.3054.1.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-18 at 12:56 +1000, Stuart Longland wrote:
> When SX_TLV widgets are read, if the gain is set to a value below 0dB,
> the mixer control is erroniously read as being at maximum volume.
> 
> The value read out of the CODEC register is never sign-extended, and
> when the minimum value is subtracted (read; added, since the minimum is
> negative) the result is a number greater than the maximum allowed value
> for the control, and hence it saturates.
> 
> Solution: Mask the result so that it "wraps around", emulating
> sign-extension.
> 
> Signed-off-by: Stuart Longland <redhatter@gentoo.org>
> ---
>  sound/soc/soc-core.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
> index a82a797..0470288 100644
> --- a/sound/soc/soc-core.c
> +++ b/sound/soc/soc-core.c
> @@ -2400,8 +2400,8 @@ int snd_soc_get_volsw_2r_sx(struct snd_kcontrol *kcontrol,
>  	int val = snd_soc_read(codec, mc->reg) & mask;
>  	int valr = snd_soc_read(codec, mc->rreg) & mask;
>  
> -	ucontrol->value.integer.value[0] = ((val & 0xff)-min);
> -	ucontrol->value.integer.value[1] = ((valr & 0xff)-min);
> +	ucontrol->value.integer.value[0] = ((val & 0xff)-min) & mask;
> +	ucontrol->value.integer.value[1] = ((valr & 0xff)-min) & mask;
>  	return 0;
>  }
>  EXPORT_SYMBOL_GPL(snd_soc_get_volsw_2r_sx);

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

