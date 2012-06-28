Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab2F1SQu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 14:16:50 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:65113 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab2F1SQt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 14:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <201206072359.43707.arnd@arndb.de>
References: <1339075302.3279.14.camel@lappy> <201206072359.43707.arnd@arndb.de>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Thu, 28 Jun 2012 20:16:28 +0200
Message-ID: <CA+1xoqdaGfim-P229V2i0BwSX1kOMnQWyB9NTvFWE9MdPWiPzQ@mail.gmail.com>
Subject: Re: lp: hung task in lp_open
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This seems to be doing the trick, thanks!

Sorry for the delay.

On Fri, Jun 8, 2012 at 1:59 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Thursday 07 June 2012, Sasha Levin wrote:
>> This appears to be happening since we can block on port open, which
>> is done within the mutex lock, so that any further lp_open calls with
>> appear to be "hung" on that mutex.
>>
>> That mutex was added there as part of BKL cleanup.
>>
>> I'm not sure whether the solution here is to get the lock just on the
>> parts which need locking, or add it as an exception to the hung task monitor.
>
> Hmm, does the hung task detector only trigger because this is an
> uninterruptible sleep? Does this fix it?
>
> 8<------
> lp: use only one per-port mutex
>
> Different stages of the BKL removal in the lp driver have taken different
> approaches: the earlier read/write conversion used a new per-port mutex,
> while the later open and ioctl conversion used a global mutex and
> did an uninterruptible sleep, which causes tasks to hang when multiple
> ones try to open any device. Using mutex_lock_interruptible lets the
> user stop waiting for a device that is already open and decouples the
> devices from one another.
>
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/drivers/char/lp.c b/drivers/char/lp.c
> index a741e41..0fcb197 100644
> --- a/drivers/char/lp.c
> +++ b/drivers/char/lp.c
> @@ -493,11 +493,12 @@ static int lp_open(struct inode * inode, struct file * file)
>        unsigned int minor = iminor(inode);
>        int ret = 0;
>
> -       mutex_lock(&lp_mutex);
> -       if (minor >= LP_NO) {
> -               ret = -ENXIO;
> -               goto out;
> -       }
> +       if (minor >= LP_NO)
> +               return -ENXIO;
> +
> +       if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
> +               return -ERESTARTSYS;
> +
>        if ((LP_F(minor) & LP_EXIST) == 0) {
>                ret = -ENXIO;
>                goto out;
> @@ -554,7 +555,7 @@ static int lp_open(struct inode * inode, struct file * file)
>        lp_release_parport (&lp_table[minor]);
>        lp_table[minor].current_mode = IEEE1284_MODE_COMPAT;
>  out:
> -       mutex_unlock(&lp_mutex);
> +       mutex_unlock(&lp_table[minor].port_mutex);
>        return ret;
>  }
>
> @@ -680,7 +681,8 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
>        int ret;
>
>        minor = iminor(file->f_path.dentry->d_inode);
> -       mutex_lock(&lp_mutex);
> +       if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
> +               return -ERESTARTSYS;
>        switch (cmd) {
>        case LPSETTIMEOUT:
>                if (copy_from_user(&par_timeout, (void __user *)arg,
> @@ -694,7 +696,7 @@ static long lp_ioctl(struct file *file, unsigned int cmd,
>                ret = lp_do_ioctl(minor, cmd, arg, (void __user *)arg);
>                break;
>        }
> -       mutex_unlock(&lp_mutex);
> +       mutex_unlock(&lp_table[minor].port_mutex);
>
>        return ret;
>  }
> @@ -708,7 +710,8 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
>        int ret;
>
>        minor = iminor(file->f_path.dentry->d_inode);
> -       mutex_lock(&lp_mutex);
> +       if (mutex_lock_interruptible(&lp_table[minor].port_mutex))
> +               return -ERESTARTSYS;
>        switch (cmd) {
>        case LPSETTIMEOUT:
>                if (compat_get_timeval(&par_timeout, compat_ptr(arg))) {
> @@ -727,7 +730,7 @@ static long lp_compat_ioctl(struct file *file, unsigned int cmd,
>                ret = lp_do_ioctl(minor, cmd, arg, compat_ptr(arg));
>                break;
>        }
> -       mutex_unlock(&lp_mutex);
> +       mutex_unlock(&lp_table[minor].port_mutex);
>
>        return ret;
>  }
