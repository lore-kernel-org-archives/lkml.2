Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207Ab2EIQ2p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:28:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557Ab2EIQ2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:28:43 -0400
Date: Wed, 9 May 2012 19:28:19 +0300
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
Subject: [PATCHv2] bitops: add _local bitops
Message-ID: <20120509162819.GA21328@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm needs to update some hypervisor variables atomically
in a sense that the operation can't be interrupted
in the middle. However the hypervisor always runs
on the same CPU so it does not need any memory
barrier or lock prefix.

Add _local bitops for this purpose: define them
as non-atomics for x86 and (for now) atomics for
everyone else.

Uses are not restricted to virtualization: they
might be useful to communicate with an interrupt
handler if we know that it's running on the same CPU.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
---

Changes from v1:
- Fix x86 version so it includes optimization barriers
  as suggested by Peter Anvin
- Fix documentation as suggested by Avi Kivity
- Remove duplicate files as suggested by Arnd Bergmann

Link to discussion preceding v1:
http://www.spinics.net/lists/kvm/msg72241.html



 Documentation/atomic_ops.txt              |   19 ++++
 arch/x86/include/asm/bitops.h             |  132 +++++++++++++++++++++++++++++
 include/asm-generic/bitops.h              |    1 +
 include/asm-generic/bitops/local-atomic.h |  114 +++++++++++++++++++++++++
 include/linux/bitops.h                    |    8 ++
 5 files changed, 274 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-generic/bitops/local-atomic.h

diff --git a/Documentation/atomic_ops.txt b/Documentation/atomic_ops.txt
index 27f2b21..b45eb12 100644
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
+except that _local is appended to the interface name.
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
index b97596e..4e6d900 100644
--- a/arch/x86/include/asm/bitops.h
+++ b/arch/x86/include/asm/bitops.h
@@ -41,6 +41,20 @@
 #define CONST_MASK_ADDR(nr, addr)	BITOP_ADDR((void *)(addr) + ((nr)>>3))
 #define CONST_MASK(nr)			(1 << ((nr) & 7))
 
+/*
+ * x86 has its own version of local atomic operations.  These operations
+ * change memory using a single instruction, but give no atomicity or ordering
+ * guarantees if result observed from another CPU.  Atomicity is guaranteed if
+ * result is observed from the same CPU, e.g. from a local interrupt, or a
+ * hypervisor if running in a VM.
+ * Atomicity is not guaranteed across CPUs: if two examples of these operations
+ * race on different CPUs, one can appear to succeed but actually fail.
+ * To get atomicity guarantees across CPUs use non-local atomics instead.
+ * These operations can be reordered. No memory barrier is implied.
+ */
+
+#define ARCH_HAS_BITOPS_LOCAL_ATOMIC 1
+
 /**
  * set_bit - Atomically set a bit in memory
  * @nr: the bit to set
@@ -85,6 +99,19 @@ static inline void __set_bit(int nr, volatile unsigned long *addr)
 }
 
 /**
+ * set_bit_local - Atomically set a bit in memory
+ * @nr: the bit to set
+ * @addr: the address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static inline void set_bit_local(int nr, volatile unsigned long *addr)
+{
+	asm volatile("bts %1,%0" : ADDR : "Ir" (nr) : "memory");
+}
+
+/**
  * clear_bit - Clears a bit in memory
  * @nr: Bit to clear
  * @addr: Address to start counting from
@@ -149,6 +176,30 @@ static inline void __clear_bit_unlock(unsigned nr, volatile unsigned long *addr)
 #define smp_mb__after_clear_bit()	barrier()
 
 /**
+ * clear_bit - Clears a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static __always_inline void
+clear_bit_local(int nr, volatile unsigned long *addr)
+{
+	if (IS_IMMEDIATE(nr)) {
+		asm volatile("andb %1,%0"
+			: CONST_MASK_ADDR(nr, addr)
+			: "iq" ((u8)~CONST_MASK(nr))
+			: "memory");
+	} else {
+		asm volatile("btr %1,%0"
+			: BITOP_ADDR(addr)
+			: "Ir" (nr)
+			: "memory");
+	}
+}
+
+/**
  * __change_bit - Toggle a bit in memory
  * @nr: the bit to change
  * @addr: the address to start counting from
@@ -185,6 +236,29 @@ static inline void change_bit(int nr, volatile unsigned long *addr)
 }
 
 /**
+ * change_bit_local - Toggle a bit in memory
+ * @nr: Bit to clear
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static inline void change_bit_local(int nr, volatile unsigned long *addr)
+{
+	if (IS_IMMEDIATE(nr)) {
+		asm volatile("xorb %1,%0"
+			: CONST_MASK_ADDR(nr, addr)
+			: "iq" ((u8)CONST_MASK(nr))
+			: "memory");
+	} else {
+		asm volatile("btc %1,%0"
+			: BITOP_ADDR(addr)
+			: "Ir" (nr)
+			: "memory");
+	}
+}
+
+/**
  * test_and_set_bit - Set a bit and return its old value
  * @nr: Bit to set
  * @addr: Address to count from
@@ -236,6 +310,24 @@ static inline int __test_and_set_bit(int nr, volatile unsigned long *addr)
 }
 
 /**
+ * test_and_set_bit_local - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static inline int test_and_set_bit_local(int nr, volatile unsigned long *addr)
+{
+	int oldbit;
+
+	asm volatile("bts %2,%1\n\t"
+		     "sbb %0,%0" : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
+
+	return oldbit;
+}
+
+/**
  * test_and_clear_bit - Clear a bit and return its old value
  * @nr: Bit to clear
  * @addr: Address to count from
@@ -274,6 +366,26 @@ static inline int __test_and_clear_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
+/**
+ * test_and_clear_bit_local - Clear a bit and return its old value
+ * @nr: Bit to clear
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static inline
+int test_and_clear_bit_local(int nr, volatile unsigned long *addr)
+{
+	int oldbit;
+
+	asm volatile("btr %2,%1\n\t"
+		     "sbb %0,%0"
+		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
+
+	return oldbit;
+}
+
 /* WARNING: non atomic and it can be reordered! */
 static inline int __test_and_change_bit(int nr, volatile unsigned long *addr)
 {
@@ -306,6 +418,26 @@ static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
 	return oldbit;
 }
 
