Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab1FZUHj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:07:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab1FZUGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:06:37 -0400
Date: Sun, 26 Jun 2011 22:04:42 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ptrace: make former thread ID available via
	PTRACE_GETEVENTMSG after PTRACE_EVENT_EXEC stop (v.2)
Message-ID: <20110626200442.GA16293@redhat.com>
References: <201106262108.43011.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106262108.43011.vda.linux@googlemail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Denys Vlasenko wrote:
>
> @@ -1366,13 +1366,22 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  	for (try=0; try<2; try++) {
>  		read_lock(&binfmt_lock);
>  		list_for_each_entry(fmt, &formats, lh) {
> -			int (*fn)(struct linux_binprm *, struct pt_regs *) = fmt->load_binary;
> -			if (!fn)
> +			int (*load_binary)(struct linux_binprm *, struct pt_regs *);
> +			pid_t old_pid = old_pid; /* for compiler */

we have uninitialized_var() for this,

	pid_t uninitialized_var(old_pid);

> +
> +			load_binary = fmt->load_binary;
> +			if (!load_binary)
>  				continue;
>  			if (!try_module_get(fmt->module))
>  				continue;
>  			read_unlock(&binfmt_lock);
> -			retval = fn(bprm, regs);
> +			if (task_ptrace(current) & PT_PTRACED) {

May be PT_TRACE_EXEC makes more sense. Note that ptrace_event_enabled() was
recently added.

> +				/* Need to fetch pid before load_binary changes it */
> +				rcu_read_lock();
> +				old_pid = task_pid_nr_ns(current, task_active_pid_ns(current->parent));

OK, this looks correct. But imho this code looks strange inside the
for (;;) loop. Perhaps it would be more clean to record the old pid
before.

Also, this line is too long. Personally I do not care, but I told you
we have the coding style police. Please use ./scripts/checkpatch.pl

> @@ -1381,7 +1390,7 @@ int search_binary_handler(struct linux_binprm *bprm,struct pt_regs *regs)
>  			bprm->recursion_depth = depth;
>  			if (retval >= 0) {
>  				if (depth == 0)
> -					tracehook_report_exec(fmt, bprm, regs);
> +					tracehook_report_exec(fmt, bprm, regs, old_pid);

Heh, you are out of luck ;) This hook was already killed. Please redo
against git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace


Also, please update the changelog. It should clearly explain why do we
need this feature and what this patch does. The output from a test
program doesn't make too much sense unless you show the source code.

Oleg.

