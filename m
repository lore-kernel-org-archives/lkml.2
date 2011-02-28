Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab1B1XZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 18:25:18 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33294 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659Ab1B1XZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 18:25:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vuh0LBjECsHlNMoato+8707BWEv3F/fduAo6FBG7/QzvkunthttCvMG6H6EaSMvfIp
         Jk5JJko88nNswugd2fLBWE2N3VIkfSQrRXFXoKsczYL1EL7IQI4X2p5wwo7pmEt8wJtw
         JhJaeGGtu3/6umHb4m77dnpPMvEkVtJuJiqCs=
Date: Tue, 1 Mar 2011 08:25:08 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm: compaction: Minimise the time IRQs are
 disabled while isolating pages for migration
Message-ID: <20110228232508.GA2265@barrios-desktop>
References: <1298664299-10270-1-git-send-email-mel@csn.ul.ie>
 <1298664299-10270-3-git-send-email-mel@csn.ul.ie>
 <20110228230131.GB1896@barrios-desktop>
 <20110228230712.GR22700@random.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110228230712.GR22700@random.random>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 12:07:12AM +0100, Andrea Arcangeli wrote:
> On Tue, Mar 01, 2011 at 08:01:31AM +0900, Minchan Kim wrote:
> > I am not sure it's good if we release the lock whenever lru->lock was contended
> > unconditionally? There are many kinds of lru_lock operations(add to lru, 
> > del from lru, isolation, reclaim, activation, deactivation and so on).
> 
> This is mostly to mirror cond_resched_lock (which actually uses
> spin_needbreak but it's ok to have it also when preempt is off). I
> doubt it makes a big difference but I tried to mirror
> cond_resched_lock.

But what's the benefit of releasing lock in here when lock contentionn happen where
activate_page for example? 
> 
> > Do we really need to release the lock whenever all such operations were contened?
> > I think what we need is just spin_is_contended_irqcontext.
> > Otherwise, please write down the comment for justifying for it.
> 
> What is spin_is_contended_irqcontext?

I thought what we need function is to check lock contention happened in only irq context
for short irq latency.

> 
> > This patch is for reducing for irq latency but do we have to check signal 
> > in irq hold time?
> 
> I think it's good idea to check the signal in case the loop is very
> long and this is run in direct compaction context.

I don't oppose the signal check.
I am not sure why we should check by just sign of lru_lock contention.

How about this by coarse-grained?

               /* give a chance to irqs before checking need_resched() */
               if (!((low_pfn+1) % SWAP_CLUSTER_MAX)) {
                       if (fatal_signal_pending(current))
                               break;
                       spin_unlock_irq(&zone->lru_lock);
                       unlocked = true;
               }
               if (need_resched() || spin_is_contended(&zone->lru_lock)) {
                       if (!unlocked)
                               spin_unlock_irq(&zone->lru_lock);
                       cond_resched();
                       spin_lock_irq(&zone->lru_lock);
               } else if (unlocked)
                       spin_lock_irq(&zone->lru_lock);


> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
