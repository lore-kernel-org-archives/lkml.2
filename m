Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2HCMOQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 08:14:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:45439 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab2HCMON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 08:14:13 -0400
Date: Fri, 3 Aug 2012 17:43:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120803121342.GD3748@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120728163157.GA22719@redhat.com>
 <20120731064730.GB5087@linux.vnet.ibm.com>
 <20120731124805.GA485@redhat.com>
 <20120802100515.GC5782@linux.vnet.ibm.com>
 <20120802135313.GA4334@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120802135313.GA4334@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12080312-7606-0000-0000-00000283FC63
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> OK, lets start with dup_mmap:
> 
> 		// retval == 0
> 
> 		if (file && uprobe_mmap(tmp))
> 			goto out;
> 
> 	out:
> 		up_write(&mm->mmap_sem);
> 		flush_tlb_mm(oldmm);
> 		up_write(&oldmm->mmap_sem);
> 		return retval;
> 
> Given that retval == 0, what do you think dup_mmap() returns if
> uprobe_mmap() fails? And note that we didn't copy all vmas.
> OK, at least this can't crash (afaics), and easy to fix.
> 
> 
> But mmap_region() is worse, much worse. It simply can _not_ fail
> after uprobe_mmap (of course, I am not saying this is unfixable)
> without the crash. And note that the crash is "delayed". And btw,
> like dup_mmap(), mmap_region() doesn't return the error too.
> 
> Srikar, I strongly believe this horror must not exist. Either
> we should teach mmap_region() and dup_mmap() (and vma_adjust!)
> to fail correctly, or we should ignore the error code.
> 
> It is that simple, isn't it?

I think you would have thought of this approach already but just wanted
to check if below is fine with you.

diff --git a/kernel/fork.c b/kernel/fork.c
index f00e319..78bfd94 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -456,10 +456,10 @@ static int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 		if (tmp->vm_ops && tmp->vm_ops->open)
 			tmp->vm_ops->open(tmp);
 
-		if (retval)
-			goto out;
+		if (!retval && file)
+			retval = uprobe_mmap(tmp);
 
-		if (file && uprobe_mmap(tmp))
+		if (retval)
 			goto out;
 	}
 	/* a new mm has just been created */
diff --git a/mm/mmap.c b/mm/mmap.c
index 4fe2697..91d36fb 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1355,9 +1355,12 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	} else if ((flags & MAP_POPULATE) && !(flags & MAP_NONBLOCK))
 		make_pages_present(addr, addr + len);
 
-	if (file && uprobe_mmap(vma))
+	if (file) {
+		error = uprobe_mmap(vma)
 		/* matching probes but cannot insert */
-		goto unmap_and_free_vma;
+		if (error)
+			goto unmap_and_free_vma;
+	}
 
 	return addr;
 
Basically, I am setting the return value of uprobe_mmap() so that
mmap_region and do_fork() fail.  This still needs the fix in
uprobe_mmap() to ignore unsupported instructions.

I am completely _okay_ with not setting the return values as proposed by you. 
Just that setting return values and the fix in uprobe_mmap() might help
in minor issues

- We either probe all probes where possible or intimate to the user that
  the requested operation wasnt successful.

- If valid probes follow a probe with invalid instruction, we still
  allow valid probes.

- If get_user_pages()/set_swbp() fail because of genuine reasons like
  ENOMEM, then we dont retry to place probes on the subsequent vmas.

-- 
thanks and regards
Srikar

