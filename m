Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab0IXKyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 06:54:46 -0400
Received: from www.tglx.de ([62.245.132.106]:44257 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139Ab0IXKyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 06:54:45 -0400
Date: Fri, 24 Sep 2010 12:55:56 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] uio: Implement hotunplug support, using libunload
Message-ID: <20100924105555.GD1819@silverbox.local>
References: <m1y6b48973.fsf@fess.ebiederm.org>
 <20100917205946.GF2522@local>
 <m139t451b4.fsf_-_@fess.ebiederm.org>
 <m1eico3mjg.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1eico3mjg.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 12:24:19AM -0700, Eric W. Biederman wrote:
> 
>  }
>  
>  static ssize_t uio_read(struct file *filep, char __user *buf,
>  			size_t count, loff_t *ppos)
>  {
>  	struct uio_listener *listener = filep->private_data;
> -	struct uio_device *idev = listener->dev;
> +	struct uio_device *idev = listener_idev(listener);
>  	DECLARE_WAITQUEUE(wait, current);
>  	ssize_t retval;
>  	s32 event_count;
>  
> -	if (!idev->info->irq)
> +	if (!unload_trylock(&idev->unload))
>  		return -EIO;
>  
> +	retval = -EIO;
> +	if (!idev->info->irq)
> +		goto out;
> +
> +	retval = -EIO;
>  	if (count != sizeof(s32))
> -		return -EINVAL;
> +		goto out;

No. uio_read() should return -EINVAL if count != sizeof(s32). This is
simply wrong userspace code that passes in an illegal value, so it's
not an IO error but an invalid parameter.
BTW, you use -EINVAL in the same situation in uio_write()...

>  
>  	add_wait_queue(&idev->wait, &wait);
>  
> @@ -550,12 +586,21 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
>  			retval = -ERESTARTSYS;
>  			break;
>  		}
> +		unload_unlock(&idev->unload);
> +
>  		schedule();
> +
> +		if (!unload_trylock(&idev->unload)) {
> +			retval = -EIO;
> +			break;
> +		}
>  	} while (1);
>  
>  	__set_current_state(TASK_RUNNING);
>  	remove_wait_queue(&idev->wait, &wait);
>  
> +out:
> +	unload_unlock(&idev->unload);
>  	return retval;
>  }
>  
> @@ -563,24 +608,33 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
>  			size_t count, loff_t *ppos)
>  {
>  	struct uio_listener *listener = filep->private_data;
> -	struct uio_device *idev = listener->dev;
> +	struct uio_device *idev = listener_idev(listener);
>  	ssize_t retval;
>  	s32 irq_on;
>  
> -	if (!idev->info->irq)
> +	if (!unload_trylock(&idev->unload))
>  		return -EIO;
>  
> +	retval = -EIO;
> +	if (!idev->info->irq)
> +		goto out;
> +
> +	retval = -EINVAL;
>  	if (count != sizeof(s32))
> -		return -EINVAL;
> +		goto out;
>  
> +	retval = -ENOSYS;
>  	if (!idev->info->irqcontrol)
> -		return -ENOSYS;
> +		goto out;
>  
> +	retval = -EFAULT;
>  	if (copy_from_user(&irq_on, buf, count))
> -		return -EFAULT;
> +		goto out;
>  
>  	retval = idev->info->irqcontrol(idev->info, irq_on);
>  
> +out:
> +	unload_unlock(&idev->unload);
>  	return retval ? retval : sizeof(s32);
>  }
