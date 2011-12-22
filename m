Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1LVAcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:32:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33322 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab1LVAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:32:41 -0500
Date: Wed, 21 Dec 2011 16:32:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mempool: fix first round failure behavior
Message-Id: <20111221163240.ef73f77e.akpm@linux-foundation.org>
In-Reply-To: <20111222001939.GM9213@google.com>
References: <20111222001800.GL9213@google.com>
	<20111222001939.GM9213@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 16:19:39 -0800
Tejun Heo <tj@kernel.org> wrote:

> For the initial allocation, mempool passes modified gfp mask to the
> backing allocator so that it doesn't try too hard when there are
> reserved elements waiting in the pool; however, when that allocation
> fails and pool is empty too, it either waits for the pool to be
> replenished before retrying or fails if !__GFP_WAIT.
> 
> * If the caller was calling in with GFP_ATOMIC, it never gets to try
>   emergency reserve.  Allocations which would have succeeded without
>   mempool may fail, which is just wrong.
> 
> * Allocation which could have succeeded after a bit of reclaim now has
>   to wait on the reserved items and it's not like mempool doesn't
>   retry with the original gfp mask.  It just does that *after* someone
>   returns an element, pointlessly delaying things.

This is a significant change in behaviour.  Previously the mempool code
would preserve emergency pools while waiting for someone to return an
item.  Now, it will permit many more items to be allocated, chewing
into the emergency pools.

We *know* that items will soon become available, so why not wait for
that to happen rather than consuming memory which less robust callers
could have utilised?

IOW, this change appears to make the kernel more vulnerable to memory
exhaustion failures?
