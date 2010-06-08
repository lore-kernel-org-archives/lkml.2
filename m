Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab0FHSoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 14:44:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab0FHSoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 14:44:04 -0400
Date: Tue, 8 Jun 2010 20:41:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 08/10] oom: use send_sig() instead force_sig()
Message-ID: <20100608184144.GA5914@redhat.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608210000.7692.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608210000.7692.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, KOSAKI Motohiro wrote:
>
> Oleg pointed out oom_kill.c has force_sig() abuse. force_sig() mean
> ignore signal mask. but SIGKILL itself is not maskable.

Yes. And we have other reasons to avoid force_sig(). It should be used
only for synchronous signals.

But,

> @@ -399,7 +399,7 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem)
>  	p->rt.time_slice = HZ;
>  	set_tsk_thread_flag(p, TIF_MEMDIE);
>
> -	force_sig(SIGKILL, p);
> +	send_sig(SIGKILL, p, 1);

This is not right, we need send_sig(SIGKILL, p, 0). Better yet,
send_sig_info(SIGKILL, SEND_SIG_NOINFO). I think send_sig() should
die.

The reason is that si_fromuser() must be true, otherwise we can't kill
the SIGNAL_UNKILLABLE (sub-namespace inits) tasks.

Oh. This reminds me, we really need the trivial (but annoying) cleanups
here. The usage of SEND_SIG_ constants is messy, and they should be
renamed at least.

And in fact, we need the new one which acts like SEND_SIG_FORCED but
si_fromuser(). We do not want to allocate the memory when the caller
is oom_kill or zap_pid_ns_processes().

OK. I'll send the simple patch which adds the new helper with the
comment. send_sigkill() or kernel_kill_task(), or do you see a
better name?

Oleg.

