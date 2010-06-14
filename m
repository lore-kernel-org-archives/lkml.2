Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab0FNWfh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:35:37 -0400
Received: from kroah.org ([198.145.64.141]:38118 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127Ab0FNWff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:35:35 -0400
Date: Mon, 14 Jun 2010 15:33:04 -0700
From: Greg KH <greg@kroah.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Matthew Garrett <mjg@redhat.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       Bernhard Rosenkraenzer <bero@arklinux.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] qcserial: fix a memory leak in qcprobe error path
Message-ID: <20100614223304.GB31069@kroah.com>
References: <1275982163.17060.3.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275982163.17060.3.camel@mola>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 08, 2010 at 03:29:23PM +0800, Axel Lin wrote:
> In current implemtation, the "data" is not kfreed in qcprobe error path.
> This patch moves the memory allocation a little bit latter and only
> allocate memory when no error is detected in previous checking.

Yeah, but it's now pretty messy.

> --- a/drivers/usb/serial/qcserial.c
> +++ b/drivers/usb/serial/qcserial.c
> @@ -109,13 +109,6 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>  	ifnum = intf->desc.bInterfaceNumber;
>  	dbg("This Interface = %d", ifnum);
>  
> -	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
> -					 GFP_KERNEL);
> -	if (!data)
> -		return -ENOMEM;
> -
> -	spin_lock_init(&data->susp_lock);
> -

Moving this to the end is fine.

> @@ -140,7 +135,7 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>  					retval);
>  				retval = -ENODEV;
>  			}
> -			return retval;
> +			goto out;

But this doesn't need to be changed, right?
Or this.

>  		}
>  		break;
>  
> @@ -156,17 +151,26 @@ static int qcprobe(struct usb_serial *serial, const struct usb_device_id *id)
>  					retval);
>  				retval = -ENODEV;
>  			}
> -			return retval;
> +			goto out;

Or this?

>  		}
>  		break;
>  
>  	default:
>  		dev_err(&serial->dev->dev,
>  			"unknown number of interfaces: %d\n", nintf);
> -		return -ENODEV;

Hm. maybe.

>  	}
>  
> -	return retval;
> +out:
> +	if (retval)
> +		return retval;
> +
> +	data = serial->private = kzalloc(sizeof(struct usb_wwan_intf_private),
> +					 GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	spin_lock_init(&data->susp_lock);
> +	return 0;

I guess it's ok, I just don't like doing data initialization on the
"out" path, it's messy.

Care to neaten this up a bit more and resend it?  Perhaps just free the
memory on the error path instead of moving it later on?

thanks,

greg k-h
