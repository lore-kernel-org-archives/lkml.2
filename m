Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1FFXNE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 19:13:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51124 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751085Ab1FFXNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 19:13:02 -0400
Date: Mon, 6 Jun 2011 16:12:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathias Krause <minipli@googlemail.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
Message-Id: <20110606161254.5f02d855.akpm@linux-foundation.org>
In-Reply-To: <1306772228-1603-1-git-send-email-minipli@googlemail.com>
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 May 2011 18:17:08 +0200
Mathias Krause <minipli@googlemail.com> wrote:

> We use kernel_execve() to transfer control of the init procces from
> kernel to userland. If the program to start as init process isn't given
> on the kernel command line or fails to start we use a few hardcoded
> fallbacks. This fallback mechanism does not work when we encounter a
> file that is executable but fails to start, e.g. due to a missing
> library dependency or by having an unsupported file format.
> 
> The bug is, that search_binary_handler() sets the address limit to
> USER_DS but doesn't reset it on error which will make all further
> attempts fail with -EFAULT because argv[0] is a pointer to kernel
> memory, not userland.
> 
> The bug can easily be reproduced by starting a 32 bit kernel with a 64
> bit executable as /init and a 32 bit version as /sbin/init within an
> initramfs. The hardcoded defaults should make /init fail because of the
> unsupported file format but should make /sbin/init succeed. This doesn't
> happen because the string "/sbin/init" lives in kernel memory and is no
> longer allowed because of the modified address limit to USER_DS after
> the failed execution attempt of /init.
> 
> Fixing the only user of kernel_execve that needs this tweaking was far
> more easy than changing the implementation for all architectures. This
> also makes backporting far more easy as this bug is in there from the
> very beginning -- at least it's in v2.6.12, too.
> 
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> CC: stable@kernel.org
> ---
>  init/main.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/init/main.c b/init/main.c
> index cafba67..4ee893a 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -731,6 +731,9 @@ static void __init do_pre_smp_initcalls(void)
>  
>  static void run_init_process(const char *init_filename)
>  {
> +	/* Ensure we can access in-kernel filenames -- previous exec attempts
> +	 * might have set the address limit to USER_DS */
> +	set_fs(KERNEL_DS);
>  	argv_init[0] = init_filename;
>  	kernel_execve(init_filename, argv_init, envp_init);
>  }

Geeze, you're kicking over some ancient rocks there.

Possibly the bug was added by

commit 473ae30bc7b1dda5c5791c773f95e9424ddfead9
Author:     Al Viro <viro@zeniv.linux.org.uk>
AuthorDate: Wed Apr 26 14:04:08 2006 -0400
Commit:     Al Viro <viro@zeniv.linux.org.uk>
CommitDate: Tue Jun 20 05:25:21 2006 -0400

    [PATCH] execve argument logging


and will be fixed with

--- a/fs/exec.c~a
+++ a/fs/exec.c
@@ -1357,14 +1357,14 @@ int search_binary_handler(struct linux_b
 	if (retval)
 		return retval;
 
-	/* kernel module loader fixup */
-	/* so we don't try to load run modprobe in kernel space. */
-	set_fs(USER_DS);
-
 	retval = audit_bprm(bprm);
 	if (retval)
 		return retval;
 
+	/* kernel module loader fixup */
+	/* so we don't try to load run modprobe in kernel space. */
+	set_fs(USER_DS);
+
 	retval = -ENOENT;
 	for (try=0; try<2; try++) {
 		read_lock(&binfmt_lock);
_

but I'm finding lots of mysterious things in there.

Like, what does this comment:

	/* so we don't try to load run modprobe in kernel space. */
	set_fs(USER_DS);

mean?

It's all truly ancient code and I suspect the set_fs() simply isn't
needed any more - the calling process doesn't parent modprobe.  And
request_module() should take care of the mm_segment, not its callers.



Also, search_binary_handler() appears to *always* return with USER_DS? 
Is that a secret part of its interface?  Or should it be
unconditionally restoring KERNEL_DS?


I tried to work out how that set_fs() got there, in the historical git
tree but it's part of 14592fa9:

	73 files changed, 963 insertions(+), 798 deletions(-)
	
which is pretty useless (what's up with that?)


So I dunno, I'm stumped.  I'm suspecting that the right fix here is to
just remove that call to set_fs(USER_DS) but I'm having trouble working
out what all this cruft is trying to do.
