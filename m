Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709Ab1LERqO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:46:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58821 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932531Ab1LERqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:46:12 -0500
Date: Mon, 5 Dec 2011 09:45:49 -0800
From: tip-bot for Ajaykumar Hotchandani 
	<ajaykumar.hotchandani@oracle.com>
Message-ID: <tip-8dbf4a30033ff61091015f0076e872b5c8f717cc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        arjan@linux.intel.com, torvalds@linux-foundation.org,
        ajaykumar.hotchandani@oracle.com, lucas.demarchi@profusion.mobi,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ajaykumar.hotchandani@oracle.com, torvalds@linux-foundation.org,
        arjan@linux.intel.com, tglx@linutronix.de,
        lucas.demarchi@profusion.mobi, mingo@elte.hu
In-Reply-To: <4EBD1CC5.3030008@oracle.com>
References: <4EBD1CC5.3030008@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mtrr: Resolve inconsistency with Intel processor manual
Git-Commit-ID: 8dbf4a30033ff61091015f0076e872b5c8f717cc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 09:45:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8dbf4a30033ff61091015f0076e872b5c8f717cc
Gitweb:     http://git.kernel.org/tip/8dbf4a30033ff61091015f0076e872b5c8f717cc
Author:     Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
AuthorDate: Fri, 11 Nov 2011 18:31:57 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 15:06:15 +0100

x86/mtrr: Resolve inconsistency with Intel processor manual

Following is from Notes of section 11.5.3 of Intel processor
manual available at:

  http://www.intel.com/Assets/PDF/manual/325384.pdf

For the Pentium 4 and Intel Xeon processors, after the sequence of
steps given above has been executed, the cache lines containing the
code between the end of the WBINVD instruction and before the
MTRRS have actually been disabled may be retained in the cache
hierarchy. Here, to remove code from the cache completely, a
second WBINVD instruction must be executed after the MTRRs have
been disabled.

This patch provides resolution for that.

Ideally, I will like to make changes only for Pentium 4 and Xeon
processors. But, I am not finding easier way to do it.
And, extra wbinvd() instruction does not hurt much for other
processors.

Signed-off-by: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Link: http://lkml.kernel.org/r/4EBD1CC5.3030008@oracle.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/mtrr/generic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index e1fe7f4..97b2635 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -694,6 +694,7 @@ static void prepare_set(void) __acquires(set_atomicity_lock)
 
 	/* Disable MTRRs, and set the default type to uncached */
 	mtrr_wrmsr(MSR_MTRRdefType, deftype_lo & ~0xcff, deftype_hi);
+	wbinvd();
 }
 
 static void post_set(void) __releases(set_atomicity_lock)
