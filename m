Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab2FXPCx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 11:02:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5356 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756172Ab2FXPCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 11:02:51 -0400
Date: Sun, 24 Jun 2012 17:00:35 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] uprobes: kill write_opcode()->lock_page(new_page)
Message-ID: <20120624150035.GC23277@redhat.com>
References: <20120624145936.GA23269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120624145936.GA23269@redhat.com>
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
index 6fda799..23c562b 100644
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
-- 
1.5.5.1


