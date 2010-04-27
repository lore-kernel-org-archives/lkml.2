Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0D0JGV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 05:06:21 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:44437 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0D0JGT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 05:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=W0xWVKhaAjrk3fij4RKttxZ7FL72yPoKameg+8zQAJuxe5bYXYpw24a7CyBciuyzNM
         HJGAdcgeQycHaihKl5trZ41x40/8TJoHeLsVHIzOmF6nX+hlT2trxuDXLer8u+6puD+G
         FXbNcDqyOK115ONCATEuODnHrnzSoyEgPOdMQ=
Date: Tue, 27 Apr 2010 11:05:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [patch] gpio: potential null dereference
Message-ID: <20100427090533.GZ29093@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jani Nikula <ext-jani.1.nikula@nokia.com>,
	David Brownell <dbrownell@users.sourceforge.net>,
	Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20100426192520.GU29093@bicker> <20100426230515.GA1388@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100426230515.GA1388@emlix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 01:05:15AM +0200, Daniel Glöckner wrote:
> On Mon, Apr 26, 2010 at 09:25:20PM +0200, Dan Carpenter wrote:
> > Smatch found a potential null dereference in gpio_setup_irq().  The 
> > "pdesc" variable is allocated with idr_find() that can return NULL.  If
> > gpio_setup_irq() is called with 0 as gpio_flags and "pdesc" is null, it
> > would OOPs here.
> 
> idr_find() doesn't allocate, idr_get_new_above() does.
> Assuming idr_find() never fails for an id if idr_get_new_above()
> successfully allocated that id, I don't think we can reach that
> line with pdesc being NULL:
> 
> - There are two gotos leading to free_sd
> - #2 is after a block that allocates pdesc
> - #1 is in an if (!gpio_flags) block
> - We exit early if ((desc->flags & GPIO_TRIGGER_MASK) == gpio_flags)
> - Therefore (desc->flags & GPIO_TRIGGER_MASK) must be != 0 to reach #1
> - Trigger flags are added to desc->flags only after we have
>   successfully allocated pdesc (i.e. right before return 0)
> - We start off with no trigger flags set
> 

Are you sure?  If we know that the call to idr_find() returns a valid 
pointer we could remove a lot of error handling code...

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 76be229..54922a6 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -330,14 +330,6 @@ static irqreturn_t gpio_sysfs_irq(int irq, void *priv)
 	return IRQ_HANDLED;
 }
 
-static void gpio_notify_sysfs(struct work_struct *work)
-{
-	struct poll_desc	*pdesc;
-
-	pdesc = container_of(work, struct poll_desc, work);
-	sysfs_notify_dirent(pdesc->value_sd);
-}
-
 static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		unsigned long gpio_flags)
 {
@@ -353,14 +345,10 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		return -EIO;
 
 	id = desc->flags >> PDESC_ID_SHIFT;
+	/* idr_find() always returns a valid pointer here */
 	pdesc = idr_find(&pdesc_idr, id);
-	if (pdesc) {
-		free_irq(irq, &pdesc->work);
-		cancel_work_sync(&pdesc->work);
-	}
 
 	desc->flags &= ~GPIO_TRIGGER_MASK;
-
 	if (!gpio_flags) {
 		ret = 0;
 		goto free_sd;
@@ -374,39 +362,6 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 		irq_flags |= test_bit(FLAG_ACTIVE_LOW, &desc->flags) ?
 			IRQF_TRIGGER_FALLING : IRQF_TRIGGER_RISING;
 
-	if (!pdesc) {
-		pdesc = kmalloc(sizeof(*pdesc), GFP_KERNEL);
-		if (!pdesc) {
-			ret = -ENOMEM;
-			goto err_out;
-		}
-
-		do {
-			ret = -ENOMEM;
-			if (idr_pre_get(&pdesc_idr, GFP_KERNEL))
-				ret = idr_get_new_above(&pdesc_idr,
-						pdesc, 1, &id);
-		} while (ret == -EAGAIN);
-
-		if (ret)
-			goto free_mem;
-
-		desc->flags &= GPIO_FLAGS_MASK;
-		desc->flags |= (unsigned long)id << PDESC_ID_SHIFT;
-
-		if (desc->flags >> PDESC_ID_SHIFT != id) {
-			ret = -ERANGE;
-			goto free_id;
-		}
-
-		pdesc->value_sd = sysfs_get_dirent(dev->kobj.sd, "value");
-		if (!pdesc->value_sd) {
-			ret = -ENODEV;
-			goto free_id;
-		}
-		INIT_WORK(&pdesc->work, gpio_notify_sysfs);
-	}
-
 	ret = request_irq(irq, gpio_sysfs_irq, irq_flags,
 			"gpiolib", &pdesc->work);
 	if (ret)
@@ -417,12 +372,9 @@ static int gpio_setup_irq(struct gpio_desc *desc, struct device *dev,
 
 free_sd:
 	sysfs_put(pdesc->value_sd);
-free_id:
 	idr_remove(&pdesc_idr, id);
 	desc->flags &= GPIO_FLAGS_MASK;
-free_mem:
 	kfree(pdesc);
-err_out:
 	return ret;
 }
 

