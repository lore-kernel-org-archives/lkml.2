Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2FKJzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:55:48 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:63699 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab2FKJzr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAK=Wgba9_o+0f1X+wtj1CALhUBBA4-P+Disaf0i6UtNvCs_M=g@mail.gmail.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
	<1338989907-25360-8-git-send-email-sjur.brandeland@stericsson.com>
	<CAK=Wgba9_o+0f1X+wtj1CALhUBBA4-P+Disaf0i6UtNvCs_M=g@mail.gmail.com>
Date: Mon, 11 Jun 2012 11:55:45 +0200
X-Google-Sender-Auth: Ew6tDPfKcw2YSKAll75RiMUuIu0
Message-ID: <CAJK669a-O-Ee9ex4fiZ14Q18eJB_MM408yDnjNArtF_PN9aQ2A@mail.gmail.com>
Subject: Re: [PATCH 7/7] remoteproc: Add custom STE-modem firmware loader.
From: =?UTF-8?Q?Sjur_Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

>> +struct rproc_fw_ops rproc_ste_modem_fw_ops = {
>> +       .load = ste_load_segments,
>> +       .find_rsc_table = ste_find_rsc_table
>> +};
>> +EXPORT_SYMBOL(rproc_ste_modem_fw_ops);
...
> I'm just still not sure we want to publicly export those fw_ops
> symbols throughout the kernel.
>
>
> Alternatively, we can do something like how i2c algos are determined:
> expose a rproc_set_ste_modem_fw() function, which takes an rproc
> struct, and then sets the fw_ops to rproc_ste_modem_fw_ops. Then call
> it from your driver after rproc_alloc() but before rproc_register().
>
> This way only statically-format-imposing drivers will call those
> functions, and all others, who use generic and detectable formats,
> will just follow the current registration scheme (so no extra param
> needed to rproc_alloc either). In the long term those generic formats
> will be dynamically detected, but meanwhile, we can just set ELF as
> the default.
>
> What do you think?

How about this:
In rproc_alloc, we set the rproc_elf_fw_ops as default, and we add a function:

void rproc_set_fw_ops(struct rproc *rproc, const struct rproc_fw_ops *fw_ops)
{
	rproc->fw_ops = fw_ops;
}
EXPORT_SYMBOL(rproc_set_fw_ops);

allowing the ste_modem_driver to override the default ELF-firmware handler.

Then the file remoteproc_elf_loader.c containing rproc_elf_fw_ops is
default fw_ops
and is contained remoteproc.ko.

The ste_modem_fw_ops will be linked together with the ste_modem_rproc module,
and none of the fw_ops needs to be exported as symbols globally.

Regards,
Sjur
