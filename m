Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab1HRSwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 14:52:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3094 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268Ab1HRSwa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 14:52:30 -0400
Date: Thu, 18 Aug 2011 20:48:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
	.patch added to -mm tree
Message-ID: <20110818184857.GA12094@redhat.com>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org> <20110817115543.GA8745@redhat.com> <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com> <20110817134516.GA14136@redhat.com> <20110818124353.GA2839@tango.0pointer.de> <20110818142508.GA30959@redhat.com> <1313691091.1107.9.camel@mop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313691091.1107.9.camel@mop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kay,

I need to go away, I'll read this patch (and the whole email) tomorrow.

Just a quick note right now,

On 08/18, Kay Sievers wrote:
>
>  static struct task_struct *find_new_reaper(struct task_struct *father)
>  	__releases(&tasklist_lock)
> @@ -724,6 +725,19 @@ static struct task_struct *find_new_reap
>  		 * forget_original_parent() must move them somewhere.
>  		 */
>  		pid_ns->child_reaper = init_pid_ns.child_reaper;
> +	} else {
> +		/* find the first ancestor which is marked as child_reaper */
> +		for (thread = father->real_parent;
> +		     thread != thread->real_parent;
> +		     thread = thread->real_parent) {
> +			if (thread == pid_ns->child_reaper)
> +				break;
> +			if (!thread->signal->child_reaper)
> +				continue;
> +			if (thread->flags & PF_EXITING)
> +				continue;
> +			return thread;

No, this doesn't look right.

This code should do something like

		for (reaper = father->real_parent;
		     !same_thread_group(reaper, pid_ns->child_reaper);
		     reaper = reaper->real_parent) {
			if (!signal->child_reaper)
				continue;

			if (there is a !PF_EXITING thread)
				return thread;
		}

And I forgot to mention, could you please-please rename child_reaper?
Say, is_child_reaper or is_sub_reaper. Or whatever. I do not really
care about the naming. But I use grep very often, and personally I
dislike the task->child_reaper/signal->child_reaper confusion.

Oleg.

