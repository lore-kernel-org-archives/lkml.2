Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583Ab0HXPk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:40:28 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:47661 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432Ab0HXPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:39:44 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Julia Lawall <julia@diku.dk>, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix@diku.dk>, Michal Marek <mmarek@suse.cz>
Cc: cocci@diku.dk, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Nicolas Palix <npalix@diku.dk>
Subject: [PATCH 04/18] Coccinelle: Add locks/call_kern.cocci
Date: Tue, 24 Aug 2010 17:38:58 +0200
Message-Id: <1282664352-15882-5-git-send-email-npalix@diku.dk>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282664352-15882-1-git-send-email-npalix@diku.dk>
References: <1282664352-15882-1-git-send-email-npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find functions that refer to GFP_KERNEL but are called with locks held.
The proposed change of converting the GFP_KERNEL is not necessarily the
correct one.  It may be desired to unlock the lock, or to not call the
function under the lock in the first place.

Signed-off-by: Nicolas Palix <npalix@diku.dk>
Signed-off-by: Julia Lawall <julia@diku.dk>
---
 scripts/coccinelle/locks/call_kern.cocci |   74 ++++++++++++++++++++++++++++++
 1 files changed, 74 insertions(+), 0 deletions(-)
 create mode 100644 scripts/coccinelle/locks/call_kern.cocci

diff --git a/scripts/coccinelle/locks/call_kern.cocci b/scripts/coccinelle/locks/call_kern.cocci
new file mode 100644
index 0000000..00af534
--- /dev/null
+++ b/scripts/coccinelle/locks/call_kern.cocci
@@ -0,0 +1,74 @@
+/// Find functions that refer to GFP_KERNEL but are called with locks held.
+/// The proposed change of converting the GFP_KERNEL is not necessarily the
+/// correct one.  It may be desired to unlock the lock, or to not call the
+/// function under the lock in the first place.
+///
+// Confidence: Moderate
+// Copyright: (C) 2010 Nicolas Palix, DIKU.  GPLv2.
+// Copyright: (C) 2010 Julia Lawall, DIKU.  GPLv2.
+// Copyright: (C) 2010 Gilles Muller, INRIA/LiP6.  GPLv2.
+// URL: http://coccinelle.lip6.fr/
+// Comments:
+// Options: -no_includes -include_headers
+
+virtual patch
+
+@gfp exists@
+identifier fn;
+position p;
+@@
+
+fn(...) {
+ ... when != read_unlock_irq(...)
+     when != write_unlock_irq(...)
+     when != read_unlock_irqrestore(...)
+     when != write_unlock_irqrestore(...)
+     when != spin_unlock(...)
+     when != spin_unlock_irq(...)
+     when != spin_unlock_irqrestore(...)
+     when != local_irq_enable(...)
+     when any
+ GFP_KERNEL@p
+ ... when any
+}
+
+@locked@
+identifier gfp.fn;
+@@
+
+(
+read_lock_irq
+|
+write_lock_irq
+|
+read_lock_irqsave
+|
+write_lock_irqsave
+|
+spin_lock
+|
+spin_trylock
+|
+spin_lock_irq
+|
+spin_lock_irqsave
+|
+local_irq_disable
+)
+ (...)
+...  when != read_unlock_irq(...)
+     when != write_unlock_irq(...)
+     when != read_unlock_irqrestore(...)
+     when != write_unlock_irqrestore(...)
+     when != spin_unlock(...)
+     when != spin_unlock_irq(...)
+     when != spin_unlock_irqrestore(...)
+     when != local_irq_enable(...)
+fn(...)
+
+@depends on locked@
+position gfp.p;
+@@
+
+- GFP_KERNEL@p
++ GFP_ATOMIC
-- 
1.7.0.4

