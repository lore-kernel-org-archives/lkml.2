Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2EHEZK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 00:25:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51329 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2EHEZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 00:25:08 -0400
Date: Mon, 7 May 2012 21:24:56 -0700
From: tip-bot for Shai Fultheim <shai@scalemp.com>
Message-ID: <tip-42fa4250436304d4650fa271f37671f6cee24e08@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        shai@scalemp.com, ido@wizery.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        shai@scalemp.com, tglx@linutronix.de, ido@wizery.com
In-Reply-To: <1334873552-31346-1-git-send-email-ido@wizery.com>
References: <1334873552-31346-1-git-send-email-ido@wizery.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86:
  Conditionally update time when ack-ing pending irqs
Git-Commit-ID: 42fa4250436304d4650fa271f37671f6cee24e08
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 07 May 2012 21:25:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42fa4250436304d4650fa271f37671f6cee24e08
Gitweb:     http://git.kernel.org/tip/42fa4250436304d4650fa271f37671f6cee24e08
Author:     Shai Fultheim <shai@scalemp.com>
AuthorDate: Fri, 20 Apr 2012 01:12:32 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 7 May 2012 16:25:28 +0200

x86: Conditionally update time when ack-ing pending irqs

On virtual environments, apic_read could take a long time. As a
result, under certain conditions the ack pending loop may exit
without any queued irqs left, but after more than one second. A
warning will be printed needlessly in this case.

If the loop is about to exit regardless of max_loops, don't
update it.

Signed-off-by: Shai Fultheim <shai@scalemp.com>
[ rebased and reworded the commit message]
Signed-off-by: Ido Yariv <ido@wizery.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1334873552-31346-1-git-send-email-ido@wizery.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index edc2448..3beab62 100644
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
 
