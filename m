Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932784Ab1DNKbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:31:40 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56228 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab1DNKbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:31:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=IeyIkAomylri1prxjX+2xVpord+41XxpJNTI3s+GKalYMgRPJEDXAX/zxvHwRZobgQ
         TE3WzRXnXtpcRzwMkzdNfroWsP+LkTAsZKz/NLJ7h4ybqQmDtigvldJQYLAsYCOOTxEy
         1T8IwjNq6/I1Z6kWxIuef0zgaFn/4JkP9Diu0=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: akpm@linux-foundation.org, "Alexey Dobriyan" <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [40/52] kstrtox: convert drivers/usb/
References: <1296915654-7458-40-git-send-email-adobriyan@gmail.com>
Date: Thu, 14 Apr 2011 12:31:35 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtxbiwjx3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <1296915654-7458-40-git-send-email-adobriyan@gmail.com>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Feb 2011 15:20:43 +0100, Alexey Dobriyan <adobriyan@gmail.com>  
wrote:

> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>
> ---
> drivers/usb/gadget/storage_common.c |    7 ++++---

I haven't notice your patch (wasn't sent to linux-usb?) and changed this
file already -- patch is in Greg's tree.

>  drivers/usb/host/ehci-dbg.c         |    6 +++---
>  drivers/usb/serial/iuu_phoenix.c    |   27 ++++++++++-----------------
>  3 files changed, 17 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/usb/gadget/storage_common.c  
> b/drivers/usb/gadget/storage_common.c
> index b015561..ed81718 100644
> --- a/drivers/usb/gadget/storage_common.c
> +++ b/drivers/usb/gadget/storage_common.c
> @@ -713,8 +713,9 @@ static ssize_t fsg_store_ro(struct device *dev,  
> struct device_attribute *attr,
>  	struct rw_semaphore	*filesem = dev_get_drvdata(dev);
>  	unsigned long	ro;
> -	if (strict_strtoul(buf, 2, &ro))
> -		return -EINVAL;
> +	rc = kstrtoul(buf, 2, &ro);
> +	if (rc < 0)
> +		return rc;
> 	/*
>  	 * Allow the write-enable status to change only while the

Also, this is actually incorrect -- it zeroes rc which it should not
do.  I made the same mistake at first. ;)

> @@ -740,7 +741,7 @@ static ssize_t fsg_store_nofua(struct device *dev,
>  	struct fsg_lun	*curlun = fsg_lun_from_dev(dev);
>  	unsigned long	nofua;
> -	if (strict_strtoul(buf, 2, &nofua))
> +	if (kstrtoul(buf, 2, &nofua))
>  		return -EINVAL;
> 	/* Sync data when switching from async mode to sync */


> diff --git a/drivers/usb/host/ehci-dbg.c b/drivers/usb/host/ehci-dbg.c
> @@ -1000,7 +1000,7 @@ static ssize_t debug_lpm_write(struct file *file,  
> const char __user *user_buf,
>  		buf[len - 1] = '\0';
> 	if (strncmp(buf, "enable", 5) == 0) {
> -		if (strict_strtoul(buf + 7, 10, &port))
> +		if (kstrtoul(buf + 7, 10, &port))
>  			return -EINVAL;
>  		params = ehci_readl(ehci, &ehci->caps->hcs_params);
>  		if (port > HCS_N_PORTS(params)) {
> @@ -1018,7 +1018,7 @@ static ssize_t debug_lpm_write(struct file *file,  
> const char __user *user_buf,
>  		printk(KERN_INFO "force enable LPM for port %lu\n", port);
>  	} else if (strncmp(buf, "hird=", 5) == 0) {
>  		unsigned long hird;
> -		if (strict_strtoul(buf + 5, 16, &hird))
> +		if (kstrtoul(buf + 5, 16, &hird))
>  			return -EINVAL;
>  		printk(KERN_INFO "setting hird %s %lu\n", buf + 6, hird);
>  		temp = ehci_readl(ehci, &ehci->regs->command);
> @@ -1026,7 +1026,7 @@ static ssize_t debug_lpm_write(struct file *file,  
> const char __user *user_buf,
>  		temp |= hird << 24;
>  		ehci_writel(ehci, temp, &ehci->regs->command);
>  	} else if (strncmp(buf, "disable", 7) == 0) {
> -		if (strict_strtoul(buf + 8, 10, &port))
> +		if (kstrtoul(buf + 8, 10, &port))
>  			return -EINVAL;
>  		params = ehci_readl(ehci, &ehci->caps->hcs_params);
>  		if (port > HCS_N_PORTS(params)) {

I'm wondering if we care about loosing the possible -ERANGE.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
