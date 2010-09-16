Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab0IPP5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:57:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57921 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab0IPP5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:57:47 -0400
X-Authority-Analysis: v=1.1 cv=FR6uSFBUsHpo/LPxUdUfz19YCIdHKFi4UJmy4GdSgrg= c=1 sm=0 a=G6fJhtGuX8gA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=_QOhAC9u1-2zpYMG7LUA:9 a=ztAy1r9PiXXcBQFZoDcA:7 a=4G4r9oUBAH3AUVEbZC6Anma7Ls0A:4 a=CjuIK1q_8ugA:10 a=MSl-tDqOz04A:10 wl=env:18 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 16 Sep 2010 11:57:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: j.dumon@option.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        security@kernel.org, davem@davemloft.net, stable@kernel.org
Subject: Re: [PATCH v2] drivers/net/usb/hso.c: prevent reading
 uninitialized memory
Message-ID: <20100916155745.GB14318@home.goodmis.org>
References: <1284587008.6275.95.camel@dan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284587008.6275.95.camel@dan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 05:43:28PM -0400, Dan Rosenberg wrote:
> Fixed formatting (tabs and line breaks).
> 
> The TIOCGICOUNT device ioctl allows unprivileged users to read
> uninitialized stack memory, because the "reserved" member of the
> serial_icounter_struct struct declared on the stack in hso_get_count()
> is not altered or zeroed before being copied back to the user.  This
> patch takes care of it.
> 
> Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
> 
> --- linux-2.6.35.4.orig/drivers/net/usb/hso.c	2010-08-26 19:47:12.000000000 -0400
> +++ linux-2.6.35.4/drivers/net/usb/hso.c	2010-09-14 21:26:18.477585183 -0400
> @@ -1653,6 +1653,8 @@ static int hso_get_count(struct hso_seri
>  	struct uart_icount cnow;
>  	struct hso_tiocmget  *tiocmget = serial->tiocmget;
>  
> +	memset(&icount, 0, sizeof(struct serial_icounter_struct));
> +

Move the above to after the spinlocks.

-- Steve

>  	if (!tiocmget)
>  		 return -ENOENT;
>  	spin_lock_irq(&serial->serial_lock);
> 
