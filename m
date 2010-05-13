Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab0EMUTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:19:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60520 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932851Ab0EMUTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:19:37 -0400
Date: Thu, 13 May 2010 13:19:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kirjanov@gmail.com
Cc: joern@logfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] lib/btree: Fix possible NULL pointer dereference
Message-Id: <20100513131907.a3373db2.akpm@linux-foundation.org>
In-Reply-To: <20100512212026.GA5513@coldcone>
References: <20100512212026.GA5513@coldcone>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 01:20:27 +0400
"Denis Kirjanov <kirjanov@gmail.com" <kirjanov@gmail.com> wrote:

> mempool_alloc can return null in atomic case.
> 
> Signed-off-by: Denis Kirjanov <kirjanov@gmail.com>
> ---
> diff --git a/lib/btree.c b/lib/btree.c
> index 41859a8..542c904 100644
> --- a/lib/btree.c
> +++ b/lib/btree.c
> @@ -95,7 +94,8 @@ static unsigned long *btree_node_alloc(struct btree_head *head, gfp_t gfp)
>  	unsigned long *node;
>  
>  	node = mempool_alloc(head->mempool, gfp);
> -	memset(node, 0, NODESIZE);
> +	if (likely(node))
> +		memset(node, 0, NODESIZE);
>  	return node;
>  }

hm, why is btree.c using mempools?  mempools are only appropriate when
it is known that objects will become available if the allocating task
simply waits for a while.  Typically, things like BIOs and
request-structs.  Simply waiting for the disk to complete some IO will
cause some objects to be returned to the mempool.

If waiting-and-doing-nothing fails to cause objects to be returned to
the pool then the mempool code can lock up.



