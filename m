Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab2BHQaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:30:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754489Ab2BHQaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:30:10 -0500
Date: Wed, 8 Feb 2012 11:30:07 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, seiji.aguchi@hds.com, dzickus@redhat.com
Subject: Re: [PATCH] kmsg_dump: Don't run on non-error paths by default
Message-ID: <20120208163007.GA19323@redhat.com>
References: <1328717646-17121-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328717646-17121-1-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 11:14:06AM -0500, Matthew Garrett wrote:

[..]
> +/*
> + * Keep this list arranged in rough order of priority. Anything listed after
> + * KMSG_DUMP_OOPS will not be logged by default unless printk.always_kmsg_dump
> + * is passed to the kernel.
> + */
>  enum kmsg_dump_reason {
> -	KMSG_DUMP_OOPS,
>  	KMSG_DUMP_PANIC,
> +	KMSG_DUMP_OOPS,
> +	KMSG_DUMP_EMERG,
>  	KMSG_DUMP_RESTART,
>  	KMSG_DUMP_HALT,
>  	KMSG_DUMP_POWEROFF,
> -	KMSG_DUMP_EMERG,
>  };
>  
>  /**
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 13c0a11..e7d07f5 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -702,6 +702,9 @@ static bool printk_time = 0;
>  #endif
>  module_param_named(time, printk_time, bool, S_IRUGO | S_IWUSR);
>  
> +static bool always_kmsg_dump;
> +module_param_named(always_kmsg_dump, always_kmsg_dump, bool, S_IRUGO | S_IWUSR);
> +
>  /* Check if we have any console registered that can be called early in boot. */
>  static int have_callable_console(void)
>  {
> @@ -1732,6 +1735,9 @@ void kmsg_dump(enum kmsg_dump_reason reason)
>  	unsigned long l1, l2;
>  	unsigned long flags;
>  
> +	if (reason > KMSG_DUMP_PANIC && !always_kmsg_dump)
> +		return;

Did you mean reason > KMSG_DUMP_OOPS to enable oops logging by default?
 
Given the fact that not everybody likes kmsg_dump() and it is not known
how stable it with various backends, will it make sense to keep it disabled
by default and provide a knob to enable it (instead of always_kmsg_dump).

Thanks
Vivek
