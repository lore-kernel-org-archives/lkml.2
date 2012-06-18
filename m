Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2FRI52 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 04:57:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40523 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab2FRI50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 04:57:26 -0400
Date: Mon, 18 Jun 2012 01:57:04 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-fc36f59565861af2e897225bc3782479a26c5d5a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154344.GA9601@redhat.com>
References: <20120615154344.GA9601@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Copy_insn()
  should not return -ENOMEM if __copy_insn() fails
Git-Commit-ID: fc36f59565861af2e897225bc3782479a26c5d5a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:57:10 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc36f59565861af2e897225bc3782479a26c5d5a
Gitweb:     http://git.kernel.org/tip/fc36f59565861af2e897225bc3782479a26c5d5a
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:44 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:46 +0200

uprobes: Copy_insn() should not return -ENOMEM if __copy_insn() fails

copy_insn() returns -ENOMEM if the first __copy_insn() fails,
it should return the correct error code.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120615154344.GA9601@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
