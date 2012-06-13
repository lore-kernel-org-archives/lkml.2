Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2FMSwQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:52:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754678Ab2FMSwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:52:15 -0400
Date: Wed, 13 Jun 2012 20:50:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] uprobes: copy_insn() should not return -ENOMEM if
	__copy_insn() fails
Message-ID: <20120613185013.GB13878@redhat.com>
References: <20120613184933.GA13870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613184933.GA13870@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_insn() returns -ENOMEM if the first __copy_insn() fails,
it should return the correct error code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index bb61248..9bb5571 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -639,10 +639,10 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
 
 	/* Instruction at the page-boundary; copy bytes in second page */
 	if (nbytes < bytes) {
-		if (__copy_insn(mapping, filp, uprobe->arch.insn + nbytes,
-				bytes - nbytes, uprobe->offset + nbytes))
-			return -ENOMEM;
-
+		int err = __copy_insn(mapping, filp, uprobe->arch.insn + nbytes,
+				bytes - nbytes, uprobe->offset + nbytes);
+		if (err)
+			return err;
 		bytes = nbytes;
 	}
 	return __copy_insn(mapping, filp, uprobe->arch.insn, bytes, uprobe->offset);
-- 
1.5.5.1


