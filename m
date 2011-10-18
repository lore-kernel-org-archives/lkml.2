Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180Ab1JRBnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 21:43:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:60747 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab1JRBnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 21:43:33 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <20111017232547.GB2559@opensource.wolfsonmicro.com>
References: <1318826212.12989.2.camel@phoenix> <20111017232547.GB2559@opensource.wolfsonmicro.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Tue, 18 Oct 2011 09:43:12 +0800
Message-ID: <CAF+7xWkaQbfdOJ8_zWeyzctX4Ses64BtK7nHz4ubkLp1P_bV5g@mail.gmail.com>
Subject: Re: [PATCH 2/2] ASoC: wm9081: Use snd_soc_update_bits for read-modify-write
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/18 Mark Brown <broonie@opensource.wolfsonmicro.com>:
> On Mon, Oct 17, 2011 at 12:36:52PM +0800, Axel Lin wrote:
>> Use snd_soc_update_bits for read-modify-write register access instead of
>> open-coding it using snd_soc_read and snd_soc_write
>
> Something in here is breaking audio through the WM9081 on Speyside.  I
> can't immediately spot anything wrong but the behaviour is quite obvious
> in the system.
>
hi Mark,
Thanks for testing.
I think the suspect part is here:

                        /* VMID 2*4k; Soft VMID ramp enable */
-                       reg = snd_soc_read(codec, WM9081_VMID_CONTROL);
-                       reg |= WM9081_VMID_RAMP | 0x6;
-                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
-
+                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+                                           WM9081_VMID_RAMP | 0x6,
+                                           WM9081_VMID_RAMP | 0x6);
                        mdelay(100);

                        /* Normal bias enable & soft start off */
-                       reg |= WM9081_BIAS_ENA;
-                       reg &= ~WM9081_VMID_RAMP;
-                       snd_soc_write(codec, WM9081_VMID_CONTROL, reg);
+                       snd_soc_update_bits(codec, WM9081_VMID_CONTROL,
+                                           WM9081_VMID_RAMP | WM9081_BIAS_ENA,
+                                           WM9081_BIAS_ENA);

Original code does not change VMID_SEL[1:0] bits in the second write for
Normal bias enable & soft start off.

Maybe I should not convert it to snd_soc_update_bits for this case.

Regards,
Axel
