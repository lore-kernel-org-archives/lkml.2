Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1FUPQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 11:16:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:59933 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859Ab1FUPQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 11:16:27 -0400
Date: Tue, 21 Jun 2011 15:16:15 GMT
From: "tip-bot for cpw@sgi.com" <cpw@sgi.com>
Message-ID: <tip-00b30cf04a775b5292ab704f782394e36e25617d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, cpw@sgi.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        cpw@sgi.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110621122242.086384966@sgi.com>
References: <20110621122242.086384966@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/uv] x86, UV: Fix smp_processor_id() use in a preemptable region
Git-Commit-ID: 00b30cf04a775b5292ab704f782394e36e25617d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 21 Jun 2011 15:16:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  00b30cf04a775b5292ab704f782394e36e25617d
Gitweb:     http://git.kernel.org/tip/00b30cf04a775b5292ab704f782394e36e25617d
Author:     cpw@sgi.com <cpw@sgi.com>
AuthorDate: Tue, 21 Jun 2011 07:21:26 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 21 Jun 2011 14:50:31 +0200

x86, UV: Fix smp_processor_id() use in a preemptable region

Fix a call by tunables_write() to smp_processor_id() within a
preemptable region.

Call get_cpu()/put_cpu() around the region where the returned
cpu number is actually used, which makes it non-preemptable.

A DEBUG_PREEMPT warning is prevented.

UV does not support cpu hotplug yet, but this is a step toward
that ability as well.

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Link: http://lkml.kernel.org/r/20110621122242.086384966@sgi.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/platform/uv/tlb_uv.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/platform/uv/tlb_uv.c b/arch/x86/platform/uv/tlb_uv.c
index 68e467f..34be650 100644
--- a/arch/x86/platform/uv/tlb_uv.c
+++ b/arch/x86/platform/uv/tlb_uv.c
@@ -1334,9 +1334,10 @@ static ssize_t tunables_write(struct file *file, const char __user *user,
 
 	instr[count] = '\0';
 
-	bcp = &per_cpu(bau_control, smp_processor_id());
-
+	cpu = get_cpu();
+	bcp = &per_cpu(bau_control, cpu);
 	ret = parse_tunables_write(bcp, instr, count);
+	put_cpu();
 	if (ret)
 		return ret;
 
