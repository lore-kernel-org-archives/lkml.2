Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752032Ab2LCTTQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 14:19:16 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40917 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab2LCTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 14:19:14 -0500
MIME-Version: 1.0
In-Reply-To: <20121202172930.GA21835@elgon.mountain>
References: <1354418247.7995.49.camel@deadeye.wl.decadent.org.uk> <20121202172930.GA21835@elgon.mountain>
From: Bryan Wu <cooloney@gmail.com>
Date: Mon, 3 Dec 2012 11:18:52 -0800
Message-ID: <CAK5ve-Li0O5b7WL6R+RL6+=4FAV=NSLfMt99rG+k7ruTEPNVEg@mail.gmail.com>
Subject: Re: [patch] leds: leds-lp5521: return an error code on error in probe()
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 9:29 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> If "buf" wasn't equal to LP5521_REG_R_CURR_DEFAULT the probe fails but
> we still return zero.  I've changed it to print an error message and
> return -EINVAL.
>

Looks fine with me, I applied it to my for-next branch.

-Bryan

> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/leds/leds-lp5521.c b/drivers/leds/leds-lp5521.c
> index 2bee6b9..cb8a522 100644
> --- a/drivers/leds/leds-lp5521.c
> +++ b/drivers/leds/leds-lp5521.c
> @@ -788,10 +788,17 @@ static int lp5521_probe(struct i2c_client *client,
>          * LP5521_REG_ENABLE register will not have any effect - strange!
>          */
>         ret = lp5521_read(client, LP5521_REG_R_CURRENT, &buf);
> -       if (ret || buf != LP5521_REG_R_CURR_DEFAULT) {
> +       if (ret) {
>                 dev_err(&client->dev, "error in resetting chip\n");
>                 goto fail2;
>         }
> +       if (buf != LP5521_REG_R_CURR_DEFAULT) {
> +               dev_err(&client->dev,
> +                       "unexpected data in register (expected 0x%x got 0x%x)\n",
> +                       LP5521_REG_R_CURR_DEFAULT, buf);
> +               ret = -EINVAL;
> +               goto fail2;
> +       }
>         usleep_range(10000, 20000);
>
>         ret = lp5521_detect(client);
