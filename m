Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933417Ab2BBX0r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 18:26:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab2BBX0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 18:26:33 -0500
Date: Thu, 2 Feb 2012 15:26:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Glauber Costa <glommer@parallels.com>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [patch cr 2/4] [RFC] syscalls, x86: Add __NR_kcmp syscall v7
Message-Id: <20120202152632.c356719a.akpm@linux-foundation.org>
In-Reply-To: <20120130141852.309402052@openvz.org>
References: <20120130140905.441199885@openvz.org>
	<20120130141852.309402052@openvz.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012 18:09:07 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> While doing the checkpoint-restore in the userspace one need to determine
> whether various kernel objects (like mm_struct-s of file_struct-s) are shared
> between tasks and restore this state.
> 
> The 2nd step can be solved by using appropriate CLONE_ flags and the unshare
> syscall, while there's currently no ways for solving the 1st one.
> 
> One of the ways for checking whether two tasks share e.g. mm_struct is to
> provide some mm_struct ID of a task to its proc file, but showing such
> info considered to be not that good for security reasons.
> 
> Thus after some debates we end up in conclusion that using that named
> 'comparision' syscall might be the best candidate. So here is it --
> __NR_kcmp.
> 
> It takes up to 5 agruments - the pids of the two tasks (which
> characteristics should be compared), the comparision type and
> (in case of comparision of files) two file descriptors.
> 
> Lookups for pids are done in the caller's PID namespace only.
> 
> At moment only x86 is supported and tested.
> 
> ...
>
> --- linux-2.6.git.orig/kernel/Makefile
> +++ linux-2.6.git/kernel/Makefile
> @@ -25,6 +25,7 @@ endif
>  obj-y += sched/
>  obj-y += power/
>  
> +obj-$(CONFIG_X86) += kcmp.o

Can we turn this into obj-$(CONFIG_CHECKPOINT_RESTART) and add the
cond_syscall to sys_ni.c?

I keep saying this, because "hey, we can delete it all again" figures
largely in my rationale for merging your code ;)

>
> ...
>
