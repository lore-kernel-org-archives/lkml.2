Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1L1Oht (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 09:37:49 -0500
Received: from mail.solarflare.com ([216.237.3.220]:43729 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753936Ab1L1Ohk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 09:37:40 -0500
Message-ID: <1325083051.2327.47.camel@deadeye>
Subject: Re: [PATCH 1/1] via-rhine: Fix hanging with high CPU load on
 low-end broads.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Bjarke Istrup Pedersen <gurligebis@gentoo.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Roger Luethi <rl@hellgate.ch>
Date: Wed, 28 Dec 2011 15:37:31 +0100
In-Reply-To: <1325075319-13464-1-git-send-email-gurligebis@gentoo.org>
References: <1325075319-13464-1-git-send-email-gurligebis@gentoo.org>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [176.99.104.76]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18604.005
X-TM-AS-Result: No--2.580200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-28 at 12:28 +0000, Bjarke Istrup Pedersen wrote:
> Working around problem causing high CPU load and hanging system when
> there is alot of network trafic.
> 
> It is kind of an ugly way to work around it, but it allows the Soekris
> net5501 to have trafic between two of it's NICs without hanging so much
> that the watchdog kicks in and does a hard reboot of the system.
> 
> There is more info on the problem here:
> http://http://lists.soekris.com/pipermail/soekris-tech/2010-October/016889.html
> 
> Tested with positive results on two Soekris net5501-70 boxes.

This is completely wrong.  In a UP configuration the extra spinlock
calls have no effect (except perhaps a small delay).  In an SMP
configuration they will cause rhine_tx() to deadlock when it also tries
to acquire the spinlock.

Ben.

[...]
> diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
> index f34dd99..8c77dcd 100644
> --- a/drivers/net/ethernet/via/via-rhine.c
> +++ b/drivers/net/ethernet/via/via-rhine.c
> @@ -1567,6 +1567,9 @@ static irqreturn_t rhine_interrupt(int irq, void *dev_instance)
>         int boguscnt = max_interrupt_work;
>         int handled = 0;
>  
> +       if (!spin_trylock(&rp->lock))
> +               return IRQ_RETVAL(handled);
> +
>         while ((intr_status = get_intr_status(dev))) {
>                 handled = 1;
>  
> @@ -1616,6 +1619,8 @@ static irqreturn_t rhine_interrupt(int irq, void *dev_instance)
>                 }
>         }
>  
> +       spin_unlock(&rp->lock);
> +
>         if (debug > 3)
>                 netdev_dbg(dev, "exiting interrupt, status=%08x\n",
>                            ioread16(ioaddr + IntrStatus));

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

