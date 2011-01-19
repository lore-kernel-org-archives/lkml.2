Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab1ASNNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 08:13:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:65318 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1ASNNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 08:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jRkE+WjNAEf8f9djbGrTEcfhjh54krZj4grgDNLqUt6BbMri6yJ/tOAcTrJ8burokM
         71QzCKyzlwTj9khJaPpQp2QLJzlZjvVe/3k+QOZ48mimDUStQXZTuyqBRY4P42QR8gr6
         8hB+gBdq4PI6WGDwnuYSCowVHDf4hIpddl4iw=
Date: Wed, 19 Jan 2011 14:13:29 +0100
From: Tejun Heo <tj@kernel.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: percpu related boot crash on x86 (was: Linux 2.6.38-rc1)
Message-ID: <20110119131329.GB14096@mtj.dyndns.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119120200.GA1057@elte.hu>
 <1295441307.28776.15.camel@laptop>
 <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=gxMkzO63RAWiuFt9vp57dvi4d=TaT=NmuvyY2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jan 19, 2011 at 02:56:23PM +0200, Pekka Enberg wrote:
> Is vmalloc() and vfree() supposed to work with interrupts disabled? I
> always thought they weren't which would mean something in
> pcpu_mem_alloc() needs changing...

They aren't but percpu allocator doesn't call them with interrupts
disabled normally.  It only happens during early boot before it's
enabled for the first time but this is an allowed exception.  We'll
probably need to update the WARN_ON to consider the rare call path.
It also looks like something in that path is turning off/on IRQ
instead of saving/restoring it, so that probably needs to be changed
too but both aren't really critical.

I think the real problem is a lot of unsigned int percpu allocations
added by 6c9ae009 (irq: use per_cpu kstat_irqs).  percpu allocator
should be able to cope but it assumes that it would always be able to
allocate contiguous allocation map using vmalloc and that might be
failing, although I cannot readily see how or why that would happen
frequently on a 64bit machine.

Thanks.

-- 
tejun
