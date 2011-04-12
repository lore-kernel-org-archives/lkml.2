Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830Ab1DLJEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 05:04:00 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38014 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753523Ab1DLJD7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 05:03:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=dpUptHX7Ulk6jFYl5QLCkvwA8+ne5bwbjT64wynVRSeyo0Dks65bTqDa5dz3q/qGaI
         Ji+xyJ1tNXzCNt+1VAu5zGk9A+ctALB10wpWz5akSNYyYGaK/eD1dKnKZNdCr0l7MZ1x
         uLrycR+ZdQt3dR80v4Ps5tKevblxdOvp5lgPg=
Subject: Re: [PATCH 3/4]percpu_counter: fix code for 32bit systems
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cl@linux.com, tj@kernel.org
In-Reply-To: <1302595444.3981.129.camel@sli10-conroe>
References: <1302595444.3981.129.camel@sli10-conroe>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Apr 2011 11:03:55 +0200
Message-ID: <1302599035.3233.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 12 avril 2011 à 16:04 +0800, Shaohua Li a écrit :
> percpu_counter.counter is a 's64'. Accessing it in 32-bit system is racing.
> we need some locking to protect it otherwise some very wrong value could be
> accessed.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  include/linux/percpu_counter.h |   43 +++++++++++++++++++++++++++++++----------
>  1 file changed, 33 insertions(+), 10 deletions(-)
> 
> Index: linux/include/linux/percpu_counter.h
> ===================================================================
> --- linux.orig/include/linux/percpu_counter.h	2011-04-12 15:48:44.000000000 +0800
> +++ linux/include/linux/percpu_counter.h	2011-04-12 15:48:54.000000000 +0800
> @@ -54,7 +54,15 @@ static inline s64 percpu_counter_sum(str
>  
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>  {
> +#if BITS_PER_LONG == 32
> +	s64 count;
> +	spin_lock(&fbc->lock);
> +	count = fbc->count;
> +	spin_unlock(&fbc->lock);
> +	return count;
> +#else
>  	return fbc->count;
> +#endif
>  }
>  

Hmm... did you test this with LOCKDEP on ?

You add a possible deadlock here.

Hint : Some percpu_counter are used from irq context.

This interface assumes caller take the appropriate locking.



