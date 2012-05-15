Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964985Ab2EOOis (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:38:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31370 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932961Ab2EOOgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:36:08 -0400
Date: Tue, 15 May 2012 17:36:07 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: x86@kernel.org, kvm@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        gleb@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 6/8] x86/bitops: note on __test_and_clear_bit atomicity
Message-ID: <b82d1cb99227fa4393a8842e614b6014e4961e6a.1337091955.git.mst@redhat.com>
References: <cover.1337091955.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1337091955.git.mst@redhat.com>
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
index c9c70ea..86f3a1e 100644
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
MST

