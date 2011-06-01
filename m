Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab1FAVk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:40:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:49836 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab1FAVky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:40:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Timur Tabi <timur@freescale.com>
Subject: Re: [PATCH 7/7] [v2] drivers/misc: introduce Freescale hypervisor management driver
Date: Wed, 1 Jun 2011 23:40:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: kumar.gala@freescale.com, benh@kernel.crashing.org, greg@kroah.com,
        akpm@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-console@vger.kernel.org
References: <1306953337-15698-1-git-send-email-timur@freescale.com>
In-Reply-To: <1306953337-15698-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201106012340.14237.arnd@arndb.de>
X-Provags-ID: V02:K0:d4JNbjEU2U3Kr1Y8EZH3dPswad7drdEY3ah3rslVPrF
 F1TG/ClxGhxb9TtbAm4+hEedF8La4TDqVZ6DNtjno8ttr6VgRD
 F4ZrDp38PlmaFLZtkvlspoHZB0nYjVmbyRi0sdMwLPDfH+UDZU
 PssRv5R+HJ73adhMYhavyUUSituXzDe7XVj4BlpazoaNgepqk/
 V6QyBeMGqipulQNmpayqA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 June 2011, Timur Tabi wrote:
> The Freescale hypervisor management driver provides several services to
> drivers and applications related to the Freescale hypervisor:
> 
> 1. An ioctl interface for querying and managing partitions
> 
> 2. A file interface to reading incoming doorbells
> 
> 3. An interrupt handler for shutting down the partition upon receiving the
>    shutdown doorbell from a manager partition
> 
> 4. An interface for receiving callbacks when a managed partition shuts down.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  drivers/misc/Kconfig           |    7 +
>  drivers/misc/Makefile          |    1 +
>  drivers/misc/fsl_hypervisor.c  |  941 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/Kbuild           |    1 +
>  include/linux/fsl_hypervisor.h |  203 +++++++++
>  5 files changed, 1153 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/misc/fsl_hypervisor.c
>  create mode 100644 include/linux/fsl_hypervisor.h

I think drivers/misc is not the right place for this, but I'm not completely
sure what is. drivers/firmware would be better at least, but virt/fsl might
also be ok.

> +static long ioctl_dtprop(struct fsl_hv_ioctl_prop __user *p, int set)
> +{
> +	struct fsl_hv_ioctl_prop param;
> +	char __user *upath, *upropname;
> +	void __user *upropval;
> +	char *path = NULL, *propname = NULL;
> +	void *propval = NULL;
> +	int ret = 0;
> +

I'm not convinced that an ioctl interface is the right way to work with
device tree properties. A more natural way would be to export it as
a file system, or maybe as a flattened device tree blob (the latter option
would require changing the hypervisor interface, which might not be
possible).

> +/**
> + * fsl_hv_ioctl: ioctl main entry point
> + */
> +static long fsl_hv_ioctl(struct file *file, unsigned int cmd,
> +			 unsigned long argaddr)
> +{
> +	union fsl_hv_ioctl_param __user *arg =
> +		(union fsl_hv_ioctl_param __user *)argaddr;
> +	long ret;
> +

For an ioctl, please follow the normal pattern of defining a separate
structure for each case, no union.

You can use a void __user * in the common ioctl function, and pass that
to the typed argument list in the specific functions.

	Arnd
