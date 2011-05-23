Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab1EWTyX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:54:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49681 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932729Ab1EWTyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:54:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: markgross@thegnar.org
Subject: Re: linux-next: build warning after merge of the suspend tree
Date: Mon, 23 May 2011 21:54:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Milton Miller <milltonm@bga.com>,
        Simon Horman <horms@verge.net.au>
References: <20110523150636.ccd83777.sfr@canb.auug.org.au> <20110523141846.GA8122@gvim.org>
In-Reply-To: <20110523141846.GA8122@gvim.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105232154.52344.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 23, 2011, mark gross wrote:
> On Mon, May 23, 2011 at 03:06:36PM +1000, Stephen Rothwell wrote:
> > Hi Rafael,
> > 
> > After merging the suspend tree, today's linux-next build (i386 defconfig
> > among others) produced this warning:
> > 
> > kernel/pm_qos_params.c: In function 'pm_qos_power_write':
> > kernel/pm_qos_params.c:420: warning: passing argument 3 of 'kstrtol' from incompatible pointer type
> > include/linux/kernel.h:210: note: expected 'long int *' but argument is of type 's32 *'
> > 
> > Intreoduced by commit 365daa955e03 ("PM: Correct PM QOS's user mode
> > interface to work with ascii input per").
> 
> Gah!  I'm sorry about that.
> 
> attached is a fix.
> 
> 
> --mark
> 
> signed-off-by:markgross <markgross@thegnar.org>
> 
> 
> 
> From a8f0587b9ae598be5ca4c3cdda4e0ced6ca9baaf Mon Sep 17 00:00:00 2001
> From: mgross <mgross@cr48>
> Date: Mon, 23 May 2011 07:14:09 -0700
> Subject: [PATCH] clean up a compile time warning in the use of strict_strtol but that was
>  passing an s32 * when it should be passing a long *
> 
> ---
>  kernel/pm_qos_params.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index d61ecf3..dd37c56 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -405,6 +405,7 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		size_t count, loff_t *f_pos)
>  {
>  	s32 value;
> +	long safe_int;
>  	int x;
>  	char ascii_value[11];
>  	struct pm_qos_request_list *pm_qos_req;
> @@ -417,10 +418,11 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  		ascii_value[count] = 0;
>  		if (copy_from_user(ascii_value, buf, count))
>  			return -EFAULT;
> -		if ((x=strict_strtol(ascii_value, 16, &value)) != 0){
> -			pr_debug("%s, 0x%x, 0x%x\n",ascii_value, value, x);
> +		if ((x=strict_strtol(ascii_value, 16, &safe_int)) != 0){
> +			pr_debug("%s, 0x%lx, 0x%x\n",ascii_value, safe_int, x);
>  			return -EINVAL;
>  		}
> +		value = (s32) safe_int;

Well, this doesn't seem quite right.

>  	} else
>  		return -EINVAL;

Besides, if count == 11, there we'll write beyond ascii_value[], right?

What about the appended patch instead of your original one?

Rafael


---
From: mark gross <markgross@thegnar.org>
Subject: PM: Correct PM QOS's user mode interface to work with ascii input per

What is in the kernel docs.  Writing a string to the ABI from user mode
comes in 2 flavors.  One with and one without a '\n' at the end.  This
change accepts both.

# echo 0x12345678 > /dev/cpu_dma_latency

and

# echo -n 0x12345678 > /dev/cpu_dma_latency

now both work.

[rjw: Fixed up array bounds checking and type casting.]

Signed-off-by: mark gross <markgross@thegnar.org>
Acked-by: Simon Horman <horms@verge.net.au>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/pm_qos_params.c |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

Index: linux-2.6/kernel/pm_qos_params.c
===================================================================
--- linux-2.6.orig/kernel/pm_qos_params.c
+++ linux-2.6/kernel/pm_qos_params.c
@@ -40,6 +40,7 @@
 #include <linux/string.h>
 #include <linux/platform_device.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 
 #include <linux/uaccess.h>
 
@@ -404,24 +405,30 @@ static ssize_t pm_qos_power_write(struct
 		size_t count, loff_t *f_pos)
 {
 	s32 value;
-	int x;
 	char ascii_value[11];
 	struct pm_qos_request_list *pm_qos_req;
 
 	if (count == sizeof(s32)) {
 		if (copy_from_user(&value, buf, sizeof(s32)))
 			return -EFAULT;
-	} else if (count == 11) { /* len('0x12345678/0') */
-		if (copy_from_user(ascii_value, buf, 11))
+	} else if (count >= 10) { /* '0x12345678' or '0x12345678\n'*/
+		unsigned long int ulval;
+		int ret;
+
+		count = 10;
+		ascii_value[count] = 0;
+		if (copy_from_user(ascii_value, buf, count))
 			return -EFAULT;
-		if (strlen(ascii_value) != 10)
-			return -EINVAL;
-		x = sscanf(ascii_value, "%x", &value);
-		if (x != 1)
+
+		ret = strict_strtoul(ascii_value, 16, &ulval);
+		if (ret){
+			pr_debug("%s, 0x%lx, 0x%x\n", ascii_value, ulval, ret);
 			return -EINVAL;
-		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
-	} else
+		}
+		value = (s32)lower_32_bits(ulval);
+	} else {
 		return -EINVAL;
+	}
 
 	pm_qos_req = filp->private_data;
 	pm_qos_update_request(pm_qos_req, value);
