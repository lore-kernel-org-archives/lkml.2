Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab2GYQEb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:04:31 -0400
Received: from osrc3.amd.com ([217.9.48.20]:36468 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753833Ab2GYQEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:04:30 -0400
Date: Wed, 25 Jul 2012 18:04:25 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 08/13] driver core: firmware loader: fix device
 lifetime
Message-ID: <20120725160425.GK11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
 <1343149213-10160-9-git-send-email-ming.lei@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343149213-10160-9-git-send-email-ming.lei@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 01:00:08AM +0800, Ming Lei wrote:
> Callers of request_firmware* must hold the reference count of
> @device, otherwise it is easy to trigger oops since the firmware
> loader device is the child of @device.
> 
> This patch adds comments about the usage. In fact, most of drivers
> call request_firmware* in its probe() or open(), so the constraint
> should be reasonable and satisfied easily.
> 
> Also this patch holds the reference cound of @device before

					count

> schedule_work() in request_firmware_nowait() to avoid that
> the @device dies after request_firmware_nowait returns and before
> the work is scheduled.
> 
> Also request_firmware_nowait should be called in atomic context now,
> so fix the obsolete comments.
> 
> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> ---
>  drivers/base/firmware_class.c |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 674cb11..540b2e1 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -717,6 +717,8 @@ err_put_dev:
>   *      @name will be used as $FIRMWARE in the uevent environment and
>   *      should be distinctive enough not to be confused with any other
>   *      firmware image for this or any other device.
> + *
> + *	Caller must hold the reference count of @device.
>   **/
>  int
>  request_firmware(const struct firmware **firmware_p, const char *name,
> @@ -798,6 +800,7 @@ static void request_firmware_work_func(struct work_struct *work)
>  
>   out:
>  	fw_work->cont(fw, fw_work->context);
> +	put_device(fw_work->device);
>  
>  	module_put(fw_work->module);
>  	kfree(fw_work);
> @@ -816,9 +819,10 @@ static void request_firmware_work_func(struct work_struct *work)
>   * @cont: function will be called asynchronously when the firmware
>   *	request is over.
>   *
> + *	Caller must hold the reference count of @device.
> + *
>   *	Asynchronous variant of request_firmware() for user contexts where
> - *	it is not possible to sleep for long time. It can't be called
> - *	in atomic contexts.
> + *	it is not possible to sleep for long time.

Let's state it explicitly:

	"it is not allowed to sleep for it is called in atomic context."

>   **/
>  int
>  request_firmware_nowait(
> @@ -844,6 +848,7 @@ request_firmware_nowait(
>  		return -EFAULT;
>  	}
>  
> +	get_device(fw_work->device);
>  	INIT_WORK(&fw_work->work, request_firmware_work_func);
>  	schedule_work(&fw_work->work);
>  	return 0;

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
