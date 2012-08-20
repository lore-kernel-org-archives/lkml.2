Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2HTTqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:46:12 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:20283 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752416Ab2HTTqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:46:10 -0400
Date: Mon, 20 Aug 2012 19:46:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 4/5] mempolicy: fix refcount leak in
 mpol_set_shared_policy()
In-Reply-To: <1345480594-27032-5-git-send-email-mgorman@suse.de>
Message-ID: <00000139459223d7-93a9c53f-6724-4a4b-b675-cd25d8d53c71-000000@email.amazonses.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-5-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Mel Gorman wrote:

> @@ -2318,9 +2323,7 @@ void mpol_free_shared_policy(struct shared_policy *p)
>  	while (next) {
>  		n = rb_entry(next, struct sp_node, nd);
>  		next = rb_next(&n->nd);
> -		rb_erase(&n->nd, &p->root);

Looks like we need to keep the above line? sp_delete does not remove the
tree entry.

> -		mpol_put(n->policy);
> -		kmem_cache_free(sn_cache, n);
> +		sp_delete(p, n);
>  	}
>  	mutex_unlock(&p->mutex);
>  }
>
