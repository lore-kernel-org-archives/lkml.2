Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423188Ab2KNT7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:59:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932448Ab2KNT7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:59:46 -0500
Date: Wed, 14 Nov 2012 11:59:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dannyfeng@tencent.com>,
        Jeff Layton <jlayton@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] swapfile: fix name leak in swapoff
Message-Id: <20121114115945.539ab5ba.akpm@linux-foundation.org>
In-Reply-To: <1351762616-2060-1-git-send-email-xtfeng@gmail.com>
References: <1351762616-2060-1-git-send-email-xtfeng@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Nov 2012 17:36:55 +0800
Xiaotian Feng <xtfeng@gmail.com> wrote:

> there's a name leak introduced by commit 91a27b2, add the missing
> putname.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Jeff Layton <jlayton@redhat.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> ---
>  mm/swapfile.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 71cd288..459fe30 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1608,6 +1608,8 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
>  out_dput:
>  	filp_close(victim, NULL);
>  out:
> +	if (pathname && !IS_ERR(pathname))
> +		putname(pathname);
>  	return err;
>  }

This way is simpler:

--- a/mm/swapfile.c~swapfile-fix-name-leak-in-swapoff-fix
+++ a/mm/swapfile.c
@@ -1507,9 +1507,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
 	BUG_ON(!current->mm);
 
 	pathname = getname(specialfile);
-	err = PTR_ERR(pathname);
 	if (IS_ERR(pathname))
-		goto out;
+		return PTR_ERR(pathname);
 
 	victim = file_open_name(pathname, O_RDWR|O_LARGEFILE, 0);
 	err = PTR_ERR(victim);
@@ -1615,8 +1614,7 @@ SYSCALL_DEFINE1(swapoff, const char __us
 out_dput:
 	filp_close(victim, NULL);
 out:
-	if (pathname && !IS_ERR(pathname))
-		putname(pathname);
+	putname(pathname);
 	return err;
 }
 
_


It would be even simpler to do the putname() immediately after
file_open_name(), but it is nice to keep `pathname' live for the whole
function in case it gets used by later code.

