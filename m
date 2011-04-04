Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab1DDHaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:30:04 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52884 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1DDHaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:30:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=RRKF/d/WV0aSCfdqDI3AhV/8tcNVPxRJ67raTI0bIppcjTV/B01kcf6rjZhVjWRKrB
         Wqqti3faqnVEF2OpLeVdvKHM/v+4FPugJp0GZe2ThnfIViEKVHTG2IMtPR5c3iqIlZqg
         pjS4Dn2blLOGEvL3O+zOp4kc1jpGSUybOiKw0=
Subject: Re: [PATCH] MTD: Retry Read/Write Transfer Buffer Allocations
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Grant Erickson <marathon96@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1301705049-15593-1-git-send-email-marathon96@gmail.com>
References: <1301705049-15593-1-git-send-email-marathon96@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:27:30 +0300
Message-ID: <1301902050.2760.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CCing LKML in a hope to get good suggestions]
[The patch: http://lists.infradead.org/pipermail/linux-mtd/2011-April/034645.html]

Hi Grant,

Just in case, Jarkko was trying to address the same issue recently:

http://lists.infradead.org/pipermail/linux-mtd/2011-March/034416.html
On Fri, 2011-04-01 at 17:44 -0700, Grant Erickson wrote:
> When handling user space read or write requests via mtd_{read,write},
> exponentially back off on the size of the requested kernel transfer
> buffer until it succeeds or until the requested transfer buffer size
> falls below the page size.
> 
> This helps ensure the operation can succeed under low-memory,
> highly-fragmented situations albeit somewhat more slowly.
> 
> Signed-off-by: Grant Erickson <marathon96@gmail.com>
> ---
>  drivers/mtd/mtdchar.c |   30 ++++++++++++++----------------
>  1 files changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 145b3d0d..d887b91 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -179,6 +179,7 @@ static ssize_t mtd_read(struct file *file, char __user *buf, size_t count,loff_t
>  	size_t total_retlen=0;
>  	int ret=0;
>  	int len;
> +	size_t size;
>  	char *kbuf;
>  
>  	DEBUG(MTD_DEBUG_LEVEL0,"MTD_read\n");
> @@ -192,20 +193,18 @@ static ssize_t mtd_read(struct file *file, char __user *buf, size_t count,loff_t
>  	/* FIXME: Use kiovec in 2.5 to lock down the user's buffers
>  	   and pass them directly to the MTD functions */
>  
> -	if (count > MAX_KMALLOC_SIZE)
> -		kbuf=kmalloc(MAX_KMALLOC_SIZE, GFP_KERNEL);
> -	else
> -		kbuf=kmalloc(count, GFP_KERNEL);
> +	size = min_t(size_t, count, MAX_KMALLOC_SIZE);
> +
> +	do {
> +		kbuf=kmalloc(size, GFP_KERNEL);
> +	} while (!kbuf && ((size >>= 1) >= PAGE_SIZE));

This should be a bit more complex I think. First of all, I think it is
better to make this a separate function. Second, you should make sure
the system does not print scary warnings when the allocation fails - use
__GFP_NOWARN flag, just like Jarkko did.

An third, as I wrote in my answer to Jarkko, allocating large contiguous
buffers is bad for performance: if the system memory is fragmented and
there is no such large contiguous areas, the kernel will start writing
back dirty FS data, killing FS caches, shrinking caches and buggers,
probably even swapping out applications. We do not want MTD to cause
this at all.

Probably we can mitigate this with kmalloc flags. Now, I'm not sure what
flags are the optimal, but I'd do:

__GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY

May be even __GFP_WAIT flag could be kicked out.

>  
>  	if (!kbuf)
>  		return -ENOMEM;
>  
>  	while (count) {
>  
> -		if (count > MAX_KMALLOC_SIZE)
> -			len = MAX_KMALLOC_SIZE;
> -		else
> -			len = count;
> +		len = min_t(size_t, count, size);
>  
>  		switch (mfi->mode) {
>  		case MTD_MODE_OTP_FACTORY:
> @@ -268,6 +267,7 @@ static ssize_t mtd_write(struct file *file, const char __user *buf, size_t count
>  {
>  	struct mtd_file_info *mfi = file->private_data;
>  	struct mtd_info *mtd = mfi->mtd;
> +	size_t size;
>  	char *kbuf;
>  	size_t retlen;
>  	size_t total_retlen=0;
> @@ -285,20 +285,18 @@ static ssize_t mtd_write(struct file *file, const char __user *buf, size_t count
>  	if (!count)
>  		return 0;
>  
> -	if (count > MAX_KMALLOC_SIZE)
> -		kbuf=kmalloc(MAX_KMALLOC_SIZE, GFP_KERNEL);
> -	else
> -		kbuf=kmalloc(count, GFP_KERNEL);
> +	size = min_t(size_t, count, MAX_KMALLOC_SIZE);
> +
> +	do {
> +		kbuf=kmalloc(size, GFP_KERNEL);
> +	} while (!kbuf && ((size >>= 1) >= PAGE_SIZE));
>  
>  	if (!kbuf)
>  		return -ENOMEM;
>  
>  	while (count) {
>  
> -		if (count > MAX_KMALLOC_SIZE)
> -			len = MAX_KMALLOC_SIZE;
> -		else
> -			len = count;
> +		len = min_t(size_t, count, size);
>  
>  		if (copy_from_user(kbuf, buf, len)) {
>  			kfree(kbuf);


-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

