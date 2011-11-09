Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab1KIIqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 03:46:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39027 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1KIIqo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 03:46:44 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1320827885.6708.1.camel@phoenix>
References: <1320827885.6708.1.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 9 Nov 2011 16:46:22 +0800
Message-ID: <CAF+7xW=uozfkCEfozZFmVzkbC+6S5UX-9n2woF9CCGxj5_tmFA@mail.gmail.com>
Subject: Re: [PATCH v3] ASoC: wm9081: Use snd_soc_update_bits for read-modify-write
To: linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>                        /* VMID 2*4k; Soft VMID ramp enable */
> -                       reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
> -                       reg |= WM9081_VMID_RAMP | 0x6;
> -                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +                                           WM9081_VMID_RAMP |
> +                                           WM9081_VMID_SEL_MASK,
> +                                           WM9081_VMID_RAMP | 0x6);
>
>                        mdelay(100);
>
>                        /* Normal bias enable & soft start off */
> -                       reg &= ~WM9081_VMID_RAMP;
> -                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
> +                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
> +                                           WM9081_VMID_RAMP |
> +                                           WM9081_VMID_SEL_MASK, 0);
>
It's probably not trival why we need to clear WM9081_VMID_SEL_MASK bits here by
looking at the patch.  Looking at original code, you will know current code
indeed clear WM9081_VMID_SEL_MASK bit here.

What current code does:
        1. read WM9081_VMID_CONTROL register
        2. write to WM9081_VMID_CONTROL register with setting WM9081_VMID_RAMP
           bit and setting WM9081_VMID_SEL_MASK bits to 0x6 (VMID
2*4k; Soft VMID
           ramp enable)
        3. mdelay(100)
        4. write to WM9081_VMID_CONTROL register with clearing
WM9081_VMID_RAMP bit.
           Note: In this write, we do also clear WM9081_VMID_SEL_MASK
bits because the register
           value of WM9081_VMID_SEL_MASK bits are clear when we read
in "step1".
           In this case, the WM9081_VMID_SEL_MASK bits are clear
           because we clear WM9081_VMID_SEL_MASK bits in SND_SOC_BIAS_OFF.
           ( The default value is also zero for WM9081_VMID_SEL_MASK bits. )

While converting to snd_soc_update_bits here we actually do one more read.
For the second call of snd_soc_update_bits, we need to explictly clear
WM9081_VMID_SEL_MASK bits.

Regards,
Axel
