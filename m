Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab2FXQZe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 12:25:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422Ab2FXQYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 12:24:48 -0400
Date: Sun, 24 Jun 2012 19:24:42 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCHv9 4/8] x86/bitops: note on __test_and_clear_bit atomicity
Message-ID: <539c51df757e80635ae735e9b7962a93216d10a1.1340554550.git.mst@robin.redhat.com>
References: <cover.1340554550.git.mst@robin.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1340554550.git.mst@robin.redhat.com>
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
 arch/x86/include/asm/bitops.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index a6983b2..72f5009 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -264,6 +264,13 @@ static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
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
1.6.3.2.307.gdf0b

