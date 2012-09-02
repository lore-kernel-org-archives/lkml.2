Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675Ab2IBHSc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 03:18:32 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43953 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823Ab2IBHSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 03:18:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
References: <1345643359-16584-1-git-send-email-stigge@antcom.de>
	<CAPub14-Oot_wJsRTv2AGu3SAAf40+3_wK43=0Swxj+5XjPaDew@mail.gmail.com>
Date: Sun, 2 Sep 2012 09:18:29 +0200
Message-ID: <CACRpkdY3atmx4N-Zq2imrgPoukueYiexzndD7bVyQTgV02Vpuw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] spi/pl022: Add chip select handling via GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: shiraz hashim <shiraz.linux.kernel@gmail.com>
Cc: Roland Stigge <stigge@antcom.de>, aletes.xgr@gmail.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 1:14 PM, shiraz hashim
<shiraz.linux.kernel@gmail.com> wrote:
> Hi Roland,
>
> On Wed, Aug 22, 2012 at 7:19 PM, Roland Stigge <stigge@antcom.de> wrote:
>> @@ -2016,6 +2030,8 @@ pl022_probe(struct amba_device *adev, co
>>         pl022->master_info = platform_info;
>>         pl022->adev = adev;
>>         pl022->vendor = id->data;
>> +       /* Point chipselects to allocated memory beyond the main struct */
>> +       pl022->chipselects = (int *) pl022 + sizeof(struct pl022);
>
> This is going beyond memory allocated for chipselects
> as it adds 4 * sizeof(struct pl022) bytes to pl022.

Yes that is why the allocation looks like this:

+       master = spi_alloc_master(dev, sizeof(struct pl022) + sizeof(int) *
+                                 platform_info->num_chipselect);

> pl022->chipselects = (int *) &pl022[1];
> can be musch safer.

I see absolutely no sematic difference between these two
methods to reach the first position beyond the first struct.

If we're gonna be debating this it's a safe sign that this is
not a good design pattern at all, so then it is better to simply
devm_kzalloc(sizeof(int) * platform_info->num_chipselect);
separately.

(But I'm happy with the patch as it is. And the other way
too, since I'm not very picky.)

Yours,
Linus Walleij
