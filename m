Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0E0QVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:21:54 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42142 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab0E0QVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:21:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=b53KSmPvnfu/UiuXbXXJXaK3VlRCrBENsngtRU2OLjuY3HhyDt0jN9lrLgNq0B5nFr
         H7+2fbSkbQevGWgKOsqmP5mpwt65ZARwN2lFcsq+RXNol+iRycyZO0NPXt0Ie1QTdfU8
         2fRmoU1wZI1HaO88vmiboavvszebXugqXgAC0=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 9/11] drivers/platform/x86: Eliminate a NULL pointer dereference
Date: Thu, 27 May 2010 09:21:42 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32.12-115.fc12.x86_64; KDE/4.4.2; x86_64; ; )
Cc: Mattia Dongili <malattia@linux.it>, Matthew Garrett <mjg@redhat.com>,
       platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005271436460.5422@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005271436460.5422@ask.diku.dk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005270921.43049.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 May 2010 05:37:00 am Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> Give different error messages if device_enum is NULL or if its type field
> has the wrong value.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @r exists@
> expression E,E1;
> identifier f;
> statement S1,S2,S3;
> @@
> 
> if ((E == NULL && ...) || ...)
> {
>   ... when != if (...) S1 else S2
>       when != E = E1
> * E->f
>   ... when any
>   return ...;
> }
> else S3
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> This may be too much clutter for little benefit.  Other, perhaps less
> informative solutions are possible.

Verbosity should be OK but I think that mixing pr_xxx() and naked printks
in the same patch is not very nice.

> 
>  drivers/platform/x86/sony-laptop.c |    8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/sony-laptop.c
> b/drivers/platform/x86/sony-laptop.c index 1387c5f..9db8d2b 100644
> --- a/drivers/platform/x86/sony-laptop.c
> +++ b/drivers/platform/x86/sony-laptop.c
> @@ -1196,8 +1196,12 @@ static void sony_nc_rfkill_setup(struct acpi_device
> *device) }
> 
>  	device_enum = (union acpi_object *) buffer.pointer;
> -	if (!device_enum || device_enum->type != ACPI_TYPE_BUFFER) {
> -		printk(KERN_ERR "Invalid SN06 return object 0x%.2x\n",
> +	if (!device_enum) {
> +		pr_err("Invalid SN06 return object\n");
> +		goto out_no_enum;
> +	}
> +	if (device_enum->type != ACPI_TYPE_BUFFER) {
> +		printk(KERN_ERR "Invalid SN06 return object type 0x%.2x\n",
>  				device_enum->type);
>  		goto out_no_enum;
>  	}

Thanks.

-- 
Dmitry
