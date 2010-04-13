Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753044Ab0DMKxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 06:53:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37967 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab0DMKxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 06:53:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH -v2] rmap: make anon_vma_prepare link in all the anon_vmas of a mergeable VMA
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
In-Reply-To: <1271088103.20295.3383.camel@laptop>
References: <4BC33A02.8000307@redhat.com> <1271088103.20295.3383.camel@laptop>
Message-Id: <20100413194443.D116.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 13 Apr 2010 19:53:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  struct anon_vma *page_lock_anon_vma(struct page *page)
>  {
> @@ -294,14 +309,24 @@ struct anon_vma *page_lock_anon_vma(struct page *page)
>  	unsigned long anon_mapping;
>  
>  	rcu_read_lock();
> -	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> +	anon_mapping = (unsigned long)rcu_dereference(page->mapping);
>  	if ((anon_mapping & PAGE_MAPPING_FLAGS) != PAGE_MAPPING_ANON)
>  		goto out;
> -	if (!page_mapped(page))
> -		goto out;
>  
>  	anon_vma = (struct anon_vma *) (anon_mapping - PAGE_MAPPING_ANON);
>  	spin_lock(&anon_vma->lock);

Does anon->lock dereference is guranteed if page->_mapcount==-1?
It can be freed miliseconds ago, rcu_read_lock() doesn't provide such
gurantee.

perhaps, I'm missing your point.


