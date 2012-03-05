Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757651Ab2CEUNH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:13:07 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:40744 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757496Ab2CEUNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:13:04 -0500
Message-ID: <4F551E46.7000100@linux.vnet.ibm.com>
Date: Tue, 06 Mar 2012 01:42:54 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [RFC] firmware loader: retry _nowait requests when userhelper
 is not yet available
References: <201203032122.36745.chunkeey@googlemail.com>
In-Reply-To: <201203032122.36745.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12030520-8878-0000-0000-0000018CB900
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ Adding more Cc's. ]

On 03/04/2012 01:52 AM, Christian Lamparter wrote:

> During resume, the userhelper might not be available. However for
> drivers which use the request_firmware_nowait interface, this will
> only lead to a pointless WARNING and a device which no longer works
> after the resume [since it couldn't get the firmware, because the
> userhelper was not available to take the request].
> 
> In order to solve this "chicken or egg" dilemma, the code now
> retries _nowait requests at one second intervals until the
> "loading_timeout" time is up.
> 
> ---
> I'm aware about the previous "request_firmware* in probe" discussions.
> Unfortunately, the hardware needs firmware so there is no other way
> around it. So please, I just wanted to know what the general opinion
> about the idea behind this patch is.
> 
> Regards,
> 	Christian
> 
> BTW: I'm not on the list, so please keep the 'CC'.
> ---
>  drivers/base/firmware_class.c |   24 +++++++++++++++++++++++-
>  1 files changed, 23 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 6c9387d..9f70096 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -19,6 +19,7 @@
>  #include <linux/kthread.h>
>  #include <linux/highmem.h>
>  #include <linux/firmware.h>
> +#include <linux/delay.h>
>  #include <linux/slab.h>
> 
>  #define to_dev(obj) container_of(obj, struct device, kobj)
> @@ -535,6 +536,11 @@ static int _request_firmware(const struct firmware **firmware_p,
> 
>  	read_lock_usermodehelper();
> 
> +	if (nowait && usermodehelper_is_disabled()) {
> +		retval = -EBUSY;
> +		goto out;
> +	}
> +
>  	if (WARN_ON(usermodehelper_is_disabled())) {
>  		dev_err(device, "firmware: %s will not be loaded\n", name);
>  		retval = -EBUSY;
> @@ -633,7 +639,7 @@ static int request_firmware_work_func(void *arg)
>  {
>  	struct firmware_work *fw_work = arg;
>  	const struct firmware *fw;
> -	int ret;
> +	int ret, timeout = loading_timeout;
> 
>  	if (!arg) {
>  		WARN_ON(1);
> @@ -642,6 +648,22 @@ static int request_firmware_work_func(void *arg)
> 
>  	ret = _request_firmware(&fw, fw_work->name, fw_work->device,
>  				fw_work->uevent, true);
> +
> +	while (ret == -EBUSY) {
> +		/*
> +		 * Try to retrieve the firmware within the loading timeout.
> +		 * To stick with the loading timeout convention from above:
> +		 *	loading_timeout = 0 means 'try forever' as well.
> +		 */
> +
> +		msleep(1000);
> +		ret = _request_firmware(&fw, fw_work->name, fw_work->device,
> +					fw_work->uevent, true);
> +
> +		if (timeout != 0 && timeout-- == 1)

> +			break;

> +	};

> +

>  	fw_work->cont(fw, fw_work->context);
> 
>  	module_put(fw_work->module);

