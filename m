Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0EaKQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 06:16:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59034 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753014Ab0EaKQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 06:16:48 -0400
Date: Mon, 31 May 2010 11:23:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
In-Reply-To: <20100531030402.GQ6056@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Past objections and rebuttals could be summarized as:

You missed a couple at least

1.We have things like SELinux so you can write rules to bound apps
  which should be able to do this, if not then we should fix the security
  policy to generally solve it

2. If it worries you that much then you can *fix* /tmp/ for good using
the work Al Viro did years ago on mountpoints. Give people their
own /tmp. End of problem.

>  - Violates POSIX.
>    - POSIX didn't consider this situation and it's not useful to follow
>      a broken specification at the cost of security.

(If you fill your computer with concrete it will also violate POSIX but
it will be more secure than your proposal. Both will of course has some
impact on applications).

>  - Might break unknown applications that use this feature.
>    - Applications that break because of the change are easy to spot and
>      fix. Applications that are vulnerable to symlink ToCToU by not having

What if they are things like binary only games - now you can neither turn
on your feature nor fix the app if you want to use it. If it was using
SELinux or similar rules you could create a single exception rule. If it
was using per user /tmp nobody would have to do anything

>  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>    - True, but applications are not perfect, and new software is written
>      all the time that makes these mistakes; blocking this flaw at the
>      kernel is a single solution to the entire class of vulnerability.

So new software is also being written all the time which has other holes.
Actually its also according to your argument being written all the time
so it'll break if you turn the feature on ?


> +The default value is "0".  To disable this protection, setting a value of "1"
> +will allow symlinks in sticky world-writable directories to be followed by
> +anyone.

Wrong way around. You don't enable non-compliance and misbehaviour by
default. For it to be any use you need a userspace adapted to run on your
odd environment, so your distro can flip the flag from Linux mode to odd.


> +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +	    parent->i_uid != inode->i_uid &&
> +	    cred->fsuid != inode->i_uid) {
> +		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> +			"following attempted in sticky-directory by "
> +			"%s (fsuid %d)\n", current->comm, cred->fsuid);

This is of minimal use - current->comm is arbitary and user controlled.
Also are we guaranteed to hold enough locks here to stop the parent uid
changing ?

You've also stopped root doing this. Given DAC override that makes no
sense and is asking to confuse stuff.

Give your users their own /tmp. No kernel mods, no misbehaviours, no
weirdomatic path walking hackery. No kernel patch needed that I can see.


Alan
