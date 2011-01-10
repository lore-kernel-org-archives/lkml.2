Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab1AJUgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 15:36:17 -0500
Received: from smtp-out.google.com ([74.125.121.67]:17493 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab1AJUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 15:36:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=a2EWHVCfwEDh7BMrcNXKcS6LxUdQVfvBALNmmSBHImbm/HS3gPuRzJFVi3KJfneUBS
         DXLFGjrPSbsnAoJBzUOg==
Date: Mon, 10 Jan 2011 12:36:10 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Catalin Marinas <catalin.marinas@arm.com>
cc: linux-kernel@vger.kernel.org,
        =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] kmemleak: Reduce verbosity when memory allocation
 fails
In-Reply-To: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com>
Message-ID: <alpine.DEB.2.00.1101101232580.11969@chino.kir.corp.google.com>
References: <20110110181133.14995.12364.stgit@e102109-lin.cambridge.arm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011, Catalin Marinas wrote:

> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index bd9bc21..eee8e31 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -113,7 +113,8 @@
>  #define BYTES_PER_POINTER	sizeof(void *)
>  
>  /* GFP bitmask for kmemleak internal allocations */
> -#define GFP_KMEMLEAK_MASK	(GFP_KERNEL | GFP_ATOMIC)
> +#define gfp_kmemleak_mask(gfp)	((gfp) & (GFP_KERNEL | GFP_ATOMIC) | \
> +				 __GFP_NOWARN)

It would be a shame if the allocation were __GFP_NORETRY and kmemleak 
ended up looping forever because it suppresses the bit for a single page, 
it uses __GFP_NOMEMALLOC and kmemleak ends up allocating from memory 
reserves, or it uses __GFP_HARDWALL and kmemleak is allocating metadata in 
a different cpuset.

I'm not sure why you're not just masking __GFP_NOFAIL and __GFP_REPEAT and 
then failing gracefully?  (And __GFP_ZERO and __GFP_COMP, too, of course.)
