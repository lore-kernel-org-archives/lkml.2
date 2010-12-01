Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab0LAC14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 21:27:56 -0500
Received: from DMZ-MAILSEC-SCANNER-5.MIT.EDU ([18.7.68.34]:49825 "EHLO
	dmz-mailsec-scanner-5.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753622Ab0LAC1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 21:27:55 -0500
X-AuditID: 12074422-b7c3eae000000a70-88-4cf5b2aad941
From: Nelson Elhage <nelhage@ksplice.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nelson Elhage <nelhage@ksplice.com>
Subject: [PATCH v2] do_exit(): Make sure we run with get_fs() == USER_DS.
Date: Tue, 30 Nov 2010 21:27:36 -0500
Message-Id: <1291170456-22580-1-git-send-email-nelhage@ksplice.com>
X-Mailer: git-send-email 1.7.1.31.g6297e
In-Reply-To: <20101130174947.5ccc3778.akpm@linux-foundation.org>
References: <20101130174947.5ccc3778.akpm@linux-foundation.org>
X-Brightmail-Tracker: AAAAARbTrbM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user manages to trigger an oops with fs set to KERNEL_DS, fs is not
otherwise reset before do_exit(). do_exit may later (via mm_release in fork.c)
do a put_user to a user-controlled address, potentially allowing a user to
leverage an oops into a controlled write into kernel memory.

A more logical place to put this might be when we know an oops has occurred,
before we call do_exit(), but that would involve changing every architecture, in
multiple places. Let's just stick it in do_exit instead.

Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
---
 kernel/exit.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/exit.c b/kernel/exit.c
index 21aa7b3..68899b3 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -914,6 +914,14 @@ NORET_TYPE void do_exit(long code)
 	if (unlikely(!tsk->pid))
 		panic("Attempted to kill the idle task!");
 
+	/*
+	 * If do_exit is called because this processes oopsed, it's possible
+	 * that get_fs() was left as KERNEL_DS, so reset it to USER_DS before
+	 * continuing. This is relevant at least for clearing clear_child_tid in
+	 * mm_release.
+	 */
+	set_fs(USER_DS);
+
 	tracehook_report_exit(&code);
 
 	validate_creds_for_do_exit(tsk);
-- 
1.7.1.31.g6297e

