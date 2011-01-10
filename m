Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1AJSCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 13:02:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38919 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab1AJSCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 13:02:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fQ+cW0qakJDIwVuwyy7PuXNh0LQwU0gWRCiPeoJ1DyyDUU2AIug6YG2S3Obs7L34mA
         B0nCuekPlXODURTsEImsBIS5M7FKVzGyqcQjtamK8pIB3Cl8BkrmX+oZVqbQgPa8s0L6
         D2JMF+qpwOvIk2KlNVIAKpgnVtl7WpQFr4vhc=
MIME-Version: 1.0
In-Reply-To: <s5hd3o4ddb4.wl%tiwai@suse.de>
References: <AANLkTi=Fza-mJyAKtsryAUMMgPoXur4oQ6F2keBmxF6B@mail.gmail.com>
 <s5hhbdgdfu6.wl%tiwai@suse.de> <s5hd3o4ddb4.wl%tiwai@suse.de>
From: Nirbheek Chauhan <nirbheek.chauhan@gmail.com>
Date: Mon, 10 Jan 2011 23:31:19 +0530
Message-ID: <AANLkTik6qSuPdZJ2Ziq-GUHuXfKOBO8154Uv1NsQK=Zc@mail.gmail.com>
Subject: Re: [bisected] snd_hda_intel, 2.6.37: automuting on headphone connect
 broken; headphone connecter no longer shown in userspace
To: Takashi Iwai <tiwai@suse.de>
Cc: Jaroslav Kysela <perex@perex.cz>, Kailang Yang <kailang@realtek.com>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        arun@accosted.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0AI2im6014740

On Mon, Jan 10, 2011 at 8:19 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Mon, 10 Jan 2011 14:54:25 +0100,
> Takashi Iwai wrote:
>>
>> At Wed, 5 Jan 2011 13:07:41 +0530,
>> Nirbheek Chauhan wrote:
>> >
>> > Hello,
>> >
>> > Upon upgrading to 2.6.37,
>> > auto-muting-laptop-speakers-on-headphone-connect stopped working, and
>> > the headphone connector completely disappeared from alsamixer as well
>> > as the pulseaudio volume control panel. The headphone jack was still
>> > transmitting sound, though.
>> >
>> > I bisected the problem, with 'good' being v2.6.36, and found the
>> > commit below as the first bad commit. Reverting it on v2.6.37 fixes
>> > the problem. I also tried the latest alsa-kernel master git tree,
>> > which had the same problem.
>> >
>> > alsa-info when 'good':
>> >
>> > http://www.alsa-project.org/db/?f=a0b5c95f764a0b01746be46f989685996e1f9210
>> >
>> > alsa-info when 'bad':
>> >
>> > http://www.alsa-project.org/db/?f=30f30ca5461f03b98ab6c7c611cf24ea4526f537
>> >
>> > Note: both were taken without X running, before pulseaudio came up.
>> >
>> > ================
>> > 03642c9a444079aa13f0864383a8f9ca04bfd198 is the first bad commit
>> > commit 03642c9a444079aa13f0864383a8f9ca04bfd198
>> > Author: Takashi Iwai <tiwai@suse.de>
>> > Date:   Wed Sep 8 15:28:19 2010 +0200
>> >
>> >     ALSA: hda - Clear left-over hp_pins in snd_hda_parse_pin_def_config()
>> >
>> >     In snd_hda_parse_def_config(), some unused values may remain in hp_pins[]
>> >     array during the headphone-reassignment workaround.  This patch clears
>> >     the unused array members.
>> >
>> >     Signed-off-by: Takashi Iwai <tiwai@suse.de>
>> >
>> > :040000 040000 34724336a75f74263423f28d64450d65e5ed948d
>> > 8d136fce8661ad2df35ac3c4a9ca1c712c9833ed M  sound
>> >
>> > ================
>>
>> It seems that the driver worked casually in the earlier versions :)
>> Does the patch below fix your problem?
>>
>> Note that the "Headphone" control will still not appear even with this
>> patch, but these two outputs are controlled by "Front" and "Surround"
>> controls.  The lack of "Headphone" is no regression but simply it
>> shouldn't have been there.
>>
>> I'll work on 2.6.38 tree for better handling of multi headphone
>> cases.
>
> The patch is below.  Give it a try.
>

