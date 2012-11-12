Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab2KLNkj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 08:40:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab2KLNki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 08:40:38 -0500
Message-ID: <50A0FC50.4060203@redhat.com>
Date: Mon, 12 Nov 2012 08:40:32 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 3/3] mm: debug code to verify rb_subtree_gap updates are
 safe
References: <1352721091-27022-1-git-send-email-walken@google.com> <1352721091-27022-4-git-send-email-walken@google.com>
In-Reply-To: <1352721091-27022-4-git-send-email-walken@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2012 06:51 AM, Michel Lespinasse wrote:
> Using the trinity fuzzer, Sasha Levin uncovered a case where
> rb_subtree_gap wasn't correctly updated.
>
> Digging into this, the root cause was that vma insertions and removals
> require both an rbtree insert or erase operation (which may trigger
> tree rotations), and an update of the next vma's gap (which does not
> change the tree topology, but may require iterating on the node's
> ancestors to propagate the update). The rbtree rotations caused the
> rb_subtree_gap values to be updated in some of the internal nodes, but
> without upstream propagation. Then the subsequent update on the next
> vma didn't iterate as high up the tree as it should have, as it
> stopped as soon as it hit one of the internal nodes that had been
> updated as part of a tree rotation.
>
> The fix is to impose that all rb_subtree_gap values must be up to date
> before any rbtree insertion or erase, with the possible exception that
> the node being erased doesn't need to have an up to date rb_subtree_gap.
>
> This change: introduce validate_mm_rb() to verify that the rbtree does
> not include any stale rb_subtree_gap values before node insertion or
> erase, so as to avoid the issue where a subsequent vma_gap_update() would
> fail to propagate the rb_subtree_gap updates as high up as necessary.
>
> Signed-off-by: Michel Lespinasse <walken@google.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed
