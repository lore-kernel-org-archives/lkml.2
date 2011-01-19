Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab1ASTCC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 14:02:02 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:5981 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab1ASTB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:01:59 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Anisse Astier <anisse@astier.eu>
Subject: Re: [PATCH RFC] dmi-scan: Use little-endian for the first 3 fields of the UUID.
Date: Wed, 19 Jan 2011 12:01:02 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pascal VITOUX <pascal@substantiel.fr>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Jean Delvare <khali@linux-fr.org>
References: <20110119185411.49668f81@destiny.ordissimo>
In-Reply-To: <20110119185411.49668f81@destiny.ordissimo>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201101191201.03971.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 19, 2011 10:54:11 am Anisse Astier wrote:
> 
> From: Pascal VITOUX <pascal@substantiel.fr>
> 
>  - Get SMBIOS version.
>  - Byte-swap the first 3 fields of the UUID (DMI type 1) as off SMBIOS
>    version 2.6.
> 
> This patch is an adaptation of Jean Delvare patches for dmidecode
> rev1.100, rev1.01 and rev1.119.
> http://cvs.savannah.gnu.org/viewvc/dmidecode/dmidecode.c?root=dmidecode&view=log
> 
> It is intended to get the same uuid from dmidecode tool as from sysfs kernel
> tree, more compliant with SMBIOS specification.
> Therefore this patch will have the kernel return a different UUID if you
> are using a recent BIOS implementing SMBIOS >= 2.6.

It seems like a good idea to have /sys/class/dmi/id/product_uuid
match what dmidecode reports.  Does dmidecode use the same algorithm
(testing dmi_ver against 0x0206)?

It'd be nice to mention that /sys/... filename explicitly in the
changelog, and maybe even include an example from a system where
they previously did not match, and now do.

I don't have an opinion on the SMBIOS version stuff, but that looks
like it should be split into a separate patch.

Bjorn

> Signed-off-by: Pascal VITOUX <pascal@substantiel.fr>
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> ---
> Hi,
> 
> I'd like to get some feedback on this patch. It doesn't modify the
> API/ABI, but modifies the value returned by kernel on a given hardware,
> so it could potentially break a (very) badly written app.
> 
> Disclaimer: Although I've applied my Signed-off-by, Pascal and I work for
> the same company.
> 
> Regards,
> Anisse
> 
> ---
>  drivers/firmware/dmi_scan.c |   36 ++++++++++++++++++++++++++++++++++--
>  1 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index e28e41668..b6278a7 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -99,6 +99,7 @@ static void dmi_table(u8 *buf, int len, int num,
>  static u32 dmi_base;
>  static u16 dmi_len;
>  static u16 dmi_num;
> +static u16 dmi_ver;
>  
>  static int __init dmi_walk_early(void (*decode)(const struct dmi_header *,
>  		void *))
> @@ -169,7 +170,18 @@ static void __init dmi_save_uuid(const struct dmi_header *dm, int slot, int inde
>  	if (!s)
>  		return;
>  
> -	sprintf(s, "%pUB", d);
> +	/*
> +	 * As off version 2.6 of the SMBIOS specification, the first 3
> +	 * fields of the UUID are supposed to be encoded on little-endian.
> +	 * The specification says that this is the defacto standard,
> +	 * however I've seen systems following RFC 4122 instead and use
> +	 * network byte order, so I am reluctant to apply the byte-swapping
> +	 * for older versions.
> +	 */
> +	if (dmi_ver >= 0x0206)
> +		sprintf(s, "%pUL", d);
> +	else
> +		sprintf(s, "%pUB", d);
>  
>          dmi_ident[slot] = s;
>  }
> @@ -400,9 +412,29 @@ static int __init dmi_present(const char __iomem *p)
>  		dmi_base = (buf[11] << 24) | (buf[10] << 16) |
>  			(buf[9] << 8) | buf[8];
>  
> +		/* SMBIOS version */
> +		dmi_ver = (*(u8 *)(p - 0x10 + 0x06) << 8) +
> +			*(u8 *)(p - 0x10 + 0x07);
> +
> +		/* Some BIOS report weird SMBIOS version, fix that up */
> +		switch (dmi_ver) {
> +		case 0x021F:
> +			printk(KERN_INFO "SMBIOS version fixup (2.%d -> 2.%d).\n",
> +			       31, 3);
> +			dmi_ver = 0x0203;
> +			break;
> +		case 0x0233:
> +			printk(KERN_INFO "SMBIOS version fixup (2.%d -> 2.%d).\n",
> +			       51, 6);
> +			dmi_ver = 0x0206;
> +			break;
> +		}
> +		printk(KERN_INFO "SMBIOS version %d.%d.\n", dmi_ver >> 8,
> +		       dmi_ver & 0xFF);
> +
>  		/*
>  		 * DMI version 0.0 means that the real version is taken from
> -		 * the SMBIOS version, which we don't know at this point.
> +		 * the SMBIOS version.
>  		 */
>  		if (buf[14] != 0)
>  			printk(KERN_INFO "DMI %d.%d present.\n",
> 
