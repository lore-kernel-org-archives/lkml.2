Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab0LVUFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:05:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43172 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab0LVUFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:05:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Gvg56wRZv/VDc0gwyQcwNsZ8d9NfU4czui0XkbhZRRaZslKoLPyXPXb+3HN/UAeUWk
         4sUd/8shjZj/VQAwXapfVd1qrG+HYO1i4o6pQURo0HgEgsbO2zQwpAUwvlJ5b4DRr0wI
         Wzkrn815/pGWOqcqUzA/jb0cLJqRpMOaT2Uv8=
Message-ID: <4D1259E8.9030706@gmail.com>
Date: Wed, 22 Dec 2010 12:04:56 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: dirk.brandewie@gmail.com
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Grant Likely <grant.likely@secretlab.ca>, linux-doc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] of/fdt: add kernel command line option for dtb_compat
 string
References: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com>
In-Reply-To: <1291658059-383-1-git-send-email-dirk.brandewie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2010 09:54 AM, dirk.brandewie@gmail.com wrote:
> From: Dirk Brandewie<dirk.brandewie@gmail.com>
>
> Adds a kernel command line option "dtb_compat=<string>".  This string
> will be used to select the first compatible device tree blob linked
> into the kernel if a device tree blob is was *not* passed in by the
> bootloader.
>
> Signed-off-by: Dirk Brandewie<dirk.brandewie@gmail.com>
> ---
>   Documentation/kernel-parameters.txt |    8 ++++++
>   drivers/of/fdt.c                    |   48 +++++++++++++++++++++++++++++++++++
>   2 files changed, 56 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 92e83e5..64093e5 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -655,6 +655,14 @@ and is between 256 and 4096 characters. It is defined in the file
>
>   	dscc4.setup=	[NET]
>
> +	dtb_compat=	[KNL]
> +			Specify the "compatible" string for the device
> +			tree blob present in the vmlinux image.  This
> +			string will be used to select the first device
> +			tree blob whose compatible property matches
> +			the string if a dtb was NOT passed in by the
> +			bootloader.
> +
>   	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
>   			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
>   			These can also be switched on/off via
> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
> index c1360e0..ca1318c 100644
> --- a/drivers/of/fdt.c
> +++ b/drivers/of/fdt.c
> @@ -15,6 +15,8 @@
>   #include<linux/of_fdt.h>
>   #include<linux/string.h>
>   #include<linux/errno.h>
> +#include<asm-generic/vmlinux.lds.h>
> +
>
>   #ifdef CONFIG_PPC
>   #include<asm/machdep.h>
> @@ -604,3 +606,49 @@ void __init unflatten_device_tree(void)
>
>   	pr_debug("<- unflatten_device_tree()\n");
>   }
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
> +
> +	while (blob<  __dtb_end) {
> +		if (be32_to_cpu(initial_boot_params->magic) != OF_DT_HEADER) {
> +			WARN(1, "Invalid device tree blob in vmlinux\n");
> +			break;
> +		}
> +
> +		root = of_get_flat_dt_root();
> +		if (of_flat_dt_is_compatible(root, name)>  0) {
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
> +		initial_boot_params = of_flat_dt_find_compatible_dtb(line);
> +	return 1;
> +}
> +
> +early_param("dtb_compat", of_flat_dtb_compat_setup);
> +
Any more comments on this patch? Is it good to go or DOA?

Thanks
--Dirk

