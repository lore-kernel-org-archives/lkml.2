Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab2FSTtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 15:49:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753482Ab2FSTtl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 15:49:41 -0400
Date: Tue, 19 Jun 2012 21:47:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/5] uprobes: kill write_opcode()->lock_page(new_page)
Message-ID: <20120619194727.GC30146@redhat.com>
References: <20120619194636.GA30137@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120619194636.GA30137@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write_opcode() does lock_page(new_page) for no reason. Nobody can
see this page until __replace_page() exposes it under ptl lock, and
we do nothing with this page after pte_unmap_unlock().

If nothing else, the similar code in do_wp_page() doesn't lock the
new page for page_add_new_anon_rmap/set_pte_at_notify.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 5b10705..16a3b69 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -238,9 +238,7 @@ retry:
 	if (ret)
 		goto unlock_out;
 
-	lock_page(new_page);
 	ret = __replace_page(vma, vaddr, old_page, new_page);
-	unlock_page(new_page);
 
 unlock_out:
 	unlock_page(old_page);
-- 
1.5.5.1


