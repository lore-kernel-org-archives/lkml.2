Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864Ab0FMLZY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 07:25:24 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48175 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753Ab0FMLYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 07:24:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 08/10] oom: use send_sig() instead force_sig()
Cc: kosaki.motohiro@jp.fujitsu.com,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
In-Reply-To: <20100608184144.GA5914@redhat.com>
References: <20100608210000.7692.A69D9226@jp.fujitsu.com> <20100608184144.GA5914@redhat.com>
Message-Id: <20100613180912.617B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Sun, 13 Jun 2010 20:24:52 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 06/08, KOSAKI Motohiro wrote:
> >
> > Oleg pointed out oom_kill.c has force_sig() abuse. force_sig() mean
> > ignore signal mask. but SIGKILL itself is not maskable.
> 
> Yes. And we have other reasons to avoid force_sig(). It should be used
> only for synchronous signals.
> 
> But,
> 
> > @@ -399,7 +399,7 @@ static int __oom_kill_process(struct task_struct *p, struct mem_cgroup *mem)
> >  	p->rt.time_slice = HZ;
> >  	set_tsk_thread_flag(p, TIF_MEMDIE);
> >
> > -	force_sig(SIGKILL, p);
> > +	send_sig(SIGKILL, p, 1);
> 
> This is not right, we need send_sig(SIGKILL, p, 0). Better yet,
> send_sig_info(SIGKILL, SEND_SIG_NOINFO). I think send_sig() should
> die.
> 
> The reason is that si_fromuser() must be true, otherwise we can't kill
> the SIGNAL_UNKILLABLE (sub-namespace inits) tasks.

Thanks. I am not signal expert. 
To be honest, current special siginfo arguments have a bit unclear meanings
to me ;)
current definition (following) doesn't teach anything.

sched.h
=====================
/* These can be the second arg to send_sig_info/send_group_sig_info.  */
#define SEND_SIG_NOINFO ((struct siginfo *) 0)
#define SEND_SIG_PRIV   ((struct siginfo *) 1)
#define SEND_SIG_FORCED ((struct siginfo *) 2)


If anyone write exact meanings, I'm really really glad.



> Oh. This reminds me, we really need the trivial (but annoying) cleanups
> here. The usage of SEND_SIG_ constants is messy, and they should be
> renamed at least.
> 
> And in fact, we need the new one which acts like SEND_SIG_FORCED but
> si_fromuser(). We do not want to allocate the memory when the caller
> is oom_kill or zap_pid_ns_processes().
> 
> OK. I'll send the simple patch which adds the new helper with the
> comment. send_sigkill() or kernel_kill_task(), or do you see a
> better name?

Very thanks. both name are pretty good to me.



