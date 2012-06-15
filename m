Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2FOPpj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:45:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab2FOPpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:45:33 -0400
Date: Fri, 15 Jun 2012 17:43:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/15] uprobes: __copy_insn() should ensure a_ops->readpage
	!= NULL
Message-ID: <20120615154325.GA9568@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__copy_insn() blindly calls read_mapping_page(), this will crash
the kernel if ->readpage == NULL, add the necessary check. For
example, hugetlbfs_aops->readpage is NULL. Perhaps we should change
read_mapping_page() instead.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 kernel/events/uprobes.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index f0d0453..604930b 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -610,6 +610,9 @@ __copy_insn(struct address_space *mapping, struct vm_area_struct *vma, char *ins
 	if (!filp)
 		return -EINVAL;
 
+	if (!mapping->a_ops->readpage)
+		return -EIO;
+
 	idx = (unsigned long)(offset >> PAGE_CACHE_SHIFT);
 	off1 = offset &= ~PAGE_MASK;
 
-- 
1.5.5.1

