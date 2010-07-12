Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab0GLWQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:16:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753043Ab0GLWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:16:21 -0400
Date: Mon, 12 Jul 2010 15:15:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Martin Bligh <mbligh@google.com>, Michael Rubin <mrubin@google.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: fix queue_io() ordering
Message-Id: <20100712151518.d4cdfebc.akpm@linux-foundation.org>
In-Reply-To: <20100711021749.163345723@intel.com>
References: <20100711020656.340075560@intel.com>
	<20100711021749.163345723@intel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Jul 2010 10:07:01 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> This was not a bug, since b_io is empty for kupdate writeback.
> The next patch will do requeue_io() for non-kupdate writeback,
> so let's fix it.
> 
> CC: Dave Chinner <david@fromorbit.com>
> Cc: Martin Bligh <mbligh@google.com>
> Cc: Michael Rubin <mrubin@google.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Fengguang Wu <wfg@mail.ustc.edu.cn>

I assumed you didn't mean to sign this twice so I removed this signoff.

> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  fs/fs-writeback.c |    7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2010-07-11 09:13:31.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2010-07-11 09:13:32.000000000 +0800
> @@ -252,11 +252,14 @@ static void move_expired_inodes(struct l
>  }
>  
>  /*
> - * Queue all expired dirty inodes for io, eldest first.
> + * Queue all expired dirty inodes for io, eldest first:
> + * (newly dirtied) => b_dirty inodes
> + *                 => b_more_io inodes
> + *                 => remaining inodes in b_io => (dequeue for sync)
>   */
>  static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
>  {
> -	list_splice_init(&wb->b_more_io, wb->b_io.prev);
> +	list_splice_init(&wb->b_more_io, &wb->b_io);
>  	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
>  }

