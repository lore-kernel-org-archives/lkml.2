Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962Ab1BNSIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 13:08:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:45622 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752602Ab1BNSH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 13:07:26 -0500
Date: Mon, 14 Feb 2011 13:53:52 GMT
From: tip-bot for Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andi@firstfloor.org, eric.dumazet@gmail.com, shaohua.li@intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, andi@firstfloor.org, tglx@linutronix.de,
        shaohua.li@intel.com, mingo@elte.hu
In-Reply-To: <1295232730.1949.710.camel@sli10-conroe>
References: <1295232730.1949.710.camel@sli10-conroe>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86: Avoid tlbstate lock if not enough cpus
Message-ID: <tip-7064d865af804b9b841e7b9a3e9b653e40c3e5ca@git.kernel.org>
Git-Commit-ID: 7064d865af804b9b841e7b9a3e9b653e40c3e5ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Feb 2011 18:06:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7064d865af804b9b841e7b9a3e9b653e40c3e5ca
Gitweb:     http://git.kernel.org/tip/7064d865af804b9b841e7b9a3e9b653e40c3e5ca
Author:     Shaohua Li <shaohua.li@intel.com>
AuthorDate: Mon, 17 Jan 2011 10:52:10 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 14 Feb 2011 13:03:08 +0100

x86: Avoid tlbstate lock if not enough cpus

This one isn't related to previous patch. If online cpus are
below NUM_INVALIDATE_TLB_VECTORS, we don't need the lock. The
comments in the code declares we don't need the check, but a hot
lock still needs an atomic operation and expensive, so add the
check here.

Uses nr_cpu_ids here as suggested by Eric Dumazet.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
LKML-Reference: <1295232730.1949.710.camel@sli10-conroe>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/tlb.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 6acc724..55272d7 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -179,12 +179,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 	sender = this_cpu_read(tlb_vector_offset);
 	f = &flush_state[sender];
 
-	/*
-	 * Could avoid this lock when
-	 * num_online_cpus() <= NUM_INVALIDATE_TLB_VECTORS, but it is
-	 * probably not worth checking this for a cache-hot lock.
-	 */
-	raw_spin_lock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_lock(&f->tlbstate_lock);
 
 	f->flush_mm = mm;
 	f->flush_va = va;
@@ -202,7 +198,8 @@ static void flush_tlb_others_ipi(const struct cpumask *cpumask,
 
 	f->flush_mm = NULL;
 	f->flush_va = 0;
-	raw_spin_unlock(&f->tlbstate_lock);
+	if (nr_cpu_ids > NUM_INVALIDATE_TLB_VECTORS)
+		raw_spin_unlock(&f->tlbstate_lock);
 }
 
 void native_flush_tlb_others(const struct cpumask *cpumask,
