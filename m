Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0FWQFQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:05:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599Ab0FWQFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:05:12 -0400
Date: Wed, 23 Jun 2010 18:02:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Edward Allcutt <edward@allcutt.me.uk>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
Message-ID: <20100623160221.GA9923@redhat.com>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk> <20100623155733.GA8874@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100623155733.GA8874@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23, Oleg Nesterov wrote:
>
> On 06/21, Edward Allcutt wrote:
> >
> > The ability to limit concurrent coredumps allows dumping core to be safely
> > enabled in these situations without affecting responsiveness of the system
> > as a whole.
>
> OK, but please note that the patch is not right,

OOPS, sorry, I was not exactly right too.

> > @@ -1844,6 +1845,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  	int retval = 0;
> >  	int flag = 0;
> >  	int ispipe;
> > +	int dump_count = 0;
> >  	static atomic_t core_dump_count = ATOMIC_INIT(0);
> >  	struct coredump_params cprm = {
> >  		.signr = signr,
> > @@ -1865,6 +1867,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
> >  	if (!__get_dumpable(cprm.mm_flags))
> >  		goto fail;
> >
> > +	dump_count = atomic_inc_return(&core_dump_count);
> > +	if (core_max_concurrency && (core_max_concurrency < dump_count)) {
> > +		printk(KERN_WARNING "Pid %d(%s) over core_max_concurrency\n",
> > +		       task_tgid_vnr(current), current->comm);
> > +		printk(KERN_WARNING "Skipping core dump\n");
> > +		goto fail;
> > +	}
> > +
>
> We can't return here. We should kill other threads which share the same
> ->mm in any case.
>
> Suppose that core_dump_count > core_max_concurrency, and we send, say,
> SIGQUIT to the process. With this patch SIGQUIT suddenly starts to kill
> the single thread, this must not happen.

well, the caller does do_group_exit() after do_coredump(), this kills
sub-threads.

However, this doesn't kill other CLONE_VM tasks. Perhaps this is fine,
but I am not sure.

> If you change the patch to sleep until core_dump_count < core_max_concurrency,
> then, again, we should kill other threads first.

Yes, this is true. If we are going to sleep, we shouldn't allow other
threads to run.

Oleg.

