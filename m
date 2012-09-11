Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128Ab2IKIsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 04:48:06 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45141 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab2IKIr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 04:47:58 -0400
Date: Tue, 11 Sep 2012 11:47:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Iglesias =?iso-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Jens Taprogge <jens.taprogge@taprogge.org>,
        linux-kernel@vger.kernel.org, industrypack-devel@lists.sourceforge.net
Subject: Re: [PATCH 03/20] Staging: ipack/bridges/tpci200: provide new
 callbacks to tpci200
Message-ID: <20120911084702.GM19396@mwanda>
References: <1347267118-9580-1-git-send-email-siglesias@igalia.com>
 <1347267118-9580-3-git-send-email-siglesias@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1347267118-9580-3-git-send-email-siglesias@igalia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I had a few style comments on this patchset.  Nothing that couldn't
be fixed later.

On Mon, Sep 10, 2012 at 10:51:41AM +0200, Samuel Iglesias Gonsálvez wrote:
> From: Jens Taprogge <jens.taprogge@taprogge.org>
> 
> Provide get_clockrate, set_clockrate, get_error, get_timeout and reset_timeout
> callbacks.
> 
> Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
> Signed-off-by: Samuel Iglesias Gonsálvez <siglesias@igalia.com>
> ---
>  drivers/staging/ipack/bridges/tpci200.c |  107 +++++++++++++++++++++++++++++++
>  1 file changed, 107 insertions(+)
> 
> diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
> index 4383953..861b00d 100644
> --- a/drivers/staging/ipack/bridges/tpci200.c
> +++ b/drivers/staging/ipack/bridges/tpci200.c
> @@ -14,6 +14,20 @@
>  #include <linux/module.h>
>  #include "tpci200.h"
>  
> +static u16 tpci200_status_timeout[] = {
> +	TPCI200_A_TIMEOUT,
> +	TPCI200_B_TIMEOUT,
> +	TPCI200_C_TIMEOUT,
> +	TPCI200_D_TIMEOUT,
> +};
> +
> +static u16 tpci200_status_error[] = {
> +	TPCI200_A_ERROR,
> +	TPCI200_B_ERROR,
> +	TPCI200_C_ERROR,
> +	TPCI200_D_ERROR,
> +};
> +
>  static struct ipack_bus_ops tpci200_bus_ops;
>  
>  static int tpci200_slot_unregister(struct ipack_device *dev);
> @@ -507,6 +521,94 @@ out_unlock:
>  	return res;
>  }
>  
> +static int tpci200_get_clockrate(struct ipack_device *dev)
> +{
> +	struct tpci200_board *tpci200 = check_slot(dev);
> +	__le16 __iomem *addr;

The point of the underscores in the __le16 is that you don't want to
pollute user space headers in glibc with a bunch of kernel typedefs.
It is not needed here.  (Or if it is, then we would need to replace
the u16 uses as well).

> +
> +	if (!tpci200)
> +		return -ENODEV;
> +
> +	addr = &tpci200->info->interface_regs->control[dev->slot];
> +	return (ioread16(addr) & TPCI200_CLK32) ? 32 : 8;
> +}
> +
> +static int tpci200_set_clockrate(struct ipack_device *dev, int mherz)
> +{
> +	struct tpci200_board *tpci200 = check_slot(dev);
> +	__le16 __iomem *addr;
> +	u16 reg;
> +
> +	if (!tpci200)
> +		return -ENODEV;
> +
> +	addr = &tpci200->info->interface_regs->control[dev->slot];
> +
> +	/* Ensure the control register is not changed by another task after we
> +	 * have read it. */
> +	mutex_lock(&tpci200->mutex);
> +	reg = ioread16(addr);
> +	switch (mherz) {
> +	case 8:
> +		reg &= ~(TPCI200_CLK32); break;
> +	case 32:
> +		reg |= TPCI200_CLK32; break;

Put the breaks on the next line so that we can see them.  At first I
thought it fell through.

> +	default:
> +		mutex_unlock(&tpci200->mutex);
> +		return -EINVAL;
> +	}
> +	iowrite16(reg, addr);
> +	mutex_unlock(&tpci200->mutex);
> +	return 0;
> +}
> +
> +static int tpci200_get_error(struct ipack_device *dev)
> +{
> +	struct tpci200_board *tpci200 = check_slot(dev);
> +	__le16 __iomem *addr;
> +	u16 mask;
> +
> +	if (!tpci200)
> +		return -ENODEV;
> +
> +	addr = &tpci200->info->interface_regs->status;
> +	mask = tpci200_status_error[dev->slot];
> +	return (ioread16(addr) & mask) ? 1 : 0;
> +}
> +
> +static int tpci200_get_timeout(struct ipack_device *dev)
> +{
> +	struct tpci200_board *tpci200 = check_slot(dev);
> +	__le16 __iomem *addr;
> +	u16 mask;
> +
> +	if (!tpci200)
> +		return -ENODEV;
> +
> +	addr = &tpci200->info->interface_regs->status;
> +	mask = tpci200_status_timeout[dev->slot];
> +
> +	return (ioread16(addr) & mask) ? 1 : 0;
> +}
> +
> +static int tpci200_reset_timeout(struct ipack_device *dev)
> +{
> +	struct tpci200_board *tpci200 = check_slot(dev);
> +	__le16 __iomem *addr;
> +	u16 mask;
> +
> +	if (!tpci200)
> +		return -ENODEV;
> +
> +	addr = &tpci200->info->interface_regs->status;
> +	mask = tpci200_status_timeout[dev->slot];
> +
> +	iowrite16(mask, addr);
> +	return 0;
> +}
> +
> +
> +

Only one blank line is here.

>  static void tpci200_uninstall(struct tpci200_board *tpci200)
>  {
>  	int i;
> @@ -524,6 +626,11 @@ static struct ipack_bus_ops tpci200_bus_ops = {
>  	.request_irq = tpci200_request_irq,
>  	.free_irq = tpci200_free_irq,
>  	.remove_device = tpci200_slot_unregister,
> +	.get_clockrate = tpci200_get_clockrate,
> +	.set_clockrate = tpci200_set_clockrate,
> +	.get_error     = tpci200_get_error,
> +	.get_timeout   = tpci200_get_timeout,
> +	.reset_timeout = tpci200_reset_timeout,
>  };
>  
>  static int tpci200_install(struct tpci200_board *tpci200)
> -- 
> 1.7.10.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel
