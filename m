Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932678Ab2IMATR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:19:17 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:50843 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756693Ab2ILXgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:36:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>, William Cohen <wcohen@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 105/108] uprobes: Fix mmap_region()s mm->mm_rb corruption if uprobe_mmap() fails
Date: Wed, 12 Sep 2012 16:29:43 -0700
Message-Id: <20120912232501.510809318@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

commit c7a3a88c938fbe3d70c2278e082b80eb830d1c58 upstream.

This patch fixes:

  https://bugzilla.redhat.com/show_bug.cgi?id=843640

If mmap_region()->uprobe_mmap() fails, unmap_and_free_vma path
does unmap_region() but does not remove the soon-to-be-freed vma
from rb tree. Actually there are more problems but this is how
William noticed this bug.

Perhaps we could do do_munmap() + return in this case, but in
fact it is simply wrong to abort if uprobe_mmap() fails. Until
at least we move the !UPROBE_COPY_INSN code from
install_breakpoint() to uprobe_register().

For example, uprobe_mmap()->install_breakpoint() can fail if the
probed insn is not supported (remember, uprobe_register()
succeeds if nobody mmaps inode/offset), mmap() should not fail
in this case.

dup_mmap()->uprobe_mmap() is wrong too by the same reason,
fork() can race with uprobe_register() and fail for no reason if
it wins the race and does install_breakpoint() first.

And, if nothing else, both mmap_region() and dup_mmap() return
success if uprobe_mmap() fails. Change them to ignore the error
code from uprobe_mmap().

Reported-and-tested-by: William Cohen <wcohen@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120819171042.GB26957@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/fork.c |    4 ++--
 mm/mmap.c     |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -459,8 +459,8 @@ static int dup_mmap(struct mm_struct *mm
 		if (retval)
 			goto out;
 
-		if (file && uprobe_mmap(tmp))
-			goto out;
+		if (file)
+			uprobe_mmap(tmp);
 	}
 	/* a new mm has just been created */
 	arch_dup_mmap(oldmm, mm);
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1355,9 +1355,8 @@ out:
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 
-	if (file && uprobe_mmap(vma))
-		/* matching probes but cannot insert */
-		goto unmap_and_free_vma;
+	if (file)
+		uprobe_mmap(vma);
 
 	return addr;
 


