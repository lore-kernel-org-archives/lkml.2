Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab2IQNvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 09:51:15 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55538 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab2IQNvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 09:51:13 -0400
MIME-Version: 1.0
In-Reply-To: <1347635630-19880-1-git-send-email-peter.senna@gmail.com>
References: <1347635630-19880-1-git-send-email-peter.senna@gmail.com>
Date: Mon, 17 Sep 2012 15:51:12 +0200
Message-ID: <CA+MoWDooQWuSyqE8CNKJVN5xhPvEEVqCsv5GuumBKKGQKXCg-g@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless kfree
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: wharms@bfs.de, kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch.

On Fri, Sep 14, 2012 at 5:13 PM, Peter Senna Tschudin
<peter.senna@gmail.com> wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
>
> Remove useless kfree() and clean up code related to the removal.
>
> The semantic patch that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r exists@
> position p1,p2;
> expression x;
> @@
>
> if (x@p1 == NULL) { ... kfree@p2(x); ... return ...; }
>
> @unchanged exists@
> position r.p1,r.p2;
> expression e <= r.x,x,e1;
> iterator I;
> statement S;
> @@
>
> if (x@p1 == NULL) { ... when != I(x,...) S
>                         when != e = e1
>                         when != e += e1
>                         when != e -= e1
>                         when != ++e
>                         when != --e
>                         when != e++
>                         when != e--
>                         when != &e
>    kfree@p2(x); ... return ...; }
>
> @ok depends on unchanged exists@
> position any r.p1;
> position r.p2;
> expression x;
> @@
>
> ... when != true x@p1 == NULL
> kfree@p2(x);
>
> @depends on !ok && unchanged@
> position r.p2;
> expression x;
> @@
>
> *kfree@p2(x);
> // </smpl>
>
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>
> ---
>  drivers/staging/gdm72xx/gdm_sdio.c |   13 ++++---------
>  1 file changed, 4 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
> index f824290..2e1a964 100644
> --- a/drivers/staging/gdm72xx/gdm_sdio.c
> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
> @@ -91,20 +91,15 @@ static void free_tx_struct(struct sdio_tx *t)
>
>  static struct sdio_rx *alloc_rx_struct(struct rx_cxt *rx)
>  {
> -       struct sdio_rx *r = NULL;
> -
> -       r = kmalloc(sizeof(*r), GFP_ATOMIC);
> -       if (r == NULL)
> -               goto out;
> +       struct sdio_rx *r;
>
> -       memset(r, 0, sizeof(*r));
> +       r = kzalloc(sizeof(*r), GFP_ATOMIC);
> +       if (!r)
> +               return NULL;
>
>         r->rx_cxt = rx;
>
>         return r;
> -out:
> -       kfree(r);
> -       return NULL;
>  }
>
>  static void free_rx_struct(struct sdio_rx *r)
>



-- 
Peter
