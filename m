Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab0HTG4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 02:56:42 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:58905 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227Ab0HTG4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 02:56:38 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>, Oliver Neukum <oneukum@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Regarding USB-Serial Device driver
Date: Fri, 20 Aug 2010 12:26:22 +0530
Message-Id: <20100820064731.M31524@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20100820035632.GA7349@suse.de>
References: <20100819055329.M29689@admin-gateway.ncra.tifr.res.in> <20100819061525.M24093@admin-gateway.ncra.tifr.res.in> <201008190938.44532.marek.vasut@gmail.com> <20100819141812.GA12375@suse.de> <20100820033259.M54157@admin-gateway.ncra.tifr.res.in> <20100820035632.GA7349@suse.de>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
      Sorry for including quotations in my email.

Oliver,
          I see the  superfluous data with usbmon also.

I have changed the pl2303_write(), according to my need.I enabled the RTS line before 
the data transmission and after a delay of 5ms ,disabled the RTS lines for my MCM device
to respond.

static int pl2303_write(struct usb_serial_port *port, const unsigned char *buf,int count)
> {
> 	struct pl2303_private *priv = usb_get_serial_port_data(port);
> 	unsigned long flags;
>          u8 control;
> 	dbg("%s - port %d, %d bytes", __func__, port->number, count);
>        
> 	if (!count)
> 		return count;
> 
>      // Following code is included so that We can enable the RTS line to high before
data transmission
>        //  Tried writing a for loop here to loop the RTS line enable/disable , but
that also didn't work...
>   
>                   spin_lock_irqsave(&priv->lock, flags);
> 	          priv->line_control |= (CONTROL_DTR | CONTROL_RTS);
>                  control = priv->line_control;
> 	          spin_unlock_irqrestore(&priv->lock, flags);
> 	          set_control_lines(port->serial->dev, control); 
>  
> 	     spin_lock_irqsave(&priv->lock, flags);
> 	     count = pl2303_buf_put(priv->buf, buf, count);
> 	     spin_unlock_irqrestore(&priv->lock, flags);
>    
> 	       pl2303_send(port);                              // If I comment this , driver
dosen't work 
>        
> 	//  Following code is included so that We can disable the RTS line to low after data
transmission..
>          // mdelay plays an Important role here....
>           mdelay(5);
>          spin_lock_irqsave(&priv->lock, flags);
>        //   priv->line_control &= ~(CONTROL_DTR | CONTROL_RTS); // this doesn't work
here...
>            priv->line_control   = 0;   // this work here.....
>          control = priv->line_control;
> 	 spin_unlock_irqrestore(&priv->lock, flags);
> 	 set_control_lines(port->serial->dev,control); 
>         
>           return count;   // count is also very IMP b'coz it affect the device
driver's behaviour.....
> }


Thanks,
 Raju
