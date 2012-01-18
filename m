Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab2ARWGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 17:06:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2ARWGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 17:06:05 -0500
Date: Wed, 18 Jan 2012 14:06:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] ramoops: use pstore interface
Message-Id: <20120118140603.0fc22302.akpm@linux-foundation.org>
In-Reply-To: <20120117235852.GA4877@www.outflux.net>
References: <20120117235852.GA4877@www.outflux.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jan 2012 15:58:52 -0800
Kees Cook <keescook@chromium.org> wrote:

> Instead of using /dev/mem directly and forcing userspace to know (or
> extract) where the platform has defined persistent memory, how many
> slots it has, the sizes, etc, use the common pstore infrastructure to
> handle Oops gathering and extraction. This presents a much easier to
> use filesystem-based view to the memory region. This also means that any
> other tools that are written to understand pstore will automatically be
> able to process ramoops too.
> 
> ...
>
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -603,6 +603,7 @@ source "drivers/s390/char/Kconfig"
>  config RAMOOPS
>  	tristate "Log panic/oops to a RAM buffer"
>  	depends on HAS_IOMEM
> +	depends on PSTORE
>  	default n
>  	help
>  	  This enables panic and oops messages to be logged to a circular

I think this is the right thing to do, but boy I hate it.  You sit
there wondering "wtf do I need to enable so I can use feature X".  I
sometimes use menuconfig's search feature, other times go trawl the
Kconfig files.  There should be a capability in Kconfig to just turn on
the terminal feature, enabling any precondition features on the way. 
Everyone loves Kconfig.

>
> ...
>
>  static int __exit ramoops_remove(struct platform_device *pdev)
>  {
> +#if 0
> +	/* TODO(kees): We cannot unload ramoops since pstore doesn't support
> +	 * unregistering yet.
> +	 */

Well that sucks.  Is pstore getting fixed?

>  	struct ramoops_context *cxt = &oops_cxt;
>  
> -	if (kmsg_dump_unregister(&cxt->dump) < 0)
> -		pr_warn("could not unregister kmsg_dumper\n");
> -
>  	iounmap(cxt->virt_addr);
>  	release_mem_region(cxt->phys_addr, cxt->size);
> +	cxt->max_count = 0;
> +
> +	/* TODO(kees): When pstore supports unregistering, call it here. */
> +	kfree(cxt->pstore.buf);
> +	cxt->pstore.bufsize = 0;
> +
>  	return 0;
> +#endif
> +	return -EBUSY;
>  }
>  
>  static struct platform_driver ramoops_driver = {

