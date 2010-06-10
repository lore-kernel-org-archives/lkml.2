Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756780Ab0FJBB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 21:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab0FJBB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 21:01:58 -0400
Date: Thu, 10 Jun 2010 02:59:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>
Cc: "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: [PATCH 0/1] signals: introduce send_sigkill() helper
Message-ID: <20100610005937.GA4727@redhat.com>
References: <20100608204621.767A.A69D9226@jp.fujitsu.com> <20100608210000.7692.A69D9226@jp.fujitsu.com> <20100608184144.GA5914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100608184144.GA5914@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/08, Oleg Nesterov wrote:
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
>
> Oh. This reminds me, we really need the trivial (but annoying) cleanups
> here. The usage of SEND_SIG_ constants is messy, and they should be
> renamed at least.
>
> And in fact, we need the new one which acts like SEND_SIG_FORCED but
> si_fromuser(). We do not want to allocate the memory when the caller
> is oom_kill or zap_pid_ns_processes().

I tried to make some simple cleanups right now, but this really needs
time and discussion.

So. If we are going to remove force_sig() in mm/oom_kill.c (and I think
we should), I'd like to add the trivial helper first.

Oleg.

