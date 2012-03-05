Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757748Ab2CEUx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 15:53:57 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:42922 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730Ab2CEUxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 15:53:55 -0500
Date: Mon, 5 Mar 2012 20:53:54 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] flush_tlb_range() needs ->page_table_lock when
 ->mmap_sem is not held
Message-ID: <20120305205354.GM23916@ZenIV.linux.org.uk>
References: <20120305063707.GH23916@ZenIV.linux.org.uk>
 <20120305064029.GK23916@ZenIV.linux.org.uk>
 <CA+55aFwQtEPGwK-W8H3Fa0EZUOV057kj_xhUXONZRcyeZtSt3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwQtEPGwK-W8H3Fa0EZUOV057kj_xhUXONZRcyeZtSt3Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 12:30:19PM -0800, Linus Torvalds wrote:
> Is this safe? And why does it need it? Please add more explanations.

a) safety - as the matter of fact, all other callers either hold either
->mmap_sem (exclusive) or ->page_table_lock.  flush_tlb_range() is
called under ->page_table_lock in a lot of places, e.g.
page_referenced_one() -> pmdp_clear_flush_young_notify() ->
-> pmdp_clear_flush_young() -> flush_tlb_range(), with
                /* go ahead even if the pmd is pmd_trans_splitting() */
                if (pmdp_clear_flush_young_notify(vma, address, pmd))
                        referenced++;
                spin_unlock(&mm->page_table_lock);
in page_referenced_one().

b) there are instances that work with page tables.  See e.g.
arch/powerpc/mm/tlb_hash32.c, flush_tlb_range() and flush_range() in there.
The same goes for uml, with a lot more extensive playing with page tables.

Almost all callers are actually fine - flush_tlb_range() may have no need
to bother playing with page tables, but it can do so safely; again, this
caller is the sole exception - everything else either has exclusive ->mmap_sem
on the mm in question, or mm->page_table_lock is held.
