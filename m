Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab2FDO7j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:59:39 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab2FDO7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:59:37 -0400
Message-ID: <1338821964.28282.58.camel@twins>
Subject: Re: [PATCH 2/3] uprobes: change build_map_info() to try
 kmalloc(GFP_NOWAIT) first
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 16:59:24 +0200
In-Reply-To: <20120604145315.GB6416@redhat.com>
References: <20120604145238.GA6408@redhat.com>
	 <20120604145315.GB6416@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 16:53 +0200, Oleg Nesterov wrote:
> build_map_info() doesn't allocate the memory under i_mmap_mutex
> to avoid the deadlock with page reclaim. But it can try GFP_NOWAIT
> first, it should work in the likely case and thus we almost never
> need the pre-alloc-and-retry path.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index a1bbcab..c9836ae 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -772,8 +772,13 @@ build_map_info(struct address_space *mapping, loff_t offset, bool is_register)
>  			continue;
>  
>  		if (!prev) {
> -			more++;
> -			continue;


Should we add something like this:

			/*
			 * Needs GFP_NOWAIT to avoid i_mmap_mutex recursion through reclaim.
			 * This is optimistic, no harm done if it fails.
			 */


> +			prev = kmalloc(sizeof(struct map_info),
> +					GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +			if (!prev) {
> +				more++;
> +				continue;
> +			}
> +			prev->next = NULL;
>  		}
>  
>  		if (!atomic_inc_not_zero(&vma->vm_mm->mm_users))

