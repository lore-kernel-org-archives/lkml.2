Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2EVBlf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 21:41:35 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:52398 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab2EVBld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 21:41:33 -0400
Date: Mon, 21 May 2012 18:41:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "Fleming, Matt" <matt.fleming@intel.com>,
        "balbi@ti.com" <balbi@ti.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [Resend PATCH v2] testusb: add path /dev/bus/usb to default
 search paths of usbfs
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A06388E@SHSMSX101.ccr.corp.intel.com>
Message-ID: <alpine.DEB.2.00.1205211839180.20916@chino.kir.corp.google.com>
References: <0C18FE92A7765D4EB9EE5D38D86A563A062E6C@SHSMSX101.ccr.corp.intel.com> <0C18FE92A7765D4EB9EE5D38D86A563A06388E@SHSMSX101.ccr.corp.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2012, Du, ChangbinX wrote:

> As real device-nodes managed by udev whose nodes lived in /dev/bus/usb are mostly used today, let testusb tool use that directory as one default path make tool be more convenient to use.
> 
> Signed-off-by: Du Changbin <changbinx.du@intel.com>
> ---
>  tools/usb/testusb.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/tools/usb/testusb.c b/tools/usb/testusb.c index 6e0f567..82d7c59 100644
> --- a/tools/usb/testusb.c
> +++ b/tools/usb/testusb.c
> @@ -358,6 +358,7 @@ static const char *usbfs_dir_find(void)  {
>  	static char usbfs_path_0[] = "/dev/usb/devices";
>  	static char usbfs_path_1[] = "/proc/bus/usb/devices";
> +	static char udev_usb_path[] = "/dev/bus/usb";
>  
>  	static char *const usbfs_paths[] = {
>  		usbfs_path_0, usbfs_path_1
> @@ -376,6 +377,10 @@ static const char *usbfs_dir_find(void)
>  		}
>  	} while (++it != end);
>  
> +	/* real device-nodes managed by udev */
> +	if (access(udev_usb_path, F_OK) == 0)
> +		return udev_usb_path;
> +
>  	return NULL;
>  }
>  

Two issues with this: F_OK only guarantees that the path exists, it does 
not guarantee that it is readable like this function guarantees for 
usbfs_paths, and access() shouldn't be used because of its security 
implications, you're better off using open() and testing for fd.
