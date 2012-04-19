Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932731Ab2DSWNE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 18:13:04 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46483 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932508Ab2DSWNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 18:13:02 -0400
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Subject: [PATCH RESEND] x86: Conditionally update time when ack-ing pending irqs
Date: Fri, 20 Apr 2012 01:12:32 +0300
Message-Id: <1334873552-31346-1-git-send-email-ido@wizery.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1333716101-26186-1-git-send-email-ido@wizery.com>
References: <1333716101-26186-1-git-send-email-ido@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shai Fultheim <shai@scalemp.com>

On virtual environments, apic_read could take a long time. As a result,
under certain conditions the ack pending loop may exit without any
queued irqs left, but after more than one second. A warning will be
printed needlessly in this case.

If the loop is about to exit regardless of max_loops, don't update it.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ido@wizery.com: rebased and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 arch/x86/kernel/apic/apic.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 11544d8..f0330f2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1325,11 +1325,13 @@ void __cpuinit setup_local_APIC(void)
 			       acked);
 			break;
 		}
-		if (cpu_has_tsc) {
-			rdtscll(ntsc);
-			max_loops = (cpu_khz << 10) - (ntsc - tsc);
-		} else
-			max_loops--;
+		if (queued) {
+			if (cpu_has_tsc) {
+				rdtscll(ntsc);
+				max_loops = (cpu_khz << 10) - (ntsc - tsc);
+			} else
+				max_loops--;
+		}
 	} while (queued && max_loops > 0);
 	WARN_ON(max_loops <= 0);
 
-- 
1.7.7.6

