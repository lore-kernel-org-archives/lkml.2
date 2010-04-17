Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab0DQJIR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 05:08:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65224 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755253Ab0DQJIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 05:08:15 -0400
Message-ID: <4BC97A7D.4070502@cn.fujitsu.com>
Date: Sat, 17 Apr 2010 17:08:13 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: [PATCH] kvm: reduce couple for ACC_EXEC_MASK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The statement "access &= ~(gpte >> PT64_NX_SHIFT);" tries
to clear bit ACC_EXEC_MASK actually. This statement
relies PT64_NX_SHIFT==63&&ACC_EXEC_MASK=1

This patch reduces this couple.


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/arch/x86/kvm/paging_tmpl.h b/arch/x86/kvm/paging_tmpl.h
index 81eab9a..34f4aa2 100644
--- a/arch/x86/kvm/paging_tmpl.h
+++ b/arch/x86/kvm/paging_tmpl.h
@@ -101,11 +101,9 @@ static unsigned FNAME(gpte_access)(struct kvm_vcpu *vcpu, pt_element_t gpte)
 {
 	unsigned access;
 
-	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK)) | ACC_EXEC_MASK;
-#if PTTYPE == 64
-	if (is_nx(vcpu))
-		access &= ~(gpte >> PT64_NX_SHIFT);
-#endif
+	access = (gpte & (PT_WRITABLE_MASK | PT_USER_MASK));
+	if (PTTYPE != 64 || !is_nx(vcpu) || (gpte & PT64_NX_MASK))
+		access |= ACC_EXEC_MASK;
 	return access;
 }
 
