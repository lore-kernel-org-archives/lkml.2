Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666Ab2K2NLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:11:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52391 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2K2NLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:11:07 -0500
Date: Thu, 29 Nov 2012 13:08:44 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michael Spang <spang@chromium.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Fix page counting in mem_init and show_mem
Message-ID: <20121129130844.GI19440@n2100.arm.linux.org.uk>
References: <1350956091-5276-1-git-send-email-spang@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350956091-5276-1-git-send-email-spang@chromium.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 09:34:51PM -0400, Michael Spang wrote:
>  	for_each_bank (i, mi) {
>  		struct membank *bank = &mi->bank[i];
> -		unsigned int pfn1, pfn2;
> -		struct page *page, *end;
> +		unsigned int start, end, pfn;
>  
> -		pfn1 = bank_pfn_start(bank);
> -		pfn2 = bank_pfn_end(bank);
> +		start = bank_pfn_start(bank);
> +		end = bank_pfn_end(bank);
>  
> -		page = pfn_to_page(pfn1);
> -		end  = pfn_to_page(pfn2 - 1) + 1;
> +		for (pfn = start; pfn < end; pfn++) {
> +			struct page *page;
> +
> +			if (!pfn_valid(pfn))
> +				continue;

This is not a very good fix; what this means is that we end up calling
pfn_valid() for each and every page in the system, and as pfn_valid()
may not be a simple test (but a search) we should avoid that when we're
iterating over all pages in the system.

Firstly, the mem blank information is assumed from the very beginning
to be aligned with the sparsemem split-up.  This comes from the previous
discontiguous implementation where this was an absolute requirement.  We
continue to require that.

Secondly, if you're worred about the stolen memory, then we need to be
iterating over the memblock information instead of the membank information.
This is slightly more complex because memblock will merge neighbouring
regions into one contiguous entry - and this needs to be split up here.
This is why I persisted with the membank stuff here as that _should_
already be appropriately split.

In the long run though, moving to memblock and dealing better with the
split memory maps (rather than looking up each and every page using
pfn_to_page()) is the right way to go.
