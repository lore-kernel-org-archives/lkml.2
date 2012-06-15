Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2FOPrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:47:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab2FOPpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:45:52 -0400
Date: Fri, 15 Jun 2012 17:43:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/15] uprobes: copy_insn() should not return -ENOMEM if
	__copy_insn() fails
Message-ID: <20120615154344.GA9601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_insn() returns -ENOMEM if the first __copy_insn() fails,
it should return the correct error code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
---
 kernel/events/uprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 08ef566..2db1d94 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -641,10 +641,10 @@ static int copy_insn(struct uprobe *uprobe, struct file *filp)
 
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

