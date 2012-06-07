Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab2FGRCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:02:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab2FGRC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:02:28 -0400
Date: Thu, 7 Jun 2012 19:00:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] uprobes: valid_vma() should reject VM_HUGETLB
Message-ID: <20120607170002.GA31974@redhat.com>
References: <20120607165942.GA31966@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607165942.GA31966@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__replace_page() obviously can't work with the hugetlbfs mappings,
uprobe_register() will likely crash the kernel. Change valid_vma()
to check VM_HUGETLB as well.

As for PageTransHuge() no need to worry, vma->vm_file != NULL.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 6e3b181..48d53af 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -105,7 +105,8 @@ static bool valid_vma(struct vm_area_struct *vma, bool is_register)
 	if (!is_register)
 		return true;
 
-	if ((vma->vm_flags & (VM_READ|VM_WRITE|VM_EXEC|VM_SHARED)) == (VM_READ|VM_EXEC))
+	if ((vma->vm_flags & (VM_HUGETLB|VM_READ|VM_WRITE|VM_EXEC|VM_SHARED))
+				== (VM_READ|VM_EXEC))
 		return true;
 
 	return false;
-- 
1.5.5.1


