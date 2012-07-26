Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab2GZFMb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 01:12:31 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:48242 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab2GZFM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 01:12:29 -0400
Message-ID: <5010D1B6.6040401@linux.vnet.ibm.com>
Date: Thu, 26 Jul 2012 13:12:22 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: [PATCH v2] KVM: x86: simplify read_emulated
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12072605-1396-0000-0000-0000019EC06A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need split mmio read region into 8-bits pieces since we do it in
emulator_read_write_onepage

Changelog:
  Add a WARN_ON to check read-cache overflow

Acked-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/emulate.c |   31 ++++++++++++++-----------------
 1 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 97d9a99..e33eb02 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1166,24 +1166,21 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
 	int rc;
 	struct read_cache *mc = &ctxt->mem_read;

-	while (size) {
-		int n = min(size, 8u);
-		size -= n;
-		if (mc->pos < mc->end)
-			goto read_cached;
-
-		rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, n,
-					      &ctxt->exception);
-		if (rc != X86EMUL_CONTINUE)
-			return rc;
-		mc->end += n;
+	if (mc->pos < mc->end)
+		goto read_cached;

-	read_cached:
-		memcpy(dest, mc->data + mc->pos, n);
-		mc->pos += n;
-		dest += n;
-		addr += n;
-	}
+	WARN_ON((mc->end + size) >= sizeof(mc->data));
+
+	rc = ctxt->ops->read_emulated(ctxt, addr, mc->data + mc->end, size,
+				      &ctxt->exception);
+	if (rc != X86EMUL_CONTINUE)
+		return rc;
+
+	mc->end += size;
+
+read_cached:
+	memcpy(dest, mc->data + mc->pos, size);
+	mc->pos += size;
 	return X86EMUL_CONTINUE;
 }

-- 
1.7.7.6

