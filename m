Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0INUj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 16:39:57 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:58824 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab0INUjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 16:39:55 -0400
Message-id: <4C8FDD8A.8090009@acm.org>
Date: Tue, 14 Sep 2010 15:39:38 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 4/7] ipmi: autoconvert trivial BKL users to private mutex
References: <1284494022-7346-1-git-send-email-arnd@arndb.de>
 <1284494022-7346-5-git-send-email-arnd@arndb.de>
In-reply-to: <1284494022-7346-5-git-send-email-arnd@arndb.de>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is good with me.

Acked-by: Corey Minyard <cminyard@mvista.com>

On 09/14/2010 02:53 PM, Arnd Bergmann wrote:
> All these files use the big kernel lock in a trivial
> way to serialize their private file operations,
> typically resulting from an earlier semi-automatic
> pushdown from VFS.
>
> None of these drivers appears to want to lock against
> other code, and they all use the BKL as the top-level
> lock in their file operations, meaning that there
> is no lock-order inversion problem.
>
> Consequently, we can remove the BKL completely,
> replacing it with a per-file mutex in every case.
> Using a scripted approach means we can avoid
> typos.
>
> file=$1
> name=$2
> if grep -q lock_kernel ${file} ; then
>      if grep -q 'include.*linux.mutex.h' ${file} ; then
>              sed -i '/include.*<linux\/smp_lock.h>/d' ${file}
>      else
>              sed -i 's/include.*<linux\/smp_lock.h>.*$/include<linux\/mutex.h>/g' ${file}
>      fi
>      sed -i ${file} \
>          -e "/^#include.*linux.mutex.h/,$ {
>                  1,/^\(static\|int\|long\)/ {
>                       /^\(static\|int\|long\)/istatic DEFINE_MUTEX(${name}_mutex);
>
> } }"  \
>      -e "s/\(un\)*lock_kernel\>[ ]*()/mutex_\1lock(\&${name}_mutex)/g" \
>      -e '/[      ]*cycle_kernel_lock();/d'
> else
>      sed -i -e '/include.*\<smp_lock.h\>/d' ${file}  \
>                  -e '/cycle_kernel_lock()/d'
> fi
>
> Signed-off-by: Arnd Bergmann<arnd@arndb.de>
> Cc: Corey Minyard<minyard@acm.org>
> Cc: openipmi-developer@lists.sourceforge.net
> ---
>   drivers/char/ipmi/ipmi_devintf.c  |   14 +++++++-------
>   drivers/char/ipmi/ipmi_watchdog.c |    8 ++++----
>   2 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/char/ipmi/ipmi_devintf.c b/drivers/char/ipmi/ipmi_devintf.c
> index d8ec92a..44833de 100644
> --- a/drivers/char/ipmi/ipmi_devintf.c
> +++ b/drivers/char/ipmi/ipmi_devintf.c
> @@ -44,7 +44,6 @@
>   #include<linux/init.h>
>   #include<linux/device.h>
>   #include<linux/compat.h>
> -#include<linux/smp_lock.h>
>
>   struct ipmi_file_private
>   {
> @@ -59,6 +58,7 @@ struct ipmi_file_private
>   	unsigned int         default_retry_time_ms;
>   };
>
> +static DEFINE_MUTEX(ipmi_mutex);
>   static void file_receive_handler(struct ipmi_recv_msg *msg,
>   				 void                 *handler_data)
>   {
> @@ -102,9 +102,9 @@ static int ipmi_fasync(int fd, struct file *file, int on)
>   	struct ipmi_file_private *priv = file->private_data;
>   	int                      result;
>
> -	lock_kernel(); /* could race against open() otherwise */
> +	mutex_lock(&ipmi_mutex); /* could race against open() otherwise */
>   	result = fasync_helper(fd, file, on,&priv->fasync_queue);
> -	unlock_kernel();
> +	mutex_unlock(&ipmi_mutex);
>
>   	return (result);
>   }
> @@ -125,7 +125,7 @@ static int ipmi_open(struct inode *inode, struct file *file)
>   	if (!priv)
>   		return -ENOMEM;
>
> -	lock_kernel();
> +	mutex_lock(&ipmi_mutex);
>   	priv->file = file;
>
>   	rv = ipmi_create_user(if_num,
> @@ -150,7 +150,7 @@ static int ipmi_open(struct inode *inode, struct file *file)
>   	priv->default_retry_time_ms = 0;
>
>   out:
> -	unlock_kernel();
> +	mutex_unlock(&ipmi_mutex);
>   	return rv;
>   }
>
> @@ -639,9 +639,9 @@ static long ipmi_unlocked_ioctl(struct file   *file,
>   {
>   	int ret;
>
> -	lock_kernel();
> +	mutex_lock(&ipmi_mutex);
>   	ret = ipmi_ioctl(file, cmd, data);
> -	unlock_kernel();
> +	mutex_unlock(&ipmi_mutex);
>
>   	return ret;
>   }
> diff --git a/drivers/char/ipmi/ipmi_watchdog.c b/drivers/char/ipmi/ipmi_watchdog.c
> index 654d566..ed10b74 100644
> --- a/drivers/char/ipmi/ipmi_watchdog.c
> +++ b/drivers/char/ipmi/ipmi_watchdog.c
> @@ -35,7 +35,7 @@
>   #include<linux/moduleparam.h>
>   #include<linux/ipmi.h>
>   #include<linux/ipmi_smi.h>
> -#include<linux/smp_lock.h>
> +#include<linux/mutex.h>
>   #include<linux/watchdog.h>
>   #include<linux/miscdevice.h>
>   #include<linux/init.h>
> @@ -149,6 +149,7 @@
>   #define	WDIOC_GET_PRETIMEOUT     _IOW(WATCHDOG_IOCTL_BASE, 22, int)
>   #endif
>
> +static DEFINE_MUTEX(ipmi_watchdog_mutex);
>   static int nowayout = WATCHDOG_NOWAYOUT;
>
>   static ipmi_user_t watchdog_user;
> @@ -748,9 +749,9 @@ static long ipmi_unlocked_ioctl(struct file *file,
>   {
>   	int ret;
>
> -	lock_kernel();
> +	mutex_lock(&ipmi_watchdog_mutex);
>   	ret = ipmi_ioctl(file, cmd, arg);
> -	unlock_kernel();
> +	mutex_unlock(&ipmi_watchdog_mutex);
>
>   	return ret;
>   }
> @@ -844,7 +845,6 @@ static int ipmi_open(struct inode *ino, struct file *filep)
>   		if (test_and_set_bit(0,&ipmi_wdog_open))
>   			return -EBUSY;
>
> -		cycle_kernel_lock();
>
>   		/*
>   		 * Don't start the timer now, let it start on the
>    

