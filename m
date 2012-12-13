Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128Ab2LMQnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 11:43:07 -0500
Received: from usmamail.tilera.com ([12.216.194.151]:37347 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab2LMQnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 11:43:05 -0500
Message-ID: <201212131643.qBDGh4L3018088@farm-0013.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Thu, 13 Dec 2012 11:34:45 -0500
Subject: [PATCH] arch/tile: clean up tile-specific PTRACE_SETOPTIONS
To: <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <20121213162710.GA20271@redhat.com>
References: <20121213162710.GA20271@redhat.com> <201212122227.qBCMRiNg000851@farm-0002.internal.tilera.com> <20121212234307.GA7694@redhat.com> <50C9ECFF.6070708@tilera.com> <20121213154929.GA17421@redhat.com> <50C9FF11.2030303@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the newer idioms for setting PTRACE_O_xxx and PT_TRACE_xxx flags.
Only set/clear tile-specific flags if the generic routine returns
success, since otherwise we want to avoid setting any flags at all.
Atomically update the ptrace flags with the new values.  Eliminate
the PT_TRACE_MASK_TILE bitmask and just shift PTRACE_O_MASK_TILE.
Add a BUILD_BUG_ON to avoid overlapping with generic bits.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/include/asm/ptrace.h      |    3 +--
 arch/tile/include/uapi/asm/ptrace.h |    2 +-
 arch/tile/kernel/ptrace.c           |   10 +++++++---
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
index 1a4fd9a..5ce052e 100644
--- a/arch/tile/include/asm/ptrace.h
+++ b/arch/tile/include/asm/ptrace.h
@@ -24,8 +24,7 @@ typedef unsigned long pt_reg_t;
 #include <uapi/asm/ptrace.h>
 
 #define PTRACE_O_MASK_TILE	(PTRACE_O_TRACEMIGRATE)
-#define PT_TRACE_MIGRATE	0x00080000
-#define PT_TRACE_MASK_TILE	(PT_TRACE_MIGRATE)
+#define PT_TRACE_MIGRATE	PT_EVENT_FLAG(PTRACE_EVENT_MIGRATE)
 
 /* Flag bits in pt_regs.flags */
 #define PT_FLAGS_DISABLE_IRQ    1  /* on return to kernel, disable irqs */
diff --git a/arch/tile/include/uapi/asm/ptrace.h b/arch/tile/include/uapi/asm/ptrace.h
index 0d22088..7757e19 100644
--- a/arch/tile/include/uapi/asm/ptrace.h
+++ b/arch/tile/include/uapi/asm/ptrace.h
@@ -81,8 +81,8 @@ struct pt_regs {
 #define PTRACE_SETFPREGS	15
 
 /* Support TILE-specific ptrace options, with events starting at 16. */
-#define PTRACE_O_TRACEMIGRATE	0x00010000
 #define PTRACE_EVENT_MIGRATE	16
+#define PTRACE_O_TRACEMIGRATE	(1 << PTRACE_EVENT_MIGRATE)
 
 /*
  * Flag bits in pt_regs.flags that are part of the ptrace API.
diff --git a/arch/tile/kernel/ptrace.c b/arch/tile/kernel/ptrace.c
index 64ba102..b32bc3f 100644
--- a/arch/tile/kernel/ptrace.c
+++ b/arch/tile/kernel/ptrace.c
@@ -151,12 +151,16 @@ long arch_ptrace(struct task_struct *child, long request,
 
 	case PTRACE_SETOPTIONS:
 		/* Support TILE-specific ptrace options. */
-		child->ptrace &= ~PT_TRACE_MASK_TILE;
+		BUILD_BUG_ON(PTRACE_O_MASK_TILE & PTRACE_O_MASK);
 		tmp = data & PTRACE_O_MASK_TILE;
 		data &= ~PTRACE_O_MASK_TILE;
 		ret = ptrace_request(child, request, addr, data);
-		if (tmp & PTRACE_O_TRACEMIGRATE)
-			child->ptrace |= PT_TRACE_MIGRATE;
+		if (ret == 0) {
+			unsigned int flags = child->ptrace;
+			flags &= ~(PTRACE_O_MASK_TILE << PT_OPT_FLAG_SHIFT);
+			flags |= (tmp << PT_OPT_FLAG_SHIFT);
+			child->ptrace = flags;
+		}
 		break;
 
 	default:
-- 
1.7.10.3

