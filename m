Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148Ab2JDNsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:48:14 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:46822 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049Ab2JDNsN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Thu, 4 Oct 2012 09:48:13 -0400
Message-Id: <506DAFBA020000780009FA8C@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 04 Oct 2012 14:48:10 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: "Hugh Dickins" <hughd@google.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86-64: fix page table accounting
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 20167d3421a089a1bf1bd680b150dc69c9506810 ("x86-64: Fix
accounting in kernel_physical_mapping_init()") went a little too far
by entirely removing the counting of pre-populated page tables: This
should be done at boot time (to cover the page tables set up in early
boot code), but shouldn't be done during memory hot add.

Hence, re-add the removed increments of "pages", but make them and the
one in phys_pte_init() conditional upon !after_bootmem.

Reported-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
Not sure if this ought to be copied to stable@.

---
 arch/x86/mm/init_64.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- 3.6/arch/x86/mm/init_64.c
+++ 3.6-x86_64-page-table-count/arch/x86/mm/init_64.c
@@ -386,7 +386,8 @@ phys_pte_init(pte_t *pte_page, unsigned
 		 * these mappings are more intelligent.
 		 */
 		if (pte_val(*pte)) {
-			pages++;
+			if (!after_bootmem)
+				pages++;
 			continue;
 		}
 
@@ -451,6 +452,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_2M)) {
+				if (!after_bootmem)
+					pages++;
 				last_map_addr = next;
 				continue;
 			}
@@ -526,6 +529,8 @@ phys_pud_init(pud_t *pud_page, unsigned
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_1G)) {
+				if (!after_bootmem)
+					pages++;
 				last_map_addr = next;
 				continue;
 			}



