Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001Ab2KDX5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 18:57:20 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:60734 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab2KDX5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 18:57:17 -0500
Message-ID: <509700D7.1010809@gmail.com>
Date: Mon, 05 Nov 2012 10:57:11 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Luca Clementi <luca.clementi@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Brian Swetland <swetland@google.com>
Subject: Re: [PATCH] Staging: Android: logger: module_exit implementation
References: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
In-Reply-To: <1351836952-3389-1-git-send-email-luca.clementi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/12 17:15, Luca Clementi wrote:
> Created the module_exit for the android logger so that
> it can be loaded and unloaded as a module. Fixed
> module_init and some other minor issues.
> 
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

ret is undeclared? Has this been tested?

> +		if (unlikely(ret)) {
> +			pr_err("failed to deregister misc device for log '%s'!\n",
> +					current_log->misc.name);
> +		}

Don't need braces on single line if statements, and unlikely is not
needed here (it isn't a hotpath). The whole error can probably just be
removed since it looks like misc_deregister already does a WARN_ON if it
fails.

> +		pr_info("removed loggger '%s'\n", current_log->misc.name);

Don't spam the log with stuff like this. Either change to pr_debug, or
probably just remove it.

> +		vfree(current_log->buffer);
> +		kfree(current_log->misc.name);
> +		kfree(current_log);

Missing:

	list_del(&current_log->logs);

?

> +	}
> +
> +	return;

This is pointless.

> +}
> +
> +
> +module_init(logger_init);
> +module_exit(logger_exit);

Nitpick - Blank line here.

> +MODULE_LICENSE("GPL");
> +MODULE_AUTHOR("Brian Swetland, <swetland@google.com>");

Should be Robert Love according to the header comment.

> +MODULE_DESCRIPTION("Android Logger");
> +
> +

Don't need extra blank lines at the end of the file.

~Ryan

