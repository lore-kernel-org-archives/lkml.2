Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933366Ab2KBJjP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:39:15 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:45034 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913Ab2KBJjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:39:13 -0400
Message-ID: <509394BF.9020006@kernel.org>
Date: Fri, 02 Nov 2012 09:39:11 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] drivers/iio/industrialio-event.c: eliminate possible
 double free
References: <1350816727-1381-1-git-send-email-Julia.Lawall@lip6.fr> <1350816727-1381-6-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1350816727-1381-6-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2012 11:52 AM, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> The function __iio_add_event_config_attrs is only called once, by the
> function iio_device_register_eventset.  If the call fails,
> iio_device_register_eventset calls __iio_remove_event_config_attrs.  There
> is thus no need for __iio_add_event_config_attrs to also call
> __iio_remove_event_config_attrs on failure.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r@
> identifier f,free,a;
> parameter list[n] ps;
> type T;
> expression e;
> @@
> 
> f(ps,T a,...) {
>   ... when any
>       when != a = e
>   if(...) { ... free(a); ... return ...; }
>   ... when any
> }
> 
> @@
> identifier r.f,r.free;
> expression x,a;
> expression list[r.n] xs;
> @@
> 
> * x = f(xs,a,...);
>   if (...) { ... free(a); ... return ...; }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks - merged to fixes-togreg branch of iio.git

Jonathan
> 
> ---
> __iio_remove_event_config_attrs kfrees the elements of a list, but doesn't
> actually remove them from the list.  Perhaps for safety this should be
> cleaned up as well.  Not tested.
> 
>  drivers/iio/industrialio-event.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/iio/industrialio-event.c b/drivers/iio/industrialio-event.c
> index fa6543b..78570c7 100644
> --- a/drivers/iio/industrialio-event.c
> +++ b/drivers/iio/industrialio-event.c
> @@ -350,15 +350,10 @@ static inline int __iio_add_event_config_attrs(struct iio_dev *indio_dev)
>  		ret = iio_device_add_event_sysfs(indio_dev,
>  						 &indio_dev->channels[j]);
>  		if (ret < 0)
> -			goto error_clear_attrs;
> +			return ret;
>  		attrcount += ret;
>  	}
>  	return attrcount;
> -
> -error_clear_attrs:
> -	__iio_remove_event_config_attrs(indio_dev);
> -
> -	return ret;
>  }
>  
>  static bool iio_check_for_dynamic_events(struct iio_dev *indio_dev)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
