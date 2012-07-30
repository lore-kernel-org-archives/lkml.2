Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539Ab2G3OLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:11:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45556 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754401Ab2G3OLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:11:40 -0400
Date: Mon, 30 Jul 2012 07:11:25 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-089ba999dc881a7549d97c55ac9e0052d061867d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, anton@redhat.com, hpa@zytor.com,
        mingo@kernel.org, srikar@linux.vnet.ibm.com, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, anton@redhat.com,
        linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120729182218.GA20315@redhat.com>
References: <20120729182218.GA20315@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Kill write_opcode()->lock_page(new_page)
Git-Commit-ID: 089ba999dc881a7549d97c55ac9e0052d061867d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 30 Jul 2012 07:11:31 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  089ba999dc881a7549d97c55ac9e0052d061867d
Gitweb:     http://git.kernel.org/tip/089ba999dc881a7549d97c55ac9e0052d061867d
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 29 Jul 2012 20:22:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 30 Jul 2012 11:27:19 +0200

uprobes: Kill write_opcode()->lock_page(new_page)

write_opcode() does lock_page(new_page) for no reason. Nobody
can see this page until __replace_page() exposes it under ptl
lock, and we do nothing with this page after pte_unmap_unlock().

If nothing else, the similar code in do_wp_page() doesn't lock
the new page for page_add_new_anon_rmap/set_pte_at_notify.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120729182218.GA20315@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/uprobes.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6fda799..23c562b7 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -239,9 +239,7 @@ retry:
 	if (ret)
 		goto unlock_out;
 
-	lock_page(new_page);
 	ret = __replace_page(vma, vaddr, old_page, new_page);
-	unlock_page(new_page);
 
 unlock_out:
 	unlock_page(old_page);
