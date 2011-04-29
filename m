Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337Ab1D2Xed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 19:34:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759106Ab1D2Xea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 19:34:30 -0400
Date: Fri, 29 Apr 2011 16:28:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@suse.de>
Subject: Re: Allow setting of number of raw devices as a module parameter
Message-Id: <20110429162817.2eb26efb.akpm@linux-foundation.org>
In-Reply-To: <1304029469-19672-1-git-send-email-jack@suse.cz>
References: <1304029469-19672-1-git-send-email-jack@suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 00:24:29 +0200
Jan Kara <jack@suse.cz> wrote:

> Allow setting of maximal number of raw devices as a module parameter. This
> requires changing of static array into a vmalloced one (the array is going to
> be too large for kmalloc).
> 

Changelog failed to describe why the patch is needed.  Lacking that
information, we have no reason to apply it.

> +static int max_raw_minors = MAX_RAW_MINORS;

I suppose we could remove MAX_RAW_MINORS and use CONFIG_MAX_RAW_DEVS
directly.

> +
> +module_param(max_raw_minors, int, 0);
> +MODULE_PARM_DESC(max_raw_minors, "Maximum number of raw devices (1-65536)");
> +
>  /*
>   * Open/close code for raw IO.
>   *
> @@ -131,7 +137,7 @@ static int bind_set(int number, u64 majo
>  	struct raw_device_data *rawdev;
>  	int err = 0;
>  
> -	if (number <= 0 || number >= MAX_RAW_MINORS)
> +	if (number <= 0 || number >= max_raw_minors)
>  		return -EINVAL;
>  
>  	if (MAJOR(dev) != major || MINOR(dev) != minor)
> @@ -318,12 +324,26 @@ static int __init raw_init(void)
>  	dev_t dev = MKDEV(RAW_MAJOR, 0);
>  	int ret;
>  
> -	ret = register_chrdev_region(dev, MAX_RAW_MINORS, "raw");
> +	if (max_raw_minors < 1 || max_raw_minors > 65536) {
> +		printk(KERN_WARNING "raw: invalid max_raw_minors (must be"
> +			" between 1 and 65536), using %d\n", MAX_RAW_MINORS);
> +		max_raw_minors = MAX_RAW_MINORS;
> +	}
> +
> +	raw_devices = vmalloc(sizeof(struct raw_device_data) * max_raw_minors);
> +	if (!raw_devices) {
> +		printk(KERN_ERR "Not enough memory for raw device structures\n");
> +		ret = -ENOMEM;
> +		goto error;
> +	}
> +	memset(raw_devices, 0, sizeof(struct raw_device_data) * max_raw_minors);

vzalloc().


