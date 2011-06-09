Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1FITlX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 15:41:23 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50876 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab1FITlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 15:41:21 -0400
Date: Thu, 9 Jun 2011 12:40:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Timur Tabi <timur@freescale.com>
Cc: <alan@lxorguk.ukuu.org.uk>, <arnd@arndb.de>, <kumar.gala@freescale.com>,
        <benh@kernel.crashing.org>, <greg@kroah.com>, <akpm@kernel.org>,
        <cmetcalf@tilera.com>, <konrad.wilk@oracle.com>, <dsaxena@linaro.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-console@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 7/7] [v5] drivers/virt: introduce Freescale hypervisor
 management driver
Message-Id: <20110609124010.6335559e.randy.dunlap@oracle.com>
In-Reply-To: <1307646794-26374-1-git-send-email-timur@freescale.com>
References: <1307646794-26374-1-git-send-email-timur@freescale.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4DF121A8.00CD:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 14:13:14 -0500 Timur Tabi wrote:

> Add the drivers/virt directory, which houses drivers that support
> virtualization environments, and add the Freescale hypervisor management
> driver.
> 
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
> 4. A kernel interface for receiving callbacks when a managed partition
>    shuts down.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  drivers/Kconfig                |    2 +
>  drivers/Makefile               |    3 +
>  drivers/virt/Kconfig           |   32 ++
>  drivers/virt/Makefile          |    5 +
>  drivers/virt/fsl_hypervisor.c  |  983 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/Kbuild           |    1 +
>  include/linux/fsl_hypervisor.h |  231 ++++++++++
>  7 files changed, 1257 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/virt/Kconfig
>  create mode 100644 drivers/virt/Makefile
>  create mode 100644 drivers/virt/fsl_hypervisor.c
>  create mode 100644 include/linux/fsl_hypervisor.h

> diff --git a/include/linux/fsl_hypervisor.h b/include/linux/fsl_hypervisor.h
> new file mode 100644
> index 0000000..d1ca2b1
> --- /dev/null
> +++ b/include/linux/fsl_hypervisor.h
> @@ -0,0 +1,231 @@

[snip]

> +/**
> + * enum fsl_hv_ioctl_cmd - ioctl commands
> + * @FSL_HV_IOCTL_PARTITION_RESTART: restart another partition
> + * @FSL_HV_IOCTL_PARTITION_GET_STATUS: get a partition's status
> + * @FSL_HV_IOCTL_PARTITION_START: boot another partition
> + * @FSL_HV_IOCTL_PARTITION_STOP: stop this or another partition
> + * @FSL_HV_IOCTL_MEMCPY: copy data from one partition to another
> + * @FSL_HV_IOCTL_DOORBELL: ring a doorbell
> + * @FSL_HV_IOCTL_GETPROP: get a property from another guest's device tree
> + * @FSL_HV_IOCTL_SETPROP: set a property in another guest's device tree
> + *
> + * This enum lists the available ioctl commands for the Freescale hypervisor
> + * management driver.  The meaning
> + */
> +enum fsl_hv_ioctl_cmd {
> +	FSL_HV_IOCTL_PARTITION_RESTART = _IOWR(0, 1, struct fsl_hv_ioctl_restart),
> +	FSL_HV_IOCTL_PARTITION_GET_STATUS = _IOWR(0, 2, struct fsl_hv_ioctl_status),
> +	FSL_HV_IOCTL_PARTITION_START = _IOWR(0, 3, struct fsl_hv_ioctl_start),
> +	FSL_HV_IOCTL_PARTITION_STOP = _IOWR(0, 4, struct fsl_hv_ioctl_stop),
> +	FSL_HV_IOCTL_MEMCPY = _IOWR(0, 5, struct fsl_hv_ioctl_memcpy),
> +	FSL_HV_IOCTL_DOORBELL = _IOWR(0, 6, struct fsl_hv_ioctl_doorbell),
> +	FSL_HV_IOCTL_GETPROP = _IOWR(0, 7, struct fsl_hv_ioctl_prop),
> +	FSL_HV_IOCTL_SETPROP = _IOWR(0, 8, struct fsl_hv_ioctl_prop),
> +};

Missing an entry in Documentation/ioctl/ioctl-number.txt for 0 (with conflict!).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
