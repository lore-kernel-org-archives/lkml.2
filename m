Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab2HVFCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:02:40 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:32918 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab2HVFCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:02:38 -0400
MIME-Version: 1.0
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF0AFE@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AFE@DQHE02.ent.ti.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 22 Aug 2012 13:02:16 +0800
X-Google-Sender-Auth: nS1n0TGSrIv4so9JMCzBQY12N5o
Message-ID: <CAK5ve-Lhmiu0vbUKvmsRUPZwRU8g=X=xuQXC5yLQRVePP+hz-A@mail.gmail.com>
Subject: Re: [PATCH 4/4] leds-lp5523: minor code style fixes
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 5:04 PM, Kim, Milo <Milo.Kim@ti.com> wrote:
> (a) use LP5523_ENABLE rather than magic number 0x40
> (b) use min_t() in lp5523_mux_parse()
> (c) skip while loop and just return if invalid command
>

Thanks for this cleanup. I will merge it later.

-Bryan

> Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
> ---
>  drivers/leds/leds-lp5523.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/leds/leds-lp5523.c b/drivers/leds/leds-lp5523.c
> index f8231f1..64ba8b2 100644
> --- a/drivers/leds/leds-lp5523.c
> +++ b/drivers/leds/leds-lp5523.c
> @@ -177,7 +177,7 @@ static int lp5523_detect(struct i2c_client *client)
>         int ret;
>         u8 buf;
>
> -       ret = lp5523_write(client, LP5523_REG_ENABLE, 0x40);
> +       ret = lp5523_write(client, LP5523_REG_ENABLE, LP5523_ENABLE);
>         if (ret)
>                 return ret;
>         ret = lp5523_read(client, LP5523_REG_ENABLE, &buf);
> @@ -338,7 +338,8 @@ static int lp5523_mux_parse(const char *buf, u16 *mux, size_t len)
>  {
>         int i;
>         u16 tmp_mux = 0;
> -       len = len < LP5523_LEDS ? len : LP5523_LEDS;
> +
> +       len = min_t(int, len, LP5523_LEDS);
>         for (i = 0; i < len; i++) {
>                 switch (buf[i]) {
>                 case '1':
> @@ -546,6 +547,9 @@ static int lp5523_do_store_load(struct lp5523_engine *engine,
>         unsigned cmd;
>         u8 pattern[LP5523_PROGRAM_LENGTH] = {0};
>
> +       if (engine->mode != LP5523_CMD_LOAD)
> +               return -EINVAL;
> +
>         while ((offset < len - 1) && (i < LP5523_PROGRAM_LENGTH)) {
>                 /* separate sscanfs because length is working only for %s */
>                 ret = sscanf(buf + offset, "%2s%n ", c, &nrchars);
> @@ -563,12 +567,7 @@ static int lp5523_do_store_load(struct lp5523_engine *engine,
>                 goto fail;
>
>         mutex_lock(&chip->lock);
> -
> -       if (engine->mode == LP5523_CMD_LOAD)
> -               ret = lp5523_load_program(engine, pattern);
> -       else
> -               ret = -EINVAL;
> -
> +       ret = lp5523_load_program(engine, pattern);
>         mutex_unlock(&chip->lock);
>
>         if (ret) {
> --
> 1.7.2.5
>
>
> Best Regards,
> Milo
>
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
