Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934543Ab2JXKLs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:11:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55305 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab2JXKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:11:46 -0400
Date: Wed, 24 Oct 2012 03:10:32 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-876ee61aadf01aa0db981b5d249cbdd53dc28b5e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jbeulich@suse.com, hughd@google.com, JBeulich@suse.com,
        stable@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jbeulich@suse.com, hughd@google.com, JBeulich@suse.com,
        stable@kernel.org, tglx@linutronix.de
In-Reply-To: <506DAFBA020000780009FA8C@nat28.tlf.novell.com>
References: <506DAFBA020000780009FA8C@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Fix page table accounting
Git-Commit-ID: 876ee61aadf01aa0db981b5d249cbdd53dc28b5e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:10:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  876ee61aadf01aa0db981b5d249cbdd53dc28b5e
Gitweb:     http://git.kernel.org/tip/876ee61aadf01aa0db981b5d249cbdd53dc28b5e
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Thu, 4 Oct 2012 14:48:10 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:50:25 +0200

x86-64: Fix page table accounting

Commit 20167d3421a089a1bf1bd680b150dc69c9506810 ("x86-64: Fix
accounting in kernel_physical_mapping_init()") went a little too
far by entirely removing the counting of pre-populated page
tables: this should be done at boot time (to cover the page
tables set up in early boot code), but shouldn't be done during
memory hot add.

Hence, re-add the removed increments of "pages", but make them
and the one in phys_pte_init() conditional upon !after_bootmem.

Reported-Acked-and-Tested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/r/506DAFBA020000780009FA8C@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init_64.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2b6b4a3..3baff25 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -386,7 +386,8 @@ phys_pte_init(pte_t *pte_page, unsigned long addr, unsigned long end,
 		 * these mappings are more intelligent.
 		 */
 		if (pte_val(*pte)) {
-			pages++;
+			if (!after_bootmem)
+				pages++;
 			continue;
 		}
 
@@ -451,6 +452,8 @@ phys_pmd_init(pmd_t *pmd_page, unsigned long address, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_2M)) {
+				if (!after_bootmem)
+					pages++;
 				last_map_addr = next;
 				continue;
 			}
@@ -526,6 +529,8 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
 			 * attributes.
 			 */
 			if (page_size_mask & (1 << PG_LEVEL_1G)) {
+				if (!after_bootmem)
+					pages++;
 				last_map_addr = next;
 				continue;
 			}
