Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab2B2RVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:21:38 -0500
Received: from mail-gx0-f202.google.com ([209.85.161.202]:37816 "EHLO
	mail-gx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab2B2RVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:21:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of surovegin@google.com designates 10.236.115.136 as permitted sender) smtp.mail=surovegin@google.com; dkim=pass header.i=surovegin@google.com
MIME-Version: 1.0
From: Eugene Surovegin <surovegin@google.com>
To: linux-kernel@vger.kernel.org
Cc: Eugene Surovegin <surovegin@google.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        kexec-list <kexec@lists.infradead.org>
Subject: [PATCH] kdump: force page alignment for per-CPU crash notes.
Date: Wed, 29 Feb 2012 09:21:23 -0800
Message-Id: <1330536083-13098-1-git-send-email-surovegin@google.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per-CPU allocations are not guaranteed to be physically contiguous.
However, kdump kernel and user-space code assumes that per-CPU
memory, used for saving CPU registers on crash, is.
This can cause corrupted /proc/vmcore in some cases - the main
symptom being huge ELF note section.

Force page alignment for note_buf_t to ensure that this assumption holds.

Signed-off-by: Eugene Surovegin <surovegin@google.com>
CC: Eric Biederman <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>
CC: kexec-list <kexec@lists.infradead.org>
---
 kernel/kexec.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 7b08867..e641b5c 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1232,8 +1232,13 @@ void crash_save_cpu(struct pt_regs *regs, int cpu)
 
 static int __init crash_notes_memory_init(void)
 {
-	/* Allocate memory for saving cpu registers. */
-	crash_notes = alloc_percpu(note_buf_t);
+	/* Allocate memory for saving cpu registers.
+	 * Force page alignment to avoid crossing physical page boundary -
+	 * kexec-tools and kernel /proc/vmcore handler assume these per-CPU
+	 * chunks are physically contiguous.
+	 */
+	crash_notes = (note_buf_t __percpu *)__alloc_percpu(sizeof(note_buf_t),
+							    PAGE_SIZE);
 	if (!crash_notes) {
 		printk("Kexec: Memory allocation for saving cpu register"
 		" states failed\n");
-- 
1.7.9.1

