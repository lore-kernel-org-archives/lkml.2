Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648Ab1LLPnd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 10:43:33 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:53796 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLPnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 10:43:31 -0500
Date: Mon, 12 Dec 2011 10:42:27 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Bastian Blank <waldi@debian.org>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] xen/xenbus-backend: Only register device if
 communication ring is local
Message-ID: <20111212154227.GB21558@phenom.dumpdata.com>
References: <1323541791-18006-1-git-send-email-waldi@debian.org>
 <1323541791-18006-7-git-send-email-waldi@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323541791-18006-7-git-send-email-waldi@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4EE6211A.005E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 07:29:51PM +0100, Bastian Blank wrote:
> Signed-off-by: Bastian Blank <waldi@debian.org>
> ---
>  drivers/xen/xenbus/Makefile             |    2 +-
>  drivers/xen/xenbus/xenbus_dev_backend.c |   13 ++-----------
>  drivers/xen/xenbus/xenbus_dev_backend.h |    2 ++
>  drivers/xen/xenbus/xenbus_probe.c       |   18 ++++++++++++++++++
>  4 files changed, 23 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/xen/xenbus/xenbus_dev_backend.h
> 
> diff --git a/drivers/xen/xenbus/Makefile b/drivers/xen/xenbus/Makefile
> index 31e2e90..d751f45 100644
> --- a/drivers/xen/xenbus/Makefile
> +++ b/drivers/xen/xenbus/Makefile
> @@ -7,8 +7,8 @@ xenbus-objs += xenbus_comms.o
>  xenbus-objs += xenbus_xs.o
>  xenbus-objs += xenbus_probe.o
>  
> +xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
>  xenbus-be-objs-$(CONFIG_XEN_BACKEND) += xenbus_probe_backend.o
>  xenbus-objs += $(xenbus-be-objs-y)
>  
> -obj-$(CONFIG_XEN_BACKEND) += xenbus_dev_backend.o
>  obj-$(CONFIG_XEN_XENBUS_FRONTEND) += xenbus_probe_frontend.o
> diff --git a/drivers/xen/xenbus/xenbus_dev_backend.c b/drivers/xen/xenbus/xenbus_dev_backend.c
> index a2092bd..fb87f1b 100644
> --- a/drivers/xen/xenbus/xenbus_dev_backend.c
> +++ b/drivers/xen/xenbus/xenbus_dev_backend.c
> @@ -3,7 +3,6 @@
>  #include <linux/mm.h>
>  #include <linux/fs.h>
>  #include <linux/miscdevice.h>
> -#include <linux/module.h>
>  #include <linux/capability.h>
>  
>  #include <xen/page.h>
> @@ -11,8 +10,6 @@
>  
>  #include "xenbus_comms.h"
>  
> -MODULE_LICENSE("GPL");
> -
>  static int xenbus_backend_open(struct inode *inode, struct file *filp)
>  {
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -67,23 +64,17 @@ static struct miscdevice xenbus_backend_dev = {
>  	.fops = &xenbus_backend_fops,
>  };
>  
> -static int __init xenbus_backend_init(void)
> +int __init xenbus_backend_init(void)
>  {
>  	int err;
>  
> -	if (!xen_initial_domain())
> -		return -ENODEV;
> -
>  	err = misc_register(&xenbus_backend_dev);
>  	if (err)
>  		printk(KERN_ERR "Could not register xenbus backend device\n");
>  	return err;
>  }
>  
> -static void __exit xenbus_backend_exit(void)
> +void __exit xenbus_backend_exit(void)
>  {
>  	misc_deregister(&xenbus_backend_dev);
>  }
> -
> -module_init(xenbus_backend_init);
> -module_exit(xenbus_backend_exit);

Why are we removing the module functionality?
Can't this [the purpose of this patch] be done while still maintaining the module functionality?

> diff --git a/drivers/xen/xenbus/xenbus_dev_backend.h b/drivers/xen/xenbus/xenbus_dev_backend.h
> new file mode 100644
> index 0000000..d986853
> --- /dev/null
> +++ b/drivers/xen/xenbus/xenbus_dev_backend.h
> @@ -0,0 +1,2 @@
> +int xenbus_backend_init(void);
> +void xenbus_backend_exit(void);
> diff --git a/drivers/xen/xenbus/xenbus_probe.c b/drivers/xen/xenbus/xenbus_probe.c
> index 1b178c6..4eff095 100644
> --- a/drivers/xen/xenbus/xenbus_probe.c
> +++ b/drivers/xen/xenbus/xenbus_probe.c
> @@ -60,6 +60,7 @@
>  #include <xen/hvm.h>
>  
>  #include "xenbus_comms.h"
> +#include "xenbus_dev_backend.h"
>  #include "xenbus_probe.h"
>  
>  
> @@ -641,6 +642,10 @@ EXPORT_SYMBOL_GPL(xenbus_dev_cancel);
>  /* A flag to determine if xenstored is 'ready' (i.e. has started) */
>  int xenstored_ready;
>  
> +/* A flag to determine if xenstored is 'local' */
> +#ifdef CONFIG_XEN_BACKEND
> +static int xenstored_local;

bool?

> +#endif
>  
>  int register_xenstore_notifier(struct notifier_block *nb)
>  {
> @@ -675,6 +680,14 @@ static int __init xenbus_probe_initcall(void)
>  	if (!xen_domain())
>  		return -ENODEV;
>  
> +#ifdef CONFIG_XEN_BACKEND
> +	if (xenstored_local) {
> +		int ret = xenbus_backend_init();
> +		if (ret)
> +			return ret;
> +	}
> +#endif
> +
>  	if (xen_initial_domain() || xen_hvm_domain())
>  		return 0;
>  
> @@ -747,9 +760,14 @@ static int __init xenbus_init(void)
>  		if (xen_store_evtchn)
>  			xenstored_ready = 1;
>  		else {
> +#ifdef CONFIG_XEN_BACKEND
> +			xenstored_local = 1;
>  			err = xenstored_local_init();
>  			if (err)
>  				goto out_error;
> +#else
> +			BUG();

No way. A WARN, sure - but BUG() is way too intense for this.

> +#endif
>  		}
>  		xen_store_interface = mfn_to_virt(xen_store_mfn);
>  	}
> -- 
> 1.7.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
