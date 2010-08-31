Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0HaEFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 00:05:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45003 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751183Ab0HaEFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 00:05:05 -0400
Date: Mon, 30 Aug 2010 21:05:16 -0700
From: Greg KH <gregkh@suse.de>
To: raj uprade <rajuprade@gmail.com>
Cc: Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>,
        Oliver Neukum <oneukum@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Regarding USB-Serial Device driver
Message-ID: <20100831040516.GA15697@suse.de>
References: <20100819055329.M29689@admin-gateway.ncra.tifr.res.in> <20100819061525.M24093@admin-gateway.ncra.tifr.res.in> <201008190938.44532.marek.vasut@gmail.com> <20100819141812.GA12375@suse.de> <20100820033259.M54157@admin-gateway.ncra.tifr.res.in> <20100820035632.GA7349@suse.de> <20100820064731.M31524@admin-gateway.ncra.tifr.res.in> <20100820153910.GA11608@suse.de> <AANLkTin8AiOj4CST5Dr_icnY4MugG1mhgP7=c1jgcJcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTin8AiOj4CST5Dr_icnY4MugG1mhgP7=c1jgcJcA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 03:20:06PM +0530, raj uprade wrote:
>    Hi Greg,
> 
> >
> >
> > >  Again, please use a more modern kernel version, and then, please show
> >     the exact diff (in 'diff -u' format) that you made.
> >
> >     Below is the diff -u of changes made in pl2303.c
> 
>  --- /home/teleset/Zip_file/linux-2.6.26/drivers/usb/serial/pl2303.c
> 2010-07-29 15:13:47.000000000 +0530
> +++ /home/teleset/Desktop/pl2303.c    2010-08-26 15:11:04.000000000 +0530
> @@ -469,12 +469,25 @@
>      if (!count)
>          return count;
> 
> +                   spin_lock_irqsave(&priv->lock, flags);
> +              priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
> +                 control = priv->line_control;
> +              spin_unlock_irqrestore(&priv->lock, flags);
> +              set_control_lines(port->serial->dev, control);
> +
>      spin_lock_irqsave(&priv->lock, flags);
>      count = pl2303_buf_put(priv->buf, buf, count);
>      spin_unlock_irqrestore(&priv->lock, flags);
> -
> +
>      pl2303_send(port);
> 
> +            mdelay(5);
> +         spin_lock_irqsave(&priv->lock, flags);
> +           priv->line_control   = 0;
> +         control = priv->line_control;
> +     spin_unlock_irqrestore(&priv->lock, flags);
> +     set_control_lines(port->serial->dev,control);
> +
>      return count;
>  }

I don't even recall what you were trying to do here, sorry.  Please
include more context in your emails, we get a lot of them.

Also, what function was this change made in?

I don't think such a quick line control change is going to do what you
think it does as there are delays on the device side for sending the
data out through the uart that don't sync right up with the usb host
side here.  So it might be very easy to get out of order things
happening.

You need to make sure the data is really out the port before changing
any control lines.  Can't you do this properly from userspace with no
kernel changes?

thanks,

greg k-h
