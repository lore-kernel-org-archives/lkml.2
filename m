Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1JSIKP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 04:10:15 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:47017 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751464Ab1JSIKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 04:10:13 -0400
MIME-Version: 1.0
In-Reply-To: <1318993587.7128.7.camel@phoenix>
References: <1318993587.7128.7.camel@phoenix>
Date: Wed, 19 Oct 2011 09:10:10 +0100
Message-ID: <CABS+qY1F8Jt5gbPtr5M66MPtALgjKMyNHQUk9vN_4=-ddnsxUA@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] ASoC: wm9081: Use snd_soc_update_bits for read-modify-write
From: "Girdwood, Liam" <lrg@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9J8AQ8h012961

On 19 October 2011 04:06, Axel Lin <axel.lin@gmail.com> wrote:
> Use snd_soc_update_bits for read-modify-write register access instead of
> open-coding it using snd_soc_read and snd_soc_write
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> RESEND:
> I just found I doesn't set my mail client properly to show correct sender,
> so here is a resend.
>
> v2:
> For Initial cold start ( change bias level from SND_SOC_BIAS_OFF to
> SND_SOC_BIAS_STANDBY ), the v1 does not set VMID_SEL[1:0] bits
> correctly for Normal bias enable & soft start off.
> In v2 we also clear VMID_SEL[1:0] bits for Normal bias enable & soft start off.
> We did clear VMID_SEL[1:0] bits in SND_SOC_BIAS_OFF,
> thus we know the VMID_SEL[1:0] bits status is 0b00 in this case.
>

The mechanics look OK, but best for Mark to check with the hardware.

Acked-by: Liam Girdwood <lrg@ti.com>

