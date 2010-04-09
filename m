Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755525Ab0DIHEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 03:04:21 -0400
Received: from mail.in-ulm.de ([217.10.8.10]:47043 "HELO mail.in-ulm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754260Ab0DIHES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 03:04:18 -0400
Date: Fri, 9 Apr 2010 09:04:16 +0200
From: Christian Ehrhardt <uni@c--e.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Avi Kivity <avi@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       David Miller <davem@davemloft.net>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 05/13] mm: Make use of the anon_vma ref count
Message-ID: <20100409070416.GA14118@lisa.in-ulm.de>
References: <20100408191737.296180458@chello.nl> <20100408192722.815377075@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100408192722.815377075@chello.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thu, Apr 08, 2010 at 09:17:42PM +0200, Peter Zijlstra wrote:
> @@ -302,23 +307,33 @@ again:
>  		goto out;
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
> -	spin_lock(&anon_vma->lock);
> +	if (!atomic_inc_not_zero(&anon_vma->ref))
> +		anon_vma = NULL;
>  
>  	if (page_rmapping(page) != anon_vma) {
> -		spin_unlock(&anon_vma->lock);
> +		anon_vma_put(anon_vma);
>  		goto again;
>  	}

AFAICS anon_vma_put might be called with anon_vma == NULL here which
will oops on the ref count. Not sure if

     page_rmapping(page) == anon_vma == NULL 

is possible, too.

    regards   Christian

