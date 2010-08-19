Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab0HSTa2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 15:30:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:50840 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab0HSTaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 15:30:25 -0400
From: Mark Asselstine <mark.asselstine@windriver.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org,
        mathieu.desnoyers@efficios.com
Subject: [PATCH] x86: avoid using vmalloc_to_page on non-vmalloc'ed addresses
Date: Thu, 19 Aug 2010 15:29:16 -0400
Message-Id: <1282246156-7830-1-git-send-email-mark.asselstine@windriver.com>
X-Mailer: git-send-email 1.7.1
X-OriginalArrivalTime: 19 Aug 2010 19:29:17.0596 (UTC) FILETIME=[D0A015C0:01CB3FD4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible that addresses passed to text_poke() fall beyond _etext
but are also not vmalloc'ed and thus should be using virt_to_page() and
not vmalloc_to_page(). Using is_vmalloc_addr() ensures the proper logic
is used to retrieve the page.

Signed-off-by: Mark Asselstine <mark.asselstine@windriver.com>
---
At the moment I don't believe there are any situations where this is a
problem in Linus' tree but I know that mixing LTTng and RT with things
can cause this to be troublesome. LTTng introduces an immediate value
optimization which makes use of text_poke and this can happen beyond
_etext. The example I was looking at is in rd_load_image which results
in

rd_load_image --> kmalloc  --> trace_kmalloc --> imv_read

The imv_read will insert a 'mov $0x0,%al' in rd_load_image which will
later be the site of the text_poke when arch_imv_update is called.
Looking at the addresses of my build _etext = c1490b2c,
rd_load_image = c1671034 and VMALLOC_START = d87fd000. So in this case
I believe, and this is where I suspect I will get some feedback, it
is *not* acceptable to be doing a vmalloc_to_page() operation on the
address which was not vmalloc'ed.

 arch/x86/kernel/alternative.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index f65ab8b..0c8c26c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -555,7 +555,7 @@ void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
 	struct page *pages[2];
 	int i;
 
-	if (!core_kernel_text((unsigned long)addr)) {
+	if (is_vmalloc_addr(addr)) {
 		pages[0] = vmalloc_to_page(addr);
 		pages[1] = vmalloc_to_page(addr + PAGE_SIZE);
 	} else {
-- 
1.7.1

