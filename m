Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490Ab1FGVkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 17:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab1FGVkC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 17:40:02 -0400
Date: Tue, 7 Jun 2011 22:38:50 +0100
From: "Richard W.M. Jones" <rjones@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/3 v2] ftrace: Revert 8ab2b7efd ftrace: Remove
 unnecessary disabling of
Message-ID: <20110607213850.GG28762@amd.home.annexia.org>
References: <20110607212937.662660421@goodmis.org>
 <20110607213007.577456514@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607213007.577456514@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 05:29:40PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Revert the commit that removed the disabling of interrupts around
> the initial modifying of mcount callers to nops, and update the comment.
> 
> The original comment was outdated and stated that the interrupts were
> being disabled to prevent kstop machine, which was required with the
> old ftrace daemon, but was no longer the case.
> 
> What the comment failed to mention was that interrupts needed to be
> disabled to keep interrupts from preempting the modifying of the code
> and then executing the code that was partially modified.
> 
> Revert the commit and update the comment.
> 
> Reported-by: Richard W.M. Jones <rjones@redhat.com>
> Tested-by: Richard W.M. Jones <rjones@redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/ftrace.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 204b3eb..908038f 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -3330,6 +3330,7 @@ static int ftrace_process_locs(struct module *mod,
>  {
>  	unsigned long *p;
>  	unsigned long addr;
> +	unsigned long flags;
>  
>  	mutex_lock(&ftrace_lock);
>  	p = start;
> @@ -3346,7 +3347,13 @@ static int ftrace_process_locs(struct module *mod,
>  		ftrace_record_ip(addr);
>  	}
>  
> +	/*
> +	 * Disable interrupts to prevent interrupts from executing
> +	 * code that is being modified.
> +	 */
> +	local_irq_save(flags);
>  	ftrace_update_code(mod);
> +	local_irq_restore(flags);
>  	mutex_unlock(&ftrace_lock);
>  
>  	return 0;
> -- 
> 1.7.4.4

ACK as before.

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
New in Fedora 11: Fedora Windows cross-compiler. Compile Windows
programs, test, and build Windows installers. Over 70 libraries supprt'd
http://fedoraproject.org/wiki/MinGW http://www.annexia.org/fedora_mingw
