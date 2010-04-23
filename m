Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab0DWXwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 19:52:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:43347 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755073Ab0DWXwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 19:52:00 -0400
Date: Fri, 23 Apr 2010 23:51:42 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stable@kernel.org, samuel.thibault@inria.fr, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       samuel.thibault@inria.fr, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <4BD1E061.8030605@zytor.com>
References: <4BD1E061.8030605@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86-64: Clear a 64-bit FS/GS base on fork if selector is nonzero
Message-ID: <tip-7ce5a2b9bb2e92902230e3121d8c3047fab9cb47@git.kernel.org>
Git-Commit-ID: 7ce5a2b9bb2e92902230e3121d8c3047fab9cb47
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Apr 2010 23:51:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ce5a2b9bb2e92902230e3121d8c3047fab9cb47
Gitweb:     http://git.kernel.org/tip/7ce5a2b9bb2e92902230e3121d8c3047fab9cb47
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Fri, 23 Apr 2010 16:17:40 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Fri, 23 Apr 2010 16:49:51 -0700

x86-64: Clear a 64-bit FS/GS base on fork if selector is nonzero

When we do a thread switch, we clear the outgoing FS/GS base if the
corresponding selector is nonzero.  This is taken by __switch_to() as
an entry invariant; it does not verify that it is true on entry.
However, copy_thread() doesn't enforce this constraint, which can
result in inconsistent results after fork().

Make copy_thread() match the behavior of __switch_to().

Reported-and-tested-by: Samuel Thibault <samuel.thibault@inria.fr>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
LKML-Reference: <4BD1E061.8030605@zytor.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/process_64.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index dc9690b..17cb329 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -276,12 +276,12 @@ int copy_thread(unsigned long clone_flags, unsigned long sp,
 
 	set_tsk_thread_flag(p, TIF_FORK);
 
-	p->thread.fs = me->thread.fs;
-	p->thread.gs = me->thread.gs;
 	p->thread.io_bitmap_ptr = NULL;
 
 	savesegment(gs, p->thread.gsindex);
+	p->thread.gs = p->thread.gsindex ? 0 : me->thread.gs;
 	savesegment(fs, p->thread.fsindex);
+	p->thread.fs = p->thread.fsindex ? 0 : me->thread.fs;
 	savesegment(es, p->thread.es);
 	savesegment(ds, p->thread.ds);
 
