Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab1DMTEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 15:04:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46193 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757105Ab1DMTEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 15:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=GwMy5kUcS5781V9C1TG43MKnLSdAa1pXSXdwbYS4EXTLpiO+gaoWpkECW3QIZA0Sz0
         DfuHYXNk7Uulbn1Dx65M84aYrrWvD7+vHthZ7gJwZjjL0ASWKrxFh7IFDkXW0xvmvAIA
         sykxUyBKEBJG2kLn0FtTeQbLL6BH4NvqeNEQI=
Date: Thu, 14 Apr 2011 04:04:11 +0900
From: Tejun Heo <tj@kernel.org>
To: shaohua.li@intel.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, cl@linux.com,
        eric.dumazet@gmail.com
Subject: Re: [patch v2 3/4] percpu_counter: fix code for 32bit systems
Message-ID: <20110413190411.GC3987@mtj.dyndns.org>
References: <20110413075715.090406229@sli10-conroe.sh.intel.com>
 <20110413080517.735973727@sli10-conroe.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110413080517.735973727@sli10-conroe.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 03:57:18PM +0800, shaohua.li@intel.com wrote:
>  static inline s64 percpu_counter_read(struct percpu_counter *fbc)
>  {
> +#if BITS_PER_LONG == 32
> +	s64 count;
> +	unsigned long flags;
> +	spin_lock_irqsave(&fbc->lock, flags);
> +	count = fbc->count;
> +	spin_unlock_irqrestore(&fbc->lock, flags);
> +	return count;
> +#else
>  	return fbc->count;
> +#endif

I don't think this is safe.  The possible deadlock scenario was
percpu_counter_read() being called from irq context and adding irq
locking to percpu_counter_read() doesn't change that in any way.  You
should be changing locking in other places.  Given that the next patch
would make this dancing with locks all pointless, my suggestion is to
drop this patch and proceed with atomic64_t conversion directly and
note that the conversion also removes possible 32bit deviation on
32bit archs.

Thanks.

-- 
tejun
