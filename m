Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932148Ab2HUQiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 12:38:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33100 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab2HUQiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 12:38:02 -0400
Date: Tue, 21 Aug 2012 09:37:44 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-c7a3a88c938fbe3d70c2278e082b80eb830d1c58@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, wcohen@redhat.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, wcohen@redhat.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120819171042.GB26957@redhat.com>
References: <20120819171042.GB26957@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] uprobes: Fix mmap_region()'s mm->
 mm_rb corruption if uprobe_mmap() fails
Git-Commit-ID: c7a3a88c938fbe3d70c2278e082b80eb830d1c58
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 09:37:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7a3a88c938fbe3d70c2278e082b80eb830d1c58
Gitweb:     http://git.kernel.org/tip/c7a3a88c938fbe3d70c2278e082b80eb830d1c58
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Sun, 19 Aug 2012 19:10:42 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 21 Aug 2012 11:48:12 +0200

uprobes: Fix mmap_region()'s mm->mm_rb corruption if uprobe_mmap() fails

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
Cc: <stable@vger.kernel.org> # v3.5
Cc: Anton Arapov <anton@redhat.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20120819171042.GB26957@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/fork.c |    4 ++--
 mm/mmap.c     |    5 ++---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3bd2280..2c8857e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -455,8 +455,8 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (retval)
 			goto out;
 
-		if (file && uprobe_mmap(tmp))
-			goto out;
+		if (file)
+			uprobe_mmap(tmp);
 	}
 	/* a new mm has just been created */
 	arch_dup_mmap(oldmm, mm);
diff --git a/mm/mmap.c b/mm/mmap.c
index e3e8691..52e08fc 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1356,9 +1356,8 @@ out:
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 
-	if (file && uprobe_mmap(vma))
-		/* matching probes but cannot insert */
-		goto unmap_and_free_vma;
+	if (file)
+		uprobe_mmap(vma);
 
 	return addr;
 
