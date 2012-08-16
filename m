Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab2HPNMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:12:53 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:12138 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932244Ab2HPNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:12:49 -0400
X-IronPort-AV: E=Sophos;i="4.77,778,1336348800"; 
   d="scan'208";a="14040421"
From: Attilio Rao <attilio.rao@citrix.com>
To: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v2 2/2] XEN: Document the semantic of the pagetable_reserve PVOPS
Date: Thu, 16 Aug 2012 13:59:36 +0100
Message-ID: <1345121976-11169-3-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <y>
References: <y>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The informations added on the hook are:
- Native behaviour
- Xen specific behaviour
- Logic behind the Xen specific behaviour
- PVOPS semantic

Even if in general it would be a good idea to separate PVOPS implementation
from semantic, in this case it is beneficial to give a little bit of context
on the implementation in order to favourably understand the semantic.

Signed-off-by: Attilio Rao <attilio.rao@citrix.com>
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/include/asm/x86_init.h |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
index 38155f6..b22093c 100644
--- a/arch/x86/include/asm/x86_init.h
+++ b/arch/x86/include/asm/x86_init.h
@@ -72,8 +72,23 @@ struct x86_init_oem {
  * struct x86_init_mapping - platform specific initial kernel pagetable setup
  * @pagetable_reserve:	reserve a range of addresses for kernel pagetable usage
  *
- * For more details on the purpose of this hook, look in
- * init_memory_mapping and the commit that added it.
+ * It does reserve a range of pages, to be used as pagetable pages.
+ * The start and end parameters are expected to be contained in the
+ * [pgt_buf_start, pgt_buf_top] range.
+ * The native implementation reserves the pages via the memblock_reserve()
+ * interface.
+ * The Xen implementation, besides reserving the range via memblock_reserve(),
+ * also sets RW the remaining pages contained in the ranges
+ * [pgt_buf_start, start) and [end, pgt_buf_top).
+ * This is needed because the range [pgt_buf_start, pgt_buf_top] was
+ * previously mapped read-only by xen_set_pte_init: when running
+ * on Xen all the pagetable pages need to be mapped read-only in order to
+ * avoid protection faults from the hypervisor. However, once the correct
+ * amount of pages is reserved for the pagetables, all the others contained
+ * in the range must be set to RW so that they can be correctly recycled by
+ * the VM subsystem.
+ * This operation is meant to be performed only during init_memory_mapping(),
+ * just after space for the kernel direct mapping tables is found.
  */
 struct x86_init_mapping {
 	void (*pagetable_reserve)(u64 start, u64 end);
-- 
1.7.2.5

