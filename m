Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab2FFPKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 11:10:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39754 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2FFPKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 11:10:18 -0400
Date: Wed, 6 Jun 2012 08:09:11 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-2c357a15491100e94de8e6105e6046ee3a71e05a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, ananth@in.ibm.com,
        anton@redhat.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, oleg@redhat.com, tglx@linutronix.de
In-Reply-To: <20120529192759.GB8057@redhat.com>
References: <20120529192759.GB8057@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Change read_opcode() to use FOLL_FORCE
Git-Commit-ID: 2c357a15491100e94de8e6105e6046ee3a71e05a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 08:09:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2c357a15491100e94de8e6105e6046ee3a71e05a
Gitweb:     http://git.kernel.org/tip/2c357a15491100e94de8e6105e6046ee3a71e05a
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Tue, 29 May 2012 21:27:59 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 6 Jun 2012 11:30:55 +0200

uprobes: Change read_opcode() to use FOLL_FORCE

set_orig_insn()->read_opcode() should not fail if the probed
task did mprotect() after uprobe_register(), change it to use
FOLL_FORCE. Without FOLL_WRITE this doesn't have any "side"
effect but allows to read the !VM_READ memory.

There is another reason for this change, we are going to use
is_swbp_at_addr() from handle_swbp() which can race with another
thread doing mprotect().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120529192759.GB8057@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index d0f5ec0..a0dbc87 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -312,7 +312,7 @@ static int read_opcode(struct mm_struct *mm, unsigned long vaddr, uprobe_opcode_
 	void *vaddr_new;
 	int ret;
 
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &page, NULL);
+	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &page, NULL);
 	if (ret <= 0)
 		return ret;
 
