Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298Ab0K3XdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 18:33:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751718Ab0K3XdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 18:33:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: michal.simek@petalogix.com
X-Fcc: ~/Mail/linus
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        John Williams <john.williams@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Re: Flushing whole page instead of work for ptrace
In-Reply-To: Michal Simek's message of  Friday, 26 November 2010 13:31:42 +0100 <4CEFA8AE.2090804@petalogix.com>
References: <4CEFA8AE.2090804@petalogix.com>
X-Windows: a terminal disease.
Message-Id: <20101130233250.35603401C8@magilla.sf.frob.com>
Date: Tue, 30 Nov 2010 15:32:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a VM question more than a ptrace question.  
I can't give you any authoritative answers about the VM issues.

Documentation/cachetlb.txt says:

	Any time the kernel writes to a page cache page, _OR_
	the kernel is about to read from a page cache page and
	user space shared/writable mappings of this page potentially
	exist, this routine is called.

In your case, the kernel is only reading (write=0 passed to
access_process_vm and get_user_pages).  In normal situations,
the page in question will have only a private and read-only
mapping in user space.  So the call should not be required in
these cases--if the code can tell that's so.

Perhaps something like the following would be safe.
But you really need some VM folks to tell you for sure.

diff --git a/mm/memory.c b/mm/memory.c
index 02e48aa..2864ee7 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1484,7 +1484,8 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
 				pages[i] = page;
 
 				flush_anon_page(vma, page, start);
-				flush_dcache_page(page);
+				if ((vm_flags & VM_WRITE) || (vma->vm_flags & VM_SHARED)
+					flush_dcache_page(page);
 			}
 			if (vmas)
 				vmas[i] = vma;


Thanks,
Roland
