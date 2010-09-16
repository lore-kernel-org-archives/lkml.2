Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756098Ab0IPUE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:04:26 -0400
Received: from kroah.org ([198.145.64.141]:43194 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0IPUEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:04:25 -0400
Date: Thu, 16 Sep 2010 13:00:58 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 3/3] include:linux: make ti_wilink_st like the rest
Message-ID: <20100916200058.GI10397@kroah.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-5-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284148738-21643-5-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:58:58PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> ti_wilink_st.h now is similar to other headers in include/linux.
> The st_ll dependency on ti_wilink_st is also fixed.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/staging/ti-st/st_ll.c |    2 +
>  include/linux/ti_wilink_st.h  |   51 +++++++++++++++++++++++-----------------
>  2 files changed, 31 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/ti-st/st_ll.c b/drivers/staging/ti-st/st_ll.c
> index e899920..15e4028 100644
> --- a/drivers/staging/ti-st/st_ll.c
> +++ b/drivers/staging/ti-st/st_ll.c
> @@ -19,6 +19,8 @@
>   */
>  
>  #define pr_fmt(fmt) "(stll) :" fmt
> +#include <linux/module.h>
> +#include <linux/skbuff.h>

Why is this needed?  Does it fix something that broke in patch 2/3?  If
so, fix it in that patch please.

>  #include <linux/ti_wilink_st.h>
>  
>  /**********************************************************************/
> diff --git a/include/linux/ti_wilink_st.h b/include/linux/ti_wilink_st.h
> index df8d2ee..a563e09 100644
> --- a/include/linux/ti_wilink_st.h
> +++ b/include/linux/ti_wilink_st.h
> @@ -26,12 +26,18 @@
>  #ifndef ST_H
>  #define ST_H
>  
> -#include <linux/skbuff.h>
> +#ifdef __KERNEL__
> +#include <linux/skbuff.h>	/* for sk_buff */
> +#include <linux/rfkill.h>	/* for rfkill */
> +#include <linux/tty.h>		/* for tty_struct */
> +#include <linux/tty_ldisc.h>	/* for tty_ldisc_ops */

Are these really needed?  Can't you include them in the .c files that
need to include this .h file instead?

> +
> +#endif

I don't think you need this #ifdef, do you?  Are you really exporting
this file to userspace for some reason?  If so, what reason?

>  
>  /* TODO:
>   * Move the following to tty.h upon acceptance
>   */
> -#define N_TI_WL	20	/* Ldisc for TI's WL BT, FM, GPS combo chips */
> +#define N_TI_WL	22	/* Ldisc for TI's WL BT, FM, GPS combo chips */

Why did this change?

>  
>  /**
>   * enum kim_gpio_state - Few protocols such as FM have ACTIVE LOW
> @@ -292,10 +298,10 @@ void kim_st_list_protocols(struct st_data_s *, void *);
>   *	relevant procedure to be called.
>   */
>  struct bts_header {
> -	uint32_t magic;
> -	uint32_t version;
> -	uint8_t future[24];
> -	uint8_t actions[0];
> +	unsigned long magic;
> +	unsigned long version;
> +	unsigned char future[24];
> +	unsigned char actions[0];

Why change these now?  That should happen some other place in the
series, not here.  Especially as you don't mention anything like this in
the changelog comment.

Also, why not just use 'u8' and friends instead?  That's the "proper"
kernel types to be using, not the uint8_t mess that is not correct
kernel types.

> @@ -386,6 +392,7 @@ void st_ll_wakeup(struct st_data_s *);
>  
>  /**
>   * structures and declarations used by the st_core for FM packets
> + * and GPS packets
>   */
>  struct fm_event_hdr {
>  	unsigned char plen;

Oh, is it?  That should go somewhere else.

> @@ -397,8 +404,8 @@ struct fm_event_hdr {
>  
>  /* gps stuff */
>  struct gps_event_hdr {
> -unsigned char opcode;
> -unsigned short plen;
> +	unsigned char opcode;
> +	unsigned short plen;
>  } __attribute__ ((packed));

This should be done somewhere else, it's a formatting patch.

>  
>  #endif /* ST_H */

I don't think this file is called "ST_H" here anymore.

thanks,

greg k-h
