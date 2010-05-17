Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab0EQIng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:43:36 -0400
Received: from cantor.suse.de ([195.135.220.2]:51398 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0EQIne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:43:34 -0400
Date: Mon, 17 May 2010 10:43:33 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Julia Lawall <julia@diku.dk>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/4] drivers/hid: Eliminate use after free
In-Reply-To: <Pine.LNX.4.64.1005151146120.15566@ask.diku.dk>
Message-ID: <alpine.LNX.2.00.1005171042430.28092@pobox.suse.cz>
References: <Pine.LNX.4.64.1005151146120.15566@ask.diku.dk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> The skip label frees resp, which has not been allocated at the point of
> this goto and then does a break, based on the fact that err is non-zero.
> This is replaced by a break directly.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @free@
> expression E;
> position p;
> @@
> kfree@p(E)
> 
> @@
> expression free.E, subE<=free.E, E1;
> position free.p;
> @@
> 
>   kfree@p(E)
>   ...
> (
>   subE = E1
> |
> * E
> )
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/hid/hid-picolcd.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-picolcd.c b/drivers/hid/hid-picolcd.c
> index 95253b3..7aabf65 100644
> --- a/drivers/hid/hid-picolcd.c
> +++ b/drivers/hid/hid-picolcd.c
> @@ -1616,7 +1616,7 @@ static ssize_t _picolcd_flash_write(struct picolcd_data *data, int report_id,
>  		raw_data[len_off] = s > 32 ? 32 : s;
>  		if (copy_from_user(raw_data+len_off+1, u, raw_data[len_off])) {
>  			err = -EFAULT;
> -			goto skip;
> +			break;
>  		}
>  		resp = picolcd_send_and_wait(data->hdev, report_id, raw_data,
>  				len_off+1+raw_data[len_off]);

Good catch, applied. Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
