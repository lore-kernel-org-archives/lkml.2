Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740Ab1FYOQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 10:16:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44959 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab1FYOP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 10:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UszC7T36gRyv3uDB5GOt2+v9zJfg5fVDr5XkAo2HeUVVGrbTNoh2SBp0ooJXkxF1FL
         VCh17EEbK+Sg0RnD1ua4xftlSkGCmJi8x7sxHHK7lukWDkWgmCv5ibnZf+C2si7YRCEg
         tzGO8+JPcxq4Coq05htTrYuGpwMwUFufNYDwo=
Date: Sat, 25 Jun 2011 16:15:53 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hch@infradead.org
Subject: Re: [PATCH 2/8] kill tracehook_notify_death()
Message-ID: <20110625141553.GX30101@htj.dyndns.org>
References: <1308322240-8247-1-git-send-email-tj@kernel.org>
 <1308322240-8247-7-git-send-email-tj@kernel.org>
 <20110622210757.GA20549@redhat.com>
 <20110622210834.GC20549@redhat.com>
 <20110623122253.GM30101@htj.dyndns.org>
 <20110623132126.GA10410@redhat.com>
 <20110623132754.GO30101@htj.dyndns.org>
 <20110623132831.GA11453@redhat.com>
 <20110623170650.GA14601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623170650.GA14601@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jun 23, 2011 at 07:06:50PM +0200, Oleg Nesterov wrote:
> [PATCH v2 2/8] kill tracehook_notify_death()
> 
> Kill tracehook_notify_death(), reimplement the logic in its caller,
> exit_notify().
> 
> Also, change the exec_id's check to use thread_group_leader() instead
> of task_detached(), this is more clear. This logic only applies to
> the exiting leader, a sub-thread must never change its exit_signal.
> 
> Note: when the traced group leader exits the exit_signal-or-SIGCHLD
> logic looks really strange:
> 
> 	- we notify the tracer even if !thread_group_empty() but
> 	   do_wait(WEXITED) can't work until all threads exit

Yeap, we've discussed this before and this indeed is odd.  However, is
there something ptracer can't do with PTRACE_EVENT_EXIT instead?  If
PTRACE_EVENT_EXIT can be used instead for most practical purposes, I
think we're better off just documenting the fact and advise use of
PTRACE_EVENT_EXIT rather than trying to change the behavior.

> 	- if the tracer is real_parent, it is not clear why can't
> 	  we use ->exit_signal event if !thread_group_empty()

I've been thinking a bit more about this and it doesn't seem that
changing this is necessarily a good idea.  The current behavior does
make certain sense (overridden exit_signal is used only for the real
parent when the process is being reaped) and doesn't cause any actual
problem, so I don't think we need to change this behavior.

> +	if (unlikely(tsk->ptrace)) {
> +		int sig = thread_group_leader(tsk) &&
> +				thread_group_empty(tsk) &&
> +				!ptrace_reparented(tsk) ?
> +			tsk->exit_signal : SIGCHLD;

Heh, I think this needs to be prettier even at the cost of an inline
function.

Thanks.

-- 
tejun
