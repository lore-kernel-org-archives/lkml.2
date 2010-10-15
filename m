Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751269Ab0JOEUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 00:20:20 -0400
Received: from kroah.org ([198.145.64.141]:44323 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab0JOEUS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 00:20:18 -0400
Date: Thu, 14 Oct 2010 21:20:43 -0700
From: Greg KH <greg@kroah.com>
To: marui <m00150988@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
        Lin Lei <Lin.Lei@huawei.com>, Franko Fang <huananhu@huawei.com>,
        wangyeqi@huawei.com
Subject: Re: [PATCH] fix oops in usbserial_cleanup function;
Message-ID: <20101015042043.GA15942@kroah.com>
References: <00c601cb6c1c$2c768500$ba260b0a@china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c601cb6c1c$2c768500$ba260b0a@china.huawei.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 11:50:56AM +0800, marui wrote:
> 1. I find this bug on OpenSUSE 11.3 which kernel vesion is 2.6.34, but the latest kernel vesion 2.6.36-rc7 aslo have this bug. This patch is based on the kernel of 2.6.36-rc7.
> 2. Bug report:
>    a. Install huawei datacard dashboard on OpenSUSE 11.3
>    b. Plug in huawei datacard into OpenSUSE 11.3 which kernel verison is 2.6.36-rc7
>    c. After the dashboard has detected the device, I  pull out the usb datacard
>    d. close datashboard,then kernel panic will happen in usbserial_cleanup function. 

What does the "dashboard" program do?  Hold the port open?

> 3. fix the bug:
>    I find usbserial_cleanup should judge the usb device wheher has been disconnected firtly.
> 
> 
> diff -uprN -X linux-2.6.36-rc7-orig/Documentation/dontdiff linux-2.6.36-rc7-orig/drivers/usb/serial/usb-serial.c linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c
> 
> --- linux-2.6.36-rc7_orig/drivers/usb/serial/usb-serial.c 2010-10-06 16:39:52.000000000 -0400
> +++ linux-2.6.36-rc7/drivers/usb/serial/usb-serial.c 2010-10-14 20:59:47.000000000 -0400
> @@ -328,6 +328,20 @@ static void serial_cleanup(struct tty_st
>   /* The console is magical.  Do not hang up the console hardware
>    * or there will be tears.
>    */
> +        dbg("%s start\n",__func__);
> +        if(NULL == port)
> +        {
> +            dbg("%s NULL == port\n",__func__);
> +            return;

We don't need to keep the dbg statements here, do we?

> +        }
> + mutex_lock(&port->serial->disc_mutex);
> + if (port->serial->disconnected)
> +        {
> +                dbg("%s port->serial->disconnected\n",__func__);
> +                return_serial(port->serial);
> +  return;

You can't return with a lock held.

> +        }
> + mutex_unlock(&port->serial->disc_mutex);
>   if (port->port.console)
>    return;

Your tabs and spaces got all mixed up, and it can't be applied.  Also, I
need a "Signed-off-by:" line to be able to accept it.  Care to read the
file Documentation/SubmittingPatches for how to format a patch so we can
take it?

Also, run the patch through scripts/checkpatch.pl and resolve the coding
style issues before resending please.

thanks,

greg k-h
