Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964818Ab1DNRxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:53:43 -0400
Received: from mail.windriver.com ([147.11.1.11]:38465 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925Ab1DNRrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Nelson Elhage <nelhage@ksplice.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 090/209] do_exit(): make sure that we run with get_fs() == USER_DS
Date: Thu, 14 Apr 2011 13:42:00 -0400
Message-Id: <1302803039-9400-91-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nelson Elhage <nelhage@ksplice.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/exit.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index b0242b4..8eb207f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -911,6 +911,15 @@ NORET_TYPE void do_exit(long code)
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
-- 
1.7.4.4

