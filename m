Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0FWQA3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 12:00:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab0FWQAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 12:00:10 -0400
Date: Wed, 23 Jun 2010 17:57:33 +0200
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
Message-ID: <20100623155733.GA8874@redhat.com>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21, Edward Allcutt wrote:
>
> The ability to limit concurrent coredumps allows dumping core to be safely
> enabled in these situations without affecting responsiveness of the system
> as a whole.

OK, but please note that the patch is not right,

> @@ -1844,6 +1845,7 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	int retval = 0;
>  	int flag = 0;
>  	int ispipe;
> +	int dump_count = 0;
>  	static atomic_t core_dump_count = ATOMIC_INIT(0);
>  	struct coredump_params cprm = {
>  		.signr = signr,
> @@ -1865,6 +1867,14 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	if (!__get_dumpable(cprm.mm_flags))
>  		goto fail;
>
> +	dump_count = atomic_inc_return(&core_dump_count);
> +	if (core_max_concurrency && (core_max_concurrency < dump_count)) {
> +		printk(KERN_WARNING "Pid %d(%s) over core_max_concurrency\n",
> +		       task_tgid_vnr(current), current->comm);
> +		printk(KERN_WARNING "Skipping core dump\n");
> +		goto fail;
> +	}
> +

We can't return here. We should kill other threads which share the same
->mm in any case.

Suppose that core_dump_count > core_max_concurrency, and we send, say,
SIGQUIT to the process. With this patch SIGQUIT suddenly starts to kill
the single thread, this must not happen.

If you change the patch to sleep until core_dump_count < core_max_concurrency,
then, again, we should kill other threads first.

Oleg.

