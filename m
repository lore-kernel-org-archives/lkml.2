Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0LLX6s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:58:48 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36603 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755762Ab0LLXr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:47:58 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: nelhage@ksplice.com, kosaki.motohiro@jp.fujitsu.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [172/223] do_exit(): make sure that we run with get_fs() == USER_DS
Message-Id: <20101212234756.D4E54B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:47:56 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Nelson Elhage <nelhage@ksplice.com>

commit 33dd94ae1ccbfb7bf0fb6c692bc3d1c4269e6177 upstream.

If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
otherwise reset before do_exit().  do_exit may later (via mm_release in
fork.c) do a put_user to a user-controlled address, potentially allowing
a user to leverage an oops into a controlled write into kernel memory.

This is only triggerable in the presence of another bug, but this
potentially turns a lot of DoS bugs into privilege escalations, so it's
worth fixing.  I have proof-of-concept code which uses this bug along
with CVE-2010-3849 to write a zero to an arbitrary kernel address, so
I've tested that this is not theoretical.

A more logical place to put this fix might be when we know an oops has
occurred, before we call do_exit(), but that would involve changing
every architecture, in multiple places.

Let's just stick it in do_exit instead.

[akpm@linux-foundation.org: update code comment]
Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 kernel/exit.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux/kernel/exit.c
===================================================================
--- linux.orig/kernel/exit.c
+++ linux/kernel/exit.c
@@ -900,6 +900,15 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. Amongst other possible reasons, this is to prevent
+	 * mm_release()->clear_child_tid() from writing to a user-controlled
+	 * kernel address.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	validate_creds_for_do_exit(tsk);
