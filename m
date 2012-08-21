Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab2HUPQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:16:40 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:10785 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928Ab2HUPPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:15:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,802,1336348800"; 
   d="scan'208";a="14109703"
From: Attilio Rao <attilio.rao@citrix.com>
To: <linux-kernel@vger.kernel.org>, <mingo@redhat.com>, <hpa@zytor.com>,
        <tglx@linutronix.de>, <x86@kernel.org>,
        <Stefano.Stabellini@eu.citrix.com>
CC: <konrad.wilk@oracle.com>, Attilio Rao <attilio.rao@citrix.com>
Subject: [PATCH v3 2/2] XEN: Document the semantic of the pagetable_reserve PVOPS
Date: Tue, 21 Aug 2012 16:02:26 +0100
Message-ID: <1345561346-6781-3-git-send-email-attilio.rao@citrix.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1345561346-6781-1-git-send-email-attilio.rao@citrix.com>
References: <1345561346-6781-1-git-send-email-attilio.rao@citrix.com>
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

