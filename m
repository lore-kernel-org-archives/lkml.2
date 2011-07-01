Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1GANdV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 09:33:21 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38979 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755554Ab1GANdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 09:33:20 -0400
MIME-Version: 1.0
In-Reply-To: <1309248717-14606-7-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
	<1309248717-14606-7-git-send-email-per.forlin@linaro.org>
Date: Fri, 1 Jul 2011 15:33:19 +0200
Message-ID: <BANLkTimuvUcJyrO0S+Odmz2Vz0YDwyY9Mw@mail.gmail.com>
Subject: Re: [PATCH v8 06/12] mmc: mmc_test: test to measure how sg_len affect performance
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 June 2011 10:11, Per Forlin <per.forlin@linaro.org> wrote:
> test that measures how the mmc bandwidth depends on the numbers of sg elements
> in the sg list. The transfer size if fixed and sg length goes from a few up
> to 512. The purpose is to measure overhead caused by multiple sg elements.
>
> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> ---
>  drivers/mmc/card/mmc_test.c |  151 +++++++++++++++++++++++++++++++++++++++----
>  1 files changed, 139 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> -static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned long sz,
> +static int mmc_test_map_sg(struct mmc_test_mem *mem, unsigned long size,
>                           struct scatterlist *sglist, int repeat,
>                           unsigned int max_segs, unsigned int max_seg_sz,
> -                          unsigned int *sg_len)
> +                          unsigned int *sg_len, int min_sg_len)
>  {
>        struct scatterlist *sg = NULL;
>        unsigned int i;
> +       unsigned long sz = size;
>
>        sg_init_table(sglist, max_segs);
> +       if (min_sg_len > max_segs)
> +               min_sg_len = max_segs;
>
>        *sg_len = 0;
>        do {
>                for (i = 0; i < mem->cnt; i++) {
>                        unsigned long len = PAGE_SIZE << mem->arr[i].order;
>
> +                       if (min_sg_len && (size / min_sg_len < len))
> +                               len = size / min_sg_len;
Make aligned to 512
len = ALIGN(size / min_sg_len, 512);

I run into this issue running on arm realview with max test size 128k
instead of 128M.

/Per
