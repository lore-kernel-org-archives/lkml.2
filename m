Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751755Ab0D1MYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 08:24:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43167 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab0D1MYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 08:24:49 -0400
Message-ID: <4BD82905.2020408@infradead.org>
Date: Wed, 28 Apr 2010 09:24:37 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: John Kacur <jkacur@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH 10/10] bkl: Fix-up compile problems as a result of the
 bkl-pushdown.
References: <1272359898-32020-1-git-send-email-jkacur@redhat.com> <201004271317.45503.arnd@arndb.de> <alpine.LFD.2.00.1004271352510.3318@localhost> <201004271503.18077.arnd@arndb.de>
In-Reply-To: <201004271503.18077.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Arnd Bergmann wrote:
> On Tuesday 27 April 2010, John Kacur wrote:
>> Well it is certainly possible that my fixup is not correct too - your 
>> patch cannot be correct, because it doesn't compile! Here is what I get 
>> when I apply your patch to a recent linus/master
> 
> Ah, I see.
> 
>> make O=/bld/arnd/ drivers/media/video/v4l2-dev.o
>> -----CUT A BUNCH OF STUFF OUT ---
>>   CC      drivers/media/video/v4l2-dev.o
>> /home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c: In function 
>> ‘v4l2_ioctl’:
>> /home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: warning: passing 
>> argument 1 of ‘vdev->fops->ioctl’ from incompatible pointer type
>> /home/jkacur/jk-2.6/drivers/media/video/v4l2-dev.c:230: note: expected 
>> ‘struct file *’ but argument is of type ‘struct inode *’
> 
> I didn't realize that the prototype for the locked ->ioctl function in
> v4l2 does not take the inode argument, so that needs to be dropped from
> my patch (i.e. not added).
> 
> Or we do it slightly better and clean up the code a bit in the process.
> 
> Mauro, does this patch make sense to you? It would be good to have your
> Ack so we can queue this in the series leading to the removal of the
> ->ioctl file operation. We can also do the minimal change and let you
> take care of fixing this up in a different way in your own tree.

We had a similar discussion a while ago at linux-media. The idea is to do
it on a deeper level, changing the drivers to not need to use KBL.
Hans is working on those patches. Not sure about the current status.

Anyway, I think that the better is to apply first your patch, to avoid
breaking your patch series, and then ours, as we may otherwise have some 
conflicts between your tree and drivers/media git tree.

So,

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> ---
> Subject: v4l: convert v4l2-dev to unlocked_ioctl
> 
> v4l2 implements two separate file operations for drivers that use locked
> and unlocked ioctl callbacks. Since we want to remove the ioctl file operation
> in favor of the unlocked variant, this separation no longer seems helpful.
> 
> Unfortunately, there are still 77 drivers with locked ioctl functions in
> their v4l2_file_operations, which need to be taken care of separately.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/media/video/v4l2-dev.c |   52 +++++++++++----------------------------
>  1 files changed, 15 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/media/video/v4l2-dev.c b/drivers/media/video/v4l2-dev.c
> index 7090699..ab198ba 100644
> --- a/drivers/media/video/v4l2-dev.c
> +++ b/drivers/media/video/v4l2-dev.c
> @@ -25,6 +25,7 @@
>  #include <linux/init.h>
>  #include <linux/kmod.h>
>  #include <linux/slab.h>
> +#include <linux/smp_lock.h>
>  #include <asm/uaccess.h>
>  #include <asm/system.h>
>  
> @@ -215,28 +216,24 @@ static unsigned int v4l2_poll(struct file *filp, struct poll_table_struct *poll)
>  	return vdev->fops->poll(filp, poll);
>  }
>  
> -static int v4l2_ioctl(struct inode *inode, struct file *filp,
> -		unsigned int cmd, unsigned long arg)
> +static long v4l2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  {
>  	struct video_device *vdev = video_devdata(filp);
> +	int ret;
>  
> -	if (!vdev->fops->ioctl)
> -		return -ENOTTY;
>  	/* Allow ioctl to continue even if the device was unregistered.
>  	   Things like dequeueing buffers might still be useful. */
> -	return vdev->fops->ioctl(filp, cmd, arg);
> -}
> -
> -static long v4l2_unlocked_ioctl(struct file *filp,
> -		unsigned int cmd, unsigned long arg)
> -{
> -	struct video_device *vdev = video_devdata(filp);
> +	if (vdev->fops->unlocked_ioctl) {
> +		ret = vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +	} else if (vdev->fops->ioctl) {
> +		/* TODO: convert all drivers to unlocked_ioctl */
> +		lock_kernel();
> +		ret = vdev->fops->ioctl(filp, cmd, arg);
> +		unlock_kernel();
> +	} else 
> +		ret = -ENOTTY;
>  
> -	if (!vdev->fops->unlocked_ioctl)
> -		return -ENOTTY;
> -	/* Allow ioctl to continue even if the device was unregistered.
> -	   Things like dequeueing buffers might still be useful. */
> -	return vdev->fops->unlocked_ioctl(filp, cmd, arg);
> +	return ret;
>  }
>  
>  #ifdef CONFIG_MMU
> @@ -307,22 +304,6 @@ static int v4l2_release(struct inode *inode, struct file *filp)
>  	return ret;
>  }
>  
> -static const struct file_operations v4l2_unlocked_fops = {
> -	.owner = THIS_MODULE,
> -	.read = v4l2_read,
> -	.write = v4l2_write,
> -	.open = v4l2_open,
> -	.get_unmapped_area = v4l2_get_unmapped_area,
> -	.mmap = v4l2_mmap,
> -	.unlocked_ioctl = v4l2_unlocked_ioctl,
> -#ifdef CONFIG_COMPAT
> -	.compat_ioctl = v4l2_compat_ioctl32,
> -#endif
> -	.release = v4l2_release,
> -	.poll = v4l2_poll,
> -	.llseek = no_llseek,
> -};
> -
>  static const struct file_operations v4l2_fops = {
>  	.owner = THIS_MODULE,
>  	.read = v4l2_read,
> @@ -330,7 +311,7 @@ static const struct file_operations v4l2_fops = {
>  	.open = v4l2_open,
>  	.get_unmapped_area = v4l2_get_unmapped_area,
>  	.mmap = v4l2_mmap,
> -	.ioctl = v4l2_ioctl,
> +	.unlocked_ioctl = v4l2_ioctl,
>  #ifdef CONFIG_COMPAT
>  	.compat_ioctl = v4l2_compat_ioctl32,
>  #endif
> @@ -517,10 +498,7 @@ static int __video_register_device(struct video_device *vdev, int type, int nr,
>  		ret = -ENOMEM;
>  		goto cleanup;
>  	}
> -	if (vdev->fops->unlocked_ioctl)
> -		vdev->cdev->ops = &v4l2_unlocked_fops;
> -	else
> -		vdev->cdev->ops = &v4l2_fops;
> +	vdev->cdev->ops = &v4l2_fops;
>  	vdev->cdev->owner = vdev->fops->owner;
>  	ret = cdev_add(vdev->cdev, MKDEV(VIDEO_MAJOR, vdev->minor), 1);
>  	if (ret < 0) {


-- 

Cheers,
Mauro
