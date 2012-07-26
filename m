Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2GZUbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 16:31:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:38811 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab2GZUbq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 16:31:46 -0400
Message-ID: <1343334698.32120.11.camel@twins>
Subject: thp and memory barrier assumptions
From: Peter Zijlstra <peterz@infradead.org>
To: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        paulmck <paulmck@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>
Date: Thu, 26 Jul 2012 22:31:38 +0200
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


__do_huge_pmd_anonymous_page() contains:

                /*
                 * The spinlocking to take the lru_lock inside
                 * page_add_new_anon_rmap() acts as a full memory
                 * barrier to be sure clear_huge_page writes become
                 * visible after the set_pmd_at() write.
                 */
                page_add_new_anon_rmap(page, vma, haddr);


page_add_new_anon_rmap() doesn't look to actually do a LOCK+UNLOCK
except for unevictable pages.

But even if it did do an unconditional LOCK+UNLOCK that doesn't make a
full memory barrier, see Documentation/memory-barriers.txt.

In particular:

        *A = a;
        LOCK
        UNLOCK
        *B = b;

may occur as:

        LOCK, STORE *B, STORE *A, UNLOCK

