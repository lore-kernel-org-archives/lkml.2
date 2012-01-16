Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2APQU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:20:27 -0500
Received: from imr3.ericy.com ([198.24.6.13]:43000 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab2APQU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:20:26 -0500
Date: Mon, 16 Jan 2012 08:18:31 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Alejandro del Rio <scasbyte@gmail.com>
CC: Rodolfo Giometti <giometti@enneenne.it>, Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 2/2] hwmon: (w83627ehf) Add GPIO port 3 functionality
Message-ID: <20120116161831.GB7363@ericsson.com>
References: <CAPbJ=B=_Xubsni7R00kSotDQ9AE9jmhmyRV0gPkXGqAPGrNaXg@mail.gmail.com>
 <20120114211856.7e1b816d@endymion.delvare>
 <4F11FE6C.8020808@gmail.com>
 <20120115105300.GF3178@enneenne.com>
 <4F13F10F.7030606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F13F10F.7030606@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

On Mon, Jan 16, 2012 at 04:42:39AM -0500, Alejandro del Rio wrote:
> Hi Rodolfo,
> 
> On 15-Jan-12 4:53 AM, Rodolfo Giometti wrote:
> > On Sat, Jan 14, 2012 at 04:15:08PM -0600, Alejandro wrote:
> >>
> >> The patch looks great, and it is definitely more maintainable. I'll
> >> create a patch for the w83627ehf driver and send it as soon as
> >> possible. Should I make the patch for the w83627hf or wait for
> >> Rodolfo???
> >
> > I already sent a new version of my patches... here you can find a copy
> > of my message:
> >
> >     http://www.spinics.net/lists/lm-sensors/msg33656.html
> >
> > Please, ask to me whatever you need since I'd like very much these
> > patches will be added to the kernel main tree! :)
> >
> > Ciao,
> >
> > Rodolfo
> 
> The patch as it is posted on "lm-sensors/msg33656.html" mailing list 
> does not apply to the latest tree. After making some changes it applies 
> cleanly to 3.2 tree. The issues were:
> 
> -The gpio naming convention is now "gpio-[name of the driver]" instead 
> of "[name of driver]_gpio"
> -Line changes in the Kconfig
> -Some email addresses converted to @xxxxxxx (by the lm-sensors mailing 
> list I guess)
> 
> Please look at the attachments for the new patches (I take no credit for 
> the changes as it was a trivial clean-up), if you like the changes I 
> would recommend starting a new thread on this list to get reviews.
> 
> Note: I couldn't test the driver because my platform has not an HF chip 
> but the patch looks good so far =)
> 
> BR!
> 
> Alex

> From 932beeb80d022c5bab861ea4d8d78cd82cae0bba Mon Sep 17 00:00:00 2001
> From: Alejandro del Rio <scasbyte@gmail.com>
> Date: Mon, 16 Jan 2012 00:32:21 -0800
> Subject: [PATCH 1/2] [temporal change]
> 
> [temporal change]
> 
> 
> Signed-off-by: Alejandro del Rio <scasbyte@gmail.com>
> ---
>  drivers/hwmon/w83627hf.c |  331 ++++++++++++----------------------------------
>  1 files changed, 86 insertions(+), 245 deletions(-)
> 
[ ... ]

>  static int __devinit w83627hf_probe(struct platform_device *pdev)
>  {
>  	struct device *dev = &pdev->dev;
> -	struct w83627hf_sio_data *sio_data = dev->platform_data;
> +	struct w83627hf_sio_data *sio_data = dev->parent->platform_data;
>  	struct w83627hf_data *data;
> -	struct resource *res;
>  	int err, i;
>  
> -	static const char *names[] = {
> -		"w83627hf",
> -		"w83627thf",
> -		"w83697hf",
> -		"w83637hf",
> -		"w83687thf",
> +	struct resource res = {
> +		.start  = /* address + */ WINB_REGION_OFFSET,
> +		.end    = /* address + */ WINB_REGION_OFFSET +
> +						WINB_REGION_SIZE - 1,
> +		.name   = DRVNAME "_hwmon",
> +		.flags  = IORESOURCE_IO,
>  	};
>  
> -	res = platform_get_resource(pdev, IORESOURCE_IO, 0);
> -	if (!request_region(res->start, WINB_REGION_SIZE, DRVNAME)) {
> +	err = w83627hf_enable_hwmon(sio_data);
> +	if (err < 0)
> +		return err;
> +
> +	/* Before doing our job we should fixup ioport range */
> +	res.start += err;
> +	res.end += err;
> +
This doesn't look right. The mfd driver should pass resource information
to its child devices via mfd_add_device(), which adds it to the child device
platform data. Can you check how other mfd devices handle this ?

Guenter
