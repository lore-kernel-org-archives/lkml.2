Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab0GMI24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:28:56 -0400
Received: from exprod5og108.obsmtp.com ([64.18.0.186]:52269 "EHLO
	exprod5og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0GMI2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:28:55 -0400
Message-ID: <4C3C2387.3090900@ge.com>
Date: Tue, 13 Jul 2010 09:27:51 +0100
From: Martyn Welch <martyn.welch@ge.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: Re: [PATCH 01/12] staging: autoconvert trivial BKL users to private
 mutex
References: <1278883143-29035-1-git-send-email-arnd@arndb.de> <1278883143-29035-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1278883143-29035-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:

<snip>


> diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
> index bc16fc0..73a67a8 100644
> --- a/drivers/staging/vme/devices/vme_user.c
> +++ b/drivers/staging/vme/devices/vme_user.c
> @@ -31,7 +31,7 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/syscalls.h>
> -#include <linux/smp_lock.h>
> +#include <linux/mutex.h>
>  #include <linux/types.h>
>  
>  #include <asm/io.h>
> @@ -40,6 +40,7 @@
>  #include "../vme.h"
>  #include "vme_user.h"
>  
> +static DEFINE_MUTEX(vme_user_mutex);
>  static char driver_name[] = "vme_user";
>  
>  static int bus[USER_BUS_MAX];
> @@ -560,9 +561,9 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	int ret;
>  
> -	lock_kernel();
> +	mutex_lock(&vme_user_mutex);
>  	ret = vme_user_ioctl(file->f_path.dentry->d_inode, file, cmd, arg);
> -	unlock_kernel();
> +	mutex_unlock(&vme_user_mutex);
>   

Wha!, where'd that come from!!??

Ah, OK - "Staging: push down BKL into ioctl functions", missed that,
looks fine.
<http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=b1f2ac07636aadee5cb077fc7e830908b00fcaae>

Martyn
<http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sfr/linux-next.git;a=commitdiff;h=b1f2ac07636aadee5cb077fc7e830908b00fcaae>


>  
>  	return ret;
>  }
>   


-- 
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189

