Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab2FJR0N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 13:26:13 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46993 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106Ab2FJR0M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 13:26:12 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-8-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-8-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 20:25:51 +0300
Message-ID: <CAK=Wgba9_o+0f1X+wtj1CALhUBBA4-P+Disaf0i6UtNvCs_M=g@mail.gmail.com>
Subject: Re: [PATCH 7/7] remoteproc: Add custom STE-modem firmware loader.
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Wed, Jun 6, 2012 at 4:38 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add custom firmware loader for STE firmware. This plugin adds
> functions for extracting the resource table and loading the
> firmware image into shared memory.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>

Nice patch!

> +struct rproc_fw_ops rproc_ste_modem_fw_ops = {
> +       .load = ste_load_segments,
> +       .find_rsc_table = ste_find_rsc_table
> +};
> +EXPORT_SYMBOL(rproc_ste_modem_fw_ops);

After you told me there's no simple & robust way to dynamically probe
the STE binary format, I agree it'd make sense to allow low-lever
drivers to statically impose it.

I'm just still not sure we want to publicly export those fw_ops
symbols throughout the kernel.

Alternatively, we can do something like how i2c algos are determined:
expose a rproc_set_ste_modem_fw() function, which takes an rproc
struct, and then sets the fw_ops to rproc_ste_modem_fw_ops. Then call
it from your driver after rproc_alloc() but before rproc_register().

This way only statically-format-imposing drivers will call those
functions, and all others, who use generic and detectable formats,
will just follow the current registration scheme (so no extra param
needed to rproc_alloc either). In the long term those generic formats
will be dynamically detected, but meanwhile, we can just set ELF as
the default.

What do you think?

Thanks,
Ohad.
