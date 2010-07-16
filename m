Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966184Ab0GPUda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 16:33:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62921 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab0GPUd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 16:33:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MWly6oXmcCJ1c6j+LvZn3on+hoXmi0n1ynGkSuWnEzz8efatL78Qr6JmXgwpDmJAG/
         NmWFtL3zv4Pj7ONcCg5QNilwbKRWAAHku2jTjboGTROpkkPpwT8UncVr0L72vbXW+bzJ
         Tcc/ca36s5ONalqYyTyHIcBfzEixSkNkispQ8=
Date: Fri, 16 Jul 2010 22:30:55 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/15] alpha: srmcons: localize spin_lock section
Message-ID: <20100716203055.GA2731@joi.lan>
References: <1279296747-24783-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279296747-24783-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 08:12:27PM +0400, Kulikov Vasiliy wrote:
> Scale down spin_lock_irqsave/spin_unlock_irqrestore exactly to area
> where it is needed. Also it makes static checkers happy as code checks
> kmalloc() result value exactly after call.
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  arch/alpha/kernel/srmcons.c |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
> index 783f4e5..6b04005 100644
> --- a/arch/alpha/kernel/srmcons.c
> +++ b/arch/alpha/kernel/srmcons.c
> @@ -165,17 +165,15 @@ srmcons_get_private_struct(struct srmcons_private **ps)
>  
>  	if (srmconsp == NULL) {
>  		srmconsp = kmalloc(sizeof(*srmconsp), GFP_KERNEL);
> -		spin_lock_irqsave(&srmconsp_lock, flags);
> -
>  		if (srmconsp == NULL)
>  			retval = -ENOMEM;
>  		else {
> +			spin_lock_irqsave(&srmconsp_lock, flags);
>  			srmconsp->tty = NULL;
>  			spin_lock_init(&srmconsp->lock);
>  			init_timer(&srmconsp->timer);
> +			spin_unlock_irqrestore(&srmconsp_lock, flags);
>  		}
> -
> -		spin_unlock_irqrestore(&srmconsp_lock, flags);
>  	}
>  
>  	*ps = srmconsp;
> -- 

Locking in this function seems to be broken. If we are unlucky:
- two cpus will allocate, initialize and return two different pointers
- two cpus will allocate, but both initialize only one (two times!) and return
  the same pointer (so one of them will be leaked) - 2 initializations may lead
  to double unlock later, etc
- ...

Something like patch below is needed. I don't have alpha cross compiler so
I can't even compile it...

---
From: Marcin Slusarz <marcin.slusarz@gmail.com>
Subject: [PATCH] alpha: fix races in srmcons_get_private_struct

---
 arch/alpha/kernel/srmcons.c |   38 ++++++++++++++++++++++++--------------
 1 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/alpha/kernel/srmcons.c b/arch/alpha/kernel/srmcons.c
index 783f4e5..531ac99 100644
--- a/arch/alpha/kernel/srmcons.c
+++ b/arch/alpha/kernel/srmcons.c
@@ -161,25 +161,35 @@ srmcons_get_private_struct(struct srmcons_private **ps)
 	static struct srmcons_private *srmconsp = NULL;
 	static DEFINE_SPINLOCK(srmconsp_lock);
 	unsigned long flags;
-	int retval = 0;
+	struct srmcons_private *tmp;
 
-	if (srmconsp == NULL) {
-		srmconsp = kmalloc(sizeof(*srmconsp), GFP_KERNEL);
-		spin_lock_irqsave(&srmconsp_lock, flags);
-
-		if (srmconsp == NULL)
-			retval = -ENOMEM;
-		else {
-			srmconsp->tty = NULL;
-			spin_lock_init(&srmconsp->lock);
-			init_timer(&srmconsp->timer);
-		}
+	if (srmconsp) {
+		*ps = srmconsp;
+		return 0;
+	}
 
-		spin_unlock_irqrestore(&srmconsp_lock, flags);
+	tmp = kmalloc(sizeof(*srmconsp), GFP_KERNEL);
+	if (!tmp) {
+		*ps = NULL;
+		return -ENOMEM;
 	}
 
+	spin_lock_irqsave(&srmconsp_lock, flags);
+
+	/* recheck under lock to not race with another cpu */
+	if (srmconsp == NULL) {
+		tmp->tty = NULL;
+		spin_lock_init(&tmp->lock);
+		init_timer(&tmp->timer);
+
+		srmconsp = tmp;
+	} else
+		kfree(tmp);
+
+	spin_unlock_irqrestore(&srmconsp_lock, flags);
+
 	*ps = srmconsp;
-	return retval;
+	return 0;
 }
 
 static int
-- 
1.7.1

