Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934591Ab2KBS3c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 14:29:32 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:34951 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759416Ab2KBS3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 14:29:30 -0400
Date: Fri, 2 Nov 2012 11:29:26 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luca Clementi <luca.clementi@gmail.com>
Cc: linux-kernel@vger.kernel.org, Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] Staging: Android: logger: module_exit implementationg
Message-ID: <20121102182926.GA18824@kroah.com>
References: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01, 2012 at 11:15:52PM -0700, Luca Clementi wrote:
> Created the module_exit for the android logger so that
> it can be loaded and unloaded as a module. Fixed
> module_init and some other minor issues.

That's doing more than one thing here at once, care to break it up?
Yeah, I know it seems funny for such a small patch, but it helps.

Also, now that you've added this, the logger driver still can't be built
as a module, as the build system isn't changed to let that happen,
right?

Also, why do you want to build this as a module?

> Signed-off-by: Luca Clementi <luca.clementi@gmail.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Brian Swetland <swetland@google.com>
> ---
>  drivers/staging/android/logger.c |   30 +++++++++++++++++++++++++++++-
>  1 file changed, 29 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
> index 1d5ed47..050be01 100644
> --- a/drivers/staging/android/logger.c
> +++ b/drivers/staging/android/logger.c
> @@ -676,4 +676,32 @@ static int __init logger_init(void)
>  out:
>  	return ret;
>  }
> -device_initcall(logger_init);
> +
> +static void __exit logger_exit(void)
> +{
> +	struct logger_log *current_log, *next_log;
> +
> +	list_for_each_entry_safe(current_log, next_log, &log_list, logs) {
> +		/* we have to delete all the entry inside log_list */
> +		ret = misc_deregister(&current_log->misc);
> +		if (unlikely(ret)) {
> +			pr_err("failed to deregister misc device for log '%s'!\n",
> +					current_log->misc.name);
> +		}
> +		pr_info("removed loggger '%s'\n", current_log->misc.name);

Is that message really needed?

> +		vfree(current_log->buffer);
> +		kfree(current_log->misc.name);
> +		kfree(current_log);
> +	}
> +
> +	return;
> +}
> +
> +
> +module_init(logger_init);

Is module_init() the same "level" as device_initcall()?  Did you test
this out in an Android system?

> +module_exit(logger_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Brian Swetland, <swetland@google.com>");
> +MODULE_DESCRIPTION("Android Logger");
> +
> +

What's with the unneeded trailing empty lines?

thanks,

greg k-h
