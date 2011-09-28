Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab1I1DCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:02:45 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:33884
	"EHLO DB3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362Ab1I1DCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:02:30 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E828E35.6070801@am.sony.com>
Date: Tue, 27 Sep 2011 20:02:13 -0700
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "tglx@linutronix.de" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <peterz@infradead.org>
Subject: [PATCH] PREEMPT_RT_FULL: arm coredump fails for cpu >= 4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


ARM can not use SPLIT_PTLOCK_CPUS if PREEMPT_RT_FULL because
vectors_user_mapping() creates a VM_ALWAYSDUMP mapping of the vector page,
but no ptl->lock has been allocated for the page.  An attempt to coredump
that page will result in a kernel NULL pointer dereference when
follow_page() attempts to lock the page.

The call tree to the NULL pointer dereference is:

   do_notify_resume()
      get_signal_to_deliver()
         do_coredump()
            elf_core_dump()
               get_dump_page()
                  __get_user_pages()
                     follow_page()
                        pte_offset_map_lock() <----- a #define
                           ...
                              rt_spin_lock()

This patch is needed only if mm-shrink-the-page-frame-to-rt-size.patch is
applied.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 mm/Kconfig |    9 	9 +	0 -	0 !
 1 file changed, 9 insertions(+)

Index: b/mm/Kconfig
===================================================================
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -172,13 +172,22 @@ config PAGEFLAGS_EXTENDED
 # page_table_lock, so that faults on different parts of the user address
 # space can be handled with less contention: split it at this NR_CPUS.
 # Default to 4 for wider testing, though 8 might be more appropriate.
+#
 # ARM's adjust_pte (unused if VIPT) depends on mm-wide page_table_lock.
+#
+# ARM can not use SPLIT_PTLOCK_CPUS if PREEMPT_RT_FULL because
+# vectors_user_mapping() creates a VM_ALWAYSDUMP mapping of the vector page,
+# but no ptl->lock has been allocated for the page.  An attempt to coredump
+# that page will result in a kernel NULL pointer dereference when
+# follow_page() attempts to lock the page.
+#
 # PA-RISC 7xxx's spinlock_t would enlarge struct page from 32 to 44 bytes.
 # DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC spinlock_t also enlarge struct page.
 #
 config SPLIT_PTLOCK_CPUS
 	int
 	default "999999" if ARM && !CPU_CACHE_VIPT
+	default "999999" if ARM && PREEMPT_RT_FULL
 	default "999999" if PARISC && !PA20
 	default "999999" if DEBUG_SPINLOCK || DEBUG_LOCK_ALLOC
 	default "4"

