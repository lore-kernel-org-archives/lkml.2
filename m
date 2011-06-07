Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab1FGGt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 02:49:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:63423 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801Ab1FGGt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 02:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=subject:x-duff:mime-version:content-type:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to:x-mailer;
        b=SnvNt+cYWoL8q4TetD4eD/btG8oay1cXN2N4C+alRI5wT1JGslzWLnDTZlotsBlt2w
         lyTs3D0ya82eok4nj0qgcQIGGohwecvOxOThq+SmKS62AjNTjQl8Swgeg86LU9TptF+r
         VdbRlf7I3onOUx86A3htUmlTA0CxvoxBg/7OE=
Subject: Re: [PATCH] init: use KERNEL_DS when trying to start init process
X-Duff: Duff Lite, Duff Dry, Duff Dark, Lady Duff, Raspberry Duff, Duff Zero
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Mathias Krause <minipli@googlemail.com>
In-Reply-To: <20110606161254.5f02d855.akpm@linux-foundation.org>
Date: Tue, 7 Jun 2011 08:49:53 +0200
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <6C79597B-CBC0-46FB-A700-BD04FFE2C5FF@googlemail.com>
References: <1306772228-1603-1-git-send-email-minipli@googlemail.com> <20110606161254.5f02d855.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.06.2011, 01:12 Andrew Morton wrote:
> On Mon, 30 May 2011 18:17:08 +0200
> Mathias Krause <minipli@googlemail.com> wrote:
> 
>> The bug is, that search_binary_handler() sets the address limit to
>> USER_DS but doesn't reset it on error which will make all further
>> attempts fail with -EFAULT because argv[0] is a pointer to kernel
>> memory, not userland.
>> 
>> The bug can easily be reproduced by starting a 32 bit kernel with a 64
>> bit executable as /init and a 32 bit version as /sbin/init within an
>> initramfs. The hardcoded defaults should make /init fail because of the
>> unsupported file format but should make /sbin/init succeed. This doesn't
>> happen because the string "/sbin/init" lives in kernel memory and is no
>> longer allowed because of the modified address limit to USER_DS after
> 
> Geeze, you're kicking over some ancient rocks there.
> 
> Possibly the bug was added by
> 
> commit 473ae30bc7b1dda5c5791c773f95e9424ddfead9
> Author:     Al Viro <viro@zeniv.linux.org.uk>
> AuthorDate: Wed Apr 26 14:04:08 2006 -0400
> Commit:     Al Viro <viro@zeniv.linux.org.uk>
> CommitDate: Tue Jun 20 05:25:21 2006 -0400
> 
>    [PATCH] execve argument logging
> 
> 
> and will be fixed with
> 
> --- a/fs/exec.c~a
> +++ a/fs/exec.c
> @@ -1357,14 +1357,14 @@ int search_binary_handler(struct linux_b
> 	if (retval)
> 		return retval;
> 
> -	/* kernel module loader fixup */
> -	/* so we don't try to load run modprobe in kernel space. */
> -	set_fs(USER_DS);
> -
> 	retval = audit_bprm(bprm);
> 	if (retval)
> 		return retval;
> 
> +	/* kernel module loader fixup */
> +	/* so we don't try to load run modprobe in kernel space. */
> +	set_fs(USER_DS);
> +
> 	retval = -ENOENT;
> 	for (try=0; try<2; try++) {
> 		read_lock(&binfmt_lock);
> _

This fixes nothing because search_binary_handler() won't return that early in
my case but will try the binfmt list to find an appropriate handler. That for,
removing the set_fs() *might* be yet another solution to the problem but I
wasn't brave enough to do that change because I could not foresee all related
consequences -- didn't want to exchange a bug fix for a security hole.

Just changing the address limit in run_init_process() was the straight forward
fix with the least possible implications to the rest of the execve path.

> but I'm finding lots of mysterious things in there.
> 
> Like, what does this comment:
> 
> 	/* so we don't try to load run modprobe in kernel space. */
> 	set_fs(USER_DS);
> 
> mean?

I found this comment confusing, too. But since the usermode helper is started
as separate kernel thread I thought this might be a security measure to prevent
leaking kernel memory to userland?! 

> It's all truly ancient code and I suspect the set_fs() simply isn't
> needed any more - the calling process doesn't parent modprobe.  And
> request_module() should take care of the mm_segment, not its callers.
> 
> Also, search_binary_handler() appears to *always* return with USER_DS? 
> Is that a secret part of its interface?  Or should it be
> unconditionally restoring KERNEL_DS?

Wouldn't that introduce a security bug, when a userland triggered execve()
fails to execute and returns to userland? Having that process run with
KERNEL_DS afterwards isn't wanted, is it? Or is the address limit restored
by some other means?

> I tried to work out how that set_fs() got there, in the historical git
> tree but it's part of 14592fa9:
> 
> 	73 files changed, 963 insertions(+), 798 deletions(-)
> 	
> which is pretty useless (what's up with that?)
> 
> 
> So I dunno, I'm stumped.  I'm suspecting that the right fix here is to
> just remove that call to set_fs(USER_DS) but I'm having trouble working
> out what all this cruft is trying to do.

Me is having trouble too, that for the simple solution with run_init_process().


Mathias