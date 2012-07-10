Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab2GJO1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 10:27:36 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:42632 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2GJO1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 10:27:35 -0400
Date: Tue, 10 Jul 2012 10:19:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Olaf Hering <olaf@aepfle.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen/pv-on-hvm kexec: shutdown watches from
 old kernel
Message-ID: <20120710141906.GC1791@phenom.dumpdata.com>
References: <1341924603-18978-1-git-send-email-olaf@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341924603-18978-1-git-send-email-olaf@aepfle.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 02:50:03PM +0200, Olaf Hering wrote:
> Add xs_reset_watches function to shutdown watches from old kernel after
> kexec boot.  The old kernel does not unregister all watches in the
> shutdown path.  They are still active, the double registration can not
> be detected by the new kernel.  When the watches fire, unexpected events
> will arrive and the xenwatch thread will crash (jumps to NULL).  An
> orderly reboot of a hvm guest will destroy the entire guest with all its
> resources (including the watches) before it is rebuilt from scratch, so
> the missing unregister is not an issue in that case.
> 
> With this change the xenstored is instructed to wipe all active watches
> for the guest.  However, a patch for xenstored is required so that it
> accepts the XS_RESET_WATCHES request from a client (see changeset
> 23839:42a45baf037d in xen-unstable.hg). Without the patch for xenstored
> the registration of watches will fail and some features of a PVonHVM
> guest are not available. The guest is still able to boot, but repeated
> kexec boots will fail.

OK, so this should make the reset of xenstore work with the new hypervisor,
but with older ones (like Amazon), it won't and we won't have regressions, right?

> 
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
>  drivers/xen/xenbus/xenbus_xs.c     |   20 ++++++++++++++++++++
>  include/xen/interface/io/xs_wire.h |    3 ++-
>  2 files changed, 22 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/xenbus/xenbus_xs.c b/drivers/xen/xenbus/xenbus_xs.c
> index d1c217b..bce15cf 100644
> --- a/drivers/xen/xenbus/xenbus_xs.c
> +++ b/drivers/xen/xenbus/xenbus_xs.c
> @@ -618,6 +618,23 @@ static struct xenbus_watch *find_watch(const char *token)
>  	return NULL;
>  }
>  
> +static void xs_reset_watches(void)
> +{
> +	int err, supported = 0;
> +
> +	if (!xen_hvm_domain())
> +		return;
> +
> +	err = xenbus_scanf(XBT_NIL, "control",
> +			"platform-feature-xs_reset_watches", "%d", &supported);
> +	if (err != 1 || !supported)
> +		return;
> +
> +	err = xs_error(xs_single(XBT_NIL, XS_RESET_WATCHES, "", NULL));
> +	if (err && err != -EEXIST)
> +		printk(KERN_WARNING "xs_reset_watches failed: %d\n", err);
> +}
> +
>  /* Register callback to watch this node. */
>  int register_xenbus_watch(struct xenbus_watch *watch)
>  {
> @@ -900,5 +917,8 @@ int xs_init(void)
>  	if (IS_ERR(task))
>  		return PTR_ERR(task);
>  
> +	/* shutdown watches for kexec boot */
> +	xs_reset_watches();
> +
>  	return 0;
>  }
> diff --git a/include/xen/interface/io/xs_wire.h b/include/xen/interface/io/xs_wire.h
> index 7cdfca2..3c1877c 100644
> --- a/include/xen/interface/io/xs_wire.h
> +++ b/include/xen/interface/io/xs_wire.h
> @@ -29,7 +29,8 @@ enum xsd_sockmsg_type
>      XS_IS_DOMAIN_INTRODUCED,
>      XS_RESUME,
>      XS_SET_TARGET,
> -    XS_RESTRICT
> +    XS_RESTRICT,
> +    XS_RESET_WATCHES
>  };
>  
>  #define XS_WRITE_NONE "NONE"
> -- 
> 1.7.3.4
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
