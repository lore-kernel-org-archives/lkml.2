Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761165Ab2J2Vgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 17:36:47 -0400
Received: from mail.kernel.org ([198.145.19.201]:47129 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761067Ab2J2Vgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:36:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@suse.com>, Ingo Molnar <mingo@kernel.org>
Subject: [ 011/101] x86-64: Fix page table accounting
Date: Mon, 29 Oct 2012 14:34:24 -0700
Message-Id: <20121029213241.415276140@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 876ee61aadf01aa0db981b5d249cbdd53dc28b5e upstream.

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
Link: http://lkml.kernel.org/r/506DAFBA020000780009FA8C@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/mm/init_64.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
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


