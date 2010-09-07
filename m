Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756824Ab0IGNiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:38:12 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43751 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0IGNiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:38:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=XUDt4KZ86CQ8Qqf/16oIrmkOguF/Pe+ri4i0I+O9M5g1hVs7x1x/ila7DclyVIYRJi
         ILRljvMF5xzPuWqHJZmpTmFANlsjSc6aZ6xhlb/M33Hdb4diXI8NOW2g8Y4UgfvRRTgG
         KzwH7fjwJjvACbzeyCWB4G/swwAJwQHsw4Cf4=
Date: Tue, 7 Sep 2010 06:38:05 -0700
From: mark gross <markgross@thegnar.org>
To: mark gross <markgross@thegnar.org>
Cc: Dan Carpenter <error27@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <James.Bottomley@suse.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] pm_qos_params: cleanup: terminate a string
Message-ID: <20100907133805.GA20050@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100903124105.GJ5437@bicker>
 <20100907062227.GB25651@gvim.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100907062227.GB25651@gvim.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:22:27PM -0700, mark gross wrote:
> On Fri, Sep 03, 2010 at 02:41:06PM +0200, Dan Carpenter wrote:
> > This is just a picky thing, but we pass an possibly unterminated string
> > to printk if debugging is turned on.  Also printk level is set to
> > "debug" by pr_debug() so the "KERN_ERR" isn't used.
> 
> Picky is good.  But we should probably get the other pr_debug fixed and
> return -EINVAL if the strlen of the ascii_value is not bigger than 10.
> 
> thanks for finding my screw up!
> 
> 
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > 
> > diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> > index b7e4c36..310a51e 100644
> > --- a/kernel/pm_qos_params.c
> > +++ b/kernel/pm_qos_params.c
> > @@ -389,10 +389,11 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
> >  	} else if (count == 11) { /* len('0x12345678/0') */
> >  		if (copy_from_user(ascii_value, buf, 11))
> >  			return -EFAULT;
> > +		ascii_value[10] = '\0';
> >  		x = sscanf(ascii_value, "%x", &value);
> >  		if (x != 1)
> >  			return -EINVAL;
> > -		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
> > +		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
> >  	} else
> >  		return -EINVAL;
> >  
> 
> Updated version of this patch:
> 
> --mark
> 
> Signed-off-by: mark gross <markgross@thegnar.org>
> 
> Subject: [PATCH] correct some pr_debug misuse and add a stronger parrameter check to
>  pm_qos_write for the ascii hex value case.  Thanks to Dan Carpenter for
>  pointing out the problem!
> 
> ---
>  kernel/pm_qos_params.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
> index f42d3f7..db4295a 100644
> --- a/kernel/pm_qos_params.c
> +++ b/kernel/pm_qos_params.c
> @@ -155,7 +155,7 @@ static void update_target(int pm_qos_class)
>  		call_notifier = 1;
>  		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
>  				extreme_value);
> -		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
> +		pr_debug("new target for qos %d is %d\n", pm_qos_class,
>  			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
>  	}
>  	spin_unlock_irqrestore(&pm_qos_lock, flags);
> @@ -374,10 +374,12 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>  	} else if (count == 11) { /* len('0x12345678/0') */
>  		if (copy_from_user(ascii_value, buf, 11))
>  			return -EFAULT;
> +		if (strlen(ascii_value) > 10)
                         should be !=

> +			return -EINVAL;
>  		x = sscanf(ascii_value, "%x", &value);
>  		if (x != 1)
>  			return -EINVAL;
> -		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
> +		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
>  	} else
>  		return -EINVAL;
>  
> -- 
> 1.7.0.4

updated patch 

Signed-off-by: mark gross <markgross@thegnar.org>

--mgross 

Subject: [PATCH] correct some pr_debug misuse and add a stronger parrameter check to
 pm_qos_write for the ascii hex value case.  Thanks to Dan Carpenter for
 pointing out the problem!

---
 kernel/pm_qos_params.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/pm_qos_params.c b/kernel/pm_qos_params.c
index f42d3f7..aae58d2 100644
--- a/kernel/pm_qos_params.c
+++ b/kernel/pm_qos_params.c
@@ -155,7 +155,7 @@ static void update_target(int pm_qos_class)
 		call_notifier = 1;
 		atomic_set(&pm_qos_array[pm_qos_class]->target_value,
 				extreme_value);
-		pr_debug(KERN_ERR "new target for qos %d is %d\n", pm_qos_class,
+		pr_debug("new target for qos %d is %d\n", pm_qos_class,
 			atomic_read(&pm_qos_array[pm_qos_class]->target_value));
 	}
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
@@ -374,10 +374,12 @@ static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
 	} else if (count == 11) { /* len('0x12345678/0') */
 		if (copy_from_user(ascii_value, buf, 11))
 			return -EFAULT;
+		if (strlen(ascii_value) != 10)
+			return -EINVAL;
 		x = sscanf(ascii_value, "%x", &value);
 		if (x != 1)
 			return -EINVAL;
-		pr_debug(KERN_ERR "%s, %d, 0x%x\n", ascii_value, x, value);
+		pr_debug("%s, %d, 0x%x\n", ascii_value, x, value);
 	} else
 		return -EINVAL;
 
-- 
1.7.0.4


