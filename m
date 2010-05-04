Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377Ab0EDSd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 14:33:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:50043 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0EDSd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 14:33:56 -0400
Date: Tue, 4 May 2010 18:33:41 GMT
From: tip-bot for David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       dhowells@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, tglx@linutronix.de
In-Reply-To: <20100504124253.30994.79841.stgit@warthog.procyon.org.uk>
References: <20100504124253.30994.79841.stgit@warthog.procyon.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Use the proper register width in call_rwsem_wait()
Message-ID: <tip-50db45f2f010e9251dae644c5fb86b321d9ac815@git.kernel.org>
Git-Commit-ID: 50db45f2f010e9251dae644c5fb86b321d9ac815
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 04 May 2010 18:33:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  50db45f2f010e9251dae644c5fb86b321d9ac815
Gitweb:     http://git.kernel.org/tip/50db45f2f010e9251dae644c5fb86b321d9ac815
Author:     David Howells <dhowells@redhat.com>
AuthorDate: Tue, 4 May 2010 13:42:53 +0100
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Tue, 4 May 2010 10:15:54 -0700

x86-64: Use the proper register width in call_rwsem_wait()

The x86_64 call_rwsem_wait() treats the active state counter part of the R/W
semaphore state as being 16-bit when it's actually 32-bit (it's half of the
64-bit state).  It should do "decl %edx" not "decw %dx".

[ hpa note: decl %edx will clear the upper half of %rdx, but the value of
  %rdx is dead after this point so that is OK. ]

Signed-off-by: David Howells <dhowells@redhat.com>
LKML-Reference: <20100504124253.30994.79841.stgit@warthog.procyon.org.uk>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/lib/rwsem_64.S |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/lib/rwsem_64.S b/arch/x86/lib/rwsem_64.S
index 15acecf..41fcf00 100644
--- a/arch/x86/lib/rwsem_64.S
+++ b/arch/x86/lib/rwsem_64.S
@@ -60,7 +60,7 @@ ENTRY(call_rwsem_down_write_failed)
 	ENDPROC(call_rwsem_down_write_failed)
 
 ENTRY(call_rwsem_wake)
-	decw %dx    /* do nothing if still outstanding active readers */
+	decl %edx	/* do nothing if still outstanding active readers */
 	jnz 1f
 	save_common_regs
 	movq %rax,%rdi
