Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263Ab1ASUjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 15:39:52 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:39718 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251Ab1ASUjv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 15:39:51 -0500
Date: Wed, 19 Jan 2011 21:39:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Anisse Astier <anisse@astier.eu>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Pascal VITOUX <pascal@substantiel.fr>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH RFC] dmi-scan: Use little-endian for the first 3 fields
 of  the UUID.
Message-ID: <20110119213936.06400e49@endymion.delvare>
In-Reply-To: <20110119185411.49668f81@destiny.ordissimo>
References: <20110119185411.49668f81@destiny.ordissimo>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anisse,

On Wed, 19 Jan 2011 18:54:11 +0100, Anisse Astier wrote:
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

Note that I am not particularly proud of this patch, and even thought
of reverting it at some point. It is possible that dmidecode 2.12 will
have different code for UUID decoding. The current behavior would stay
the default, but the user would be able to force one decoding order
through a command line option.  This was suggested a long time ago:
http://www.mail-archive.com/dmidecode-devel@nongnu.org/msg00096.html
I disregarded the proposal back then. Now... Well, I'm still not sure :(

> It is intended to get the same uuid from dmidecode tool as from sysfs kernel
> tree, more compliant with SMBIOS specification.

I understand that it makes sense to have dmidecode and the kernel
return the same value. But the problem is that it appears that, in
practice, vendors don't follow the recommendations of the SMBIOS 2.6
specifications. On most machines I've checked, the network byte order
is used, per RFC4122.

Also, while the change in dmidecode was applied at the time SMBIOS 2.6
implementations were rare, this is no longer true. So a change now may
have consequences.

> Therefore this patch will have the kernel return a different UUID if you
> are using a recent BIOS implementing SMBIOS >= 2.6.
> 
> Signed-off-by: Pascal VITOUX <pascal@substantiel.fr>
> Signed-off-by: Anisse Astier <anisse@astier.eu>
> ---
> Hi,
> 
> I'd like to get some feedback on this patch. It doesn't modify the
> API/ABI, but modifies the value returned by kernel on a given hardware,
> so it could potentially break a (very) badly written app.

I fail to see why an application relying on the UUID would qualify as
"badly written". The UUID seems like a reasonable thing to use for any
inventory application, as a mean to uniquely identify machines. Using
it for licensing purpose also makes sense (whether you you like
proprietary software or not is irrelevant.)

This is a desperate case anyway, there simply is no clean solution to
this problem. Whoever suggested the addition of this note in the SMBIOS
2.6 specification should be banned permanently from ever contributing
to any technical document.

> Disclaimer: Although I've applied my Signed-off-by, Pascal and I work for
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

You can't do that, sorry. Only the 15 bytes of the _DMI_ entry point
have been iomap'd, the 16 bytes of the _SM_ entry point (which may not
even exist!) have not. I suspect you'll have to rework the loop in
dmi_scan_machine() and the way it calls dmi_present() quite a bit.

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

Note that I've added one more fixup meanwhile:
  http://cvs.savannah.gnu.org/viewvc/dmidecode/dmidecode.c?root=dmidecode&r1=1.145&r2=1.146

> +		printk(KERN_INFO "SMBIOS version %d.%d.\n", dmi_ver >> 8,
> +		       dmi_ver & 0xFF);
> +
>  		/*
>  		 * DMI version 0.0 means that the real version is taken from
> -		 * the SMBIOS version, which we don't know at this point.
> +		 * the SMBIOS version.

Changing the comment without changing the code that follows it makes no
sense.

>  		 */
>  		if (buf[14] != 0)
>  			printk(KERN_INFO "DMI %d.%d present.\n",


-- 
Jean Delvare
