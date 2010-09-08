Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475Ab0IHCg4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:36:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754976Ab0IHCgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:36:54 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
X-Fcc: ~/Mail/linus
In-Reply-To: Roland McGrath's message of  Tuesday, 7 September 2010 19:34:17 -0700 <20100908023417.8B055401AF@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830100616.78971400D9@magilla.sf.frob.com>
	<20100908023417.8B055401AF@magilla.sf.frob.com>
X-Shopping-List: (1) Prosperous pincushions
   (2) Prosthetic documents
   (3) Spacious pig apparitions
   (4) Adamant hilarious paradox riots
Subject: [PATCH 1/3] setup_arg_pages: diagnose excessive argument size
Message-Id: <20100908023549.BFFA8401AF@magilla.sf.frob.com>
Date: Tue,  7 Sep 2010 19:35:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_STACK_GROWSDOWN variant of setup_arg_pages() does not
check the size of the argument/environment area on the stack.
When it is unworkably large, shift_arg_pages() hits its BUG_ON.
This is exploitable with a very large RLIMIT_STACK limit, to
create a crash pretty easily.

Check that the initial stack is not too large to make it possible
to map in any executable.  We're not checking that the actual
executable (or intepreter, for binfmt_elf) will fit.  So those
mappings might clobber part of the initial stack mapping.  But
that is just userland lossage that userland made happen, not a
kernel problem.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2d94552..1b63237 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -594,6 +594,11 @@ int setup_arg_pages(struct linux_binprm *bprm,
 #else
 	stack_top = arch_align_stack(stack_top);
 	stack_top = PAGE_ALIGN(stack_top);
+
+	if (unlikely(stack_top < mmap_min_addr) ||
+	    unlikely(vma->vm_end - vma->vm_start >= stack_top - mmap_min_addr))
+		return -ENOMEM;
+
 	stack_shift = vma->vm_end - stack_top;
 
 	bprm->p -= stack_shift;