This patch made the jacks and their alsamixer controls function
exactly as I expected them to!

(I have to admit, at first I applied only this patch without the
previous one, and that made things really weird. I had fully
documented the weirdness before I realised that the first patch might
not have been *just* for stable)

alsamixer layout:
[Master] [Headphone] [Headphone 1] [Speaker] [PCM] [Mic 1] [Mic Boost 1]

alsa-info:
http://www.alsa-project.org/db/?f=34790490c2d70f019b14b22f8e94289425b1bcd6

* `Speaker` is only toggle-mute
* `PCM` has no toggle-mute
* `Master` affects audio in all outputs
* Inserting a jack into either headphone socket mutes the laptop speakers
* `Headphone` and `Headphone 1` control their respective headphones
(maybe they should be named Headphone 1, Headphone 2?)
* `Speaker` mutes the laptop speakers
* `PCM` affects audio in all outputs

All this is without pulseaudio running. Pulseaudio doesn't seem to be
able to handle multiple headphones nicely, and I can't control which
connector an audio stream goes to at all (not a regression, I would
note). But I guess this one is for the PA devs :-)

I'll be using both these patches, and will report any bugs I find.

Thanks a lot!

>
> Takashi
>
> ===
> From bcb2f0f517ebae7350526bbde8912ad187147e2d Mon Sep 17 00:00:00 2001
> From: Takashi Iwai <tiwai@suse.de>
> Date: Mon, 10 Jan 2011 15:45:23 +0100
> Subject: [PATCH] ALSA: hda - Add support for multiple headphone/speaker controls for Realtek
>
> So far, Realtek auto-parser assumed that the multiple pins are only for
> line-outs, and assigned the channel names like Front, Surround, etc for
> the multiple outputs.  But, there are devices that have multiple
> headphones, and these can be better controlled with the corresponding
> control-name like "Headphone" with indicies.
>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/pci/hda/patch_realtek.c |  137 ++++++++++++++++++++---------------------
>  1 files changed, 68 insertions(+), 69 deletions(-)
>
> diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
> index b4f7895..0ecd75e 100644
> --- a/sound/pci/hda/patch_realtek.c
> +++ b/sound/pci/hda/patch_realtek.c
> @@ -5068,6 +5068,25 @@ static int alc880_auto_fill_dac_nids(struct alc_spec *spec,
>        return 0;
>  }
>
> +static const char *alc_get_line_out_pfx(const struct auto_pin_cfg *cfg,
> +                                       bool can_be_master)
> +{
> +       if (!cfg->hp_outs && !cfg->speaker_outs && can_be_master)
> +               return "Master";
> +
> +       switch (cfg->line_out_type) {
> +       case AUTO_PIN_SPEAKER_OUT:
> +               return "Speaker";
> +       case AUTO_PIN_HP_OUT:
> +               return "Headphone";
> +       default:
> +               if (cfg->line_outs == 1)
> +                       return "PCM";
> +               break;
> +       }
> +       return NULL;
> +}
> +
>  /* add playback controls from the parsed DAC table */
>  static int alc880_auto_create_multi_out_ctls(struct alc_spec *spec,
>                                             const struct auto_pin_cfg *cfg)
> @@ -5075,6 +5094,7 @@ static int alc880_auto_create_multi_out_ctls(struct alc_spec *spec,
>        static const char *chname[4] = {
>                "Front", "Surround", NULL /*CLFE*/, "Side"
>        };
> +       const char *pfx = alc_get_line_out_pfx(cfg, false);
>        hda_nid_t nid;
>        int i, err;
>
> @@ -5082,7 +5102,7 @@ static int alc880_auto_create_multi_out_ctls(struct alc_spec *spec,
>                if (!spec->multiout.dac_nids[i])
>                        continue;
>                nid = alc880_idx_to_mixer(alc880_dac_to_idx(spec->multiout.dac_nids[i]));
> -               if (i == 2) {
> +               if (!pfx && i == 2) {
>                        /* Center/LFE */
>                        err = add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL,
>                                              "Center",
> @@ -5109,18 +5129,17 @@ static int alc880_auto_create_multi_out_ctls(struct alc_spec *spec,
>                        if (err < 0)
>                                return err;
>                } else {
> -                       const char *pfx;
> -                       if (cfg->line_outs == 1 &&
> -                           cfg->line_out_type == AUTO_PIN_SPEAKER_OUT)
> -                               pfx = "Speaker";
> -                       else
> -                               pfx = chname[i];
> -                       err = add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL, pfx,
> +                       const char *name = pfx;
> +                       if (!name)
> +                               name = chname[i];
> +                       err = __add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL,
> +                                               name, i,
>                                          HDA_COMPOSE_AMP_VAL(nid, 3, 0,
>                                                              HDA_OUTPUT));
>                        if (err < 0)
>                                return err;
> -                       err = add_pb_sw_ctrl(spec, ALC_CTL_BIND_MUTE, pfx,
> +                       err = __add_pb_sw_ctrl(spec, ALC_CTL_BIND_MUTE,
> +                                              name, i,
>                                          HDA_COMPOSE_AMP_VAL(nid, 3, 2,
>                                                              HDA_INPUT));
>                        if (err < 0)
> @@ -12085,13 +12104,8 @@ static int alc262_auto_create_multi_out_ctls(struct alc_spec *spec,
>        spec->multiout.dac_nids = spec->private_dac_nids;
>        spec->multiout.dac_nids[0] = 2;
>
> -       if (!cfg->speaker_pins[0] && !cfg->hp_pins[0])
> -               pfx = "Master";
> -       else if (cfg->line_out_type == AUTO_PIN_SPEAKER_OUT)
> -               pfx = "Speaker";
> -       else if (cfg->line_out_type == AUTO_PIN_HP_OUT)
> -               pfx = "Headphone";
> -       else
> +       pfx = alc_get_line_out_pfx(cfg, true);
> +       if (!pfx)
>                pfx = "Front";
>        for (i = 0; i < 2; i++) {
>                err = alc262_add_out_sw_ctl(spec, cfg->line_out_pins[i], pfx, i);
> @@ -15885,13 +15899,16 @@ static int alc861_auto_fill_dac_nids(struct hda_codec *codec,
>        return 0;
>  }
>
> -static int alc861_create_out_sw(struct hda_codec *codec, const char *pfx,
> -                               hda_nid_t nid, unsigned int chs)
> +static int __alc861_create_out_sw(struct hda_codec *codec, const char *pfx,
> +                                 hda_nid_t nid, int idx, unsigned int chs)
>  {
> -       return add_pb_sw_ctrl(codec->spec, ALC_CTL_WIDGET_MUTE, pfx,
> +       return __add_pb_sw_ctrl(codec->spec, ALC_CTL_WIDGET_MUTE, pfx, idx,
>                           HDA_COMPOSE_AMP_VAL(nid, chs, 0, HDA_OUTPUT));
>  }
>
> +#define alc861_create_out_sw(codec, pfx, nid, chs) \
> +       __alc861_create_out_sw(codec, pfx, nid, 0, chs)
> +
>  /* add playback controls from the parsed DAC table */
>  static int alc861_auto_create_multi_out_ctls(struct hda_codec *codec,
>                                             const struct auto_pin_cfg *cfg)
> @@ -15900,26 +15917,15 @@ static int alc861_auto_create_multi_out_ctls(struct hda_codec *codec,
>        static const char *chname[4] = {
>                "Front", "Surround", NULL /*CLFE*/, "Side"
>        };
> +       const char *pfx = alc_get_line_out_pfx(cfg, true);
>        hda_nid_t nid;
>        int i, err;
>
> -       if (cfg->line_outs == 1) {
> -               const char *pfx = NULL;
> -               if (!cfg->hp_outs)
> -                       pfx = "Master";
> -               else if (cfg->line_out_type == AUTO_PIN_SPEAKER_OUT)
> -                       pfx = "Speaker";
> -               if (pfx) {
> -                       nid = spec->multiout.dac_nids[0];
> -                       return alc861_create_out_sw(codec, pfx, nid, 3);
> -               }
> -       }
> -
>        for (i = 0; i < cfg->line_outs; i++) {
>                nid = spec->multiout.dac_nids[i];
>                if (!nid)
>                        continue;
> -               if (i == 2) {
> +               if (!pfx && i == 2) {
>                        /* Center/LFE */
>                        err = alc861_create_out_sw(codec, "Center", nid, 1);
>                        if (err < 0)
> @@ -15928,7 +15934,10 @@ static int alc861_auto_create_multi_out_ctls(struct hda_codec *codec,
>                        if (err < 0)
>                                return err;
>                } else {
> -                       err = alc861_create_out_sw(codec, chname[i], nid, 3);
> +                       const char *name = pfx;
> +                       if (!name)
> +                               name = chname[i];
> +                       err = __alc861_create_out_sw(codec, name, nid, i, 3);
>                        if (err < 0)
>                                return err;
>                }
> @@ -17033,6 +17042,7 @@ static int alc861vd_auto_create_multi_out_ctls(struct alc_spec *spec,
>                                             const struct auto_pin_cfg *cfg)
>  {
>        static const char *chname[4] = {"Front", "Surround", "CLFE", "Side"};
> +       const char *pfx = alc_get_line_out_pfx(cfg, true);
>        hda_nid_t nid_v, nid_s;
>        int i, err;
>
> @@ -17046,7 +17056,7 @@ static int alc861vd_auto_create_multi_out_ctls(struct alc_spec *spec,
>                                alc880_dac_to_idx(
>                                        spec->multiout.dac_nids[i]));
>
> -               if (i == 2) {
> +               if (!pfx && i == 2) {
>                        /* Center/LFE */
>                        err = add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL,
>                                              "Center",
> @@ -17073,24 +17083,17 @@ static int alc861vd_auto_create_multi_out_ctls(struct alc_spec *spec,
>                        if (err < 0)
>                                return err;
>                } else {
> -                       const char *pfx;
> -                       if (cfg->line_outs == 1 &&
> -                           cfg->line_out_type == AUTO_PIN_SPEAKER_OUT) {
> -                               if (!cfg->hp_pins)
> -                                       pfx = "Speaker";
> -                               else
> -                                       pfx = "PCM";
> -                       } else
> -                               pfx = chname[i];
> -                       err = add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL, pfx,
> +                       const char *name = pfx;
> +                       if (!name)
> +                               name = chname[i];
> +                       err = __add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL,
> +                                               name, i,
>                                          HDA_COMPOSE_AMP_VAL(nid_v, 3, 0,
>                                                              HDA_OUTPUT));
>                        if (err < 0)
>                                return err;
> -                       if (cfg->line_outs == 1 &&
> -                           cfg->line_out_type == AUTO_PIN_SPEAKER_OUT)
> -                               pfx = "Speaker";
> -                       err = add_pb_sw_ctrl(spec, ALC_CTL_BIND_MUTE, pfx,
> +                       err = __add_pb_sw_ctrl(spec, ALC_CTL_BIND_MUTE,
> +                                              name, i,
>                                          HDA_COMPOSE_AMP_VAL(nid_s, 3, 2,
>                                                              HDA_INPUT));
>                        if (err < 0)
> @@ -19078,20 +19081,24 @@ static int alc662_auto_fill_dac_nids(struct hda_codec *codec,
>        return 0;
>  }
>
> -static inline int alc662_add_vol_ctl(struct alc_spec *spec, const char *pfx,
> -                             hda_nid_t nid, unsigned int chs)
> +static inline int __alc662_add_vol_ctl(struct alc_spec *spec, const char *pfx,
> +                                      hda_nid_t nid, int idx, unsigned int chs)
>  {
> -       return add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL, pfx,
> +       return __add_pb_vol_ctrl(spec, ALC_CTL_WIDGET_VOL, pfx, idx,
>                           HDA_COMPOSE_AMP_VAL(nid, chs, 0, HDA_OUTPUT));
>  }
>
> -static inline int alc662_add_sw_ctl(struct alc_spec *spec, const char *pfx,
> -                            hda_nid_t nid, unsigned int chs)
> +static inline int __alc662_add_sw_ctl(struct alc_spec *spec, const char *pfx,
> +                                     hda_nid_t nid, int idx, unsigned int chs)
>  {
> -       return add_pb_sw_ctrl(spec, ALC_CTL_WIDGET_MUTE, pfx,
> +       return __add_pb_sw_ctrl(spec, ALC_CTL_WIDGET_MUTE, pfx, idx,
>                           HDA_COMPOSE_AMP_VAL(nid, chs, 0, HDA_INPUT));
>  }
>
> +#define alc662_add_vol_ctl(spec, pfx, nid, chs) \
> +       __alc662_add_vol_ctl(spec, pfx, nid, 0, chs)
> +#define alc662_add_sw_ctl(spec, pfx, nid, chs) \
> +       __alc662_add_sw_ctl(spec, pfx, nid, 0, chs)
>  #define alc662_add_stereo_vol(spec, pfx, nid) \
>        alc662_add_vol_ctl(spec, pfx, nid, 3)
>  #define alc662_add_stereo_sw(spec, pfx, nid) \
> @@ -19105,6 +19112,7 @@ static int alc662_auto_create_multi_out_ctls(struct hda_codec *codec,
>        static const char *chname[4] = {
>                "Front", "Surround", NULL /*CLFE*/, "Side"
>        };
> +       const char *pfx = alc_get_line_out_pfx(cfg, true);
>        hda_nid_t nid, mix;
>        int i, err;
>
> @@ -19115,7 +19123,7 @@ static int alc662_auto_create_multi_out_ctls(struct hda_codec *codec,
>                mix = alc662_dac_to_mix(codec, cfg->line_out_pins[i], nid);
>                if (!mix)
>                        continue;
> -               if (i == 2) {
> +               if (!pfx && i == 2) {
>                        /* Center/LFE */
>                        err = alc662_add_vol_ctl(spec, "Center", nid, 1);
>                        if (err < 0)
> @@ -19130,22 +19138,13 @@ static int alc662_auto_create_multi_out_ctls(struct hda_codec *codec,
>                        if (err < 0)
>                                return err;
>                } else {
> -                       const char *pfx;
> -                       if (cfg->line_outs == 1 &&
> -                           cfg->line_out_type == AUTO_PIN_SPEAKER_OUT) {
> -                               if (cfg->hp_outs)
> -                                       pfx = "Speaker";
> -                               else
> -                                       pfx = "PCM";
> -                       } else
> -                               pfx = chname[i];
> -                       err = alc662_add_vol_ctl(spec, pfx, nid, 3);
> +                       const char *name = pfx;
> +                       if (!name)
> +                               name = chname[i];
> +                       err = __alc662_add_vol_ctl(spec, name, nid, i, 3);
>                        if (err < 0)
>                                return err;
> -                       if (cfg->line_outs == 1 &&
> -                           cfg->line_out_type == AUTO_PIN_SPEAKER_OUT)
> -                               pfx = "Speaker";
> -                       err = alc662_add_sw_ctl(spec, pfx, mix, 3);
> +                       err = __alc662_add_sw_ctl(spec, name, mix, i, 3);
>                        if (err < 0)
>                                return err;
>                }
> --
> 1.7.3.4
>
>



-- 
~Nirbheek Chauhan

Gentoo GNOME+Mozilla Team
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
