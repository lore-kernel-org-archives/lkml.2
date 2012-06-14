Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab2FNNwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:52:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36829 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194Ab2FNNwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:52:51 -0400
Date: Thu, 14 Jun 2012 16:53:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv7 4/8] x86/bitops: note on __test_and_clear_bit atomicity
Message-ID: <ea455fcb519d918cbda44926bca5c4d45cc04ffb.1339681762.git.mst@redhat.com>
References: <cover.1339681762.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1339681762.git.mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__test_and_clear_bit is actually atomic with respect
to the local CPU. Add a note saying that KVM on x86
relies on this behaviour so people don't accidentaly break it.
Also warn not to rely on this in portable code.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/include/asm/bitops.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index 47f9eff..75e3787 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -266,6 +266,13 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
  * This operation is non-atomic and can be reordered.
  * If two examples of this operation race, one can appear to succeed
  * but actually fail.  You must protect multiple accesses with a lock.
+ *
+ * Note: the operation is performed atomically with respect to
+ * the local CPU, but not other CPUs. Portable code should not
+ * rely on this behaviour.
+ * KVM relies on this behaviour on x86 for modifying memory that is also
+ * accessed from a hypervisor on the same CPU if running in a VM: don't change
+ * this without also updating arch/x86/kernel/kvm.c
  */
 static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 {
-- 
MST

