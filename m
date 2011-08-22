Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab1HVL3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 07:29:48 -0400
Received: from ppsw-52.csi.cam.ac.uk ([131.111.8.152]:32891 "EHLO
	ppsw-52.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1HVL3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 07:29:43 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E523F8D.8080902@cam.ac.uk>
Date: Mon, 22 Aug 2011 12:37:49 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110801 Thunderbird/5.0
MIME-Version: 1.0
To: "Maxin B. John" <maxin.john@gmail.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
        Bryan Freed <bfreed@chromium.org>, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: iio: industrialio-core: Fix compiler warning
References: <20110822100824.GA6671@maxin>
In-Reply-To: <20110822100824.GA6671@maxin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/11 11:08, Maxin B. John wrote:
> drivers/staging/iio/industrialio-core.c: In function
> 'iio_device_add_event_sysfs':
> drivers/staging/iio/industrialio-core.c:914: warning: 'mask' may be
> used uninitialized in this function
Thanks for the patch.  It's actually a driver bug if this occurs.
We could have had a WARN_ON to let userspace know about the bug and
indeed taken the error route you suggest but
the relevant code has actually undergone a rewrite anyway so the
bit you are fixing doesn't exist any more anyway.

See http://git.kernel.org/?p=linux/kernel/git/jic23/iio-blue.git;a=summary
For our current dev tree (eats babies and includes all sorts of stuff
that hasn't been reviewed yet - so beware).  

> Signed-off-by: Maxin B. John <maxin.john@gmail.com>
> ---
> diff --git a/drivers/staging/iio/industrialio-core.c b/drivers/staging/iio/industrialio-core.c
> index 19819e7..83b5953 100644
> --- a/drivers/staging/iio/industrialio-core.c
> +++ b/drivers/staging/iio/industrialio-core.c
> @@ -911,7 +911,7 @@ static int iio_device_add_event_sysfs(struct iio_dev *dev_info,
>  				      struct iio_chan_spec const *chan)
>  {
>  
> -	int ret = 0, i, mask;
> +	int ret = 0, i, mask = 0;
>  	char *postfix;
>  	if (!chan->event_mask)
>  		return 0;
> @@ -944,6 +944,8 @@ static int iio_device_add_event_sysfs(struct iio_dev *dev_info,
>  			break;
>  		default:
>  			printk(KERN_INFO "currently unhandled type of event\n");
> +			ret = -EINVAL;
> +			goto error_ret;
>  		}
>  		ret = __iio_add_chan_devattr(postfix,
>  					     NULL,

