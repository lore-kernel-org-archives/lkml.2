Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab2LRCht (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:37:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54552 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab2LRChs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:37:48 -0500
Date: Mon, 17 Dec 2012 18:37:46 -0800 (PST)
Message-Id: <20121217.183746.284542903305308509.davem@davemloft.net>
To: riel@redhat.com
CC: mgorman@suse.de, linux-kernel@vger.kernel.org
Subject: flush_tlb_page() avoidance in balancenuma pull
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think we need to be careful, going forward, with these
flush_tlb_page() removals in the initial commits.

On those cpus, each set_pte_at() call (and therefore indirectly
via pte_clear()) queue up a per-cpu flush entry.

Then, the various flush_tlb_*() calls don't flush a single entry
but rather run the queue of pending TLB flushes.

Therefore every single set_pte_at() call must have a subsequent
flush_tlb_*() otherwise we'll return to userspace with stale
entries in the per-cpu TLB flush queues.

It seems to be the case that we turn out to be OK here, because
__set_pte_at() on sparc64 as currently implemented does not queue up a
TLB flush in the per-cpu queue if the PTE did not have the valid bit.

And the default pte_accessible() returns true unconditionally.

In fact is shows that we can probably can implement pte_accessible()
to mirror the test done in __set_pte_at() and thus we'd get the
optimization too on sparc64.

But we really need to be careful about this, these kinds of bugs are
hard to track down.

Thanks.
