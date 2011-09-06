Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab1IFExu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 00:53:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36505 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab1IFExp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 00:53:45 -0400
Subject: Re: [PATCHv4] UBI: new module ubiblk: block layer on top of UBI
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: david.wagner@free-electrons.com
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Tim Bird <tim.bird@am.sony.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Tue, 06 Sep 2011 07:55:59 +0300
In-Reply-To: <1314202540-5562-1-git-send-email-david.wagner@free-electrons.com>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
	 <1314202540-5562-1-git-send-email-david.wagner@free-electrons.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1315284965.19067.57.camel@sauron>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 18:15 +0200, david.wagner@free-electrons.com
wrote:
>  g checkpatch'd (it still complains about an assignment in an if ()), is it
>    really bad ?

Well, UBI does not do this, so for the sake of consistent style you
could fix those warnings.

> about e), I have a question: it was possible to unmount a mounted filesystem
> because ot this.  The fix we found was to return -EBUSY if the ubiblk device is
> opened. But is it correct to assume that a mounted filesystem will always hold
> the device opened ?  If not, what is the correct way to impeach the removal of a
> ubiblk device when it is "mounted" ?

Once the block device is referenced (refcound is not zero), you should
open the underlying UBI volume (in write mode). And you close it only
when the block device's reference count becomes zero, just like gluebi
does this. So you need to enhance your ubiblk_open() and release
functions.

This should make sure that no one can remove the underlying UBI volume
when the corresponding ubiblk device is being used (e.g., mounted).

> (see ubiblk_remove(), if (dev->desc))
> 
> 	other questions:
> is it ok not to return the error value from the notify function ? I found now
> way to return an error value w/o stopping the notifications from being emitted.
> 
> there are error messages printed when a ubiblk_remove() is attempted on a
> non-existing device - that happens a lot when a UBI device is detached ; should
> the messages be debug-only (or even removed) ?

Not sure I got the question, is this an error situation? I see the
following possibilities:

1. UBI volume ubiX_Y is not used by ubiblk at all -> no issues
2. UBI volume ubiX_Y is has corresponding device ubiblkA, which is
   unused, so UBI volume can be removed, which causes a notifier,
   which removes ubiblkA.
3. ubiX_Y has corresponding ubiblkA, which is used, which means ubiX_Y
   is still open, which means it cannot be removed, no issues.

> +/**
> + * ubi_ubiblk_init - initialize the module
> + *
> + * Get a major number and register to UBI notifications ; register the ioctl
> + * handler device
> + */
> +static int __init ubi_ubiblk_init(void)
> +{
> +	int ret = 0;
> +
> +	ret = register_blkdev(0, "ubiblk");
> +	if (ret <= 0) {
> +		pr_err("can't register the major\n");

Not very user-friendly message - I do not think it is very readable and
easy to understand. Saying "cannot register block device" would be
readable. But I'd better just not print anything. And the function
internally has some error-path prints.

> +		return -ENODEV;

Why do you override the error code returned by 'register_blkdev()'?

> +	}
> +	ubiblk_major = ret;
> +
> +	mutex_init(&devlist_lock);

Isn't it cleaner to initialize the global mutex when declaring it -
there is a macros to do this?

> +
> +	ret = misc_register(&ctrl_dev);
> +	if (ret) {
> +		pr_err("can't register control device\n");
> +		goto out_unreg_blk;
> +	}
> +
> +	ret = ubi_register_volume_notifier(&ubiblk_notifier, 1);
> +	if (ret < 0)
> +		goto out_unreg_ctrl;
> +
> +	pr_info("major=%d\n", ubiblk_major);

Please, print something nicer, e.g.,

"control device major number is %d"

> +
> +	return ret;
> +
> +out_unreg_ctrl:
> +	misc_deregister(&ctrl_dev);
> +out_unreg_blk:
> +	unregister_blkdev(ubiblk_major, "ubiblk");
> +
> +	return ret;
> +}

-- 
Best Regards,
Artem Bityutskiy

