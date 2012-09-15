Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172Ab2IOJLU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2012 05:11:20 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:38524 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752531Ab2IOJLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2012 05:11:18 -0400
Message-ID: <50544633.3040901@bfs.de>
Date: Sat, 15 Sep 2012 11:11:15 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/9] drivers/staging/gdm72xx/gdm_sdio.c: Remove useless
 kfree
References: <1347635630-19880-1-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1347635630-19880-1-git-send-email-peter.senna@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


it looks ok to me

Reviewed-by: walter harms <wharms@bfs.de>


Am 14.09.2012 17:13, schrieb Peter Senna Tschudin:
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
> -	struct sdio_rx *r = NULL;
> -
> -	r = kmalloc(sizeof(*r), GFP_ATOMIC);
> -	if (r == NULL)
> -		goto out;
> +	struct sdio_rx *r;
>  
> -	memset(r, 0, sizeof(*r));
> +	r = kzalloc(sizeof(*r), GFP_ATOMIC);
> +	if (!r)
> +		return NULL;
>  
>  	r->rx_cxt = rx;
>  
>  	return r;
> -out:
> -	kfree(r);
> -	return NULL;
>  }
>  
>  static void free_rx_struct(struct sdio_rx *r)
> 
> 
> 
