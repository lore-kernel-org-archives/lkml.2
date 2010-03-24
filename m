Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631Ab0CXIt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:49:27 -0400
Received: from hera.kernel.org ([140.211.167.34]:59664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361Ab0CXIt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:49:26 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       cl@linux-foundation.org, mingo@elte.hu, adobriyan@gmail.com,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] x86: don't include slab.h from arch/x86/include/asm/pgtable_32.h
Date: Wed, 24 Mar 2010 17:48:55 +0900
Message-Id: <1269420538-18039-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269420538-18039-1-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Mar 2010 08:49:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Including slab.h from x86 pgtable_32.h creates a troublesome
dependency chain w/ ftrace enabled.  The following chain leads to
inclusion of pgtable_32.h from define_trace.h.

 trace/define_trace.h
 trace/ftrace.h
 linux/ftrace_event.h
 linux/ring_buffer.h
 linux/mm.h
 asm/pgtable.h
 asm/pgtable_32.h

And when slab.h itself defines trace hooks via

 linux/sl[aou]b_def.h
 linux/kmemtrace.h
 trace/events/kmem.h

If slab.h is not included before define_trace.h is included, this
leads to duplicate definitions of kmemtrace hooks or other include
dependency problems.

pgtable_32.h doesn't need slab.h to begin with.  Don't include it from
there.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/pgtable_32.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 47339a1..2984a25 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -19,7 +19,6 @@
 #include <asm/paravirt.h>
 
 #include <linux/bitops.h>
-#include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/spinlock.h>
 
-- 
1.6.4.2

