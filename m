Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375Ab0JDXUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:20:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49903 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752169Ab0JDXUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:20:04 -0400
Date: Mon, 4 Oct 2010 16:19:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] DMI: log system, BIOS, and board information
Message-Id: <20101004161926.7082bd13.akpm@linux-foundation.org>
In-Reply-To: <20100930164905.13154.33194.stgit@bob.kio>
References: <20100930164905.13154.33194.stgit@bob.kio>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 10:49:05 -0600
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> 
> Put basic system information in the dmesg log.  There are lots of dmesg
> logs on the web, and it would be useful if they contained this information
> for debugging platform problems.
> 
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> ---
> 
>  drivers/firmware/dmi_scan.c |   35 ++++++++++++++++++++++++++++++++++-
>  1 files changed, 34 insertions(+), 1 deletions(-)
> 
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index b3d22d6..d625e53 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -2,6 +2,7 @@
>  #include <linux/string.h>
>  #include <linux/init.h>
>  #include <linux/module.h>
> +#include <linux/ctype.h>
>  #include <linux/dmi.h>
>  #include <linux/efi.h>
>  #include <linux/bootmem.h>
> @@ -361,6 +362,36 @@ static void __init dmi_decode(const struct dmi_header *dm, void *dummy)
>  	}
>  }
>  
> +static const char * __init dmi_printable_system_info(int field)
> +{
> +	const char *info, *p;
> +
> +	info = dmi_get_system_info(field);
> +	if (!info)
> +		return NULL;
> +
> +	for (p = info; *p; p++)
> +		if (!isprint(*p))
> +			return "<...>";
> +
> +	return info;
> +}

So if the string contains any non-printable character, we suppress the
whole string.

Is that the best thing to do?  Would it be better to present the
oddball character as \xNN or such?


> +static void __init dmi_dump_ids(void)
> +{
> +	const char *board;
> +
> +	printk(KERN_DEBUG "DMI: system: %s %s",
> +	       dmi_printable_system_info(DMI_SYS_VENDOR),
> +	       dmi_printable_system_info(DMI_PRODUCT_NAME));
> +	board = dmi_printable_system_info(DMI_BOARD_NAME);
> +	if (board)
> +		printk(KERN_CONT " (%s board)", board);
> +	printk(KERN_CONT ", BIOS: %s %s\n",
> +	       dmi_printable_system_info(DMI_BIOS_VERSION),
> +	       dmi_printable_system_info(DMI_BIOS_DATE));
> +}
> +
>  static int __init dmi_present(const char __iomem *p)
>  {
>  	u8 buf[15];
> @@ -381,8 +412,10 @@ static int __init dmi_present(const char __iomem *p)
>  			       buf[14] >> 4, buf[14] & 0xF);
>  		else
>  			printk(KERN_INFO "DMI present.\n");
> -		if (dmi_walk_early(dmi_decode) == 0)
> +		if (dmi_walk_early(dmi_decode) == 0) {
> +			dmi_dump_ids();
>  			return 0;
> +		}
>  	}
>  	return 1;
>  }
