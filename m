Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574Ab0EDMlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759492Ab0EDMln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:41:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20100503225105.GA18897@google.com>
References: <20100503225105.GA18897@google.com>
To: Michel Lespinasse <walken@google.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@google.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86 rwsem: up_read() does not check active count in fast path
Date: Tue, 04 May 2010 13:41:36 +0100
Message-ID: <30960.1272976896@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse <walken@google.com> wrote:

> Looking at the x86 rwsem code, I have been wondering about the up_read()
> path.  __rwsem_do_wake() comment mentions that one should check the active
> count on the way there; however I could not find that check when coming from
> up_read().

Look in call_rwsem_wake(), which is implemented in assembly in two places in
the x86 arch:

	arch/x86/lib/rwsem_64.S
	arch/x86/lib/semaphore_32.S

Note that the x86_64 version contains a bug, a patch for which is attached.

David
---
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Fix the x86_64 implementation of call_rwsem_wait()

The x86_64 call_rwsem_wait() treats the active state counter part of the R/W
semaphore state as being 16-bit when it's actually 32-bit (it's half of the
64-bit state).  It should do "decl %edx" not "decw %dx".

Signed-off-by: David Howells <dhowells@redhat.com>
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
