Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1DZQpw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:45:52 -0400
Received: from mout.perfora.net ([74.208.4.195]:60914 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578Ab1DZQpv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:45:51 -0400
Date: Tue, 26 Apr 2011 12:44:58 -0400
From: Stephen Wilson <wilsons@start.ca>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hughd@google.com>, bookjovi@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        David Rientjes <rientjes@google.com>,
        Stephen Wilson <wilsons@start.ca>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] proc: fix pagemap_read() error case (was Re: [PATCH]
	proc: put check_mem_permission before __get_free_page in mem_read)
Message-ID: <20110426164458.GB14478@fibrous.localdomain>
References: <alpine.LSU.2.00.1104252048190.6978@sister.anvils> <20110426141449.F37C.A69D9226@jp.fujitsu.com> <20110426145226.F383.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426145226.F383.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:2uIFqCDzrI6WDvzlmmyDMNWzopQo8V5aq5U4YQPK0e9
 2uA0O4hvE+mflijCjGje9ZIbhsQsKL5dokCCz3QtpjhvX4+gRu
 JxAmhdtZhzImZ42t2tqDvB6Db1xGDRSHDqfZl5UGjgbtPHMbY9
 Szrqw8RlT+PC5xARCNxkTsQh1WwWx292eefTUGqyNNdeyf4K+1
 S0Xr3w3GHa5W+z41HtG+PIG/fgUn1bs5car+ho2Y50=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 02:50:16PM +0900, KOSAKI Motohiro wrote:
> I've finished audit other /proc allocation callsite. If my understand
> is correct, only pagemap_read() has the same issue.

I think there is one additional location that might be worth looking at.
We have a kmalloc(struct numa_maps) happening in show_numa_map() (see
mempolicy.c).  In this case there is an allocation/free cycle happening
for each vma as we generate the seq_file.

Unfortunately a fix might require a little work.  Initial thinking
suggests that we perform a single allocation at numa_maps_open() time.
However, there is an odd layering/dependency issue between mempolicy.c
and task_mmu.c.  A "simple clean fix" does not seem obvious to me.

I am very tempted to suggest we move the proc related stuff out of
mempolicy.c.  However, see 1a75a6c8.

Thoughts?  I can certainly look into this some more if needed.

-- 
steve

