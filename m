Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab1LTT3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 14:29:09 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:47254 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348Ab1LTT3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 14:29:03 -0500
Date: Tue, 20 Dec 2011 20:28:50 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: kosaki.motohiro@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Caspar Zhang <caspar@casparzhang.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Wilson <wilsons@start.ca>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] [v2] mempolicy: refix mbind_range() vma issue
Message-ID: <20111220192850.GB3870@cmpxchg.org>
References: <20111212112000.GB18789@cmpxchg.org>
 <1324405032-22281-1-git-send-email-kosaki.motohiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324405032-22281-1-git-send-email-kosaki.motohiro@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 01:17:10PM -0500, kosaki.motohiro@gmail.com wrote:
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> commit 8aacc9f550 (mm/mempolicy.c: fix pgoff in mbind vma merge) is
> slightly incorrect fix.
> 
> Why? Think following case.
> 
> 1. map 4 pages of a file at offset 0
> 
>    [0123]
> 
> 2. map 2 pages just after the first mapping of the same file but with
>    page offset 2
> 
>    [0123][23]
> 
> 3. mbind() 2 pages from the first mapping at offset 2.
>    mbind_range() should treat new vma is,
> 
>    [0123][23]
>      |23|
>      mbind vma
> 
>    but it does
> 
>    [0123][23]
>      |01|
>      mbind vma
> 
>    Oops. then, it makes wrong vma merge and splitting ([01][0123] or similar).
> 
> This patch fixes it.
> 
> [testcase]
>   test result - before the patch
> 
> 	case4: 126: test failed. expect '2,4', actual '2,2,2'
>        	case5: passed
> 	case6: passed
> 	case7: passed
> 	case8: passed
> 	case_n: 246: test failed. expect '4,2', actual '1,4'
> 
> 	------------[ cut here ]------------
> 	kernel BUG at mm/filemap.c:135!
> 	invalid opcode: 0000 [#4] SMP DEBUG_PAGEALLOC
> 
> 	(snip long bug on messages)
> 
>   test result - after the patch
> 
> 	case4: passed
>        	case5: passed
> 	case6: passed
> 	case7: passed
> 	case8: passed
> 	case_n: passed

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Minchan Kim <minchan.kim@gmail.com>
> CC: Caspar Zhang <caspar@casparzhang.com>

Looks good to me now, thanks.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Since this can corrupt virtual mappings and was released with 3.2, I
think we also want this:

Cc: stable@kernel.org [3.2.x]
