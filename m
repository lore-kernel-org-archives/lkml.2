Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2IPRux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 13:50:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2IPRuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 13:50:51 -0400
Date: Sun, 16 Sep 2012 19:52:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] uprobes: Change write_opcode() to use FOLL_FORCE
Message-ID: <20120916175242.GA32363@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120916175210.GA32337@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_opcode()->get_user_pages() needs FOLL_FORCE to ensure we can
read the page even if the probed task did mprotect(PROT_NONE) after
uprobe_register(). Without FOLL_WRITE, FOLL_FORCE doesn't have any
side effect but allows to read the !VM_READ memory.

Otherwiese the subsequent uprobe_unregister()->set_orig_insn() fails
and we leak "int3". If that task does mprotect(PROT_READ | EXEC) and
execute the probed insn later it will be killed.

Note: in fact this is also needed for _register, see the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 14c2e99..fa1579a 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -221,7 +221,7 @@ static int write_opcode(struct arch_uprobe *auprobe, struct mm_struct *mm,
 
 retry:
 	/* Read the page with vaddr into memory */
-	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 0, &old_page, &vma);
+	ret = get_user_pages(NULL, mm, vaddr, 1, 0, 1, &old_page, &vma);
 	if (ret <= 0)
 		return ret;
 
-- 
1.5.5.1

