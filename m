Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab0LUG0j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 01:26:39 -0500
Received: from smtp-out.google.com ([74.125.121.67]:41154 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956Ab0LUG0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 01:26:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VVArZUOlzqOQoZTmJF7TdGN8SxrtImPSuuFFgQ7IoFs+e1D2MIFCwVKljNVmcRUrNv
         AbzZ9OHtCXBxT8N1C2RA==
Date: Mon, 20 Dec 2010 22:26:29 -0800
From: Michel Lespinasse <walken@google.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        mm-commits@vger.kernel.org, linux-mm@kvack.org
Subject: Re: mmotm 2010-12-16 - breaks mlockall() call
Message-ID: <20101221062629.GA17066@google.com>
References: <201012162329.oBGNTdPY006808@imap1.linux-foundation.org>
 <131961.1292667059@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131961.1292667059@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 05:10:59AM -0500, Valdis.Kletnieks@vt.edu wrote:
> On Thu, 16 Dec 2010 14:56:39 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-12-16-14-56 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> The patch mlock-only-hold-mmap_sem-in-shared-mode-when-faulting-in-pages.patch
> causes this chunk of code from cryptsetup-luks to fail during the initramfs:
> 
> 	if (mlockall(MCL_CURRENT | MCL_FUTURE)) {
>                         log_err(ctx, _("WARNING!!! Possibly insecure memory. Are you root?\n"));
>                         _memlock_count--;
>                         return 0;
>                 }
> 
> Bisection fingered this patch, which was added after -rc4-mmotm1202, which
> boots without tripping this log_err() call.  I haven't tried building a
> -rc6-mmotm1216 with this patch reverted, because reverting it causes apply
> errors for subsequent patches.
> 
> Ideas?

So I traced this down using valdis's initramfs image. This is actually
an interesting corner case:

Some VMA has the VM_MAY_(READ/WRITE/EXEC) flags, but is currently protected
with PROT_NONE permissions (VM_READ/WRITE_EXEC flags are all cleared).

When mlockall() is called, the old code would see mlock_fixup() return
an error for that VMA, which would be ignored by do_mlockall(). The new
code did not ignore errors from do_mlock_pages(), which broke backwards
compatibility.

So the trivial fix to make mlockall behave identically as before could be
as follows:

Signed-off-by: Michel Lespinasse <walken@google.com>

diff --git a/mm/mlock.c b/mm/mlock.c
index db0ed84..168b750 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -424,7 +424,7 @@ static int do_mlock(unsigned long start, size_t len, int on)
 	return error;
 }
 
-static int do_mlock_pages(unsigned long start, size_t len)
+static int do_mlock_pages(unsigned long start, size_t len, int ignore_errors)
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long end, nstart, nend;
@@ -465,6 +465,10 @@ static int do_mlock_pages(unsigned long start, size_t len)
 		 */
 		ret = __mlock_vma_pages_range(vma, nstart, nend, &locked);
 		if (ret < 0) {
+			if (ignore_errors) {
+				ret = 0;
+				continue;	/* continue at next VMA */
+			}
 			ret = __mlock_posix_error_return(ret);
 			break;
 		}
@@ -502,7 +506,7 @@ SYSCALL_DEFINE2(mlock, unsigned long, start, size_t, len)
 		error = do_mlock(start, len, 1);
 	up_write(&current->mm->mmap_sem);
 	if (!error)
-		error = do_mlock_pages(start, len);
+		error = do_mlock_pages(start, len, 0);
 	return error;
 }
 
@@ -567,8 +571,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	    capable(CAP_IPC_LOCK))
 		ret = do_mlockall(flags);
 	up_write(&current->mm->mmap_sem);
-	if (!ret && (flags & MCL_CURRENT))
-		ret = do_mlock_pages(0, TASK_SIZE);
+	if (!ret && (flags & MCL_CURRENT)) {
+		/* Ignore errors */
+		do_mlock_pages(0, TASK_SIZE, 1);
+	}
 out:
 	return ret;
 }

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
