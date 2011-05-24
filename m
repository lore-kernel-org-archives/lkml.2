Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1EXGea (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:34:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38635 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab1EXGe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:34:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=hpgSQgiz76inEBssdtm3Bl2jlkXksnw8wFgEpQGw/HrHKxdtc9Wus4cX+CEeHZXoUD
         Gu/KguzIIm8nLUVxLprt0FKRZQbD/dHclDeZMs8J5XkLKRPLoAFVf+pd5gE6t0DAZDdT
         RAP5Bg0MK8+FkxOXCGSqxJKaliJDwkiL3Tfsw=
Date: Mon, 23 May 2011 23:34:24 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: markgross@thegnar.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Milton Miller <milltonm@bga.com>, Simon Horman <horms@verge.net.au>
Subject: Re: linux-next: build warning after merge of the suspend tree
Message-ID: <20110524063424.GC18075@gvim.org>
Reply-To: markgross@thegnar.org
References: <20110523150636.ccd83777.sfr@canb.auug.org.au>
 <20110523141846.GA8122@gvim.org>
 <201105232154.52344.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105232154.52344.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 09:54:52PM +0200, Rafael J. Wysocki wrote:
> On Monday, May 23, 2011, mark gross wrote:
> > On Mon, May 23, 2011 at 03:06:36PM +1000, Stephen Rothwell wrote:
> > > Hi Rafael,
> > > 
> > > After merging the suspend tree, today's linux-next build (i386 defconfig
> > > among others) produced this warning:
> > > 
> > > kernel/pm_qos_params.c: In function 'pm_qos_power_write':
> > > kernel/pm_qos_params.c:420: warning: passing argument 3 of 'kstrtol' from incompatible pointer type
> > > include/linux/kernel.h:210: note: expected 'long int *' but argument is of type 's32 *'
> > > 
> > > Intreoduced by commit 365daa955e03 ("PM: Correct PM QOS's user mode
> > > interface to work with ascii input per").
> > 
> > Gah!  I'm sorry about that.
> > 
> > attached is a fix.
> > 
> > 
> > --mark
> > 
> > signed-off-by:markgross <markgross@thegnar.org>
> > 
> > 
> > 
> > From a8f0587b9ae598be5ca4c3cdda4e0ced6ca9baaf Mon Sep 17 00:00:00 2001
> > From: mgross <mgross@cr48>
> > Date: Mon, 23 May 2011 07:14:09 -0700
> > Subject: [PATCH] clean up a compile time warning in the use of strict_strtol but that was
> >  passing an s32 * when it should be passing a long *
> > 
> > ---
> >  kernel/pm_qos_params.c |    6 ++++--
> >  1 files changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index d61ecf3..dd37c56 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -405,6 +405,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  		size_t count, loff_t *f_pos)
> >  {
> >  	s32 value;
> > +	long safe_int;
> >  	int x;
> >  	char ascii_value[11];
> >  	struct pm_qos_request_list *pm_qos_req;
> > @@ -417,10 +418,11 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  		ascii_value[count] = 0;
> >  		if (copy_from_user(ascii_value, buf, count))
> >  			return -EFAULT;
> > -		if ((x=strict_strtol(ascii_value, 16, &value)) != 0){
> > -			pr_debug("%s, 0x%x, 0x%x\n",ascii_value, value, x);
> > +		if ((x=strict_strtol(ascii_value, 16, &safe_int)) != 0){
> > +			pr_debug("%s, 0x%lx, 0x%x\n",ascii_value, safe_int, x);
> >  			return -EINVAL;
> >  		}
> > +		value = (s32) safe_int;
> 
> Well, this doesn't seem quite right.
> 
> >  	} else
> >  		return -EINVAL;
> 
> Besides, if count == 11, there we'll write beyond ascii_value[], right?

right. That is a bug.

> 
> What about the appended patch instead of your original one?
Thank you!

> Rafael
> 
> 
> ---
> From: mark gross <markgross@thegnar.org>
> Subject: PM: Correct PM QOS's user mode interface to work with ascii input per
> 
> What is in the kernel docs.  Writing a string to the ABI from user mode
> comes in 2 flavors.  One with and one without a '\n' at the end.  This
> change accepts both.
> 
> # echo 0x12345678 > /dev/cpu_dma_latency
> 
> and
> 
> # echo -n 0x12345678 > /dev/cpu_dma_latency
> 
> now both work.
> 
> [rjw: Fixed up array bounds checking and type casting.]
> 
> Signed-off-by: mark gross <markgross@thegnar.org>
> Acked-by: Simon Horman <horms@verge.net.au>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  kernel/pm_qos_params.c |   25 ++++++++++++++++---------
>  1 file changed, 16 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/kernel/pm_qos_params.c
> ===================================================================
> --- linux-2.6.orig/kernel/pm_qos_params.c
> +++ linux-2.6/kernel/pm_qos_params.c
> @@ -40,6 +40,7 @@
>  #include <linux/string.h>
>  #include <linux/platform_device.h>
>  #include <linux/init.h>
> +#include <linux/kernel.h>
>  
>  #include <linux/uaccess.h>
>  
> @@ -404,24 +405,30 @@ static ssize_t pm_qos_power_write(struct
>  		size_t count, loff_t *f_pos)
>  {
>  	s32 value;
> -	int x;
>  	char ascii_value[11];
>  	struct pm_qos_request_list *pm_qos_req;
>  
>  	if (count == sizeof(s32)) {
>  		if (copy_from_user(&value, buf, sizeof(s32)))
>  			return -EFAULT;
> -	} else if (count == 11) { /* len('0x12345678/0') */
> -		if (copy_from_user(ascii_value, buf, 11))
> +	} else if (count >= 10) { /* '0x12345678' or '0x12345678\n'*/
Did you mean <= 11 here?  I know that Alan Stern wanted to see the ABI
adjusted to accept shorter hex string that the full 10 char string.

FWIW I'm ok with doing that.

> +		unsigned long int ulval;
> +		int ret;
> +
> +		count = 10;

I kind of wanted to return an error to the user if they violate the
documented format for the hex string.  With this code you get a silent
truncation of the lower digits if the string is "0x123456789abcdef"


> +		ascii_value[count] = 0;
> +		if (copy_from_user(ascii_value, buf, count))
>  			return -EFAULT;
> -		if (strlen(ascii_value) != 10)
> -			return -EINVAL;
> -		x = sscanf(ascii_value, "%x", &value);
> -		if (x != 1)
> +
> +		ret = strict_strtoul(ascii_value, 16, &ulval);
> +		if (ret){
> +			pr_debug("%s, 0x%lx, 0x%x\n", ascii_value, ulval, ret);
>  			return -EINVAL;
> -		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
> -	} else
> +		}
> +		value = (s32)lower_32_bits(ulval);
This shouldn't be needed if you are constrained to a hex format of
"0x12345678" but this is more readable.  lower_32_bits is a good idea.

--mark

> +	} else {
>  		return -EINVAL;
> +	}
>  
>  	pm_qos_req = filp->private_data;
>  	pm_qos_update_request(pm_qos_req, value);
