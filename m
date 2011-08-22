Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1HVUoY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:44:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43098 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753698Ab1HVUoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:44:21 -0400
Date: Mon, 22 Aug 2011 13:43:48 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] debug-pagealloc: add support for highmem pages
Message-Id: <20110822134348.a57db0e1.akpm@linux-foundation.org>
In-Reply-To: <1314030548-21082-3-git-send-email-akinobu.mita@gmail.com>
References: <1314030548-21082-1-git-send-email-akinobu.mita@gmail.com>
	<1314030548-21082-3-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 01:29:06 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This adds support for highmem pages poisoning and verification to the
> debug-pagealloc feature for no-architecture support.
> 
> ...
>
>  static void poison_page(struct page *page)
>  {
>  	void *addr;
> -
> -	if (PageHighMem(page)) {
> -		poison_highpage(page);
> -		return;
> +	unsigned long flags;
> +	bool highmem = PageHighMem(page);
> +
> +	if (highmem) {
> +		local_irq_save(flags);
> +		addr = kmap_atomic(page);
> +	} else {
> +		addr = page_address(page);
>  	}
>  	set_page_poison(page);
> -	addr = page_address(page);
>  	memset(addr, PAGE_POISON, PAGE_SIZE);
> +
> +	if (highmem) {
> +		kunmap_atomic(addr);
> +		local_irq_restore(flags);
> +	}
>  }

This seems more complicated than is needed.  Couldn't we just do

static void poison_page(struct page *page)
{
	void *addr;

	preempt_disable();
	addr = kmap_atomic(page);
	set_page_poison(page);
	memset(addr, PAGE_POISON, PAGE_SIZE);
	kunmap_atomic(addr);
	preempt_enable();
}

?

> +		addr = kmap_atomic(page);

That reminds me - we need to convert every "kmap_atomic(p, foo)" to
"kmap_atomic(p)" then remove the kmap_atomic back-compatibility macro.

