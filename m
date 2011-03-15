Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056Ab1COHtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 03:49:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:59751 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab1COHth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 03:49:37 -0400
Date: Tue, 15 Mar 2011 07:49:08 GMT
From: tip-bot for Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        xiaoguangrong@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, xiaoguangrong@cn.fujitsu.com,
        mingo@elte.hu
In-Reply-To: <4D7EC791.4040003@cn.fujitsu.com>
References: <4D7EC791.4040003@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, tlb, UV: Do small micro-optimization for native_flush_tlb_others()
Message-ID: <tip-25542c646afbf14c43fa7d2b443055cadb73b07a@git.kernel.org>
Git-Commit-ID: 25542c646afbf14c43fa7d2b443055cadb73b07a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 15 Mar 2011 07:49:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  25542c646afbf14c43fa7d2b443055cadb73b07a
Gitweb:     http://git.kernel.org/tip/25542c646afbf14c43fa7d2b443055cadb73b07a
Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
AuthorDate: Tue, 15 Mar 2011 09:57:37 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 15 Mar 2011 08:30:34 +0100

x86, tlb, UV: Do small micro-optimization for native_flush_tlb_others()

native_flush_tlb_others() is called from:

 flush_tlb_current_task()
 flush_tlb_mm()
 flush_tlb_page()

All these functions disable preemption explicitly, so we can use
smp_processor_id() instead of get_cpu() and put_cpu().

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Cliff Wickman <cpw@sgi.com>
LKML-Reference: <4D7EC791.4040003@cn.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/tlb.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 55272d7..d6c0418 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -208,11 +208,10 @@ void native_flush_tlb_others(const struct cpumask *cpumask,
 	if (is_uv_system()) {
 		unsigned int cpu;
 
-		cpu = get_cpu();
+		cpu = smp_processor_id();
 		cpumask = uv_flush_tlb_others(cpumask, mm, va, cpu);
 		if (cpumask)
 			flush_tlb_others_ipi(cpumask, mm, va);
-		put_cpu();
 		return;
 	}
 	flush_tlb_others_ipi(cpumask, mm, va);
