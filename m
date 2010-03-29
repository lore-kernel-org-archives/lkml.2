Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0C2NeG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:34:06 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:42909 "EHLO
	mx01.colomx.prod.int.phx2.redhat.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910Ab0C2NeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:34:05 -0400
Date: Mon, 29 Mar 2010 09:33:42 -0400 (EDT)
From: John Kacur <jkacur@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jan Blunck <jblunck@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Message-ID: <1383519680.42441269869622199.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1269866171-7331-2-git-send-email-jkacur@redhat.com>
Subject: Re: [PATCH] nvram: Convert nvram_ioctl to unlocked_ioctl, remove
 smp_lock.h
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.71]
X-Mailer: Zimbra 5.0.21_GA_3150.RHEL4_64 (ZimbraWebClient - FF3.0 (Linux)/5.0.21_GA_3150.RHEL4_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "John Kacur" <jkacur@redhat.com> wrote:

> After removing the BKL from open, we can also convert nvram_ioctl to
> an unlocked_ioctl. It has it's only spin_lock, and doesn't rely on the
> BKL
> 
> This file no longer uses the BKL so smp_lock.h can be removed.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  drivers/char/nvram.c |   18 ++++++++----------
>  1 files changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
> index 5eb83c3..0c3ba6a 100644
> --- a/drivers/char/nvram.c
> +++ b/drivers/char/nvram.c
> @@ -110,7 +110,6 @@
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
>  #include <linux/uaccess.h>
> -#include <linux/smp_lock.h>
>  
>  #include <asm/system.h>
>  
> @@ -297,8 +296,7 @@ checksum_err:
>  	return -EIO;
>  }
>  
> -static int nvram_ioctl(struct inode *inode, struct file *file,
> -					unsigned int cmd, unsigned long arg)
> +static long nvram_ioctl(struct file *file, unsigned int cmd, unsigned
> long arg)
>  {
>  	int i;
>  
> @@ -419,13 +417,13 @@ static int nvram_add_proc_fs(void)
>  #endif /* CONFIG_PROC_FS */
>  
>  static const struct file_operations nvram_fops = {
> -	.owner		= THIS_MODULE,
> -	.llseek		= nvram_llseek,
> -	.read		= nvram_read,
> -	.write		= nvram_write,
> -	.ioctl		= nvram_ioctl,
> -	.open		= nvram_open,
> -	.release	= nvram_release,
> +	.owner			= THIS_MODULE,
> +	.llseek			= nvram_llseek,
> +	.read			= nvram_read,
> +	.write			= nvram_write,
> +	.unlocked_ioctl		= nvram_ioctl,
> +	.open			= nvram_open,
> +	.release		= nvram_release,
>  };
>  
>  static struct miscdevice nvram_dev = {
> -- 
> 1.6.0.6

Sorry for the double send, I must have messed-up something with
git-send-email. The --compose failed on me, and that part of the message was
lost afaict.

What I wanted to say was, Ingo, in the past you carried nvram fixes, so
if no-one objects to this change, can you integrate this one?

This did have a curiosity in the history. It seems that Linus's tree had the
remove smp_lock.h patch before the patch to remove BKL hit his tree. So
I combined that little bit with my previous patch that turns this into
an unlocked ioctl. (resend of http://lkml.indiana.edu/hypermail/linux/kernel/0910.2/01608.html)

Thanks

John
