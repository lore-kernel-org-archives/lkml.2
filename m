Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269Ab1ABHbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:31:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:37142 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab1ABHZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:25:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 215/260] setup_arg_pages: diagnose excessive argument size
Date: Sun,  2 Jan 2011 02:18:31 -0500
Message-Id: <1293952756-15010-216-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:24:04.0870 (UTC) FILETIME=[09330260:01CBAA4E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland McGrath <roland@redhat.com>

commit 1b528181b2ffa14721fb28ad1bd539fe1732c583 upstream.

The CONFIG_STACK_GROWSDOWN variant of setup_arg_pages() does not
check the size of the argument/environment area on the stack.
When it is unworkably large, shift_arg_pages() hits its BUG_ON.
This is exploitable with a very large RLIMIT_STACK limit, to
create a crash pretty easily.

Check that the initial stack is not too large to make it possible
to map in any executable.  We're not checking that the actual
executable (or intepreter, for binfmt_elf) will fit.  So those
mappings might clobber part of the initial stack mapping.  But
that is just userland lossage that userland made happen, not a
kernel problem.

Signed-off-by: Roland McGrath <roland@redhat.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/exec.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index e6e94c6..b884fde 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -593,6 +593,11 @@ int setup_arg_pages(struct linux_binprm *bprm,
 #else
 	stack_top = arch_align_stack(stack_top);
 	stack_top = PAGE_ALIGN(stack_top);
+
+	if (unlikely(stack_top < mmap_min_addr) ||
+	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr))
+		return -ENOMEM;
+
 	stack_shift = vma->vm_end - stack_top;
 
 	bprm->p -= stack_shift;
-- 
1.7.3.3

