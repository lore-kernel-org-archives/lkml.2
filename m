Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab2FZF7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:59:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59546 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757884Ab2FZF7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:59:20 -0400
Date: Mon, 25 Jun 2012 22:59:05 -0700
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-11cab711f686893f2696a061dfca30454a624784@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org, cpw@sgi.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de
In-Reply-To: <20120622131212.GA31884@sgi.com>
References: <20120622131212.GA31884@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86/uv: Fix the UV BAU destination timeout period
Git-Commit-ID: 11cab711f686893f2696a061dfca30454a624784
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 25 Jun 2012 22:59:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  11cab711f686893f2696a061dfca30454a624784
Gitweb:     http://git.kernel.org/tip/11cab711f686893f2696a061dfca30454a624784
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Fri, 22 Jun 2012 08:12:12 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 25 Jun 2012 14:45:04 +0200

x86/uv: Fix the UV BAU destination timeout period

Correct the calculation of a destination timeout period, which
is used to distinguish between a destination timeout and the
situation where all the target software ack resources are full
and a request is returned immediately.

The problem is that integer arithmetic was overflowing, yielding
a very large result.

Without this fix destination timeouts are identified as resource
'plugged' events and an ipi method of resource releasing is
unnecessarily employed.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20120622131212.GA31884@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/platform/uv/tlb_uv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 59880af..0c48d43 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1811,8 +1811,8 @@ static int calculate_destination_timeout(void)
 		index = (mmr_image >> BAU_URGENCY_7_SHIFT) & BAU_URGENCY_7_MASK;
 		mmr_image = uv_read_local_mmr(UVH_TRANSACTION_TIMEOUT);
 		mult2 = (mmr_image >> BAU_TRANS_SHIFT) & BAU_TRANS_MASK;
-		base = timeout_base_ns[index];
-		ts_ns = base * mult1 * mult2;
+		ts_ns = timeout_base_ns[index];
+		ts_ns *= (mult1 * mult2);
 		ret = ts_ns / 1000;
 	} else {
 		/* 4 bits  0/1 for 10/80us base, 3 bits of multiplier */
