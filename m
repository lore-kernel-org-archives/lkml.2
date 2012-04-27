Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab2D0GWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:22:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:51603 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614Ab2D0GWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:22:23 -0400
Date: Fri, 27 Apr 2012 10:22:18 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: build warning after merge of the akpm tree
Message-ID: <20120427062218.GA1899@moon>
References: <20120427154420.1161da65e7bcc2322857e6b2@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427154420.1161da65e7bcc2322857e6b2@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 03:44:20PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm tree, today's linux-next build ()
> produced this warning:
> 
> kernel/sys.c: In function 'prctl_set_mm':
> kernel/sys.c:1779:6: warning: 'error' may be used uninitialized in this function [-Wuninitialized]
> 
> And this is not a false positive (I think).
> 
> Introduced by commit 5455a20be1a6 ("c/r: prctl: extend PR_SET_MM to set
> up more mm_struct entries").

Hi Stephen, thanks for report, have no idea how it happened, since
commit 5455a20be1a6 _has_ error = -EINVAL; line.
Anyway, here is a fix.

	Cyrill
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH -mm] c/r: prctl: Add error initialization

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Kees Cook <keescook@chromium.org>
---
 kernel/sys.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1790,6 +1790,8 @@ static int prctl_set_mm(int opt, unsigne
 	if (addr >= TASK_SIZE)
 		return -EINVAL;
 
+	error = -EINVAL;
+
 	down_read(&mm->mmap_sem);
 	vma = find_vma(mm, addr);
 
