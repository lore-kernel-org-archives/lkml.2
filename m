Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab2DMSVC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 14:21:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59513 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab2DMSVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 14:21:00 -0400
Date: Fri, 13 Apr 2012 13:20:51 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Lezcano <daniel.lezcano@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] pidns: reboot_pid_ns: use SEND_SIG_FORCED instead of
 force_sig()
Message-ID: <20120413182051.GA11149@sergelap>
References: <20120413004446.GA8376@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120413004446.GA8376@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> cf3f8921 "pidns: add reboot_pid_ns() to handle the reboot syscall"
> uses force_sig() to kill the SIGNAL_UNKILLABLE cinit, this was the
> only choice.
> 
> After 629d362b we can use SEND_SIG_FORCED instead, force_sig() has
> the special semantics and should be avoided if possible.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Hi Oleg,

I like the patch in theory, however after applying it containers are
no longer able to shutdown/reboot.  I can externally kill them with
lxc-stop, but internal shutdown fails.

> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 57bc1fd..ef35e20 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -241,7 +241,7 @@ int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
>  	}
>  
>  	read_lock(&tasklist_lock);
> -	force_sig(SIGKILL, pid_ns->child_reaper);
> +	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, pid_ns->child_reaper, true);
>  	read_unlock(&tasklist_lock);
>  
>  	do_exit(0);
> 
