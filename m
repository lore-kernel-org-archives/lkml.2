Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2ADPdA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:33:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37109 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab2ADPcx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:32:53 -0500
Date: Wed, 4 Jan 2012 07:32:28 -0800
From: tip-bot for Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <tip-ceb7b40b65539a771d1bfaf47660ac0ee57e0c4f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        eric.dumazet@gmail.com, torvalds@linux-foundation.org, cl@linux.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com, torvalds@linux-foundation.org, cl@linux.com,
        akpm@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1325608540.2320.103.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1325608540.2320.103.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86: Fix atomic64_xxx_cx8() functions
Git-Commit-ID: ceb7b40b65539a771d1bfaf47660ac0ee57e0c4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Jan 2012 07:32:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ceb7b40b65539a771d1bfaf47660ac0ee57e0c4f
Gitweb:     http://git.kernel.org/tip/ceb7b40b65539a771d1bfaf47660ac0ee57e0c4f
Author:     Eric Dumazet <eric.dumazet@gmail.com>
AuthorDate: Tue, 3 Jan 2012 17:35:40 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 4 Jan 2012 15:01:56 +0100

x86: Fix atomic64_xxx_cx8() functions

It appears about all functions in arch/x86/lib/atomic64_cx8_32.S
are wrong in case cmpxchg8b must be restarted, because
LOCK_PREFIX macro defines a label "1" clashing with other local
labels :

1:
	some_instructions
	LOCK_PREFIX
	cmpxchg8b (%ebp)
	jne 1b  / jumps to beginning of LOCK_PREFIX !

A possible fix is to use a magic label "672" in LOCK_PREFIX asm
definition, similar to the "671" one we defined in
LOCK_PREFIX_HERE.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Acked-by: Jan Beulich <JBeulich@suse.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1325608540.2320.103.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/alternative-asm.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/alternative-asm.h b/arch/x86/include/asm/alternative-asm.h
index 091508b..952bd01 100644
--- a/arch/x86/include/asm/alternative-asm.h
+++ b/arch/x86/include/asm/alternative-asm.h
@@ -4,10 +4,10 @@
 
 #ifdef CONFIG_SMP
 	.macro LOCK_PREFIX
-1:	lock
+672:	lock
 	.section .smp_locks,"a"
 	.balign 4
-	.long 1b - .
+	.long 672b - .
 	.previous
 	.endm
 #else
