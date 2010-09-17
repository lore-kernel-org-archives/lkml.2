Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab0IQUg4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 16:36:56 -0400
Received: from www.tglx.de ([62.245.132.106]:35444 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752657Ab0IQUgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 16:36:55 -0400
Date: Fri, 17 Sep 2010 22:36:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] uio: Support 2^MINOR_BITS minors
In-Reply-To: <m1eicw892p.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1009172235490.2416@localhost6.localdomain6>
References: <m1y6b48973.fsf@fess.ebiederm.org> <m1eicw892p.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Sep 2010, Eric W. Biederman wrote:

> 
> register_chrdev limits uio devices to 256 minor numbers which causes
> problems on one system I have with 384+ uio devices.  So instead set
> UIO_MAX_DEVICES to the maximum number of minors and use
> alloc_chrdev_region to reserve the uio minors.
> 
> The final result is that the code works the same but the uio driver now
> supports any minor the idr allocator comes up with.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>

One minor nit:

> +	result = alloc_chrdev_region(&uio_dev, 0, UIO_MAX_DEVICES, name);
> +	if (result)
> +		goto out;

  		return result;

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

> +
> +	result = -ENOMEM;
> +	cdev = cdev_alloc();
> +	if (!cdev)
> +		goto out_unregister;
> +
> +	cdev->owner = THIS_MODULE;
> +	cdev->ops = &uio_fops;
> +	kobject_set_name(&cdev->kobj, "%s", name);
> +
> +	result = cdev_add(cdev, uio_dev, UIO_MAX_DEVICES);
> +	if (result)
> +		goto out_put;
> +
> +	uio_major = MAJOR(uio_dev);
> +	uio_cdev = cdev;
> +	result = 0;
> +out:
> +	return result;
> +out_put:
> +	kobject_put(&cdev->kobj);
> +out_unregister:
> +	unregister_chrdev_region(uio_dev, UIO_MAX_DEVICES);
> +	goto out;
>  }
>  
>  static void uio_major_cleanup(void)
>  {
> -	unregister_chrdev(uio_major, "uio");
> +	unregister_chrdev_region(MKDEV(uio_major, 0), UIO_MAX_DEVICES);
> +	cdev_del(uio_cdev);
>  }
>  
>  static int init_uio_class(void)
> -- 
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
