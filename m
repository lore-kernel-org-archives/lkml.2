Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab2E2T3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 15:29:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1027 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab2E2T3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 15:29:39 -0400
Date: Tue, 29 May 2012 21:27:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] uprobes: change read_opcode() to use FOLL_FORCE
Message-ID: <20120529192759.GB8057@redhat.com>
References: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529192721.GA8048@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_orig_insn()->read_opcode() should not fail if the probed task
did mprotect() after uprobe_register(), change it to use FOLL_FORCE.
Without FOLL_WRITE this doesn't have any "side" effect but allows
to read the !VM_READ memory.

There is another reason for this change, we are going to use
is_swbp_at_addr() from handle_swbp() which can race with another
thread doing mprotect().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
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
 
-- 
1.5.5.1


