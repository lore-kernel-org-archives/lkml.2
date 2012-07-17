Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab2GQNwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 09:52:18 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:55096 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2GQNwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 09:52:17 -0400
Message-ID: <50056DE6.6020801@linux.vnet.ibm.com>
Date: Tue, 17 Jul 2012 21:51:34 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: [PATCH 2/9] KVM: x86: simplify read_emulated
References: <50056DB8.7080702@linux.vnet.ibm.com>
In-Reply-To: <50056DB8.7080702@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12071703-5490-0000-0000-000001CB1CDA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need split mmio read region into 8-bits pieces since we do it in
emulator_read_write_onepage

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/emulate.c |   29 ++++++++++++-----------------
 1 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 97d9a99..2d1916b 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1166,24 +1166,19 @@ static int read_emulated(struct x86_emulate_ctxt *ctxt,
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

