Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab2AZNiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:38:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2AZNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:38:20 -0500
Date: Thu, 26 Jan 2012 05:37:58 -0800
From: tip-bot for Cliff Wickman <cpw@sgi.com>
Message-ID: <tip-d2ebc71d472020bc30e29afe8c4d2a85a5b41f56@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, sivanich@sgi.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, cpw@sgi.com, tglx@linutronix.de, sivanich@sgi.com,
        mingo@elte.hu
In-Reply-To: <E1RnXd1-0003wU-PM@eag09.americas.sgi.com>
References: <E1RnXd1-0003wU-PM@eag09.americas.sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/uv: Fix uninitialized spinlocks
Git-Commit-ID: d2ebc71d472020bc30e29afe8c4d2a85a5b41f56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 26 Jan 2012 05:38:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d2ebc71d472020bc30e29afe8c4d2a85a5b41f56
Gitweb:     http://git.kernel.org/tip/d2ebc71d472020bc30e29afe8c4d2a85a5b41f56
Author:     Cliff Wickman <cpw@sgi.com>
AuthorDate: Wed, 18 Jan 2012 09:40:47 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 26 Jan 2012 10:58:34 +0100

x86/uv: Fix uninitialized spinlocks

Initialize two spinlocks in tlb_uv.c and also properly define/initialize
the uv_irq_lock.

The lack of explicit initialization seems to be functionally
harmless, but it is diagnosed when these are turned on:

        CONFIG_DEBUG_SPINLOCK=y
        CONFIG_DEBUG_MUTEXES=y
        CONFIG_DEBUG_LOCK_ALLOC=y
        CONFIG_LOCKDEP=y

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Cc: <stable@kernel.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>
Link: http://lkml.kernel.org/r/E1RnXd1-0003wU-PM@eag09.americas.sgi.com
[ Added the uv_irq_lock initialization fix by Dimitri Sivanich ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |    2 ++
 arch/x86/platform/uv/uv_irq.c |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 9be4cff..3ae0e61 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1851,6 +1851,8 @@ static void __init init_per_cpu_tunables(void)
 		bcp->cong_reps			= congested_reps;
 		bcp->cong_period		= congested_period;
 		bcp->clocks_per_100_usec =	usec_2_cycles(100);
+		spin_lock_init(&bcp->queue_lock);
+		spin_lock_init(&bcp->uvhub_lock);
 	}
 }
 
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index 374a05d..f25c276 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -25,7 +25,7 @@ struct uv_irq_2_mmr_pnode{
 	int			irq;
 };
 
-static spinlock_t		uv_irq_lock;
+static DEFINE_SPINLOCK(uv_irq_lock);
 static struct rb_root		uv_irq_root;
 
 static int uv_set_irq_affinity(struct irq_data *, const struct cpumask *, bool);
