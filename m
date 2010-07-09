Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0GIRox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 13:44:53 -0400
Received: from claw.goop.org ([74.207.240.146]:58258 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab0GIRow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 13:44:52 -0400
Message-ID: <4C376013.7020208@goop.org>
Date: Fri, 09 Jul 2010 10:44:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrea Arcangeli <aarcange@redhat.com>,
       Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] remove mmu notifier calls in apply_to_page_range
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not appropriate for apply_to_page_range() to directly call any
mmu notifiers, because it is a general purpose function whose effect
depends on what context it is called in and what the callback function
does.

In particular, if it is being used as part of an mmu notifier
implementation, the recursive calls can be particularly problematic.

It is up to apply_to_page_range's caller to do any notifier calls
if necessary.  It does not affect any in-tree users because they
all operate on init_mm, and mmu notifiers only pertain to usermode
mappings.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>

diff --git a/mm/memory.c b/mm/memory.c
index 6ab19dd..d6b89eb 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1890,7 +1890,6 @@ int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 	int err;
 
 	BUG_ON(addr >= end);
-	mmu_notifier_invalidate_range_start(mm, start, end);
 	pgd = pgd_offset(mm, addr);
 	do {
 		next = pgd_addr_end(addr, end);
@@ -1898,7 +1897,7 @@ int apply_to_page_range(struct mm_struct *mm, unsigned long addr,
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	mmu_notifier_invalidate_range_end(mm, start, end);
+
 	return err;
 }
 EXPORT_SYMBOL_GPL(apply_to_page_range);


