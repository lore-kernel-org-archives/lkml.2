Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510Ab2KLUzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:55:06 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:53393 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392Ab2KLUzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:55:04 -0500
Message-ID: <50A16212.8090507@gmail.com>
Date: Mon, 12 Nov 2012 15:54:42 -0500
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/3] fix missing rb_subtree_gap updates on vma insert/erase
References: <1352721091-27022-1-git-send-email-walken@google.com>
In-Reply-To: <1352721091-27022-1-git-send-email-walken@google.com>
Content-Type: text/plain; charset=ISO-8859-1
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
> These 3 patches apply on top of the stack I previously sent (or equally,
> on top of the last published mmotm).
> 
> Michel Lespinasse (3):
>   mm: ensure safe rb_subtree_gap update when inserting new VMA
>   mm: ensure safe rb_subtree_gap update when removing VMA
>   mm: debug code to verify rb_subtree_gap updates are safe
> 
>  mm/mmap.c |  121 +++++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 73 insertions(+), 48 deletions(-)
> 

Looking good: old warnings gone, no new warnings.


Thanks,
Sasha
