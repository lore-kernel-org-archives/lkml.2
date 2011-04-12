Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711Ab1DLXNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 19:13:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34797 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756324Ab1DLXNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 19:13:48 -0400
Date: Tue, 12 Apr 2011 16:13:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Re: printk: /dev/kmsg - properly support writev() to avoid
 interleaved printk() lines
Message-Id: <20110412161323.b4b03a1d.akpm@linux-foundation.org>
In-Reply-To: <1302143360.1143.3.camel@zag>
References: <1302143360.1143.3.camel@zag>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Apr 2011 04:29:20 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> From: Kay Sievers <kay.sievers@vrfy.org>
> 
> printk: /dev/kmsg - properly support writev() to avoid interleaved printk lines
> 
> We should avoid calling printk() in a loop, when we pass a single
> string to /dev/kmsg with writev(). 
> 
> ...
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -806,29 +806,40 @@ static const struct file_operations oldmem_fops = {
>  };
>  #endif
>  
> -static ssize_t kmsg_write(struct file *file, const char __user *buf,
> -			  size_t count, loff_t *ppos)
> +static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
> +			   unsigned long count, loff_t pos)
>  {
> -	char *tmp;
> -	ssize_t ret;
> +	char *line, *p;
> +	int len, i;
> +	ssize_t ret = -EFAULT;
>  
> -	tmp = kmalloc(count + 1, GFP_KERNEL);
> -	if (tmp == NULL)
> +	len = iov_length(iv, count);
> +	line = p = kmalloc(len + 1, GFP_KERNEL);
> +	if (line == NULL)
>  		return -ENOMEM;
> -	ret = -EFAULT;
> -	if (!copy_from_user(tmp, buf, count)) {
> -		tmp[count] = 0;
> -		ret = printk("%s", tmp);
> -		if (ret > count)
> -			/* printk can add a prefix */
> -			ret = count;
> +
> +	/*
> +	 * copy all vectors into a single string, to ensure we do
> +	 * not interleave our log line with other printk calls
> +	 */
> +	for (i = 0; i < count; i++) {
> +		if (copy_from_user(p, iv[i].iov_base, iv[i].iov_len))
> +			goto out;
> +		p += iv[i].iov_len;
>  	}
> -	kfree(tmp);
> +	p[0] = '\0';
> +
> +	ret = printk("%s", line);
> +	/* printk can add a prefix */
> +	if (ret > len)
> +		ret = len;
> +out:
> +	kfree(line);
>  	return ret;
>  }
>  
>  static const struct file_operations kmsg_fops = {
> -	.write = kmsg_write,
> +	.aio_write = kmsg_writev,
>  	.llseek = noop_llseek,
>  };
>  

LGTM.  Nitpicks:

From: Andrew Morton <akpm@linux-foundation.org>

make `len' size_t, avoid multiple-assignments.

Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/char/mem.c~dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines-fix drivers/char/mem.c
--- a/drivers/char/mem.c~dev-kmsg-properly-support-writev-to-avoid-interleaved-printk-lines-fix
+++ a/drivers/char/mem.c
@@ -810,11 +810,11 @@ static ssize_t kmsg_writev(struct kiocb 
 			   unsigned long count, loff_t pos)
 {
 	char *line, *p;
-	int len, i;
+	int i;
 	ssize_t ret = -EFAULT;
+	size_t len = iov_length(iv, count);
 
-	len = iov_length(iv, count);
-	line = p = kmalloc(len + 1, GFP_KERNEL);
+	line = kmalloc(len + 1, GFP_KERNEL);
 	if (line == NULL)
 		return -ENOMEM;
 
@@ -822,6 +822,7 @@ static ssize_t kmsg_writev(struct kiocb 
 	 * copy all vectors into a single string, to ensure we do
 	 * not interleave our log line with other printk calls
 	 */
+	p = line;
 	for (i = 0; i < count; i++) {
 		if (copy_from_user(p, iv[i].iov_base, iv[i].iov_len))
 			goto out;
_