>  sound/soc/codecs/wm9081.c |   82 +++++++++++++++++++-------------------------
>  1 files changed, 35 insertions(+), 47 deletions(-)
>
> diff --git a/sound/soc/codecs/wm9081.c b/sound/soc/codecs/wm9081.c
> index 66092ef..9c38ddb 100644
> --- a/sound/soc/codecs/wm9081.c
> +++ b/sound/soc/codecs/wm9081.c
> @@ -766,84 +766,73 @@ static const struct snd_soc_dapm_route wm9081_audio_paths[] = {
>  static int wm9081_set_bias_level(struct snd_soc_codec *codec,
>                                 enum snd_soc_bias_level level)
>  {
> -       u16 reg;
> -
>        switch (level) {
>        case SND_SOC_BIAS_ON:
>                break;
>
>        case SND_SOC_BIAS_PREPARE:
>                /* VMID=2*40k */
> -               reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
> -               reg &= ~WM9081_VMID_SEL_MASK;
> -               reg |= 0x2;
> -               snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +               snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +                                   WM9081_VMID_SEL_MASK, 0x2);
>
>                /* Normal bias current */
> -               reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
> -               reg &= ~WM9081_STBY_BIAS_ENA;
> -               snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
> +               snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
> +                                   WM9081_STBY_BIAS_ENA, 0);
>                break;
>
>        case SND_SOC_BIAS_STANDBY:
>                /* Initial cold start */
>                if (codec->dapm.bias_level == SND_SOC_BIAS_OFF) {
>                        /* Disable LINEOUT discharge */
> -                       reg = snd_soc_read(codec, WM9081_ANTI_POP_CONTROL);
> -                       reg &= ~WM9081_LINEOUT_DISCH;
> -                       snd_soc_write(codec, WM9081_ANTI_POP_CONTROL, reg);
> +                       snd_soc_update_bits(codec, WM9081_ANTI_POP_CONTROL,
> +                                           WM9081_LINEOUT_DISCH, 0);
>
>                        /* Select startup bias source */
> -                       reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
> -                       reg |= WM9081_BIAS_SRC | WM9081_BIAS_ENA;
> -                       snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
> +                       snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
> +                                           WM9081_BIAS_SRC | WM9081_BIAS_ENA,
> +                                           WM9081_BIAS_SRC | WM9081_BIAS_ENA);
>
>                        /* VMID 2*4k; Soft VMID ramp enable */
> -                       reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
> -                       reg |= WM9081_VMID_RAMP | 0x6;
> -                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> -
> +                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +                                           WM9081_VMID_RAMP | 0x6,
> +                                           WM9081_VMID_RAMP | 0x6);
>                        mdelay(100);
>
>                        /* Normal bias enable & soft start off */
> -                       reg |= WM9081_BIAS_ENA;
> -                       reg &= ~WM9081_VMID_RAMP;
> -                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +                                           WM9081_VMID_RAMP | WM9081_BIAS_ENA |
> +                                           WM9081_VMID_SEL_MASK,
> +                                           WM9081_BIAS_ENA);
>
>                        /* Standard bias source */
> -                       reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
> -                       reg &= ~WM9081_BIAS_SRC;
> -                       snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
> +                       snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
> +                                           WM9081_BIAS_SRC, 0);
>                }
>
>                /* VMID 2*240k */
> -               reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
> -               reg &= ~WM9081_VMID_SEL_MASK;
> -               reg |= 0x04;
> -               snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +               snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
> +                                   WM9081_VMID_SEL_MASK, 0x04);
>
>                /* Standby bias current on */
> -               reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
> -               reg |= WM9081_STBY_BIAS_ENA;
> -               snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
> +               snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
> +                                   WM9081_STBY_BIAS_ENA,
> +                                   WM9081_STBY_BIAS_ENA);
>                break;
>
>        case SND_SOC_BIAS_OFF:
>                /* Startup bias source */
> -               reg = snd_soc_read(codec, WM9081_BIAS_CONTROL_1);
> -               reg |= WM9081_BIAS_SRC;
> -               snd_soc_write(codec, WM9081_BIAS_CONTROL_1, reg);
> +               snd_soc_update_bits(codec, WM9081_BIAS_CONTROL_1,
> +                                   WM9081_BIAS_SRC, WM9081_BIAS_SRC);
>
>                /* Disable VMID and biases with soft ramping */
> -               reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
> -               reg &= ~(WM9081_VMID_SEL_MASK | WM9081_BIAS_ENA);
> -               reg |= WM9081_VMID_RAMP;
> -               snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +               snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +                                   WM9081_VMID_RAMP | WM9081_VMID_SEL_MASK |
> +                                   WM9081_BIAS_ENA, WM9081_VMID_RAMP);
>
>                /* Actively discharge LINEOUT */
> -               reg = snd_soc_read(codec, WM9081_ANTI_POP_CONTROL);
> -               reg |= WM9081_LINEOUT_DISCH;
> -               snd_soc_write(codec, WM9081_ANTI_POP_CONTROL, reg);
> +               snd_soc_update_bits(codec, WM9081_ANTI_POP_CONTROL,
> +                                   WM9081_LINEOUT_DISCH,
> +                                   WM9081_LINEOUT_DISCH);
>                break;
>        }
>
> @@ -1242,11 +1231,10 @@ static int wm9081_probe(struct snd_soc_codec *codec)
>        wm9081_set_bias_level(codec, SND_SOC_BIAS_STANDBY);
>
>        /* Enable zero cross by default */
> -       reg = snd_soc_read(codec, WM9081_ANALOGUE_LINEOUT);
> -       snd_soc_write(codec, WM9081_ANALOGUE_LINEOUT, reg | WM9081_LINEOUTZC);
> -       reg = snd_soc_read(codec, WM9081_ANALOGUE_SPEAKER_PGA);
> -       snd_soc_write(codec, WM9081_ANALOGUE_SPEAKER_PGA,
> -                    reg | WM9081_SPKPGAZC);
> +       snd_soc_update_bits(codec, WM9081_ANALOGUE_LINEOUT,
> +                           WM9081_LINEOUTZC, WM9081_LINEOUTZC);
> +       snd_soc_update_bits(codec, WM9081_ANALOGUE_SPEAKER_PGA,
> +                           WM9081_SPKPGAZC, WM9081_SPKPGAZC);
>
>        snd_soc_add_controls(codec, wm9081_snd_controls,
>                             ARRAY_SIZE(wm9081_snd_controls));
> --
> 1.7.5.4
>
>
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
