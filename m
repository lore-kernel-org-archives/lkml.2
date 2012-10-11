Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab2JKHei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 03:34:38 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40605 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754552Ab2JKHeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 03:34:36 -0400
MIME-Version: 1.0
In-Reply-To: <s5hy5jhjrty.wl%tiwai@suse.de>
References: <1349443512-18340-1-git-send-email-chenhc@lemote.com>
	<1349443512-18340-13-git-send-email-chenhc@lemote.com>
	<s5hy5jhjrty.wl%tiwai@suse.de>
Date: Thu, 11 Oct 2012 15:34:34 +0800
X-Google-Sender-Auth: Kl_CXQ4JjzoBdhxivTZEJlEiQ9g
Message-ID: <CAAhV-H4Mt+5uxAL870FdLTJenjCdg2_9fEzs4X3w6XW+dkq6Ng@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH V7 12/15] ALSA: HDA: Make hda sound card
 usable for Loongson
From: Huacai Chen <chenhc@lemote.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-mips@linux-mips.org, alsa-devel@alsa-project.org,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hua Yan <yanh@lemote.com>,
        Jie Chen <chenj@lemote.com>, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>, Fuxin Zhang <zhangfx@lemote.com>,
        Hongliang Tao <taohl@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 4:22 PM, Takashi Iwai <tiwai@suse.de> wrote:
> At Fri,  5 Oct 2012 21:25:09 +0800,
> Huacai Chen wrote:
>>
>> Lemote A1004(Laptop) and A1205(All-In-One) use Conexant's hda codec,
>> this patch modify patch_conexant.c to add Lemote specific code.
>>
>> Both A1004 and A1205 use the same pin configurations, but A1004 need
>> to increase the default boost of internal mic.
>>
>> Signed-off-by: Jie Chen <chenj@lemote.com>
>> Signed-off-by: Huacai Chen <chenhc@lemote.com>
>> Signed-off-by: Hongliang Tao <taohl@lemote.com>
>> Signed-off-by: Hua Yan <yanh@lemote.com>
>> Cc: alsa-devel@alsa-project.org
>
> Looks good to me.
>
> Is this intended to be taken into 3.7 kernel?  Or it's a 3.8 kernel
> material?
>
> In anyway, the patch isn't intrusive and just fixups, so I can merge
> this in sound git tree at any time.
Please merge this patch in alsa tree first, since other patches of
this series need some more time to go mips tree, I don't want you to
be disturbed again and again.
Thanks.

