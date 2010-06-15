Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab0FOKRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 06:17:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34398 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756154Ab0FOKRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 06:17:48 -0400
Message-ID: <4C17519C.5080209@ru.mvista.com>
Date: Tue, 15 Jun 2010 14:10:36 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
CC: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: gadget: g_fs: possible invalid pointer reference
 bug fixed
References: <f8fbee30a711b740b5875514715c3c58b4eb196c.1276170819.git.m.nazarewicz@samsung.com>
In-Reply-To: <f8fbee30a711b740b5875514715c3c58b4eb196c.1276170819.git.m.nazarewicz@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Michal Nazarewicz wrote:

> During __gfs_do_config() some invalid pointers may be left
> in usb_configuration::interfaces array from previous calls
> to the __gfs_do_config() for the same configuration.  This
> will always happen if an user space function which has
> a fewer then the last user space function registers itself.
> Composite's set_config() function that a pointer after the
> last interface in usb_configuration::interface is NULL
> unless the array is full.

> This patch makes the __gfs_do_config() make sure that if the
> usb_configuration::interface is not full then a pointer
> after the last interface is NULL.

> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/usb/gadget/g_ffs.c |   11 +++++++++++
>  1 files changed, 11 insertions(+), 0 deletions(-)

> diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
> index 2f26470..da3a9e4 100644
> --- a/drivers/usb/gadget/g_ffs.c
> +++ b/drivers/usb/gadget/g_ffs.c
> @@ -392,6 +392,17 @@ static int __gfs_do_config(struct usb_configuration *c,
>  	if (unlikely(ret < 0))
>  		return ret;
>  
> +	/* After previous do_configs there may be some invalid
> +	 * pointers in c->interface array.  This happens every time
> +	 * a user space function with fewer interfaces than a user
> +	 * space function that was run before the new one is run.  The
> +	 * compasit's set_config() assumes that if there is no more
> +	 * then MAX_CONFIG_INTERFACES interfaces in a configuration
> +	 * then there is a NULL pointer after the last interface in
> +	 * c->interface array.  We need to make sure this is true. */

    According to CodingStyle, the preferred style of the multi-line comments 
is this:

/*
  * bla
  * bla
  */

> +	if (c->next_interface_id < ARRAY_SIZE(c->interface))
> +		c->interface[c->next_interface_id] = NULL;
> +
>  	return 0;
>  }

WBR, Sergei

