Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2LLQb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 11:31:59 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:46084
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab2LLQbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 11:31:21 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MEXF7Y-02-CDG-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 1/5] perf: Add hardware breakpoint address mask
Date: Wed, 12 Dec 2012 10:30:39 -0600
Message-ID: <1355329843-25842-2-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
References: <1355329843-25842-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some architectures (for us, AMD Family 16h) allow for "don't care" bit
mask to further qualify a hardware breakpoint address, in order to
trap on range of addresses. Update perf uapi to add bp_addr_mask field
and define HAVE_HW_BREAKPOINT_ADDR_MASK.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 arch/Kconfig                    |    4 ++++
 include/linux/hw_breakpoint.h   |    6 ++++++
 include/uapi/linux/perf_event.h |    5 ++++-
 kernel/events/hw_breakpoint.c   |    3 +++
 4 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index cc74aae..0bf366f 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -201,6 +201,10 @@ config HAVE_HW_BREAKPOINT
 	bool
 	depends on PERF_EVENTS
 
+config HAVE_HW_BREAKPOINT_ADDR_MASK
+       bool
+       depends on HAVE_HW_BREAKPOINT
+
 config HAVE_MIXED_BREAKPOINTS_REGS
 	bool
 	depends on HAVE_HW_BREAKPOINT
diff --git a/include/linux/hw_breakpoint.h b/include/linux/hw_breakpoint.h
index 0464c85..9384201 100644
--- a/include/linux/hw_breakpoint.h
+++ b/include/linux/hw_breakpoint.h
@@ -84,6 +84,12 @@ static inline struct arch_hw_breakpoint *counter_arch_bp(struct perf_event *bp)
 	return &bp->hw.info;
 }
 
+#ifdef CONFIG_HAVE_HW_BREAKPOINT_ADDR_MASK
+extern int arch_has_hw_breakpoint_addr_mask(void);
+#else
+static inline int arch_has_hw_breakpoint_addr_mask(void) { return 0; }
+#endif /* CONFIG_HAVE_HW_BREAKPOINT_ADDR_MASK */
+
 #else /* !CONFIG_HAVE_HW_BREAKPOINT */
 
 static inline int __init init_hw_breakpoint(void) { return 0; }
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 4f63c05..067d315 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -284,7 +284,10 @@ struct perf_event_attr {
 		__u64		config1; /* extension of config */
 	};
 	union {
-		__u64		bp_len;
+		struct {
+			__u32		bp_len;
+			__u32		bp_addr_mask;
+		};
 		__u64		config2; /* extension of config1 */
 	};
 	__u64	branch_sample_type; /* enum perf_branch_sample_type */
diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index fe8a916..6f10baa 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -612,6 +612,9 @@ static int hw_breakpoint_add(struct perf_event *bp, int flags)
 	if (!(flags & PERF_EF_START))
 		bp->hw.state = PERF_HES_STOPPED;
 
+	if (bp->attr.bp_addr_mask && !arch_has_hw_breakpoint_addr_mask())
+		return -EOPNOTSUPP;
+
 	return arch_install_hw_breakpoint(bp);
 }
 
-- 
1.7.9.5


