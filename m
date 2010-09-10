Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab0IJR3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 13:29:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840Ab0IJR3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 13:29:01 -0400
Date: Fri, 10 Sep 2010 19:24:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Roland McGrath <roland@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net>, Eugene Teo" 
	<eugene@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] move cred_guard_mutex from task_struct to signal_struct
Message-ID: <20100910172457.GA23393@redhat.com>
References: <20100909140219.C942.A69D9226@jp.fujitsu.com> <20100909220504.GA6273@redhat.com> <20100910101528.C958.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100910101528.C958.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10, KOSAKI Motohiro wrote:
>
> 1) moving cread_guard_mutex itself
>    - no increase execve overhead
> 	-> very good
>    - it also prevent parallel ptrace

No, it doesn't. Only PTRACE_ATTACH needs this mutex, and as Roland
pointed out it also needs write_lock(tasklist) which is worse. So
this change doesn't make any practical harm for ptrace.

> 2) move in_exec_mm to signal_struct too
>    -> very hard. oom-killer can use very few lock because it's called
>       from various place. now both ->mm and ->in_exec_mm are protected
>       task_lock() and it help to avoid messy.

Yes. But, if ->in_exec_mm is only used by oom_badness(), then I think
you can use task_lock(tsk->group_leader). oom_badness() needs tasklist
anyway, this means it can't race with de_thread() changing the leader.
But up to you.

Another very minor nit (but again, up to you). Perhaps exec_mmap()
could clear ->in_exec_mm (in task_struct or signal_struct, this doesnt
matter), it takes task_lock(current) anyway (and at this point current
is always the group leader).

> Let's move ->cred_guard_mutex from task_struct to signal_struct. It
> naturally prevent multiple-threads-inside-exec.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>


This is very minor, but perhaps you can also fix a couple of comments
which mention task->cred_guard_mutex,

	fs/exec.c:1109		the caller must hold current->cred_guard_mutex
	kernel/cred.c:328	The caller must hold current->cred_guard_mutex
	include/linux/tracehook.h:153	@task->cred_guard_mutex

Oleg.

