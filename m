Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2JBOTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:19:50 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59685 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2JBOTt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Tue, 2 Oct 2012 10:19:49 -0400
Message-Id: <506B141F020000780009F19A@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 02 Oct 2012 15:19:43 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Hugh Dickins" <hughd@google.com>
Cc: "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@kernel.org>,
        <x86@kernel.org>, "Yinghai Lu" <yinghai@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: x86_64: wrong DirectMap kB
References: <alpine.LSU.2.00.1210010116570.6566@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1210010116570.6566@eggly.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 01.10.12 at 10:37, Hugh Dickins <hughd@google.com> wrote:
> I noticed yesterday that the DirectMap counts at the bottom of x86_64's
> /proc/meminfo are wrong on v3.5 and v3.6.  For example, I happen to have
> booted this laptop with mem=700M to run a test, but /proc/meminfo shows
> 
> DirectMap4k:        4096 kB
> DirectMap2M:    18446744073709547520 kB

I cannot see such odd effect with "mem="; with I can (for any
value up to around 1G).

> Or if I boot with the full amount of physical memory, the DirectMap
> numbers do not add up to the full amount of physical memory, as they
> used to do on v3.4 and before.

That one I can see how could have happened, in that said patch
went a little too far: Dropping the "pages" increments from
phys_p[um]d_init() is necessary only for the hotplug case (as
otherwise duplicating accounting already done earlier), while
at boot time we would want to do the accounting.

> Whilst I've not yet tried reverting it, I strongly suspect your
> 20167d3421a0 "x86-64: Fix accounting in kernel_physical_mapping_init()".
> 
> Either it was a complete misunderstanding, totally bogus, and should
> simply be reverted; or perhaps you really noticed something wrong in
> your code inspection, but didn't get the fix quite right?

The latter, apparently. The patch below should fix both aspects.

Jan

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


