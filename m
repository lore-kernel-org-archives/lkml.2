Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2CEGhN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 01:37:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57906 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab2CEGhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 01:37:11 -0500
Date: Mon, 5 Mar 2012 06:37:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, arve@android.com, airlied@linux.ie,
        carsteno@de.ibm.com, steiner@sgi.com
Subject: [patches] VM-related fixes
Message-ID: <20120305063707.GH23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	I'd been crawling through VMA-related code for the last couple
of weeks; the obvious parts of fallout are in followups and IMO they
need to go into -stable as well; there's more, including some bugs I
don't know what to do about and patches that need more testing...

* aout handling needs to do setup_arg_pages() _before_ it does any mmap();
otherwise we might easily end up with bprm->vma freed by the time we
get to setup_arg_pages().  Sure, long-term we want setup_new_exec()
merged with setup_arg_pages(), but not this late in the cycle...

* anonymous shared mapping should *not* get VM_GROWS{UP,DOWN}, or we'll
end up with very unpleasant things happening.

* __unmap_hugepage_range() calls flush_tlb_range() without ->mmap_sem,
which means that we need ->page_table_lock.  Call it before dropping
->page_table_lock, not after that...

[unsolved] binder is insane, even more than usual for drivers/staging.
It stores a reference to mm at open() time, then it stores a reference to
vma at mmap() time, then it cheerfully works with that ->vma assuming that
->mmap_sem on stored reference to ->mm would suffice.  Guess what happens
if somebody opens it and then forks and does mmap in child?  Moreover, if
we fork() and have child exit(), we get ->close() called on each VMA we'd
copied into child.  Since they have stored reference to vma invalidated by
->close(), that has unpleasant side effects, to put it mildly.  And yes,
I realize that android userland probably doesn't do anything of that kind;
fat lot of good it does us...

[unsolved] a bunch of ->fault() instances are doing things that need
->mmap_sem exclusive; e.g. vm_insert_page() is called by xip_file_fault(),
drivers/misc/sgi-gru/grumain.c:gru_fault() does remap_pfn_range().
drivers/gpu/drm/gma500/framebuffer.c:psbfb_vm_fault() does
        vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
and drivers/gpu/drm/ttm/ttm_bo_vm.c:ttm_bo_vm_fault() does very similar
things, same for spufs ->fault() instances.
