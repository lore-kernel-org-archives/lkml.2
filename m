Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab0LLTEb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 14:04:31 -0500
Received: from mail.perches.com ([173.55.12.10]:2532 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab0LLTEb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 14:04:31 -0500
Subject: Re: [PATCH 3/3] Staging: rt2860: include KERN_* in printk
From: Joe Perches <joe@perches.com>
To: "L. Alberto" =?ISO-8859-1?Q?Gim=E9nez?= <agimenez@sysvalve.es>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
References: <1292176591-26081-1-git-send-email-agimenez@sysvalve.es>
	 <1292176591-26081-4-git-send-email-agimenez@sysvalve.es>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 11:04:28 -0800
Message-ID: <1292180668.18202.43.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-12 at 18:56 +0100, L. Alberto Giménez wrote:
> Fix checkpatch complains
> diff --git a/drivers/staging/rt2860/common/ee_efuse.c b/drivers/staging/rt2860/common/ee_efuse.c
[]
> @@ -281,8 +281,8 @@ int set_eFusedump_Proc(struct rt_rtmp_adapter *pAd, char *arg)
>  
>  		eFuseReadPhysical(pAd, &InBuf[0], 4, &InBuf[2], 2);
>  		if (i % 4 == 0)
> -			printk("\nBlock %x:", i / 8);
> -		printk("%04x ", InBuf[2]);
> +			printk(KERN_DEBUG "\nBlock %x:", i / 8);
> +		printk(KERN_DEBUG "%04x ", InBuf[2]);
>  	}
>  	return TRUE;
>  }

Not quite.  Use:

(before the for)
	printk(KERN_DEBUG "Block 0: ");

for(...)
[]
		if (i && i % 4 == 0) {
			printk(KERN_CONT "\n");
			printk(KERN_DEBUG "Block %x: ", i / 8);
		}
		printk(KERN_CONT " %04x", InBuf[2]);
	}
	printk(KERN_CONT "\n");

> diff --git a/drivers/staging/rt2860/pci_main_dev.c b/drivers/staging/rt2860/pci_main_dev.c
> index 628559d..1949acd 100644
> --- a/drivers/staging/rt2860/pci_main_dev.c
> +++ b/drivers/staging/rt2860/pci_main_dev.c
> @@ -202,7 +202,7 @@ static int rt2860_resume(struct pci_dev *pci_dev)
>  
>  	/* initialize device before it's used by a driver */
>  	if (pci_enable_device(pci_dev)) {
> -		printk("pci enable fail!\n");
> +		printk(KERN_ERR "rt2860: pci enable fail!\n");
>  		return 0;
>  	}
>  
> diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
[]
> @@ -343,9 +343,8 @@ int RTMPAllocateNdisPacket(struct rt_rtmp_adapter *pAd,
>  					   RTMP_PKT_TAIL_PADDING);
>  	if (pPacket == NULL) {
>  		*ppPacket = NULL;
> -#ifdef DEBUG
> -		printk("RTMPAllocateNdisPacket Fail\n");
> -#endif
> +		printk(KERN_DEBUG "RTMPAllocateNdisPacket Fail\n");

Behavior change.
Using pr_devel would be exactly the same.
Using pr_debug would enable dynamic debug.

> @@ -601,15 +600,15 @@ void hex_dump(char *str, unsigned char *pSrcBufVA, unsigned int SrcBufLen)
>  		return;
>  
>  	pt = pSrcBufVA;
> -	printk("%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
> +	printk(KERN_DEBUG "%s: %p, len = %d\n", str, pSrcBufVA, SrcBufLen);
>  	for (x = 0; x < SrcBufLen; x++) {
>  		if (x % 16 == 0)
> -			printk("0x%04x : ", x);
> -		printk("%02x ", ((unsigned char)pt[x]));
> +			printk(KERN_DEBUG "0x%04x : ", x);
> +		printk(KERN_DEBUG "%02x ", ((unsigned char)pt[x]));
>  		if (x % 16 == 15)
> -			printk("\n");
> +			printk(KERN_DEBUG "\n");
>  	}
> -	printk("\n");
> +	printk(KERN_DEBUG "\n");

This should use print_hex_dump

> diff --git a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_linux.h
[]
>  #define DBGPRINT_ERR(Fmt)           \
>  {                                   \
> -    printk("ERROR! ");          \
> +    printk(KERN_ERR "ERROR! ");          \
>      printk Fmt;                  \
>  }

Better ways to do this:

#define DBGPRINT_ERR(fmt, args...) printk(KERN_ERR fmt, ##args)
or
#define DBGPRINT_ERR(fmt, ...) printk(KERN_ERR fmt, ##__VA_ARGS__)

and remove the unnecessary () at the call sites.

