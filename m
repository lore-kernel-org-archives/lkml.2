Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab2GJJ4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:56:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34798 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab2GJJ4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:56:22 -0400
Date: Tue, 10 Jul 2012 02:55:59 -0700
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-1ba9a294141b106b7247649a5c3372d8284eca80@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, jbeulich@suse.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, torvalds@linux-foundation.org,
        a.p.zijlstra@chello.nl, jbeulich@suse.com, akpm@linux-foundation.org,
        JBeulich@suse.com, tglx@linutronix.de
In-Reply-To: <4FF70D54020000780008E179@nat28.tlf.novell.com>
References: <4FF70D54020000780008E179@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/mm/mtrr:
  Fix alignment determination in range_to_mtrr()
Git-Commit-ID: 1ba9a294141b106b7247649a5c3372d8284eca80
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 10 Jul 2012 02:56:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ba9a294141b106b7247649a5c3372d8284eca80
Gitweb:     http://git.kernel.org/tip/1ba9a294141b106b7247649a5c3372d8284eca80
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 6 Jul 2012 15:07:48 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 10 Jul 2012 10:38:14 +0200

x86/mm/mtrr: Fix alignment determination in range_to_mtrr()

With the variable operated on being of "unsigned long" type,
neither ffs() nor fls() are suitable to use on them, as those
truncate their arguments to 32 bits. Using __ffs() and __fls()
respectively at once eliminates the need to subtract 1 from their
results.

Additionally, with the alignment value subsequently used as a
shift count, it must be enforced to be less than BITS_PER_LONG
(and on 64-bit there's no need for it to be any smaller).

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/4FF70D54020000780008E179@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index bdda2e6..35ffda5 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -258,11 +258,11 @@ range_to_mtrr(unsigned int reg, unsigned long range_startk,
 
 		/* Compute the maximum size with which we can make a range: */
 		if (range_startk)
-			max_align = ffs(range_startk) - 1;
+			max_align = __ffs(range_startk);
 		else
-			max_align = 32;
+			max_align = BITS_PER_LONG - 1;
 
-		align = fls(range_sizek) - 1;
+		align = __fls(range_sizek);
 		if (align > max_align)
 			align = max_align;
 
