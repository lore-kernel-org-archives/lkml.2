Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758675Ab2CJAbG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:31:06 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58871 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757170Ab2CJAbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:31:04 -0500
Date: Fri, 9 Mar 2012 16:30:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] USB: create module_usb_serial_driver macro
Message-ID: <20120310003058.GB22064@kroah.com>
References: <20120224233814.GA16588@kroah.com>
 <4F48CBCF.7060004@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F48CBCF.7060004@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 12:53:51PM +0100, Lars-Peter Clausen wrote:
> On 02/25/2012 12:38 AM, Greg KH wrote:
> > Now that Alan Stern has cleaned up the usb serial driver registration,
> > we have the ability to create a module_usb_serial_driver macro to make
> > things a bit simpler, like the other *_driver macros created.
> > 
> > But, as we need two functions here, we can't reuse the existing
> > module_driver() macro, so we need to roll our own.
> > 
> > Lars-Peter, or anyone else, am I missing something here and we can use
> > module_driver() somehow, or even modify it, to work for subsystems that
> > need 2 parameters for their function calls to register/deregister?
> > 
> 
> I suppose we can make module_driver a variadic macro and pass any additional
> parameters to the register and unregister functions. Patch attached.
> 
> - Lars
> 
> 8<-------------------------------------------------------------------->8
> >From 0d731970249b787748eccd6e81890c012a44e5a6 Mon Sep 17 00:00:00 2001
> From: Lars-Peter Clausen <lars@metafoo.de>
> Date: Sat, 25 Feb 2012 11:25:58 +0100
> Subject: [PATCH] driver-core: Allow additional parameters for module_driver
> 
> Allow module_driver take additional parameters which will be passed to the
> register and unregister function calls. This allows it to be used in cases
> where additional parameters are required (e.g. usb_serial_register_drivers).
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  include/linux/device.h |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/device.h b/include/linux/device.h
> index b63fb39..bccccef 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1007,19 +1007,20 @@ extern long sysfs_deprecated;
>   * @__driver: driver name
>   * @__register: register function for this driver type
>   * @__unregister: unregister function for this driver type
> + * @...: Additional arguments to be passed to __register and __unregister.
>   *
>   * Use this macro to construct bus specific macros for registering
>   * drivers, and do not use it on its own.
>   */
> -#define module_driver(__driver, __register, __unregister) \
> +#define module_driver(__driver, __register, __unregister, ...) \
>  static int __init __driver##_init(void) \
>  { \
> -	return __register(&(__driver)); \
> +	return __register(&(__driver) , ##__VA_ARGS__); \
>  } \
>  module_init(__driver##_init); \
>  static void __exit __driver##_exit(void) \
>  { \
> -	__unregister(&(__driver)); \
> +	__unregister(&(__driver) , ##__VA_ARGS__); \
>  } \
>  module_exit(__driver##_exit);

Nice, let me play with this and see how it works out, thanks.

greg k-h
