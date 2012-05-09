Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754520Ab2EINqD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:46:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab2EINp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:45:59 -0400
Date: Wed, 9 May 2012 16:45:29 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] bitops: add _local bitops
Message-ID: <20120509134528.GA18044@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm needs to update some hypervisor variables atomically
in a sense that the operation can't be interrupted
in the middle. However the hypervisor always runs
on the same CPU so it does not need any memory
barrier or lock prefix.

At Peter Anvin's suggestion, add _local bitops for this purpose:
define them as non-atomics for x86 and (for now) atomics
for everyone else.

Uses are not restricted to virtualization: they
might be useful to communicate with an interrupt
handler if we know that it's running on the same CPU.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Link to previous discussion:
http://www.spinics.net/lists/kvm/msg72241.html


 Documentation/atomic_ops.txt              |   19 ++++++
 arch/x86/include/asm/bitops.h             |    1 +
 include/asm-generic/bitops.h              |    1 +
 include/asm-generic/bitops/local-atomic.h |   92 +++++++++++++++++++++++++++++
 include/asm-generic/bitops/local.h        |   85 ++++++++++++++++++++++++++
 include/linux/bitops.h                    |    8 +++
 6 files changed, 206 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/bitops/local-atomic.h
 create mode 100644 include/asm-generic/bitops/local.h

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 27f2b21..b7e3b67 100644
--- a/Documentation/atomic_ops.txt
+++ b/Documentation/atomic_ops.txt
@@ -520,6 +520,25 @@ The __clear_bit_unlock version is non-atomic, however it still implements
 unlock barrier semantics. This can be useful if the lock itself is protecting
 the other bits in the word.
 
+Local versions of the bitmask operations are also provided.  They are used in
+contexts where the operations need to be performed atomically with respect to
+the local CPU, but no other CPU accesses the bitmask.  This assumption makes it
+possible to avoid the need for SMP protection and use less expensive atomic
+operations in the implementation.
+They have names similar to the above bitmask operation interfaces,
+except that _local is sufficed to the interface name.
+
+	void set_bit_local(unsigned long nr, volatile unsigned long *addr);
+	void clear_bit_local(unsigned long nr, volatile unsigned long *addr);
+	void change_bit_local(unsigned long nr, volatile unsigned long *addr);
+	int test_and_set_bit_local(unsigned long nr, volatile unsigned long *addr);
+	int test_and_clear_bit_local(unsigned long nr, volatile unsigned long *addr);
+	int test_and_change_bit_local(unsigned long nr, volatile unsigned long *addr);
+
+These local variants are useful for example if the bitmask may be accessed from
+a local intrerrupt, or from a hypervisor on the same CPU if running in a VM.
+These local variants also do not have any special memory barrier semantics.
+
 Finally, there are non-atomic versions of the bitmask operations
 provided.  They are used in contexts where some other higher-level SMP
 locking scheme is being used to protect the bitmask, and thus less
diff --git a/arch/x86/include/asm/bitops.h b/arch/x86/include/asm/bitops.h
index b97596e..8784cd7 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -509,6 +509,7 @@ static __always_inline int fls64(__u64 x)
 #include <asm-generic/bitops/le.h>
 
 #include <asm-generic/bitops/ext2-atomic-setbit.h>
+#include <asm-generic/bitops/local.h>
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_BITOPS_H */
diff --git a/include/asm-generic/bitops.h b/include/asm-generic/bitops.h
index 280ca7a..d720c9e 100644
--- a/include/asm-generic/bitops.h
+++ b/include/asm-generic/bitops.h
@@ -40,5 +40,6 @@
 #include <asm-generic/bitops/non-atomic.h>
 #include <asm-generic/bitops/le.h>
 #include <asm-generic/bitops/ext2-atomic.h>
+#include <asm-generic/bitops/local-atomic.h>
 
 #endif /* __ASM_GENERIC_BITOPS_H */
