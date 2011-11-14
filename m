Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1KNUpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 15:45:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3002 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093Ab1KNUpV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 15:45:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 14 Nov 2011 12:45:18 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Denis Kuzmenko <linux@solonet.org.ua>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 12:45:14 -0800
Subject: RE: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to
 wrong GPIO line exporting
Thread-Topic: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to
 wrong GPIO line exporting
Thread-Index: Acyho+Dzm3N2JMejQGSgC3+VhTCGYgBaUJ6w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740805B5B@HQMAIL01.nvidia.com>
References: <4EBF1DD1.8090600@solonet.org.ua>
In-Reply-To: <4EBF1DD1.8090600@solonet.org.ua>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote at Saturday, November 12, 2011 6:31 PM:
> From: Denis Kuzmenko <linux@solonet.org.ua>
> 
> Fix bug in gpio-sysfs interface (export of busy GPIO line leads to export of different GPIO line).
> 
> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> ---
> 
> Patch is against 3.0.9
> When trying to export GPIO line 37(40) which is already exported/requested by kernel code we got GPIO
> line 3(4) exported.
> Looks like this is done because `export_store` function doesn't return the number of processed bytes
> and gets a part of previous buffer again.
> This fix works for me (Samsung s3c2440).
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index a971e3d..ccec497 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -633,7 +633,7 @@ static ssize_t export_store(struct class *class,
>  done:
>  	if (status)
>  		pr_debug("%s: status %d\n", __func__, status);
> -	return status ? : len;
> +	return len;
>  }

I assume that when the error occurs, status is negative. Is it some
special value like EINTR, EAGAIN? I'm surprised that the retried write
is smaller than the whole original buffer.

What's actually retrying the failed write? Is it user-space in response
to the previous failed write, in a (mistaken?) attempt to handle shorter-
than-expected-writes? You could confirm this with strace.

If the patch above really is correct, there are other places it'd be
needed; it looks like e.g. drivers/video/backlight/backlight.c would
have the same issue if you gave too-large integers to its sysfs files.

-- 
nvpublic

