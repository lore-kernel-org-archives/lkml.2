Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab0GGBdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 21:33:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40534 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751274Ab0GGBdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 21:33:08 -0400
Date: Tue, 6 Jul 2010 18:32:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andi Kleen <andi@firstfloor.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH]shmem: reduce one time of locking in pagefault
Message-Id: <20100706183254.cf67e29e.akpm@linux-foundation.org>
In-Reply-To: <1278465346.11107.8.camel@sli10-desk.sh.intel.com>
References: <1278465346.11107.8.camel@sli10-desk.sh.intel.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jul 2010 09:15:46 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> I'm running a shmem pagefault test case (see attached file) under a 64 CPU
> system. Profile shows shmem_inode_info->lock is heavily contented and 100%
> CPUs time are trying to get the lock.

I seem to remember complaining about that in 2002 ;) Faulting in a
mapping of /dev/zero is just awful on a 4-way(!).

> In the pagefault (no swap) case,
> shmem_getpage gets the lock twice, the last one is avoidable if we prealloc a
> page so we could reduce one time of locking. This is what below patch does.
> 
> The result of the test case:
> 2.6.35-rc3: ~20s
> 2.6.35-rc3 + patch: ~12s
> so this is 40% improvement.
> 
> One might argue if we could have better locking for shmem. But even shmem is lockless,
> the pagefault will soon have pagecache lock heavily contented because shmem must add
> new page to pagecache. So before we have better locking for pagecache, improving shmem
> locking doesn't have too much improvement. I did a similar pagefault test against
> a ramfs file, the test result is ~10.5s.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index f65f840..c5f2939 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c

The patch doesn't make shmem_getpage() any clearer :(

shmem_inode_info.lock appears to be held too much.  Surely
lookup_swap_cache() didn't need it (for example).

What data does shmem_inode_info.lock actually protect?