diff --git a/include/asm-generic/bitops/local-atomic.h b/include/asm-generic/bitops/local-atomic.h
new file mode 100644
index 0000000..94ad261
--- /dev/null
+++ b/include/asm-generic/bitops/local-atomic.h
@@ -0,0 +1,92 @@
+#ifndef ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H
+#define ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H
+/**
+ * Local atomic operations
+ *
+ * These operations give no atomicity or ordering guarantees if result
+ * observed from another CPU.  Atomicity is guaranteed if result is observed
+ * from the same CPU, e.g. from a local interrupt, or a hypervisor if running
+ * in a VM.
+ * Atomicity is not guaranteed across CPUs: if two examples of these operations
+ * race on different CPUs, one can appear to succeed but actually fail.  Use
+ * non-local atomics instead or protect such SMP accesses with a lock.
+ * These operations can be reordered. No memory barrier is implied.
+ */
+
+/**
+ * Implement local operations in terms of atomics.
+ * For use from a local interrupt, this is always safe but suboptimal: many
+ * architectures can use bitops/local.h instead.
+ * For use from a hypervisor, make sure your architecture doesn't
+ * rely on locks for atomics: if it does - override these operations.
+ */
+
+#define HAVE_ASM_BITOPS_LOCAL
+
+/**
+ * set_bit_local - Sets a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+#define set_bit_local(nr, addr) set_bit(nr, addr)
+
+/**
+ * clear_bit_local - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+#define clear_bit_local(nr, addr) clear_bit(nr, addr)
+
+/**
+ * test_and_set_bit_local - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define test_and_set_bit_local(nr, addr) test_and_set_bit(nr, addr)
+
+/**
+ * test_and_clear_bit_local - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ * Note that @nr may be almost arbitrarily large; this function is not
+ * restricted to acting on a single-word quantity.
+ */
+#define test_and_clear_bit_local(nr, addr) test_and_clear_bit(nr, addr)
+
+/**
+ * change_bit_local - Toggle a bit in memory
+ * @nr: Bit to change
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define change_bit_local(nr, addr) change_bit(nr, addr)
+
+/**
+ * test_and_change_bit_local - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define test_and_change_bit_local(nr, addr) test_and_change_bit(nr, addr)
+
+#endif /* ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H */
diff --git a/include/asm-generic/bitops/local.h b/include/asm-generic/bitops/local.h
new file mode 100644
index 0000000..64ab358
--- /dev/null
+++ b/include/asm-generic/bitops/local.h
@@ -0,0 +1,85 @@
+#ifndef ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H
+#define ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H
+/**
+ * Local atomic operations
+ *
+ * These operations give no atomicity or ordering guarantees if result
+ * observed from another CPU.  Atomicity is guaranteed if result is observed
+ * from the same CPU, e.g. from a local interrupt, or a hypervisor if running
+ * in a VM.
+ * Atomicity is not guaranteed across CPUs: if two examples of these operations
+ * race on different CPUs, one can appear to succeed but actually fail.  Use
+ * non-local atomics instead or protect such SMP accesses with a lock.
+ * These operations can be reordered. No memory barrier is implied.
+ */
+
+
+/**
+ * Implement local operations in terms of non-atomics.
+ * Only safe on architectures, such as x86, that implement
+ * non-atomics in terms of a single instruction.
+ */
+
+#define HAVE_ASM_BITOPS_LOCAL
+
+/**
+ * set_bit - Atomically set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define set_bit_local(nr, addr) set_bit(nr, addr)
+
+/**
+ * clear_bit - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define clear_bit_local(nr, addr) clear_bit(nr, addr)
+
+/**
+ * test_and_set_bit_local - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define test_and_set_bit_local(nr, addr) test_and_set_bit(nr, addr)
+
+/**
+ * test_and_clear_bit - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define test_and_clear_bit_local(nr, addr) test_and_clear_bit(nr, addr)
+
+/**
+ * change_bit - Toggle a bit in memory
+ * @nr: Bit to change
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define change_bit_local(nr, addr) change_bit(nr, addr)
+
+/**
+ * test_and_change_bit - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+#define test_and_change_bit_local(nr, addr) test_and_change_bit(nr, addr)
+
+#endif /* ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..ba86418 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -197,5 +197,13 @@ extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
 #endif
 
+/**
+ * Include the generic version for local atomics unless
+ * an architecture overrides it.
+ * */
+#ifndef HAVE_ASM_BITOPS_LOCAL
+#include "include/asm-generic/bitops/local-atomic.h"
+#endif
+
 #endif /* __KERNEL__ */
 #endif
-- 
MST
