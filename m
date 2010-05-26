Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab0EZRI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 13:08:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45004 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab0EZRIy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 13:08:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:message-id:content-type
         :content-transfer-encoding;
        b=KTwZZZGTWytLnFu6I5ANpXpmvnqldQk44ydAvf48sEu0hLbdEsS7gfzkLPV2MUmW/B
         961PyDbYOu/4UANDUQ883MNrya6UZAZ4nRVZU7aTxXUZVdPOcOurG+GEjUvJ8d9akXjt
         XktpB9jgOflnkjpkIw9dZPp+ofnJkK5HyRGS8=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 7/17] arch/arm/common: Add missing spin_unlock_irqrestore
Date: Wed, 26 May 2010 19:07:06 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.33-2-amd64; KDE/4.4.2; x86_64; ; )
Cc: Julia Lawall <julia@diku.dk>, Russell King <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1005261756000.23743@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005261756000.23743@ask.diku.dk>
MIME-Version: 1.0
Message-Id: <201005261907.06198.marek.vasut@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne St 26. května 2010 17:56:14 Julia Lawall napsal(a):
> From: Julia Lawall <julia@diku.dk>
> 
> Add a spin_unlock_irqrestore missing on the error path.  Although the lock
> is destroyed with the rest of the sachip structure in the function
> __sa1111_remove, it still seems useful to restore the interrupt state.
> 
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> expression E1;
> @@
> 
> * spin_lock_irqsave(E1,...);
>   <+... when != E1
>   if (...) {
>     ... when != E1
> *   return ...;
>   }
>   ...+>
> * spin_unlock_irqrestore(E1,...);
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
> Perhaps the unlock is now too early?
> 
>  arch/arm/common/sa1111.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/arm/common/sa1111.c b/arch/arm/common/sa1111.c
> index a52a27c..59e38ff 100644
> --- a/arch/arm/common/sa1111.c
> +++ b/arch/arm/common/sa1111.c
> @@ -959,6 +959,7 @@ static int sa1111_resume(struct platform_device *dev)
>  	 */
>  	id = sa1111_readl(sachip->base + SA1111_SKID);
>  	if ((id & SKID_ID_MASK) != SKID_SA1111_ID) {
> +		spin_unlock_irqrestore(&sachip->lock, flags);
>  		__sa1111_remove(sachip);
>  		platform_set_drvdata(dev, NULL);
>  		kfree(save);

Why are "readl"s protected by spinlock anyway ? Can't we just move the locking 
past the code above ?

I'm no sa1111 expert though, Russell ?

Cheers
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