>
>
> thanks,
>
> Takashi
>
>> ---
>>  sound/pci/hda/patch_conexant.c |   44 ++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 44 insertions(+), 0 deletions(-)
>>
>> diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
>> index 5e22a8f..3cc265e 100644
>> --- a/sound/pci/hda/patch_conexant.c
>> +++ b/sound/pci/hda/patch_conexant.c
>> @@ -4408,7 +4408,10 @@ static const struct hda_codec_ops cx_auto_patch_ops = {
>>  enum {
>>       CXT_PINCFG_LENOVO_X200,
>>       CXT_PINCFG_LENOVO_TP410,
>> +     CXT_PINCFG_LEMOTE_A1004,
>> +     CXT_PINCFG_LEMOTE_A1205,
>>       CXT_FIXUP_STEREO_DMIC,
>> +     CXT_FIXUP_INC_MIC_BOOST,
>>  };
>>
>>  static void cxt_fixup_stereo_dmic(struct hda_codec *codec,
>> @@ -4418,6 +4421,19 @@ static void cxt_fixup_stereo_dmic(struct hda_codec *codec,
>>       spec->fixup_stereo_dmic = 1;
>>  }
>>
>> +static void cxt5066_increase_mic_boost(struct hda_codec *codec,
>> +                                const struct hda_fixup *fix, int action)
>> +{
>> +     if (action != HDA_FIXUP_ACT_PRE_PROBE)
>> +             return;
>> +
>> +     snd_hda_override_amp_caps(codec, 0x17, HDA_OUTPUT,
>> +                               (0x3 << AC_AMPCAP_OFFSET_SHIFT) |
>> +                               (0x4 << AC_AMPCAP_NUM_STEPS_SHIFT) |
>> +                               (0x27 << AC_AMPCAP_STEP_SIZE_SHIFT) |
>> +                               (0 << AC_AMPCAP_MUTE_SHIFT));
>> +}
>> +
>>  /* ThinkPad X200 & co with cxt5051 */
>>  static const struct hda_pintbl cxt_pincfg_lenovo_x200[] = {
>>       { 0x16, 0x042140ff }, /* HP (seq# overridden) */
>> @@ -4435,6 +4451,18 @@ static const struct hda_pintbl cxt_pincfg_lenovo_tp410[] = {
>>       {}
>>  };
>>
>> +/* Lemote A1004/A1205 with cxt5066 */
>> +static const struct hda_pintbl cxt_pincfg_lemote[] = {
>> +     { 0x1a, 0x90a10020 }, /* Internal mic */
>> +     { 0x1b, 0x03a11020 }, /* External mic */
>> +     { 0x1d, 0x400101f0 }, /* Not used */
>> +     { 0x1e, 0x40a701f0 }, /* Not used */
>> +     { 0x20, 0x404501f0 }, /* Not used */
>> +     { 0x22, 0x404401f0 }, /* Not used */
>> +     { 0x23, 0x40a701f0 }, /* Not used */
>> +     {}
>> +};
>> +
>>  static const struct hda_fixup cxt_fixups[] = {
>>       [CXT_PINCFG_LENOVO_X200] = {
>>               .type = HDA_FIXUP_PINS,
>> @@ -4444,10 +4472,24 @@ static const struct hda_fixup cxt_fixups[] = {
>>               .type = HDA_FIXUP_PINS,
>>               .v.pins = cxt_pincfg_lenovo_tp410,
>>       },
>> +     [CXT_PINCFG_LEMOTE_A1004] = {
>> +             .type = HDA_FIXUP_PINS,
>> +             .chained = true,
>> +             .chain_id = CXT_FIXUP_INC_MIC_BOOST,
>> +             .v.pins = cxt_pincfg_lemote,
>> +     },
>> +     [CXT_PINCFG_LEMOTE_A1205] = {
>> +             .type = HDA_FIXUP_PINS,
>> +             .v.pins = cxt_pincfg_lemote,
>> +     },
>>       [CXT_FIXUP_STEREO_DMIC] = {
>>               .type = HDA_FIXUP_FUNC,
>>               .v.func = cxt_fixup_stereo_dmic,
>>       },
>> +     [CXT_FIXUP_INC_MIC_BOOST] = {
>> +             .type = HDA_FIXUP_FUNC,
>> +             .v.func = cxt5066_increase_mic_boost,
>> +     },
>>  };
>>
>>  static const struct snd_pci_quirk cxt5051_fixups[] = {
>> @@ -4463,6 +4505,8 @@ static const struct snd_pci_quirk cxt5066_fixups[] = {
>>       SND_PCI_QUIRK(0x17aa, 0x21cf, "Lenovo T520", CXT_PINCFG_LENOVO_TP410),
>>       SND_PCI_QUIRK(0x17aa, 0x3975, "Lenovo U300s", CXT_FIXUP_STEREO_DMIC),
>>       SND_PCI_QUIRK(0x17aa, 0x397b, "Lenovo S205", CXT_FIXUP_STEREO_DMIC),
>> +     SND_PCI_QUIRK(0x1c06, 0x2011, "Lemote A1004", CXT_PINCFG_LEMOTE_A1004),
>> +     SND_PCI_QUIRK(0x1c06, 0x2012, "Lemote A1205", CXT_PINCFG_LEMOTE_A1205),
>>       {}
>>  };
>>
>> --
>> 1.7.7.3
>>
>> _______________________________________________
>> Alsa-devel mailing list
>> Alsa-devel@alsa-project.org
>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>>
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
