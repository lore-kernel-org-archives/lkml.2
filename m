Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237Ab2IETZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:25:34 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61607 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab2IETZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:25:32 -0400
MIME-Version: 1.0
In-Reply-To: <1346775269-12191-5-git-send-email-peter.senna@gmail.com>
References: <1346775269-12191-5-git-send-email-peter.senna@gmail.com>
Date: Wed, 5 Sep 2012 16:25:31 -0300
Message-ID: <CALF0-+Vn33ZtY68JbKSbNbaqkSO6OOfA38Ejoz=Kkz5WmOSFjA@mail.gmail.com>
Subject: Re: [PATCH 1/5] drivers/media/platform/davinci/vpbe.c: fix error
 return code
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, Sep 4, 2012 at 1:14 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Convert a nonnegative error return code to a negative one, as returned
> elsewhere in the function.
>
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
>
> // <smpl>
> (
> if@p1 (\(ret < 0\|ret != 0\))
>  { ... return ret; }
> |
> ret@p1 = 0
> )
> ... when != ret = e1
>     when != &ret
> *if(...)
> {
>   ... when != ret = e2
>       when forall
>  return ret;
> }
>
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>  drivers/media/platform/davinci/vpbe.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
> index c4a82a1..2e4a0da 100644
> --- a/drivers/media/platform/davinci/vpbe.c
> +++ b/drivers/media/platform/davinci/vpbe.c
> @@ -603,7 +603,6 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>         int output_index;
>         int num_encoders;
>         int ret = 0;
> -       int err;
>         int i;
>
>         /*
> @@ -646,10 +645,10 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
>         }
>         v4l2_info(&vpbe_dev->v4l2_dev, "vpbe v4l2 device registered\n");
>
> -       err = bus_for_each_dev(&platform_bus_type, NULL, vpbe_dev,
> +       ret = bus_for_each_dev(&platform_bus_type, NULL, vpbe_dev,
>                                platform_device_get);
> -       if (err < 0)
> -               return err;
> +       if (ret < 0)
> +               return ret;

This should be "goto somewhere" (probably vbpe_fail_v4l2_device),
instead of "return".
There are several tasks done (like locking a mutex) that need to be undone.

Actually, this bug is not directly related to *this* patch, so you
could send another patch
fixing this.

Regards,
Ezequiel.
