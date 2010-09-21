Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021Ab0IUQrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:47:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35212 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753736Ab0IUQrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:47:10 -0400
Date: Tue, 21 Sep 2010 09:46:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH] mm: do not print backtraces on GFP_ATOMIC failures
Message-Id: <20100921094638.9910add0.akpm@linux-foundation.org>
In-Reply-To: <20100921121818.4745f038@annuminas.surriel.com>
References: <20100921121818.4745f038@annuminas.surriel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Sep 2010 12:18:18 -0400 Rik van Riel <riel@redhat.com> wrote:

> Atomic allocations cannot fall back to the page eviction code
> and are expected to fail.  In fact, in some network intensive
> workloads, it is common to experience hundreds of GFP_ATOMIC
> allocation failures.
> 
> Printing out a backtrace for every one of those expected
> allocation failures accomplishes nothing good. At multi-gigabit
> network speeds with jumbo frames, a burst of allocation failure
> backtraces could even slow down the system.
> 
> We're better off not printing out backtraces on GFP_ATOMIC
> allocation failures.
> 
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 975609c..5a0bddb 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -72,7 +72,7 @@ struct vm_area_struct;
>  /* This equals 0, but use constants in case they ever change */
>  #define GFP_NOWAIT	(GFP_ATOMIC & ~__GFP_HIGH)
>  /* GFP_ATOMIC means both !wait (__GFP_WAIT not set) and use emergency pool */
> -#define GFP_ATOMIC	(__GFP_HIGH)
> +#define GFP_ATOMIC	(__GFP_HIGH | __GFP_NOWARN)
>  #define GFP_NOIO	(__GFP_WAIT)
>  #define GFP_NOFS	(__GFP_WAIT | __GFP_IO)
>  #define GFP_KERNEL	(__GFP_WAIT | __GFP_IO | __GFP_FS)

A much finer-tuned implementation would be to add __GFP_NOWARN just to
the networking call sites.  I asked about this in June and it got
nixed:

http://www.spinics.net/lists/netdev/msg131965.html