+/**
+ * test_and_change_bit_local - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static inline
+int test_and_change_bit_local(int nr, volatile unsigned long *addr)
+{
+	int oldbit;
+
+	asm volatile("btc %2,%1\n\t"
+		     "sbb %0,%0"
+		     : "=r" (oldbit), ADDR : "Ir" (nr) : "memory");
+
+	return oldbit;
+}
+
 static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr % BITS_PER_LONG)) &
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
index 0000000..8ae3c22
--- /dev/null
+++ b/include/asm-generic/bitops/local-atomic.h
@@ -0,0 +1,114 @@
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
+#if 0 /* Fool kernel-doc since it doesn't do macros yet */
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
+static
+void set_bit_local(unsigned int nr, volatile unsigned long *addr);
+#endif
+#define set_bit_local(nr, addr) set_bit(nr, addr)
+
+#if 0 /* Fool kernel-doc since it doesn't do macros yet */
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
+static
+void clear_bit_local(unsigned int nr, volatile unsigned long *addr);
+#endif
+#define clear_bit_local(nr, addr) clear_bit(nr, addr)
+
+#if 0 /* Fool kernel-doc since it doesn't do macros yet */
+/**
+ * change_bit_local - Toggle a bit in memory
+ * @nr: Bit to change
+ * @addr: Address to start counting from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static
+void change_bit_local(unsigned int nr, volatile unsigned long *addr);
+#endif
+#define change_bit_local(nr, addr) change_bit(nr, addr)
+
+#if 0 /* Fool kernel-doc since it doesn't do macros yet */
+/**
+ * test_and_set_bit_local - Set a bit and return its old value
+ * @nr: Bit to set
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static
+int test_and_set_bit_local(unsigned int nr, volatile unsigned long *addr);
+#endif
+#define test_and_set_bit_local(nr, addr) test_and_set_bit(nr, addr)
+
+#if 0 /* Fool kernel-doc since it doesn't do macros yet */
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
+static
+int test_and_clear_bit_local(unsigned int nr, volatile unsigned long *addr);
+#endif
+#define test_and_clear_bit_local(nr, addr) test_and_clear_bit(nr, addr)
+
+#if 0 /* Fool kernel-doc since it doesn't do macros yet */
+/**
+ * test_and_change_bit_local - Change a bit and return its old value
+ * @nr: Bit to change
+ * @addr: Address to count from
+ *
+ * This operation is atomic with respect to local CPU only. No memory barrier
+ * is implied.
+ */
+static
+int test_and_change_bit_local(unsigned int nr, volatile unsigned long *addr);
+#endif
+#define test_and_change_bit_local(nr, addr) test_and_change_bit(nr, addr)
+
+#endif /* ASM_GENERIC_BITOPS_LOCAL_ATOMIC_H */
diff --git a/include/linux/bitops.h b/include/linux/bitops.h
index a3b6b82..09ab214 100644
--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -197,5 +197,13 @@ extern unsigned long find_last_bit(const unsigned long *addr,
 				   unsigned long size);
 #endif
 
+/**
+ * Include the generic version for local atomics unless
+ * an architecture overrides it.
+ * */
+#ifndef ARCH_HAS_BITOPS_LOCAL_ATOMIC
+#include "include/asm-generic/bitops/local-atomic.h"
+#endif
+
 #endif /* __KERNEL__ */
 #endif
-- 
MST
