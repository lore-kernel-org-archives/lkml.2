Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab0IJRP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:15:58 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64600 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425Ab0IJRP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:15:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=GsQOKqoaikCaDKFkrOoHeyECfaZ3sSXXWzxFQrphV4eEIKGX2KGcKQ7EXkKiSSORI8
         wHAXdav6xSu6LQpAdx9k0VzgFRTPSWfCwLHQ/vAfGL5yrN4ZH3Gy33pJcQD3/TA0Ss1Z
         t3pym/ekPfk2O65MFeyfHdk+/Py+Z7k9wjgig=
Date: Fri, 10 Sep 2010 10:15:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@i5.linux-foundation.org
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Christoph Lameter <cl@linux.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 3/4] hugetlb, rmap: fix confusing page locking in
 hugetlb_cow()
In-Reply-To: <1284092586-1179-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.LFD.2.00.1009101011140.9670@i5.linux-foundation.org>
References: <1284092586-1179-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1284092586-1179-4-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Sep 2010, Naoya Horiguchi wrote:
>  
> -	if (!pagecache_page) {
> -		page = pte_page(entry);
> +	/*
> +	 * hugetlb_cow() requires page locks of pte_page(entry) and
> +	 * pagecache_page, so here we need take the former one
> +	 * when page != pagecache_page or !pagecache_page.
> +	 */
> +	page = pte_page(entry);
> +	if (page != pagecache_page)
>  		lock_page(page);

Why isn't this a potential deadlock? You have two pages, and lock them 
both. Is there some ordering guarantee that says that 'pagecache_page' and 
'page' will always be in a certain relationship so that you cannot get 
A->B and B->A lock ordering?

Please document that ordering rule if so.

			Linus
