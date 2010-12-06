Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab0LFShW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 13:37:22 -0500
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:52765
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750837Ab0LFShU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 13:37:20 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz542N1432N9371Pzz1202hzz8275bh8275dhz2dh95h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] of/fdt: add kernel command line option for dtb_compat string
Date: Mon, 6 Dec 2010 10:37:14 -0800
In-Reply-To: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] of/fdt: add kernel command line option for dtb_compat string
Thread-Index: AcuVbqzSh7jpLRWkQiCZurn6lEdwmAABdlRQ
References: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com>
From: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
To: <dirk.brandewie@gmail.com>, <linux-kernel@vger.kernel.org>
CC: Randy Dunlap <rdunlap@xenotime.net>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>
X-OriginalArrivalTime: 06 Dec 2010 18:37:12.0417 (UTC) FILETIME=[98E65D10:01CB9574]
Message-ID: <4bb36a12-8d95-4d4e-936c-c1c74a9372cc@VA3EHSMHS025.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From:
devicetree-discuss-bounces+stephen.neuendorffer=xilinx.com@lists.ozlabs.
org [mailto:devicetree-
> discuss-bounces+stephen.neuendorffer=xilinx.com@lists.ozlabs.org] On
Behalf Of
> dirk.brandewie@gmail.com
> Sent: Monday, December 06, 2010 9:54 AM
> To: linux-kernel@vger.kernel.org
> Cc: Randy Dunlap; devicetree-discuss@lists.ozlabs.org;
linux-doc@vger.kernel.org
> Subject: [PATCH] of/fdt: add kernel command line option for dtb_compat
string
> 
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> Adds a kernel command line option "dtb_compat=<string>".  This string
> will be used to select the first compatible device tree blob linked
> into the kernel if a device tree blob is was *not* passed in by the
> bootloader.
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
>  Documentation/kernel-parameters.txt |    8 ++++++
>  drivers/of/fdt.c                    |   48
+++++++++++++++++++++++++++++++++++
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
> index 92e83e5..64093e5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -655,6 +655,14 @@ and is between 256 and 4096 characters. It is
defined in the file
> 
>  	dscc4.setup=	[NET]
> 
> +	dtb_compat=	[KNL]
> +			Specify the "compatible" string for the device
> +			tree blob present in the vmlinux image.  This
> +			string will be used to select the first device
> +			tree blob whose compatible property matches
> +			the string if a dtb was NOT passed in by the
> +			bootloader.
> +
>  	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
>  			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
>  			These can also be switched on/off via
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index c1360e0..ca1318c 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -15,6 +15,8 @@
>  #include <linux/of_fdt.h>
>  #include <linux/string.h>
>  #include <linux/errno.h>
> +#include <asm-generic/vmlinux.lds.h>
> +
> 
>  #ifdef CONFIG_PPC
>  #include <asm/machdep.h>
> @@ -604,3 +606,49 @@ void __init unflatten_device_tree(void)
> 
>  	pr_debug(" <- unflatten_device_tree()\n");
>  }
> +
> +extern uint8_t __dtb_start[];
> +extern uint8_t __dtb_end[];
> +static void __init *of_flat_dt_find_compatible_dtb(char *name)
> +{
> +	void *rc = NULL;
> +	unsigned long root, size;
> +	struct boot_param_header  *orig_initial_boot_params;
> +	uint8_t *blob;
> +
> +	orig_initial_boot_params = initial_boot_params;
> +	blob = __dtb_start;
> +	initial_boot_params = (struct boot_param_header *)blob;

Oy... can you avoid the pointer dance by using of_fdt_is_compatible()
from my recent set of patches?
It takes a blob argument.  Then the loop below goes away.

Steve

> +
> +
> +	while (blob < __dtb_end) {
> +		if (be32_to_cpu(initial_boot_params->magic) !=
OF_DT_HEADER) {
> +			WARN(1, "Invalid device tree blob in
vmlinux\n");
> +			break;
> +		}
> +
> +		root = of_get_flat_dt_root();
> +		if (of_flat_dt_is_compatible(root, name) > 0) {
> +			rc = blob;
> +			break;
> +		}
> +
> +		size =  be32_to_cpu(initial_boot_params->totalsize);
> +		blob =  PTR_ALIGN(blob + size, STRUCT_ALIGNMENT);
> +		initial_boot_params = (struct boot_param_header *)blob;
> +	}
> +
> +	if (rc == NULL)
> +		initial_boot_params = orig_initial_boot_params;
> +	return rc;
> +}
> +
> +
> +static int __init of_flat_dtb_compat_setup(char *line)
> +{
> +	if (!initial_boot_params)
> +		initial_boot_params =
of_flat_dt_find_compatible_dtb(line);
> +	return 1;
> +}
> +
> +early_param("dtb_compat", of_flat_dtb_compat_setup);
> +
> --
> 1.7.2.3
> 
> _______________________________________________
> devicetree-discuss mailing list
> devicetree-discuss@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/devicetree-discuss


This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


