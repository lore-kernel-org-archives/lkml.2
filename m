Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1FTU07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 16:26:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1FTU05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 16:26:57 -0400
Date: Mon, 20 Jun 2011 22:25:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 3/7] ptrace: move SIGTRAP on exec(2) logic to
	ptrace_event()
Message-ID: <20110620202504.GB17157@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-4-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322240-8247-4-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Tejun Heo wrote:
>
> Move SIGTRAP on exec(2) logic from tracehook_report_exec() to
> ptrace_event().  This is part of changes to make ptrace_event()
> smarter and handle ptrace event related details in one place.

I am going to apply all patches except 6/7, but to be honest this
one looks a bit ugly to me.

> -static inline int ptrace_event(int event, unsigned long message)
> +static inline void ptrace_event(int event, unsigned long message)
>  {
> -	if (likely(!ptrace_event_enabled(current, event)))
> -		return false;
> -	current->ptrace_message = message;
> -	ptrace_notify((event << 8) | SIGTRAP);
> -	return true;
> +	if (unlikely(ptrace_event_enabled(current, event))) {
> +		current->ptrace_message = message;
> +		ptrace_notify((event << 8) | SIGTRAP);
> +	} else if (event == PTRACE_EVENT_EXEC && unlikely(current->ptrace)) {
> +		/* legacy EXEC report via SIGTRAP */
> +		send_sig(SIGTRAP, current, 0);
> +	}

Why does this make ptrace_event() smarter?

OK, tracehooks should die. But why should we move this special case
into ptrace_event? Say, a simple

	static inline void ptrace_exec_event(...)
	{
		if (!ptrace_event_enabled(PTRACE_EVENT_EXEC))
			send_sig(SIGTRAP, current, 0);
		else
			ptrace_event(PTRACE_EVENT_EXEC);
	}

in fs/exec.c looks a bit better to me.

Oleg.

