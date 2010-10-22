Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab0JVSln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:41:43 -0400
Received: from kroah.org ([198.145.64.141]:46011 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758911Ab0JVSll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:41 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:33 2010
Message-Id: <20101022184033.836726646@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Roland McGrath <roland@redhat.com>, Chuck Ebbert <cebbert@redhat.com>
Subject: [15/17] setup_arg_pages: diagnose excessive argument size
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Roland McGrath <roland@redhat.com>

commit 1b528181b2ffa14721fb28ad1bd539fe1732c583 upstream.

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
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/exec.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -608,6 +608,11 @@ int setup_arg_pages(struct linux_binprm
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


