Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab0KEQxI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 12:53:08 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56910 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab0KEQxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 12:53:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=dNwd8fOs/jXtp2/6WO8e56bdubuU+2q8IYjsYz1vLC664XRUVasRcGS08m/KUKCWn9
         W2DDrjxkX+YqHLtrjmi7FFpjhyQnm2H0V6v3vuJPB5qO/FFjqyZ3KNNgqO9AnOw35VI/
         CRu0UwSCZ8DW5+0xc1Sm/8luQaJ0YzmFHSD8k=
Subject: [PATCH] atomic: add atomic_inc_not_zero_hint()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nick Piggin <npiggin@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Nov 2010 17:53:00 +0100
Message-ID: <1288975980.2882.877.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew

atomic_inc_not_zero() / atomic_add_unless() ... are spreaded in many
arch/xxx/include/asm/atomic.h, but they are generic.

Apparently there is no centralization of some common atomic features...

What do you think adding a new file so that we can move common
definitions in it ?

Thanks

[PATCH] atomic: add atomic_inc_not_zero_hint()

Followup of perf tools session in Netfilter WorkShop 2010

In network stack we make high usage of atomic_inc_not_zero() in contexts
we know the probable value of atomic before increment (2 for udp sockets
for example)

Using a special version of atomic_inc_not_zero() giving this hint can
help processor to use less bus transactions.

On x86 (MESI protocol) for example, this avoids entering Shared state,
because "lock cmpxchg" issues an RFO (Read For Ownership)

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Nick Piggin <npiggin@kernel.dk>
---
 include/linux/atomic.h |   29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux/atomic.h b/include/linux/atomic.h
new file mode 100644
index 0000000..c04327a
--- /dev/null
+++ b/include/linux/atomic.h
@@ -0,0 +1,29 @@
+#ifndef _LINUX_ATOMIC_H
+#define _LINUX_ATOMIC_H
+#include <asm/atomic.h>
+
+/**
+ * atomic_inc_not_zero_hint - increment if not null
+ * @v: pointer of type atomic_t
+ * @hint: probable value of the atomic before the increment
+ *
+ * This version of atomic_inc_not_zero() gives a hint of probable
+ * value of the atomic. This helps processor to not read the memory
+ * before doing the atomic read/modify/write cycle, lowering
+ * number of bus transactions on some arches.
+ * Note: hint MUST not be 0 !
+ */
+static inline int atomic_inc_not_zero_hint(atomic_t *v, int hint)
+{
+	int val, c = hint;
+
+ 	do {
+		val = atomic_cmpxchg(v, c, c + 1);
+		if (val == c)
+			return 1;
+		c = val;
+	} while (c);
+
+	return 0;
+}
+#endif /* _LINUX_ATOMIC_H */


