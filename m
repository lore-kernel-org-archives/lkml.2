Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760622Ab2FGRCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:02:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab2FGRCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:02:33 -0400
Date: Thu, 7 Jun 2012 19:00:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] uprobes: __copy_insn() should ensure a_ops->readpage
	!= NULL
Message-ID: <20120607170018.GB31974@redhat.com>
References: <20120607165942.GA31966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607165942.GA31966@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__copy_insn() blindly calls read_mapping_page(), this will crash
the kernel if ->readpage == NULL, add the necessary check. For
example, hugetlbfs_aops->readpage is NULL. Perhaps we should change
read_mapping_page() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 48d53af..9c53bc2 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -616,6 +616,8 @@ __copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *ins
 
 	if (!filp)
 		return -EINVAL;
+	if (!mapping->a_ops->readpage)
+		return -EIO;
 
 	idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
 	off1 = offset &= ~PAGE_MASK;
-- 
1.5.5.1


