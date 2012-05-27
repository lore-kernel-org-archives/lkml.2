Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965477Ab2E0BN3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:13:29 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36607 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab2E0BNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:13:19 -0400
Message-Id: <20120527010436.589304776@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 10:05:54 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Catalin Marinas <catalin.marinas@arm.com>,
        Dima Zavin <dima@android.com>, John Stultz <john.stultz@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 91/94] ARM: 7409/1: Do not call flush_cache_user_range with mmap_sem held
In-Reply-To: <20120527010332.GA11170@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dima Zavin <dima@android.com>

commit 435a7ef52db7d86e67a009b36cac1457f8972391 upstream.

We can't be holding the mmap_sem while calling flush_cache_user_range
because the flush can fault. If we fault on a user address, the
page fault handler will try to take mmap_sem again. Since both places
acquire the read lock, most of the time it succeeds. However, if another
thread tries to acquire the write lock on the mmap_sem (e.g. mmap) in
between the call to flush_cache_user_range and the fault, the down_read
in do_page_fault will deadlock.

[will: removed drop of vma parameter as already queued by rmk (7365/1)]

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Dima Zavin <dima@android.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/traps.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -491,7 +491,9 @@ do_cache_op(unsigned long start, unsigne
 		if (end > vma->vm_end)
 			end = vma->vm_end;
 
+		up_read(&mm->mmap_sem);
 		flush_cache_user_range(start, end);
+		return;
 	}
 	up_read(&mm->mmap_sem);
 }


