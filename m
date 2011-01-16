Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1APWG0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 17:06:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab1APWGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 17:06:25 -0500
Date: Sun, 16 Jan 2011 23:06:14 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: ia64 broken by transparent huge pages - other arches too?
Message-ID: <20110116220614.GH9506@random.random>
References: <4d308cf5394566ccc@agluck-desktop.sc.intel.com>
 <1295076096.4875.60.camel@pasglop>
 <AANLkTikZ+MmM9f0tidpccDAimtUkDvJ3N=3KE+xFxc63@mail.gmail.com>
 <20110116131039.0f0a9359.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110116131039.0f0a9359.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 01:10:39PM -0800, Andrew Morton wrote:
> I believe it's the below.  I haven't tested it yet and nor has anyone
> else apart from Andrea, afaik.

Correct. I tested it with sparc64 cross compiler using ARCH=sparc32 in
addition to x86_32/64 with THP on and off. It should solve the
problem.

James' fix for arm still needed in addition to it, I'm appending it.

Thanks and sorry again for the arch build trouble.
Andrea

===
Subject: [PATCH] parisc: fix compile breakage caused by inlining maybe_mkwrite

From: James Bottomley <James.Bottomley@HansenPartnership.com>

on Parisc, we have an include of linux/mm.h inside our asm/pgtable.h, so
this patch 

commit 14fd403f2146f740942d78af4e0ee59396ad8eab
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Thu Jan 13 15:46:37 2011 -0800

    thp: export maybe_mkwrite

Causes us an unsatisfiable use of pte_mkwrite in linux/mm.h

The fix is obviously not to include linux/mm.h in our pgtable.h, which
unbreaks the build.

James

---

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index f3c0973..5d7b8ce 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -10,11 +10,13 @@
  * we simulate an x86-style page table for the linux mm code
  */
 
-#include <linux/mm.h>		/* for vm_area_struct */
 #include <linux/bitops.h>
+#include <linux/spinlock.h>
 #include <asm/processor.h>
 #include <asm/cache.h>
 
+struct vm_area_struct;
+
 /*
  * kern_addr_valid(ADDR) tests if ADDR is pointing to valid kernel
  * memory.  For the return value to be meaningful, ADDR must be >=


